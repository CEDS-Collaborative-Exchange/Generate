


PRINT N'Dropping Extended Property [RDS].[DimAcademicTermDesignators].[DimAcademicTermDesignatorId].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAcademicTermDesignators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAcademicTermDesignators'), N'DimAcademicTermDesignatorId', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAcademicTermDesignators', @level2type = N'COLUMN', @level2name = N'DimAcademicTermDesignatorId';



PRINT N'Dropping Extended Property [RDS].[DimAcademicTermDesignators].[DimAcademicTermDesignatorId].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAcademicTermDesignators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAcademicTermDesignators'), N'DimAcademicTermDesignatorId', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAcademicTermDesignators', @level2type = N'COLUMN', @level2name = N'DimAcademicTermDesignatorId';



PRINT N'Dropping Extended Property [RDS].[DimAcademicTermDesignators].[DimAcademicTermDesignatorId].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAcademicTermDesignators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAcademicTermDesignators'), N'DimAcademicTermDesignatorId', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAcademicTermDesignators', @level2type = N'COLUMN', @level2name = N'DimAcademicTermDesignatorId';



PRINT N'Dropping Extended Property [RDS].[DimAcademicTermDesignators].[DimAcademicTermDesignatorId].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAcademicTermDesignators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAcademicTermDesignators'), N'DimAcademicTermDesignatorId', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAcademicTermDesignators', @level2type = N'COLUMN', @level2name = N'DimAcademicTermDesignatorId';



PRINT N'Dropping Extended Property [RDS].[DimAcademicTermDesignators].[DimAcademicTermDesignatorId].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAcademicTermDesignators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAcademicTermDesignators'), N'DimAcademicTermDesignatorId', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAcademicTermDesignators', @level2type = N'COLUMN', @level2name = N'DimAcademicTermDesignatorId';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EconomicDisadvantageStatusCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EconomicDisadvantageStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EconomicDisadvantageStatusCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EconomicDisadvantageStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EconomicDisadvantageStatusCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EconomicDisadvantageStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EconomicDisadvantageStatusCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EconomicDisadvantageStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EconomicDisadvantageStatusCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EconomicDisadvantageStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EconomicDisadvantageStatusDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EconomicDisadvantageStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EconomicDisadvantageStatusDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EconomicDisadvantageStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EconomicDisadvantageStatusDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EconomicDisadvantageStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EconomicDisadvantageStatusDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EconomicDisadvantageStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EconomicDisadvantageStatusDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EconomicDisadvantageStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EnglishLearnerStatusCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EnglishLearnerStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EnglishLearnerStatusCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EnglishLearnerStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EnglishLearnerStatusCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EnglishLearnerStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EnglishLearnerStatusCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EnglishLearnerStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EnglishLearnerStatusCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EnglishLearnerStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EnglishLearnerStatusDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EnglishLearnerStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EnglishLearnerStatusDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EnglishLearnerStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EnglishLearnerStatusDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EnglishLearnerStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EnglishLearnerStatusDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EnglishLearnerStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[EnglishLearnerStatusDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'EnglishLearnerStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessnessStatusCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessnessStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessnessStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessnessStatusCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessnessStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessnessStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessnessStatusCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessnessStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessnessStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessnessStatusCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessnessStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessnessStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessnessStatusCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessnessStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessnessStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessnessStatusDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessnessStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessnessStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessnessStatusDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessnessStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessnessStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessnessStatusDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessnessStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessnessStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessnessStatusDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessnessStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessnessStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessnessStatusDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessnessStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessnessStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessPrimaryNighttimeResidenceCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessPrimaryNighttimeResidenceCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessPrimaryNighttimeResidenceCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessPrimaryNighttimeResidenceCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessPrimaryNighttimeResidenceCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessPrimaryNighttimeResidenceCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessPrimaryNighttimeResidenceCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessPrimaryNighttimeResidenceCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessPrimaryNighttimeResidenceCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessPrimaryNighttimeResidenceCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessPrimaryNighttimeResidenceCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessPrimaryNighttimeResidenceCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessPrimaryNighttimeResidenceCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessPrimaryNighttimeResidenceCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessPrimaryNighttimeResidenceCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessPrimaryNighttimeResidenceDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessPrimaryNighttimeResidenceDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessPrimaryNighttimeResidenceDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessPrimaryNighttimeResidenceDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessPrimaryNighttimeResidenceDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessPrimaryNighttimeResidenceDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessPrimaryNighttimeResidenceDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessPrimaryNighttimeResidenceDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessPrimaryNighttimeResidenceDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessPrimaryNighttimeResidenceDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessPrimaryNighttimeResidenceDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessPrimaryNighttimeResidenceDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessPrimaryNighttimeResidenceDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessPrimaryNighttimeResidenceDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessPrimaryNighttimeResidenceDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessUnaccompaniedYouthStatusCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessUnaccompaniedYouthStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessUnaccompaniedYouthStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessUnaccompaniedYouthStatusCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessUnaccompaniedYouthStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessUnaccompaniedYouthStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessUnaccompaniedYouthStatusCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessUnaccompaniedYouthStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessUnaccompaniedYouthStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessUnaccompaniedYouthStatusCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessUnaccompaniedYouthStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessUnaccompaniedYouthStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessUnaccompaniedYouthStatusCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessUnaccompaniedYouthStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessUnaccompaniedYouthStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessUnaccompaniedYouthStatusDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessUnaccompaniedYouthStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessUnaccompaniedYouthStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessUnaccompaniedYouthStatusDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessUnaccompaniedYouthStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessUnaccompaniedYouthStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessUnaccompaniedYouthStatusDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessUnaccompaniedYouthStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessUnaccompaniedYouthStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessUnaccompaniedYouthStatusDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessUnaccompaniedYouthStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessUnaccompaniedYouthStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[HomelessUnaccompaniedYouthStatusDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'HomelessUnaccompaniedYouthStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'HomelessUnaccompaniedYouthStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MigrantStatusCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MigrantStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MigrantStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MigrantStatusCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MigrantStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MigrantStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MigrantStatusCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MigrantStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MigrantStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MigrantStatusCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MigrantStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MigrantStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MigrantStatusCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MigrantStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MigrantStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MigrantStatusDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MigrantStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MigrantStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MigrantStatusDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MigrantStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MigrantStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MigrantStatusDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MigrantStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MigrantStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MigrantStatusDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MigrantStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MigrantStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MigrantStatusDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MigrantStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MigrantStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MilitaryConnectedStudentIndicatorCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MilitaryConnectedStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MilitaryConnectedStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MilitaryConnectedStudentIndicatorCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MilitaryConnectedStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MilitaryConnectedStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MilitaryConnectedStudentIndicatorCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MilitaryConnectedStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MilitaryConnectedStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MilitaryConnectedStudentIndicatorCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MilitaryConnectedStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MilitaryConnectedStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MilitaryConnectedStudentIndicatorCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MilitaryConnectedStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MilitaryConnectedStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MilitaryConnectedStudentIndicatorDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MilitaryConnectedStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MilitaryConnectedStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MilitaryConnectedStudentIndicatorDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MilitaryConnectedStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MilitaryConnectedStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MilitaryConnectedStudentIndicatorDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MilitaryConnectedStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MilitaryConnectedStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MilitaryConnectedStudentIndicatorDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MilitaryConnectedStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MilitaryConnectedStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeDemographics].[MilitaryConnectedStudentIndicatorDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeDemographics') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeDemographics'), N'MilitaryConnectedStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeDemographics', @level2type = N'COLUMN', @level2name = N'MilitaryConnectedStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimAeProviders].[AeServiceProviderIdentifierSea].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAeProviders') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeProviders'), N'AeServiceProviderIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeProviders', @level2type = N'COLUMN', @level2name = N'AeServiceProviderIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimAeProviders].[AeServiceProviderIdentifierSea].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAeProviders') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeProviders'), N'AeServiceProviderIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeProviders', @level2type = N'COLUMN', @level2name = N'AeServiceProviderIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimAeProviders].[AeServiceProviderIdentifierSea].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAeProviders') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeProviders'), N'AeServiceProviderIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeProviders', @level2type = N'COLUMN', @level2name = N'AeServiceProviderIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimAeProviders].[AeServiceProviderIdentifierSea].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAeProviders') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeProviders'), N'AeServiceProviderIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeProviders', @level2type = N'COLUMN', @level2name = N'AeServiceProviderIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimAeProviders].[AeServiceProviderIdentifierSea].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAeProviders') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAeProviders'), N'AeServiceProviderIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAeProviders', @level2type = N'COLUMN', @level2name = N'AeServiceProviderIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimAssessmentAdministrations].[LEAIdentifierSea].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAssessmentAdministrations') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAssessmentAdministrations'), N'LEAIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAssessmentAdministrations', @level2type = N'COLUMN', @level2name = N'LEAIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimAssessmentAdministrations].[LEAIdentifierSea].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAssessmentAdministrations') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAssessmentAdministrations'), N'LEAIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAssessmentAdministrations', @level2type = N'COLUMN', @level2name = N'LEAIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimAssessmentAdministrations].[LEAIdentifierSea].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAssessmentAdministrations') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAssessmentAdministrations'), N'LEAIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAssessmentAdministrations', @level2type = N'COLUMN', @level2name = N'LEAIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimAssessmentAdministrations].[LEAIdentifierSea].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAssessmentAdministrations') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAssessmentAdministrations'), N'LEAIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAssessmentAdministrations', @level2type = N'COLUMN', @level2name = N'LEAIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimAssessmentAdministrations].[LEAIdentifierSea].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAssessmentAdministrations') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAssessmentAdministrations'), N'LEAIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAssessmentAdministrations', @level2type = N'COLUMN', @level2name = N'LEAIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimAssessmentAdministrations].[SchoolIdentifierSea].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimAssessmentAdministrations') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAssessmentAdministrations'), N'SchoolIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAssessmentAdministrations', @level2type = N'COLUMN', @level2name = N'SchoolIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimAssessmentAdministrations].[SchoolIdentifierSea].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimAssessmentAdministrations') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAssessmentAdministrations'), N'SchoolIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAssessmentAdministrations', @level2type = N'COLUMN', @level2name = N'SchoolIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimAssessmentAdministrations].[SchoolIdentifierSea].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimAssessmentAdministrations') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAssessmentAdministrations'), N'SchoolIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAssessmentAdministrations', @level2type = N'COLUMN', @level2name = N'SchoolIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimAssessmentAdministrations].[SchoolIdentifierSea].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimAssessmentAdministrations') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAssessmentAdministrations'), N'SchoolIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAssessmentAdministrations', @level2type = N'COLUMN', @level2name = N'SchoolIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimAssessmentAdministrations].[SchoolIdentifierSea].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimAssessmentAdministrations') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimAssessmentAdministrations'), N'SchoolIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimAssessmentAdministrations', @level2type = N'COLUMN', @level2name = N'SchoolIdentifierSea';



PRINT N'Dropping Extended Property [RDS].[DimFederalFinancialExpenditureClassifications].[FinancialExpenditureProjectReportingCodeCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications'), N'FinancialExpenditureProjectReportingCodeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimFederalFinancialExpenditureClassifications', @level2type = N'COLUMN', @level2name = N'FinancialExpenditureProjectReportingCodeCode';



PRINT N'Dropping Extended Property [RDS].[DimFederalFinancialExpenditureClassifications].[FinancialExpenditureProjectReportingCodeCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications'), N'FinancialExpenditureProjectReportingCodeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimFederalFinancialExpenditureClassifications', @level2type = N'COLUMN', @level2name = N'FinancialExpenditureProjectReportingCodeCode';



PRINT N'Dropping Extended Property [RDS].[DimFederalFinancialExpenditureClassifications].[FinancialExpenditureProjectReportingCodeCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications'), N'FinancialExpenditureProjectReportingCodeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimFederalFinancialExpenditureClassifications', @level2type = N'COLUMN', @level2name = N'FinancialExpenditureProjectReportingCodeCode';



PRINT N'Dropping Extended Property [RDS].[DimFederalFinancialExpenditureClassifications].[FinancialExpenditureProjectReportingCodeCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications'), N'FinancialExpenditureProjectReportingCodeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimFederalFinancialExpenditureClassifications', @level2type = N'COLUMN', @level2name = N'FinancialExpenditureProjectReportingCodeCode';



PRINT N'Dropping Extended Property [RDS].[DimFederalFinancialExpenditureClassifications].[FinancialExpenditureProjectReportingCodeCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications'), N'FinancialExpenditureProjectReportingCodeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimFederalFinancialExpenditureClassifications', @level2type = N'COLUMN', @level2name = N'FinancialExpenditureProjectReportingCodeCode';



PRINT N'Dropping Extended Property [RDS].[DimFederalFinancialExpenditureClassifications].[FinancialExpenditureProjectReportingCodeDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications'), N'FinancialExpenditureProjectReportingCodeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimFederalFinancialExpenditureClassifications', @level2type = N'COLUMN', @level2name = N'FinancialExpenditureProjectReportingCodeDescription';



PRINT N'Dropping Extended Property [RDS].[DimFederalFinancialExpenditureClassifications].[FinancialExpenditureProjectReportingCodeDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications'), N'FinancialExpenditureProjectReportingCodeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimFederalFinancialExpenditureClassifications', @level2type = N'COLUMN', @level2name = N'FinancialExpenditureProjectReportingCodeDescription';



PRINT N'Dropping Extended Property [RDS].[DimFederalFinancialExpenditureClassifications].[FinancialExpenditureProjectReportingCodeDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications'), N'FinancialExpenditureProjectReportingCodeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimFederalFinancialExpenditureClassifications', @level2type = N'COLUMN', @level2name = N'FinancialExpenditureProjectReportingCodeDescription';



PRINT N'Dropping Extended Property [RDS].[DimFederalFinancialExpenditureClassifications].[FinancialExpenditureProjectReportingCodeDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications'), N'FinancialExpenditureProjectReportingCodeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimFederalFinancialExpenditureClassifications', @level2type = N'COLUMN', @level2name = N'FinancialExpenditureProjectReportingCodeDescription';



PRINT N'Dropping Extended Property [RDS].[DimFederalFinancialExpenditureClassifications].[FinancialExpenditureProjectReportingCodeDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimFederalFinancialExpenditureClassifications'), N'FinancialExpenditureProjectReportingCodeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimFederalFinancialExpenditureClassifications', @level2type = N'COLUMN', @level2name = N'FinancialExpenditureProjectReportingCodeDescription';



PRINT N'Dropping Extended Property [RDS].[DimIncidentStatuses].[IncidentBehaviorCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimIncidentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimIncidentStatuses'), N'IncidentBehaviorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimIncidentStatuses', @level2type = N'COLUMN', @level2name = N'IncidentBehaviorCode';



PRINT N'Dropping Extended Property [RDS].[DimIncidentStatuses].[IncidentBehaviorCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimIncidentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimIncidentStatuses'), N'IncidentBehaviorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimIncidentStatuses', @level2type = N'COLUMN', @level2name = N'IncidentBehaviorCode';



PRINT N'Dropping Extended Property [RDS].[DimIncidentStatuses].[IncidentBehaviorCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimIncidentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimIncidentStatuses'), N'IncidentBehaviorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimIncidentStatuses', @level2type = N'COLUMN', @level2name = N'IncidentBehaviorCode';



PRINT N'Dropping Extended Property [RDS].[DimIncidentStatuses].[IncidentBehaviorCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimIncidentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimIncidentStatuses'), N'IncidentBehaviorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimIncidentStatuses', @level2type = N'COLUMN', @level2name = N'IncidentBehaviorCode';



PRINT N'Dropping Extended Property [RDS].[DimIncidentStatuses].[IncidentBehaviorCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimIncidentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimIncidentStatuses'), N'IncidentBehaviorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimIncidentStatuses', @level2type = N'COLUMN', @level2name = N'IncidentBehaviorCode';



PRINT N'Dropping Extended Property [RDS].[DimIncidentStatuses].[IncidentBehaviorDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimIncidentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimIncidentStatuses'), N'IncidentBehaviorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimIncidentStatuses', @level2type = N'COLUMN', @level2name = N'IncidentBehaviorDescription';



PRINT N'Dropping Extended Property [RDS].[DimIncidentStatuses].[IncidentBehaviorDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimIncidentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimIncidentStatuses'), N'IncidentBehaviorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimIncidentStatuses', @level2type = N'COLUMN', @level2name = N'IncidentBehaviorDescription';



PRINT N'Dropping Extended Property [RDS].[DimIncidentStatuses].[IncidentBehaviorDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimIncidentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimIncidentStatuses'), N'IncidentBehaviorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimIncidentStatuses', @level2type = N'COLUMN', @level2name = N'IncidentBehaviorDescription';



PRINT N'Dropping Extended Property [RDS].[DimIncidentStatuses].[IncidentBehaviorDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimIncidentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimIncidentStatuses'), N'IncidentBehaviorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimIncidentStatuses', @level2type = N'COLUMN', @level2name = N'IncidentBehaviorDescription';



PRINT N'Dropping Extended Property [RDS].[DimIncidentStatuses].[IncidentBehaviorDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimIncidentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimIncidentStatuses'), N'IncidentBehaviorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimIncidentStatuses', @level2type = N'COLUMN', @level2name = N'IncidentBehaviorDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusEdFactsCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusEdFactsCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusEdFactsCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusEdFactsCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12EnrollmentStatuses].[PostSecondaryEnrollmentStatusEdFactsCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'), N'PostSecondaryEnrollmentStatusEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'PostSecondaryEnrollmentStatusEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeCode';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeDescription';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeEdFactsCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeEdFactsCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeEdFactsCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeEdFactsCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimK12StaffStatuses].[TeachingCredentialTypeEdFactsCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimK12StaffStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimK12StaffStatuses'), N'TeachingCredentialTypeEdFactsCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12StaffStatuses', @level2type = N'COLUMN', @level2name = N'TeachingCredentialTypeEdFactsCode';



PRINT N'Dropping Extended Property [RDS].[DimLeas].[NameOfInstitution].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimLeas') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimLeas'), N'NameOfInstitution', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimLeas', @level2type = N'COLUMN', @level2name = N'NameOfInstitution';



PRINT N'Dropping Extended Property [RDS].[DimLeas].[NameOfInstitution].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimLeas') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimLeas'), N'NameOfInstitution', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimLeas', @level2type = N'COLUMN', @level2name = N'NameOfInstitution';



PRINT N'Dropping Extended Property [RDS].[DimLeas].[NameOfInstitution].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimLeas') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimLeas'), N'NameOfInstitution', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimLeas', @level2type = N'COLUMN', @level2name = N'NameOfInstitution';



PRINT N'Dropping Extended Property [RDS].[DimLeas].[NameOfInstitution].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimLeas') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimLeas'), N'NameOfInstitution', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimLeas', @level2type = N'COLUMN', @level2name = N'NameOfInstitution';



PRINT N'Dropping Extended Property [RDS].[DimLeas].[NameOfInstitution].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimLeas') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimLeas'), N'NameOfInstitution', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimLeas', @level2type = N'COLUMN', @level2name = N'NameOfInstitution';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryActiveStudentIndicatorCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryActiveStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryActiveStudentIndicatorCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryActiveStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryActiveStudentIndicatorCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryActiveStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryActiveStudentIndicatorCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryActiveStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryActiveStudentIndicatorCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryActiveStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryActiveStudentIndicatorDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryActiveStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryActiveStudentIndicatorDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryActiveStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryActiveStudentIndicatorDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryActiveStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryActiveStudentIndicatorDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryActiveStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryActiveStudentIndicatorDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryActiveStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryVeteranStudentIndicatorCode].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryVeteranStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryVeteranStudentIndicatorCode].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryVeteranStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryVeteranStudentIndicatorCode].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryVeteranStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryVeteranStudentIndicatorCode].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryVeteranStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryVeteranStudentIndicatorCode].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryVeteranStudentIndicatorCode', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicatorCode';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryVeteranStudentIndicatorDescription].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryVeteranStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryVeteranStudentIndicatorDescription].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryVeteranStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryVeteranStudentIndicatorDescription].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryVeteranStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryVeteranStudentIndicatorDescription].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryVeteranStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimMilitaryStatuses].[MilitaryVeteranStudentIndicatorDescription].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimMilitaryStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimMilitaryStatuses'), N'MilitaryVeteranStudentIndicatorDescription', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimMilitaryStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicatorDescription';



