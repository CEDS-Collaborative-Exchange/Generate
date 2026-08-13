import { Component, OnInit } from '@angular/core';
import { forkJoin } from 'rxjs';

import * as XLSX from '../../lib/xlsx-js-style/xlsx.js';

import { EtlSourceMappingService } from '../services/app/etlSourceMapping.service';
import { EtlChatService } from '../services/app/etlChat.service';
import { EtlMappingCoverage } from '../models/app/etlChat';
import {
  CedsElementCatalog,
  CedsOptionSetValue,
  EtlMap,
  EtlMapFileSpec,
  EtlMapJoin,
  EtlMapSource,
  EtlMapSourceSchema,
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

  // Source datasets registered to the selected map (a file spec may draw from several).
  sources: EtlMapSource[] = [];
  editingSource: EtlMapSource = null;   // the row being added/edited (null = form closed)
  unregisteredSources: string[] = [];   // source tables in the mappings but not in the registry

  // How the map's source tables join to one another (structured), plus free-text AI guidance.
  mapJoins: EtlMapJoin[] = [];
  editingJoin: EtlMapJoin = null;
  sourceSchema: EtlMapSourceSchema[] = [];   // source objects + their columns, for join dropdowns
  joinInstructions = '';                     // free-text join description (map level)
  processingNotes = '';                      // free-text filtering/processing guidance (map level)
  guidanceSaved = false;

  // Readiness: does the map cover the Staging tables the target file spec's migration requires?
  coverage: EtlMappingCoverage = null;

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

  // Staging tables anchored by a discrete 1-to-1 mapping. Ubiquitous CEDS elements (School/Student
  // Identifier, School Year, …) fan out to every staging table that has that column; we only surface
  // destinations for these "active" tables so the grid — and the LLM feed — stay focused.
  activeStagingTables = new Set<string>();

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
  notesOpenFor: number = null;   // row whose transformation-notes editor is expanded
  pickerFilter = '';
  optionSetCache: { [globalId: string]: CedsOptionSetValue[] } = {};

  constructor(
    private etlSourceMappingService: EtlSourceMappingService,
    private etlChatService: EtlChatService) { }

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

  factTypeDisplay(factType: FactType): string {
    return factType.factTypeLabel
      ? factType.factTypeLabel + ' (' + factType.factTypeCode + ')'
      : factType.factTypeCode;
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
    this.joinInstructions = etlMap.joinInstructions || '';
    this.processingNotes = etlMap.processingNotes || '';
    this.guidanceSaved = false;
    this.loadMappings();
    this.loadSources();
    this.loadCoverage();
    this.loadJoins();
    this.loadSourceSchema();
  }

  backToMaps() {
    this.selectedMap = null;
    this.mappings = [];
    this.sources = [];
    this.editingSource = null;
    this.unregisteredSources = [];
    this.coverage = null;
    this.mapJoins = [];
    this.editingJoin = null;
    this.sourceSchema = [];
    this.joinInstructions = '';
    this.processingNotes = '';
    this.statusMessage = '';
    this.loadMaps();
  }

  // ---- Table joins + free-text AI guidance ----

  loadJoins() {
    if (!this.selectedMap) { return; }
    this.etlSourceMappingService.getMapJoins(this.selectedMap.etlMapId).subscribe({
      next: j => this.mapJoins = j || [],
      error: () => this.statusMessage = 'Unable to load the table joins.'
    });
  }

  loadSourceSchema() {
    if (!this.selectedMap) { return; }
    this.etlSourceMappingService.getMapSourceSchema(this.selectedMap.etlMapId).subscribe({
      next: s => this.sourceSchema = s || [],
      error: () => this.sourceSchema = []
    });
  }

  // Columns available for a chosen source object (drives the join column dropdowns).
  columnsFor(sourceObject: string): string[] {
    const s = this.sourceSchema.find(x => x.sourceObject === sourceObject);
    return s ? s.columns : [];
  }

  newJoin() {
    const first = this.sourceSchema[0] ? this.sourceSchema[0].sourceObject : '';
    const second = this.sourceSchema[1] ? this.sourceSchema[1].sourceObject : first;
    this.editingJoin = {
      etlMapJoinId: 0,
      etlMapId: this.selectedMap ? this.selectedMap.etlMapId : null,
      leftSourceObject: first,
      leftColumn: '',
      rightSourceObject: second,
      rightColumn: '',
      joinType: 'LEFT',
      sortOrder: 0
    };
  }

  editJoin(join: EtlMapJoin) {
    this.editingJoin = { ...join };
  }

  cancelJoin() {
    this.editingJoin = null;
  }

  saveJoin() {
    if (!this.selectedMap || !this.editingJoin) { return; }
    const j = this.editingJoin;
    if (!j.leftSourceObject || !j.rightSourceObject || !j.leftColumn || !j.rightColumn) {
      this.statusMessage = 'A join needs both tables and both columns.';
      return;
    }
    this.etlSourceMappingService.saveMapJoin(this.selectedMap.etlMapId, j).subscribe({
      next: () => { this.editingJoin = null; this.statusMessage = 'Join saved.'; this.loadJoins(); },
      error: () => this.statusMessage = 'The join could not be saved.'
    });
  }

  deleteJoin(join: EtlMapJoin) {
    if (!window.confirm('Remove this join?')) { return; }
    this.etlSourceMappingService.deleteMapJoin(join.etlMapJoinId).subscribe({
      next: () => { this.statusMessage = 'Join removed.'; this.loadJoins(); },
      error: () => this.statusMessage = 'The join could not be removed.'
    });
  }

  saveGuidance() {
    if (!this.selectedMap) { return; }
    this.etlSourceMappingService.saveMapGuidance(this.selectedMap.etlMapId, {
      joinInstructions: this.joinInstructions,
      processingNotes: this.processingNotes
    }).subscribe({
      next: saved => {
        this.guidanceSaved = true;
        if (this.selectedMap) {
          this.selectedMap.joinInstructions = this.joinInstructions;
          this.selectedMap.processingNotes = this.processingNotes;
        }
        this.statusMessage = 'AI guidance saved.';
      },
      error: () => this.statusMessage = 'The guidance could not be saved.'
    });
  }

  // Readiness for an end-to-end migration: are all the Staging tables the file spec needs mapped?
  loadCoverage() {
    if (!this.selectedMap) { this.coverage = null; return; }
    this.etlChatService.getCoverage(this.selectedMap.etlMapId).subscribe({
      next: c => this.coverage = c,
      error: () => this.coverage = null
    });
  }

  // ---- Source datasets (multi-source per map) ----

  loadSources() {
    if (!this.selectedMap) { return; }
    this.etlSourceMappingService.getMapSources(this.selectedMap.etlMapId).subscribe({
      next: s => { this.sources = s || []; this.recomputeUnregisteredSources(); },
      error: () => this.statusMessage = 'Unable to load the map sources.'
    });
  }

  // Distinct source objects (schema.table) the uploaded element mappings reference. Blank table names
  // (derived/system elements) are ignored.
  private mappedSourceObjects(): string[] {
    const seen = new Set<string>();
    const objects: string[] = [];
    for (const m of this.mappings) {
      if (!m.sourceTableName || !m.sourceTableName.trim()) { continue; }
      const schema = m.sourceSchemaName && m.sourceSchemaName.trim() ? m.sourceSchemaName.trim() + '.' : '';
      const obj = schema + m.sourceTableName.trim();
      const key = obj.toLowerCase();
      if (!seen.has(key)) { seen.add(key); objects.push(obj); }
    }
    return objects;
  }

  // Source tables used by the mappings but NOT registered in the Source Datasets table. Every uploaded
  // source table should be registered so the map, join builder, and AI ETL Developer stay in sync.
  recomputeUnregisteredSources() {
    const registered = new Set((this.sources || [])
      .map(s => (s.sourceObject || '').trim().toLowerCase())
      .filter(o => o.length > 0));
    this.unregisteredSources = this.mappedSourceObjects().filter(o => !registered.has(o.toLowerCase()));
  }

  // One-click fix: register every mapped-but-unregistered source table as a Source Dataset.
  registerMissingSources() {
    if (!this.selectedMap || this.unregisteredSources.length === 0) { return; }
    const mapId = this.selectedMap.etlMapId;
    const pending = this.unregisteredSources.map(obj => {
      const table = obj.indexOf('.') >= 0 ? obj.substring(obj.lastIndexOf('.') + 1) : obj;
      return this.etlSourceMappingService.saveMapSource(mapId, {
        etlMapSourceId: 0, etlMapId: mapId,
        sourceName: table, sourceConnection: '', sourceObject: obj, notes: ''
      });
    });
    forkJoin(pending).subscribe({
      next: () => { this.statusMessage = 'Registered ' + pending.length + ' source dataset(s).'; this.loadSources(); this.loadSourceSchema(); },
      error: () => this.statusMessage = 'Some sources could not be registered.'
    });
  }

  newSource() {
    this.editingSource = {
      etlMapSourceId: 0,
      etlMapId: this.selectedMap ? this.selectedMap.etlMapId : null,
      sourceName: '',
      sourceConnection: '',
      sourceObject: '',
      notes: ''
    };
  }

  editSource(source: EtlMapSource) {
    this.editingSource = { ...source };
  }

  cancelSource() {
    this.editingSource = null;
  }

  saveSource() {
    if (!this.selectedMap || !this.editingSource) { return; }
    const obj = (this.editingSource.sourceObject || '').trim();
    if (!obj) {
      this.statusMessage = 'A source object (schema.table / view / query) is required.';
      return;
    }
    // Prevent duplicates: a source object may be registered only once per map.
    const dup = this.sources.find(s =>
      s.etlMapSourceId !== this.editingSource.etlMapSourceId &&
      (s.sourceObject || '').trim().toLowerCase() === obj.toLowerCase());
    if (dup) {
      this.statusMessage = `"${obj}" is already registered as a source dataset on this map.`;
      return;
    }
    this.etlSourceMappingService.saveMapSource(this.selectedMap.etlMapId, this.editingSource).subscribe({
      next: () => {
        this.editingSource = null;
        this.statusMessage = 'Source saved — auto-mapping its columns…';
        this.loadSources();
        // Saving a source runs the automapper server-side for its columns, so reload the mappings table
        // (and the source-object dropdowns) to surface the newly auto-generated rows.
        this.loadMappings();
        this.loadSourceSchema();
      },
      error: () => this.statusMessage = 'The source could not be saved.'
    });
  }

  deleteSource(source: EtlMapSource) {
    if (!window.confirm('Remove the source "' + (source.sourceName || source.sourceObject) + '" from this map?')) { return; }
    this.etlSourceMappingService.deleteMapSource(source.etlMapSourceId).subscribe({
      next: () => { this.statusMessage = 'Source removed.'; this.loadSources(); },
      error: () => this.statusMessage = 'The source could not be removed.'
    });
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
        this.recomputeActiveStagingTables();
        this.recomputeUnregisteredSources();
        this.isLoading = false;
      },
      error: () => {
        this.isLoading = false;
        this.statusMessage = 'Unable to load the current mappings.';
      }
    });
  }

  // Parse a "Table.Col; Table2.Col2; …" value into normalized Table.Column pairs (strip Staging. prefix).
  private parseStagingPairs(stagingTableColumns: string): string[] {
    if (!stagingTableColumns) { return []; }
    return stagingTableColumns.split(';')
      .map(p => p.trim())
      .filter(p => p.length > 0)
      .map(p => p.toLowerCase().startsWith('staging.') ? p.substring('staging.'.length) : p)
      .filter(p => p.indexOf('.') > 0);
  }

  private tableOf(pair: string): string {
    const dot = pair.indexOf('.');
    return (dot > 0 ? pair.substring(0, dot) : pair).trim();
  }

  // Active tables = those a mapping targets 1-to-1 (its destinations resolve to exactly one table).
  private recomputeActiveStagingTables() {
    const active = new Set<string>();
    for (const m of this.mappings) {
      const pairs = this.parseStagingPairs(m.stagingTableColumns);
      if (pairs.length === 0) { continue; }
      const tables = Array.from(new Set(pairs.map(p => this.tableOf(p).toLowerCase())));
      if (tables.length === 1) { active.add(tables[0]); }
    }
    this.activeStagingTables = active;
  }

  // Filter a mapping's Staging target pairs to what should actually be shown/fed to the LLM:
  //   (1) tables REQUIRED by the file spec (from coverage), and (2) ACTIVE tables (anchored by a discrete
  // 1-to-1 mapping). Each filter is skipped only when its set is unknown/empty, so a brand-new automap
  // (no coverage yet, nothing active) still shows the raw fan-out rather than blanking.
  private filterStagingPairs(pairs: string[]): string[] {
    let kept = pairs;
    const required = (this.coverage && this.coverage.resolved ? (this.coverage.requiredTables || []) : [])
      .map(t => t.toLowerCase());
    if (required.length > 0) {
      const req = new Set(required);
      kept = kept.filter(p => req.has(this.tableOf(p).toLowerCase()));
    }
    if (this.activeStagingTables.size > 0) {
      kept = kept.filter(p => this.activeStagingTables.has(this.tableOf(p).toLowerCase()));
    }
    return kept;
  }

  // The destination string to SHOW for a mapping: fan-out pruned to required ∩ active tables.
  displayStaging(mapping: EtlSourceElementMapping): string {
    return this.filterStagingPairs(this.parseStagingPairs(mapping.stagingTableColumns)).join('; ');
  }

  // The Staging target columns for a mapping, as individually-removable Table.Column chips (same filter).
  stagingPairs(mapping: EtlSourceElementMapping): string[] {
    return this.filterStagingPairs(this.parseStagingPairs(mapping.stagingTableColumns));
  }

  // Remove one auto-mapped Staging target column and persist the pruned set with the map.
  deleteStagingColumn(mapping: EtlSourceElementMapping, pair: string) {
    const remaining = this.parseStagingPairs(mapping.stagingTableColumns).filter(p => p !== pair);
    this.updateElement(mapping, { stagingTableColumns: remaining });
  }

  // --- Add-back: re-add a Staging target column that was removed by mistake ---
  // The full candidate pool (every column the CEDS element expands to), lazily fetched per mapping.
  stagingCandidateCache: { [mappingId: number]: string[] } = {};
  stagingAddOpenFor: number | null = null;

  // Toggle the "add target" panel for a mapping; fetch its candidate pool on first open.
  toggleStagingAdd(mapping: EtlSourceElementMapping) {
    if (this.stagingAddOpenFor === mapping.etlSourceElementMappingId) {
      this.stagingAddOpenFor = null;
      return;
    }
    this.stagingAddOpenFor = mapping.etlSourceElementMappingId;
    if (!this.stagingCandidateCache[mapping.etlSourceElementMappingId]) {
      this.etlSourceMappingService.getStagingCandidates(mapping.etlSourceElementMappingId).subscribe({
        next: candidates => this.stagingCandidateCache[mapping.etlSourceElementMappingId] = this.parseStagingPairs((candidates || []).join('; ')),
        error: () => this.statusMessage = 'Unable to load the Staging target candidates.'
      });
    }
  }

  // Candidate columns NOT currently selected — the ones offered for add-back.
  availableStagingColumns(mapping: EtlSourceElementMapping): string[] {
    const all = this.stagingCandidateCache[mapping.etlSourceElementMappingId] || [];
    const selected = new Set(this.parseStagingPairs(mapping.stagingTableColumns));
    return all.filter(p => !selected.has(p));
  }

  // Re-add a removed Staging target column and persist the expanded set with the map.
  addStagingColumn(mapping: EtlSourceElementMapping, pair: string) {
    const next = this.parseStagingPairs(mapping.stagingTableColumns);
    if (!next.includes(pair)) { next.push(pair); }
    this.updateElement(mapping, { stagingTableColumns: next });
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
    // The Staging target set is re-derived server-side for the new element, so drop this mapping's cached
    // candidate pool (it belonged to the OLD element) and close its add-back panel — otherwise "+ add"
    // would offer the previous element's columns.
    delete this.stagingCandidateCache[mapping.etlSourceElementMappingId];
    if (this.stagingAddOpenFor === mapping.etlSourceElementMappingId) { this.stagingAddOpenFor = null; }
    this.updateElement(mapping, { mappingStatus: 'Accepted', cedsElementGlobalId: cedsElement.cedsElementGlobalId });
  }

  // Per-row transformation-notes editor (hidden by default). Holds free-text transformation rules the
  // AI ETL Developer reads (the prompt injects it as "transform:" for that element).
  toggleNotes(mapping: EtlSourceElementMapping) {
    this.notesOpenFor = this.notesOpenFor === mapping.etlSourceElementMappingId
      ? null
      : mapping.etlSourceElementMappingId;
  }

  saveMappingNotes(mapping: EtlSourceElementMapping) {
    this.updateElement(mapping, {
      transformationRules: mapping.transformationRules,
      notes: mapping.notes
    });
    this.statusMessage = 'Transformation notes saved.';
    this.notesOpenFor = null;
  }

  private updateElement(mapping: EtlSourceElementMapping, update: any) {
    // The Staging candidate pool depends on the CEDS element / Not-in-CEDS state, so invalidate the
    // cached pool for this mapping — it will re-fetch (with the right candidates) next time it's opened.
    delete this.stagingCandidateCache[mapping.etlSourceElementMappingId];
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
    this.recomputeActiveStagingTables();
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
