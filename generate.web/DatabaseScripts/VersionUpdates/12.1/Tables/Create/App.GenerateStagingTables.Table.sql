CREATE TABLE [App].[GenerateStagingTables](
	[StagingTableId] [smallint] NOT NULL,
	[StagingTableName] [varchar](100) NULL,
 CONSTRAINT [PK_GenerateStagingTables] PRIMARY KEY CLUSTERED 
(
	[StagingTableId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]