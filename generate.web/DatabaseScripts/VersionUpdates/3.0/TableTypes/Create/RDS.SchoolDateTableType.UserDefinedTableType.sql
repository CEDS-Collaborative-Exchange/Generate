CREATE TYPE [RDS].[SchoolStatusTableType] AS TABLE(
	K12SchoolIndicatorStatusId int NULL,
	K12SchoolId int NULL,
	DimCountDateId int NULL,
	[Year] int NULL,
	OrganizationId int NULL,
	DimSchoolId int NULL
)
