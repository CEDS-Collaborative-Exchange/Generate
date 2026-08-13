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

IF OBJECT_ID('App.EtlMapSource', 'U') IS NULL
BEGIN
	-- Source datasets registered to a map (CIID-9061). A single file spec often draws from several
	-- source systems; each row is one source table/view/query the alignment mappings + generated ETL
	-- pull from. The AI ETL Developer joins these on shared business keys into the Staging tables.
	CREATE TABLE [App].[EtlMapSource] (
		[EtlMapSourceId] [int] IDENTITY(1,1) NOT NULL,
		[EtlMapId] [int] NOT NULL,
		[SourceName] [nvarchar](200) NULL,          -- alias, e.g. "SIS_Enrollment", "SpEd", "Race"
		[SourceConnection] [nvarchar](1000) NULL,   -- server/database/schema or connection descriptor
		[SourceObject] [nvarchar](500) NULL,        -- schema.table / view / query the ETL reads from
		[Notes] [nvarchar](max) NULL,               -- join hints, filters, caveats
		[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_EtlMapSource_CreatedDate] DEFAULT (GETDATE()),
		[CreatedBy] [nvarchar](100) NULL,
		[ModifiedDate] [datetime] NULL,
		[ModifiedBy] [nvarchar](100) NULL,
		CONSTRAINT [PK_EtlMapSource] PRIMARY KEY CLUSTERED ([EtlMapSourceId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY],
		CONSTRAINT [FK_EtlMapSource_EtlMap] FOREIGN KEY ([EtlMapId])
			REFERENCES [App].[EtlMap] ([EtlMapId]) ON DELETE CASCADE
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IX_EtlMapSource_EtlMapId]
		ON [App].[EtlMapSource] ([EtlMapId] ASC)
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

-- CIID-9061: AI ETL developer chatbot sessions + transcript, stored by map
IF OBJECT_ID('App.EtlChatSession', 'U') IS NULL
BEGIN
	CREATE TABLE [App].[EtlChatSession] (
		[EtlChatSessionId] [int] IDENTITY(1,1) NOT NULL,
		[EtlMapId] [int] NOT NULL,
		[SessionName] [nvarchar](200) NULL,
		[SourceConnection] [nvarchar](1000) NULL,   -- source server/database/schema or connection descriptor
		[SourceObject] [nvarchar](500) NULL,        -- source table/view/query the ETL pulls from
		[Status] [varchar](20) NOT NULL CONSTRAINT [DF_EtlChatSession_Status] DEFAULT ('Active'),  -- Active | AwaitingInput | Completed | Failed
		[MaxLoops] [int] NOT NULL CONSTRAINT [DF_EtlChatSession_MaxLoops] DEFAULT (10),
		[CurrentLoop] [int] NOT NULL CONSTRAINT [DF_EtlChatSession_CurrentLoop] DEFAULT (0),
		[SchoolYear] [int] NULL,                     -- target end school year for migration/validation (e.g. 2026)
		[CurrentPhase] [varchar](40) NULL,           -- EtlChatPhase.*: StagingLoad -> StagingValidate -> RdsMigrate -> ReportMigrate -> ReportValidate -> Done
		[LastEtlSql] [nvarchar](max) NULL,
		[LastTestSql] [nvarchar](max) NULL,
		[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_EtlChatSession_CreatedDate] DEFAULT (GETDATE()),
		[CreatedBy] [nvarchar](100) NULL,
		[ModifiedDate] [datetime] NULL,
		[ModifiedBy] [nvarchar](100) NULL,
		CONSTRAINT [PK_EtlChatSession] PRIMARY KEY CLUSTERED ([EtlChatSessionId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY],
		CONSTRAINT [FK_EtlChatSession_EtlMap] FOREIGN KEY ([EtlMapId])
			REFERENCES [App].[EtlMap] ([EtlMapId]) ON DELETE CASCADE
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IX_EtlChatSession_EtlMapId] ON [App].[EtlChatSession] ([EtlMapId] ASC)
END

-- Add the end-to-end phase columns to any pre-existing EtlChatSession table (CIID-9061 phase machine).
IF OBJECT_ID('App.EtlChatSession', 'U') IS NOT NULL AND COL_LENGTH('App.EtlChatSession', 'SchoolYear') IS NULL
	ALTER TABLE [App].[EtlChatSession] ADD [SchoolYear] [int] NULL
IF OBJECT_ID('App.EtlChatSession', 'U') IS NOT NULL AND COL_LENGTH('App.EtlChatSession', 'CurrentPhase') IS NULL
	ALTER TABLE [App].[EtlChatSession] ADD [CurrentPhase] [varchar](40) NULL

IF OBJECT_ID('App.EtlChatMessage', 'U') IS NULL
BEGIN
	CREATE TABLE [App].[EtlChatMessage] (
		[EtlChatMessageId] [int] IDENTITY(1,1) NOT NULL,
		[EtlChatSessionId] [int] NOT NULL,
		[Role] [varchar](20) NOT NULL,              -- user | assistant | system | tool
		[MessageType] [varchar](20) NOT NULL CONSTRAINT [DF_EtlChatMessage_MessageType] DEFAULT ('chat'),  -- chat | question | sql | testresult | status | error
		[IterationNumber] [int] NULL,
		[Content] [nvarchar](max) NULL,
		[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_EtlChatMessage_CreatedDate] DEFAULT (GETDATE()),
		CONSTRAINT [PK_EtlChatMessage] PRIMARY KEY CLUSTERED ([EtlChatMessageId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY],
		CONSTRAINT [FK_EtlChatMessage_EtlChatSession] FOREIGN KEY ([EtlChatSessionId])
			REFERENCES [App].[EtlChatSession] ([EtlChatSessionId]) ON DELETE CASCADE
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IX_EtlChatMessage_EtlChatSessionId] ON [App].[EtlChatMessage] ([EtlChatSessionId] ASC)
END

-- CIID-9061: record the stored procedure the AI ETL developer published for a session
IF COL_LENGTH('App.EtlChatSession', 'GeneratedProcedureName') IS NULL
BEGIN
	ALTER TABLE [App].[EtlChatSession] ADD [GeneratedProcedureName] [nvarchar](300) NULL
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

-- Map-level free-text guidance for the AI ETL Developer (CIID-9061): natural-language join description
-- and map-wide filtering/complex-processing notes. Both are fed verbatim into the LLM prompt.
IF COL_LENGTH('App.EtlMap', 'JoinInstructions') IS NULL
	ALTER TABLE [App].[EtlMap] ADD [JoinInstructions] [nvarchar](max) NULL
IF COL_LENGTH('App.EtlMap', 'ProcessingNotes') IS NULL
	ALTER TABLE [App].[EtlMap] ADD [ProcessingNotes] [nvarchar](max) NULL

IF OBJECT_ID('App.EtlMapJoin', 'U') IS NULL
BEGIN
	-- Structured join conditions between a map's source objects (CIID-9061). Each row is one equality
	-- condition Left.Column = Right.Column; a composite join is several rows for the same table pair
	-- (ordered by SortOrder). The AI ETL Developer renders these as explicit JOINs so it never has to
	-- guess how the sources relate (the cause of the "Invalid column name" retry loop on multi-source maps).
	CREATE TABLE [App].[EtlMapJoin] (
		[EtlMapJoinId] [int] IDENTITY(1,1) NOT NULL,
		[EtlMapId] [int] NOT NULL,
		[LeftSourceObject] [nvarchar](500) NULL,    -- e.g. Source.MembershipExtract2026
		[LeftColumn] [nvarchar](200) NULL,
		[RightSourceObject] [nvarchar](500) NULL,   -- e.g. Source.PersonStatusExtract2026
		[RightColumn] [nvarchar](200) NULL,
		[JoinType] [nvarchar](20) NULL,             -- INNER / LEFT / RIGHT / FULL (defaults to LEFT)
		[SortOrder] [int] NOT NULL CONSTRAINT [DF_EtlMapJoin_SortOrder] DEFAULT (0),
		[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_EtlMapJoin_CreatedDate] DEFAULT (GETDATE()),
		[CreatedBy] [nvarchar](100) NULL,
		[ModifiedDate] [datetime] NULL,
		[ModifiedBy] [nvarchar](100) NULL,
		CONSTRAINT [PK_EtlMapJoin] PRIMARY KEY CLUSTERED ([EtlMapJoinId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY],
		CONSTRAINT [FK_EtlMapJoin_EtlMap] FOREIGN KEY ([EtlMapId])
			REFERENCES [App].[EtlMap] ([EtlMapId]) ON DELETE CASCADE
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IX_EtlMapJoin_EtlMapId]
		ON [App].[EtlMapJoin] ([EtlMapId] ASC)
END

print 'App.TableChanges.sql executed for 14.0.'

-- General-purpose AI assistant chat (CIID-9061): sessions NOT tied to an ETL map. A place to ask
-- questions or have the LLM write/update T-SQL (e.g. rolling a stored procedure to a new school year).
IF OBJECT_ID('App.AssistantSession', 'U') IS NULL
BEGIN
	CREATE TABLE [App].[AssistantSession] (
		[AssistantSessionId] [int] IDENTITY(1,1) NOT NULL,
		[Title] [nvarchar](200) NULL,
		[Status] [nvarchar](40) NULL,            -- Active | AwaitingInput
		[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_AssistantSession_CreatedDate] DEFAULT (GETDATE()),
		[CreatedBy] [nvarchar](100) NULL,
		[ModifiedDate] [datetime] NULL,
		[ModifiedBy] [nvarchar](100) NULL,
		CONSTRAINT [PK_AssistantSession] PRIMARY KEY CLUSTERED ([AssistantSessionId] ASC)
	) ON [PRIMARY]
END

IF OBJECT_ID('App.AssistantMessage', 'U') IS NULL
BEGIN
	CREATE TABLE [App].[AssistantMessage] (
		[AssistantMessageId] [int] IDENTITY(1,1) NOT NULL,
		[AssistantSessionId] [int] NOT NULL,
		[Role] [nvarchar](20) NULL,              -- user | assistant | system
		[Content] [nvarchar](max) NULL,
		[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_AssistantMessage_CreatedDate] DEFAULT (GETDATE()),
		CONSTRAINT [PK_AssistantMessage] PRIMARY KEY CLUSTERED ([AssistantMessageId] ASC),
		CONSTRAINT [FK_AssistantMessage_AssistantSession] FOREIGN KEY ([AssistantSessionId])
			REFERENCES [App].[AssistantSession] ([AssistantSessionId]) ON DELETE CASCADE
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IX_AssistantMessage_SessionId] ON [App].[AssistantMessage] ([AssistantSessionId] ASC)
END
