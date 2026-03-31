CREATE TYPE [RDS].[LeaDateTableType] AS TABLE(
	[DimLeaId]			[INT] NULL,
	[DimSchoolYearId]	[INT] NULL,
	[CountDate]			[datetime] NULL,
	[SchoolYear]		[INT] NULL,
	[SessionBeginDate]	[datetime] NULL,
	[SessionEndDate]	[datetime] NULL,
	[SchoolOrganizationId]    [int] NULL
)
