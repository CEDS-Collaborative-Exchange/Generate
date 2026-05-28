CREATE TYPE [RDS].[SchoolDateTableType] AS TABLE(
    [DimSchoolId] [int] NULL,
    [DimSchoolYearId] [int] NULL,
    [SubmissionYearDate] [datetime] NULL,
    [Year] [int] NULL,
    [SubmissionYearStartDate] [datetime] NULL,
    [SubmissionYearEndDate] [datetime] NULL,
    [SchoolOrganizationId] [int] NULL
)