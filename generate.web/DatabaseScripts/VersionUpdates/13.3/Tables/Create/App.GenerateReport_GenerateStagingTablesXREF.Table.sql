CREATE TABLE [App].[GenerateReport_GenerateStagingTablesXREF](
	[GenerateReportId] [smallint] NOT NULL,
	[StagingTableId] [smallint] NOT NULL,
 CONSTRAINT [PK_GenerateReportGroup_GenerateStagingTablesXREF] PRIMARY KEY CLUSTERED 
(
	[GenerateReportId] ASC,
	[StagingTableId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

