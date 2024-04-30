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
*	Updated on 01/24/2023
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
		-- c212
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c212'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C212%' OR CedsConnectionName like '%FS212%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c212', 'C212: Identification School Support and Improvement', 'C212', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c212' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C212: Identification School Support and Improvement',	ReportShortName = 'C212' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C212%' OR CedsConnectionName like '%FS212%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
  

 		----------------------
		-- c218
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c218'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C218%' OR CedsConnectionName like '%FS218%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c218', 'C218: N or D in Program Outcomes - State Agency', 'C218', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c218' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C218: N or D in Program Outcomes - State Agency',	ReportShortName = 'C218' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C218%' OR CedsConnectionName like '%FS226%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
		

 		----------------------
		-- c219
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c219'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C219%' OR CedsConnectionName like '%FS219%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c219', 'C219: N or D in Program Outcomes - LEA', 'C219', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c219' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C219: N or D in Program Outcomes - LEA',	ReportShortName = 'C219' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C219%' OR CedsConnectionName like '%FS226%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
	

 		----------------------
		-- c220
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c220'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C220%' OR CedsConnectionName like '%FS220%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c220', 'C220: N or D Exit Outcomes - State Agency', 'C220', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c220' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C220: N or D Exit Outcomes - State Agency',	ReportShortName = 'C220' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C220%' OR CedsConnectionName like '%FS226%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)	

 		----------------------
		-- c221
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c221'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C221%' OR CedsConnectionName like '%FS221%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c221', 'C221: N or D Exit Outcomes - LEA', 'C221', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c221' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C221: N or D Exit Outcomes - LEA',	ReportShortName = 'C221' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C221%' OR CedsConnectionName like '%FS226%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)


 		----------------------
		-- c222
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c222'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C222%' OR CedsConnectionName like '%FS222%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c222', 'C222: Foster Care Enrolled', 'C222', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c222' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C222: Foster Care Enrolled',	ReportShortName = 'C222' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C222%' OR CedsConnectionName like '%FS226%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)



 		----------------------
		-- c223
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c223'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C223%' OR CedsConnectionName like '%FS223%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c223', 'C223: Title I School Status', 'C223', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c223' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C223: Title I School Status',	ReportShortName = 'C223' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C223%' OR CedsConnectionName like '%FS226%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)


 		----------------------
		-- c224
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c224'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C224%' OR CedsConnectionName like '%FS224%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c224', 'C224: N or D Assessment Proficiency - State Agency', 'C224', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c224' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C224: N or D Assessment Proficiency - State Agency',	ReportShortName = 'C224' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C224%' OR CedsConnectionName like '%FS226%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)

 
 		----------------------
		-- c225
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c225'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C225%' OR CedsConnectionName like '%FS225%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c225', 'C225: N or D Assessment Proficiency - LEA', 'C225', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c225' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C225: N or D Assessment Proficiency - LEA',	ReportShortName = 'C225' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C225%' OR CedsConnectionName like '%FS226%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)

 		----------------------
		-- c226
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c226'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C226%' OR CedsConnectionName like '%FS226%' order by CedsUseCaseId desc),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c226', 'C226: Economically Disadvantaged Students', 'C226', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c226' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C226: Economically Disadvantaged Students',	ReportShortName = 'C226' , IsActive ='1', 
			CedsConnectionId = 	 (select top 1 CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C226%' OR CedsConnectionName like '%FS226%' order by CedsUseCaseId desc) 
			WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
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