import {GenerateReportFilterItemDto} from './generateReportFilterItemDto';

export interface GenerateReportFilterDto {
    filterName: string;
    filterControl: string;
    filterItems: Array<GenerateReportFilterItemDto>;
}