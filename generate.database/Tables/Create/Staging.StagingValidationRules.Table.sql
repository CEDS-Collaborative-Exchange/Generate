CREATE TABLE [Staging].[StagingValidationRules](
	[StagingValidationRuleId] [int] IDENTITY(1,1) NOT NULL,
	[ReportGroupOrCodes] [varchar](500) NULL,
	[RuleDscr] [varchar](max) NULL,
	[StagingTableName] [varchar](100) NOT NULL,
	[ColumnName] [varchar](100) NULL,
	[ValidationType] [varchar](20) NOT NULL,
	[RefTableName] [varchar](100) NULL,
	[TableFilter] [varchar](10) NULL,
	[Condition] [varchar](2000) NULL,
	[ValidationMessage] [varchar](2000) NULL,
	[Severity] [varchar](50) NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreateDateTime]  AS (getdate()),
 CONSTRAINT [PK_StagingValidationConfig] PRIMARY KEY CLUSTERED 
(
	[StagingValidationRuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]