CREATE TABLE [Staging].[OrganizationSchoolComprehensiveAndTargetedSupport](
	[Id] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[School_Identifier_State] [varchar](100) NOT NULL,
	[SchoolYear] [varchar](100) NULL,
	[School_ComprehensiveAndTargetedSupport] varchar(100),
	[School_ComprehensiveSupport] varchar(100),
	[School_TargetedSupport]  varchar(100)
)