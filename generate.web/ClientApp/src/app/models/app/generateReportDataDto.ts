import {GenerateReportStructureDto} from './generateReportStructureDto';
import {CategorySetDto} from './categorySetDto';

export interface GenerateReportDataDto {
    reportTitle: string;
    reportControlTypeName: string;
    reportYear: string;
    categorySets: Array<CategorySetDto>;
    structure: GenerateReportStructureDto;
    data: Array<any>;
    dataCount: number;
    subtotalKey: string;
    subtotalValues: Array<string>;
    totalKey: string;
    totalValues: Array<string>;
}