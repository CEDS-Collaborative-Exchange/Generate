DECLARE @AssessmentFactTypeId INT, @GenerateReportId INT
declare @rdsDataMigrationTypeId as varchar(50), @reportDataMigrationTypeId as varchar(50)
declare @factTypeId as int, @taskSquence as int
declare @factTypeCode as varchar(100)

SELECT @AssessmentFactTypeId = DimFactTypeId 
FROM RDS.DimFactTypes 
WHERE FactTypeCode = 'Assessment'

SELECT @GenerateReportId = GenerateReportId
FROM App.GenerateReports
WHERE ReportCode = 'C224'

UPDATE App.GenerateReport_FactType
SET FactTypeId = @AssessmentFactTypeId
WHERE GenerateReportId = @GenerateReportId

SELECT @GenerateReportId = GenerateReportId
FROM App.GenerateReports
WHERE ReportCode = 'C225'

UPDATE App.GenerateReport_FactType
SET FactTypeId = @AssessmentFactTypeId
WHERE GenerateReportId = @GenerateReportId
	
-- Update name of NorD Wrapper
update app.DataMigrationTasks
set StoredProcedureName = 'App.Wrapper_Migrate_NeglectedOrDelinquent_to_RDS', Description = '119, 127, 218, 219, 220, 221'
where StoredProcedureName = 'App.Wrapper_Migrate_NorD_to_RDS'

update app.DataMigrationTasks
set StoredProcedureName = 'rds.Empty_Reports ''graduatescompleters'''
where StoredProcedureName = 'rds.Empty_Reports ''grad'''

update app.DataMigrationTasks
set StoredProcedureName = 'rds.create_reports ''graduatescompleters'',0'
where StoredProcedureName = 'rds.create_reports ''grad'',0'

update app.DataMigrationTasks
set StoredProcedureName = 'rds.Empty_Reports ''migranteducationprogram'''
where StoredProcedureName = 'rds.Empty_Reports ''mep'''

update app.DataMigrationTasks
set StoredProcedureName = 'rds.create_reports ''migranteducationprogram'',0'
where StoredProcedureName = 'rds.create_reports ''mep'',0'

update app.DataMigrationTasks
set StoredProcedureName = 'rds.Empty_Reports ''neglectedordelinquent'''
where StoredProcedureName = 'rds.Empty_Reports ''nord'''

update app.DataMigrationTasks
set StoredProcedureName = 'rds.create_reports ''neglectedordelinquent'',0'
where StoredProcedureName = 'rds.create_reports ''nord'',0'

update app.DataMigrationTasks
set StoredProcedureName = 'rds.Empty_Reports ''graduationrate'''
where StoredProcedureName = 'rds.Empty_Reports ''gradrate'''

update app.DataMigrationTasks
set StoredProcedureName = 'rds.create_reports ''graduationrate'',0'
where StoredProcedureName = 'rds.create_reports ''gradrate'',0'

update app.DataMigrationTasks
set StoredProcedureName = 'rds.Empty_Reports ''hsgradpsenroll'''
where StoredProcedureName = 'rds.Empty_Reports ''hsgradenroll'''

update app.DataMigrationTasks
set StoredProcedureName = 'rds.create_reports ''hsgradpsenroll'',0'
where StoredProcedureName = 'rds.create_reports ''hsgradenroll'',0'


SET @taskSquence = 301
DECLARE factType_cursor CURSOR FOR 
SELECT DimFactTypeId, lower(FactTypeCode)
FROM rds.DimFactTypes
where DimFactTypeId > 0
order by DimFactTypeId


OPEN factType_cursor
FETCH NEXT FROM factType_cursor INTO @factTypeId, @factTypeCode

WHILE @@FETCH_STATUS = 0
BEGIN

	Update app.DataMigrationTasks set FactTypeId = @factTypeId
	where lower(StoredProcedureName) like '%' + @factTypeCode + '%'

	IF NOT EXISTS(SELECT 1 FROM [App].[DataMigrationTasks] WHERE [FactTypeId] = @factTypeId AND [DataMigrationTypeId] = 5 AND [StoredProcedureName] = 'Staging.StagingValidation_Execute @SchoolYear, @FactTypeOrReportCode')
	BEGIN
		INSERT INTO [App].[DataMigrationTasks]
				([DataMigrationTypeId]
				,[IsActive]
				,[RunAfterGenerateMigration]
				,[RunBeforeGenerateMigration]
				,[StoredProcedureName]
				,[TaskSequence]
				,[IsSelected]
				,[Description]
				,[TaskName]
				,[FactTypeId])
		VALUES(5, 1, 0, 0, 'Staging.StagingValidation_Execute @SchoolYear, @FactTypeOrReportCode', @taskSquence, 1, 'Staging Validation for ' + @factTypeCode, '', @factTypeId)
	END
	SET @taskSquence = @taskSquence + 1

	FETCH NEXT FROM factType_cursor INTO @factTypeId, @factTypeCode
END

CLOSE factType_cursor
DEALLOCATE factType_cursor



select @rdsDataMigrationTypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'rds'
select @reportDataMigrationTypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'report'

Update app.DataMigrationTasks set TaskSequence = TaskSequence + 100, IsSelected = 1 where DataMigrationTypeId = @rdsDataMigrationTypeId
Update app.DataMigrationTasks set TaskSequence = TaskSequence + 200 where DataMigrationTypeId = @reportDataMigrationTypeId

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

-------------------------------------------
-- DimFactTypes
-------------------------------------------
	update f
	set f.FactTypeDescription = concat(f.FactTypeDescription, ' - ', rc.ReportCodes)
	from rds.DimFactTypes f
		inner join (SELECT rdft.FactTypeCode,
		STUFF((SELECT ',' + replace(r.ReportCode, 'c', '') 
				FROM app.GenerateReport_FactType rf
				inner join rds.DimFactTypes f
					on rf.FactTypeId = f.DimFactTypeId
				inner join app.GenerateReports r
					on rf.GenerateReportId = r.GenerateReportId
			WHERE f.FactTypeCode = rdft.FactTypeCode
			AND len(r.ReportCode) = 4
			ORDER BY replace(r.ReportCode, 'c', '')
				FOR XML PATH(''), TYPE).value('text()[1]', 'nvarchar(max)')
		, 1, LEN(','), '') AS ReportCodes
	FROM rds.DimFactTypes rdft
	GROUP BY rdft.FactTypeCode) rc
			on f.FactTypeCode = rc.FactTypeCode
	where isnull(rc.ReportCodes, '') <> ''