import {CategorySetDto} from './categorySetDto';
import {OrganizationLevelDto} from './organizationLevelDto';
import { GenerateReportFilterDto } from './generateReportFilterDto';
import { GenerateReportControlType } from './generateReportControlType';
import { GenerateReportFilterOptionDto } from './generateReportFilterOptionDto'

export interface GenerateReportDto {
    generateReportId: number;
    generateReportTypeId: number;
    generateReportControlTypeId: number;
    cedsConnectionId: number;
    reportName: string;
    reportShortName: string;
    reportTypeAbbreviation: string;
    reportCode: string;
    categorySetControlCaption: string;
    showCategorySetControl: boolean;
    categorySetControlLabel: string;
    filterControlLabel: string;
    subFilterControlLabel: string;
    showFilterControl: boolean;
    showSubFilterControl: boolean;
    showData: boolean;
    showGraph: boolean;
    seaLevel: boolean;
    leaLevel: boolean;
    schLevel: boolean;
    organizationLevels: Array<OrganizationLevelDto>;
    reportFilters: Array<GenerateReportFilterDto>;
    categorySets: Array<CategorySetDto>;
    reportFilterOptions: Array<GenerateReportFilterOptionDto>;
    reportControlType: GenerateReportControlType;
    isActive: boolean;
    connectionLink: string;
}