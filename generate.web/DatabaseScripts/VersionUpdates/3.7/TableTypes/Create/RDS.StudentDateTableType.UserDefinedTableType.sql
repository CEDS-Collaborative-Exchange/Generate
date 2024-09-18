CREATE TYPE [RDS].[StudentDateTableType] AS TABLE(
	[DimStudentId] [int] NULL,
	[PersonId] [int] NULL,
	[DimCountDateId] [int] NULL,
	[SubmissionYearDate] [datetime] NULL,
	[Year] [int] NULL,
	[SubmissionYearStartDate] [datetime] NULL,
	[SubmissionYearEndDate] [datetime] NULL
)