PRINT N'Dropping Extended Property [RDS].[DimPsFamilyStatuses].[SingleParentOrSinglePregnantWomanStatus].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.DimPsFamilyStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimPsFamilyStatuses'), N'SingleParentOrSinglePregnantWomanStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsFamilyStatuses', @level2type = N'COLUMN', @level2name = N'SingleParentOrSinglePregnantWomanStatus';



PRINT N'Dropping Extended Property [RDS].[DimPsFamilyStatuses].[SingleParentOrSinglePregnantWomanStatus].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.DimPsFamilyStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimPsFamilyStatuses'), N'SingleParentOrSinglePregnantWomanStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsFamilyStatuses', @level2type = N'COLUMN', @level2name = N'SingleParentOrSinglePregnantWomanStatus';



PRINT N'Dropping Extended Property [RDS].[DimPsFamilyStatuses].[SingleParentOrSinglePregnantWomanStatus].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.DimPsFamilyStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimPsFamilyStatuses'), N'SingleParentOrSinglePregnantWomanStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsFamilyStatuses', @level2type = N'COLUMN', @level2name = N'SingleParentOrSinglePregnantWomanStatus';



PRINT N'Dropping Extended Property [RDS].[DimPsFamilyStatuses].[SingleParentOrSinglePregnantWomanStatus].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.DimPsFamilyStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimPsFamilyStatuses'), N'SingleParentOrSinglePregnantWomanStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsFamilyStatuses', @level2type = N'COLUMN', @level2name = N'SingleParentOrSinglePregnantWomanStatus';



PRINT N'Dropping Extended Property [RDS].[DimPsFamilyStatuses].[SingleParentOrSinglePregnantWomanStatus].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.DimPsFamilyStatuses') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.DimPsFamilyStatuses'), N'SingleParentOrSinglePregnantWomanStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsFamilyStatuses', @level2type = N'COLUMN', @level2name = N'SingleParentOrSinglePregnantWomanStatus';



PRINT N'Dropping Extended Property [RDS].[FactAeStudentEnrollments].[K12DiplomaOrCredentialAwardDateId].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'RDS.FactAeStudentEnrollments') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.FactAeStudentEnrollments'), N'K12DiplomaOrCredentialAwardDateId', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'FactAeStudentEnrollments', @level2type = N'COLUMN', @level2name = N'K12DiplomaOrCredentialAwardDateId';



PRINT N'Dropping Extended Property [RDS].[FactAeStudentEnrollments].[K12DiplomaOrCredentialAwardDateId].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'RDS.FactAeStudentEnrollments') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.FactAeStudentEnrollments'), N'K12DiplomaOrCredentialAwardDateId', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'FactAeStudentEnrollments', @level2type = N'COLUMN', @level2name = N'K12DiplomaOrCredentialAwardDateId';



PRINT N'Dropping Extended Property [RDS].[FactAeStudentEnrollments].[K12DiplomaOrCredentialAwardDateId].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'RDS.FactAeStudentEnrollments') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.FactAeStudentEnrollments'), N'K12DiplomaOrCredentialAwardDateId', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'FactAeStudentEnrollments', @level2type = N'COLUMN', @level2name = N'K12DiplomaOrCredentialAwardDateId';



PRINT N'Dropping Extended Property [RDS].[FactAeStudentEnrollments].[K12DiplomaOrCredentialAwardDateId].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'RDS.FactAeStudentEnrollments') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.FactAeStudentEnrollments'), N'K12DiplomaOrCredentialAwardDateId', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'FactAeStudentEnrollments', @level2type = N'COLUMN', @level2name = N'K12DiplomaOrCredentialAwardDateId';



PRINT N'Dropping Extended Property [RDS].[FactAeStudentEnrollments].[K12DiplomaOrCredentialAwardDateId].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'RDS.FactAeStudentEnrollments') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'RDS.FactAeStudentEnrollments'), N'K12DiplomaOrCredentialAwardDateId', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'FactAeStudentEnrollments', @level2type = N'COLUMN', @level2name = N'K12DiplomaOrCredentialAwardDateId';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[MilitaryActiveStudentIndicator].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'MilitaryActiveStudentIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicator';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[MilitaryActiveStudentIndicator].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'MilitaryActiveStudentIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicator';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[MilitaryActiveStudentIndicator].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'MilitaryActiveStudentIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicator';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[MilitaryActiveStudentIndicator].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'MilitaryActiveStudentIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicator';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[MilitaryActiveStudentIndicator].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'MilitaryActiveStudentIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicator';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[MilitaryVeteranStudentIndicator].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'MilitaryVeteranStudentIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicator';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[MilitaryVeteranStudentIndicator].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'MilitaryVeteranStudentIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicator';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[MilitaryVeteranStudentIndicator].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'MilitaryVeteranStudentIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicator';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[MilitaryVeteranStudentIndicator].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'MilitaryVeteranStudentIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicator';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[MilitaryVeteranStudentIndicator].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'MilitaryVeteranStudentIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicator';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[SchoolYear].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[SchoolYear].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[SchoolYear].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[SchoolYear].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[PersonStatus].[SchoolYear].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.PersonStatus') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.PersonStatus'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitType].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitType].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitType].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitType].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[EdFactsAcademicOrCareerAndTechnicalOutcomeExitType].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[EdFactsAcademicOrCareerAndTechnicalOutcomeType].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeType', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeType';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[EdFactsAcademicOrCareerAndTechnicalOutcomeType].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeType', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeType';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[EdFactsAcademicOrCareerAndTechnicalOutcomeType].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeType', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeType';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[EdFactsAcademicOrCareerAndTechnicalOutcomeType].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeType', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeType';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[EdFactsAcademicOrCareerAndTechnicalOutcomeType].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'EdFactsAcademicOrCareerAndTechnicalOutcomeType', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'EdFactsAcademicOrCareerAndTechnicalOutcomeType';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentAcademicAchievementIndicator].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentAcademicAchievementIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentAcademicAchievementIndicator';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentAcademicAchievementIndicator].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentAcademicAchievementIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentAcademicAchievementIndicator';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentAcademicAchievementIndicator].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentAcademicAchievementIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentAcademicAchievementIndicator';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentAcademicAchievementIndicator].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentAcademicAchievementIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentAcademicAchievementIndicator';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentAcademicAchievementIndicator].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentAcademicAchievementIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentAcademicAchievementIndicator';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentProgramEnrollmentSubpart].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentProgramEnrollmentSubpart', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentProgramEnrollmentSubpart';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentProgramEnrollmentSubpart].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentProgramEnrollmentSubpart', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentProgramEnrollmentSubpart';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentProgramEnrollmentSubpart].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentProgramEnrollmentSubpart', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentProgramEnrollmentSubpart';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentProgramEnrollmentSubpart].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentProgramEnrollmentSubpart', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentProgramEnrollmentSubpart';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentProgramEnrollmentSubpart].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentProgramEnrollmentSubpart', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentProgramEnrollmentSubpart';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentStatus].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentStatus';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentStatus].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentStatus';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentStatus].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentStatus';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentStatus].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentStatus';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[NeglectedOrDelinquentStatus].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'NeglectedOrDelinquentStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'NeglectedOrDelinquentStatus';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[SchoolYear].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[SchoolYear].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[SchoolYear].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[SchoolYear].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[SchoolYear].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationNorD') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationNorD'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[SchoolYear].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationSpecialEducation') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationSpecialEducation'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[SchoolYear].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationSpecialEducation') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationSpecialEducation'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[SchoolYear].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationSpecialEducation') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationSpecialEducation'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[SchoolYear].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationSpecialEducation') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationSpecialEducation'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[SchoolYear].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationSpecialEducation') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationSpecialEducation'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[SchoolYear].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationTitleI') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationTitleI'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[SchoolYear].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationTitleI') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationTitleI'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[SchoolYear].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationTitleI') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationTitleI'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[SchoolYear].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationTitleI') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationTitleI'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[SchoolYear].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationTitleI') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationTitleI'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[SchoolYear].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationTitleIII') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationTitleIII'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[SchoolYear].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationTitleIII') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationTitleIII'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[SchoolYear].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationTitleIII') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationTitleIII'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[SchoolYear].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationTitleIII') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationTitleIII'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[SchoolYear].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.ProgramParticipationTitleIII') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.ProgramParticipationTitleIII'), N'SchoolYear', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'SchoolYear';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[EconomicDisadvantageStatus].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'EconomicDisadvantageStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatus';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[EconomicDisadvantageStatus].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'EconomicDisadvantageStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatus';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[EconomicDisadvantageStatus].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'EconomicDisadvantageStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatus';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[EconomicDisadvantageStatus].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'EconomicDisadvantageStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatus';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[EconomicDisadvantageStatus].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'EconomicDisadvantageStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'EconomicDisadvantageStatus';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[EnglishLearnerStatus].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'EnglishLearnerStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatus';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[EnglishLearnerStatus].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'EnglishLearnerStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatus';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[EnglishLearnerStatus].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'EnglishLearnerStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatus';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[EnglishLearnerStatus].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'EnglishLearnerStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatus';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[EnglishLearnerStatus].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'EnglishLearnerStatus', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'EnglishLearnerStatus';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[IdeaIndicator].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'IdeaIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'IdeaIndicator';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[IdeaIndicator].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'IdeaIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'IdeaIndicator';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[IdeaIndicator].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'IdeaIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'IdeaIndicator';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[IdeaIndicator].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'IdeaIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'IdeaIndicator';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[IdeaIndicator].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'IdeaIndicator', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'IdeaIndicator';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[LeaIdentifierSea].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'LeaIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[LeaIdentifierSea].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'LeaIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[LeaIdentifierSea].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'LeaIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[LeaIdentifierSea].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'LeaIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[LeaIdentifierSea].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'LeaIdentifierSea', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'LeaIdentifierSea';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[Race].[CEDS_Def_Desc]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Def_Desc' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'Race', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Def_Desc', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'Race';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[Race].[CEDS_Element]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_Element' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'Race', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_Element', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'Race';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[Race].[CEDS_GlobalId]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_GlobalId' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'Race', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_GlobalId', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'Race';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[Race].[CEDS_URL]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'CEDS_URL' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'Race', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'CEDS_URL', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'Race';



PRINT N'Dropping Extended Property [Staging].[SchoolPerformanceIndicators].[Race].[MS_Description]...';



IF EXISTS (SELECT NULL FROM sys.extended_properties WHERE [name] = N'MS_Description' AND major_id = OBJECT_ID(N'Staging.SchoolPerformanceIndicators') AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'Staging.SchoolPerformanceIndicators'), N'Race', 'ColumnId'))
    EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'SchoolPerformanceIndicators', @level2type = N'COLUMN', @level2name = N'Race';



PRINT N'Dropping Index [RDS].[DimAcademicTermDesignators].[IX_DimAcademicTermDesignators_AcademicTermDesignatorCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimAcademicTermDesignators_AcademicTermDesignatorCode' AND object_id = OBJECT_ID(N'RDS.DimAcademicTermDesignators'))
    DROP INDEX [IX_DimAcademicTermDesignators_AcademicTermDesignatorCode]
    ON [RDS].[DimAcademicTermDesignators];



PRINT N'Dropping Index [RDS].[DimAeDemographics].[IX_DimAeDemographics_Codes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimAeDemographics_Codes' AND object_id = OBJECT_ID(N'RDS.DimAeDemographics'))
    DROP INDEX [IX_DimAeDemographics_Codes]
    ON [RDS].[DimAeDemographics];



PRINT N'Dropping Index [RDS].[DimAges].[IX_DimAges_AgeCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimAges_AgeCode' AND object_id = OBJECT_ID(N'RDS.DimAges'))
    DROP INDEX [IX_DimAges_AgeCode]
    ON [RDS].[DimAges];



PRINT N'Dropping Index [RDS].[DimAssessmentPerformanceLevels].[IX_DimAssessmentPerformanceLevels_AssessmentPerformanceLevelIdentifier]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimAssessmentPerformanceLevels_AssessmentPerformanceLevelIdentifier' AND object_id = OBJECT_ID(N'RDS.DimAssessmentPerformanceLevels'))
    DROP INDEX [IX_DimAssessmentPerformanceLevels_AssessmentPerformanceLevelIdentifier]
    ON [RDS].[DimAssessmentPerformanceLevels];



PRINT N'Dropping Index [RDS].[DimAssessments].[IX_DimAssessments_Codes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimAssessments_Codes' AND object_id = OBJECT_ID(N'RDS.DimAssessments'))
    DROP INDEX [IX_DimAssessments_Codes]
    ON [RDS].[DimAssessments];



PRINT N'Dropping Index [RDS].[DimAssessments].[IX_DimAssessments_AssessmentSubjectEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimAssessments_AssessmentSubjectEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimAssessments'))
    DROP INDEX [IX_DimAssessments_AssessmentSubjectEdFactsCode]
    ON [RDS].[DimAssessments];



PRINT N'Dropping Index [RDS].[DimCredentials].[IX_DimCredentials_Codes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimCredentials_Codes' AND object_id = OBJECT_ID(N'RDS.DimCredentials'))
    DROP INDEX [IX_DimCredentials_Codes]
    ON [RDS].[DimCredentials];



PRINT N'Dropping Index [RDS].[DimDates].[IX_DimDates_DateValue]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimDates_DateValue' AND object_id = OBJECT_ID(N'RDS.DimDates'))
    DROP INDEX [IX_DimDates_DateValue]
    ON [RDS].[DimDates];



PRINT N'Dropping Index [RDS].[DimDates].[IX_DimDates_SubmissionYear]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimDates_SubmissionYear' AND object_id = OBJECT_ID(N'RDS.DimDates'))
    DROP INDEX [IX_DimDates_SubmissionYear]
    ON [RDS].[DimDates];



PRINT N'Dropping Index [RDS].[DimDisabilityStatuses].[IX_DimDisabilityStatuses_Codes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimDisabilityStatuses_Codes' AND object_id = OBJECT_ID(N'RDS.DimDisabilityStatuses'))
    DROP INDEX [IX_DimDisabilityStatuses_Codes]
    ON [RDS].[DimDisabilityStatuses];



PRINT N'Dropping Index [RDS].[DimDisciplineStatuses].[IX_DimDisciplineStatuses_Codes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimDisciplineStatuses_Codes' AND object_id = OBJECT_ID(N'RDS.DimDisciplineStatuses'))
    DROP INDEX [IX_DimDisciplineStatuses_Codes]
    ON [RDS].[DimDisciplineStatuses];



PRINT N'Dropping Index [RDS].[DimDisciplineStatuses].[IX_DimDisciplineStatuses_DisciplineActionEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimDisciplineStatuses_DisciplineActionEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimDisciplineStatuses'))
    DROP INDEX [IX_DimDisciplineStatuses_DisciplineActionEdFactsCode]
    ON [RDS].[DimDisciplineStatuses];



PRINT N'Dropping Index [RDS].[DimDisciplineStatuses].[IX_DimDisciplineStatuses_DisciplineMethodEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimDisciplineStatuses_DisciplineMethodEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimDisciplineStatuses'))
    DROP INDEX [IX_DimDisciplineStatuses_DisciplineMethodEdFactsCode]
    ON [RDS].[DimDisciplineStatuses];



PRINT N'Dropping Index [RDS].[DimDisciplineStatuses].[IX_DimDisciplineStatuses_EducationalServicesEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimDisciplineStatuses_EducationalServicesEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimDisciplineStatuses'))
    DROP INDEX [IX_DimDisciplineStatuses_EducationalServicesEdFactsCode]
    ON [RDS].[DimDisciplineStatuses];



PRINT N'Dropping Index [RDS].[DimDisciplineStatuses].[IX_DimDisciplineStatuses_RemovalTypeEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimDisciplineStatuses_RemovalTypeEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimDisciplineStatuses'))
    DROP INDEX [IX_DimDisciplineStatuses_RemovalTypeEdFactsCode]
    ON [RDS].[DimDisciplineStatuses];



PRINT N'Dropping Index [RDS].[DimFirearms].[IX_DimFirearms_FirearmTypeCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimFirearms_FirearmTypeCode' AND object_id = OBJECT_ID(N'RDS.DimFirearms'))
    DROP INDEX [IX_DimFirearms_FirearmTypeCode]
    ON [RDS].[DimFirearms];



PRINT N'Dropping Index [RDS].[DimFirearms].[IX_DimFirearms_FirearmTypeEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimFirearms_FirearmTypeEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimFirearms'))
    DROP INDEX [IX_DimFirearms_FirearmTypeEdFactsCode]
    ON [RDS].[DimFirearms];



PRINT N'Dropping Index [RDS].[DimGradeLevels].[IX_DimGradeLevels_GradeLevelCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimGradeLevels_GradeLevelCode' AND object_id = OBJECT_ID(N'RDS.DimGradeLevels'))
    DROP INDEX [IX_DimGradeLevels_GradeLevelCode]
    ON [RDS].[DimGradeLevels];



PRINT N'Dropping Index [RDS].[DimGradeLevels].[IX_DimGradeLevels_GradeLevelEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimGradeLevels_GradeLevelEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimGradeLevels'))
    DROP INDEX [IX_DimGradeLevels_GradeLevelEdFactsCode]
    ON [RDS].[DimGradeLevels];



PRINT N'Dropping Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_Codes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimIdeaStatuses_Codes' AND object_id = OBJECT_ID(N'RDS.DimIdeaStatuses'))
    DROP INDEX [IX_DimIdeaStatuses_Codes]
    ON [RDS].[DimIdeaStatuses];



PRINT N'Dropping Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_EducEnvEarlyChildhoodEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimIdeaStatuses_EducEnvEarlyChildhoodEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimIdeaStatuses'))
    DROP INDEX [IX_DimIdeaStatuses_EducEnvEarlyChildhoodEdFactsCode]
    ON [RDS].[DimIdeaStatuses];



PRINT N'Dropping Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_EducEnvSchoolAgeEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimIdeaStatuses_EducEnvSchoolAgeEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimIdeaStatuses'))
    DROP INDEX [IX_DimIdeaStatuses_EducEnvSchoolAgeEdFactsCode]
    ON [RDS].[DimIdeaStatuses];



PRINT N'Dropping Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_BasisOfExitEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimIdeaStatuses_BasisOfExitEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimIdeaStatuses'))
    DROP INDEX [IX_DimIdeaStatuses_BasisOfExitEdFactsCode]
    ON [RDS].[DimIdeaStatuses];



PRINT N'Dropping Index [RDS].[DimIndicatorStatuses].[IX_DimIndicatorStatuses_IndicatorStatusCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimIndicatorStatuses_IndicatorStatusCode' AND object_id = OBJECT_ID(N'RDS.DimIndicatorStatuses'))
    DROP INDEX [IX_DimIndicatorStatuses_IndicatorStatusCode]
    ON [RDS].[DimIndicatorStatuses];



PRINT N'Dropping Index [RDS].[DimIndicatorStatuses].[IX_DimIndicatorStatuses_IndicatorStatusEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimIndicatorStatuses_IndicatorStatusEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimIndicatorStatuses'))
    DROP INDEX [IX_DimIndicatorStatuses_IndicatorStatusEdFactsCode]
    ON [RDS].[DimIndicatorStatuses];



PRINT N'Dropping Index [RDS].[DimIndicatorStatusTypes].[IX_DimIndicatorStatusTypes_IndicatorStatusTypeCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimIndicatorStatusTypes_IndicatorStatusTypeCode' AND object_id = OBJECT_ID(N'RDS.DimIndicatorStatusTypes'))
    DROP INDEX [IX_DimIndicatorStatusTypes_IndicatorStatusTypeCode]
    ON [RDS].[DimIndicatorStatusTypes];



PRINT N'Dropping Index [RDS].[DimIndicatorStatusTypes].[IX_DimIndicatorStatusTypes_IndicatorStatusTypeEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimIndicatorStatusTypes_IndicatorStatusTypeEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimIndicatorStatusTypes'))
    DROP INDEX [IX_DimIndicatorStatusTypes_IndicatorStatusTypeEdFactsCode]
    ON [RDS].[DimIndicatorStatusTypes];



PRINT N'Dropping Index [RDS].[DimK12Demographics].[IX_DimK12Demographics_SexEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12Demographics_SexEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12Demographics'))
    DROP INDEX [IX_DimK12Demographics_SexEdFactsCode]
    ON [RDS].[DimK12Demographics];



PRINT N'Dropping Index [RDS].[DimK12EnrollmentStatuses].[IX_DimK12EnrollmentStatuses_Codes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12EnrollmentStatuses_Codes' AND object_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'))
    DROP INDEX [IX_DimK12EnrollmentStatuses_Codes]
    ON [RDS].[DimK12EnrollmentStatuses];



