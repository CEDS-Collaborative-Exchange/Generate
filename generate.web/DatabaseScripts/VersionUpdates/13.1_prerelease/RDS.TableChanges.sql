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


/**************
CIID-8062
**************/
--Create the new Fact Type
	IF NOT EXISTS(SELECT 1 FROM RDS.DimFactTypes WHERE FactTypeCode = 'schoolperformanceindicators')
	BEGIN
        insert into RDS.DimFactTypes
        values ('schoolperformanceindicators','SCHOOLPERFORMANCEINDICATORS - 199, 200, 201, 202, 205', 'School Performance Indicators');
    END

--Remove the reports from the previous Fact Type
    update RDS.DimFactTypes
    set FactTypeDescription = 'ORGANIZATIONSTATUS -'
        , FactTypeLabel = 'Organization Status'
    where FactTypeCode = 'organizationstatus';

--Update the report to Fact Type relationship
    update gf
    set FactTypeId = (select DimFactTypeId from rds.DimFactTypes where FactTypeCode = 'schoolperformanceindicators')
    from app.GenerateReport_FactType gf
        inner join app.GenerateReports r
            on gf.GenerateReportId = r.GenerateReportId
    where reportcode in ('199','200','201','202','205')

--Drop any constraints on the Fact table that reference the deprecated Fact table
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'';    

    SELECT @sql = @sql + 
        'ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
    FROM sys.foreign_keys fk
    INNER JOIN sys.tables t ON fk.parent_object_id = t.object_id
    WHERE t.name = 'OrganizationCounts'
    AND SCHEMA_NAME(t.schema_id) = 'RDS';

    EXEC sp_executesql @sql;

--Drop the deprecated Fact table
    IF OBJECT_ID('RDS.FactOrganizationStatusCounts', 'U') IS NOT NULL
        DROP TABLE RDS.FactOrganizationStatusCounts;

--Drop and Recreate the Fact table
    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicatorStateDefinedStatuses];

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicators];

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimRaces];

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimK12Demographics];

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimIdeaStatuses];

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimFactTypes];

    IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[FactSchoolPerformanceIndicators]') AND type in (N'U'))
        DROP TABLE [RDS].[FactSchoolPerformanceIndicators];

    CREATE TABLE [RDS].[FactSchoolPerformanceIndicators](
        [FactSchoolPerformanceIndicatorId] [int] IDENTITY(1,1) NOT NULL,
        [FactTypeId] [int] NOT NULL,
        [LeaId] [int] NOT NULL,
        [K12SchoolId] [int] NOT NULL,
        [SchoolYearId] [int] NOT NULL,
        [RaceId] [int] NULL,
        [IdeaStatusId] [int] NULL,
        [K12DemographicId] [int] NULL,
        [EconomicallyDisadvantagedStatusId] [int] NULL,
        [EnglishLearnerStatusId] [int] NULL,
        [SchoolPerformanceIndicatorCategoryId] [int] NULL,
        [SchoolPerformanceIndicatorId] [int] NULL,
        [SchoolPerformanceIndicatorStateDefinedStatusId] [int] NULL,
        [SchoolQualityOrStudentSuccessIndicatorId] [int] NULL,
        [IndicatorStatusId] [int] NULL,
        [SubgroupId] [int] NULL,
    CONSTRAINT [PK_FactSchoolPerformanceIndicators] PRIMARY KEY CLUSTERED 
    (
        [FactSchoolPerformanceIndicatorId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
    ) ON [PRIMARY];

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators]  WITH CHECK ADD  CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimFactTypes] FOREIGN KEY([FactTypeId])
    REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId]);

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimFactTypes];

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators]  WITH CHECK ADD  CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimIdeaStatuses] FOREIGN KEY([IdeaStatusId])
    REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId]);

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimIdeaStatuses];

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators]  WITH CHECK ADD  CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimK12Demographics] FOREIGN KEY([K12DemographicId])
    REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]);

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimK12Demographics];

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators]  WITH CHECK ADD  CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimRaces] FOREIGN KEY([RaceId])
    REFERENCES [RDS].[DimRaces] ([DimRaceId]);

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimRaces];

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators]  WITH CHECK ADD  CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicators] FOREIGN KEY([SchoolPerformanceIndicatorId])
    REFERENCES [RDS].[DimSchoolPerformanceIndicators] ([DimSchoolPerformanceIndicatorId]);

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicators];

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators]  WITH CHECK ADD  CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicatorStateDefinedStatuses] FOREIGN KEY([SchoolPerformanceIndicatorStateDefinedStatusId])
    REFERENCES [RDS].[DimSchoolPerformanceIndicatorStateDefinedStatuses] ([DimSchoolPerformanceIndicatorStateDefinedStatusId]);

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicatorStateDefinedStatuses];

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators]  WITH CHECK ADD  CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimIndicatorStatuses] FOREIGN KEY([IndicatorStatusId])
    REFERENCES [RDS].[DimIndicatorStatuses] ([DimIndicatorStatusId]);

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimIndicatorStatuses];

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators]  WITH CHECK ADD  CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSubgroups] FOREIGN KEY([SubgroupId])
    REFERENCES [RDS].[DimSubgroups] ([DimSubgroupId]);

    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSubgroups];

    --Add the required columns to the Report table

   	IF COL_LENGTH('RDS.ReportEDFactsSchoolPerformanceIndicators', 'INDICATORTYPE') IS NULL
	BEGIN
		ALTER TABLE RDS.ReportEDFactsSchoolPerformanceIndicators ADD INDICATORTYPE VARCHAR(50) NULL;
	END

    IF COL_LENGTH('RDS.ReportEdFactsK12StudentAssessments', 'NEGLECTEDPROGRAMTYPE') IS NULL
	BEGIN
		ALTER TABLE [RDS].[ReportEdFactsK12StudentAssessments] ADD [NEGLECTEDPROGRAMTYPE] NVARCHAR(50) NULL;
	END

     IF COL_LENGTH('RDS.ReportEDFactsK12StudentCounts', 'NEGLECTEDPROGRAMTYPE') IS NULL
	BEGIN
		ALTER TABLE [RDS].[ReportEDFactsK12StudentCounts] ADD [NEGLECTEDPROGRAMTYPE] NVARCHAR(50) NULL;
	END

     IF COL_LENGTH('RDS.ReportEDFactsK12StudentCounts', 'DELINQUENTPROGRAMTYPE') IS NULL
	BEGIN
		ALTER TABLE [RDS].[ReportEDFactsK12StudentCounts] ADD [DELINQUENTPROGRAMTYPE] NVARCHAR(50) NULL;
	END