import { Component, OnInit } from '@angular/core';

import * as XLSX from '../../lib/xlsx-js-style/xlsx.js';

import { EtlSourceMappingService } from '../services/app/etlSourceMapping.service';
import {
  CedsElementCatalog,
  CedsOptionSetValue,
  EtlSourceElementMapping,
  EtlSourceElementUpload,
  EtlSourceMappingUpload,
  EtlSourceOptionSetMapping
} from '../models/app/etlSourceMapping';

// Header aliases used to locate columns in the uploaded data dictionary. Keys are the upload DTO
// property names; values are accepted (lowercased, alphanumeric-only) column header spellings.
const COLUMN_ALIASES: { [property: string]: string[] } = {
  sourceCommonName: ['sourcecommonname', 'commonname', 'systemname'],
  sourceTechnicalName: ['sourcetechnicalname', 'technicalname', 'systemofrecord'],
  sourceDatabaseName: ['sourcedatabasename', 'databasename'],
  sourceSchemaName: ['sourceschemaname', 'schemaname'],
  sourceTableName: ['sourcetablename', 'tablename'],
  sourceColumnName: ['sourcecolumnname', 'columnname'],
  sourceElementName: ['sourceelementname', 'elementname', 'elementfieldname', 'fieldname'],
  sourceElementDefinition: ['sourceelementdefinition', 'elementdefinition', 'definition'],
  sourceDataType: ['sourcedatatype', 'datatype'],
  sourceDataLength: ['sourcedatalength', 'datalength', 'length'],
  sourceDataSteward: ['sourcedatasteward', 'datasteward'],
  selectionCriteria: ['selectioncriteria'],
  transformationRules: ['transformationrules'],
  notes: ['notes', 'comments'],
  sourceOptionSetCode: ['sourceoptionsetcode', 'optionsetcode', 'optionset', 'validvaluesoptionset', 'validvalues'],
  sourceOptionSetDescription: ['sourceoptionsetdescription', 'optionsetdescription', 'optiondescription']
};

@Component({
  selector: 'generate-etl-mapping',
  templateUrl: './etl-mapping.component.html',
  styleUrls: ['./etl-mapping.component.scss'],
  standalone: false
})
export class EtlMappingComponent implements OnInit {

  mappings: EtlSourceElementMapping[] = [];
  cedsElements: CedsElementCatalog[] = [];

  isLoading = false;
  isUploading = false;
  uploadFileName = '';
  uploadError = '';
  statusMessage = '';

  expandedElementId: number = null;
  pickerElementId: number = null;
  pickerFilter = '';
  optionSetCache: { [globalId: string]: CedsOptionSetValue[] } = {};

  constructor(private etlSourceMappingService: EtlSourceMappingService) { }

  ngOnInit() {
    this.loadMappings();
    this.loadCedsElements();
  }

  loadMappings() {
    this.isLoading = true;
    this.etlSourceMappingService.getAll().subscribe({
      next: mappings => {
        this.mappings = mappings || [];
        this.isLoading = false;
      },
      error: () => {
        this.isLoading = false;
        this.statusMessage = 'Unable to load the current mappings.';
      }
    });
  }

  loadCedsElements() {
    this.etlSourceMappingService.getCedsElements().subscribe({
      next: cedsElements => this.cedsElements = cedsElements || [],
      error: () => this.statusMessage = 'Unable to load the CEDS element catalog.'
    });
  }

  // -------------------- Upload --------------------

