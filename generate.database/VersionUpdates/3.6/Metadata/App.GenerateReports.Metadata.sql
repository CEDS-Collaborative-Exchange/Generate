/*
-- To generate metadata refresh script, run this on EDENDB on 192.168.71.30

set nocount on;

-- Use three most recent school years
--   Using all school years were causing duplicate reports when file spec name changed over years
--   Note, this means that older, retired file specs will not be updated if they change
--   Note, this might still cause duplicate data when a file spec name changes

declare @latestSchoolYear as int
select @latestSchoolYear = max(ReportingPeriodId) from reportingperiod where substring(ReportingPeriodAbbrv, 1, 1) = '2'

declare @lastSchoolYear as int
select @lastSchoolYear = max(ReportingPeriodId) from reportingperiod where substring(ReportingPeriodAbbrv, 1, 1) = '2' and ReportingPeriodId <> @latestSchoolYear

declare @schoolYearBeforeLast as int
select @schoolYearBeforeLast = max(ReportingPeriodId) from reportingperiod where substring(ReportingPeriodAbbrv, 1, 1) = '2' and ReportingPeriodId not in (@latestSchoolYear, @lastSchoolYear)


DECLARE @fileSpecs TABLE
(
	fileSpec nvarchar(10)
)

-- Release 2.4
insert into @fileSpecs (fileSpec) values ('c002')
insert into @fileSpecs (fileSpec) values ('c005')
insert into @fileSpecs (fileSpec) values ('c006')
insert into @fileSpecs (fileSpec) values ('c007')
insert into @fileSpecs (fileSpec) values ('c009')
insert into @fileSpecs (fileSpec) values ('c029')
insert into @fileSpecs (fileSpec) values ('c032')
insert into @fileSpecs (fileSpec) values ('c033')
insert into @fileSpecs (fileSpec) values ('c036')
insert into @fileSpecs (fileSpec) values ('c037')
insert into @fileSpecs (fileSpec) values ('c039')
insert into @fileSpecs (fileSpec) values ('c040')
insert into @fileSpecs (fileSpec) values ('c052')
insert into @fileSpecs (fileSpec) values ('c054')
insert into @fileSpecs (fileSpec) values ('c059')
insert into @fileSpecs (fileSpec) values ('c065')
insert into @fileSpecs (fileSpec) values ('c070')
insert into @fileSpecs (fileSpec) values ('c082')
insert into @fileSpecs (fileSpec) values ('c083')
insert into @fileSpecs (fileSpec) values ('c088')
insert into @fileSpecs (fileSpec) values ('c089')
insert into @fileSpecs (fileSpec) values ('c099')
insert into @fileSpecs (fileSpec) values ('c112')
insert into @fileSpecs (fileSpec) values ('c121')
insert into @fileSpecs (fileSpec) values ('c122')
insert into @fileSpecs (fileSpec) values ('c129')
insert into @fileSpecs (fileSpec) values ('c130')
insert into @fileSpecs (fileSpec) values ('c134')
insert into @fileSpecs (fileSpec) values ('c141')
insert into @fileSpecs (fileSpec) values ('c142')
insert into @fileSpecs (fileSpec) values ('c143')
insert into @fileSpecs (fileSpec) values ('c144')
insert into @fileSpecs (fileSpec) values ('c145')
insert into @fileSpecs (fileSpec) values ('c154')
insert into @fileSpecs (fileSpec) values ('c155')
insert into @fileSpecs (fileSpec) values ('c156')
insert into @fileSpecs (fileSpec) values ('c157')
insert into @fileSpecs (fileSpec) values ('c158')
insert into @fileSpecs (fileSpec) values ('c165')
insert into @fileSpecs (fileSpec) values ('c167')
insert into @fileSpecs (fileSpec) values ('c169')
insert into @fileSpecs (fileSpec) values ('c175')
insert into @fileSpecs (fileSpec) values ('c178')
insert into @fileSpecs (fileSpec) values ('c185')
insert into @fileSpecs (fileSpec) values ('c188')
insert into @fileSpecs (fileSpec) values ('c190')
insert into @fileSpecs (fileSpec) values ('c193')
insert into @fileSpecs (fileSpec) values ('c196')
insert into @fileSpecs (fileSpec) values ('c197')
insert into @fileSpecs (fileSpec) values ('c198')

-- Release 2.5
insert into @fileSpecs (fileSpec) values ('c103')
insert into @fileSpecs (fileSpec) values ('c118')
insert into @fileSpecs (fileSpec) values ('c132')
insert into @fileSpecs (fileSpec) values ('c170')
insert into @fileSpecs (fileSpec) values ('c194')
insert into @fileSpecs (fileSpec) values ('c195')

-- Release 2.6
insert into @fileSpecs (fileSpec) values ('c045')
insert into @fileSpecs (fileSpec) values ('c050')
insert into @fileSpecs (fileSpec) values ('c067')
insert into @fileSpecs (fileSpec) values ('c116')
insert into @fileSpecs (fileSpec) values ('c126')
insert into @fileSpecs (fileSpec) values ('c137')
insert into @fileSpecs (fileSpec) values ('c138')
insert into @fileSpecs (fileSpec) values ('c139')
insert into @fileSpecs (fileSpec) values ('c179')
insert into @fileSpecs (fileSpec) values ('c189')
insert into @fileSpecs (fileSpec) values ('c204')
insert into @fileSpecs (fileSpec) values ('c205')

-- Release 2.7
insert into @fileSpecs (fileSpec) values ('c086')
insert into @fileSpecs (fileSpec) values ('c131')
insert into @fileSpecs (fileSpec) values ('c150')
insert into @fileSpecs (fileSpec) values ('c151')
insert into @fileSpecs (fileSpec) values ('c160')
insert into @fileSpecs (fileSpec) values ('c163')
insert into @fileSpecs (fileSpec) values ('c199')

-- Release 2.8
insert into @fileSpecs (fileSpec) values ('c113')
insert into @fileSpecs (fileSpec) values ('c119')
insert into @fileSpecs (fileSpec) values ('c125')
insert into @fileSpecs (fileSpec) values ('c127')
insert into @fileSpecs (fileSpec) values ('c180')
insert into @fileSpecs (fileSpec) values ('c181')

-- Release 2.9
insert into @fileSpecs (fileSpec) values ('c192')
insert into @fileSpecs (fileSpec) values ('c200')
insert into @fileSpecs (fileSpec) values ('c201')
insert into @fileSpecs (fileSpec) values ('c202')
insert into @fileSpecs (fileSpec) values ('c203')
insert into @fileSpecs (fileSpec) values ('c206')
insert into @fileSpecs (fileSpec) values ('c207')

-- Release 3.0
insert into @fileSpecs (fileSpec) values ('c035')

-- Release 3.5
insert into @fileSpecs (fileSpec) values ('c208')
insert into @fileSpecs (fileSpec) values ('c209')
insert into @fileSpecs (fileSpec) values ('c212')
insert into @fileSpecs (fileSpec) values ('c213')
insert into @fileSpecs (fileSpec) values ('c214')
insert into @fileSpecs (fileSpec) values ('c215')
insert into @fileSpecs (fileSpec) values ('c216')
insert into @fileSpecs (fileSpec) values ('c217')


print 'set nocount on'
print 'begin try'
print ''
print '	begin transaction'
print ''

print '		declare @generateReportTypeId as int'
print '		select @generateReportTypeId = GenerateReportTypeId from App.GenerateReportTypes where ReportTypeCode = ''edfactsreport'''
print ''
print '		declare @GenerateReportControlTypeId as int = 2'
print '		declare @ShowCategorySetControl as bit = 1'
print ''
print '		declare @GenerateReportId as int'
print ''

declare @ReportCode as varchar(50)
declare @ReportName as varchar(500)
declare @ReportShortName as varchar(50)
declare @ReportShortNameAlt as varchar(50)
declare @isActive as varchar(5)
declare @EduationLevelId as int

DECLARE cs_cursor CURSOR FOR 
Select distinct 'c' + substring(fsd.FileSpecificationDocumentNumber, 2, 3) as ReportCode,
'C' + substring(fsd.FileSpecificationDocumentNumber, 2, 3)  + ': ' + fsd.DisplayName as ReportName,
'C' + substring(fsd.FileSpecificationDocumentNumber, 2, 3) as ReportShortName,
'FS' + substring(fsd.FileSpecificationDocumentNumber, 2, 3) as ReportShortNameAlt,
1 AS IsActive
from FileSpecificationDocument fsd
inner join FileRecordLayout_x_FileSpecificationDocument frlfsd on fsd.FileSpecificationDocumentId = frlfsd.FileSpecificationDocumentId
inner join FileRecordLayout frl on frlfsd.FileRecordLayoutID = frl.FileRecordLayoutID
inner join ReportingPeriod rp on frl.ReportingPeriodId = rp.ReportingPeriodId
inner join ReportingPeriod sy on rp.SchoolYearId = sy.ReportingPeriodId
and sy.ReportingPeriodId in (@latestSchoolYear, @lastSchoolYear, @schoolYearBeforeLast)
where fsd.FileSpecificationDocumentNumber like 'N%'
and 'c' + substring(fsd.FileSpecificationDocumentNumber, 2, 3) in (select fileSpec from @fileSpecs)
order by 'c' + substring(fsd.FileSpecificationDocumentNumber, 2, 3) 

OPEN cs_cursor
FETCH NEXT FROM cs_cursor INTO @ReportCode, @ReportName, @ReportShortName, @ReportShortNameAlt, @isActive

WHILE @@FETCH_STATUS = 0
BEGIN
	print ''
	print '		----------------------'
	print '		-- ' + @ReportCode
	print '		----------------------'
	print ''
	print ''
	print '		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode =''' + @ReportCode + '''  and GenerateReportTypeId = @generateReportTypeId)'
	Print '		BEGIN'
	print '			INSERT into App.GenerateReports'
	print '			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)'
	print '			values'
	print '			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like ''%' + @ReportShortName + '%'' OR CedsConnectionName like ''%' + @ReportShortNameAlt + '%'' order by CedsUseCaseId desc),'
	print '			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, ''' + @ReportCode + ''', ''' + @ReportName + ''', ''' + @ReportShortName + ''', ' + @isActive + ' )'

	print ''
	print '			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)'

	Print '		END'			

	PRINT '		ELSE'
	PRINT '		BEGIN'
	print '			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = ''' + @ReportCode + ''' and GenerateReportTypeId = @generateReportTypeId'
	print '			UPDATE app.GenerateReports SET ReportName ='''  + @ReportName + ''',	ReportShortName = ''' + @ReportShortName +''' , IsActive =''' + @isActive + ''', '
	print '			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like ''%' + @ReportShortName + '%'' OR CedsConnectionName like ''%' + @ReportShortNameAlt + '%'' order by CedsUseCaseId desc) '
	print '			WHERE GenerateReportId = @GenerateReportId'
	PRINT '		END'

	PRINT ''
	print '		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId'
	print ''

	declare orgLevel_cursor CURSOR FOR 
	Select distinct frl.EducationLevelId
	from FileSpecificationDocument fsd
	inner join FileRecordLayout_x_FileSpecificationDocument frlfsd on fsd.FileSpecificationDocumentId = frlfsd.FileSpecificationDocumentId
	inner join FileRecordLayout frl on frlfsd.FileRecordLayoutID = frl.FileRecordLayoutID
	inner join ReportingPeriod rp on frl.ReportingPeriodId = rp.ReportingPeriodId
	inner join ReportingPeriod sy on rp.SchoolYearId = sy.ReportingPeriodId
	and sy.ReportingPeriodId in (@latestSchoolYear, @lastSchoolYear, @schoolYearBeforeLast)
	where 'c' + substring(fsd.FileSpecificationDocumentNumber, 2, 3) = @ReportCode
	order by frl.EducationLevelId
	
	OPEN orgLevel_cursor
	FETCH NEXT FROM orgLevel_cursor INTO @EduationLevelId

	WHILE @@FETCH_STATUS = 0
	BEGIN

		print '		INSERT into App.GenerateReport_OrganizationLevels'
		print '		(GenerateReportId,OrganizationLevelId)'
		print '		values'
		print '		(@GenerateReportId, ' + convert(varchar(20), @EduationLevelId) + ')'
		print ''
	
		FETCH NEXT FROM orgLevel_cursor INTO @EduationLevelId
	END

	CLOSE orgLevel_cursor
	DEALLOCATE orgLevel_cursor


	FETCH NEXT FROM cs_cursor INTO @ReportCode, @ReportName, @ReportShortName, @ReportShortNameAlt, @isActive
END

CLOSE cs_cursor
DEALLOCATE cs_cursor



print '	commit transaction'

print ''

print 'end try'
print ''
print 'begin catch'
print '	IF @@TRANCOUNT > 0'
print '	begin'
print '		rollback transaction'
print '	end'

print '	declare @msg as nvarchar(max)'
print '	set @msg = ERROR_MESSAGE()'

print '	declare @sev as int'
print '	set @sev = ERROR_SEVERITY()'

print '	RAISERROR(@msg, @sev, 1)'

print 'end catch'

print ''
print 'set nocount off' 

set nocount off;


*/

