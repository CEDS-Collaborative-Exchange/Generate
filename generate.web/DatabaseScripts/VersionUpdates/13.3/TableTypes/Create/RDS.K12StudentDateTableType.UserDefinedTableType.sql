CREATE TYPE [RDS].[K12StudentDateTableType] AS TABLE(
	[DimK12StudentId] [INT],
	[PersonId] [INT],
	[DimSchoolYearId] INT NULL,
	[DimCountDateId] [INT],
	[CountDate] [datetime] NULL,
	[SchoolYear] [INT] NULL,
	[SessionBeginDate] [datetime] NULL,
	[SessionEndDate] [datetime] NULL,
	[RecordStartDateTime] DATETIME,
	[RecordEndDateTime] DATETIME NULL
)
