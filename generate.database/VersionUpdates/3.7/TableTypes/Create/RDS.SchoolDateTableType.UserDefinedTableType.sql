CREATE TYPE [RDS].[SchoolDateTableType] AS TABLE(
	[DimSchoolId] [int] NULL,
	[SchoolOrganizationId] [int] NULL,
	[DimCountDateId] [int] NULL,
	[SubmissionYearDate] [datetime] NULL,
	[Year] [int] NULL,
	[SubmissionYearStartDate] [datetime] NULL,
	[SubmissionYearEndDate] [datetime] NULL
)