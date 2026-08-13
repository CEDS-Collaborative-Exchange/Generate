export interface EtlSourceOptionSetMapping {
    etlSourceOptionSetMappingId: number;
    etlSourceElementMappingId: number;
    sourceOptionSetCode: string;
    sourceOptionSetDescription: string;
    cedsOptionSetCode: string;
    cedsOptionSetDescription: string;
    optionSetResponseId: string;
    matchConfidence: number;
    matchType: string;
    mappingStatus: string;
    createdDate: string;
    modifiedDate: string;
    modifiedBy: string;
}

export interface EtlMapFileSpec {
    fileSpecNumber: string;
    dimFactTypeId: number;
    factTypeCode: string;
}

export interface EtlMapSave {
    mapName: string;
    fileSpecs: Array<EtlMapFileSpec>;
    modifiedBy?: string;
}

export interface FactType {
    dimFactTypeId: number;
    factTypeCode: string;
    factTypeDescription: string;
    factTypeLabel: string;
}

export interface EtlMap {
    etlMapId: number;
    mapName: string;
    uploadFileName: string;
    joinInstructions?: string;
    processingNotes?: string;
    createdDate: string;
    createdBy: string;
    modifiedDate: string;
    modifiedBy: string;
    elementCount: number;
    mappedElementCount: number;
    fileSpecs: Array<EtlMapFileSpec>;
}

export interface EtlMapJoin {
    etlMapJoinId: number;
    etlMapId: number;
    leftSourceObject: string;
    leftColumn: string;
    rightSourceObject: string;
    rightColumn: string;
    joinType: string;      // INNER | LEFT | RIGHT | FULL
    sortOrder: number;
}

export interface EtlMapSourceSchema {
    sourceObject: string;
    sourceName: string;
    columns: string[];
}

export interface EtlMapGuidance {
    joinInstructions: string;
    processingNotes: string;
}

export interface EtlMapSource {
    etlMapSourceId: number;
    etlMapId: number;
    sourceName: string;
    sourceConnection: string;
    sourceObject: string;
    notes: string;
    createdDate?: string;
    modifiedDate?: string;
}

export interface EtlSourceElementMapping {
    etlSourceElementMappingId: number;
    etlMapId: number;
    sourceCommonName: string;
    sourceTechnicalName: string;
    sourceDatabaseName: string;
    sourceSchemaName: string;
    sourceTableName: string;
    sourceColumnName: string;
    sourceElementName: string;
    sourceElementDefinition: string;
    sourceDataType: string;
    sourceDataLength: string;
    sourceDataSteward: string;
    selectionCriteria: string;
    transformationRules: string;
    notes: string;
    cedsElementGlobalId: string;
    cedsElementName: string;
    cedsElementDefinition: string;
    cedsDataModelId: string;
    cedsPath: string;
    elementDefinitionResponseId: string;
    matchConfidence: number;
    matchType: string;
    mappingStatus: string;
    stagingTableColumns: string;
    uploadFileName: string;
    createdDate: string;
    createdBy: string;
    modifiedDate: string;
    modifiedBy: string;
    etlSourceOptionSetMappings: Array<EtlSourceOptionSetMapping>;
}

export interface CedsElementCatalog {
    cedsElementGlobalId: string;
    cedsElementName: string;
    cedsElementDefinition: string;
    cedsPath: string;
    cedsDataModelId: string;
    hasOptionSet: boolean;
}

export interface CedsElementMatch extends CedsElementCatalog {
    confidence: number;
}

export interface CedsOptionSetValue {
    cedsOptionSetCode: string;
    cedsOptionSetDescription: string;
}

export interface EtlSourceElementMappingResult {
    mapping: EtlSourceElementMapping;
    candidates: Array<CedsElementMatch>;
}

export interface EtlSourceOptionSetValueUpload {
    sourceOptionSetCode: string;
    sourceOptionSetDescription: string;
}

export interface EtlSourceElementUpload {
    sourceCommonName: string;
    sourceTechnicalName: string;
    sourceDatabaseName: string;
    sourceSchemaName: string;
    sourceTableName: string;
    sourceColumnName: string;
    sourceElementName: string;
    sourceElementDefinition: string;
    sourceDataType: string;
    sourceDataLength: string;
    sourceDataSteward: string;
    selectionCriteria: string;
    transformationRules: string;
    notes: string;
    optionSetValues: Array<EtlSourceOptionSetValueUpload>;
}

export interface EtlSourceMappingUpload {
    etlMapId?: number;
    mapName: string;
    uploadFileName: string;
    uploadedBy: string;
    elements: Array<EtlSourceElementUpload>;
}

export interface EtlSourceElementMappingUpdate {
    cedsElementGlobalId?: string;
    mappingStatus?: string;
    elementDefinitionResponseId?: string;
    selectionCriteria?: string;
    transformationRules?: string;
    notes?: string;
    // Reviewer-curated Staging target columns (Table.Column). Non-null REPLACES the auto-derived set,
    // so pruning an over-broad shared-element expansion persists with the map.
    stagingTableColumns?: string[];
    modifiedBy?: string;
}

export interface EtlSourceOptionSetMappingUpdate {
    cedsOptionSetCode?: string;
    cedsOptionSetDescription?: string;
    mappingStatus?: string;
    optionSetResponseId?: string;
    modifiedBy?: string;
}
