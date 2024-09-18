CREATE TABLE [Staging].[StagingValidationRules_ReportsXREF](
	[StagingValidationRuleId] [int] NOT NULL,
	[GenerateReportId] [int] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDateTime]  AS (getdate()),
 CONSTRAINT [PK_Staging.StagingValidationRulesReportsXREF] PRIMARY KEY CLUSTERED 
(
	[StagingValidationRuleId] ASC,
	[GenerateReportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]



