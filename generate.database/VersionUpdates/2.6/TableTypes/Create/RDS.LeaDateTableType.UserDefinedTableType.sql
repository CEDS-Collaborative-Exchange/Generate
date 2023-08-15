CREATE TYPE [RDS].[LeaDateTableType] AS TABLE(
	[DimLeaId] [int] NULL,
	[DimCountDateId] [int] NULL,
	[SubmissionYearDate] [datetime] NULL,
	[Year] [int] NULL,
	[SubmissionYearStartDate] [datetime] NULL,
	[SubmissionYearEndDate] [datetime] NULL
)
