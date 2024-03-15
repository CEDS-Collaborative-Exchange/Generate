CREATE TABLE [Staging].[StagingValidationResults](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StagingValidationRuleId] [int] NULL,
	[SchoolYear] [int] NULL,
	[ReportGroupOrCode] [varchar](50) NULL,
	[StagingTableName] [varchar](200) NULL,
	[ColumnName] [varchar](100) NULL,
	[Severity] [varchar](50) NULL,
	[ValidationMessage] [varchar](500) NULL,
	[RecordCount] [int] NULL,
	[ShowRecordsSQL] [varchar](max) NULL,
	[InsertDate] [datetime] NULL,
 CONSTRAINT [PK_StagingValidationResults] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


