-- App schema table changes for release 14.0
-- Add idempotent ALTER/CREATE statements here.

--------------------------------------------------------------------------------------------------------------------------------------------------------------
---- CIID-9031 (epic CIID-9029): ETL source mapping tables
---- These tables capture the "left" (source/state data dictionary) side of the ETL Checklist and its
---- mapping to CEDS. App.EtlMetadata (created in 13.0) remains the "right" (CEDS/Generate destination)
---- side; the two sides relate through the CEDS Element Global ID (+ option set code).
----   App.EtlSourceElementMapping    - one row per element in the state's uploaded bespoke data dictionary
----   App.EtlSourceOptionSetMapping  - one row per option set (enumeration) value of a source element
--------------------------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('App.EtlMap', 'U') IS NULL
BEGIN
	CREATE TABLE [App].[EtlMap] (
		[EtlMapId] [int] IDENTITY(1,1) NOT NULL,
		[MapName] [nvarchar](200) NOT NULL,
		[UploadFileName] [nvarchar](260) NULL,
		[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_EtlMap_CreatedDate] DEFAULT (GETDATE()),
		[CreatedBy] [nvarchar](100) NULL,
		[ModifiedDate] [datetime] NULL,
		[ModifiedBy] [nvarchar](100) NULL,
		CONSTRAINT [PK_EtlMap] PRIMARY KEY CLUSTERED ([EtlMapId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]
END

IF OBJECT_ID('App.EtlMapFileSpec', 'U') IS NULL
BEGIN
	-- Associates a map with one or more EDFacts file specs, identified either by spec number
	-- (e.g. FS002) or by Fact Type (rds.DimFactTypes). DimFactTypeId is intentionally not a hard
	-- foreign key because RDS dimension tables can be reloaded by data migrations; FactTypeCode is
	-- denormalized so the association stays meaningful across reloads.
	CREATE TABLE [App].[EtlMapFileSpec] (
		[EtlMapFileSpecId] [int] IDENTITY(1,1) NOT NULL,
		[EtlMapId] [int] NOT NULL,
		[FileSpecNumber] [varchar](20) NULL,
		[DimFactTypeId] [int] NULL,
		[FactTypeCode] [varchar](100) NULL,
		[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_EtlMapFileSpec_CreatedDate] DEFAULT (GETDATE()),
		CONSTRAINT [PK_EtlMapFileSpec] PRIMARY KEY CLUSTERED ([EtlMapFileSpecId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY],
		CONSTRAINT [FK_EtlMapFileSpec_EtlMap] FOREIGN KEY ([EtlMapId])
			REFERENCES [App].[EtlMap] ([EtlMapId]) ON DELETE CASCADE
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IX_EtlMapFileSpec_EtlMapId]
		ON [App].[EtlMapFileSpec] ([EtlMapId] ASC)
END

IF OBJECT_ID('App.EtlSourceElementMapping', 'U') IS NULL
BEGIN
	CREATE TABLE [App].[EtlSourceElementMapping] (
		[EtlSourceElementMappingId] [int] IDENTITY(1,1) NOT NULL,
		[EtlMapId] [int] NULL,
		-- Source System & Element Details (Assessment ETL Documentation Template, "Assessment ETL Detail" tab)
		[SourceCommonName] [nvarchar](500) NULL,
		[SourceTechnicalName] [nvarchar](500) NULL,
		[SourceDatabaseName] [nvarchar](200) NULL,
		[SourceSchemaName] [nvarchar](200) NULL,
		[SourceTableName] [nvarchar](200) NULL,
		[SourceColumnName] [nvarchar](200) NULL,
		[SourceElementName] [nvarchar](500) NOT NULL,
		[SourceElementDefinition] [nvarchar](max) NULL,
		[SourceDataType] [nvarchar](100) NULL,
		[SourceDataLength] [nvarchar](50) NULL,
		[SourceDataSteward] [nvarchar](200) NULL,
		-- Source to Generate Transformation
		[SelectionCriteria] [nvarchar](max) NULL,
		[TransformationRules] [nvarchar](max) NULL,
		[Notes] [nvarchar](max) NULL,
		-- CEDS element mapping (denormalized from App.EtlMetadata at mapping time)
		-- Note: some EtlMetadata global/data-model IDs hold long placeholder text (e.g. "Pending - see
		-- OSC ticket https://..."), so these columns must be wide enough to carry them verbatim.
		[CedsElementGlobalId] [varchar](400) NULL,
		[CedsElementName] [nvarchar](500) NULL,
		[CedsElementDefinition] [nvarchar](max) NULL,
		[CedsDataModelId] [varchar](400) NULL,
		[CedsPath] [nvarchar](1000) NULL,
		[ElementDefinitionResponseId] [varchar](50) NULL,
		-- Automapping metadata
		[MatchConfidence] [decimal](5, 4) NULL,
		[MatchType] [varchar](20) NULL,           -- Suggested | Manual
		[MappingStatus] [varchar](20) NOT NULL CONSTRAINT [DF_EtlSourceElementMapping_MappingStatus] DEFAULT ('Unmapped'),  -- Unmapped | Suggested | Accepted | Rejected | NotInCeds
		-- Audit
		[UploadFileName] [nvarchar](260) NULL,
		[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_EtlSourceElementMapping_CreatedDate] DEFAULT (GETDATE()),
		[CreatedBy] [nvarchar](100) NULL,
		[ModifiedDate] [datetime] NULL,
		[ModifiedBy] [nvarchar](100) NULL,
		CONSTRAINT [PK_EtlSourceElementMapping] PRIMARY KEY CLUSTERED ([EtlSourceElementMappingId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY],
		CONSTRAINT [FK_EtlSourceElementMapping_EtlMap] FOREIGN KEY ([EtlMapId])
			REFERENCES [App].[EtlMap] ([EtlMapId]) ON DELETE CASCADE
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

-- Upgrade path for databases where EtlSourceElementMapping was created before EtlMap existed
IF COL_LENGTH('App.EtlSourceElementMapping', 'EtlMapId') IS NULL
BEGIN
	ALTER TABLE [App].[EtlSourceElementMapping] ADD [EtlMapId] [int] NULL
END

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_EtlSourceElementMapping_EtlMap')
BEGIN
	ALTER TABLE [App].[EtlSourceElementMapping] WITH CHECK
		ADD CONSTRAINT [FK_EtlSourceElementMapping_EtlMap] FOREIGN KEY ([EtlMapId])
		REFERENCES [App].[EtlMap] ([EtlMapId]) ON DELETE CASCADE
END

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('App.EtlSourceElementMapping') AND name = 'IX_EtlSourceElementMapping_EtlMapId')
BEGIN
	CREATE NONCLUSTERED INDEX [IX_EtlSourceElementMapping_EtlMapId]
		ON [App].[EtlSourceElementMapping] ([EtlMapId] ASC)
END

IF OBJECT_ID('App.EtlSourceOptionSetMapping', 'U') IS NULL
BEGIN
	CREATE TABLE [App].[EtlSourceOptionSetMapping] (
		[EtlSourceOptionSetMappingId] [int] IDENTITY(1,1) NOT NULL,
		[EtlSourceElementMappingId] [int] NOT NULL,
		-- Source option set (enumeration) value
		[SourceOptionSetCode] [nvarchar](500) NULL,
		[SourceOptionSetDescription] [nvarchar](1000) NULL,
		-- CEDS option set mapping
		[CedsOptionSetCode] [nvarchar](500) NULL,
		[CedsOptionSetDescription] [nvarchar](1000) NULL,
		[OptionSetResponseId] [varchar](50) NULL,
		-- Automapping metadata
		[MatchConfidence] [decimal](5, 4) NULL,
		[MatchType] [varchar](20) NULL,           -- ExactCode | Semantic | Manual
		[MappingStatus] [varchar](20) NOT NULL CONSTRAINT [DF_EtlSourceOptionSetMapping_MappingStatus] DEFAULT ('Unmapped'),  -- Unmapped | Suggested | Accepted | Rejected | NotInCeds
		-- Audit
		[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_EtlSourceOptionSetMapping_CreatedDate] DEFAULT (GETDATE()),
		[ModifiedDate] [datetime] NULL,
		[ModifiedBy] [nvarchar](100) NULL,
		CONSTRAINT [PK_EtlSourceOptionSetMapping] PRIMARY KEY CLUSTERED ([EtlSourceOptionSetMappingId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY],
		CONSTRAINT [FK_EtlSourceOptionSetMapping_EtlSourceElementMapping] FOREIGN KEY ([EtlSourceElementMappingId])
			REFERENCES [App].[EtlSourceElementMapping] ([EtlSourceElementMappingId]) ON DELETE CASCADE
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('App.EtlSourceOptionSetMapping') AND name = 'IX_EtlSourceOptionSetMapping_EtlSourceElementMappingId')
BEGIN
	CREATE NONCLUSTERED INDEX [IX_EtlSourceOptionSetMapping_EtlSourceElementMappingId]
		ON [App].[EtlSourceOptionSetMapping] ([EtlSourceElementMappingId] ASC)
END

-- CIID-9036: capture the CEDS Data Warehouse Staging destination(s) for the mapped CEDS element
IF COL_LENGTH('App.EtlSourceElementMapping', 'StagingTableColumns') IS NULL
BEGIN
	ALTER TABLE [App].[EtlSourceElementMapping] ADD [StagingTableColumns] [nvarchar](max) NULL
END

-- CIID-9036: surfaces the CEDS extended properties on Staging-schema columns so the automapper can
-- (a) restrict the CEDS element catalog to elements loadable into the warehouse and
-- (b) show the Staging table + column for each mapped element.
-- The CEDS_GlobalId extended property holds the CEDS Ontology identifier minus the C/P prefix.
IF OBJECT_ID('App.vwEtlStagingCedsColumns', 'V') IS NOT NULL
	EXEC('DROP VIEW [App].[vwEtlStagingCedsColumns]')
EXEC('
CREATE VIEW [App].[vwEtlStagingCedsColumns]
AS
	SELECT
		s.name									AS [SchemaName]
		, t.name								AS [TableName]
		, c.name								AS [ColumnName]
		, CAST(gid.value AS varchar(100))		AS [CedsGlobalId]
		, CAST(el.value AS nvarchar(500))		AS [CedsElement]
	FROM sys.columns c
	JOIN sys.tables t ON c.object_id = t.object_id
	JOIN sys.schemas s ON t.schema_id = s.schema_id
	JOIN sys.extended_properties gid
		ON gid.major_id = c.object_id AND gid.minor_id = c.column_id AND gid.name = ''CEDS_GlobalId''
	LEFT JOIN sys.extended_properties el
		ON el.major_id = c.object_id AND el.minor_id = c.column_id AND el.name = ''CEDS_Element''
	WHERE s.name = ''Staging''
		AND CAST(gid.value AS varchar(100)) LIKE ''[0-9]%''
')

print 'App.TableChanges.sql executed for 14.0.'
