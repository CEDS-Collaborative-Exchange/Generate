

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

IF COL_LENGTH('Staging.K12Organization', 'IEU_OrganizationName') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Ieu_OrganizationName') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.IEU_OrganizationName',
        'Ieu_OrganizationName',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'IEU_OperationalStatusEffectiveDate') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Ieu_OperationalStatusEffectiveDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.IEU_OperationalStatusEffectiveDate',
        'Ieu_OperationalStatusEffectiveDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'IEU_OrganizationOperationalStatus') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Ieu_OrganizationOperationalStatus') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.IEU_OrganizationOperationalStatus',
        'Ieu_OrganizationOperationalStatus',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'IEU_WebSiteAddress') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Ieu_WebSiteAddress') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.IEU_WebSiteAddress',
        'Ieu_WebSiteAddress',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'IEU_RecordStartDateTime') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Ieu_RecordStartDateTime') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.IEU_RecordStartDateTime',
        'Ieu_RecordStartDateTime',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'IEU_RecordEndDateTime') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Ieu_RecordEndDateTime') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.IEU_RecordEndDateTime',
        'Ieu_RecordEndDateTime',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_SupervisoryUnionIdentificationNumber') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_SupervisoryUnionIdentificationNumber') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_SupervisoryUnionIdentificationNumber',
        'Lea_SupervisoryUnionIdentificationNumber',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_WebSiteAddress') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_WebSiteAddress') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_WebSiteAddress',
        'Lea_WebSiteAddress',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_OperationalStatus') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_OperationalStatus') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_OperationalStatus',
        'Lea_OperationalStatus',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_OperationalStatusEffectiveDate') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_OperationalStatusEffectiveDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_OperationalStatusEffectiveDate',
        'Lea_OperationalStatusEffectiveDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_CharterLeaStatus') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_CharterLeaStatus') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_CharterLeaStatus',
        'Lea_CharterLeaStatus',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_CharterSchoolIndicator') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_CharterSchoolIndicator') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_CharterSchoolIndicator',
        'Lea_CharterSchoolIndicator',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_Type') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_Type') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_Type',
        'Lea_Type',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_McKinneyVentoSubgrantRecipient') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_McKinneyVentoSubgrantRecipient') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_McKinneyVentoSubgrantRecipient',
        'Lea_McKinneyVentoSubgrantRecipient',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_GunFreeSchoolsActReportingStatus') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_GunFreeSchoolsActReportingStatus') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_GunFreeSchoolsActReportingStatus',
        'Lea_GunFreeSchoolsActReportingStatus',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_TitleIinstructionalService') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_TitleIinstructionalService') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_TitleIinstructionalService',
        'Lea_TitleIinstructionalService',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_TitleIProgramType') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_TitleIProgramType') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_TitleIProgramType',
        'Lea_TitleIProgramType',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_K12LeaTitleISupportService') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_K12LeaTitleISupportService') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_K12LeaTitleISupportService',
        'Lea_K12LeaTitleISupportService',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_MepProjectType') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_MepProjectType') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_MepProjectType',
        'Lea_MepProjectType',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_IsReportedFederally') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_IsReportedFederally') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_IsReportedFederally',
        'Lea_IsReportedFederally',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_RecordStartDateTime') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_RecordStartDateTime') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_RecordStartDateTime',
        'Lea_RecordStartDateTime',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_RecordEndDateTime') IS NOT NULL
   AND COL_LENGTH('Staging.K12Organization', 'Lea_RecordEndDateTime') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_RecordEndDateTime',
        'Lea_RecordEndDateTime',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'SchoolIdentifierAct') IS NULL
BEGIN
    ALTER TABLE Staging.K12Organization
    ADD SchoolIdentifierAct NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12Organization', 'SchoolIdentifierSat') IS NULL
BEGIN
    ALTER TABLE Staging.K12Organization
    ADD SchoolIdentifierSat NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12Organization', 'School_CharterSchoolStateAppropriationMethod') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12Organization
    DROP COLUMN School_CharterSchoolStateAppropriationMethod;
END;

IF COL_LENGTH('Staging.K12SchoolComprehensiveSupportIdentificationType', 'LEAIdentifierSea') IS NOT NULL
   AND COL_LENGTH('Staging.K12SchoolComprehensiveSupportIdentificationType', 'LeaIdentifierSea') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12SchoolComprehensiveSupportIdentificationType.LEAIdentifierSea',
        'LeaIdentifierSea',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12SchoolComprehensiveSupportIdentificationType', 'DataCollectionName') IS NULL
BEGIN
    ALTER TABLE Staging.K12SchoolComprehensiveSupportIdentificationType
    ADD DataCollectionName NVARCHAR (100) NULL;
END;



DECLARE @K12SupportColumnName SYSNAME;
DECLARE @K12SupportMaxLength INT;
DECLARE @K12SupportIsNullable NVARCHAR(3);
DECLARE @K12SupportAlterSql NVARCHAR(MAX);

DECLARE K12SupportVarcharColumnsCursor CURSOR LOCAL FAST_FORWARD FOR
SELECT COLUMN_NAME,
             CHARACTER_MAXIMUM_LENGTH,
             IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Staging'
    AND TABLE_NAME = 'K12SchoolComprehensiveSupportIdentificationType'
    AND COLUMN_NAME IN (
            'SchoolYear',
            'SchoolIdentifierSea',
            'ComprehensiveSupport',
            'ComprehensiveSupportReasonApplicability',
            'LeaIdentifierSea'
    )
    AND DATA_TYPE = 'varchar';

OPEN K12SupportVarcharColumnsCursor;

FETCH NEXT FROM K12SupportVarcharColumnsCursor
INTO @K12SupportColumnName, @K12SupportMaxLength, @K12SupportIsNullable;

WHILE @@FETCH_STATUS = 0
BEGIN
        SET @K12SupportAlterSql =
                'ALTER TABLE Staging.K12SchoolComprehensiveSupportIdentificationType ALTER COLUMN ['
                + @K12SupportColumnName
                + '] NVARCHAR('
                + CASE
                        WHEN @K12SupportMaxLength = -1 THEN 'MAX'
                        ELSE CAST(@K12SupportMaxLength AS NVARCHAR(10))
                    END
                + ') '
                + CASE
                        WHEN @K12SupportIsNullable = 'YES' THEN 'NULL'
                        ELSE 'NOT NULL'
                    END
                + ';';

        EXEC sp_executesql @K12SupportAlterSql;

        FETCH NEXT FROM K12SupportVarcharColumnsCursor
        INTO @K12SupportColumnName, @K12SupportMaxLength, @K12SupportIsNullable;
END;

CLOSE K12SupportVarcharColumnsCursor;
DEALLOCATE K12SupportVarcharColumnsCursor;


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

