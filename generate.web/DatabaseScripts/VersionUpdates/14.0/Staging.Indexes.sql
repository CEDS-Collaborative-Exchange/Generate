IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_K12Enrollment_DataCollectionName'
      AND object_id = OBJECT_ID('Staging.K12Enrollment')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_K12Enrollment_DataCollectionName]
        ON [Staging].[K12Enrollment]([DataCollectionName] ASC)
        INCLUDE([StudentIdentifierState], [LeaIdentifierSeaAccountability], [LeaIdentifierSeaAttendance], [LeaIdentifierSeaFunding], [LeaIdentifierSeaGraduation], [LeaIdentifierSeaIndividualizedEducationProgram], [SchoolIdentifierSea], [EnrollmentEntryDate], [EnrollmentExitDate], [SchoolYear]);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Staging_K12Enrollment_StuId_SchId_Hispanic_RecordStartDateTime'
      AND object_id = OBJECT_ID('Staging.K12Enrollment')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Staging_K12Enrollment_StuId_SchId_Hispanic_RecordStartDateTime]
        ON [Staging].[K12Enrollment]([StudentIdentifierState] ASC, [SchoolIdentifierSea] ASC, [HispanicLatinoEthnicity] ASC, [RecordStartDateTime] ASC);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Staging_K12Enrollment_WithIdentifiers'
      AND object_id = OBJECT_ID('Staging.K12Enrollment')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Staging_K12Enrollment_WithIdentifiers]
        ON [Staging].[K12Enrollment]([DataCollectionName] ASC, [StudentIdentifierState] ASC, [LeaIdentifierSeaAccountability] ASC, [LeaIdentifierSeaAttendance] ASC, [LeaIdentifierSeaFunding] ASC, [LeaIdentifierSeaGraduation] ASC, [LeaIdentifierSeaIndividualizedEducationProgram] ASC, [SchoolIdentifierSea] ASC, [EnrollmentEntryDate] ASC)
        INCLUDE([Birthdate], [EnrollmentExitDate], [FirstName], [FullTimeEquivalency], [LastOrSurname], [MiddleName], [ProjectedGraduationDate], [RecordStartDateTime], [SchoolYear], [Sex]);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Staging_K12Organization_Lea_IsReportedFederally'
      AND object_id = OBJECT_ID('Staging.K12Organization')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Staging_K12Organization_Lea_IsReportedFederally]
        ON [Staging].[K12Organization]([Lea_IsReportedFederally] ASC)
        INCLUDE([LeaIdentifierSea]);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Staging_K12Organization_School_RecordStartDateTime'
      AND object_id = OBJECT_ID('Staging.K12Organization')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Staging_K12Organization_School_RecordStartDateTime]
        ON [Staging].[K12Organization]([School_RecordStartDateTime] ASC)
        INCLUDE([SchoolIdentifierSea], [School_TitleISchoolStatus], [School_RecordEndDateTime]);
END;

IF NOT EXISTS (
	SELECT 1
	FROM sys.indexes
	WHERE name = 'IX_Staging_OrganizationGradesOffered_OrganizationIdentifier'
	  AND object_id = OBJECT_ID('Staging.OrganizationGradeOffered')
)
BEGIN
	CREATE NONCLUSTERED INDEX [IX_Staging_OrganizationGradesOffered_OrganizationIdentifier]
		ON [Staging].[OrganizationGradeOffered]([OrganizationIdentifier] ASC)
		WITH (FILLFACTOR = 100, STATISTICS_NORECOMPUTE = ON);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_OrganizationProgramType_OrganizationIdentifier_ProgramType'
      AND object_id = OBJECT_ID('Staging.OrganizationProgramType')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_OrganizationProgramType_OrganizationIdentifier_ProgramType]
        ON [Staging].[OrganizationProgramType]([OrganizationIdentifier] ASC, [ProgramType] ASC)
        WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
END;


IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'Staging_PersonStatus_WithIdentifiers'
      AND object_id = OBJECT_ID('Staging.PersonStatus')
)
BEGIN
    DROP INDEX [Staging_PersonStatus_WithIdentifiers] ON [Staging].[PersonStatus];
END;

CREATE NONCLUSTERED INDEX [Staging_PersonStatus_WithIdentifiers]
    ON [Staging].[PersonStatus]([DataCollectionName] ASC, [LeaIdentifierSeaAccountability] ASC, [LeaIdentifierSeaAttendance] ASC, [LeaIdentifierSeaFunding] ASC, [LeaIdentifierSeaGraduation] ASC, [LeaIdentifierSeaIndividualizedEducationProgram] ASC, [SchoolIdentifierSea] ASC, [StudentIdentifierState] ASC);

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Staging_ProgramParticipationNorD_DataCollectionName'
      AND object_id = OBJECT_ID('Staging.ProgramParticipationNorD')
)
BEGIN
    DROP INDEX [IX_Staging_ProgramParticipationNorD_DataCollectionName] ON [Staging].[ProgramParticipationNorD];
END;

