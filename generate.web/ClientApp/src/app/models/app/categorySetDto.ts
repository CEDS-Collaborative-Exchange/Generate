import {CategoryOptionDto} from './categoryOptionDto';

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
