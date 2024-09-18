CREATE TYPE [RDS].[SeaDateTableType] AS TABLE(
	[DimSeaId] [int] NULL,
	[DimCountDateId] [int] NULL,
	[SubmissionYearDate] [datetime] NULL,
	[Year] [int] NULL,
	[SubmissionYearStartDate] [datetime] NULL,
	[SubmissionYearEndDate] [datetime] NULL
)
