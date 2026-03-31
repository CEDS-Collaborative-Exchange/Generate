CREATE TYPE [RDS].[PsStudentDateTableType] AS TABLE(
	[DimPsStudentId] [int] NULL,
	[PersonId] [int] NULL,
	[DimSchoolYearId] [int] NULL,
	[DimCountDateId] [int] NULL,
	[CountDate] [datetime] NULL,
	[SchoolYear] [int] NULL,
	[SessionBeginDate] [datetime] NULL,
	[SessionEndDate] [datetime] NULL,
	[RecordStartDatetime] [datetime] NULL,
	[RecordEndDatetime] [datetime] NULL
)
