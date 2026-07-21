import { Component, OnInit } from '@angular/core';

import * as XLSX from '../../lib/xlsx-js-style/xlsx.js';

import { EtlSourceMappingService } from '../services/app/etlSourceMapping.service';
import {
  CedsElementCatalog,
  CedsOptionSetValue,
  EtlMap,
  EtlMapFileSpec,
  EtlSourceElementMapping,
  EtlSourceElementUpload,
  EtlSourceMappingUpload,
  EtlSourceOptionSetMapping,
  FactType
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

  maps: EtlMap[] = [];
  selectedMap: EtlMap = null;
  mapNameInput = '';

  // Map add/edit editor
  editingMapId: number = null;   // null = editor closed, 0 = new map, >0 = editing that map
  editorName = '';
  editorSpecs: EtlMapFileSpec[] = [];
  editorSpecNumber = '';
  editorFactTypeId: number = null;
  factTypes: FactType[] = [];
  fileSpecNumbers: string[] = [];

  mappings: EtlSourceElementMapping[] = [];
  cedsElements: CedsElementCatalog[] = [];

  isLoading = false;
  isUploading = false;
  uploadFileName = '';
  uploadError = '';
  statusMessage = '';
  showRequirements = false;

  // Upload requirements shown on the page; aliases mirror COLUMN_ALIASES above
  readonly columnRequirements = [
    { column: 'Source Element Name', required: true, aliases: 'Element Name, Element/Field Name, Field Name', notes: 'The name of the element in your data dictionary. Rows without a value are skipped.' },
    { column: 'Source Element Definition', required: false, aliases: 'Element Definition, Definition', notes: 'Strongly recommended - definitions significantly improve automapping accuracy.' },
    { column: 'Source Option Set Code', required: false, aliases: 'Option Set Code, Option Set, Valid Values/Option Set, Valid Values', notes: 'One row per option value; repeat the element columns on each row.' },
    { column: 'Source Option Set Description', required: false, aliases: 'Option Set Description, Option Description', notes: 'The human-readable meaning of the option value.' },
    { column: 'Source Common Name', required: false, aliases: 'Common Name, System Name', notes: '' },
    { column: 'Source Technical Name', required: false, aliases: 'Technical Name, System of Record', notes: '' },
    { column: 'Source Database Name', required: false, aliases: 'Database Name', notes: '' },
    { column: 'Source Schema Name', required: false, aliases: 'Schema Name', notes: '' },
    { column: 'Source Table Name', required: false, aliases: 'Table Name', notes: '' },
    { column: 'Source Column Name', required: false, aliases: 'Column Name', notes: '' },
    { column: 'Source Data Type', required: false, aliases: 'Data Type', notes: '' },
    { column: 'Source Data Length', required: false, aliases: 'Data Length, Length', notes: '' },
    { column: 'Source Data Steward', required: false, aliases: 'Data Steward', notes: '' },
    { column: 'Selection Criteria', required: false, aliases: '', notes: '' },
    { column: 'Transformation Rules', required: false, aliases: '', notes: '' },
    { column: 'Notes', required: false, aliases: 'Comments', notes: '' }
  ];

  expandedElementId: number = null;
  pickerElementId: number = null;
  pickerFilter = '';
  optionSetCache: { [globalId: string]: CedsOptionSetValue[] } = {};

  constructor(private etlSourceMappingService: EtlSourceMappingService) { }

  ngOnInit() {
    this.loadMaps();
    this.loadCedsElements();

    this.etlSourceMappingService.getFactTypes().subscribe({
      next: factTypes => this.factTypes = factTypes || [],
      error: () => { }
    });
    this.etlSourceMappingService.getFileSpecNumbers().subscribe({
      next: fileSpecNumbers => this.fileSpecNumbers = fileSpecNumbers || [],
      error: () => { }
    });
  }

  // -------------------- Map add / edit --------------------

  newMap() {
    this.editingMapId = 0;
    this.editorName = '';
    this.editorSpecs = [];
    this.editorSpecNumber = '';
    this.editorFactTypeId = null;
  }

  editMap(etlMap: EtlMap) {
    this.editingMapId = etlMap.etlMapId;
    this.editorName = etlMap.mapName;
    this.editorSpecs = (etlMap.fileSpecs || []).map(s => ({ ...s }));
    this.editorSpecNumber = '';
    this.editorFactTypeId = null;
  }

  cancelMapEditor() {
    this.editingMapId = null;
  }

  addEditorSpecNumber() {
    const specNumber = (this.editorSpecNumber || '').trim().toUpperCase();

    if (!specNumber) {
      return;
    }

    if (!this.editorSpecs.some(s => (s.fileSpecNumber || '').toUpperCase() === specNumber)) {
      this.editorSpecs.push({ fileSpecNumber: specNumber, dimFactTypeId: null, factTypeCode: null });
    }

    this.editorSpecNumber = '';
  }

  addEditorFactType() {
    if (this.editorFactTypeId === null) {
      return;
    }

    const factType = this.factTypes.find(f => f.dimFactTypeId === +this.editorFactTypeId);

    if (factType && !this.editorSpecs.some(s => s.dimFactTypeId === factType.dimFactTypeId)) {
      this.editorSpecs.push({ fileSpecNumber: null, dimFactTypeId: factType.dimFactTypeId, factTypeCode: factType.factTypeCode });
    }

    this.editorFactTypeId = null;
  }

  removeEditorSpec(index: number) {
    this.editorSpecs.splice(index, 1);
  }

  specLabel(spec: EtlMapFileSpec): string {
    return spec.fileSpecNumber || spec.factTypeCode || ('FactType ' + spec.dimFactTypeId);
  }

  specsSummary(etlMap: EtlMap): string {
    return (etlMap.fileSpecs || []).map(s => this.specLabel(s)).join(', ');
  }

  saveMapEditor() {
    const name = (this.editorName || '').trim();

    if (!name) {
      this.statusMessage = 'A map name is required.';
      return;
    }

    const save = { mapName: name, fileSpecs: this.editorSpecs };

    const request = this.editingMapId === 0
      ? this.etlSourceMappingService.createMap(save)
      : this.etlSourceMappingService.updateMap(this.editingMapId, save);

    request.subscribe({
      next: savedMap => {
        this.editingMapId = null;
        this.statusMessage = 'Map "' + savedMap.mapName + '" was saved.';

        if (this.selectedMap && this.selectedMap.etlMapId === savedMap.etlMapId) {
          this.selectedMap = savedMap;
        }

        this.loadMaps();
      },
      error: () => this.statusMessage = 'The map could not be saved.'
    });
  }

  loadMaps() {
    this.isLoading = true;
    this.etlSourceMappingService.getMaps().subscribe({
      next: maps => {
        this.maps = maps || [];
        this.isLoading = false;

        // Keep the selected map's summary row fresh
        if (this.selectedMap) {
          this.selectedMap = this.maps.find(m => m.etlMapId === this.selectedMap.etlMapId) || null;
        }
      },
      error: () => {
        this.isLoading = false;
        this.statusMessage = 'Unable to load the mapping list.';
      }
    });
  }

  openMap(etlMap: EtlMap) {
    this.selectedMap = etlMap;
    this.expandedElementId = null;
    this.pickerElementId = null;
    this.statusMessage = '';
    this.loadMappings();
  }

  backToMaps() {
    this.selectedMap = null;
    this.mappings = [];
    this.statusMessage = '';
    this.loadMaps();
  }

  deleteMap(etlMap: EtlMap) {
    if (!window.confirm('Delete the map "' + etlMap.mapName + '" and all of its mappings?')) {
      return;
    }

    this.etlSourceMappingService.deleteMap(etlMap.etlMapId).subscribe({
      next: () => {
        if (this.selectedMap && this.selectedMap.etlMapId === etlMap.etlMapId) {
          this.selectedMap = null;
          this.mappings = [];
        }
        this.statusMessage = 'Map "' + etlMap.mapName + '" was deleted.';
        this.loadMaps();
      },
      error: () => this.statusMessage = 'The map could not be deleted.'
    });
  }

  loadMappings() {
    if (!this.selectedMap) {
      return;
    }

    this.isLoading = true;
    this.etlSourceMappingService.getAll(this.selectedMap.etlMapId).subscribe({
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

  toggleRequirements() {
    this.showRequirements = !this.showRequirements;
  }

  downloadTemplate() {
    const headers = [
      'Source Common Name', 'Source Technical Name', 'Source Database Name', 'Source Schema Name',
      'Source Table Name', 'Source Column Name', 'Source Element Name', 'Source Element Definition',
      'Source Data Type', 'Source Data Length', 'Source Option Set Code', 'Source Option Set Description',
      'Source Data Steward', 'Selection Criteria', 'Transformation Rules', 'Notes'
    ];

    // Sample rows: one element with two option set values (repeated rows) and one without an option set
    const sampleRows = [
      ['Student Information System', 'SIS', 'StateSIS', 'dbo', 'StudentEnrollment', 'EntryGrade',
        'Entry Grade Level', 'The grade level at which the student enters and receives services during the school year.',
        'varchar', '2', '08', 'Eighth Grade', 'Jane Doe', '', '', 'One row per option set value - repeat the element columns.'],
      ['Student Information System', 'SIS', 'StateSIS', 'dbo', 'StudentEnrollment', 'EntryGrade',
        'Entry Grade Level', 'The grade level at which the student enters and receives services during the school year.',
        'varchar', '2', '09', 'Ninth Grade', 'Jane Doe', '', '', ''],
      ['Student Information System', 'SIS', 'StateSIS', 'dbo', 'Student', 'DOB',
        'Student Birth Date', 'The month, day, and year on which the student was born.',
        'date', '', '', '', 'Jane Doe', '', '', 'Elements without an option set use a single row with the option columns blank.']
    ];

    const worksheet = XLSX.utils.aoa_to_sheet([headers, ...sampleRows]);

    // Bold header row (xlsx-js-style cell style support)
    headers.forEach((header, columnIndex) => {
      const cellRef = XLSX.utils.encode_cell({ r: 0, c: columnIndex });
      if (worksheet[cellRef]) {
        worksheet[cellRef].s = {
          font: { bold: true, color: { rgb: 'FFFFFF' } },
          fill: { fgColor: { rgb: '33739E' } }
        };
      }
    });

    worksheet['!cols'] = headers.map(header =>
      ({ wch: Math.max(header.length + 2, header.indexOf('Definition') >= 0 ? 60 : 18) }));

    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Data Dictionary');
    XLSX.writeFile(workbook, 'Generate Data Dictionary Template.xlsx');
  }

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

      // Elements repeat across rows (one row per option set value, or per source table);
      // list each distinct element ONCE, keyed by element name only
      const key = elementName.toLowerCase();
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
      } else {
        // Later rows for the same element may carry values the first row left blank
        element.sourceCommonName = element.sourceCommonName || value('sourceCommonName');
        element.sourceTechnicalName = element.sourceTechnicalName || value('sourceTechnicalName');
        element.sourceDatabaseName = element.sourceDatabaseName || value('sourceDatabaseName');
        element.sourceSchemaName = element.sourceSchemaName || value('sourceSchemaName');
        element.sourceTableName = element.sourceTableName || value('sourceTableName');
        element.sourceColumnName = element.sourceColumnName || value('sourceColumnName');
        element.sourceElementDefinition = element.sourceElementDefinition || value('sourceElementDefinition');
        element.sourceDataType = element.sourceDataType || value('sourceDataType');
        element.sourceDataLength = element.sourceDataLength || value('sourceDataLength');
        element.sourceDataSteward = element.sourceDataSteward || value('sourceDataSteward');
        element.selectionCriteria = element.selectionCriteria || value('selectionCriteria');
        element.transformationRules = element.transformationRules || value('transformationRules');
        element.notes = element.notes || value('notes');
      }

      const optionCode = value('sourceOptionSetCode');
      const optionDescription = value('sourceOptionSetDescription');

      if (optionCode || optionDescription) {
        // Skip identical option values repeated across the element's rows
        const duplicate = element.optionSetValues.some(o =>
          o.sourceOptionSetCode.toLowerCase() === optionCode.toLowerCase() &&
          o.sourceOptionSetDescription.toLowerCase() === optionDescription.toLowerCase());

        if (!duplicate) {
          element.optionSetValues.push({
            sourceOptionSetCode: optionCode,
            sourceOptionSetDescription: optionDescription
          });
        }
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
      // Uploading while a map is open appends the elements to that map
      etlMapId: this.selectedMap ? this.selectedMap.etlMapId : null,
      mapName: (this.mapNameInput || '').trim() || this.uploadFileName,
      uploadFileName: this.uploadFileName,
      uploadedBy: null,
      elements: elements
    };

    this.isUploading = true;
    this.statusMessage = '';

    this.etlSourceMappingService.upload(upload).subscribe({
      next: results => {
        this.isUploading = false;
        this.mapNameInput = '';
        this.statusMessage = (results || []).length + ' element(s) uploaded to map "' + upload.mapName + '" and automapped to CEDS.';

        // Open the new map for review
        const firstResult = (results || [])[0];
        this.etlSourceMappingService.getMaps().subscribe({
          next: maps => {
            this.maps = maps || [];
            const newMap = firstResult && firstResult.mapping
              ? this.maps.find(m => m.etlMapId === firstResult.mapping.etlMapId)
              : this.maps[0];
            if (newMap) {
              this.openMap(newMap);
            }
          }
        });
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

  exportChecklist(etlMap?: EtlMap) {
    const target = etlMap || this.selectedMap;

    this.etlSourceMappingService.export(target ? target.etlMapId : null).subscribe({
      next: blob => {
        const url = window.URL.createObjectURL(blob);
        const anchor = document.createElement('a');
        anchor.href = url;
        anchor.download = (target ? target.mapName.replace(/[^\w\- ]/g, '') : 'EtlChecklist') + '.csv';
        anchor.click();
        window.URL.revokeObjectURL(url);
      },
      error: () => this.statusMessage = 'The export failed.'
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