PRINT N'Dropping Index [RDS].[DimK12OrganizationStatuses].[IX_DimK12OrganizationStatuses_Codes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12OrganizationStatuses_Codes' AND object_id = OBJECT_ID(N'RDS.DimK12OrganizationStatuses'))
    DROP INDEX [IX_DimK12OrganizationStatuses_Codes]
    ON [RDS].[DimK12OrganizationStatuses];



PRINT N'Dropping Index [RDS].[DimK12OrganizationStatuses].[IX_DimK12OrganizationStatuses_GunFreeSchoolsActReportingStatusEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12OrganizationStatuses_GunFreeSchoolsActReportingStatusEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12OrganizationStatuses'))
    DROP INDEX [IX_DimK12OrganizationStatuses_GunFreeSchoolsActReportingStatusEdFactsCode]
    ON [RDS].[DimK12OrganizationStatuses];



PRINT N'Dropping Index [RDS].[DimK12OrganizationStatuses].[IX_DimK12OrganizationStatuses_HighSchoolGraduationRateIndicatorStatusEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12OrganizationStatuses_HighSchoolGraduationRateIndicatorStatusEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12OrganizationStatuses'))
    DROP INDEX [IX_DimK12OrganizationStatuses_HighSchoolGraduationRateIndicatorStatusEdFactsCode]
    ON [RDS].[DimK12OrganizationStatuses];



PRINT N'Dropping Index [RDS].[DimK12OrganizationStatuses].[IX_DimK12OrganizationStatuses_ReapAlternativeFundingStatusEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12OrganizationStatuses_ReapAlternativeFundingStatusEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12OrganizationStatuses'))
    DROP INDEX [IX_DimK12OrganizationStatuses_ReapAlternativeFundingStatusEdFactsCode]
    ON [RDS].[DimK12OrganizationStatuses];



PRINT N'Dropping Index [RDS].[DimK12SchoolStateStatuses].[IX_DimK12SchoolStateStatuses_SchoolStateStatusCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12SchoolStateStatuses_SchoolStateStatusCode' AND object_id = OBJECT_ID(N'RDS.DimK12SchoolStateStatuses'))
    DROP INDEX [IX_DimK12SchoolStateStatuses_SchoolStateStatusCode]
    ON [RDS].[DimK12SchoolStateStatuses];



PRINT N'Dropping Index [RDS].[DimK12SchoolStateStatuses].[IX_DimRaces_SchoolStateStatusCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimRaces_SchoolStateStatusCode' AND object_id = OBJECT_ID(N'RDS.DimK12SchoolStateStatuses'))
    DROP INDEX [IX_DimRaces_SchoolStateStatusCode]
    ON [RDS].[DimK12SchoolStateStatuses];



PRINT N'Dropping Index [RDS].[DimK12SchoolStateStatuses].[IX_DimRaces_SchoolStateStatusEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimRaces_SchoolStateStatusEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12SchoolStateStatuses'))
    DROP INDEX [IX_DimRaces_SchoolStateStatusEdFactsCode]
    ON [RDS].[DimK12SchoolStateStatuses];



PRINT N'Dropping Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_MagnetOrSpecialProgramEmphasisSchoolEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12SchoolStatuses_MagnetOrSpecialProgramEmphasisSchoolEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12SchoolStatuses'))
    DROP INDEX [IX_DimK12SchoolStatuses_MagnetOrSpecialProgramEmphasisSchoolEdFactsCode]
    ON [RDS].[DimK12SchoolStatuses];



PRINT N'Dropping Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_NslpStatusEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12SchoolStatuses_NslpStatusEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12SchoolStatuses'))
    DROP INDEX [IX_DimK12SchoolStatuses_NslpStatusEdFactsCode]
    ON [RDS].[DimK12SchoolStatuses];



PRINT N'Dropping Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_SharedTimeIndicatorEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12SchoolStatuses_SharedTimeIndicatorEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12SchoolStatuses'))
    DROP INDEX [IX_DimK12SchoolStatuses_SharedTimeIndicatorEdFactsCode]
    ON [RDS].[DimK12SchoolStatuses];



PRINT N'Dropping Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_StatePovertyDesignationEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12SchoolStatuses_StatePovertyDesignationEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12SchoolStatuses'))
    DROP INDEX [IX_DimK12SchoolStatuses_StatePovertyDesignationEdFactsCode]
    ON [RDS].[DimK12SchoolStatuses];



PRINT N'Dropping Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_VirtualSchoolStatusEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12SchoolStatuses_VirtualSchoolStatusEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12SchoolStatuses'))
    DROP INDEX [IX_DimK12SchoolStatuses_VirtualSchoolStatusEdFactsCode]
    ON [RDS].[DimK12SchoolStatuses];



PRINT N'Dropping Index [RDS].[DimK12StaffCategories].[IX_DimK12StaffCategories_Codes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12StaffCategories_Codes' AND object_id = OBJECT_ID(N'RDS.DimK12StaffCategories'))
    DROP INDEX [IX_DimK12StaffCategories_Codes]
    ON [RDS].[DimK12StaffCategories];



PRINT N'Dropping Index [RDS].[DimK12StaffCateries].[IX_DimK12StaffCategories_K12StaffClassificationEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12StaffCategories_K12StaffClassificationEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12StaffCategories'))
    DROP INDEX [IX_DimK12StaffCategories_K12StaffClassificationEdFactsCode]
    ON [RDS].[DimK12StaffCategories];



PRINT N'Dropping Index [RDS].[DimK12StaffCategories].[IX_DimK12StaffCategories_SpecialEducationSupportServicesCategoryEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12StaffCategories_SpecialEducationSupportServicesCategoryEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12StaffCategories'))
    DROP INDEX [IX_DimK12StaffCategories_SpecialEducationSupportServicesCategoryEdFactsCode]
    ON [RDS].[DimK12StaffCategories];



PRINT N'Dropping Index [RDS].[DimK12StaffCategories].[IX_DimK12StaffCategories_TitleIProgramStaffCategoryEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12StaffCategories_TitleIProgramStaffCategoryEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12StaffCategories'))
    DROP INDEX [IX_DimK12StaffCategories_TitleIProgramStaffCategoryEdFactsCode]
    ON [RDS].[DimK12StaffCategories];


PRINT N'Dropping Index [RDS].[DimK12StaffCategories].[IX_DimK12StaffCategories_Category]...';



IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_DimK12StaffCategories_Category'
      AND object_id = OBJECT_ID('[RDS].[DimK12StaffCategories]')
)
BEGIN
IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12StaffCategories_Category' AND object_id = OBJECT_ID(N'RDS.DimK12StaffCategories'))
    DROP INDEX [IX_DimK12StaffCategories_Category]
    ON [RDS].[DimK12StaffCategories];
END



PRINT N'Dropping Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_EdFactsCertificationStatusCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12StaffStatuses_EdFactsCertificationStatusCode' AND object_id = OBJECT_ID(N'RDS.DimK12StaffStatuses'))
    DROP INDEX [IX_DimK12StaffStatuses_EdFactsCertificationStatusCode]
    ON [RDS].[DimK12StaffStatuses];



PRINT N'Dropping Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_Codes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12StaffStatuses_Codes' AND object_id = OBJECT_ID(N'RDS.DimK12StaffStatuses'))
    DROP INDEX [IX_DimK12StaffStatuses_Codes]
    ON [RDS].[DimK12StaffStatuses];



PRINT N'Dropping Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_EdFactsTeacherInexperiencedStatusCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12StaffStatuses_EdFactsTeacherInexperiencedStatusCode' AND object_id = OBJECT_ID(N'RDS.DimK12StaffStatuses'))
    DROP INDEX [IX_DimK12StaffStatuses_EdFactsTeacherInexperiencedStatusCode]
    ON [RDS].[DimK12StaffStatuses];



PRINT N'Dropping Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_EdFactsTeacherOutOfFieldStatusEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12StaffStatuses_EdFactsTeacherOutOfFieldStatusEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12StaffStatuses'))
    DROP INDEX [IX_DimK12StaffStatuses_EdFactsTeacherOutOfFieldStatusEdFactsCode]
    ON [RDS].[DimK12StaffStatuses];



PRINT N'Dropping Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_HighlyQualifiedTeacherIndicatorCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12StaffStatuses_HighlyQualifiedTeacherIndicatorCode' AND object_id = OBJECT_ID(N'RDS.DimK12StaffStatuses'))
    DROP INDEX [IX_DimK12StaffStatuses_HighlyQualifiedTeacherIndicatorCode]
    ON [RDS].[DimK12StaffStatuses];



PRINT N'Dropping Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_ParaprofessionalQualificationStatusEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12StaffStatuses_ParaprofessionalQualificationStatusEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12StaffStatuses'))
    DROP INDEX [IX_DimK12StaffStatuses_ParaprofessionalQualificationStatusEdFactsCode]
    ON [RDS].[DimK12StaffStatuses];



PRINT N'Dropping Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_SpecialEducationAgeGroupTaughtEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12StaffStatuses_SpecialEducationAgeGroupTaughtEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12StaffStatuses'))
    DROP INDEX [IX_DimK12StaffStatuses_SpecialEducationAgeGroupTaughtEdFactsCode]
    ON [RDS].[DimK12StaffStatuses];



PRINT N'Dropping Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_SpecialEducationTeacherQualificationStatusEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12StaffStatuses_SpecialEducationTeacherQualificationStatusEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12StaffStatuses'))
    DROP INDEX [IX_DimK12StaffStatuses_SpecialEducationTeacherQualificationStatusEdFactsCode]
    ON [RDS].[DimK12StaffStatuses];



PRINT N'Dropping Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitleIStatuses_Codes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimOrganizationTitleIStatuses_Codes' AND object_id = OBJECT_ID(N'RDS.DimOrganizationTitleIStatuses'))
    DROP INDEX [IX_DimOrganizationTitleIStatuses_Codes]
    ON [RDS].[DimOrganizationTitleIStatuses];



PRINT N'Dropping Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitle1Statuses_Codes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimOrganizationTitle1Statuses_Codes' AND object_id = OBJECT_ID(N'RDS.DimOrganizationTitleIStatuses'))
    DROP INDEX [IX_DimOrganizationTitle1Statuses_Codes]
    ON [RDS].[DimOrganizationTitleIStatuses];



PRINT N'Dropping Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitle1Statuses_Title1InstructionalServicesEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimOrganizationTitle1Statuses_Title1InstructionalServicesEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimOrganizationTitleIStatuses'))
    DROP INDEX [IX_DimOrganizationTitle1Statuses_Title1InstructionalServicesEdFactsCode]
    ON [RDS].[DimOrganizationTitleIStatuses];



PRINT N'Dropping Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitleIStatuses_TitleIInstructionalServicesEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimOrganizationTitleIStatuses_TitleIInstructionalServicesEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimOrganizationTitleIStatuses'))
    DROP INDEX [IX_DimOrganizationTitleIStatuses_TitleIInstructionalServicesEdFactsCode]
    ON [RDS].[DimOrganizationTitleIStatuses];



PRINT N'Dropping Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitle1Statuses_Title1ProgramTypeEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimOrganizationTitle1Statuses_Title1ProgramTypeEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimOrganizationTitleIStatuses'))
    DROP INDEX [IX_DimOrganizationTitle1Statuses_Title1ProgramTypeEdFactsCode]
    ON [RDS].[DimOrganizationTitleIStatuses];



PRINT N'Dropping Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitleIStatuses_TitleIProgramTypeEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimOrganizationTitleIStatuses_TitleIProgramTypeEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimOrganizationTitleIStatuses'))
    DROP INDEX [IX_DimOrganizationTitleIStatuses_TitleIProgramTypeEdFactsCode]
    ON [RDS].[DimOrganizationTitleIStatuses];



PRINT N'Dropping Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitle1Statuses_Title1SchoolStatusEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimOrganizationTitle1Statuses_Title1SchoolStatusEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimOrganizationTitleIStatuses'))
    DROP INDEX [IX_DimOrganizationTitle1Statuses_Title1SchoolStatusEdFactsCode]
    ON [RDS].[DimOrganizationTitleIStatuses];



PRINT N'Dropping Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitleIStatuses_TitleISchoolStatusEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimOrganizationTitleIStatuses_TitleISchoolStatusEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimOrganizationTitleIStatuses'))
    DROP INDEX [IX_DimOrganizationTitleIStatuses_TitleISchoolStatusEdFactsCode]
    ON [RDS].[DimOrganizationTitleIStatuses];



PRINT N'Dropping Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitleIStatuses_TitleISupportServicesEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimOrganizationTitleIStatuses_TitleISupportServicesEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimOrganizationTitleIStatuses'))
    DROP INDEX [IX_DimOrganizationTitleIStatuses_TitleISupportServicesEdFactsCode]
    ON [RDS].[DimOrganizationTitleIStatuses];



PRINT N'Dropping Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitle1Statuses_Title1SupportServicesEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimOrganizationTitle1Statuses_Title1SupportServicesEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimOrganizationTitleIStatuses'))
    DROP INDEX [IX_DimOrganizationTitle1Statuses_Title1SupportServicesEdFactsCode]
    ON [RDS].[DimOrganizationTitleIStatuses];



PRINT N'Dropping Index [RDS].[DimProgramTypes].[IX_DimProgramTypes_ProgramTypeCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimProgramTypes_ProgramTypeCode' AND object_id = OBJECT_ID(N'RDS.DimProgramTypes'))
    DROP INDEX [IX_DimProgramTypes_ProgramTypeCode]
    ON [RDS].[DimProgramTypes];



PRINT N'Dropping Index [RDS].[DimPsAcademicAwardStatuses].[IX_DimPsAcademicAwardStatuses_Codes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimPsAcademicAwardStatuses_Codes' AND object_id = OBJECT_ID(N'RDS.DimPsAcademicAwardStatuses'))
    DROP INDEX [IX_DimPsAcademicAwardStatuses_Codes]
    ON [RDS].[DimPsAcademicAwardStatuses];



PRINT N'Dropping Index [RDS].[DimPsCitizenshipStatuses].[IX_DimPsCitizenshipStatuses_Codes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimPsCitizenshipStatuses_Codes' AND object_id = OBJECT_ID(N'RDS.DimPsCitizenshipStatuses'))
    DROP INDEX [IX_DimPsCitizenshipStatuses_Codes]
    ON [RDS].[DimPsCitizenshipStatuses];



PRINT N'Dropping Index [RDS].[DimRaces].[IX_DimRaces_RaceCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimRaces_RaceCode' AND object_id = OBJECT_ID(N'RDS.DimRaces'))
    DROP INDEX [IX_DimRaces_RaceCode]
    ON [RDS].[DimRaces];



PRINT N'Dropping Index [RDS].[DimSchoolPerformanceIndicatorCateries].[IX_DimSchoolPerformanceIndicatorCateries_SchoolPerformanceIndicatorCateryCode]...';



--DROP INDEX [IX_DimSchoolPerformanceIndicatorCateries_SchoolPerformanceIndicatorCateryCode]
--    ON [RDS].[DimSchoolPerformanceIndicatorCateries];



PRINT N'Dropping Index [RDS].[DimSchoolPerformanceIndicatorCateries].[IX_DimSchoolPerformanceIndicatorCateries_SchoolPerformanceIndicatorCateryEdFactsCode]...';



--DROP INDEX [IX_DimSchoolPerformanceIndicatorCateries_SchoolPerformanceIndicatorCateryEdFactsCode]
--    ON [RDS].[DimSchoolPerformanceIndicatorCateries];



PRINT N'Dropping Index [RDS].[DimSchoolPerformanceIndicators].[IX_DimSchoolPerformanceIndicators_SchoolPerformanceIndicatorTypeCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimSchoolPerformanceIndicators_SchoolPerformanceIndicatorTypeCode' AND object_id = OBJECT_ID(N'RDS.DimSchoolPerformanceIndicators'))
    DROP INDEX [IX_DimSchoolPerformanceIndicators_SchoolPerformanceIndicatorTypeCode]
    ON [RDS].[DimSchoolPerformanceIndicators];



PRINT N'Dropping Index [RDS].[DimSchoolPerformanceIndicators].[IX_DimSchoolPerformanceIndicators_SchoolPerformanceIndicatorTypeEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimSchoolPerformanceIndicators_SchoolPerformanceIndicatorTypeEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimSchoolPerformanceIndicators'))
    DROP INDEX [IX_DimSchoolPerformanceIndicators_SchoolPerformanceIndicatorTypeEdFactsCode]
    ON [RDS].[DimSchoolPerformanceIndicators];



PRINT N'Dropping Index [RDS].[DimSchoolPerformanceIndicatorStateDefinedStatuses].[IX_DimSchoolPerformanceIndicatorStateDefinedStatuses_SchoolPerformanceIndicatorStateDefinedStatusCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimSchoolPerformanceIndicatorStateDefinedStatuses_SchoolPerformanceIndicatorStateDefinedStatusCode' AND object_id = OBJECT_ID(N'RDS.DimSchoolPerformanceIndicatorStateDefinedStatuses'))
    DROP INDEX [IX_DimSchoolPerformanceIndicatorStateDefinedStatuses_SchoolPerformanceIndicatorStateDefinedStatusCode]
    ON [RDS].[DimSchoolPerformanceIndicatorStateDefinedStatuses];



PRINT N'Dropping Index [RDS].[DimSchoolQualityOrStudentSuccessIndicators].[IX_DimSchoolQualityOrStudentSuccessIndicators_SchoolQualityOrStudentSuccessIndicatorTypeCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimSchoolQualityOrStudentSuccessIndicators_SchoolQualityOrStudentSuccessIndicatorTypeCode' AND object_id = OBJECT_ID(N'RDS.DimSchoolQualityOrStudentSuccessIndicators'))
    DROP INDEX [IX_DimSchoolQualityOrStudentSuccessIndicators_SchoolQualityOrStudentSuccessIndicatorTypeCode]
    ON [RDS].[DimSchoolQualityOrStudentSuccessIndicators];



PRINT N'Dropping Index [RDS].[DimStateDefinedCustomIndicators].[IX_DimStateDefinedCustomIndicators_StateDefinedCustomIndicatorCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimStateDefinedCustomIndicators_StateDefinedCustomIndicatorCode' AND object_id = OBJECT_ID(N'RDS.DimStateDefinedCustomIndicators'))
    DROP INDEX [IX_DimStateDefinedCustomIndicators_StateDefinedCustomIndicatorCode]
    ON [RDS].[DimStateDefinedCustomIndicators];



PRINT N'Dropping Index [RDS].[DimStateDefinedStatuses].[IX_DimStateDefinedStatuses_StateDefinedStatusCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimStateDefinedStatuses_StateDefinedStatusCode' AND object_id = OBJECT_ID(N'RDS.DimStateDefinedStatuses'))
    DROP INDEX [IX_DimStateDefinedStatuses_StateDefinedStatusCode]
    ON [RDS].[DimStateDefinedStatuses];



PRINT N'Dropping Index [RDS].[ReportEDFactsK12StudentCounts].[IX_FactStudentCountReports_CaterySetCode_DISABILITY_Report]...';



--DROP INDEX [IX_FactStudentCountReports_CaterySetCode_DISABILITY_Report]
--    ON [RDS].[ReportEDFactsK12StudentCounts];



PRINT N'Dropping Index [CEDS].[CedsOptionSetMapping].[ix_CedsOptionSetMapping_CedsOptionSetCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'ix_CedsOptionSetMapping_CedsOptionSetCode' AND object_id = OBJECT_ID(N'CEDS.CedsOptionSetMapping'))
    DROP INDEX [ix_CedsOptionSetMapping_CedsOptionSetCode]
    ON [CEDS].[CedsOptionSetMapping];



PRINT N'Dropping Index [RDS].[DimCohortStatuses].[IX_DimCohortStatuses_CohortStatusCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimCohortStatuses_CohortStatusCode' AND object_id = OBJECT_ID(N'RDS.DimCohortStatuses'))
    DROP INDEX [IX_DimCohortStatuses_CohortStatusCode]
    ON [RDS].[DimCohortStatuses];



PRINT N'Dropping Index [RDS].[DimK12EnrollmentStatuses].[IX_DimK12EnrollmentStatuses_PostSecondaryEnrollmentStatusEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12EnrollmentStatuses_PostSecondaryEnrollmentStatusEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12EnrollmentStatuses'))
    DROP INDEX [IX_DimK12EnrollmentStatuses_PostSecondaryEnrollmentStatusEdFactsCode]
    ON [RDS].[DimK12EnrollmentStatuses];



PRINT N'Dropping Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_TeachingCredentialTypeEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimK12StaffStatuses_TeachingCredentialTypeEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimK12StaffStatuses'))
    DROP INDEX [IX_DimK12StaffStatuses_TeachingCredentialTypeEdFactsCode]
    ON [RDS].[DimK12StaffStatuses];



