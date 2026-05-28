IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'SourceSystemReferenceData' AND Type = N'U')
BEGIN

	CREATE TABLE [ODS].[SourceSystemReferenceData](
		[SourceSystemReferenceDataId] int IDENTITY NOT NULL,
		[SchoolYear] [smallint] NOT NULL,
		[TableName] [varchar](100) NOT NULL,
		[TableFilter] [varchar](100) NULL,
		[InputCode] [nvarchar](200) NULL,
		[OutputCode] [nvarchar](200) NULL
	CONSTRAINT [PK_SourceSystemReferenceData] PRIMARY KEY CLUSTERED 
	(
		[SourceSystemReferenceDataId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE UNIQUE INDEX [IX_SourceSystemReferenceData_Unique] ON [ODS].[SourceSystemReferenceData]
	(
		[SchoolYear] DESC,
		[TableName] ASC,
		[TableFilter] ASC,
		[InputCode] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

END

IF NOT EXISTS (SELECT 1 FROM [ODS].[SourceSystemReferenceData] WHERE TABLENAME = 'RefState') 
BEGIN 

	insert into [ODS].[SourceSystemReferenceData] values 
	(2019,'RefState',NULL,'01','AL'),
	(2019,'RefState',NULL,'02','AK'),
	(2019,'RefState',NULL,'04','AZ'),
	(2019,'RefState',NULL,'05','AR'),
	(2019,'RefState',NULL,'06','CA'),
	(2019,'RefState',NULL,'08','CO'),
	(2019,'RefState',NULL,'09','CT'),
	(2019,'RefState',NULL,'10','DE'),
	(2019,'RefState',NULL,'12','FL'),
	(2019,'RefState',NULL,'13','GA'),
	(2019,'RefState',NULL,'15','HI'),
	(2019,'RefState',NULL,'16','ID'),
	(2019,'RefState',NULL,'17','IL'),
	(2019,'RefState',NULL,'18','IN'),
	(2019,'RefState',NULL,'19','IA'),
	(2019,'RefState',NULL,'20','KS'),
	(2019,'RefState',NULL,'21','KY'),
	(2019,'RefState',NULL,'22','LA'),
	(2019,'RefState',NULL,'23','ME'),
	(2019,'RefState',NULL,'24','MD'),
	(2019,'RefState',NULL,'25','MA'),
	(2019,'RefState',NULL,'26','MI'),
	(2019,'RefState',NULL,'27','MN'),
	(2019,'RefState',NULL,'28','MS'),
	(2019,'RefState',NULL,'29','MO'),
	(2019,'RefState',NULL,'30','MT'),
	(2019,'RefState',NULL,'31','NE'),
	(2019,'RefState',NULL,'32','NV'),
	(2019,'RefState',NULL,'33','NH'),
	(2019,'RefState',NULL,'34','NJ'),
	(2019,'RefState',NULL,'35','NM'),
	(2019,'RefState',NULL,'36','NY'),
	(2019,'RefState',NULL,'37','NC'),
	(2019,'RefState',NULL,'38','ND'),
	(2019,'RefState',NULL,'39','OH'),
	(2019,'RefState',NULL,'40','OK'),
	(2019,'RefState',NULL,'41','OR'),
	(2019,'RefState',NULL,'42','PA'),
	(2019,'RefState',NULL,'44','RI'),
	(2019,'RefState',NULL,'45','SC'),
	(2019,'RefState',NULL,'46','SD'),
	(2019,'RefState',NULL,'47','TN'),
	(2019,'RefState',NULL,'48','TX'),
	(2019,'RefState',NULL,'49','UT'),
	(2019,'RefState',NULL,'50','VT'),
	(2019,'RefState',NULL,'51','VA'),
	(2019,'RefState',NULL,'53','WA'),
	(2019,'RefState',NULL,'54','WV'),
	(2019,'RefState',NULL,'55','WI'),
	(2019,'RefState',NULL,'56','WY'),
	(2019,'RefState',NULL,'60','AS'),
	(2019,'RefState',NULL,'66','GU'),
	(2019,'RefState',NULL,'69','MP'),
	(2019,'RefState',NULL,'72','PR'),
	(2019,'RefState',NULL,'78','VI')

END

