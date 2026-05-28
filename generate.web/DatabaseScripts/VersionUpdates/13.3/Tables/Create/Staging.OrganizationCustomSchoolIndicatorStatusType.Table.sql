CREATE TABLE Staging.OrganizationCustomSchoolIndicatorStatusType (
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[School_Identifier_State] [varchar](100) NOT NULL,
	[SchoolYear] [varchar](100) NULL,
	[IndicatorStatusType] [varchar](100) NULL,
	[IndicatorStatus] [varchar](100) NULL,
	[IndicatorStatusSubgroupType] [varchar](100) NULL,
	[IndicatorStatusSubgroup] [varchar](100) NULL,
	[StatedDefinedIndicatorStatus] [varchar](100) NULL,
	[StatedDefinedCustomIndicatorStatusType] [varchar](100) NULL,
	[RecordStartDateTime] [DATE] NULL,
    [RecordEndDateTime] [DATE] NULL
);

