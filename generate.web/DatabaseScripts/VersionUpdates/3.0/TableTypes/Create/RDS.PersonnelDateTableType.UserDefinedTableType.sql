CREATE TYPE [RDS].[PersonnelDateTableType] AS TABLE(
	[DimPersonnelId] [int] NULL,
	[PersonId] [int] NULL,
	[DimCountDateId] [int] NULL,
	[SubmissionYearDate] [datetime] NULL,
	[Year] [int] NULL,
	[SubmissionYearStartDate] [datetime] NULL,
	[SubmissionYearEndDate] [datetime] NULL
)
