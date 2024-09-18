export interface StagingValidationResult {
    id: number;
    stagingValidationRuleId: number;
    schoolYear: number;
    factTypeOrReportCode: String;
    stagingTableName: String;
    columnName: String;
    severity: String;
    validationMessage: String;
    recordCount: number;
}
