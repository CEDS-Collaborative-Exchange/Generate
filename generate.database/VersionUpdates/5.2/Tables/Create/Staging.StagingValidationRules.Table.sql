CREATE TABLE [Staging].[StagingValidationRules](
	[StagingValidationRuleId] [int] IDENTITY(1,1) NOT NULL,
	[ReportGroupOrCodes] [varchar](500) NULL,
	[RuleDscr] [varchar](200) NULL,
	[StagingTableName] [varchar](100) NOT NULL,
	[ColumnName] [varchar](100) NULL,
	[ValidationType] [varchar](20) NOT NULL,
	[RefTableName] [varchar](50) NULL,
	[TableFilter] [varchar](10) NULL,
	[Condition] [varchar](500) NULL,
	[ValidationMessage] [varchar](500) NULL,
	[Severity] [varchar](50) NULL,
 CONSTRAINT [PK_StagingValidationConfig] PRIMARY KEY CLUSTERED 
(
	[StagingValidationRuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
