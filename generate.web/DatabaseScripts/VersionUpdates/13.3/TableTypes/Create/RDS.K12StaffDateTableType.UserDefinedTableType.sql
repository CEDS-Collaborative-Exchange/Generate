CREATE TYPE [RDS].[K12StaffDateTableType] AS TABLE(
	[DimK12StaffId] [int] NULL,
	[PersonId] [int] NULL,
	[DimSchoolYearId] [int] NULL,
	[DimCountDateId] [int] NULL,
	[CountDate] [datetime] NULL,
	[SchoolYear] [int] NULL,
	[SessionBeginDate] [datetime] NULL,
	[SessionEndDate] [datetime] NULL,
	[RecordStartDateTime] [datetime] NULL,
	[RecordEndDateTime] [datetime] NULL
)