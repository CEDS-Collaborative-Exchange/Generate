import { CategoryOptionDto } from './categoryOptionDto';
import { TableType } from './tableType';

export interface CategorySetDto {
    categorySetId: number;
    organizationLevelCode: string;
    submissionYear: string;
    categorySetCode: string;
    categorySetName: string;
    viewDefinition: string;
    includeOnFilter: string;
    excludeOnFilter: string;
    categories: Array<string>;
    categoryOptions: Array<CategoryOptionDto>;
    tableTypes: Array<TableType>;
}
export interface Categoriess {
    categoryId: number;
    categoryName: string;

}

export interface Filter {
    filterCode: number;
    filterName: string;

}

export interface CatToDisplay {
    categorySetCode: number;
    categorySetName: string;

}
