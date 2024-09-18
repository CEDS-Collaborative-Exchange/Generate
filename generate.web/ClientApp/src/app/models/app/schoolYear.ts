export interface DimSchoolYearDto {

    dimSchoolYearId: number;
    schoolYear: string;
    sessionBeginDate: Date;
    sessionEndDate: Date;
    isSelected: boolean;
    dataMigrationTypeId: number;
}

export interface DimSchoolYearDataMigrationType {
    dimSchoolYearId: number;
    dataMigrationTypeId: number;
    isSelected: boolean;
}