PRINT N'Dropping Index [RDS].[DimPeople].[ix_DimPeople_IsActiveStudent]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'ix_DimPeople_IsActiveStudent' AND object_id = OBJECT_ID(N'RDS.DimPeople'))
    DROP INDEX [ix_DimPeople_IsActiveStudent]
    ON [RDS].[DimPeople];



PRINT N'Dropping Index [RDS].[DimPsInstitutions].[IX_DimPsInstitutions_InstitutionIpedsUnitId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimPsInstitutions_InstitutionIpedsUnitId' AND object_id = OBJECT_ID(N'RDS.DimPsInstitutions'))
    DROP INDEX [IX_DimPsInstitutions_InstitutionIpedsUnitId]
    ON [RDS].[DimPsInstitutions];



PRINT N'Dropping Index [RDS].[DimTitleIStatuses].[IX_DimTitle1Statuses_TitleIIndicatorCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimTitle1Statuses_TitleIIndicatorCode' AND object_id = OBJECT_ID(N'RDS.DimTitleIStatuses'))
    DROP INDEX [IX_DimTitle1Statuses_TitleIIndicatorCode]
    ON [RDS].[DimTitleIStatuses];



PRINT N'Dropping Index [RDS].[DimTitleIStatuses].[IX_DimTitleIStatuses_TitleIIndicatorCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimTitleIStatuses_TitleIIndicatorCode' AND object_id = OBJECT_ID(N'RDS.DimTitleIStatuses'))
    DROP INDEX [IX_DimTitleIStatuses_TitleIIndicatorCode]
    ON [RDS].[DimTitleIStatuses];



PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[ix_FactK12StudentAssessments_FactType]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'ix_FactK12StudentAssessments_FactType' AND object_id = OBJECT_ID(N'RDS.FactK12StudentAssessments'))
    DROP INDEX [ix_FactK12StudentAssessments_FactType]
    ON [RDS].[FactK12StudentAssessments];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IX_FactK12StudentCounts_SchoolYearId_FactTypeId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_FactK12StudentCounts_SchoolYearId_FactTypeId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IX_FactK12StudentCounts_SchoolYearId_FactTypeId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IX_RDS_FactK12StudentCounts_SchoolYearId_FactTypeId_AgeId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_RDS_FactK12StudentCounts_SchoolYearId_FactTypeId_AgeId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IX_RDS_FactK12StudentCounts_SchoolYearId_FactTypeId_AgeId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IX_RDS_FactK12StudentCounts_SchoolYearId_FactTypeId_SeaId_WithIncludes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_RDS_FactK12StudentCounts_SchoolYearId_FactTypeId_SeaId_WithIncludes' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IX_RDS_FactK12StudentCounts_SchoolYearId_FactTypeId_SeaId_WithIncludes]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_AgeId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_AgeId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_AgeId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_AttendanceId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_AttendanceId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_AttendanceId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_CohortStatusId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_CohortStatusId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_CohortStatusId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_CteStatusId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_CteStatusId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_CteStatusId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_EconomicallyDisadvantagedStatusId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_EconomicallyDisadvantagedStatusId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_EconomicallyDisadvantagedStatusId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_EnglishLearnerStatusId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_EnglishLearnerStatusId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_EnglishLearnerStatusId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_FactTypeId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_FactTypeId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_FactTypeId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_FosterCareStatusId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_FosterCareStatusId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_FosterCareStatusId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_GradeLevelId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_GradeLevelId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_GradeLevelId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_HomelessnessStatusId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_HomelessnessStatusId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_HomelessnessStatusId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_IdeaStatusesId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_IdeaStatusesId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_IdeaStatusesId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_ImmigrantStatusId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_ImmigrantStatusId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_ImmigrantStatusId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_K12AcademicAwardStatusId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_K12AcademicAwardStatusId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_K12AcademicAwardStatusId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_K12DemographicId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_K12DemographicId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_K12DemographicId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_K12EnrollmentStatusId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_K12EnrollmentStatusId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_K12EnrollmentStatusId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_K12SchoolId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_K12SchoolId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_K12Studentid]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_K12Studentid' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_K12Studentid]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_LanguageId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_LanguageId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_LanguageId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_LeaId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_LeaId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_LeaId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_MigrantStatusId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_MigrantStatusId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_MigrantStatusId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_MigrantStudentQualifyingArrivalDateId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_MigrantStudentQualifyingArrivalDateId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_MigrantStudentQualifyingArrivalDateId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_NOrDStatusId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_NOrDStatusId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_NOrDStatusId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_PrimaryDisabilityTypeId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_PrimaryDisabilityTypeId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_PrimaryDisabilityTypeId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_RaceId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_RaceId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_RaceId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_SchoolYearId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_SchoolYearId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_SeaId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_SeaId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_SeaId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_SpecialEducationServicesExitDateId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_SpecialEducationServicesExitDateId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_SpecialEducationServicesExitDateId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_StatusEndDateEnglishLearnerId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_StatusEndDateEnglishLearnerId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_StatusEndDateEnglishLearnerId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_StatusStartDateEnglishLearnerId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_StatusStartDateEnglishLearnerId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_StatusStartDateEnglishLearnerId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_TitleIIIStatusId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_TitleIIIStatusId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_TitleIIIStatusId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_TitleIStatusId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCounts_TitleIStatusId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCounts'))
    DROP INDEX [IXFK_FactK12StudentCounts_TitleIStatusId]
    ON [RDS].[FactK12StudentCounts];



PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_K12CourseId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCourseSections_K12CourseId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCourseSections'))
    DROP INDEX [IXFK_FactK12StudentCourseSections_K12CourseId]
    ON [RDS].[FactK12StudentCourseSections];



PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_LeaIds]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentCourseSections_LeaIds' AND object_id = OBJECT_ID(N'RDS.FactK12StudentCourseSections'))
    DROP INDEX [IXFK_FactK12StudentCourseSections_LeaIds]
    ON [RDS].[FactK12StudentCourseSections];



PRINT N'Dropping Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_PrimaryDisabilityTypes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentDisciplines_PrimaryDisabilityTypes' AND object_id = OBJECT_ID(N'RDS.FactK12StudentDisciplines'))
    DROP INDEX [IXFK_FactK12StudentDisciplines_PrimaryDisabilityTypes]
    ON [RDS].[FactK12StudentDisciplines];



PRINT N'Dropping Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_SecondaryDisabilityTypes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentDisciplines_SecondaryDisabilityTypes' AND object_id = OBJECT_ID(N'RDS.FactK12StudentDisciplines'))
    DROP INDEX [IXFK_FactK12StudentDisciplines_SecondaryDisabilityTypes]
    ON [RDS].[FactK12StudentDisciplines];



PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_LeaMembershipResidentId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentEnrollments_LeaMembershipResidentId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentEnrollments'))
    DROP INDEX [IXFK_FactK12StudentEnrollments_LeaMembershipResidentId]
    ON [RDS].[FactK12StudentEnrollments];



PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_PrimaryDisabilityTypes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentEnrollments_PrimaryDisabilityTypes' AND object_id = OBJECT_ID(N'RDS.FactK12StudentEnrollments'))
    DROP INDEX [IXFK_FactK12StudentEnrollments_PrimaryDisabilityTypes]
    ON [RDS].[FactK12StudentEnrollments];



PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_ResponsibleSchoolTypeId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentEnrollments_ResponsibleSchoolTypeId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentEnrollments'))
    DROP INDEX [IXFK_FactK12StudentEnrollments_ResponsibleSchoolTypeId]
    ON [RDS].[FactK12StudentEnrollments];



PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_SecodanryDisabilityTypes]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentEnrollments_SecodanryDisabilityTypes' AND object_id = OBJECT_ID(N'RDS.FactK12StudentEnrollments'))
    DROP INDEX [IXFK_FactK12StudentEnrollments_SecodanryDisabilityTypes]
    ON [RDS].[FactK12StudentEnrollments];



PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusEndDateEconomicallyDisadvantageId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentEnrollments_StatusEndDateEconomicallyDisadvantageId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentEnrollments'))
    DROP INDEX [IXFK_FactK12StudentEnrollments_StatusEndDateEconomicallyDisadvantageId]
    ON [RDS].[FactK12StudentEnrollments];



PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusEndDatePerkinsELId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentEnrollments_StatusEndDatePerkinsELId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentEnrollments'))
    DROP INDEX [IXFK_FactK12StudentEnrollments_StatusEndDatePerkinsELId]
    ON [RDS].[FactK12StudentEnrollments];



PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusEndDateTitleIIIImmgirantId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentEnrollments_StatusEndDateTitleIIIImmgirantId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentEnrollments'))
    DROP INDEX [IXFK_FactK12StudentEnrollments_StatusEndDateTitleIIIImmgirantId]
    ON [RDS].[FactK12StudentEnrollments];



PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusStartDatePerkinsELId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactK12StudentEnrollments_StatusStartDatePerkinsELId' AND object_id = OBJECT_ID(N'RDS.FactK12StudentEnrollments'))
    DROP INDEX [IXFK_FactK12StudentEnrollments_StatusStartDatePerkinsELId]
    ON [RDS].[FactK12StudentEnrollments];



PRINT N'Dropping Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_EntryDateId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactPsStudentEnrollments_EntryDateId' AND object_id = OBJECT_ID(N'RDS.FactPsStudentEnrollments'))
    DROP INDEX [IXFK_FactPsStudentEnrollments_EntryDateId]
    ON [RDS].[FactPsStudentEnrollments];



PRINT N'Dropping Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_ExitDateId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactPsStudentEnrollments_ExitDateId' AND object_id = OBJECT_ID(N'RDS.FactPsStudentEnrollments'))
    DROP INDEX [IXFK_FactPsStudentEnrollments_ExitDateId]
    ON [RDS].[FactPsStudentEnrollments];



PRINT N'Dropping Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_DimK12Schools_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IXFK_FactSpecialEducation_DimK12Schools_K12SchoolId' AND object_id = OBJECT_ID(N'RDS.FactSpecialEducation'))
    DROP INDEX [IXFK_FactSpecialEducation_DimK12Schools_K12SchoolId]
    ON [RDS].[FactSpecialEducation];



--PRINT N'Dropping Index [RDS].[ReportEdFactsK12StudentAssessments].[IX_FactStudentAssessmentReports_ReportCode_ReportYear_ReportLevel_CaterySetCode]...';



--DROP INDEX [IX_FactStudentAssessmentReports_ReportCode_ReportYear_ReportLevel_CaterySetCode]
--    ON [RDS].[ReportEdFactsK12StudentAssessments];



--PRINT N'Dropping Index [RDS].[ReportEdFactsK12StudentAssessments].[IX_FactStudentAssessmentReports_ReportCode_ReportYear_ReportLevel_CaterySetCode_SubJect_AssmentType_Grade]...';



--DROP INDEX [IX_FactStudentAssessmentReports_ReportCode_ReportYear_ReportLevel_CaterySetCode_SubJect_AssmentType_Grade]
--    ON [RDS].[ReportEdFactsK12StudentAssessments];



--PRINT N'Dropping Index [RDS].[ReportEDFactsK12StudentCounts].[IX_FactStudentCountReports_ReportCode_ReportYear_ReportLevel_CaterySetCode]...';



--DROP INDEX [IX_FactStudentCountReports_ReportCode_ReportYear_ReportLevel_CaterySetCode]
--    ON [RDS].[ReportEDFactsK12StudentCounts];



--PRINT N'Dropping Index [RDS].[ReportEdFactsOrganizationCounts].[IX_FactOrganizationCountReports_ReportCode_ReportYear_ReportLevel_CaterySetCode]...';



--DROP INDEX [IX_FactOrganizationCountReports_ReportCode_ReportYear_ReportLevel_CaterySetCode]
--    ON [RDS].[ReportEdFactsOrganizationCounts];



PRINT N'Dropping Index [RDS].[ReportEdFactsOrganizationCounts].[IX_FactOrganizationCountReports_ReportCode_ReportYear_ReportLevel_Grade_Organization]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_FactOrganizationCountReports_ReportCode_ReportYear_ReportLevel_Grade_Organization' AND object_id = OBJECT_ID(N'RDS.ReportEdFactsOrganizationCounts'))
    DROP INDEX [IX_FactOrganizationCountReports_ReportCode_ReportYear_ReportLevel_Grade_Organization]
    ON [RDS].[ReportEdFactsOrganizationCounts];



PRINT N'Dropping Index [Staging].[Assessment].[ix_Assessment_Identifier_Title_AcademicSubject_PerformanceLevel]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'ix_Assessment_Identifier_Title_AcademicSubject_PerformanceLevel' AND object_id = OBJECT_ID(N'Staging.Assessment'))
    DROP INDEX [ix_Assessment_Identifier_Title_AcademicSubject_PerformanceLevel]
    ON [Staging].[Assessment];



PRINT N'Dropping Index [Staging].[K12Enrollment].[IX_Staging_K12Enrollment_DataCollectionName]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_Staging_K12Enrollment_DataCollectionName' AND object_id = OBJECT_ID(N'Staging.K12Enrollment'))
    DROP INDEX [IX_Staging_K12Enrollment_DataCollectionName]
    ON [Staging].[K12Enrollment];



PRINT N'Dropping Index [Staging].[OrganizationGradeOffered].[ix_OrganizationGradeOffered_SchoolYear]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'ix_OrganizationGradeOffered_SchoolYear' AND object_id = OBJECT_ID(N'Staging.OrganizationGradeOffered'))
    DROP INDEX [ix_OrganizationGradeOffered_SchoolYear]
    ON [Staging].[OrganizationGradeOffered];



PRINT N'Dropping Index [Staging].[PersonStatus].[ix_PersonStatus_EnglishLearnerStatus]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'ix_PersonStatus_EnglishLearnerStatus' AND object_id = OBJECT_ID(N'Staging.PersonStatus'))
    DROP INDEX [ix_PersonStatus_EnglishLearnerStatus]
    ON [Staging].[PersonStatus];



PRINT N'Dropping Index [Staging].[PersonStatus].[ix_PersonStatus_HomelessnessStatus]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'ix_PersonStatus_HomelessnessStatus' AND object_id = OBJECT_ID(N'Staging.PersonStatus'))
    DROP INDEX [ix_PersonStatus_HomelessnessStatus]
    ON [Staging].[PersonStatus];



PRINT N'Dropping Index [Staging].[PersonStatus].[ix_PersonStatus_MigrantStatus]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'ix_PersonStatus_MigrantStatus' AND object_id = OBJECT_ID(N'Staging.PersonStatus'))
    DROP INDEX [ix_PersonStatus_MigrantStatus]
    ON [Staging].[PersonStatus];



PRINT N'Dropping Index [Staging].[PersonStatus].[ix_PersonStatus_ProgramType_FosterCare]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'ix_PersonStatus_ProgramType_FosterCare' AND object_id = OBJECT_ID(N'Staging.PersonStatus'))
    DROP INDEX [ix_PersonStatus_ProgramType_FosterCare]
    ON [Staging].[PersonStatus];



PRINT N'Dropping Index [Staging].[ProgramParticipationNorD].[IX_ProgramParticipationNOrD_Student_LEA_School_BeginDate_EndDate]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_ProgramParticipationNOrD_Student_LEA_School_BeginDate_EndDate' AND object_id = OBJECT_ID(N'Staging.ProgramParticipationNorD'))
    DROP INDEX [IX_ProgramParticipationNOrD_Student_LEA_School_BeginDate_EndDate]
    ON [Staging].[ProgramParticipationNorD];



PRINT N'Dropping Index [Staging].[ProgramParticipationSpecialEducation].[IX_Staging_ProgramParticipationSpecialEducation_ProgramParticipationEndDate]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_Staging_ProgramParticipationSpecialEducation_ProgramParticipationEndDate' AND object_id = OBJECT_ID(N'Staging.ProgramParticipationSpecialEducation'))
    DROP INDEX [IX_Staging_ProgramParticipationSpecialEducation_ProgramParticipationEndDate]
    ON [Staging].[ProgramParticipationSpecialEducation];



PRINT N'Dropping Index [Staging].[ProgramParticipationTitleIII].[IX_Staging_ProgramParticipationTitleIII_DataCollectionName]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_Staging_ProgramParticipationTitleIII_DataCollectionName' AND object_id = OBJECT_ID(N'Staging.ProgramParticipationTitleIII'))
    DROP INDEX [IX_Staging_ProgramParticipationTitleIII_DataCollectionName]
    ON [Staging].[ProgramParticipationTitleIII];



PRINT N'Dropping Default Constraint [RDS].[DF_CONSTRAINT [DF_BridgeK12StudentCourseSectionK12Staff_K12StaffId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_CONSTRAINT DF_BridgeK12StudentCourseSectionK12Staff_K12StaffId')
    ALTER TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff] DROP CONSTRAINT [DF_CONSTRAINT [DF_BridgeK12StudentCourseSectionK12Staff_K12StaffId];



PRINT N'Dropping Default Constraint [RDS].[DF_CONSTRAINT [DF_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSectionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_CONSTRAINT DF_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSectionId')
    ALTER TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff] DROP CONSTRAINT [DF_CONSTRAINT [DF_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSectionId];



PRINT N'Dropping Default Constraint [RDS].[DF_DimK12Schools_SchoolOperationalStatus]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_DimK12Schools_SchoolOperationalStatus')
    ALTER TABLE [RDS].[DimK12Schools] DROP CONSTRAINT [DF_DimK12Schools_SchoolOperationalStatus];



PRINT N'Dropping Default Constraint [RDS].[DF_DimLeas_RecordEndDateTime]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_DimLeas_RecordEndDateTime')
    ALTER TABLE [RDS].[DimLeas] DROP CONSTRAINT [DF_DimLeas_RecordEndDateTime];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateIdeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateIdeaId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateIdeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_MigrantStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_MigrantStatusId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_MigrantStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateMilitaryId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateMilitaryId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateMilitaryId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_IdeaStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_IdeaStatusId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_IdeaStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_K12StudentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_K12StudentId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_K12StudentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_RuralStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_RuralStatusId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_RuralStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateMigrantId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateMigrantId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateMigrantId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_EconomicallyDisadvantagedStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_EconomicallyDisadvantagedStatusId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_EconomicallyDisadvantagedStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_LearningResourceOrderedDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_LearningResourceOrderedDateId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_LearningResourceOrderedDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateMigrantId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateMigrantId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateMigrantId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDatePerkinsEnglishLearnerId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDatePerkinsEnglishLearnerId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDatePerkinsEnglishLearnerId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateMilitaryId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateMilitaryId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateMilitaryId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_CourSectionEndDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_CourSectionEndDateId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_CourSectionEndDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDatePerkinsEnglishLearnerId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDatePerkinsEnglishLearnerId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDatePerkinsEnglishLearnerId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_ImmigrantStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_ImmigrantStatusId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_ImmigrantStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_EntryGradeLevelId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_EntryGradeLevelId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_EntryGradeLevelId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateEnglishLearnerId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateEnglishLearnerId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateEnglishLearnerId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_DisabilityStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_DisabilityStatusId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_DisabilityStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_AgeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_AgeId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_AgeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_IeuId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_IeuId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_IeuId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_AccessibleEducationMaterialProviderId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_AccessibleEducationMaterialProviderId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_AccessibleEducationMaterialProviderId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateEconomicallyDisadvantagedId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateEconomicallyDisadvantagedId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateEconomicallyDisadvantagedId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_ScedCodeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_ScedCodeId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_ScedCodeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_HomelessnessStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_HomelessnessStatusId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_HomelessnessStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_LearningResourceReceivedDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_LearningResourceReceivedDateId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_LearningResourceReceivedDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateHomelessnessId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateHomelessnessId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateHomelessnessId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_AccessibleEducationMaterialStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_AccessibleEducationMaterialStatusId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_AccessibleEducationMaterialStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateEconomicallyDisadvantagedId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateEconomicallyDisadvantagedId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateEconomicallyDisadvantagedId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_RaceId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_RaceId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_RaceId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_EnglishLearnerStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_EnglishLearnerStatusId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_EnglishLearnerStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_LearningResourceIssuedDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_LearningResourceIssuedDateId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_LearningResourceIssuedDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_CountDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_CountDateId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_CountDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_K12CourseId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_K12CourseId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_K12CourseId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_LeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_LeaId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_LeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_MilitaryStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_MilitaryStatusId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_MilitaryStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_K12SchoolId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_K12SchoolId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_K12SchoolId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_DataCollectionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_DataCollectionId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_DataCollectionId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_PrimaryIdeaDisabilityTypeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_PrimaryIdeaDisabilityTypeId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_PrimaryIdeaDisabilityTypeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_EnrollmentEntryDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_EnrollmentEntryDateId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_EnrollmentEntryDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_SeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_SeaId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_SeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_SchoolYearId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_K12DemographicId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_K12DemographicId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_K12DemographicId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateHomelessnessId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateHomelessnessId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateHomelessnessId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_SecondaryIdeaDisabilityTypeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_SecondaryIdeaDisabilityTypeId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_SecondaryIdeaDisabilityTypeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateEnglishLearnerId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateEnglishLearnerId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateEnglishLearnerId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_FosterCareStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_FosterCareStatusId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_FosterCareStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_CourSectionStartDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_CourSectionStartDateId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_CourSectionStartDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_AssignmentCount]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_AssignmentCount')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_AssignmentCount];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_EnrollmentExitDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_EnrollmentExitDateId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_EnrollmentExitDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_K12EnrollmentStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_K12EnrollmentStatusId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_K12EnrollmentStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateIdeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateIdeaId')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateIdeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_ProgramParticipationExitDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_ProgramParticipationExitDateId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_ProgramParticipationExitDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_StudentCount]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_StudentCount')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_StudentCount];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_ProgramParticipationStartDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_ProgramParticipationStartDateId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_ProgramParticipationStartDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_LeaGraduationId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_LeaGraduationId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_LeaGraduationId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_K12SchoolId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_K12SchoolId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_K12SchoolId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_LeaAttendancId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_LeaAttendancId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_LeaAttendancId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_SchoolYearId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_SeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_SeaId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_SeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_IdeaStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_IdeaStatusId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_IdeaStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_IeuId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_IeuId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_IeuId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_DataCollectionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_DataCollectionId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_DataCollectionId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_K12ProgramTypeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_K12ProgramTypeId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_K12ProgramTypeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_LeaAccountabilityId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_LeaAccountabilityId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_LeaAccountabilityId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_LeaFundingId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_LeaFundingId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_LeaFundingId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_K12StudentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_K12StudentId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_K12StudentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_K12DemographicId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_K12DemographicId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_K12DemographicId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12ProgramParticipations_LeaIndividualizedEducationProgramId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12ProgramParticipations_LeaIndividualizedEducationProgramId')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF_FactK12ProgramParticipations_LeaIndividualizedEducationProgramId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_SeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StaffCounts_SeaId')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_SeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_CredentialIssuanceDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StaffCounts_CredentialIssuanceDateId')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_CredentialIssuanceDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_K12StaffStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StaffCounts_K12StaffStatusId')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_K12StaffStatusId];



--PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_K12StaffCateryId]...';



--ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_K12StaffCateryId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_K12SchoolId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StaffCounts_K12SchoolId')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_K12SchoolId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_CredentialExpirationDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StaffCounts_CredentialExpirationDateId')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_CredentialExpirationDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_FactTypeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StaffCounts_FactTypeId')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_FactTypeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_K12StaffId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StaffCounts_K12StaffId')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_K12StaffId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_LeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StaffCounts_LeaId')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_LeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_TitleIIIStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StaffCounts_TitleIIIStatusId')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_TitleIIIStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_StaffCount]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StaffCounts_StaffCount')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_StaffCount];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StaffCounts_SchoolYearId')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_CompetencyDefinitionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_CompetencyDefinitionId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_CompetencyDefinitionId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_LeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_LeaId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_LeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_FactTypeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_FactTypeId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_FactTypeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_TitleIIIStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_TitleIIIStatusId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_TitleIIIStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_SchoolYearId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_MigrantStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_MigrantStatusId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_MigrantStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_AssessmentRegistrationId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_AssessmentRegistrationId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentRegistrationId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_GradeLevelWhenAssessedId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_GradeLevelWhenAssessedId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_GradeLevelWhenAssessedId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_IdeaStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_IdeaStatusId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_IdeaStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_K12SchoolId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_K12SchoolId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_K12SchoolId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_AssessmentCount]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_AssessmentCount')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentCount];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_SeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_SeaId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_SeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_K12StudentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_K12StudentId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_K12StudentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_FactK12StudentAssessmentAccommodationId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_FactK12StudentAssessmentAccommodationId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_FactK12StudentAssessmentAccommodationId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_AssessmentResultId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_AssessmentResultId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentResultId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_HomelessnessStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_HomelessnessStatusId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_HomelessnessStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_IeuId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_IeuId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_IeuId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_AssessmentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_AssessmentId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_AssessmentAdministrationId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_AssessmentAdministrationId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentAdministrationId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_TitleIStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_TitleIStatusId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_TitleIStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_AssessmentPerformanceLevelId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_AssessmentPerformanceLevelId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentPerformanceLevelId];



PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactK12StudentAssessments]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF__FactK12St__Prima__1B293529')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF__FactK12St__Prima__1B293529];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_EconomicallyDisadvantagedStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_EconomicallyDisadvantagedStatusId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_EconomicallyDisadvantagedStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_FosterCareStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_FosterCareStatusId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_FosterCareStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_K12DemographicId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_K12DemographicId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_K12DemographicId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_NOrDStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_NOrDStatusId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_NOrDStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_EnglishLearnerStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_EnglishLearnerStatusId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_EnglishLearnerStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_AssessmentSubtestId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_AssessmentSubtestId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentSubtestId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_ImmigrantStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_ImmigrantStatusId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_ImmigrantStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_CteStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_CteStatusId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_CteStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_AssessmentParticipationSessionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_AssessmentParticipationSessionId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentParticipationSessionId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_MilitaryStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessments_MilitaryStatusId')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_MilitaryStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_RaceId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessmentsResultAggregates_RaceId')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_RaceId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_AcademicTermDesignatorId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessmentsResultAggregates_AcademicTermDesignatorId')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_AcademicTermDesignatorId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_SeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessmentsResultAggregates_SeaId')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_SeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_IeuId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessmentsResultAggregates_IeuId')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_IeuId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_CompetencyDefinitionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessmentsResultAggregates_CompetencyDefinitionId')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_CompetencyDefinitionId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_IdeaStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessmentsResultAggregates_IdeaStatusId')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_IdeaStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_AssessmentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessmentsResultAggregates_AssessmentId')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_AssessmentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessmentsResultAggregates_SchoolYearId')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_LeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessmentsResultAggregates_LeaId')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_LeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_K12DemographicId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessmentsResultAggregates_K12DemographicId')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_K12DemographicId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_AssessmentAdministrationId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessmentsResultAggregates_AssessmentAdministrationId')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_AssessmentAdministrationId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_K12SchoolId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessmentsResultAggregates_K12SchoolId')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_K12SchoolId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_AssessmentSubtestId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessmentsResultAggregates_AssessmentSubtestId')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_AssessmentSubtestId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_GradeLevelWhenAssessedId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAssessmentsResultAggregates_GradeLevelWhenAssessedId')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_GradeLevelWhenAssessedId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_LeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAttendanceRates_LeaId')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [DF_FactK12StudentAttendanceRates_LeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_AttendanceId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAttendanceRates_AttendanceId')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [DF_FactK12StudentAttendanceRates_AttendanceId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_FactTypeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAttendanceRates_FactTypeId')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [DF_FactK12StudentAttendanceRates_FactTypeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_K12DemographicId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAttendanceRates_K12DemographicId')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [DF_FactK12StudentAttendanceRates_K12DemographicId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAttendanceRates_SchoolYearId')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [DF_FactK12StudentAttendanceRates_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_K12SchoolId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAttendanceRates_K12SchoolId')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [DF_FactK12StudentAttendanceRates_K12SchoolId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_SeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAttendanceRates_SeaId')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [DF_FactK12StudentAttendanceRates_SeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_K12StudentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentAttendanceRates_K12StudentId')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [DF_FactK12StudentAttendanceRates_K12StudentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_SeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_SeaId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_SeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_CteStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_CteStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_CteStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_CohortGraduationYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_CohortGraduationYearId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_CohortGraduationYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_HomelessnessStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_HomelessnessStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_HomelessnessStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_ImmigrantStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_ImmigrantStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_ImmigrantStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_EnrollmentEntryDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_EnrollmentEntryDateId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_EnrollmentEntryDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_TitleIIIStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_TitleIIIStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_TitleIIIStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_StatusEndDateEnglishLearnerId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_StatusEndDateEnglishLearnerId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_StatusEndDateEnglishLearnerId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_StatusStartDateEnglishLearnerId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_StatusStartDateEnglishLearnerId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_StatusStartDateEnglishLearnerId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_LanguageId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_LanguageId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_LanguageId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_EnglishLearnerStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_EnglishLearnerStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_EnglishLearnerStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_NOrDStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_NOrDStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_NOrDStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_DisabilityStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_DisabilityStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_DisabilityStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_K12AcademicAwardStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_K12AcademicAwardStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_K12AcademicAwardStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_MigrantStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_MigrantStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_MigrantStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_EnrollmentStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_EnrollmentStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_EnrollmentStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_SchoolYearId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_StudentCount]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_StudentCount')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_StudentCount];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_K12SchoolId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_K12SchoolId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_K12SchoolId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_StatusEndDateNeglectedOrDelinquentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_StatusEndDateNeglectedOrDelinquentId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_StatusEndDateNeglectedOrDelinquentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_PrimaryDisabilityType]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_PrimaryDisabilityType')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_PrimaryDisabilityType];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_FosterCareStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_FosterCareStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_FosterCareStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_CteOutcomeIndicatorId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_CteOutcomeIndicatorId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_CteOutcomeIndicatorId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_CohortYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_CohortYearId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_CohortYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_StatusStartDateNeglectedOrDelinquentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_StatusStartDateNeglectedOrDelinquentId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_StatusStartDateNeglectedOrDelinquentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_SpecialEducationServicesExitDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_SpecialEducationServicesExitDateId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_SpecialEducationServicesExitDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_K12StudentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_K12StudentId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_K12StudentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_CohortStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_CohortStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_CohortStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_AgeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_AgeId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_AgeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_RaceId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_RaceId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_RaceId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_FactTypeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_FactTypeId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_FactTypeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_TitleIStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_TitleIStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_TitleIStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_IdeaStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_IdeaStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_IdeaStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_GradeLevelId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_GradeLevelId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_GradeLevelId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_K12Demographic]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_K12Demographic')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_K12Demographic];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_AttendanceId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_AttendanceId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_AttendanceId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_LeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_LeaId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_LeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_EnrollmentExitDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_EnrollmentExitDateId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_EnrollmentExitDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_EconomicallyDisadvantagedStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCounts_EconomicallyDisadvantagedStatusId')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_EconomicallyDisadvantagedStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_SchoolYearId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_EntryGradeLevelId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_EntryGradeLevelId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_EntryGradeLevelId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_IeuId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_IeuId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_IeuId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_StudentCourseSectionCount]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_StudentCourseSectionCount')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_StudentCourseSectionCount];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_DataCollectionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_DataCollectionId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_DataCollectionId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_CipCodeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_CipCodeId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_CipCodeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_SeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_SeaId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_SeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_K12CourseId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_K12CourseId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_K12CourseId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_LanguageId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_LanguageId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_LanguageId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_LeaGraduationId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_LeaGraduationId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_LeaGraduationId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_ScedCodeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_ScedCodeId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_ScedCodeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_LeaIndividualizedEducationProgramId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_LeaIndividualizedEducationProgramId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_LeaIndividualizedEducationProgramId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_LeaFundingId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_LeaFundingId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_LeaFundingId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_LeaAccountabilityId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_LeaAccountabilityId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_LeaAccountabilityId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_K12StudentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_K12StudentId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_K12StudentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_K12CourseStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_K12CourseStatusId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_K12CourseStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_K12DemographicId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_K12DemographicId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_K12DemographicId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_K12SchoolId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_K12SchoolId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_K12SchoolId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCourseSections_LeaAttendanceId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentCourseSections_LeaAttendanceId')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF_FactK12StudentCourseSections_LeaAttendanceId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDailyAttendances_PersonId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentDailyAttendances_PersonId')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [DF_FactK12StudentDailyAttendances_PersonId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDailyAttendances_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentDailyAttendances_SchoolYearId')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [DF_FactK12StudentDailyAttendances_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDailyAttendances_AttendanceEventDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentDailyAttendances_AttendanceEventDateId')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [DF_FactK12StudentDailyAttendances_AttendanceEventDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDailyAttendances_DataCollectionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentDailyAttendances_DataCollectionId')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [DF_FactK12StudentDailyAttendances_DataCollectionId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDailyAttendances_AttendanceId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentDailyAttendances_AttendanceId')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [DF_FactK12StudentDailyAttendances_AttendanceId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDailyAttendances_IeuId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentDailyAttendances_IeuId')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [DF_FactK12StudentDailyAttendances_IeuId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDailyAttendances_LeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentDailyAttendances_LeaId')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [DF_FactK12StudentDailyAttendances_LeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDailyAttendances_K12SchoolId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentDailyAttendances_K12SchoolId')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [DF_FactK12StudentDailyAttendances_K12SchoolId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDailyAttendances_SeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentDailyAttendances_SeaId')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [DF_FactK12StudentDailyAttendances_SeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDisciplines_RaceId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentDisciplines_RaceId')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [DF_FactK12StudentDisciplines_RaceId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDisciplines_MilitaryId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentDisciplines_MilitaryId')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [DF_FactK12StudentDisciplines_MilitaryId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDisciplines_DataCollectionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentDisciplines_DataCollectionId')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [DF_FactK12StudentDisciplines_DataCollectionId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_PersonAddressId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEconomicDisadvantages_PersonAddressId')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_PersonAddressId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEconomicDisadvantages_SchoolYearId')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_K12StudentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEconomicDisadvantages_K12StudentId')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_K12StudentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_CountDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEconomicDisadvantages_CountDateId')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_CountDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_EconomicallyDisadvantagedStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEconomicDisadvantages_EconomicallyDisadvantagedStatusId')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_EconomicallyDisadvantagedStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_NcesSideVantageBeginYearDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEconomicDisadvantages_NcesSideVantageBeginYearDateId')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_NcesSideVantageBeginYearDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_DataCollectionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEconomicDisadvantages_DataCollectionId')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_DataCollectionId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_SeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEconomicDisadvantages_SeaId')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_SeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_LeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEconomicDisadvantages_LeaId')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_LeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_K12SchoolId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEconomicDisadvantages_K12SchoolId')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_K12SchoolId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_NcesSideVantageEndYearDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEconomicDisadvantages_NcesSideVantageEndYearDateId')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_NcesSideVantageEndYearDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_IeuId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEconomicDisadvantages_IeuId')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_IeuId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_K12DemographicId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEconomicDisadvantages_K12DemographicId')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_K12DemographicId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEnrollments_ResponsibleSchoolTypeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEnrollments_ResponsibleSchoolTypeId')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [DF_FactK12StudentEnrollments_ResponsibleSchoolTypeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEnrollments_LeaMembershipResidentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEnrollments_LeaMembershipResidentId')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [DF_FactK12StudentEnrollments_LeaMembershipResidentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentEnrollments_CountDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactK12StudentEnrollments_CountDateId')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [DF_FactK12StudentEnrollments_CountDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_ReasonApplicabilityId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_ReasonApplicabilityId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_ReasonApplicabilityId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_K12SchoolStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_K12SchoolStatusId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_K12SchoolStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_K12StaffId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_K12StaffId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_K12StaffId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_AuthorizingBodyCharterSchoolAuthorizerId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_AuthorizingBodyCharterSchoolAuthorizerId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_AuthorizingBodyCharterSchoolAuthorizerId];



--PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_OrganizationTitleIStatusId]...';



--ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_OrganizationTitleIStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_SecondaryAuthorizingBodyCharterSchoolAuthorizerId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_SecondaryAuthorizingBodyCharterSchoolAuthorizerId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_SecondaryAuthorizingBodyCharterSchoolAuthorizerId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_K12SchoolStateStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_K12SchoolStateStatusId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_K12SchoolStateStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_LeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_LeaId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_LeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_K12OrganizationStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_K12OrganizationStatusId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_K12OrganizationStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_CharterSchoolStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_CharterSchoolStatusId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_CharterSchoolStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_K12SchoolId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_K12SchoolId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_K12SchoolId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_ComprehensiveAndTargetedSupportId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_ComprehensiveAndTargetedSupportId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_ComprehensiveAndTargetedSupportId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_SubgroupId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_SubgroupId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_SubgroupId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_CharterSchoolUpdatedManagementOrganizationId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_CharterSchoolUpdatedManagementOrganizationId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_CharterSchoolUpdatedManagementOrganizationId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_OrganizationCount]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_OrganizationCount')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_OrganizationCount];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_FactTypeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_FactTypeId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_FactTypeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_CharterSchoolManagementOrganizationId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_CharterSchoolManagementOrganizationId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_CharterSchoolManagementOrganizationId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_SeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_SeaId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_SeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactOrganizationCounts_SchoolYearId')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicAwards_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicAwards_SchoolYearId')
    ALTER TABLE [RDS].[FactPsStudentAcademicAwards] DROP CONSTRAINT [DF_FactPsStudentAcademicAwards_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicAwards_PsDemographicId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicAwards_PsDemographicId')
    ALTER TABLE [RDS].[FactPsStudentAcademicAwards] DROP CONSTRAINT [DF_FactPsStudentAcademicAwards_PsDemographicId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicRecords_PsInstitutionStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicRecords_PsInstitutionStatusId')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [DF_FactPsStudentAcademicRecords_PsInstitutionStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicRecords_StudentCourseCount]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicRecords_StudentCourseCount')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [DF_FactPsStudentAcademicRecords_StudentCourseCount];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicRecords_PsEnrollmentStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicRecords_PsEnrollmentStatusId')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [DF_FactPsStudentAcademicRecords_PsEnrollmentStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicRecords_CountDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicRecords_CountDateId')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [DF_FactPsStudentAcademicRecords_CountDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicRecords_SeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicRecords_SeaId')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [DF_FactPsStudentAcademicRecords_SeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicRecords_PsInstitutionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicRecords_PsInstitutionId')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [DF_FactPsStudentAcademicRecords_PsInstitutionId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicRecords_PsStudentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicRecords_PsStudentId')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [DF_FactPsStudentAcademicRecords_PsStudentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicRecords_EnrollmentEntryDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicRecords_EnrollmentEntryDateId')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [DF_FactPsStudentAcademicRecords_EnrollmentEntryDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicRecords_DataCollectionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicRecords_DataCollectionId')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [DF_FactPsStudentAcademicRecords_DataCollectionId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicRecords_EnrollmentExitDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicRecords_EnrollmentExitDateId')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [DF_FactPsStudentAcademicRecords_EnrollmentExitDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicRecords_AcademicTermDesignatorId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicRecords_AcademicTermDesignatorId')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [DF_FactPsStudentAcademicRecords_AcademicTermDesignatorId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicRecords_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicRecords_SchoolYearId')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [DF_FactPsStudentAcademicRecords_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentAcademicRecords_PsDemographicId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentAcademicRecords_PsDemographicId')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [DF_FactPsStudentAcademicRecords_PsDemographicId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentEnrollments_AcademicTermDesignatorId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentEnrollments_AcademicTermDesignatorId')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [DF_FactPsStudentEnrollments_AcademicTermDesignatorId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentEnrollments_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentEnrollments_SchoolYearId')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [DF_FactPsStudentEnrollments_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentEnrollments_PsInstitutionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentEnrollments_PsInstitutionId')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [DF_FactPsStudentEnrollments_PsInstitutionId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentEnrollments_StudentCount]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentEnrollments_StudentCount')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [DF_FactPsStudentEnrollments_StudentCount];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentEnrollments_PsInstitutionStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentEnrollments_PsInstitutionStatusId')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [DF_FactPsStudentEnrollments_PsInstitutionStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentEnrollments_PsStudentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentEnrollments_PsStudentId')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [DF_FactPsStudentEnrollments_PsStudentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentEnrollments_EnrollmentEntryDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentEnrollments_EnrollmentEntryDateId')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [DF_FactPsStudentEnrollments_EnrollmentEntryDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentEnrollments_CountDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentEnrollments_CountDateId')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [DF_FactPsStudentEnrollments_CountDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentEnrollments_EntryDateIntoPostSecondaryId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentEnrollments_EntryDateIntoPostSecondaryId')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [DF_FactPsStudentEnrollments_EntryDateIntoPostSecondaryId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentEnrollments_EnrollmentExitDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentEnrollments_EnrollmentExitDateId')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [DF_FactPsStudentEnrollments_EnrollmentExitDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentEnrollments_PsEnrollmentStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentEnrollments_PsEnrollmentStatusId')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [DF_FactPsStudentEnrollments_PsEnrollmentStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactPsStudentEnrollments_DataCollectionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactPsStudentEnrollments_DataCollectionId')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [DF_FactPsStudentEnrollments_DataCollectionId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_ChildOutcomeSummaryAtExitId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_ChildOutcomeSummaryAtExitId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_ChildOutcomeSummaryAtExitId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_LeaAttendanceId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_LeaAttendanceId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_LeaAttendanceId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_EconomicallyDisadvantagedStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_EconomicallyDisadvantagedStatusId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_EconomicallyDisadvantagedStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_SecondaryDisabilityTypeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_SecondaryDisabilityTypeId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_SecondaryDisabilityTypeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_NOrDStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_NOrDStatusId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_NOrDStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_LeaAccountabilityId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_LeaAccountabilityId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_LeaAccountabilityId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_IndividualizedProgramStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_IndividualizedProgramStatusId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_IndividualizedProgramStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_EnglishLearnerStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_EnglishLearnerStatusId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_EnglishLearnerStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_IdeaStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_IdeaStatusId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_IdeaStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_CteStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_CteStatusId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_CteStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_DisabilityStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_DisabilityStatusId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_DisabilityStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_EntryGradeLevelId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_EntryGradeLevelId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_EntryGradeLevelId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_EligibilityEvaluationDateReevaluationId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_EligibilityEvaluationDateReevaluationId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_EligibilityEvaluationDateReevaluationId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_HomelessnessStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_HomelessnessStatusId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_HomelessnessStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_ChildOutcomeSummaryDateAtExitId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_ChildOutcomeSummaryDateAtExitId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_ChildOutcomeSummaryDateAtExitId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_PrimaryDisabilityTypeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_PrimaryDisabilityTypeId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_PrimaryDisabilityTypeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_ProgramParticipationStartDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_ProgramParticipationStartDateId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_ProgramParticipationStartDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_SpecialEducationServicesExitDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_SpecialEducationServicesExitDateId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_SpecialEducationServicesExitDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_ImmigrantStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_ImmigrantStatusId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_ImmigrantStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_DataCollectionId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_DataCollectionId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_DataCollectionId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_K12SchoolId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_K12SchoolId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_K12SchoolId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_LeaGraduationId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_LeaGraduationId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_LeaGraduationId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_MigrantStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_MigrantStatusId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_MigrantStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_K12EnrollmentStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_K12EnrollmentStatusId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_K12EnrollmentStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_EnrollmentEntryDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_EnrollmentEntryDateId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_EnrollmentEntryDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_ConsentToEvaluationDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_ConsentToEvaluationDateId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_ConsentToEvaluationDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_IeuId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_IeuId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_IeuId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_ChildOutcomeSummaryDateBaselineId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_ChildOutcomeSummaryDateBaselineId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_ChildOutcomeSummaryDateBaselineId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_IndividualizedProgramServicePlanReevaluationDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_IndividualizedProgramServicePlanReevaluationDateId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_IndividualizedProgramServicePlanReevaluationDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_CountDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_CountDateId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_CountDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_LeaFundingId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_LeaFundingId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_LeaFundingId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_LeaIEPServiceProviderId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_LeaIEPServiceProviderId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_LeaIEPServiceProviderId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_IndividualizedProgramServicePlanExitDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_IndividualizedProgramServicePlanExitDateId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_IndividualizedProgramServicePlanExitDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_SchoolYearId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_SchoolYearId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_SchoolYearId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_ResponsibleSchoolTypeId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_ResponsibleSchoolTypeId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_ResponsibleSchoolTypeId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_IndividualizedProgramDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_IndividualizedProgramDateId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_IndividualizedProgramDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_ChildOutcomeSummaryBaselineId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_ChildOutcomeSummaryBaselineId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_ChildOutcomeSummaryBaselineId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_EligibilityEvaluationDateInitialId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_EligibilityEvaluationDateInitialId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_EligibilityEvaluationDateInitialId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_TitleIIIStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_TitleIIIStatusId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_TitleIIIStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_K12DemographicId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_K12DemographicId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_K12DemographicId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_LeaIndividualizedEducationProgramId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_LeaIndividualizedEducationProgramId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_LeaIndividualizedEducationProgramId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_FosterCareId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_FosterCareId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_FosterCareId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_K12StudentId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_K12StudentId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_K12StudentId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_MilitaryStatusId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_MilitaryStatusId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_MilitaryStatusId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_EnrollmentExitDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_EnrollmentExitDateId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_EnrollmentExitDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_SeaId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_SeaId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_SeaId];



PRINT N'Dropping Default Constraint [RDS].[DF_FactSpecialEducation_IndividualizedProgramServicePlanDateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_FactSpecialEducation_IndividualizedProgramServicePlanDateId')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [DF_FactSpecialEducation_IndividualizedProgramServicePlanDateId];



