CREATE TABLE [App].[GenerateReportGroups](
	[ReportGroupId] [smallint] NOT NULL,
	[ReportGroup] [nvarchar](50) NULL,
 CONSTRAINT [PK_App.GenerateReportGroups] PRIMARY KEY CLUSTERED 
(
	[ReportGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

