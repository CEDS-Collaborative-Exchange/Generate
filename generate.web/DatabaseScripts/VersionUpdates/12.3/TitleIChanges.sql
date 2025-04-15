----------------------------------------------------------------------
-- Title I changes to support student information
----------------------------------------------------------------------

	----------------------------------------------------------------------
	-- Drop constraints on rds.DimTitleIStatuses
	----------------------------------------------------------------------
	-- Drop foreign key constraints
	DECLARE @sql NVARCHAR(MAX) = N'';
	SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
		+ ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
	FROM sys.foreign_keys
	WHERE referenced_object_id = OBJECT_ID('RDS.DimTitleIStatuses');
	EXEC sp_executesql @sql;

	-- Drop primary key and unique constraints
	DECLARE @sql2 NVARCHAR(MAX) = N'';
	SELECT @sql2 += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
		+ ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID('RDS.DimTitleIStatuses');
	EXEC sp_executesql @sql2;

	-- Drop check constraints
	DECLARE @sql3 NVARCHAR(MAX) = N'';
	SELECT @sql3 += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
		+ ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
	FROM sys.check_constraints
	WHERE parent_object_id = OBJECT_ID('RDS.DimTitleIStatuses');
	EXEC sp_executesql @sql3;

	-- Drop default constraints
	DECLARE @sql4 NVARCHAR(MAX) = N'';
	SELECT @sql4 += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
		+ ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
	FROM sys.default_constraints
	WHERE parent_object_id = OBJECT_ID('RDS.DimTitleIStatuses');
	EXEC sp_executesql @sql4;

	----------------------------------------------------------------------
	-- Drop indexes on rds.DimTitleIStatuses
	----------------------------------------------------------------------
	-- Drop any indexes
	IF EXISTS (SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID('RDS.DimTitleIStatuses') AND name = 'IndexName')
	DROP INDEX IndexName ON RDS.DimTitleIStatuses;

	----------------------------------------------------------------------
	-- Drop the existing rds.DimTitleIStatuses table
	----------------------------------------------------------------------
	-- Drop the table if it exists
	IF OBJECT_ID('RDS.DimTitleIStatuses', 'U') IS NOT NULL
	DROP TABLE RDS.DimTitleIStatuses;

	----------------------------------------------------------------------
	-- Just in case - Drop rds.DimOrganizationTitleIStatuses constraints 
	----------------------------------------------------------------------
	-- Drop primary key and unique constraints
	DECLARE @sql5 NVARCHAR(MAX) = N'';
	SELECT @sql5 += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
		+ ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
	FROM sys.key_constraints
	WHERE parent_object_id = OBJECT_ID('RDS.DimOrganizationTitleIStatuses');
	EXEC sp_executesql @sql5;

	----------------------------------------------------------------------
	-- Just in case - Drop rds.DimOrganizationTitleIStatuses table
	----------------------------------------------------------------------
	-- Drop the table if it exists
	IF OBJECT_ID('RDS.DimOrganizationTitleIStatuses', 'U') IS NOT NULL
	DROP TABLE RDS.DimOrganizationTitleIStatuses;

	----------------------------------------------------------------------
	-- Create the new Organization Title I dimension
	----------------------------------------------------------------------

	CREATE TABLE [RDS].[DimOrganizationTitleIStatuses] (
		[DimOrganizationTitleIStatusId]          INT            IDENTITY (1, 1) NOT NULL,
		[TitleIInstructionalServicesCode]        NVARCHAR (50)  NULL,
		[TitleIInstructionalServicesDescription] NVARCHAR (100) NULL,
		[TitleIInstructionalServicesEdFactsCode] NVARCHAR (50)  NULL,
		[TitleIProgramTypeCode]                  NVARCHAR (50)  NULL,
		[TitleIProgramTypeDescription]           NVARCHAR (100) NULL,
		[TitleIProgramTypeEdFactsCode]           NVARCHAR (50)  NULL,
		[TitleISchoolStatusCode]                 NVARCHAR (50)  NULL,
		[TitleISchoolStatusDescription]          NVARCHAR (100) NULL,
		[TitleISchoolStatusEdFactsCode]          NVARCHAR (50)  NULL,
		[TitleISupportServicesCode]              NVARCHAR (50)  NULL,
		[TitleISupportServicesDescription]       NVARCHAR (100) NULL,
		[TitleISupportServicesEdFactsCode]       NVARCHAR (50)  NULL,
		CONSTRAINT [PK_DimOrganizationTitleIStatuses] PRIMARY KEY CLUSTERED ([DimOrganizationTitleIStatusId] ASC) WITH (DATA_COMPRESSION = PAGE)
	);
	
	CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitle1Statuses_Title1SchoolStatusEdFactsCode]
		ON [RDS].[DimOrganizationTitleIStatuses]([TitleISchoolStatusEdFactsCode] ASC);
	
	CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitleIStatuses_TitleISchoolStatusEdFactsCode]
		ON [RDS].[DimOrganizationTitleIStatuses]([TitleISchoolStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitle1Statuses_Title1ProgramTypeEdFactsCode]
		ON [RDS].[DimOrganizationTitleIStatuses]([TitleIProgramTypeEdFactsCode] ASC);
	
	CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitleIStatuses_TitleISupportServicesEdFactsCode]
		ON [RDS].[DimOrganizationTitleIStatuses]([TitleISupportServicesEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitleIStatuses_Codes]
		ON [RDS].[DimOrganizationTitleIStatuses]([TitleISchoolStatusCode] ASC, [TitleIInstructionalServicesCode] ASC, [TitleISupportServicesCode] ASC, [TitleIProgramTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitle1Statuses_Title1InstructionalServicesEdFactsCode]
		ON [RDS].[DimOrganizationTitleIStatuses]([TitleIInstructionalServicesEdFactsCode] ASC);
	
	CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitle1Statuses_Codes]
		ON [RDS].[DimOrganizationTitleIStatuses]([TitleISchoolStatusCode] ASC, [TitleIInstructionalServicesCode] ASC, [TitleISupportServicesCode] ASC, [TitleIProgramTypeCode] ASC);
	
	CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitleIStatuses_TitleIInstructionalServicesEdFactsCode]
		ON [RDS].[DimOrganizationTitleIStatuses]([TitleIInstructionalServicesEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);
	
	CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitle1Statuses_Title1SupportServicesEdFactsCode]
		ON [RDS].[DimOrganizationTitleIStatuses]([TitleISupportServicesEdFactsCode] ASC);
	
	CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitleIStatuses_TitleIProgramTypeEdFactsCode]
		ON [RDS].[DimOrganizationTitleIStatuses]([TitleIProgramTypeEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);
	

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of instructional services provided to students in ESEA Title I programs.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Instructional Services' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000282' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21282' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of instructional services provided to students in ESEA Title I programs.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Instructional Services' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000282' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21282' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of instructional services provided to students in ESEA Title I programs.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Instructional Services' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000282' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21282' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIInstructionalServicesEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of Title I program offered in the school or district.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Program Type' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000284' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21284' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of Title I program offered in the school or district.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Program Type' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000284' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21284' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of Title I program offered in the school or district.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Program Type' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000284' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21284' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIProgramTypeEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that a school is designated under state and federal regulations as being eligible for participation in programs authorized by Title I of ESEA as amended and whether it has a Title I program.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I School Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000285' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21285' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that a school is designated under state and federal regulations as being eligible for participation in programs authorized by Title I of ESEA as amended and whether it has a Title I program.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I School Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000285' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21285' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that a school is designated under state and federal regulations as being eligible for participation in programs authorized by Title I of ESEA as amended and whether it has a Title I program.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I School Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000285' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21285' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolStatusEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of support services provided to students in Title I programs.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Support Services' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000289' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21289' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of support services provided to students in Title I programs.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Support Services' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000289' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21289' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of support services provided to students in Title I programs.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Support Services' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000289' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesEdFactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21289' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimOrganizationTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISupportServicesEdFactsCode';
	

	------------------------------------------------------------------------
	---- Create the new Organization Title I supporting view
	------------------------------------------------------------------------

	----Drop first, just in case
	--IF OBJECT_ID('RDS.vwDimOrganizationTitleIStatuses', 'V') IS NOT NULL
	--	DROP VIEW RDS.vwDimOrganizationTitleIStatuses;
	

	--CREATE VIEW [RDS].[vwDimOrganizationTitleIStatuses]
	--AS
	--	SELECT
	--		  rdot1s.DimOrganizationTitleIStatusId
	--		, rsy.SchoolYear
	--		, rdot1s.TitleIInstructionalServicesCode
	--		, sssrd1.InputCode AS TitleIInstructionalServicesMap
	--		, rdot1s.TitleIProgramTypeCode
	--		, sssrd2.InputCode AS TitleIProgramTypeMap
	--		, rdot1s.TitleISchoolStatusCode
	--		, sssrd3.InputCode AS TitleISchoolStatusMap
	--		, rdot1s.TitleISupportServicesCode
	--		, sssrd4.InputCode AS TitleISupportServicesMap
	--	FROM rds.DimOrganizationTitleIStatuses rdot1s
	--	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	--	LEFT JOIN staging.SourceSystemReferenceData sssrd1
	--		ON rdot1s.TitleISupportServicesCode = sssrd1.OutputCode
	--		AND sssrd1.TableName = 'RefTitleIInstructionServices'
	--		AND rsy.SchoolYear = sssrd1.SchoolYear
	--	LEFT JOIN staging.SourceSystemReferenceData sssrd2
	--		ON rdot1s.TitleIProgramTypeCode = sssrd2.OutputCode
	--		AND sssrd2.TableName = 'RefTitleIProgramType'
	--		AND rsy.SchoolYear = sssrd2.SchoolYear
	--	LEFT JOIN staging.SourceSystemReferenceData sssrd3
	--		ON rdot1s.TitleISchoolStatusCode = sssrd2.OutputCode
	--		AND sssrd3.TableName = 'RefTitleISchoolStatus'
	--		AND rsy.SchoolYear = sssrd3.SchoolYear
	--	LEFT JOIN staging.SourceSystemReferenceData sssrd4
	--		ON rdot1s.TitleISupportServicesCode = sssrd4.OutputCode
	--		AND sssrd4.TableName = 'RefK12LeaTitleISupportService'
	--		AND rsy.SchoolYear = sssrd4.SchoolYear
	

	----------------------------------------------------------------------
	-- Re-create the Title I Statuses dimension table
	----------------------------------------------------------------------

	CREATE TABLE [RDS].[DimTitleIStatuses] (
		[DimTitleIStatusId]												INT				IDENTITY(1,1) NOT NULL,
		[TitleIIndicatorCode]											NVARCHAR (50)	NULL,
		[TitleIIndicatorDescription]									NVARCHAR (100)	NULL,
		[TitleIIndicatorEdFactsCode]									NVARCHAR (50)	NULL,
		[SchoolChoiceAppliedforTransferStatusCode]						NVARCHAR (50)	NULL,
		[SchoolChoiceAppliedforTransferStatusDescription]				NVARCHAR (100)	NULL,
		[SchoolChoiceEligibleforTransferStatusCode]						NVARCHAR (50)	NULL,
		[SchoolChoiceEligibleforTransferStatusDescription]				NVARCHAR (100)	NULL,
		[SchoolChoiceTransferStatusCode]								NVARCHAR (50)	NULL,
		[SchoolChoiceTransferStatusDescription]							NVARCHAR (100)	NULL,
		[TitleISchoolSupplementalServicesAppliedStatusCode]				NVARCHAR (50)	NULL,
		[TitleISchoolSupplementalServicesAppliedStatusDescription]		NVARCHAR (100)	NULL,
		[TitleISchoolSupplementalServicesEligibleStatusCode]			NVARCHAR (50)	NULL,
		[TitleISchoolSupplementalServicesEligibleStatusDescription]		NVARCHAR (100)	NULL,
		[TitleISchoolSupplementalServicesReceivedStatusCode] 			NVARCHAR (50)	NULL,
		[TitleISchoolSupplementalServicesReceivedStatusDescription]		NVARCHAR (100)	NULL,
		[TitleISchoolwideProgramParticipationCode]	 					NVARCHAR (50)	NULL,
		[TitleISchoolwideProgramParticipationDescription] 				NVARCHAR (100)	NULL,
		[TitleITargetedAssistanceParticipationCode] 					NVARCHAR (50)	NULL,
		[TitleITargetedAssistanceParticipationDescription] 				NVARCHAR (100)	NULL,
		CONSTRAINT [PK_DimTitleIStatuses] PRIMARY KEY CLUSTERED ([DimTitleIStatusId] ASC) WITH (DATA_COMPRESSION = PAGE)
	);
	

	CREATE NONCLUSTERED INDEX [IX_DimTitle1Statuses_TitleIIndicatorCode]
		ON [RDS].[DimTitleIStatuses]([TitleIIndicatorCode] ASC);
	
	CREATE NONCLUSTERED INDEX [IX_DimTitleIStatuses_TitleIIndicatorCode]
		ON [RDS].[DimTitleIStatuses]([TitleIIndicatorCode] ASC) WITH (DATA_COMPRESSION = PAGE);
	

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that the student is participating in and served by programs under Title I, Part A of ESEA as amended.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Indicator' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000281' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000281' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that the student is participating in and served by programs under Title I, Part A of ESEA as amended.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Indicator' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000281' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000281' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorEdfactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that the student is participating in and served by programs under Title I, Part A of ESEA as amended.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorEdfactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Indicator' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorEdfactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000281' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorEdfactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000281' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleIIndicatorEdfactsCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceAppliedForTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that a student applied to transfer in the current year (regardless of whether the student transferred), OR previously applied and transferred under the public school choice provisions and continue to attend the transfer school in the current year.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceAppliedForTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Choice Applied for Transfer Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceAppliedForTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000235' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceAppliedForTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000235' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceAppliedForTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceAppliedForTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that a student applied to transfer in the current year (regardless of whether the student transferred), OR previously applied and transferred under the public school choice provisions and continue to attend the transfer school in the current year.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceAppliedForTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Choice Applied for Transfer Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceAppliedForTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000235' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceAppliedForTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000235' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceAppliedForTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceEligibleForTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication the student is eligible to transfer for the current school year under the public school choice provisions or who applied and transferred in the current school year under the public school choice provisions or previously applied and transferred under the public school choice provisions and continue to attend the transfer school in the current year.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceEligibleForTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Choice Eligible for Transfer Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceEligibleForTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000236' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceEligibleForTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000236' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceEligibleForTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceEligibleForTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication the student is eligible to transfer for the current school year under the public school choice provisions or who applied and transferred in the current school year under the public school choice provisions or previously applied and transferred under the public school choice provisions and continue to attend the transfer school in the current year.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceEligibleForTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Choice Eligible for Transfer Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceEligibleForTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000236' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceEligibleForTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000236' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceEligibleForTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication of whether an eligible student transferred to the school under the provisions for public school choice in accordance with Title I, Part A, Section 1116 of ESEA as amended.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Choice Transfer Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000237' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000237' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceTransferStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication of whether an eligible student transferred to the school under the provisions for public school choice in accordance with Title I, Part A, Section 1116 of ESEA as amended.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Choice Transfer Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000237' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000237' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'SchoolChoiceTransferStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesAppliedStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication of whether an eligible student applied/requested to receive supplemental educational services under Title I, Part A, Section 1116 of ESEA as amended during the school year.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesAppliedStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I School Supplemental Services Applied Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesAppliedStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000286' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesAppliedStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000286' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesAppliedStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesAppliedStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication of whether an eligible student applied/requested to receive supplemental educational services under Title I, Part A, Section 1116 of ESEA as amended during the school year.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesAppliedStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I School Supplemental Services Applied Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesAppliedStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000286' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesAppliedStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000286' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesAppliedStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesEligibleStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication of whether a student is eligible to receive supplemental educational services during the school year in accordance with Title I, Part A, Section 1116 of ESEA as amended.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesEligibleStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I School Supplemental Services Eligible Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesEligibleStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000287' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesEligibleStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000287' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesEligibleStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesEligibleStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication of whether a student is eligible to receive supplemental educational services during the school year in accordance with Title I, Part A, Section 1116 of ESEA as amended.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesEligibleStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I School Supplemental Services Eligible Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesEligibleStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000287' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesEligibleStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000287' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesEligibleStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesReceivedStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication of whether an eligible student received supplemental educational services during the school year in accordance with Title I, Part A, Section 1116 of ESEA as amended.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesReceivedStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I School Supplemental Services Received Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesReceivedStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000288' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesReceivedStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000288' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesReceivedStatusCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesReceivedStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication of whether an eligible student received supplemental educational services during the school year in accordance with Title I, Part A, Section 1116 of ESEA as amended.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesReceivedStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I School Supplemental Services Received Status' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesReceivedStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000288' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesReceivedStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000288' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolSupplementalServicesReceivedStatusDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolwideProgramParticipationCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that the student participates in and is served by a schoolwide program (SWP) under Title I of ESEA, Part A, Sections 1114.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolwideProgramParticipationCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Schoolwide Program Participation' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolwideProgramParticipationCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000550' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolwideProgramParticipationCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000550' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolwideProgramParticipationCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolwideProgramParticipationDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that the student participates in and is served by a schoolwide program (SWP) under Title I of ESEA, Part A, Sections 1114.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolwideProgramParticipationDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Schoolwide Program Participation' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolwideProgramParticipationDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000550' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolwideProgramParticipationDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000550' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleISchoolwideProgramParticipationDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleITargetedAssistanceParticipationCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that the student participates in and is served by a targeted assistance (TAS) program under Title I of ESEA, Part A, Sections 1115.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleITargetedAssistanceParticipationCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Targeted Assistance Participation' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleITargetedAssistanceParticipationCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000551' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleITargetedAssistanceParticipationCode';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000551' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleITargetedAssistanceParticipationCode';
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleITargetedAssistanceParticipationDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that the student participates in and is served by a targeted assistance (TAS) program under Title I of ESEA, Part A, Sections 1115.' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleITargetedAssistanceParticipationDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title I Targeted Assistance Participation' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleITargetedAssistanceParticipationDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000551' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleITargetedAssistanceParticipationDescription';
	
	EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/000551' , @level0type=N'SCHEMA',@level0name=N'RDS', @level1type=N'TABLE',@level1name=N'DimTitleIStatuses', @level2type=N'COLUMN',@level2name=N'TitleITargetedAssistanceParticipationDescription';
	

	----------------------------------------------------------------------
	-- Re-create the Title I Statuses supporting view 
	----------------------------------------------------------------------
	-- Drop the view if it exists
	--IF OBJECT_ID('RDS.vwDimTitleIStatuses', 'V') IS NOT NULL
	--	DROP VIEW RDS.vwDimTitleIStatuses;
	

	--CREATE VIEW [RDS].[vwDimTitleIStatuses]
	--AS
	--	SELECT
	--		rdt1s.DimTitleIStatusId
	--		, rsy.SchoolYear
	--		, rdt1s.TitleIIndicatorCode
	--		, sssrd1.InputCode AS TitleIIndicatorMap
	--		, rdt1s.SchoolChoiceAppliedforTransferStatusCode
	--		, CASE rdt1s.SchoolChoiceAppliedforTransferStatusCode 
	--			WHEN 'Yes' THEN 1 
	--			WHEN 'No' THEN 0
	--			ELSE -1
	--		  END AS SchoolChoiceAppliedforTransferStatusMap
	--		, rdt1s.SchoolChoiceEligibleforTransferStatusCode
	--		, CASE rdt1s.SchoolChoiceEligibleforTransferStatusCode 
	--			WHEN 'Yes' THEN 1 
	--			WHEN 'No' THEN 0
	--			ELSE -1
	--		  END AS SchoolChoiceEligibleforTransferStatusMap
	--		, rdt1s.SchoolChoiceTransferStatusCode
	--		, CASE rdt1s.SchoolChoiceTransferStatusCode 
	--			WHEN 'Yes' THEN 1 
	--			WHEN 'No' THEN 0
	--			ELSE -1
	--		  END AS SchoolChoiceTransferStatusMap
	--		, rdt1s.TitleISchoolSupplementalServicesAppliedStatusCode
	--		, CASE rdt1s.TitleISchoolSupplementalServicesAppliedStatusCode 
	--			WHEN 'Yes' THEN 1 
	--			WHEN 'No' THEN 0
	--			ELSE -1
	--		  END AS TitleISchoolSupplementalServicesAppliedStatusMap
	--		, rdt1s.TitleISchoolSupplementalServicesEligibleStatusCode
	--		, CASE rdt1s.TitleISchoolSupplementalServicesEligibleStatusCode 
	--			WHEN 'Yes' THEN 1 
	--			WHEN 'No' THEN 0
	--			ELSE -1
	--		  END AS TitleISchoolSupplementalServicesEligibleStatusMap
	--		, rdt1s.TitleISchoolSupplementalServicesReceivedStatusCode
	--		, CASE rdt1s.TitleISchoolSupplementalServicesReceivedStatusCode 
	--			WHEN 'Yes' THEN 1 
	--			WHEN 'No' THEN 0
	--			ELSE -1
	--		  END AS TitleISchoolSupplementalServicesReceivedStatusMap
	--		, rdt1s.TitleISchoolwideProgramParticipationCode
	--		, CASE rdt1s.TitleISchoolwideProgramParticipationCode 
	--			WHEN 'Yes' THEN 1 
	--			WHEN 'No' THEN 0
	--			ELSE -1
	--		  END AS TitleISchoolwideProgramParticipationMap
	--		, rdt1s.TitleITargetedAssistanceParticipationCode
	--		, CASE rdt1s.TitleITargetedAssistanceParticipationCode 
	--			WHEN 'Yes' THEN 1 
	--			WHEN 'No' THEN 0
	--			ELSE -1
	--		  END AS TitleITargetedAssistanceParticipationMap

	--	FROM rds.DimTitleIStatuses rdt1s
	--	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	--	LEFT JOIN staging.SourceSystemReferenceData sssrd1
	--		ON rdt1s.TitleIIndicatorCode = sssrd1.OutputCode
	--		AND sssrd1.TableName = 'RefTitleIIndicator'
	--		AND rsy.SchoolYear = sssrd1.SchoolYear
	

	

-- Rename the column 'TitleIProgramType' to 'TitleIIndicator'
IF EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'ReportEdFactsK12StudentCounts' 
    AND TABLE_SCHEMA = 'rds' 
    AND COLUMN_NAME = 'TitleIProgramType'
)
BEGIN
	EXEC sp_rename 'RDS.ReportEdFactsK12StudentCounts.TitleIProgramType', 'TitleIIndicator', 'COLUMN';
END

