/*
-- To generate metadata refresh script, run this on EDENDB on 192.168.71.30

set nocount on;

-- Use two most recent school years
--   Using all school years were causing duplicate reports when file spec name changed over years
--   Note, this means that older, retired file specs will not be updated if they change
--   Note, this might still cause duplicate data when a file spec name changes

declare @latestSchoolYear as int
select @latestSchoolYear = max(ReportingPeriodId) from reportingperiod where substring(ReportingPeriodAbbrv, 1, 1) = '2'

declare @lastSchoolYear as int
select @lastSchoolYear = max(ReportingPeriodId) from reportingperiod where substring(ReportingPeriodAbbrv, 1, 1) = '2' and ReportingPeriodId <> @latestSchoolYear


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
declare @isActive as varchar(5)
declare @EduationLevelId as int

DECLARE cs_cursor CURSOR FOR 
Select distinct 'c' + substring(fsd.FileSpecificationDocumentNumber, 2, 3) as ReportCode,
'C' + substring(fsd.FileSpecificationDocumentNumber, 2, 3)  + ': ' + fsd.DisplayName as ReportName,
'C' + substring(fsd.FileSpecificationDocumentNumber, 2, 3) as ReportShortName,
1 AS IsActive
from FileSpecificationDocument fsd
inner join FileRecordLayout_x_FileSpecificationDocument frlfsd on fsd.FileSpecificationDocumentId = frlfsd.FileSpecificationDocumentId
inner join FileRecordLayout frl on frlfsd.FileRecordLayoutID = frl.FileRecordLayoutID
inner join ReportingPeriod rp on frl.ReportingPeriodId = rp.ReportingPeriodId
inner join ReportingPeriod sy on rp.SchoolYearId = sy.ReportingPeriodId
and sy.ReportingPeriodId in (@latestSchoolYear, @lastSchoolYear)
where fsd.FileSpecificationDocumentNumber like 'N%'
and 'c' + substring(fsd.FileSpecificationDocumentNumber, 2, 3) in (select fileSpec from @fileSpecs)
order by 'c' + substring(fsd.FileSpecificationDocumentNumber, 2, 3) 

OPEN cs_cursor
FETCH NEXT FROM cs_cursor INTO @ReportCode, @ReportName, @ReportShortName, @isActive

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
	print '			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like ''%' + @ReportShortName + '%''),'
	print '			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, ''' + @ReportCode + ''', ''' + @ReportName + ''', ''' + @ReportShortName + ''', ' + @isActive + ' )'

	print ''
	print '			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)'

	Print '		END'			

	PRINT '		ELSE'
	PRINT '		BEGIN'
	print '			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = ''' + @ReportCode + ''' and GenerateReportTypeId = @generateReportTypeId'
	print '			UPDATE app.GenerateReports SET ReportName ='''  + @ReportName + ''',	ReportShortName = ''' + @ReportShortName +''' , IsActive =''' + @isActive + ''' WHERE GenerateReportId = @GenerateReportId'
	PRINT '		END'

	PRINT ''
	print '		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId'
	print ''

	declare orgLevel_cursor CURSOR FOR 
	Select frl.EducationLevelId
	from FileSpecificationDocument fsd
	inner join FileRecordLayout_x_FileSpecificationDocument frlfsd on fsd.FileSpecificationDocumentId = frlfsd.FileSpecificationDocumentId
	inner join FileRecordLayout frl on frlfsd.FileRecordLayoutID = frl.FileRecordLayoutID
	inner join ReportingPeriod rp on frl.ReportingPeriodId = rp.ReportingPeriodId
	inner join ReportingPeriod sy on rp.SchoolYearId = sy.ReportingPeriodId
	and sy.ReportingPeriodId in (@latestSchoolYear, @lastSchoolYear)
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


	FETCH NEXT FROM cs_cursor INTO @ReportCode, @ReportName, @ReportShortName, @isActive
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C002%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c002', 'C002: Children with Disabilities (IDEA) School Age', 'C002', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c002' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C002: Children with Disabilities (IDEA) School Age',	ReportShortName = 'C002' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C005%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c005', 'C005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting', 'C005', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c005' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting',	ReportShortName = 'C005' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C006%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c006', 'C006: Children with Disabilities (IDEA) Suspensions/Expulsions', 'C006', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c006' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C006: Children with Disabilities (IDEA) Suspensions/Expulsions',	ReportShortName = 'C006' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C007%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c007', 'C007: Children with Disabilities (IDEA) Reasons for Unilateral Removal', 'C007', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c007' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C007: Children with Disabilities (IDEA) Reasons for Unilateral Removal',	ReportShortName = 'C007' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C009%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c009', 'C009: Children with Disabilities (IDEA) Exiting Special Education', 'C009', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c009' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C009: Children with Disabilities (IDEA) Exiting Special Education',	ReportShortName = 'C009' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C029%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c029', 'C029: Directory', 'C029', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c029' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C029: Directory',	ReportShortName = 'C029' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C033%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c033', 'C033: Free and Reduced Price Lunch', 'C033', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c033' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C033: Free and Reduced Price Lunch',	ReportShortName = 'C033' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C039%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c039', 'C039: Grades Offered', 'C039', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c039' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C039: Grades Offered',	ReportShortName = 'C039' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
		-- c045
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c045'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C045%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c045', 'C045: Immigrant', 'C045', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c045' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C045: Immigrant',	ReportShortName = 'C045' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C050%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c050', 'C050: Title III English Language Proficiency Results', 'C050', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c050' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C050: Title III English Language Proficiency Results',	ReportShortName = 'C050' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C052%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c052', 'C052: Membership', 'C052', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c052' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C052: Membership',	ReportShortName = 'C052' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C059%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c059', 'C059: Staff FTE', 'C059', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c059' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C059: Staff FTE',	ReportShortName = 'C059' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C067%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c067', 'C067: Title III Teachers', 'C067', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c067' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C067: Title III Teachers',	ReportShortName = 'C067' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C070%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c070', 'C070: Special Education Teachers (FTE)', 'C070', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c070' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C070: Special Education Teachers (FTE)',	ReportShortName = 'C070' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C082%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c082', 'C082: CTE Concentrators Exiting', 'C082', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c082' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C082: CTE Concentrators Exiting',	ReportShortName = 'C082' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C083%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c083', 'C083: CTE Concentrators Graduates', 'C083', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c083' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C083: CTE Concentrators Graduates',	ReportShortName = 'C083' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c088
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c088'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C088%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c088', 'C088: Children with Disabilities (IDEA) Disciplinary Removals', 'C088', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c088' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C088: Children with Disabilities (IDEA) Disciplinary Removals',	ReportShortName = 'C088' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C089%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c089', 'C089: Children with Disabilities (IDEA) Early Childhood', 'C089', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c089' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C089: Children with Disabilities (IDEA) Early Childhood',	ReportShortName = 'C089' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C099%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c099', 'C099: Special Education Related Services Personnel', 'C099', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c099' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C099: Special Education Related Services Personnel',	ReportShortName = 'C099' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C103%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c103', 'C103: Accountability', 'C103', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c103' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C103: Accountability',	ReportShortName = 'C103' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C112%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c112', 'C112: Special Education Paraprofessionals', 'C112', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c112' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C112: Special Education Paraprofessionals',	ReportShortName = 'C112' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
		-- c116
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c116'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C116%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c116', 'C116: Title III Students Served', 'C116', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c116' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C116: Title III Students Served',	ReportShortName = 'C116' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C118%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c118', 'C118: Homeless Students Enrolled', 'C118', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c118' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C118: Homeless Students Enrolled',	ReportShortName = 'C118' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
		-- c121
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c121'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C121%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c121', 'C121: Migratory Students Eligible - 12 Months', 'C121', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c121' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C121: Migratory Students Eligible - 12 Months',	ReportShortName = 'C121' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C122%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c122', 'C122: MEP Students Eligible and Served - Summer/Intersession', 'C122', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c122' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C122: MEP Students Eligible and Served - Summer/Intersession',	ReportShortName = 'C122' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c126
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c126'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C126%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c126', 'C126: Title III Former EL Students', 'C126', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c126' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C126: Title III Former EL Students',	ReportShortName = 'C126' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C129%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c129', 'C129: CCD School', 'C129', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c129' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C129: CCD School',	ReportShortName = 'C129' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C130%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c130', 'C130: ESEA Status', 'C130', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c130' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C130: ESEA Status',	ReportShortName = 'C130' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c132
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c132'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C132%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c132', 'C132: Section 1003 Funds', 'C132', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c132' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C132: Section 1003 Funds',	ReportShortName = 'C132' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 3)
 
 
		----------------------
		-- c137
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c137'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C137%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c137', 'C137: English Language Proficiency Test', 'C137', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c137' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C137: English Language Proficiency Test',	ReportShortName = 'C137' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C138%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c138', 'C138: Title III English Language Proficiency Test', 'C138', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c138' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C138: Title III English Language Proficiency Test',	ReportShortName = 'C138' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C139%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c139', 'C139: English Language Proficiency Results', 'C139', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c139' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C139: English Language Proficiency Results',	ReportShortName = 'C139' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C141%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c141', 'C141: EL Enrolled', 'C141', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c141' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C141: EL Enrolled',	ReportShortName = 'C141' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C142%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c142', 'C142: CTE Concentrators Academic Achievement', 'C142', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c142' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C142: CTE Concentrators Academic Achievement',	ReportShortName = 'C142' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C143%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c143', 'C143: Children with Disabilities (IDEA) Total Disciplinary Removals', 'C143', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c143' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C143: Children with Disabilities (IDEA) Total Disciplinary Removals',	ReportShortName = 'C143' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C144%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c144', 'C144: Educational Services During Expulsion', 'C144', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c144' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C144: Educational Services During Expulsion',	ReportShortName = 'C144' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
		-- c154
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c154'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C154%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c154', 'C154: CTE Concentrators in Graduation Rate', 'C154', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c154' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C154: CTE Concentrators in Graduation Rate',	ReportShortName = 'C154' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C155%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c155', 'C155: CTE Participants in Programs for Non-Traditional', 'C155', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c155' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C155: CTE Participants in Programs for Non-Traditional',	ReportShortName = 'C155' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C156%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c156', 'C156:  CTE Concentrators NonTraditional', 'C156', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c156' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C156:  CTE Concentrators NonTraditional',	ReportShortName = 'C156' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C157%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c157', 'C157: CTE Concentrators Technical Skills', 'C157', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c157' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C157: CTE Concentrators Technical Skills',	ReportShortName = 'C157' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C158%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c158', 'C158: CTE Concentrators Placement', 'C158', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c158' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C158: CTE Concentrators Placement',	ReportShortName = 'C158' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C160%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c160', 'C160: High School Graduates Postsecondary Enrollment', 'C160', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c160' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C160: High School Graduates Postsecondary Enrollment',	ReportShortName = 'C160' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C163%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c163', 'C163: Discipline Data', 'C163', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c163' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C163: Discipline Data',	ReportShortName = 'C163' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
		-- c169
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c169'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C169%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c169', 'C169: CTE Type of Placement', 'C169', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c169' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C169: CTE Type of Placement',	ReportShortName = 'C169' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C170%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c170', 'C170: LEA Subgrant Status', 'C170', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c170' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C170: LEA Subgrant Status',	ReportShortName = 'C170' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C175%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c175', 'C175: Academic Achievement in Mathematics', 'C175', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c175' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C175: Academic Achievement in Mathematics',	ReportShortName = 'C175' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C178%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c178', 'C178: Academic Achievement in Reading (Language Arts)', 'C178', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c178' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C178: Academic Achievement in Reading (Language Arts)',	ReportShortName = 'C178' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C179%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c179', 'C179: Academic Achievement in Science', 'C179', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c179' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C179: Academic Achievement in Science',	ReportShortName = 'C179' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
		-- c185
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c185'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C185%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c185', 'C185: Assessment Participation in Mathematics', 'C185', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c185' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C185: Assessment Participation in Mathematics',	ReportShortName = 'C185' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C188%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c188', 'C188: Assessment Participation in Reading/Language Arts', 'C188', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c188' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C188: Assessment Participation in Reading/Language Arts',	ReportShortName = 'C188' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C189%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c189', 'C189: Assessment Participation in Science', 'C189', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c189' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C189: Assessment Participation in Science',	ReportShortName = 'C189' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C190%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c190', 'C190: Charter Authorizer Directory', 'C190', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c190' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C190: Charter Authorizer Directory',	ReportShortName = 'C190' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1112)
 
 
		----------------------
		-- c192
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c192'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C192%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c192', 'C192: MEP Students Priority for Services', 'C192', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c192' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C192: MEP Students Priority for Services',	ReportShortName = 'C192' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
		END
 
		delete from App.GenerateReport_OrganizationLevels where GenerateReportId = @GenerateReportId
 
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId)
		values
		(@GenerateReportId, 1)
 
 
		----------------------
		-- c194
		----------------------
 
 
		IF NOT EXISTS (select 1 from app.GenerateReports where ReportCode ='c194'  and GenerateReportTypeId = @generateReportTypeId)
		BEGIN
			INSERT into App.GenerateReports
			(CedsConnectionId, GenerateReportTypeId,GenerateReportControlTypeId,ShowCategorySetControl, ReportCode, ReportName, ReportShortName, IsActive)
			values
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C194%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c194', 'C194: Young Homeless Children Served (McKinney-Vento)', 'C194', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c194' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C194: Young Homeless Children Served (McKinney-Vento)',	ReportShortName = 'C194' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C195%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c195', 'C195: Chronic Absenteeism', 'C195', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c195' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C195: Chronic Absenteeism',	ReportShortName = 'C195' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C196%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c196', 'C196: Management Organizations Directory', 'C196', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c196' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C196: Management Organizations Directory',	ReportShortName = 'C196' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C197%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c197', 'C197: Crosswalk of Charter Schools to Management Organizations', 'C197', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c197' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C197: Crosswalk of Charter Schools to Management Organizations',	ReportShortName = 'C197' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C198%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c198', 'C198: Charter Contracts', 'C198', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c198' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C198: Charter Contracts',	ReportShortName = 'C198' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C199%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c199', 'C199: Graduation Rate Indicator Status', 'C199', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c199' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C199: Graduation Rate Indicator Status',	ReportShortName = 'C199' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C200%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c200', 'C200: Academic Achievement Indicator Status', 'C200', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c200' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C200: Academic Achievement Indicator Status',	ReportShortName = 'C200' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C201%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c201', 'C201: Other Academic Indicator Status', 'C201', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c201' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C201: Other Academic Indicator Status',	ReportShortName = 'C201' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C202%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c202', 'C202: School Quality or Student Success Indicator Status', 'C202', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c202' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C202: School Quality or Student Success Indicator Status',	ReportShortName = 'C202' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C203%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c203', 'C203: Teachers', 'C203', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c203' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C203: Teachers',	ReportShortName = 'C203' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C204%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c204', 'C204: Title III English Learners', 'C204', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c204' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C204: Title III English Learners',	ReportShortName = 'C204' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C205%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c205', 'C205: Progress Achieving English Language Proficiency Indicator Status ', 'C205', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c205' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C205: Progress Achieving English Language Proficiency Indicator Status ',	ReportShortName = 'C205' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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
			( (select CedsConnectionId from App.CedsConnections where CedsConnectionName like '%C206%'),
			@generateReportTypeId, @GenerateReportControlTypeId, @ShowCategorySetControl, 'c206', 'C206: School Support and Improvement', 'C206', 1 )
 
			SET @GenerateReportId = CAST(SCOPE_IDENTITY() AS INT)
		END
		ELSE
		BEGIN
			select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c206' and GenerateReportTypeId = @generateReportTypeId
			UPDATE app.GenerateReports SET ReportName ='C206: School Support and Improvement',	ReportShortName = 'C206' , IsActive ='1' WHERE GenerateReportId = @GenerateReportId
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