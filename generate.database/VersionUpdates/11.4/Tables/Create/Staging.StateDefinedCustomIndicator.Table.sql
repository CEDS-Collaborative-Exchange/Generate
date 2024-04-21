CREATE TABLE Staging.StateDefinedCustomIndicator (
	[Code] [nvarchar](50) NULL,
	[Description] [nvarchar](100) NULL,
	[Definition] [nvarchar](max) NULL,
	RefIndicatorStatusCustomTypeId INT NULL,
	RunDateTime DATETIME
	);