PRINT N'Dropping Default Constraint [RDS].[DF_DimCharterSchoolManagementOrganizations_RecordEndDateTime]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_DimCharterSchoolManagementOrganizations_RecordEndDateTime')
    ALTER TABLE [RDS].[DimCharterSchoolManagementOrganizations] DROP CONSTRAINT [DF_DimCharterSchoolManagementOrganizations_RecordEndDateTime];



PRINT N'Dropping Default Constraint [RDS].[DF_ToggleAssessments_Subject]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_ToggleAssessments_Subject')
    ALTER TABLE [APP].[ToggleAssessments] DROP CONSTRAINT [DF_ToggleAssessments_Subject];



PRINT N'Dropping Default Constraint [RDS].[DF_DimCompetencyDefinitionsCompetencyDefinitionValudStartDate]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_DimCompetencyDefinitionsCompetencyDefinitionValudStartDate')
    ALTER TABLE [RDS].[DimCompetencyDefinitions] DROP CONSTRAINT [DF_DimCompetencyDefinitionsCompetencyDefinitionValudStartDate];



PRINT N'Dropping Default Constraint [RDS].[DF_ReportEDFactsOrganizationCounts_TitleiParentalInvolveRes]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_ReportEDFactsOrganizationCounts_TitleiParentalInvolveRes')
    ALTER TABLE [RDS].[ReportEdFactsOrganizationCounts] DROP CONSTRAINT [DF_ReportEDFactsOrganizationCounts_TitleiParentalInvolveRes];



PRINT N'Dropping Default Constraint [RDS].[DF_ReportEDFactsOrganizationCounts_ParentOrganizationNcesId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_ReportEDFactsOrganizationCounts_ParentOrganizationNcesId')
    ALTER TABLE [RDS].[ReportEdFactsOrganizationCounts] DROP CONSTRAINT [DF_ReportEDFactsOrganizationCounts_ParentOrganizationNcesId];



PRINT N'Dropping Default Constraint [RDS].[DF_ReportEDFactsOrganizationCounts_TitleiPartaAllocations]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_ReportEDFactsOrganizationCounts_TitleiPartaAllocations')
    ALTER TABLE [RDS].[ReportEdFactsOrganizationCounts] DROP CONSTRAINT [DF_ReportEDFactsOrganizationCounts_TitleiPartaAllocations];



PRINT N'Dropping Default Constraint [RDS].[DF_ReportEDFactsOrganizationCounts_OutOfStateIndicator]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_ReportEDFactsOrganizationCounts_OutOfStateIndicator')
    ALTER TABLE [RDS].[ReportEdFactsOrganizationCounts] DROP CONSTRAINT [DF_ReportEDFactsOrganizationCounts_OutOfStateIndicator];



PRINT N'Dropping Default Constraint [RDS].[DF_ReportEDFactsOrganizationCounts_ParentOrganizationStateId]...';



IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE NAME = N'DF_ReportEDFactsOrganizationCounts_ParentOrganizationStateId')
    ALTER TABLE [RDS].[ReportEdFactsOrganizationCounts] DROP CONSTRAINT [DF_ReportEDFactsOrganizationCounts_ParentOrganizationStateId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionK12Staff_K12Staff]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentCourseSectionK12Staff_K12Staff' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentCourseSectionK12Staff')
    ALTER TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff] DROP CONSTRAINT [FK_BridgeK12StudentCourseSectionK12Staff_K12Staff];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSections]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSections' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentCourseSectionK12Staff')
    ALTER TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff] DROP CONSTRAINT [FK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSections];



PRINT N'Dropping Foreign Key [RDS].[FK_FactAeStudentEnrollments_AeProviderId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactAeStudentEnrollments_AeProviderId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactAeStudentEnrollments')
    ALTER TABLE [RDS].[FactAeStudentEnrollments] DROP CONSTRAINT [FK_FactAeStudentEnrollments_AeProviderId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_AssessmentAdministrationId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessmentsResultAggregates_AssessmentAdministrationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessmentsResultAggregates')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_AssessmentAdministrationId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionsCipCodes_CipCodeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentCourseSectionsCipCodes_CipCodeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentCourseSectionsCipCodes')
    ALTER TABLE [RDS].[BridgeK12StudentCourseSectionsCipCodes] DROP CONSTRAINT [FK_BridgeK12StudentCourseSectionsCipCodes_CipCodeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_CipCodeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_CipCodeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_CipCodeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_IeuId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessmentsResultAggregates_IeuId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessmentsResultAggregates')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_IeuId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_IeuId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEconomicDisadvantages_IeuId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEconomicDisadvantages')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_IeuId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_IeuId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_IeuId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_IeuId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_IeuId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_IeuId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_IeuId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_IeuId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_IeuId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_IeuId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_IeuId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_IeuId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_IeuId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12SalarySchedules_IeuId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12SalarySchedules_IeuId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12SalarySchedules')
    ALTER TABLE [RDS].[FactK12SalarySchedules] DROP CONSTRAINT [FK_FactK12SalarySchedules_IeuId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDailyAttendances_IeuId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDailyAttendances_IeuId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDailyAttendances')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [FK_FactK12StudentDailyAttendances_IeuId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_IeuId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_IeuId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_IeuId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessmentsResultAggregates_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessmentsResultAggregates')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAttendanceRates_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAttendanceRates')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [FK_FactK12StudentAttendanceRates_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEconomicDisadvantages_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEconomicDisadvantages')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactOrganizationCounts_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactOrganizationCounts')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12SchoolGradeLevels_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12SchoolGradeLevels_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12SchoolGradeLevels')
    ALTER TABLE [RDS].[BridgeK12SchoolGradeLevels] DROP CONSTRAINT [FK_BridgeK12SchoolGradeLevels_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12SalarySchedules_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12SalarySchedules_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12SalarySchedules')
    ALTER TABLE [RDS].[FactK12SalarySchedules] DROP CONSTRAINT [FK_FactK12SalarySchedules_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDailyAttendances_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDailyAttendances_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDailyAttendances')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [FK_FactK12StudentDailyAttendances_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StaffCounts_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StaffCounts')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_K12SchoolId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_K12SchoolId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_K12SchoolId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_LeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessmentsResultAggregates_LeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessmentsResultAggregates')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_LeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_LeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAttendanceRates_LeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAttendanceRates')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [FK_FactK12StudentAttendanceRates_LeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_LeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEconomicDisadvantages_LeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEconomicDisadvantages')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_LeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_LeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_LeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_LeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_LeaIEPServiceProviderId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_LeaIEPServiceProviderId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_LeaIEPServiceProviderId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_LeaAccountabilityId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_LeaAccountabilityId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_LeaAccountabilityId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_LeaAttendanceId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_LeaAttendanceId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_LeaAttendanceId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_LeaFundingId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_LeaFundingId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_LeaFundingId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_LeaGraduationId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_LeaGraduationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_LeaGraduationId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_LeaIndividualizedEducationProgramId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_LeaIndividualizedEducationProgramId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_LeaIndividualizedEducationProgramId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_LeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_LeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_LeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_LeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactOrganizationCounts_LeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactOrganizationCounts')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_LeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_LeaAccountabilityId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_LeaAccountabilityId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_LeaAccountabilityId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_LeaAttendanceId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_LeaAttendanceId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_LeaAttendanceId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_LeaFundingId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_LeaFundingId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_LeaFundingId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_LeaGraduationId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_LeaGraduationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_LeaGraduationId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_LeaIndividualizedEducationProgramId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_LeaIndividualizedEducationProgramId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_LeaIndividualizedEducationProgramId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeLeaGradeLevels_LeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeLeaGradeLevels_LeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeLeaGradeLevels')
    ALTER TABLE [RDS].[BridgeLeaGradeLevels] DROP CONSTRAINT [FK_BridgeLeaGradeLevels_LeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_LeaID]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_LeaID' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_LeaID];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_LeaAccountabilityId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_LeaAccountabilityId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_LeaAccountabilityId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_LeaAttendanceId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_LeaAttendanceId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_LeaAttendanceId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_LeaFundingId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_LeaFundingId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_LeaFundingId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_LeaGraduationID]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_LeaGraduationID' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_LeaGraduationID];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_LeaIndividualizedEducationProgramId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_LeaIndividualizedEducationProgramId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_LeaIndividualizedEducationProgramId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12SalarySchedules_LeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12SalarySchedules_LeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12SalarySchedules')
    ALTER TABLE [RDS].[FactK12SalarySchedules] DROP CONSTRAINT [FK_FactK12SalarySchedules_LeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDailyAttendances_LeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDailyAttendances_LeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDailyAttendances')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [FK_FactK12StudentDailyAttendances_LeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_LeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StaffCounts_LeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StaffCounts')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_LeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_LeaAccountabilityId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_LeaAccountabilityId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_LeaAccountabilityId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_LeaAttendanceId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_LeaAttendanceId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_LeaAttendanceId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_LeaFundingId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_LeaFundingId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_LeaFundingId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_LeaIndividualizedEducationProgramId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_LeaIndividualizedEducationProgramId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_LeaIndividualizedEducationProgramId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_GraduationLeaID]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_GraduationLeaID' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_GraduationLeaID];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_LeaMembershipResidentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_LeaMembershipResidentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_LeaMembershipResidentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_MilitaryStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_MilitaryStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_MilitaryStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_MilitaryStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_MilitaryStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_MilitaryStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_MilitaryStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_MilitaryStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_MilitaryStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_MilitaryStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_MilitaryStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_MilitaryStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_NOrDStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_NOrDStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_NOrDStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_NOrDStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessments_NOrDStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessments')
    ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_NOrDStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_NOrDStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_NOrDStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_NOrDStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_K12StudentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAttendanceRates_K12StudentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAttendanceRates')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [FK_FactK12StudentAttendanceRates_K12StudentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_K12StudentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEconomicDisadvantages_K12StudentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEconomicDisadvantages')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_K12StudentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_K12StudentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_K12StudentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12StudentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_K12StudentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_K12StudentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_K12StudentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_K12StudentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_K12StudentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_K12StudentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_K12StudentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_K12StudentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_K12StudentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_PsStudentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicAwards_PsStudentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicAwards')
    ALTER TABLE [RDS].[FactPsStudentAcademicAwards] DROP CONSTRAINT [FK_FactPsStudentAcademicAwards_PsStudentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_K12StudentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_K12StudentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_K12StudentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_PsStudentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicRecords_PsStudentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicRecords')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_PsStudentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_K12StudentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_K12StudentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_K12StudentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDailyAttendances_PersonId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDailyAttendances_PersonId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDailyAttendances')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [FK_FactK12StudentDailyAttendances_PersonId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_PsStudentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentEnrollments_PsStudentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentEnrollments')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_PsStudentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_K12StaffId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StaffCounts_K12StaffId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StaffCounts')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_K12StaffId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_K12StudentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_K12StudentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_K12StudentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactAeStudentEnrollments_AeStudentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactAeStudentEnrollments_AeStudentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactAeStudentEnrollments')
    ALTER TABLE [RDS].[FactAeStudentEnrollments] DROP CONSTRAINT [FK_FactAeStudentEnrollments_AeStudentId];



--PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_PSEnrollmentStatusId]...';



--ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_PSEnrollmentStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_PsEnrollmentStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicRecords_PsEnrollmentStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicRecords')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_PsEnrollmentStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_PsEnrollmentStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentEnrollments_PsEnrollmentStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentEnrollments')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_PsEnrollmentStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_PsInstitutionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicAwards_PsInstitutionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicAwards')
    ALTER TABLE [RDS].[FactPsStudentAcademicAwards] DROP CONSTRAINT [FK_FactPsStudentAcademicAwards_PsInstitutionId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_PsInstitutionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicRecords_PsInstitutionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicRecords')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_PsInstitutionId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_PsInstitutionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentEnrollments_PsInstitutionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentEnrollments')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_PsInstitutionId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeAeStudentEnrollmentRaces_FactAeStudentEnrollmentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeAeStudentEnrollmentRaces_FactAeStudentEnrollmentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeAeStudentEnrollmentRaces')
    ALTER TABLE [RDS].[BridgeAeStudentEnrollmentRaces] DROP CONSTRAINT [FK_BridgeAeStudentEnrollmentRaces_FactAeStudentEnrollmentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactAeStudentEnrollments_AeDemographicId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactAeStudentEnrollments_AeDemographicId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactAeStudentEnrollments')
    ALTER TABLE [RDS].[FactAeStudentEnrollments] DROP CONSTRAINT [FK_FactAeStudentEnrollments_AeDemographicId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactAeStudentEnrollments_AeProgramYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactAeStudentEnrollments_AeProgramYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactAeStudentEnrollments')
    ALTER TABLE [RDS].[FactAeStudentEnrollments] DROP CONSTRAINT [FK_FactAeStudentEnrollments_AeProgramYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactAeStudentEnrollments_AePostsecondaryTransitionDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactAeStudentEnrollments_AePostsecondaryTransitionDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactAeStudentEnrollments')
    ALTER TABLE [RDS].[FactAeStudentEnrollments] DROP CONSTRAINT [FK_FactAeStudentEnrollments_AePostsecondaryTransitionDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactAeStudentEnrollments_AeProgramTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactAeStudentEnrollments_AeProgramTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactAeStudentEnrollments')
    ALTER TABLE [RDS].[FactAeStudentEnrollments] DROP CONSTRAINT [FK_FactAeStudentEnrollments_AeProgramTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactAeStudentEnrollments_AeStudentStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactAeStudentEnrollments_AeStudentStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactAeStudentEnrollments')
    ALTER TABLE [RDS].[FactAeStudentEnrollments] DROP CONSTRAINT [FK_FactAeStudentEnrollments_AeStudentStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactAeStudentEnrollments_ApplicationDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactAeStudentEnrollments_ApplicationDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactAeStudentEnrollments')
    ALTER TABLE [RDS].[FactAeStudentEnrollments] DROP CONSTRAINT [FK_FactAeStudentEnrollments_ApplicationDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactAeStudentEnrollments_DataCollectionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactAeStudentEnrollments_DataCollectionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactAeStudentEnrollments')
    ALTER TABLE [RDS].[FactAeStudentEnrollments] DROP CONSTRAINT [FK_FactAeStudentEnrollments_DataCollectionId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactAeStudentEnrollments_EnrollmentEntryDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactAeStudentEnrollments_EnrollmentEntryDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactAeStudentEnrollments')
    ALTER TABLE [RDS].[FactAeStudentEnrollments] DROP CONSTRAINT [FK_FactAeStudentEnrollments_EnrollmentEntryDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactAeStudentEnrollments_EnrollmentExitDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactAeStudentEnrollments_EnrollmentExitDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactAeStudentEnrollments')
    ALTER TABLE [RDS].[FactAeStudentEnrollments] DROP CONSTRAINT [FK_FactAeStudentEnrollments_EnrollmentExitDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactAeStudentEnrollments_K12AcademicAwardStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactAeStudentEnrollments_K12AcademicAwardStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactAeStudentEnrollments')
    ALTER TABLE [RDS].[FactAeStudentEnrollments] DROP CONSTRAINT [FK_FactAeStudentEnrollments_K12AcademicAwardStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactAeStudentEnrollments_K12DiplomaOrCredentialAwardDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactAeStudentEnrollments_K12DiplomaOrCredentialAwardDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactAeStudentEnrollments')
    ALTER TABLE [RDS].[FactAeStudentEnrollments] DROP CONSTRAINT [FK_FactAeStudentEnrollments_K12DiplomaOrCredentialAwardDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_AccessibleEducationMaterialStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_AccessibleEducationMaterialStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_AccessibleEducationMaterialStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_AccessibleEducationMaterialProviderId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_AccessibleEducationMaterialProviderId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_AccessibleEducationMaterialProviderId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_CountDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_CountDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_CountDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_CourseSectionEndDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_CourseSectionEndDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_CourseSectionEndDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_CourseSectionStartDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_CourseSectionStartDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_CourseSectionStartDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_DataCollectionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_DataCollectionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_DataCollectionId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_AgeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_AgeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_AgeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_DisabilityStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_DisabilityStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_DisabilityStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_EconomicallyDisadvantagedStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_EconomicallyDisadvantagedStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EconomicallyDisadvantagedStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_EnglishLearnerStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_EnglishLearnerStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EnglishLearnerStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_EnrollmentEntryDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_EnrollmentEntryDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EnrollmentEntryDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_EnrollmentExitDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_EnrollmentExitDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EnrollmentExitDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_EntryGradeLevelId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_EntryGradeLevelId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EntryGradeLevelId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_FosterCareStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_FosterCareStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_FosterCareStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_HomelessnessStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_HomelessnessStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_HomelessnessStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_IdeaStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_IdeaStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_IdeaStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_ImmigrantStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_ImmigrantStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_ImmigrantStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_K12CourseId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_K12CourseId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12CourseId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_K12DemographicId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_K12DemographicId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12DemographicId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_K12EnrollmentStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_K12EnrollmentStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12EnrollmentStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceIssuedDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceIssuedDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceIssuedDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceOrderedDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceOrderedDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceOrderedDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceReceivedDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceReceivedDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceReceivedDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_MigrantStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_MigrantStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_MigrantStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_RaceId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_RaceId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_RaceId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_RuralStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_RuralStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_RuralStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_PrimaryIdeaDisabilityTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_PrimaryIdeaDisabilityTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_PrimaryIdeaDisabilityTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_ScedCodeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_ScedCodeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_ScedCodeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_SeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_SeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_SecondaryIdeaDisabilityTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_SecondaryIdeaDisabilityTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_SecondaryIdeaDisabilityTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateEconomicallyDisadvantagedId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateEconomicallyDisadvantagedId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateEconomicallyDisadvantagedId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateEnglishLearnerId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateEnglishLearnerId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateEnglishLearnerId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateHomelessnessId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateHomelessnessId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateHomelessnessId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateIdeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateIdeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateIdeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateMigrantId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateMigrantId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateMigrantId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateMilitaryId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateMilitaryId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateMilitaryId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDatePerkinsEnglishLearnerId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDatePerkinsEnglishLearnerId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDatePerkinsEnglishLearnerId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateEconomicallyDisadvantagedId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateEconomicallyDisadvantagedId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateEconomicallyDisadvantagedId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateEnglishLearnerId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateEnglishLearnerId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateEnglishLearnerId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateHomelessnessId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateHomelessnessId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateHomelessnessId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateIdeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateIdeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateIdeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateMigrantId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateMigrantId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateMigrantId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateMilitaryId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateMilitaryId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateMilitaryId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDatePerkinsEnglishLearnerId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDatePerkinsEnglishLearnerId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12AccessibleEducationMaterialAssignments')
    ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] DROP CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDatePerkinsEnglishLearnerId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12AccessibleEducationMaterialRaces_FactK12AccessibleEducationMaterialAssignments]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12AccessibleEducationMaterialRaces_FactK12AccessibleEducationMaterialAssignments' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12AccessibleEducationMaterialRaces')
    ALTER TABLE [RDS].[BridgeK12AccessibleEducationMaterialRaces] DROP CONSTRAINT [FK_BridgeK12AccessibleEducationMaterialRaces_FactK12AccessibleEducationMaterialAssignments];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes_FactK12AccessibleEducationMaterialAssignments]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes_FactK12AccessibleEducationMaterialAssignments' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes')
    ALTER TABLE [RDS].[BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes] DROP CONSTRAINT [FK_BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes_FactK12AccessibleEducationMaterialAssignments];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12ProgramParticipationRaces_FactK12ProgramParticipations]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12ProgramParticipationRaces_FactK12ProgramParticipations' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12ProgramParticipationRaces')
    ALTER TABLE [RDS].[BridgeK12ProgramParticipationRaces] DROP CONSTRAINT [FK_BridgeK12ProgramParticipationRaces_FactK12ProgramParticipations];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_SeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_SeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_DataCollectionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_DataCollectionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_DataCollectionId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_IdeaStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_IdeaStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_IdeaStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_K12Demographics]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_K12Demographics' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_K12Demographics];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_K12ProgramTypes]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_K12ProgramTypes' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_K12ProgramTypes];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_ProgramParticipationExitDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_ProgramParticipationExitDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_ProgramParticipationExitDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_ProgramParticipationStartDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_ProgramParticipationStartDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_ProgramParticipationStartDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12ProgramParticipations_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12ProgramParticipations')
    ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_SeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StaffCounts_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StaffCounts')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_SeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_FactTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StaffCounts_FactTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StaffCounts')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_FactTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_K12StaffCategoryId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StaffCounts_K12StaffCategoryId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StaffCounts')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_K12StaffCategoryId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_K12StaffStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StaffCounts_K12StaffStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StaffCounts')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_K12StaffStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StaffCounts_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StaffCounts')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_TitleIIIStatuses]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StaffCounts_TitleIIIStatuses' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StaffCounts')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_TitleIIIStatuses];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_CredentialIssuanceDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StaffCounts_CredentialIssuanceDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StaffCounts')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_CredentialIssuanceDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_CredentialExpirationDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StaffCounts_CredentialExpirationDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StaffCounts')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_CredentialExpirationDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentAssessmentRaces_FactK12StudentAssessments]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentAssessmentRaces_FactK12StudentAssessments' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentAssessmentRaces')
    ALTER TABLE [RDS].[BridgeK12StudentAssessmentRaces] DROP CONSTRAINT [FK_BridgeK12StudentAssessmentRaces_FactK12StudentAssessments];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_SeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessmentsResultAggregates_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessmentsResultAggregates')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_SeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_AcademicTermDesignatorId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessmentsResultAggregates_AcademicTermDesignatorId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessmentsResultAggregates')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_AcademicTermDesignatorId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_AssessmentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessmentsResultAggregates_AssessmentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessmentsResultAggregates')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_AssessmentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_AssessmentSubtestId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessmentsResultAggregates_AssessmentSubtestId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessmentsResultAggregates')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_AssessmentSubtestId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_CompetencyDefinitionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessmentsResultAggregates_CompetencyDefinitionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessmentsResultAggregates')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_CompetencyDefinitionId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_GradeLevelWhenAssessedId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessmentsResultAggregates_GradeLevelWhenAssessedId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessmentsResultAggregates')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_GradeLevelWhenAssessedId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_IdeaStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessmentsResultAggregates_IdeaStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessmentsResultAggregates')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_IdeaStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_K12DemographicId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessmentsResultAggregates_K12DemographicId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessmentsResultAggregates')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_K12DemographicId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_RaceId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessmentsResultAggregates_RaceId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessmentsResultAggregates')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_RaceId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAssessmentsResultAggregates_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAssessmentsResultAggregates')
    ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] DROP CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_AttendanceId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAttendanceRates_AttendanceId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAttendanceRates')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [FK_FactK12StudentAttendanceRates_AttendanceId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_FactTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAttendanceRates_FactTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAttendanceRates')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [FK_FactK12StudentAttendanceRates_FactTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_K12DemographicId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAttendanceRates_K12DemographicId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAttendanceRates')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [FK_FactK12StudentAttendanceRates_K12DemographicId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAttendanceRates_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAttendanceRates')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [FK_FactK12StudentAttendanceRates_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_SeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentAttendanceRates_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentAttendanceRates')
    ALTER TABLE [RDS].[FactK12StudentAttendanceRates] DROP CONSTRAINT [FK_FactK12StudentAttendanceRates_SeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_MigrantStudentQualifyingArrivalDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_MigrantStudentQualifyingArrivalDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_MigrantStudentQualifyingArrivalDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_SeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_SeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_CteOutcomeIndicatorId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_CteOutcomeIndicatorId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_CteOutcomeIndicatorId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_StatusStartDateEnglishLearnerId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_StatusStartDateEnglishLearnerId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_StatusStartDateEnglishLearnerId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_StatusEndDateEnglishLearnerId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_StatusEndDateEnglishLearnerId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_StatusEndDateEnglishLearnerId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_K12AcademicAwardStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_K12AcademicAwardStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_K12AcademicAwardStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_AgeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_AgeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_AgeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_AttendanceId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_AttendanceId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_AttendanceId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_CohortStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_CohortStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_CohortStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_CteStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_CteStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_CteStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_EconomicallyDisadvantagedStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_EconomicallyDisadvantagedStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_EconomicallyDisadvantagedStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_EnglishLearnerId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_EnglishLearnerId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_EnglishLearnerId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_FactTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_FactTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_FactTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_FosterCareStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_FosterCareStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_FosterCareStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_GradeLevelId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_GradeLevelId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_GradeLevelId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_HomelessnessStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_HomelessnessStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_HomelessnessStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_IdeaStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_IdeaStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_IdeaStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_ImmigrantStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_ImmigrantStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_ImmigrantStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_StatusStartDateNeglectedOrDelinquentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_StatusStartDateNeglectedOrDelinquentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_StatusStartDateNeglectedOrDelinquentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_K12DemographicId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_K12DemographicId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_K12DemographicId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_StatusEndDateNeglectedOrDelinquentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_StatusEndDateNeglectedOrDelinquentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_StatusEndDateNeglectedOrDelinquentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_K12EnrollmentStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_K12EnrollmentStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_K12EnrollmentStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_CohortYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_CohortYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_CohortYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_LanguageId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_LanguageId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_LanguageId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_CohortGraduationYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_CohortGraduationYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_CohortGraduationYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_MigrantStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_MigrantStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_MigrantStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_EnrollmentEntryDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_EnrollmentEntryDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_EnrollmentEntryDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_PrimaryDisabilityTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_PrimaryDisabilityTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_PrimaryDisabilityTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_EnrollmentExitDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_EnrollmentExitDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_EnrollmentExitDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_RaceId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_RaceId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_RaceId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_SpecialEducationServicesExitDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_SpecialEducationServicesExitDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_SpecialEducationServicesExitDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_TitleIIIStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_TitleIIIStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCounts')
    ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_TitleIIIStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionRace_FactK12StudentCourseSections]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentCourseSectionRace_FactK12StudentCourseSections' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentCourseSectionRaces')
    ALTER TABLE [RDS].[BridgeK12StudentCourseSectionRaces] DROP CONSTRAINT [FK_BridgeK12StudentCourseSectionRace_FactK12StudentCourseSections];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionsCipCodes_FactK12StudentCourseSections]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentCourseSectionsCipCodes_FactK12StudentCourseSections' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentCourseSectionsCipCodes')
    ALTER TABLE [RDS].[BridgeK12StudentCourseSectionsCipCodes] DROP CONSTRAINT [FK_BridgeK12StudentCourseSectionsCipCodes_FactK12StudentCourseSections];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_SeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_SeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_DataCollectionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_DataCollectionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_DataCollectionId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_EntryGradeLevelId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_EntryGradeLevelId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_EntryGradeLevelId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_K12CourseId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_K12CourseId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_K12CourseId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_K12CourseStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_K12CourseStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_K12CourseStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_K12DemographicId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_K12DemographicId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_K12DemographicId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_LanguageId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_LanguageId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_LanguageId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSections_ScedCodeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCourseSections_ScedCodeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentCourseSections')
    ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSections_ScedCodeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDailyAttendances_SeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDailyAttendances_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDailyAttendances')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [FK_FactK12StudentDailyAttendances_SeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDailyAttendances_DataCollectionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDailyAttendances_DataCollectionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDailyAttendances')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [FK_FactK12StudentDailyAttendances_DataCollectionId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDailyAttendances_AttendanceId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDailyAttendances_AttendanceId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDailyAttendances')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [FK_FactK12StudentDailyAttendances_AttendanceId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDailyAttendances_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDailyAttendances_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDailyAttendances')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [FK_FactK12StudentDailyAttendances_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDailyAttendances_AttendanceEventDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDailyAttendances_AttendanceEventDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDailyAttendances')
    ALTER TABLE [RDS].[FactK12StudentDailyAttendances] DROP CONSTRAINT [FK_FactK12StudentDailyAttendances_AttendanceEventDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentDisciplineRaces_FactK12StudentDisciplines]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentDisciplineRaces_FactK12StudentDisciplines' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentDisciplineRaces')
    ALTER TABLE [RDS].[BridgeK12StudentDisciplineRaces] DROP CONSTRAINT [FK_BridgeK12StudentDisciplineRaces_FactK12StudentDisciplines];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_SeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_SeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_AgeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_AgeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_AgeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_CteStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_CteStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_CteStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DisabilityStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_DisabilityStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DisabilityStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DisciplinaryActionEndDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_DisciplinaryActionEndDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DisciplinaryActionEndDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DisciplinaryActionStartDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_DisciplinaryActionStartDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DisciplinaryActionStartDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DisciplineStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_DisciplineStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DisciplineStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_EconomicallyDisadvantagedStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_EconomicallyDisadvantagedStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_EconomicallyDisadvantagedStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_EnglishLearnerStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_EnglishLearnerStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_EnglishLearnerStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_FactTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_FactTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_FactTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_FirearmId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_FirearmId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_FirearmId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_FirearmsDisciplineStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_FirearmsDisciplineStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_FirearmsDisciplineStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_FosterCareStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_FosterCareStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_FosterCareStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_GradeLevelId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_GradeLevelId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_GradeLevelId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_HomelessnessStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_HomelessnessStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_HomelessnessStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_IdeaStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_IdeaStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_IdeaStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_ImmigrantStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_ImmigrantStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_ImmigrantStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_IncidentDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_IncidentDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_IncidentDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_IncidentStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_IncidentStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_IncidentStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_K12DemographicId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_K12DemographicId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_K12DemographicId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_MigrantStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_MigrantStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_MigrantStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_PrimaryDisabilityTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_PrimaryDisabilityTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_PrimaryDisabilityTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_SecondaryDisabilityTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_SecondaryDisabilityTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_SecondaryDisabilityTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_TitleIIIStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_TitleIIIStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_TitleIIIStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DataCollectionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentDisciplines_DataCollectionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentDisciplines')
    ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DataCollectionId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentDisciplineIdeaDisabilityTypes_FactK12StudentDisciplines]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentDisciplineIdeaDisabilityTypes_FactK12StudentDisciplines' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentDisciplineIdeaDisabilityTypes')
    ALTER TABLE [RDS].[BridgeK12StudentDisciplineIdeaDisabilityTypes] DROP CONSTRAINT [FK_BridgeK12StudentDisciplineIdeaDisabilityTypes_FactK12StudentDisciplines];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentDisciplineIncidentBehaviors_FactK12StudentDisciplines]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentDisciplineIncidentBehaviors_FactK12StudentDisciplines' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentDisciplineIncidentBehaviors')
    ALTER TABLE [RDS].[BridgeK12StudentDisciplineIncidentBehaviors] DROP CONSTRAINT [FK_BridgeK12StudentDisciplineIncidentBehaviors_FactK12StudentDisciplines];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_SeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEconomicDisadvantages_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEconomicDisadvantages')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_SeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_CountDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEconomicDisadvantages_CountDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEconomicDisadvantages')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_CountDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_DataCollectionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEconomicDisadvantages_DataCollectionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEconomicDisadvantages')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_DataCollectionId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_EconomicallyDisadvantagedStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEconomicDisadvantages_EconomicallyDisadvantagedStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEconomicDisadvantages')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_EconomicallyDisadvantagedStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_K12DemographicId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEconomicDisadvantages_K12DemographicId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEconomicDisadvantages')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_K12DemographicId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_NcesSideVintageBeginYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEconomicDisadvantages_NcesSideVintageBeginYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEconomicDisadvantages')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_NcesSideVintageBeginYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_NcesSideVintageEndYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEconomicDisadvantages_NcesSideVintageEndYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEconomicDisadvantages')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_NcesSideVintageEndYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_PersonAddressId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEconomicDisadvantages_PersonAddressId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEconomicDisadvantages')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_PersonAddressId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEconomicDisadvantages_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEconomicDisadvantages')
    ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] DROP CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentEconomicDisadvantageRaces_FactK12StudentEconomicDisadvantageId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentEconomicDisadvantageRaces_FactK12StudentEconomicDisadvantageId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentEconomicDisadvantageRaces')
    ALTER TABLE [RDS].[BridgeK12StudentEconomicDisadvantageRaces] DROP CONSTRAINT [FK_BridgeK12StudentEconomicDisadvantageRaces_FactK12StudentEconomicDisadvantageId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentEnrollmentRaces')
    ALTER TABLE [RDS].[BridgeK12StudentEnrollmentRaces] DROP CONSTRAINT [FK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentEnrollmentPersonAddresses_FactK12StudentEnrollments]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentEnrollmentPersonAddresses_FactK12StudentEnrollments' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentEnrollmentPersonAddresses')
    ALTER TABLE [RDS].[BridgeK12StudentEnrollmentPersonAddresses] DROP CONSTRAINT [FK_BridgeK12StudentEnrollmentPersonAddresses_FactK12StudentEnrollments];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentEnrollmentIdeaDisabilityTypes_FactK12StudentEnrollmentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentEnrollmentIdeaDisabilityTypes_FactK12StudentEnrollmentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentEnrollmentIdeaDisabilityTypes')
    ALTER TABLE [RDS].[BridgeK12StudentEnrollmentIdeaDisabilityTypes] DROP CONSTRAINT [FK_BridgeK12StudentEnrollmentIdeaDisabilityTypes_FactK12StudentEnrollmentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_SeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_SeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_TitleIIIStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_TitleIIIStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_TitleIIIStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_CohortGraduationYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_CohortGraduationYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_CohortGraduationYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_CohortYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_CohortYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_CohortYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_CteStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_CteStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_CteStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DataCollectionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_DataCollectionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DataCollectionId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_EconomicallyDisadvantagedStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_EconomicallyDisadvantagedStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_EconomicallyDisadvantagedStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_EducationOrganizationNetworkId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_EducationOrganizationNetworkId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_EducationOrganizationNetworkId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_EnglishLearnerStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_EnglishLearnerStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_EnglishLearnerStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_EnrollmentEntryDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_EnrollmentEntryDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_EnrollmentEntryDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_EnrollmentExitDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_EnrollmentExitDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_EnrollmentExitDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_EntryGradeLevelId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_EntryGradeLevelId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_EntryGradeLevelId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_ExitGradeLevelId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_ExitGradeLevelId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_ExitGradeLevelId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_FosterCareStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_FosterCareStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_FosterCareStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_HomelessnessStatusEndDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_HomelessnessStatusEndDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_HomelessnessStatusEndDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_HomelessnessStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_HomelessnessStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_HomelessnessStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_HomelessnessStatusStartDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_HomelessnessStatusStartDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_HomelessnessStatusStartDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_IdeaStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_IdeaStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_IdeaStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_ImmigrantStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_ImmigrantStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_ImmigrantStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_K12DemographicId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_K12DemographicId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_K12DemographicId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_K12EnrollmentStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_K12EnrollmentStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_K12EnrollmentStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_LanguageHomeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_LanguageHomeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_LanguageHomeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_LanguageNativeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_LanguageNativeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_LanguageNativeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_MigrantStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_MigrantStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_MigrantStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_PrimaryDisabilityTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_PrimaryDisabilityTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_PrimaryDisabilityTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_ProjectedGraduationDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_ProjectedGraduationDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_ProjectedGraduationDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_SecondaryDisabilityTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_SecondaryDisabilityTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_SecondaryDisabilityTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusEndDateEconomicallyDisadvantagedId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_StatusEndDateEconomicallyDisadvantagedId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateEconomicallyDisadvantagedId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusEndDateEnglishLearnerId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_StatusEndDateEnglishLearnerId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateEnglishLearnerId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusEndDateIdeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_StatusEndDateIdeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateIdeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusEndDateMigrantId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_StatusEndDateMigrantId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateMigrantId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusEndDateMilitaryConnectedStudentId ]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_StatusEndDateMilitaryConnectedStudentId ' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateMilitaryConnectedStudentId ];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusEndDatePerkinsEnglishLearnerId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_StatusEndDatePerkinsEnglishLearnerId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDatePerkinsEnglishLearnerId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusEndDateTitleIIIImmigrantId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_StatusEndDateTitleIIIImmigrantId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateTitleIIIImmigrantId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusStartDateEconomicallyDisadvantagedId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_StatusStartDateEconomicallyDisadvantagedId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateEconomicallyDisadvantagedId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusStartDateEnglishLearnerId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_StatusStartDateEnglishLearnerId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateEnglishLearnerId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusStartDateIdeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_StatusStartDateIdeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateIdeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusStartDateMigrantId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_StatusStartDateMigrantId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateMigrantId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusStartDateMilitaryConnectedStudentId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_StatusStartDateMilitaryConnectedStudentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateMilitaryConnectedStudentId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusStartDatePerkinsEnglishLearnerId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_StatusStartDatePerkinsEnglishLearnerId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDatePerkinsEnglishLearnerId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusStartDateTitleIIIImmigrantId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_StatusStartDateTitleIIIImmigrantId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateTitleIIIImmigrantId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_CountDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_CountDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_CountDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_ResponsibleSchoolTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_ResponsibleSchoolTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StudentEnrollments')
    ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_ResponsibleSchoolTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_SeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactOrganizationCounts_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactOrganizationCounts')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_SeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_AuthorizingBodyCharterSchoolAuthorizerId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactOrganizationCounts_AuthorizingBodyCharterSchoolAuthorizerId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactOrganizationCounts')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_AuthorizingBodyCharterSchoolAuthorizerId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_CharterSchoolManagementOrganizationId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactOrganizationCounts_CharterSchoolManagementOrganizationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactOrganizationCounts')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_CharterSchoolManagementOrganizationId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_SecondaryAuthorizingBodyCharterSchoolAuthorizerId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactOrganizationCounts_SecondaryAuthorizingBodyCharterSchoolAuthorizerId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactOrganizationCounts')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_SecondaryAuthorizingBodyCharterSchoolAuthorizerId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_FactTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactOrganizationCounts_FactTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactOrganizationCounts')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_FactTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_K12SchoolStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactOrganizationCounts_K12SchoolStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactOrganizationCounts')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_K12SchoolStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactOrganizationCounts_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactOrganizationCounts')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_AcademicAwardDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicAwards_AcademicAwardDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicAwards')
    ALTER TABLE [RDS].[FactPsStudentAcademicAwards] DROP CONSTRAINT [FK_FactPsStudentAcademicAwards_AcademicAwardDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_PsAcademicAwardStatuId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicAwards_PsAcademicAwardStatuId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicAwards')
    ALTER TABLE [RDS].[FactPsStudentAcademicAwards] DROP CONSTRAINT [FK_FactPsStudentAcademicAwards_PsAcademicAwardStatuId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_PsAcademicAwardTitleId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicAwards_PsAcademicAwardTitleId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicAwards')
    ALTER TABLE [RDS].[FactPsStudentAcademicAwards] DROP CONSTRAINT [FK_FactPsStudentAcademicAwards_PsAcademicAwardTitleId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicAwards_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicAwards')
    ALTER TABLE [RDS].[FactPsStudentAcademicAwards] DROP CONSTRAINT [FK_FactPsStudentAcademicAwards_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_PsDemographicId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicAwards_PsDemographicId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicAwards')
    ALTER TABLE [RDS].[FactPsStudentAcademicAwards] DROP CONSTRAINT [FK_FactPsStudentAcademicAwards_PsDemographicId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_SeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicRecords_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicRecords')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_SeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_PsDemographicId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicRecords_PsDemographicId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicRecords')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_PsDemographicId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_CountDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicRecords_CountDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicRecords')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_CountDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_AcademicTermDesignatorId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicRecords_AcademicTermDesignatorId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicRecords')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_AcademicTermDesignatorId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_DataCollectionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicRecords_DataCollectionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicRecords')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_DataCollectionId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_EnrollmentEntryDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicRecords_EnrollmentEntryDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicRecords')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_EnrollmentEntryDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_EnrollmentExitDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicRecords_EnrollmentExitDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicRecords')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_EnrollmentExitDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_PsInstitutionStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicRecords_PsInstitutionStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicRecords')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_PsInstitutionStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicRecords_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentAcademicRecords')
    ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgePsStudentEnrollmentRaces')
    ALTER TABLE [RDS].[BridgePsStudentEnrollmentRaces] DROP CONSTRAINT [FK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_AcademicTermDesignatorId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentEnrollments_AcademicTermDesignatorId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentEnrollments')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_AcademicTermDesignatorId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_DataCollectionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentEnrollments_DataCollectionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentEnrollments')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_DataCollectionId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_EnrollmentEntryDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentEnrollments_EnrollmentEntryDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentEnrollments')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_EnrollmentEntryDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_EnrollmentExitDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentEnrollments_EnrollmentExitDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentEnrollments')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_EnrollmentExitDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_EntryDateIntoPostSecondaryId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentEnrollments_EntryDateIntoPostSecondaryId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentEnrollments')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_EntryDateIntoPostSecondaryId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_PsInstitutionStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentEnrollments_PsInstitutionStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentEnrollments')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_PsInstitutionStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentEnrollments_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentEnrollments')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_CountDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactPsStudentEnrollments_CountDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactPsStudentEnrollments')
    ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_CountDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSchoolPerformanceIndicators_DimFactTypes]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSchoolPerformanceIndicators_DimFactTypes' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSchoolPerformanceIndicators')
    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimFactTypes];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSchoolPerformanceIndicators_DimIdeaStatuses]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSchoolPerformanceIndicators_DimIdeaStatuses' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSchoolPerformanceIndicators')
    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimIdeaStatuses];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSchoolPerformanceIndicators_DimK12Demographics]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSchoolPerformanceIndicators_DimK12Demographics' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSchoolPerformanceIndicators')
    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimK12Demographics];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSchoolPerformanceIndicators_DimRaces]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSchoolPerformanceIndicators_DimRaces' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSchoolPerformanceIndicators')
    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimRaces];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicators]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicators' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSchoolPerformanceIndicators')
    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicators];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicatorStateDefinedStatuses]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicatorStateDefinedStatuses' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSchoolPerformanceIndicators')
    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicatorStateDefinedStatuses];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSchoolPerformanceIndicators_DimIndicatorStatuses]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSchoolPerformanceIndicators_DimIndicatorStatuses' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSchoolPerformanceIndicators')
    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimIndicatorStatuses];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSchoolPerformanceIndicators_DimSubgroups]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSchoolPerformanceIndicators_DimSubgroups' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSchoolPerformanceIndicators')
    ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] DROP CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSubgroups];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_CteStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_CteStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_CteStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_DataCollectionId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_DataCollectionId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_DataCollectionId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_EligibilityEvaluationDateInitialId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_EligibilityEvaluationDateInitialId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_EligibilityEvaluationDateInitialId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_EligibilityEvaluationDateReevaluationId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_EligibilityEvaluationDateReevaluationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_EligibilityEvaluationDateReevaluationId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_EnglishLearnerStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_EnglishLearnerStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_EnglishLearnerStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_EnrollmentEntryDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_EnrollmentEntryDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_EnrollmentEntryDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_EnrollmentExitDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_EnrollmentExitDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_EnrollmentExitDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_EntryGradeLevelId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_EntryGradeLevelId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_EntryGradeLevelId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_FosterCareStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_FosterCareStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_FosterCareStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_HomelessnessStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_HomelessnessStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_HomelessnessStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_IdeaStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_IdeaStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_IdeaStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_ImmigrantStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_ImmigrantStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_ImmigrantStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_IndividualizedProgramDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_IndividualizedProgramDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_IndividualizedProgramServicePlanDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_IndividualizedProgramServicePlanDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramServicePlanDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_IndividualizedProgramServicePlanExitDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_IndividualizedProgramServicePlanExitDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramServicePlanExitDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_IndividualizedProgramServicePlanReevaluationDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_IndividualizedProgramServicePlanReevaluationDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramServicePlanReevaluationDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_IndividualizedProgramStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_IndividualizedProgramStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_K12DemographicId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_K12DemographicId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_K12DemographicId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_K12EnrollmentStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_K12EnrollmentStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_K12EnrollmentStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_SeaId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_SeaId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_MigrantStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_MigrantStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_MigrantStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_PrimaryDisabilityTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_PrimaryDisabilityTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_PrimaryDisabilityTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_ProgramParticipationStartDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_ProgramParticipationStartDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_ProgramParticipationStartDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_ProgramStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_ProgramStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_ProgramStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_ResponsibleSchoolTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_ResponsibleSchoolTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_ResponsibleSchoolTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_SchoolYearId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_SchoolYearId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_SchoolYearId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_SecondaryDisabilityTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_SecondaryDisabilityTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_SecondaryDisabilityTypeId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_SpecialEducationServicesExitDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_SpecialEducationServicesExitDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_SpecialEducationServicesExitDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_TitleIIIStatusId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_TitleIIIStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_TitleIIIStatusId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_ChildOutcomeSummaryAtExitId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_ChildOutcomeSummaryAtExitId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_ChildOutcomeSummaryAtExitId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_ChildOutcomeSummaryBaselineId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_ChildOutcomeSummaryBaselineId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_ChildOutcomeSummaryBaselineId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_ChildOutcomeSummaryDateAtExitId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_ChildOutcomeSummaryDateAtExitId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_ChildOutcomeSummaryDateAtExitId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_ChildOutcomeSummaryDateBaselineId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_ChildOutcomeSummaryDateBaselineId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_ChildOutcomeSummaryDateBaselineId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_ConsentToEvaluationDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_ConsentToEvaluationDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_ConsentToEvaluationDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_FactSpecialEducation_CountDateId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactSpecialEducation_CountDateId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactSpecialEducation')
    ALTER TABLE [RDS].[FactSpecialEducation] DROP CONSTRAINT [FK_FactSpecialEducation_CountDateId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeSpecialEducationIdeaDisabilityTypes_FactSpecialEducationId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeSpecialEducationIdeaDisabilityTypes_FactSpecialEducationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeSpecialEducationIdeaDisabilityTypes')
    ALTER TABLE [RDS].[BridgeSpecialEducationIdeaDisabilityTypes] DROP CONSTRAINT [FK_BridgeSpecialEducationIdeaDisabilityTypes_FactSpecialEducationId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeSpecialEducationRaces_FactSpecialEducationId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeSpecialEducationRaces_FactSpecialEducationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeSpecialEducationRaces')
    ALTER TABLE [RDS].[BridgeSpecialEducationRaces] DROP CONSTRAINT [FK_BridgeSpecialEducationRaces_FactSpecialEducationId];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentDisciplineIncidentBehaviors_DimIncidentBehaviors]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentDisciplineIncidentBehaviors_DimIncidentBehaviors' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentDisciplineIncidentBehaviors')
    ALTER TABLE [RDS].[BridgeK12StudentDisciplineIncidentBehaviors] DROP CONSTRAINT [FK_BridgeK12StudentDisciplineIncidentBehaviors_DimIncidentBehaviors];



PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentEnrollmentIdeaDisabilityTypes_IdeaDisabilityTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentEnrollmentIdeaDisabilityTypes_IdeaDisabilityTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentEnrollmentIdeaDisabilityTypes')
    ALTER TABLE [RDS].[BridgeK12StudentEnrollmentIdeaDisabilityTypes] DROP CONSTRAINT [FK_BridgeK12StudentEnrollmentIdeaDisabilityTypes_IdeaDisabilityTypeId];



PRINT N'Dropping Unique Constraint [Staging].[UC_K12PersonRace]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'UC_K12PersonRace' AND TABLE_SCHEMA = N'Staging' AND TABLE_NAME = N'K12PersonRace')
    ALTER TABLE [Staging].[K12PersonRace] DROP CONSTRAINT [UC_K12PersonRace];



PRINT N'Dropping Primary Key [RDS].[PK_BridgeK12StudentDisciplineIdeaDisabilityTypeId]...';



IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'PK_BridgeK12StudentDisciplineIdeaDisabilityTypeId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentDisciplineIdeaDisabilityTypes')
    ALTER TABLE [RDS].[BridgeK12StudentDisciplineIdeaDisabilityTypes] DROP CONSTRAINT [PK_BridgeK12StudentDisciplineIdeaDisabilityTypeId];



PRINT N'Starting rebuilding table [RDS].[BridgeK12StudentCourseSectionK12Staff]...';


PRINT N'Dropping Index [RDS].[DimAssessmentAdministrations].[IX_DimAssessmentAdministrations_AssessmentAdministrationSubjectEdFactsCode]...';



IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimAssessmentAdministrations_AssessmentAdministrationSubjectEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimAssessmentAdministrations'))
    DROP INDEX [IX_DimAssessmentAdministrations_AssessmentAdministrationSubjectEdFactsCode]
    ON [RDS].[DimAssessmentAdministrations];

IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'ix_DimAssessmentRegistrations_CompletionStatus_FullYearAcademicCodes_ReasonNotTested' AND object_id = OBJECT_ID(N'RDS.DimAssessmentRegistrations'))
    DROP INDEX [ix_DimAssessmentRegistrations_CompletionStatus_FullYearAcademicCodes_ReasonNotTested]
    ON [RDS].[DimAssessmentRegistrations];

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBalances_IeuId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBalances')
    ALTER TABLE [RDS].[FactFinancialAccountBalances] DROP CONSTRAINT [FK_FactFinancialAccountBalances_IeuId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBudgets_IeuId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBudgets')
    ALTER TABLE [RDS].[FactFinancialAccountBudgets] DROP CONSTRAINT [FK_FactFinancialAccountBudgets_IeuId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountGeneralLedgers_IeuId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountGeneralLedgers')
    ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] DROP CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_IeuId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBalances_LeaFinancialAccountBalanceId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBalances')
    ALTER TABLE [RDS].[FactFinancialAccountBalances] DROP CONSTRAINT [FK_FactFinancialAccountBalances_LeaFinancialAccountBalanceId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBudgets_LeaFinancialAccountBalanceId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBudgets')
    ALTER TABLE [RDS].[FactFinancialAccountBudgets] DROP CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialAccountBalanceId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBalances_LeaFinancialAccountClassificationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBalances')
    ALTER TABLE [RDS].[FactFinancialAccountBalances] DROP CONSTRAINT [FK_FactFinancialAccountBalances_LeaFinancialAccountClassificationId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBudgets_LeaFinancialAccountClassificationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBudgets')
    ALTER TABLE [RDS].[FactFinancialAccountBudgets] DROP CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialAccountClassificationId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBalances_LeaFinancialAccountId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBalances')
    ALTER TABLE [RDS].[FactFinancialAccountBalances] DROP CONSTRAINT [FK_FactFinancialAccountBalances_LeaFinancialAccountId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBudgets_LeaFinancialAccountId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBudgets')
    ALTER TABLE [RDS].[FactFinancialAccountBudgets] DROP CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialAccountId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountGeneralLedgers_LeaFinancialAccountClassificationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountGeneralLedgers')
    ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] DROP CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_LeaFinancialAccountClassificationId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBudgets_LeaFinancialExpenditureClassificationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBudgets')
    ALTER TABLE [RDS].[FactFinancialAccountBudgets] DROP CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialExpenditureClassificationId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBudgets_LeaFinancialRevenueClassificationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBudgets')
    ALTER TABLE [RDS].[FactFinancialAccountBudgets] DROP CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialRevenueClassificationId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountGeneralLedgers_LeaFinancialExpenditureClassificationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountGeneralLedgers')
    ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] DROP CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_LeaFinancialExpenditureClassificationId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountGeneralLedgers_LeaFinancialRevenueClassificationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountGeneralLedgers')
    ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] DROP CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_LeaFinancialRevenueClassificationId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountGeneralLedgers_LeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountGeneralLedgers')
    ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] DROP CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_LeaId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBudgets_LeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBudgets')
    ALTER TABLE [RDS].[FactFinancialAccountBudgets] DROP CONSTRAINT [FK_FactFinancialAccountBudgets_LeaId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBalances_LeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBalances')
    ALTER TABLE [RDS].[FactFinancialAccountBalances] DROP CONSTRAINT [FK_FactFinancialAccountBalances_LeaId]

IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimSchoolPerformanceIndicatorCategories_SchoolPerformanceIndicatorCategoryCode' AND object_id = OBJECT_ID(N'RDS.DimSchoolPerformanceIndicatorCategories'))
	DROP INDEX [IX_DimSchoolPerformanceIndicatorCategories_SchoolPerformanceIndicatorCategoryCode] ON [RDS].[DimSchoolPerformanceIndicatorCategories]

IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_DimSchoolPerformanceIndicatorCategories_SchoolPerformanceIndicatorCategoryEdFactsCode' AND object_id = OBJECT_ID(N'RDS.DimSchoolPerformanceIndicatorCategories'))
	DROP INDEX [IX_DimSchoolPerformanceIndicatorCategories_SchoolPerformanceIndicatorCategoryEdFactsCode] ON [RDS].[DimSchoolPerformanceIndicatorCategories]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBalances_SeaFinancialAccountBalanceId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBalances')
    ALTER TABLE [RDS].[FactFinancialAccountBalances] DROP CONSTRAINT [FK_FactFinancialAccountBalances_SeaFinancialAccountBalanceId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBudgets_SeaFinancialAccountBalanceId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBudgets')
    ALTER TABLE [RDS].[FactFinancialAccountBudgets] DROP CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialAccountBalanceId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBalances_SeaFinancialAccountClassificationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBalances')
    ALTER TABLE [RDS].[FactFinancialAccountBalances] DROP CONSTRAINT [FK_FactFinancialAccountBalances_SeaFinancialAccountClassificationId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBudgets_SeaFinancialAccountClassificationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBudgets')
    ALTER TABLE [RDS].[FactFinancialAccountBudgets] DROP CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialAccountClassificationId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBalances_SeaFinancialAccountId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBalances')
    ALTER TABLE [RDS].[FactFinancialAccountBalances] DROP CONSTRAINT [FK_FactFinancialAccountBalances_SeaFinancialAccountId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBudgets_SeaFinancialAccountId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBudgets')
    ALTER TABLE [RDS].[FactFinancialAccountBudgets] DROP CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialAccountId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountGeneralLedgers_SeaFinancialAccountClassificationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountGeneralLedgers')
    ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] DROP CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_SeaFinancialAccountClassificationId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBudgets_SeaFinancialExpenditureClassificationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBudgets')
    ALTER TABLE [RDS].[FactFinancialAccountBudgets] DROP CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialExpenditureClassificationId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBudgets_SeaFinancialRevenueClassificationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBudgets')
    ALTER TABLE [RDS].[FactFinancialAccountBudgets] DROP CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialRevenueClassificationId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountGeneralLedgers_SeaFinancialExpenditureClassificationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountGeneralLedgers')
    ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] DROP CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_SeaFinancialExpenditureClassificationId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountGeneralLedgers_SeaFinancialRevenueClassificationId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountGeneralLedgers')
    ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] DROP CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_SeaFinancialRevenueClassificationId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountGeneralLedgers_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountGeneralLedgers')
    ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] DROP CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_SeaId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBudgets_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBudgets')
    ALTER TABLE [RDS].[FactFinancialAccountBudgets] DROP CONSTRAINT [FK_FactFinancialAccountBudgets_SeaId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_FactFinancialAccountBalances_SeaId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactFinancialAccountBalances')
    ALTER TABLE [RDS].[FactFinancialAccountBalances] DROP CONSTRAINT [FK_FactFinancialAccountBalances_SeaId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'DF_FactK12StaffCounts_K12StaffCategoryId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactK12StaffCounts')
    ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_K12StaffCategoryId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'DF_FactOrganizationCounts_TitleIStatusId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'FactOrganizationCounts')
    ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_TitleIStatusId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentAssessmentAccommodations_FactK12StudentAssessmentId' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentAssessmentAccommodations')
    ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccommodations] DROP CONSTRAINT [FK_BridgeK12StudentAssessmentAccommodations_FactK12StudentAssessmentId]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentDisciplineDiscplineReasons_FactK12StudentDisciplines' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentDisciplineDiscplineReasons')
    ALTER TABLE [RDS].[BridgeK12StudentDisciplineDiscplineReasons] DROP CONSTRAINT [FK_BridgeK12StudentDisciplineDiscplineReasons_FactK12StudentDisciplines]

IF EXISTS (SELECT NULL FROM sys.indexes WHERE [name] = N'IX_FactStudentCountReports_CategorySetCode_DISABILITY_Report' AND object_id = OBJECT_ID(N'RDS.ReportEDFactsK12StudentCounts'))
DROP INDEX [IX_FactStudentCountReports_CategorySetCode_DISABILITY_Report] ON [RDS].[ReportEDFactsK12StudentCounts]

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = N'FK_BridgeK12StudentDisciplineDiscplineReasons_DimDisciplineReasons' AND TABLE_SCHEMA = N'RDS' AND TABLE_NAME = N'BridgeK12StudentDisciplineDiscplineReasons')
    ALTER TABLE [RDS].[BridgeK12StudentDisciplineDiscplineReasons] DROP CONSTRAINT [FK_BridgeK12StudentDisciplineDiscplineReasons_DimDisciplineReasons]