/************************************************************
*
*	Updated on 04/20/2020
*
*************************************************************/
set nocount on
begin try
 
	begin transaction
 
		declare @generateReportTypeId as int
		select @generateReportTypeId = GenerateReportTypeId from App.GenerateReportTypes where ReportTypeCode = 'edfactsreport'
 
		declare @GenerateReportControlTypeId as int = 2
		declare @ShowCategorySetControl as bit = 1
 
		declare @GenerateReportId as int
 
 
		----------------------
		-- c002
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c002'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C002%' OR CedsConnectionName like '%FS002%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c002', 'C002: Children with Disabilities (IDEA) School Age', 'C002', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c002' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C002: Children with Disabilities (IDEA) School Age',	ReportShortName = 'C002' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C002%' OR CedsConnectionName like '%FS002%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c005
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c005'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C005%' OR CedsConnectionName like '%FS005%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c005', 'C005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting', 'C005', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c005' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting',	ReportShortName = 'C005' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C005%' OR CedsConnectionName like '%FS005%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c006
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c006'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C006%' OR CedsConnectionName like '%FS006%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c006', 'C006: Children with Disabilities (IDEA) Suspensions/Expulsions', 'C006', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c006' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C006: Children with Disabilities (IDEA) Suspensions/Expulsions',	ReportShortName = 'C006' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C006%' OR CedsConnectionName like '%FS006%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c007
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c007'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C007%' OR CedsConnectionName like '%FS007%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c007', 'C007: Children with Disabilities (IDEA) Reasons for Unilateral Removal', 'C007', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c007' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C007: Children with Disabilities (IDEA) Reasons for Unilateral Removal',	ReportShortName = 'C007' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C007%' OR CedsConnectionName like '%FS007%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c009
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c009'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C009%' OR CedsConnectionName like '%FS009%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c009', 'C009: Children with Disabilities (IDEA) Exiting Special Education', 'C009', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c009' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C009: Children with Disabilities (IDEA) Exiting Special Education',	ReportShortName = 'C009' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C009%' OR CedsConnectionName like '%FS009%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c029
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c029'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C029%' OR CedsConnectionName like '%FS029%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c029', 'C029: Directory', 'C029', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c029' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C029: Directory',	ReportShortName = 'C029' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C029%' OR CedsConnectionName like '%FS029%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c032
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c032'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C032%' OR CedsConnectionName like '%FS032%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c032', 'C032: Dropouts', 'C032', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c032' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C032: Dropouts',	ReportShortName = 'C032' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C032%' OR CedsConnectionName like '%FS032%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c033
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c033'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C033%' OR CedsConnectionName like '%FS033%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c033', 'C033: Free and Reduced Price Lunch', 'C033', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c033' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C033: Free and Reduced Price Lunch',	ReportShortName = 'C033' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C033%' OR CedsConnectionName like '%FS033%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c037
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c037'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C037%' OR CedsConnectionName like '%FS037%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c037', 'C037: Title I Part A SWP/TAS Participation', 'C037', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c037' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C037: Title I Part A SWP/TAS Participation',	ReportShortName = 'C037' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C037%' OR CedsConnectionName like '%FS037%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c039
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c039'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C039%' OR CedsConnectionName like '%FS039%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c039', 'C039: Grades Offered', 'C039', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c039' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C039: Grades Offered',	ReportShortName = 'C039' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C039%' OR CedsConnectionName like '%FS039%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c040
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c040'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C040%' OR CedsConnectionName like '%FS040%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c040', 'C040: Graduates/Completers', 'C040', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c040' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C040: Graduates/Completers',	ReportShortName = 'C040' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C040%' OR CedsConnectionName like '%FS040%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c045
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c045'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C045%' OR CedsConnectionName like '%FS045%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c045', 'C045: Immigrant', 'C045', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c045' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C045: Immigrant',	ReportShortName = 'C045' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C045%' OR CedsConnectionName like '%FS045%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c050
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c050'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C050%' OR CedsConnectionName like '%FS050%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c050', 'C050: Title III English Language Proficiency Results', 'C050', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c050' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C050: Title III English Language Proficiency Results',	ReportShortName = 'C050' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C050%' OR CedsConnectionName like '%FS050%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c052
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c052'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C052%' OR CedsConnectionName like '%FS052%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c052', 'C052: Membership', 'C052', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c052' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C052: Membership',	ReportShortName = 'C052' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C052%' OR CedsConnectionName like '%FS052%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c054
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c054'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C054%' OR CedsConnectionName like '%FS054%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c054', 'C054: MEP Students Served - 12 Month ', 'C054', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c054' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C054: MEP Students Served - 12 Month ',	ReportShortName = 'C054' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C054%' OR CedsConnectionName like '%FS054%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c059
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c059'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C059%' OR CedsConnectionName like '%FS059%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c059', 'C059: Staff FTE', 'C059', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c059' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C059: Staff FTE',	ReportShortName = 'C059' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C059%' OR CedsConnectionName like '%FS059%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c067
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c067'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C067%' OR CedsConnectionName like '%FS067%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c067', 'C067: Title III Teachers', 'C067', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c067' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C067: Title III Teachers',	ReportShortName = 'C067' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C067%' OR CedsConnectionName like '%FS067%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c070
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c070'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C070%' OR CedsConnectionName like '%FS070%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c070', 'C070: Special Education Teachers (FTE)', 'C070', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c070' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C070: Special Education Teachers (FTE)',	ReportShortName = 'C070' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C070%' OR CedsConnectionName like '%FS070%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c082
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c082'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C082%' OR CedsConnectionName like '%FS082%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c082', 'C082: CTE Concentrators Exiting', 'C082', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c082' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C082: CTE Concentrators Exiting',	ReportShortName = 'C082' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C082%' OR CedsConnectionName like '%FS082%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c083
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c083'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C083%' OR CedsConnectionName like '%FS083%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c083', 'C083: CTE Concentrators Graduates', 'C083', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c083' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C083: CTE Concentrators Graduates',	ReportShortName = 'C083' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C083%' OR CedsConnectionName like '%FS083%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c086
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c086'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C086%' OR CedsConnectionName like '%FS086%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c086', 'C086: Students Involved with Firearms', 'C086', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c086' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C086: Students Involved with Firearms',	ReportShortName = 'C086' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C086%' OR CedsConnectionName like '%FS086%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c088
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c088'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C088%' OR CedsConnectionName like '%FS088%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c088', 'C088: Children with Disabilities (IDEA) Disciplinary Removals', 'C088', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c088' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C088: Children with Disabilities (IDEA) Disciplinary Removals',	ReportShortName = 'C088' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C088%' OR CedsConnectionName like '%FS088%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c089
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c089'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C089%' OR CedsConnectionName like '%FS089%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c089', 'C089: Children with Disabilities (IDEA) Early Childhood', 'C089', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c089' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C089: Children with Disabilities (IDEA) Early Childhood',	ReportShortName = 'C089' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C089%' OR CedsConnectionName like '%FS089%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c099
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c099'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C099%' OR CedsConnectionName like '%FS099%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c099', 'C099: Special Education Related Services Personnel', 'C099', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c099' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C099: Special Education Related Services Personnel',	ReportShortName = 'C099' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C099%' OR CedsConnectionName like '%FS099%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c103
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c103'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C103%' OR CedsConnectionName like '%FS103%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c103', 'C103: Accountability', 'C103', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c103' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C103: Accountability',	ReportShortName = 'C103' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C103%' OR CedsConnectionName like '%FS103%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c112
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c112'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C112%' OR CedsConnectionName like '%FS112%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c112', 'C112: Special Education Paraprofessionals', 'C112', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c112' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C112: Special Education Paraprofessionals',	ReportShortName = 'C112' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C112%' OR CedsConnectionName like '%FS112%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c113
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c113'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C113%' OR CedsConnectionName like '%FS113%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c113', 'C113: N or D Academic Achievement - State Agency', 'C113', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c113' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C113: N or D Academic Achievement - State Agency',	ReportShortName = 'C113' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C113%' OR CedsConnectionName like '%FS113%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c116
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c116'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C116%' OR CedsConnectionName like '%FS116%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c116', 'C116: Title III Students Served', 'C116', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c116' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C116: Title III Students Served',	ReportShortName = 'C116' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C116%' OR CedsConnectionName like '%FS116%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c118
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c118'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C118%' OR CedsConnectionName like '%FS118%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c118', 'C118: Homeless Students Enrolled', 'C118', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c118' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C118: Homeless Students Enrolled',	ReportShortName = 'C118' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C118%' OR CedsConnectionName like '%FS118%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c119
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c119'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C119%' OR CedsConnectionName like '%FS119%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c119', 'C119: Neglected or Delinquent Participation (SEA)', 'C119', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c119' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C119: Neglected or Delinquent Participation (SEA)',	ReportShortName = 'C119' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C119%' OR CedsConnectionName like '%FS119%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c121
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c121'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C121%' OR CedsConnectionName like '%FS121%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c121', 'C121: Migratory Students Eligible - 12 Months', 'C121', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c121' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C121: Migratory Students Eligible - 12 Months',	ReportShortName = 'C121' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C121%' OR CedsConnectionName like '%FS121%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c122
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c122'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C122%' OR CedsConnectionName like '%FS122%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c122', 'C122: MEP Students Eligible and Served - Summer/Intersession', 'C122', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c122' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C122: MEP Students Eligible and Served - Summer/Intersession',	ReportShortName = 'C122' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C122%' OR CedsConnectionName like '%FS122%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c125
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c125'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C125%' OR CedsConnectionName like '%FS125%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c125', 'C125: N or D Academic Achievement - LEA', 'C125', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c125' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C125: N or D Academic Achievement - LEA',	ReportShortName = 'C125' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C125%' OR CedsConnectionName like '%FS125%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c126
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c126'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C126%' OR CedsConnectionName like '%FS126%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c126', 'C126: Title III Former EL Students', 'C126', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c126' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C126: Title III Former EL Students',	ReportShortName = 'C126' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C126%' OR CedsConnectionName like '%FS126%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c127
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c127'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C127%' OR CedsConnectionName like '%FS127%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c127', 'C127: N or D - Participation (LEA)', 'C127', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c127' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C127: N or D - Participation (LEA)',	ReportShortName = 'C127' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C127%' OR CedsConnectionName like '%FS127%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c129
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c129'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C129%' OR CedsConnectionName like '%FS129%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c129', 'C129: CCD School', 'C129', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c129' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C129: CCD School',	ReportShortName = 'C129' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C129%' OR CedsConnectionName like '%FS129%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c130
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c130'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C130%' OR CedsConnectionName like '%FS130%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c130', 'C130: ESEA Status', 'C130', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c130' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C130: ESEA Status',	ReportShortName = 'C130' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C130%' OR CedsConnectionName like '%FS130%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c131
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c131'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C131%' OR CedsConnectionName like '%FS131%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c131', 'C131: LEA End of School Year Status', 'C131', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c131' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C131: LEA End of School Year Status',	ReportShortName = 'C131' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C131%' OR CedsConnectionName like '%FS131%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c132
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c132'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C132%' OR CedsConnectionName like '%FS132%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c132', 'C132: Section 1003 Funds', 'C132', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c132' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C132: Section 1003 Funds',	ReportShortName = 'C132' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C132%' OR CedsConnectionName like '%FS132%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c134
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c134'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C134%' OR CedsConnectionName like '%FS134%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c134', 'C134: Title I Part A Participation', 'C134', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c134' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C134: Title I Part A Participation',	ReportShortName = 'C134' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C134%' OR CedsConnectionName like '%FS134%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c137
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c137'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C137%' OR CedsConnectionName like '%FS137%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c137', 'C137: English Language Proficiency Test', 'C137', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c137' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C137: English Language Proficiency Test',	ReportShortName = 'C137' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C137%' OR CedsConnectionName like '%FS137%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c138
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c138'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C138%' OR CedsConnectionName like '%FS138%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c138', 'C138: Title III English Language Proficiency Test', 'C138', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c138' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C138: Title III English Language Proficiency Test',	ReportShortName = 'C138' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C138%' OR CedsConnectionName like '%FS138%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c139
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c139'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C139%' OR CedsConnectionName like '%FS139%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c139', 'C139: English Language Proficiency Results', 'C139', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c139' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C139: English Language Proficiency Results',	ReportShortName = 'C139' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C139%' OR CedsConnectionName like '%FS139%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c141
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c141'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C141%' OR CedsConnectionName like '%FS141%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c141', 'C141: EL Enrolled', 'C141', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c141' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C141: EL Enrolled',	ReportShortName = 'C141' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C141%' OR CedsConnectionName like '%FS141%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c142
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c142'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C142%' OR CedsConnectionName like '%FS142%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c142', 'C142: CTE Concentrators Academic Achievement', 'C142', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c142' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C142: CTE Concentrators Academic Achievement',	ReportShortName = 'C142' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C142%' OR CedsConnectionName like '%FS142%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c143
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c143'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C143%' OR CedsConnectionName like '%FS143%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c143', 'C143: Children with Disabilities (IDEA) Total Disciplinary Removals', 'C143', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c143' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C143: Children with Disabilities (IDEA) Total Disciplinary Removals',	ReportShortName = 'C143' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C143%' OR CedsConnectionName like '%FS143%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c144
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c144'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C144%' OR CedsConnectionName like '%FS144%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c144', 'C144: Educational Services During Expulsion', 'C144', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c144' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C144: Educational Services During Expulsion',	ReportShortName = 'C144' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C144%' OR CedsConnectionName like '%FS144%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c145
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c145'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C145%' OR CedsConnectionName like '%FS145%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c145', 'C145: MEP Services', 'C145', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c145' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C145: MEP Services',	ReportShortName = 'C145' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C145%' OR CedsConnectionName like '%FS145%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c150
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c150'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C150%' OR CedsConnectionName like '%FS150%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c150', 'C150: Adjusted-Cohort Graduation Rate', 'C150', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c150' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C150: Adjusted-Cohort Graduation Rate',	ReportShortName = 'C150' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C150%' OR CedsConnectionName like '%FS150%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c151
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c151'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C151%' OR CedsConnectionName like '%FS151%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c151', 'C151: Cohorts for Adjusted-Cohort Graduation Rate', 'C151', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c151' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C151: Cohorts for Adjusted-Cohort Graduation Rate',	ReportShortName = 'C151' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C151%' OR CedsConnectionName like '%FS151%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c154
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c154'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C154%' OR CedsConnectionName like '%FS154%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c154', 'C154: CTE Concentrators in Graduation Rate', 'C154', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c154' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C154: CTE Concentrators in Graduation Rate',	ReportShortName = 'C154' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C154%' OR CedsConnectionName like '%FS154%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c155
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c155'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C155%' OR CedsConnectionName like '%FS155%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c155', 'C155: CTE Participants in Programs for Non-Traditional', 'C155', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c155' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C155: CTE Participants in Programs for Non-Traditional',	ReportShortName = 'C155' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C155%' OR CedsConnectionName like '%FS155%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c156
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c156'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C156%' OR CedsConnectionName like '%FS156%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c156', 'C156: CTE Concentrators in Programs for Non-Traditional', 'C156', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c156' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C156: CTE Concentrators in Programs for Non-Traditional',	ReportShortName = 'C156' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C156%' OR CedsConnectionName like '%FS156%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c157
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c157'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C157%' OR CedsConnectionName like '%FS157%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c157', 'C157: CTE Concentrators Technical Skills', 'C157', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c157' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C157: CTE Concentrators Technical Skills',	ReportShortName = 'C157' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C157%' OR CedsConnectionName like '%FS157%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c158
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c158'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C158%' OR CedsConnectionName like '%FS158%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c158', 'C158: CTE Concentrators Placement', 'C158', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c158' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C158: CTE Concentrators Placement',	ReportShortName = 'C158' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C158%' OR CedsConnectionName like '%FS158%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c160
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c160'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C160%' OR CedsConnectionName like '%FS160%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c160', 'C160: High School Graduates Postsecondary Enrollment', 'C160', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c160' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C160: High School Graduates Postsecondary Enrollment',	ReportShortName = 'C160' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C160%' OR CedsConnectionName like '%FS160%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c163
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c163'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C163%' OR CedsConnectionName like '%FS163%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c163', 'C163: Discipline Data', 'C163', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c163' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C163: Discipline Data',	ReportShortName = 'C163' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C163%' OR CedsConnectionName like '%FS163%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c165
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c165'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C165%' OR CedsConnectionName like '%FS165%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c165', 'C165: Migratory Data', 'C165', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c165' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C165: Migratory Data',	ReportShortName = 'C165' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C165%' OR CedsConnectionName like '%FS165%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c169
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c169'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C169%' OR CedsConnectionName like '%FS169%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c169', 'C169: CTE Type of Placement', 'C169', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c169' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C169: CTE Type of Placement',	ReportShortName = 'C169' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C169%' OR CedsConnectionName like '%FS169%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c170
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c170'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C170%' OR CedsConnectionName like '%FS170%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c170', 'C170: LEA Subgrant Status', 'C170', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c170' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C170: LEA Subgrant Status',	ReportShortName = 'C170' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C170%' OR CedsConnectionName like '%FS170%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c175
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c175'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C175%' OR CedsConnectionName like '%FS175%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c175', 'C175: Academic Achievement in Mathematics', 'C175', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c175' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C175: Academic Achievement in Mathematics',	ReportShortName = 'C175' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C175%' OR CedsConnectionName like '%FS175%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c178
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c178'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C178%' OR CedsConnectionName like '%FS178%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c178', 'C178: Academic Achievement in Reading (Language Arts)', 'C178', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c178' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C178: Academic Achievement in Reading (Language Arts)',	ReportShortName = 'C178' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C178%' OR CedsConnectionName like '%FS178%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c179
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c179'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C179%' OR CedsConnectionName like '%FS179%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c179', 'C179: Academic Achievement in Science', 'C179', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c179' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C179: Academic Achievement in Science',	ReportShortName = 'C179' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C179%' OR CedsConnectionName like '%FS179%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c180
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c180'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C180%' OR CedsConnectionName like '%FS180%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c180', 'C180: N or D In Program Outcomes', 'C180', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c180' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C180: N or D In Program Outcomes',	ReportShortName = 'C180' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C180%' OR CedsConnectionName like '%FS180%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c181
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c181'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C181%' OR CedsConnectionName like '%FS181%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c181', 'C181: N or D Exited Programs Outcomes', 'C181', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c181' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C181: N or D Exited Programs Outcomes',	ReportShortName = 'C181' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C181%' OR CedsConnectionName like '%FS181%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c185
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c185'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C185%' OR CedsConnectionName like '%FS185%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c185', 'C185: Assessment Participation in Mathematics', 'C185', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c185' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C185: Assessment Participation in Mathematics',	ReportShortName = 'C185' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C185%' OR CedsConnectionName like '%FS185%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c188
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c188'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C188%' OR CedsConnectionName like '%FS188%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c188', 'C188: Assessment Participation in Reading/Language Arts', 'C188', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c188' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C188: Assessment Participation in Reading/Language Arts',	ReportShortName = 'C188' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C188%' OR CedsConnectionName like '%FS188%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c189
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c189'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C189%' OR CedsConnectionName like '%FS189%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c189', 'C189: Assessment Participation in Science', 'C189', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c189' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C189: Assessment Participation in Science',	ReportShortName = 'C189' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C189%' OR CedsConnectionName like '%FS189%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c190
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c190'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C190%' OR CedsConnectionName like '%FS190%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c190', 'C190: Charter Authorizer Directory', 'C190', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c190' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C190: Charter Authorizer Directory',	ReportShortName = 'C190' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C190%' OR CedsConnectionName like '%FS190%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1112)
 
 
		----------------------
		-- c193
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c193'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C193%' OR CedsConnectionName like '%FS193%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c193', 'C193: Title I Allocations', 'C193', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c193' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C193: Title I Allocations',	ReportShortName = 'C193' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C193%' OR CedsConnectionName like '%FS193%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c194
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c194'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C194%' OR CedsConnectionName like '%FS194%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c194', 'C194: Young Homeless Children Served (McKinney-Vento)', 'C194', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c194' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C194: Young Homeless Children Served (McKinney-Vento)',	ReportShortName = 'C194' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C194%' OR CedsConnectionName like '%FS194%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c195
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c195'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C195%' OR CedsConnectionName like '%FS195%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c195', 'C195: Chronic Absenteeism', 'C195', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c195' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C195: Chronic Absenteeism',	ReportShortName = 'C195' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C195%' OR CedsConnectionName like '%FS195%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c196
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c196'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C196%' OR CedsConnectionName like '%FS196%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c196', 'C196: Management Organization for Charter Schools Roster', 'C196', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c196' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C196: Management Organization for Charter Schools Roster',	ReportShortName = 'C196' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C196%' OR CedsConnectionName like '%FS196%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1182)
 
 
		----------------------
		-- c197
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c197'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C197%' OR CedsConnectionName like '%FS197%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c197', 'C197: Crosswalk of Charter Schools to Management Organizations', 'C197', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c197' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C197: Crosswalk of Charter Schools to Management Organizations',	ReportShortName = 'C197' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C197%' OR CedsConnectionName like '%FS197%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c198
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c198'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C198%' OR CedsConnectionName like '%FS198%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c198', 'C198: Charter Contracts', 'C198', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c198' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C198: Charter Contracts',	ReportShortName = 'C198' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C198%' OR CedsConnectionName like '%FS198%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c199
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c199'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C199%' OR CedsConnectionName like '%FS199%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c199', 'C199: Graduation Rate Indicator Status', 'C199', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c199' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C199: Graduation Rate Indicator Status',	ReportShortName = 'C199' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C199%' OR CedsConnectionName like '%FS199%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c200
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c200'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C200%' OR CedsConnectionName like '%FS200%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c200', 'C200: Academic Achievement Indicator Status', 'C200', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c200' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C200: Academic Achievement Indicator Status',	ReportShortName = 'C200' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C200%' OR CedsConnectionName like '%FS200%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c201
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c201'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C201%' OR CedsConnectionName like '%FS201%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c201', 'C201: Other Academic Indicator Status', 'C201', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c201' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C201: Other Academic Indicator Status',	ReportShortName = 'C201' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C201%' OR CedsConnectionName like '%FS201%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c202
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c202'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C202%' OR CedsConnectionName like '%FS202%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c202', 'C202: School Quality or Student Success Indicator Status', 'C202', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c202' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C202: School Quality or Student Success Indicator Status',	ReportShortName = 'C202' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C202%' OR CedsConnectionName like '%FS202%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c203
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c203'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C203%' OR CedsConnectionName like '%FS203%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c203', 'C203: Teachers', 'C203', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c203' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C203: Teachers',	ReportShortName = 'C203' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C203%' OR CedsConnectionName like '%FS203%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c204
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c204'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C204%' OR CedsConnectionName like '%FS204%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c204', 'C204: Title III English Learners', 'C204', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c204' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C204: Title III English Learners',	ReportShortName = 'C204' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C204%' OR CedsConnectionName like '%FS204%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 2)
 
 
		----------------------
		-- c205
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c205'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C205%' OR CedsConnectionName like '%FS205%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c205', 'C205: Progress Achieving English Language Proficiency Indicator Status ', 'C205', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c205' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C205: Progress Achieving English Language Proficiency Indicator Status ',	ReportShortName = 'C205' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C205%' OR CedsConnectionName like '%FS205%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c206
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c206'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C206%' OR CedsConnectionName like '%FS206%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c206', 'C206: School Support and Improvement', 'C206', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c206' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C206: School Support and Improvement',	ReportShortName = 'C206' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C206%' OR CedsConnectionName like '%FS206%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c207
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c207'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C207%' OR CedsConnectionName like '%FS207%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c207', 'C207: State Appropriations for Charter Schools', 'C207', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c207' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C207: State Appropriations for Charter Schools',	ReportShortName = 'C207' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C207%' OR CedsConnectionName like '%FS207%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c209
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c209'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C209%' OR CedsConnectionName like '%FS209%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c209', 'C209: CTE Enrollment File Specifications', 'C209', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c209' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C209: CTE Enrollment File Specifications',	ReportShortName = 'C209' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C209%' OR CedsConnectionName like '%FS209%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c212
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c212'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C212%' OR CedsConnectionName like '%FS212%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c212', 'C212: Comprehensive Support and Targeted Support Identification', 'C212', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c212' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C212: Comprehensive Support and Targeted Support Identification',	ReportShortName = 'C212' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C212%' OR CedsConnectionName like '%FS212%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c215
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c215'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C215%' OR CedsConnectionName like '%FS215%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c215', 'C215: CTE Concentrators Postsecondary Credits', 'C215', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c215' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C215: CTE Concentrators Postsecondary Credits',	ReportShortName = 'C215' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C215%' OR CedsConnectionName like '%FS215%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
	commit transaction
 
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off
