import {CategorySetDto} from './categorySetDto';

export interface IGenerateReportParametersDto {
    reportType: string;
    reportCode: string;
    reportLevel: string;
    reportYear: string;
    reportCategorySet: CategorySetDto;
    reportCategorySetCode: string;
    reportSort: number;
    reportPage: number;
    reportPageSize: number;
    reportFilter: string;
    reportFilterValue: string;
    reportTypeAbbreviation: string;
    reportControlTypeName: string;
    reportSubFilter: string;
    reportGrade: string;
    reportLea: string;
    reportSchool: string;
    connectionLink: string;
    organizationalIdList: string;
}

export class GenerateReportParametersDto implements IGenerateReportParametersDto {
    reportType: string;
    reportCode: string;
    reportLevel: string;
    reportYear: string;
    reportCategorySet: CategorySetDto;
    reportCategorySetCode: string;
    reportSort: number;
    reportPage: number;
    reportPageSize: number;
    reportFilter: string;
    reportFilterValue: string;
    reportTypeAbbreviation: string;
    reportControlTypeName: string;
    reportSubFilter: string;
    reportGrade: string;
    reportLea: string;
    reportSchool: string;
    connectionLink: string;
    organizationalIdList: string;
}