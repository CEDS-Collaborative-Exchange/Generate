/************************************************************
Staging.SchoolPerformanceIndicators
************************************************************/

--find and drop all extended properties on the table and columns
    DECLARE @sql NVARCHAR(MAX) = N'';

    SELECT @sql = @sql + '
    EXEC sys.sp_dropextendedproperty 
        @name = N''' + ep.name + ''', 
        @level0type = N''SCHEMA'', @level0name = N''Staging'', 
        @level1type = N''TABLE'', @level1name = N''SchoolPerformanceIndicators''' +
        CASE 
            WHEN ep.minor_id > 0 THEN 
                ', @level2type = N''COLUMN'', @level2name = N''' + c.name + ''''
            ELSE ''
        END + ';
    '
    FROM sys.extended_properties ep
    INNER JOIN sys.objects o ON ep.major_id = o.object_id
    LEFT JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
    WHERE o.name = 'SchoolPerformanceIndicators'
    AND SCHEMA_NAME(o.schema_id) = 'Staging';

    EXEC sp_executesql @sql;

-- Find and drop all foreign keys on Staging.SchoolPerformanceIndicators
    SET @sql = N'';    

    SELECT @sql = @sql + 
        'ALTER TABLE [Staging].[SchoolPerformanceIndicators] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
    FROM sys.foreign_keys fk
    INNER JOIN sys.tables t ON fk.parent_object_id = t.object_id
    WHERE t.name = 'SchoolPerformanceIndicators'
    AND SCHEMA_NAME(t.schema_id) = 'Staging';

    EXEC sp_executesql @sql;


--Drop the table if it exists
    IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Staging].[SchoolPerformanceIndicators]') AND type in (N'U'))
    DROP TABLE [Staging].[SchoolPerformanceIndicators];

--Add the reconstructed table 
    CREATE TABLE [Staging].[SchoolPerformanceIndicators](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [LeaIdentifierSea] [nvarchar](50) NOT NULL,
        [SchoolIdentifierSea] [nvarchar](50) NOT NULL,
        [SchoolYear] [smallint] NULL,
        [SchoolPerformanceIndicatorCategory] [varchar](100) NULL,
        [SchoolPerformanceIndicatorType] [varchar](100) NULL,
        [SchoolPerformanceIndicatorStatus] [varchar](100) NULL,
        [SchoolPerformanceIndicatorStateDefinedStatus] [varchar](100) NULL,
        [SchoolPerformanceIndicatorStateDefinedStatusDescription] [varchar](200) NULL,
        [SchoolQualityOrStudentSuccessIndicatorType] [varchar](100) NULL,
        [RaceEthnicity] [varchar](100) NULL,
        [IdeaIndicator] [varchar](100) NULL,
        [EnglishLearnerStatus] [varchar](100) NULL,
        [EconomicDisadvantageStatus] [varchar](100) NULL,
        [SubgroupCode] [varchar](100) NULL,
        [RecordStartDateTime] [datetime] NULL,
        [RecordEndDateTime] [datetime] NULL,
        [DataCollectionName] [nvarchar](100) NULL,
    CONSTRAINT [PK_SchoolPerformanceIndicators] PRIMARY KEY CLUSTERED 
    (
        [Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
    ) ON [PRIMARY]

--Add the extended properties back to the table and columns
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to a local education agency by a school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSea'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Local Education Agency Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSea'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001068' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSea'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21153' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSea'
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSea'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to an institution by a school, school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001069' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21155' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea'
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year for a reported school session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'SchoolYear'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'SchoolYear'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'SchoolYear'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'SchoolYear'
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'SchoolYear'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The start date and, optionally, time that a record is active as used to support version control.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Record Start Date Time' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001917' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22898' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The end date and, optionally, time that a record is active as used to support version control.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Record End Date Time' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001918' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22899' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that the student met the State criteria for classification as having an economic disadvantage.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'EconomicDisadvantageStatus'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Economic Disadvantage Status' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'EconomicDisadvantageStatus'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000086' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'EconomicDisadvantageStatus'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21086' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'EconomicDisadvantageStatus'
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'EconomicDisadvantageStatus'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'In coordination with the state''s definition based on Section 8101(20) of the ESEA, as amended by the ESSA, the term ''English learner'', when used with respect to an individual, means an individual:  (A) who is aged 3 through 21;  (B) who is enrolled or preparing to enroll in an elementary school or a secondary school;  (C)   (i) who was not born in the United States or whose native languages are languages other than English;  (ii)   (I) who is a Native American or Alaska Native, or a native resident of the outlying areas; and  (II) who comes from an environment where a language other than English has had a significant impact on the individual''s level of English language proficiency; or  (iii) who is migratory, whose native language is a language other than English, and who come from an environment where a language other than English is dominant; and  (D) whose difficulties in speaking, reading, writing, or understanding the English language may be sufficient to deny the individual   (i) the ability to meet the challenging State academic standards;  (ii) the ability to successfully achieve in classrooms where the language of instruction is English; or  (iii) the opportunity to participate fully in society.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'EnglishLearnerStatus'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'English Learner Status' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'EnglishLearnerStatus'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000180' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'EnglishLearnerStatus'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21180' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'EnglishLearnerStatus'
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'EnglishLearnerStatus'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A person having intellectual disability; hearing impairment, including deafness; speech or language impairment; visual impairment, including blindness; serious emotional disturbance (hereafter referred to as emotional disturbance); orthopedic impairment; autism; traumatic brain injury; developmental delay; other health impairment; specific learning disability; deaf-blindness; or multiple disabilities and who, by reason thereof, receive special education and related services under the Individuals with Disabilities Education Act (IDEA) according to an Individualized Education Program (IEP), Individual Family Service Plan (IFSP), or service plan.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'IDEAIndicator'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'IDEA Indicator' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'IDEAIndicator'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000151' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'IDEAIndicator'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21151' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'IDEAIndicator'
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'IDEAIndicator'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'SchoolPerformanceIndicators', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

--Drop the tables that are no longer needed
    IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Staging].[SchoolPerformanceIndicatorStateDefinedStatus]') AND type in (N'U'))
        DROP TABLE [Staging].[SchoolPerformanceIndicatorStateDefinedStatus]

    IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Staging].[SchoolQualityOrStudentSuccessIndicatorType]') AND type in (N'U'))
        DROP TABLE [Staging].[SchoolQualityOrStudentSuccessIndicatorType]









































--Add the dimension table DimCteOutcomeIndicators
	IF EXISTS(SELECT 1
	FROM
		sys.foreign_keys AS fk
		JOIN sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
		JOIN sys.columns AS c ON fkc.parent_object_id = c.object_id AND fkc.parent_column_id = c.column_id
		JOIN sys.tables AS t ON fk.parent_object_id = t.object_id
	WHERE
		fk.name = 'FK_FactK12StudentCounts_CteOutcomeIndicatorId')
	BEGIN
        ALTER TABLE [RDS].[FactK12StudentCounts]  DROP CONSTRAINT [FK_FactK12StudentCounts_CteOutcomeIndicatorId] 
	END

    IF OBJECT_ID('RDS.DimCteOutcomeIndicators', 'U') IS NOT NULL
        DROP TABLE RDS.DimCteOutcomeIndicators;

    CREATE TABLE [RDS].[DimCteOutcomeIndicators] (
        [DimCteOutcomeIndicatorId]                                      INT            IDENTITY (1, 1) NOT NULL,
        [EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode]            NVARCHAR (100) NOT NULL,
        [EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription]     NVARCHAR (300) NOT NULL,
        [EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode]     VARCHAR (50)   NOT NULL,
        [EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode]        NVARCHAR (100) NOT NULL,
        [EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription] NVARCHAR (300) NOT NULL,
        [EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode] VARCHAR (50)   NOT NULL,
        [PerkinsPostProgramPlacementIndicatorCode]                      NVARCHAR (100) NOT NULL,
        [PerkinsPostProgramPlacementIndicatorDescription]               NVARCHAR (300) NOT NULL,
        CONSTRAINT [PK_DimCteOutcomeIndicators] PRIMARY KEY CLUSTERED ([DimCteOutcomeIndicatorId] ASC)
    );


    ALTER TABLE [RDS].[DimCteOutcomeIndicators]
        ADD CONSTRAINT [DF_DimCteOutcomeIndicators_EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode] 
            DEFAULT ('MISSING') FOR [EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode];

    ALTER TABLE [RDS].[DimCteOutcomeIndicators]
        ADD CONSTRAINT [DF_DimCteOutcomeIndicators_EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription] 
            DEFAULT ('MISSING') FOR [EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription];

    ALTER TABLE [RDS].[DimCteOutcomeIndicators]
        ADD CONSTRAINT [DF_DimCteOutcomeIndicators_EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode] 
            DEFAULT ('MISSING') FOR [EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode];

    ALTER TABLE [RDS].[DimCteOutcomeIndicators]
        ADD CONSTRAINT [DF_DimCteOutcomeIndicators_EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode] 
            DEFAULT ('MISSING') FOR [EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode];

    ALTER TABLE [RDS].[DimCteOutcomeIndicators]
        ADD CONSTRAINT [DF_DimCteOutcomeIndicators_EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription] 
            DEFAULT ('MISSING') FOR [EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription];

    ALTER TABLE [RDS].[DimCteOutcomeIndicators]
        ADD CONSTRAINT [DF_DimCteOutcomeIndicators_EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode] 
            DEFAULT ('MISSING') FOR [EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode];

    ALTER TABLE [RDS].[DimCteOutcomeIndicators]
        ADD CONSTRAINT [DF_DimCteOutcomeIndicators_PerkinsPostProgramPlacementIndicatorCode] 
            DEFAULT ('MISSING') FOR [PerkinsPostProgramPlacementIndicatorCode];

    ALTER TABLE [RDS].[DimCteOutcomeIndicators]
        ADD CONSTRAINT [DF_DimCteOutcomeIndicators_PerkinsPostProgramPlacementIndicatorDescription] 
            DEFAULT ('MISSING') FOR [PerkinsPostProgramPlacementIndicatorDescription];


    EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'The type of academic or career and technical outcome attained while enrolled in the program.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'EdFacts Academic or Career and Technical Outcome Type', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001978', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode';
    EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/element/001978', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode';
    EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'The type of academic or career and technical outcome attained while enrolled in the program.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'EdFacts Academic or Career and Technical Outcome Type', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001978', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription';
    EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/element/001978', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription';
    EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'The type of academic or career and technical outcome attained up to 90 days after exiting the facility or program.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'EdFacts Academic or Career and Technical Outcome Exit Type', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001979', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode';
    EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/element/001979', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode';
    EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'The type of academic or career and technical outcome attained up to 90 days after exiting the facility or program.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'EdFacts Academic or Career and Technical Outcome Exit Type', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001979', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription';
    EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/element/001979', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription';
    EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'PerkinsPostProgramPlacementIndicatorCode';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'An indication of the post-program status of a CTE Concentrator in the second quarter after exiting from secondary education.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'PerkinsPostProgramPlacementIndicatorCode';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Perkins Post-Program Placement Indicator', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'PerkinsPostProgramPlacementIndicatorCode';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'002087', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'PerkinsPostProgramPlacementIndicatorCode';
    EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/element/002087', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'PerkinsPostProgramPlacementIndicatorCode';
    EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'PerkinsPostProgramPlacementIndicatorDescription';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'An indication of the post-program status of a CTE Concentrator in the second quarter after exiting from secondary education.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'PerkinsPostProgramPlacementIndicatorDescription';
    EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Perkins Post-Program Placement Indicator', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'PerkinsPostProgramPlacementIndicatorDescription';
    EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'002087', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'PerkinsPostProgramPlacementIndicatorDescription';
    EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/element/002087', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCteOutcomeIndicators', @level2type = N'COLUMN', @level2name = N'PerkinsPostProgramPlacementIndicatorDescription';

    -- Add the column to the FactK12StudentCounts table
	IF COL_LENGTH('RDS.FactK12StudentCounts', 'CteOutcomeIndicatorId') IS NULL
	BEGIN
        ALTER TABLE RDS.FactK12StudentCounts ADD CteOutcomeIndicatorId INT NOT NULL
            CONSTRAINT [DF_FactK12StudentCounts_CteOutcomeIndicatorId]  DEFAULT ((-1)) WITH VALUES;
	END

	IF NOT EXISTS(SELECT 1
	FROM
		sys.foreign_keys AS fk
		JOIN sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
		JOIN sys.columns AS c ON fkc.parent_object_id = c.object_id AND fkc.parent_column_id = c.column_id
		JOIN sys.tables AS t ON fk.parent_object_id = t.object_id
	WHERE
		fk.name = 'FK_FactK12StudentCounts_CteOutcomeIndicatorId')
	BEGIN
        ALTER TABLE [RDS].[FactK12StudentCounts]  WITH NOCHECK ADD CONSTRAINT [FK_FactK12StudentCounts_CteOutcomeIndicatorId] FOREIGN KEY([CteOutcomeIndicatorId])
            REFERENCES [RDS].[DimCteOutcomeIndicators] ([DimCteOutcomeIndicatorId])

    	ALTER TABLE [RDS].[FactK12StudentCounts] CHECK CONSTRAINT [FK_FactK12StudentCounts_CteOutcomeIndicatorId]
	END

