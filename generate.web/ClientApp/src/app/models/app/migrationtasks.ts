export interface DataMigrationTask {
    dataMigrationTaskId: number;
    dataMigrationTypeId: number;
    isActive: boolean;
    runAfterGenerateMigration: boolean;
    runBeforeGenerateMigration: boolean;
    storedProcedureName: string;
    description: string;
    taskSequence: number;
    isSelected?: boolean;
}

export interface GenerateReport {
    generateReportId: number;
    generateReportTypeId: number;
    reportType: string;
    reportCode: string;
    description: string;
    reportTitle: string;
    isLocked: boolean;
    generateReport_FactTypes: Array<GenerateReportFactType>;
}

export interface GenerateReportType {
    generateReportTypeId: number;
    reportTypeName: string;
    reportTypeCode: string;
}

export interface GenerateReportFactType {
    generateReportId: number;
    factTypeId: number;
}