  onFileSelected(event: Event) {
    const input = event.target as HTMLInputElement;

    if (!input.files || input.files.length === 0) {
      return;
    }

    const file = input.files[0];
    this.uploadFileName = file.name;
    this.uploadError = '';

    const reader = new FileReader();

    reader.onload = () => {
      try {
        const workbook = XLSX.read(new Uint8Array(reader.result as ArrayBuffer), { type: 'array' });
        const sheet = workbook.Sheets[workbook.SheetNames[0]];
        const rows: any[][] = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: '' });
        const elements = this.parseDataDictionary(rows);

        if (elements.length === 0) {
          this.uploadError = 'No data dictionary elements were found. The file must contain a "Source Element Name" (or "Element Name") column.';
          return;
        }

        this.uploadElements(elements);
      } catch (e) {
        this.uploadError = 'The file could not be read. Upload a .csv or .xlsx data dictionary.';
      } finally {
        input.value = '';
      }
    };

    reader.readAsArrayBuffer(file);
  }

  private parseDataDictionary(rows: any[][]): EtlSourceElementUpload[] {
    // Locate the header row: the first row containing an element-name column
    let headerRowIndex = -1;
    let columnIndexes: { [property: string]: number } = {};

    for (let i = 0; i < Math.min(rows.length, 10); i++) {
      const candidate = this.mapColumns(rows[i]);

      if (candidate['sourceElementName'] !== undefined) {
        headerRowIndex = i;
        columnIndexes = candidate;
        break;
      }
    }

    if (headerRowIndex < 0) {
      return [];
    }

    const elements: EtlSourceElementUpload[] = [];
    const elementsByKey: { [key: string]: EtlSourceElementUpload } = {};

    for (let i = headerRowIndex + 1; i < rows.length; i++) {
      const row = rows[i];
      const value = (property: string) => {
        const index = columnIndexes[property];
        return index === undefined || row[index] === undefined || row[index] === null
          ? ''
          : String(row[index]).trim();
      };

      const elementName = value('sourceElementName');

      if (!elementName) {
        continue;
      }

      // Option set values repeat element rows (one row per value): group by element identity
      const key = [elementName, value('sourceTableName'), value('sourceColumnName')].join('||').toLowerCase();
      let element = elementsByKey[key];

      if (!element) {
        element = {
          sourceCommonName: value('sourceCommonName'),
          sourceTechnicalName: value('sourceTechnicalName'),
          sourceDatabaseName: value('sourceDatabaseName'),
          sourceSchemaName: value('sourceSchemaName'),
          sourceTableName: value('sourceTableName'),
          sourceColumnName: value('sourceColumnName'),
          sourceElementName: elementName,
          sourceElementDefinition: value('sourceElementDefinition'),
          sourceDataType: value('sourceDataType'),
          sourceDataLength: value('sourceDataLength'),
          sourceDataSteward: value('sourceDataSteward'),
          selectionCriteria: value('selectionCriteria'),
          transformationRules: value('transformationRules'),
          notes: value('notes'),
          optionSetValues: []
        };
        elementsByKey[key] = element;
        elements.push(element);
      }

      const optionCode = value('sourceOptionSetCode');
      const optionDescription = value('sourceOptionSetDescription');

      if (optionCode || optionDescription) {
        element.optionSetValues.push({
          sourceOptionSetCode: optionCode,
          sourceOptionSetDescription: optionDescription
        });
      }
    }

    return elements;
  }

  private mapColumns(headerRow: any[]): { [property: string]: number } {
    const indexes: { [property: string]: number } = {};

    if (!headerRow) {
      return indexes;
    }

    headerRow.forEach((header, index) => {
      const normalized = String(header || '').toLowerCase().replace(/[^a-z0-9]/g, '');

      if (!normalized) {
        return;
      }

      for (const property of Object.keys(COLUMN_ALIASES)) {
        if (indexes[property] === undefined && COLUMN_ALIASES[property].indexOf(normalized) >= 0) {
          indexes[property] = index;
        }
      }
    });

    return indexes;
  }

  private uploadElements(elements: EtlSourceElementUpload[]) {
    const upload: EtlSourceMappingUpload = {
      uploadFileName: this.uploadFileName,
      uploadedBy: null,
      elements: elements
    };

    this.isUploading = true;
    this.statusMessage = '';

    this.etlSourceMappingService.upload(upload).subscribe({
      next: results => {
        this.isUploading = false;
        this.statusMessage = (results || []).length + ' element(s) uploaded and automapped to CEDS.';
        this.loadMappings();
      },
      error: () => {
        this.isUploading = false;
        this.uploadError = 'The upload failed. Check the file contents and try again.';
      }
    });
  }

  // -------------------- Element review --------------------

  acceptElement(mapping: EtlSourceElementMapping) {
    this.updateElement(mapping, { mappingStatus: 'Accepted', cedsElementGlobalId: mapping.cedsElementGlobalId });
  }

  rejectElement(mapping: EtlSourceElementMapping) {
    this.updateElement(mapping, { mappingStatus: 'Rejected' });
  }

  markNotInCeds(mapping: EtlSourceElementMapping) {
    this.updateElement(mapping, { mappingStatus: 'NotInCeds' });
  }

  openPicker(mapping: EtlSourceElementMapping) {
    this.pickerElementId = this.pickerElementId === mapping.etlSourceElementMappingId
      ? null
      : mapping.etlSourceElementMappingId;
    this.pickerFilter = '';
  }

  get filteredCedsElements(): CedsElementCatalog[] {
    const filter = (this.pickerFilter || '').toLowerCase();

    if (!filter) {
      return this.cedsElements.slice(0, 50);
    }

    return this.cedsElements
      .filter(c =>
        (c.cedsElementName || '').toLowerCase().indexOf(filter) >= 0 ||
        (c.cedsElementGlobalId || '').toLowerCase().indexOf(filter) >= 0 ||
        (c.cedsElementDefinition || '').toLowerCase().indexOf(filter) >= 0)
      .slice(0, 50);
  }

  pickCedsElement(mapping: EtlSourceElementMapping, cedsElement: CedsElementCatalog) {
    this.pickerElementId = null;
    delete this.optionSetCache[cedsElement.cedsElementGlobalId];
    this.updateElement(mapping, { mappingStatus: 'Accepted', cedsElementGlobalId: cedsElement.cedsElementGlobalId });
  }

  private updateElement(mapping: EtlSourceElementMapping, update: any) {
    this.etlSourceMappingService.updateElementMapping(mapping.etlSourceElementMappingId, update).subscribe({
      next: updated => this.replaceElementRow(updated),
      error: () => this.statusMessage = 'The mapping update failed.'
    });
  }

  private replaceElementRow(updated: EtlSourceElementMapping) {
    if (!updated) {
      this.loadMappings();
      return;
    }

    const index = this.mappings.findIndex(m => m.etlSourceElementMappingId === updated.etlSourceElementMappingId);

    if (index >= 0) {
      // Keep the option set rows when the update response omits them
      if (!updated.etlSourceOptionSetMappings) {
        updated.etlSourceOptionSetMappings = this.mappings[index].etlSourceOptionSetMappings;
      }
      this.mappings[index] = updated;
    } else {
      this.loadMappings();
    }
  }

  // -------------------- Option set review --------------------

  toggleOptions(mapping: EtlSourceElementMapping) {
    this.expandedElementId = this.expandedElementId === mapping.etlSourceElementMappingId
      ? null
      : mapping.etlSourceElementMappingId;

    if (this.expandedElementId !== null && mapping.cedsElementGlobalId && !this.optionSetCache[mapping.cedsElementGlobalId]) {
      this.etlSourceMappingService.getCedsOptionSets(mapping.cedsElementGlobalId).subscribe({
        next: optionSetValues => this.optionSetCache[mapping.cedsElementGlobalId] = optionSetValues || [],
        error: () => this.statusMessage = 'Unable to load the CEDS option set values.'
      });
    }
  }

  cedsOptionsFor(mapping: EtlSourceElementMapping): CedsOptionSetValue[] {
    return mapping.cedsElementGlobalId ? (this.optionSetCache[mapping.cedsElementGlobalId] || []) : [];
  }

  acceptOption(optionMapping: EtlSourceOptionSetMapping) {
    this.updateOption(optionMapping, {
      mappingStatus: 'Accepted',
      cedsOptionSetCode: optionMapping.cedsOptionSetCode,
      cedsOptionSetDescription: optionMapping.cedsOptionSetDescription
    });
  }

  pickCedsOption(mapping: EtlSourceElementMapping, optionMapping: EtlSourceOptionSetMapping, cedsOptionSetCode: string) {
    const cedsOption = this.cedsOptionsFor(mapping).find(o => o.cedsOptionSetCode === cedsOptionSetCode);

    if (!cedsOption) {
      return;
    }

    this.updateOption(optionMapping, {
      mappingStatus: 'Accepted',
      cedsOptionSetCode: cedsOption.cedsOptionSetCode,
      cedsOptionSetDescription: cedsOption.cedsOptionSetDescription
    });
  }

  private updateOption(optionMapping: EtlSourceOptionSetMapping, update: any) {
    this.etlSourceMappingService.updateOptionSetMapping(optionMapping.etlSourceOptionSetMappingId, update).subscribe({
      next: updated => {
        if (!updated) {
          this.loadMappings();
          return;
        }

        const parent = this.mappings.find(m => m.etlSourceElementMappingId === updated.etlSourceElementMappingId);
        const index = parent ? parent.etlSourceOptionSetMappings.findIndex(o => o.etlSourceOptionSetMappingId === updated.etlSourceOptionSetMappingId) : -1;

        if (parent && index >= 0) {
          parent.etlSourceOptionSetMappings[index] = updated;
        } else {
          this.loadMappings();
        }
      },
      error: () => this.statusMessage = 'The option set mapping update failed.'
    });
  }

  // -------------------- Export / clear --------------------

  exportChecklist() {
    this.etlSourceMappingService.export().subscribe({
      next: blob => {
        const url = window.URL.createObjectURL(blob);
        const anchor = document.createElement('a');
        anchor.href = url;
        anchor.download = 'EtlChecklist.csv';
        anchor.click();
        window.URL.revokeObjectURL(url);
      },
      error: () => this.statusMessage = 'The export failed.'
    });
  }

  clearAll() {
    if (!window.confirm('Remove all uploaded data dictionary elements and their CEDS mappings?')) {
      return;
    }

    this.etlSourceMappingService.deleteAll().subscribe({
      next: () => {
        this.statusMessage = 'All mappings were removed.';
        this.loadMappings();
      },
      error: () => this.statusMessage = 'The mappings could not be removed.'
    });
  }

  // -------------------- Display helpers --------------------

  confidencePercent(confidence: number): string {
    return confidence === null || confidence === undefined ? '' : Math.round(confidence * 100) + '%';
  }

  statusClass(status: string): string {
    switch (status) {
      case 'Accepted': return 'etl-mapping__status--accepted';
      case 'Suggested': return 'etl-mapping__status--suggested';
      case 'Rejected': return 'etl-mapping__status--rejected';
      case 'NotInCeds': return 'etl-mapping__status--notinceds';
      default: return 'etl-mapping__status--unmapped';
    }
  }
}
