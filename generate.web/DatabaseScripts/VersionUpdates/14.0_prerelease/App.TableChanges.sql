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

IF OBJECT_ID('App.EtlSourceElementMapping', 'U') IS NULL
BEGIN
	CREATE TABLE [App].[EtlSourceElementMapping] (
		[EtlSourceElementMappingId] [int] IDENTITY(1,1) NOT NULL,
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
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
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

print 'App.TableChanges.sql executed for 14.0.'
