CREATE TYPE [RDS].[SchoolStatusTableType] AS TABLE(
	K12SchoolIndicatorStatusId INT NULL,
	K12SchoolId INT NULL,
	DimCountDateId INT NULL,
	[Year] INT NULL,
	OrganizationId INT NULL,
	DimK12SchoolId INT NULL,
	RefIndicatorStatusTypeId INT NULL
)