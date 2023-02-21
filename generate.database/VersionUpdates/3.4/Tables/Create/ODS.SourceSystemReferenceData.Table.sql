IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'SourceSystemReferenceData' AND Type = N'U')
BEGIN

	CREATE TABLE [ODS].[SourceSystemReferenceData](
		[SourceSystemReferenceDataId] int IDENTITY NOT NULL,
		[SchoolYear] [smallint] NOT NULL,
		[TableName] [varchar](100) NOT NULL,
		[TableFilter] [varchar](100) NULL,
		[InputCode] [nvarchar](200) NULL,
		[OutputCode] [nvarchar](200) NULL
	CONSTRAINT [PK_SourceSystemReferenceData] PRIMARY KEY CLUSTERED 
	(
		[SourceSystemReferenceDataId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE UNIQUE INDEX [IX_SourceSystemReferenceData_Unique] ON [ODS].[SourceSystemReferenceData]
	(
		[SchoolYear] DESC,
		[TableName] ASC,
		[TableFilter] ASC,
		[InputCode] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

END