CREATE NONCLUSTERED INDEX [IX_Staging_ProgramParticipationNorD_DataCollectionName]
    ON [Staging].[ProgramParticipationNorD]([DataCollectionName] ASC)
    INCLUDE([LeaIdentifierSeaAccountability], [LeaIdentifierSeaAttendance], [LeaIdentifierSeaFunding], [LeaIdentifierSeaGraduation], [LeaIdentifierSeaIndividualizedEducationProgram], [SchoolIdentifierSea], [StudentIdentifierState]);

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Staging_ProgramParticipationSpecialEducation_ProgramParticipationExitDate'
      AND object_id = OBJECT_ID('Staging.ProgramParticipationSpecialEducation')
)
BEGIN
    DROP INDEX [IX_Staging_ProgramParticipationSpecialEducation_ProgramParticipationExitDate] ON [Staging].[ProgramParticipationSpecialEducation];
END;

CREATE NONCLUSTERED INDEX [IX_Staging_ProgramParticipationSpecialEducation_ProgramParticipationExitDate]
    ON [Staging].[ProgramParticipationSpecialEducation]([ProgramParticipationExitDate] ASC)
    INCLUDE([StudentIdentifierState], [LeaIdentifierSeaAccountability], [SchoolIdentifierSea]);

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Staging_ProgramParticipationSpecialEducation_StudentIdentifierState_LeaIdentifierSeaAccountability'
      AND object_id = OBJECT_ID('Staging.ProgramParticipationSpecialEducation')
)
BEGIN
    DROP INDEX [IX_Staging_ProgramParticipationSpecialEducation_StudentIdentifierState_LeaIdentifierSeaAccountability] ON [Staging].[ProgramParticipationSpecialEducation];
END;

CREATE NONCLUSTERED INDEX [IX_Staging_ProgramParticipationSpecialEducation_StudentIdentifierState_LeaIdentifierSeaAccountability]
    ON [Staging].[ProgramParticipationSpecialEducation]([StudentIdentifierState] ASC, [LeaIdentifierSeaAccountability] ASC)
    INCLUDE([ProgramParticipationExitDate]);

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Staging_ProgramParticipationSpecialEducation_WithIdentifiers'
      AND object_id = OBJECT_ID('Staging.ProgramParticipationSpecialEducation')
)
BEGIN
    DROP INDEX [IX_Staging_ProgramParticipationSpecialEducation_WithIdentifiers] ON [Staging].[ProgramParticipationSpecialEducation];
END;

CREATE NONCLUSTERED INDEX [IX_Staging_ProgramParticipationSpecialEducation_WithIdentifiers]
    ON [Staging].[ProgramParticipationSpecialEducation]([DataCollectionName] ASC, [StudentIdentifierState] ASC, [LeaIdentifierSeaAccountability] ASC, [LeaIdentifierSeaAttendance] ASC, [LeaIdentifierSeaFunding] ASC, [LeaIdentifierSeaGraduation] ASC, [LeaIdentifierSeaIndividualizedEducationProgram] ASC, [SchoolIdentifierSea] ASC)
    INCLUDE([ProgramParticipationStartDate], [ProgramParticipationExitDate], [SpecialEducationFTE]);

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Staging_ProgramParticipationTitleIII_DataCollectionName_WithIdentifiers'
      AND object_id = OBJECT_ID('Staging.ProgramParticipationTitleIII')
)
BEGIN
    DROP INDEX [IX_Staging_ProgramParticipationTitleIII_DataCollectionName_WithIdentifiers] ON [Staging].[ProgramParticipationTitleIII];
END;

CREATE NONCLUSTERED INDEX [IX_Staging_ProgramParticipationTitleIII_DataCollectionName_WithIdentifiers]
    ON [Staging].[ProgramParticipationTitleIII]([DataCollectionName] ASC)
    INCLUDE([LeaIdentifierSeaAccountability], [LeaIdentifierSeaAttendance], [LeaIdentifierSeaFunding], [LeaIdentifierSeaGraduation], [LeaIdentifierSeaIndividualizedEducationProgram], [SchoolIdentifierSea], [StudentIdentifierState]);


IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_PsPersonRace_AcademicTermDesignator'
      AND object_id = OBJECT_ID('Staging.PsPersonRace')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_PsPersonRace_AcademicTermDesignator]
        ON [Staging].[PsPersonRace]([AcademicTermDesignator] ASC)
        WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
END;


IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_PsPersonRace_RaceType'
      AND object_id = OBJECT_ID('Staging.PsPersonRace')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_PsPersonRace_RaceType]
        ON [Staging].[PsPersonRace]([RaceType] ASC)
        WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_PsStudentAcademicRecord_AcademicTermDesignator'
      AND object_id = OBJECT_ID('Staging.PsStudentAcademicRecord')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_PsStudentAcademicRecord_AcademicTermDesignator]
        ON [Staging].[PsStudentAcademicRecord]([AcademicTermDesignator] ASC)
        INCLUDE([StudentIdentifierState], [SchoolYear], [EntryDate])
        WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
END;



