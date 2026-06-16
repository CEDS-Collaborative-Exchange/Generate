

IF COL_LENGTH('Staging.K12Enrollment', 'NumberOfSchoolDays') IS NOT NULL
   AND COL_LENGTH('Staging.K12Enrollment', 'NumberOfDaysInAttendance') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Enrollment.NumberOfSchoolDays',
        'NumberOfDaysInAttendance',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Enrollment', 'PostSecondaryEnrollmentAction') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12Enrollment
    DROP COLUMN PostSecondaryEnrollmentAction;
END;

IF COL_LENGTH('Staging.K12Enrollment', 'RunDateTime') IS NULL
BEGIN
    ALTER TABLE Staging.K12Enrollment
    ADD RunDateTime DATETIME NULL;
END;

IF COL_LENGTH('Staging.K12Enrollment', 'RecordStartDateTime') IS NOT NULL
   AND EXISTS (
       SELECT 1
       FROM INFORMATION_SCHEMA.COLUMNS
       WHERE TABLE_SCHEMA = 'Staging'
           AND TABLE_NAME = 'K12Enrollment'
           AND COLUMN_NAME = 'RecordStartDateTime'
           AND DATA_TYPE <> 'datetime'
   )
BEGIN
    EXEC (
        'ALTER TABLE Staging.K12Enrollment ALTER COLUMN RecordStartDateTime DATETIME NULL;'
    );
END;

IF COL_LENGTH('Staging.K12Enrollment', 'RecordEndDateTime') IS NOT NULL
   AND EXISTS (
       SELECT 1
       FROM INFORMATION_SCHEMA.COLUMNS
       WHERE TABLE_SCHEMA = 'Staging'
           AND TABLE_NAME = 'K12Enrollment'
           AND COLUMN_NAME = 'RecordEndDateTime'
           AND DATA_TYPE <> 'datetime'
   )
BEGIN
        EXEC (
        'ALTER TABLE Staging.K12Enrollment ALTER COLUMN RecordEndDateTime DATETIME NULL;'
    );
END;

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

IF EXISTS (
    SELECT 1
    FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
    INNER JOIN sys.tables t ON t.object_id = c.object_id
    INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE ep.name = N'CEDS_GlobalId'
      AND s.name = N'Staging'
      AND t.name = N'K12Enrollment'
      AND c.name = N'RecordEndDateTime'
)
BEGIN
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordEndDateTime';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001918', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordEndDateTime';

IF EXISTS (
    SELECT 1
    FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
    INNER JOIN sys.tables t ON t.object_id = c.object_id
    INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE ep.name = N'CEDS_URL'
      AND s.name = N'Staging'
      AND t.name = N'K12Enrollment'
      AND c.name = N'RecordEndDateTime'
)
BEGIN
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordEndDateTime';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22899', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordEndDateTime';

IF EXISTS (
    SELECT 1
    FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
    INNER JOIN sys.tables t ON t.object_id = c.object_id
    INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE ep.name = N'CEDS_GlobalId'
      AND s.name = N'Staging'
      AND t.name = N'K12Enrollment'
      AND c.name = N'RecordStartDateTime'
)
BEGIN
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordStartDateTime';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001917', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordStartDateTime';

IF EXISTS (
    SELECT 1
    FROM sys.extended_properties ep
    INNER JOIN sys.columns c ON c.object_id = ep.major_id AND c.column_id = ep.minor_id
    INNER JOIN sys.tables t ON t.object_id = c.object_id
    INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE ep.name = N'CEDS_URL'
      AND s.name = N'Staging'
      AND t.name = N'K12Enrollment'
      AND c.name = N'RecordStartDateTime'
)
BEGIN
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordStartDateTime';
END;

EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22898', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'RecordStartDateTime';

