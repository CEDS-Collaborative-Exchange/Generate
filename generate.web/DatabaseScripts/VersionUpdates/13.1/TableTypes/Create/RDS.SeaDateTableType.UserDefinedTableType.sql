CREATE TYPE [RDS].[SeaDateTableType] AS TABLE(
	[DimSeaId] [INT] NULL,
	[DimSchoolYearId] [INT] NULL,
	[DimCountDateId] [INT] NULL,
	[CountDate] [datetime] NULL,
	[SchoolYear] [INT] NULL,
	[SessionBeginDate] [datetime] NULL,
	[SessionEndDate] [datetime] NULL
)
