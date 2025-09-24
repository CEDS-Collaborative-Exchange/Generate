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

