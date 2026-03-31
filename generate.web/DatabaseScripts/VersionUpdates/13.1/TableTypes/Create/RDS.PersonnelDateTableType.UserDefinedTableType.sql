CREATE TYPE [RDS].[PersonnelDateTableType] AS TABLE(
	[DimK12StaffId] [INT] NULL,
	[PersonId] [INT] NULL,
	[DimSchoolYearId] [INT] NULL,
	[DimCountDateId] [INT] NULL,
	[CountDate] [datetime] NULL,
	[SchoolYear] [INT] NULL,
	[SessionBeginDate] [datetime] NULL,
	[SessionEndDate] [datetime] NULL
)
