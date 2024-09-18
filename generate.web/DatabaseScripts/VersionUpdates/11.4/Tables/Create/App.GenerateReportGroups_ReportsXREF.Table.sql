CREATE TABLE [App].[GenerateReportGroups_ReportsXREF](
	[ReportGroupId] [smallint] NOT NULL,
	[GenerateReportId] [smallint] NOT NULL,
 CONSTRAINT [PK_GenerateReportGroups_ReportsXREF] PRIMARY KEY CLUSTERED 
(
	[ReportGroupId] ASC,
	[GenerateReportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
