IF EXISTS(SELECT 1 FROM sys.indexes
WHERE object_id = OBJECT_ID('App.TableTypes') AND name = 'UX_TableTypes')
BEGIN
	ALTER TABLE [App].[TableTypes] DROP CONSTRAINT [UX_TableTypes]
END

IF NOT EXISTS(SELECT 1 FROM sys.indexes
WHERE object_id = OBJECT_ID('App.TableTypes') AND name = 'UX_TableTypes')
BEGIN
	ALTER TABLE [App].[TableTypes] ADD  CONSTRAINT [UX_TableTypes] UNIQUE NONCLUSTERED 
	(
		[TableTypeAbbrv], [EdFactsTableTypeId]  ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END

IF NOT EXISTS(SELECT 1 FROM sys.indexes
WHERE object_id = OBJECT_ID('App.GenerateReport_FactType') AND name = 'PK_GenerateReport_FactTypes')
BEGIN
	ALTER TABLE [App].[GenerateReport_FactType] ADD  CONSTRAINT [PK_GenerateReport_FactTypes] PRIMARY KEY CLUSTERED 
	(
		[GenerateReportId] ASC,
		[FactTypeId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END

IF COL_LENGTH('App.DataMigrations', 'UserName') IS NULL
BEGIN
	ALTER TABLE App.DataMigrations ADD UserName nvarchar(100);
END

IF COL_LENGTH('App.DataMigrations', 'DataMigrationTaskList') IS NULL
BEGIN
	ALTER TABLE App.DataMigrations ADD DataMigrationTaskList nvarchar(50);
END

IF COL_LENGTH('App.DataMigrationTasks', 'FactTypeId') IS NULL
BEGIN
	ALTER TABLE App.DataMigrationTasks ADD FactTypeId int NOT NULL default(-1);
END

UPDATE App.GenerateReport_FactType
SET FactTypeId = @AssessmentFactTypeId
WHERE GenerateReportId = @GenerateReportId
	
-- Update name of NorD Wrapper
update app.DataMigrationTasks
set StoredProcedureName = 'App.Wrapper_Migrate_NeglectedOrDelinquent_to_RDS', Description = '119, 127, 218, 219, 220, 221'
where StoredProcedureName = 'App.Wrapper_Migrate_NorD_to_RDS'

--Update the table names for app.FactTables for Organization reports
update ft
set FactReportTableName = 'ReportEDFactsOrganizationCounts'
	, FactReportTableIdName = 'ReportEDFactsOrganizationCountId'
from app.FactTables ft 
inner join app.GenerateReports r 
	on ft.FactTableId = r.FactTableId
where r.ReportCode in ('c029','c039','c035','c129','c190')
