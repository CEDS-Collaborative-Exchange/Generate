export interface GenerateReport {
    generateReportId: number;
    generateReportTypeId: number;
    generateReportControlTypeId: number;
    cedsConnectionId: number;
    reportName: string;
    reportShortName: string;
    reportCode: string;
    reportTypeAbbreviation: string;
    categorySetControlCaption: string;
    showCategorySetControl: boolean;
    filterControlLabel: string;
    subFilterControlLabel: string;
    showFilterControl: boolean;
    showSubFilterControl: boolean;
    showData: boolean;
    showGraph: boolean;
}
