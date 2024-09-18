export interface DimDateDto {

    dimDateId: number;
    dateValue?: Date;
    year?: number;
    month?: number;
    day?: number;
    monthName: string;
    dayOfWeek: string;
    dayOfYear?: number;
    submissionYear: string;
    studentCountFacts: string;
    factStudentDisciplines: string;
    factStudentAssessments: string;
    factPersonnelCounts: string;
    factOrganizationCounts: string;
    bridgeDirectoryDate: string;
    bridgeStudentDate: string;
    bridgePersonnelDate: string;
    bridgeSchoolDate: string;
    isSelected?: boolean;
    dataMigrationTypeId: number;
}

export interface DimDateDataMigrationType {
    dimDateId: number;
    dataMigrationTypeId: number;
    isSelected: boolean;
}

