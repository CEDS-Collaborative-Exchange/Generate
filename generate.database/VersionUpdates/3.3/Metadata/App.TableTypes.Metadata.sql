/*
-- To generate metadata refresh script, run this on EDENDB on 192.168.71.30

set nocount on;

-- Use two most recent school years
--   Note, this means that older, retired file specs will not be updated if they change

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

-- Release 3.0
insert into @fileSpecs (fileSpec) values ('c035')

print 'set nocount on'
print 'begin try'
print ''
print '	begin transaction'
print ''

print '	DECLARE @recordIds TABLE'
print '	('
print '	  Id int'
print '	)'


declare @GenerateReport as varchar(500)

print '		declare @TableTypeId as int'
print '		declare @GenerateReportId as varchar(500)'
print ''
print '		declare @edfactsSubmissionReportTypeId as int'
print '		select @edfactsSubmissionReportTypeId = GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode = ''edfactsreport'''
print ''

DECLARE report_cursor CURSOR FOR 
Select distinct 'c' + substring(fsd.FileSpecificationDocumentNumber, 2, 3) as GenerateReport
from FileSpecificationDocument fsd
inner join DataElement_x_FileSpecificationDocument defsd on fsd.FileSpecificationDocumentId = defsd.FileSpecificationDocumentId
inner join TableType_x_DataElement ttde on defsd.DataElementId = ttde.DataElementId
inner join TableTypeGroup ttg on ttde.TableTypeId = ttg.TableTypeId
and ttg.ReportingPeriodId = defsd.ReportingPeriodId
inner join ReportingPeriod rp on ttg.ReportingPeriodId = rp.ReportingPeriodId
inner join ReportingPeriod sy on rp.SchoolYearId = sy.ReportingPeriodId
and sy.ReportingPeriodId in (@latestSchoolYear, @lastSchoolYear)
where fsd.FileSpecificationDocumentNumber like 'N%'
and 'c' + substring(fsd.FileSpecificationDocumentNumber, 2, 3) in (select fileSpec from @fileSpecs)
order by 'c' + substring(fsd.FileSpecificationDocumentNumber, 2, 3) 

OPEN report_cursor
FETCH NEXT FROM report_cursor INTO @GenerateReport 

WHILE @@FETCH_STATUS = 0
BEGIN
	print ''
	print '		----------------------'
	print '		-- ' + @GenerateReport
	print '		----------------------'
	print ''

	print '		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = ''' + @GenerateReport + ''' and GenerateReportTypeId = @edfactsSubmissionReportTypeId'
	print ''

	declare @TableTypeAbbrv as varchar(20)
						
	DECLARE tabletype_cursor CURSOR FOR 
	Select distinct	tt.TableTypeAbbrv
	from FileSpecificationDocument fsd
	inner join DataElement_x_FileSpecificationDocument defsd on fsd.FileSpecificationDocumentId = defsd.FileSpecificationDocumentId
	inner join TableType_x_DataElement ttde on defsd.DataElementId = ttde.DataElementId
	inner join TableType tt on ttde.TableTypeID = tt.TableTypeID
	where fsd.FileSpecificationDocumentNumber = 'N' + replace(@GenerateReport, 'c', '')

	OPEN tabletype_cursor
	FETCH NEXT FROM tabletype_cursor INTO @TableTypeAbbrv

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		declare @EdFactsTableTypeId as int
		declare @TableTypeName as varchar(200)

		SELECT @EdFactsTableTypeId = TableTypeID, @TableTypeName = TableTypeName
		FROM TableType
		Where TableTypeAbbrv = @TableTypeAbbrv

		print '		insert into @recordIds (Id) values (' + convert(varchar(20), @EdFactsTableTypeId) + ')'
		print ''
		print '		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = ' + convert(varchar(20), @EdFactsTableTypeId) + ')'
		print '		BEGIN'
		print '			INSERT INTO App.TableTypes'
		print '			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])'
		print '			VALUES'
		print '			(' + convert(varchar(20), @EdFactsTableTypeId) + ', ''' + @TableTypeAbbrv + ''', ''' + @TableTypeName + ''' )'	
		print ''
		print '			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)'
		print ''
		print '			INSERT INTO App.GenerateReport_TableType'
		print '			([GenerateReportId], [TableTypeId])'
		print '			VALUES'
		print '			(@GenerateReportId, @TableTypeId)'								
		print '		END'
		print '		ELSE'
		print '		BEGIN'
		print '			UPDATE App.TableTypes Set [TableTypeAbbrv] = ''' + @TableTypeAbbrv + ''', [TableTypeName] = ''' + @TableTypeName + ''' where EdFactsTableTypeId = ' + convert(varchar(20), @EdFactsTableTypeId)
		print '		END'
		print ''
		FETCH NEXT FROM tabletype_cursor INTO @TableTypeAbbrv

	END
						
	CLOSE tabletype_cursor
	DEALLOCATE tabletype_cursor

	FETCH NEXT FROM report_cursor INTO @GenerateReport
END

CLOSE report_cursor
DEALLOCATE report_cursor

print '----------------------'
print '-- c206'
print '----------------------'
 
print 'declare @TableTypeName nvarchar(50) = ''School Support and Improvement'''
print 'declare @TableTypeAbbrv nvarchar(50) = ''SCHOOLSUPIMPV'''
print 'select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = ''c206'''
 
print '--insert into @recordIds (Id) values (259)'
 
print 'If Not exists (Select 1 from App.TableTypes where TableTypeAbbrv = @TableTypeAbbrv)'
print 'BEGIN'
print '	INSERT INTO App.TableTypes'
print '	([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])'
print '	VALUES'
print '	(0, @TableTypeAbbrv, @TableTypeName)'
 
print '	SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)'
 
print '	INSERT INTO App.GenerateReport_TableType'
print '	([GenerateReportId], [TableTypeId])'
print '	VALUES'
print '	(@GenerateReportId, @TableTypeId)'
print 'END'
print 'ELSE'
print 'BEGIN'
print '	UPDATE App.TableTypes Set [TableTypeAbbrv] = @TableTypeAbbrv, [TableTypeName] = @TableTypeName where TableTypeAbbrv = @TableTypeAbbrv'
print 'END'

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

/********************************************************************
*
*	Updated on 06/18/2019
*
*********************************************************************/
set nocount on
begin try
 
	begin transaction
 
	DECLARE @recordIds TABLE
	(
	  Id int
	)
		declare @TableTypeId as int
		declare @GenerateReportId as varchar(500)
 
		declare @edfactsSubmissionReportTypeId as int
		select @edfactsSubmissionReportTypeId = GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode = 'edfactsreport'
 
 
		----------------------
		-- c002
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c002' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (19)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 19)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(19, 'IDEADISAB', 'Children with Disabilities (IDEA) School Age Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'IDEADISAB', [TableTypeName] = 'Children with Disabilities (IDEA) School Age Tables' where EdFactsTableTypeId = 19
		END
 
 
		----------------------
		-- c005
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c005' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (20)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 20)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(20, 'CHDISDSPL', 'Children with Disabilities (IDEA) Removal Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CHDISDSPL', [TableTypeName] = 'Children with Disabilities (IDEA) Removal Table' where EdFactsTableTypeId = 20
		END
 
 
		----------------------
		-- c006
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c006' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (23)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 23)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(23, 'IDEASUSEXPL', 'Children with Disabilities (IDEA) Suspensions/Expulsions Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'IDEASUSEXPL', [TableTypeName] = 'Children with Disabilities (IDEA) Suspensions/Expulsions Table' where EdFactsTableTypeId = 23
		END
 
 
		----------------------
		-- c007
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c007' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (22)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 22)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(22, 'IDEAREMOV', 'Children with Disabilities (IDEA) Reasons for Unilateral Removal Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'IDEAREMOV', [TableTypeName] = 'Children with Disabilities (IDEA) Reasons for Unilateral Removal Table' where EdFactsTableTypeId = 22
		END
 
 
		----------------------
		-- c009
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c009' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (21)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 21)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(21, 'IDEAEXITSPED', 'Children with Disabilities (IDEA) Exiting Special Education Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'IDEAEXITSPED', [TableTypeName] = 'Children with Disabilities (IDEA) Exiting Special Education Tables' where EdFactsTableTypeId = 21
		END
 
 
		----------------------
		-- c033
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c033' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (250)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 250)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(250, 'DIRECTCERT', 'Direct Certification' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'DIRECTCERT', [TableTypeName] = 'Direct Certification' where EdFactsTableTypeId = 250
		END
 
		insert into @recordIds (Id) values (32)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 32)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(32, 'LUNCHFREERED', 'Free and Reduced Price Lunch Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'LUNCHFREERED', [TableTypeName] = 'Free and Reduced Price Lunch Table' where EdFactsTableTypeId = 32
		END
 
 
		----------------------
		-- c045
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c045' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (25)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 25)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(25, 'IMMIGRNT', 'Immigrant Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'IMMIGRNT', [TableTypeName] = 'Immigrant Table' where EdFactsTableTypeId = 25
		END
 
 
		----------------------
		-- c050
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c050' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (29)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 29)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(29, 'LEPENGPROFTST', 'Title III LEP English language proficiency results table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'LEPENGPROFTST', [TableTypeName] = 'Title III LEP English language proficiency results table' where EdFactsTableTypeId = 29
		END
 
 
		----------------------
		-- c052
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c052' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (33)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 33)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(33, 'MEMBER', 'Student Membership Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'MEMBER', [TableTypeName] = 'Student Membership Table' where EdFactsTableTypeId = 33
		END
 
 
		----------------------
		-- c059
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c059' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (131)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 131)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(131, 'CLASSTEACHFTE', 'Classroom Teachers (FTE)' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CLASSTEACHFTE', [TableTypeName] = 'Classroom Teachers (FTE)' where EdFactsTableTypeId = 131
		END
 
		insert into @recordIds (Id) values (10)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 10)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(10, 'FTESTAFF', 'Staff FTE Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'FTESTAFF', [TableTypeName] = 'Staff FTE Tables' where EdFactsTableTypeId = 10
		END
 
 
		----------------------
		-- c067
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c067' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (60)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 60)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(60, 'TEACHCERTLEP', 'Title III Teachers Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TEACHCERTLEP', [TableTypeName] = 'Title III Teachers Table' where EdFactsTableTypeId = 60
		END
 
		insert into @recordIds (Id) values (63)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 63)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(63, 'TEACHLEPNCERT', 'Teachers in LEP Programs Not Certified or Endorsed' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TEACHLEPNCERT', [TableTypeName] = 'Teachers in LEP Programs Not Certified or Endorsed' where EdFactsTableTypeId = 63
		END
 
 
		----------------------
		-- c070
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c070' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (65)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 65)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(65, 'TEACHSPED', 'Special Education Teachers (FTE) Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TEACHSPED', [TableTypeName] = 'Special Education Teachers (FTE) Table' where EdFactsTableTypeId = 65
		END
 
 
		----------------------
		-- c082
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c082' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (75)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 75)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(75, 'VOCED ', 'Vocational Concentrators Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'VOCED ', [TableTypeName] = 'Vocational Concentrators Tables' where EdFactsTableTypeId = 75
		END
 
 
		----------------------
		-- c083
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c083' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (76)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 76)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(76, 'VOCEDGRAD', 'Vocational Concentrator Graduates Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'VOCEDGRAD', [TableTypeName] = 'Vocational Concentrator Graduates Tables' where EdFactsTableTypeId = 76
		END
 
 
		----------------------
		-- c088
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c088' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (104)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 104)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(104, 'CHWDSBDSPACT', 'Children with Disabilities (IDEA) Disciplinary Removals Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CHWDSBDSPACT', [TableTypeName] = 'Children with Disabilities (IDEA) Disciplinary Removals Table' where EdFactsTableTypeId = 104
		END
 
 
		----------------------
		-- c089
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c089' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (110)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 110)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(110, 'CHWDSBERLCHD', 'Children with Disabilities (IDEA) Early Childhood Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CHWDSBERLCHD', [TableTypeName] = 'Children with Disabilities (IDEA) Early Childhood Tables' where EdFactsTableTypeId = 110
		END
 
 
		----------------------
		-- c099
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c099' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (108)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 108)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(108, 'SPEDUPERSNL', 'Special Education Personnel Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'SPEDUPERSNL', [TableTypeName] = 'Special Education Personnel Tables' where EdFactsTableTypeId = 108
		END
 
 
		----------------------
		-- c112
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c112' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (132)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 132)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(132, 'SPEDPARAPROF', 'Special Education Paraprofessionals Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'SPEDPARAPROF', [TableTypeName] = 'Special Education Paraprofessionals Tables' where EdFactsTableTypeId = 132
		END
 
 
		----------------------
		-- c116
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c116' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (143)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 143)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(143, 'TTLIIILEPSTDSRV', 'Title III LEP Students Served' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TTLIIILEPSTDSRV', [TableTypeName] = 'Title III LEP Students Served' where EdFactsTableTypeId = 143
		END
 
 
		----------------------
		-- c118
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c118' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (145)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 145)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(145, 'HOMLESENROLCNT', 'Homeless Students Enrolled - School Year Count' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'HOMLESENROLCNT', [TableTypeName] = 'Homeless Students Enrolled - School Year Count' where EdFactsTableTypeId = 145
		END
 
 
		----------------------
		-- c121
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c121' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (147)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 147)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(147, 'MEPSTUDELIG', 'MEP Students Eligible' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'MEPSTUDELIG', [TableTypeName] = 'MEP Students Eligible' where EdFactsTableTypeId = 147
		END
 
 
		----------------------
		-- c122
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c122' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (148)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 148)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(148, 'MEPSTUDELIGSERV', 'MEP Students Eligible and Served' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'MEPSTUDELIGSERV', [TableTypeName] = 'MEP Students Eligible and Served' where EdFactsTableTypeId = 148
		END
 
 
		----------------------
		-- c126
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c126' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (144)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 144)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(144, 'LEPFORSTU', 'Title III Former Students Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'LEPFORSTU', [TableTypeName] = 'Title III Former Students Tables' where EdFactsTableTypeId = 144
		END
 
 
		----------------------
		-- c132
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c132' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (8)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 8)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(8, 'ECOCIRCUM ', 'Students Economic Circumstance' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'ECOCIRCUM ', [TableTypeName] = 'Students Economic Circumstance' where EdFactsTableTypeId = 8
		END
 
		insert into @recordIds (Id) values (167)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 167)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(167, 'IMPFUNDALLOCA', 'School Improvement Funds Allocation - 1003(a)' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'IMPFUNDALLOCA', [TableTypeName] = 'School Improvement Funds Allocation - 1003(a)' where EdFactsTableTypeId = 167
		END
 
		insert into @recordIds (Id) values (173)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 173)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(173, 'IMPFUNDALLOCG', 'School Improvement Funds Allocation - 1003(g)' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'IMPFUNDALLOCG', [TableTypeName] = 'School Improvement Funds Allocation - 1003(g)' where EdFactsTableTypeId = 173
		END
 
		insert into @recordIds (Id) values (35)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 35)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(35, 'MIGRNTELIG', 'Migrant Students Eligible Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'MIGRNTELIG', [TableTypeName] = 'Migrant Students Eligible Tables' where EdFactsTableTypeId = 35
		END
 
		insert into @recordIds (Id) values (86)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 86)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(86, 'POVERTYPER', 'Poverty Percent' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'POVERTYPER', [TableTypeName] = 'Poverty Percent' where EdFactsTableTypeId = 86
		END
 
 
		----------------------
		-- c137
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c137' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (160)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 160)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(160, 'LEPENGLANGTST', 'LEP English Language' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'LEPENGLANGTST', [TableTypeName] = 'LEP English Language' where EdFactsTableTypeId = 160
		END
 
 
		----------------------
		-- c138
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c138' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (161)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 161)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(161, 'TITLEIIILEPTST', 'Title III LEP English Language Testing File Specification' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TITLEIIILEPTST', [TableTypeName] = 'Title III LEP English Language Testing File Specification' where EdFactsTableTypeId = 161
		END
 
 
		----------------------
		-- c139
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c139' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (168)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 168)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(168, 'LEPSTUENGPROF', 'LEP - English Language Proficiency Results Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'LEPSTUENGPROF', [TableTypeName] = 'LEP - English Language Proficiency Results Table' where EdFactsTableTypeId = 168
		END
 
 
		----------------------
		-- c141
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c141' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (163)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 163)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(163, 'LEPENROLLED', 'LEP Enrolled File Specifications' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'LEPENROLLED', [TableTypeName] = 'LEP Enrolled File Specifications' where EdFactsTableTypeId = 163
		END
 
 
		----------------------
		-- c142
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c142' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (164)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 164)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(164, 'CTECONACAD', 'Concentrators Academic Attainment Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CTECONACAD', [TableTypeName] = 'Concentrators Academic Attainment Table' where EdFactsTableTypeId = 164
		END
 
 
		----------------------
		-- c143
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c143' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (165)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 165)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(165, 'CWDTOTDISREM', 'Children with Disabilities (IDEA) Total Disciplinary Removals Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CWDTOTDISREM', [TableTypeName] = 'Children with Disabilities (IDEA) Total Disciplinary Removals Table' where EdFactsTableTypeId = 165
		END
 
 
		----------------------
		-- c144
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c144' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (156)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 156)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(156, 'EDUSERVICES', 'Educational Services Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'EDUSERVICES', [TableTypeName] = 'Educational Services Table' where EdFactsTableTypeId = 156
		END
 
 
		----------------------
		-- c154
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c154' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (180)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 180)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(180, 'CTECONGR', 'CTE Concentrators in Graduation Rate Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CTECONGR', [TableTypeName] = 'CTE Concentrators in Graduation Rate Table' where EdFactsTableTypeId = 180
		END
 
 
		----------------------
		-- c155
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c155' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (181)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 181)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(181, 'CTENTPAT', 'CTE Participants in Programs for Non-Traditional Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CTENTPAT', [TableTypeName] = 'CTE Participants in Programs for Non-Traditional Table' where EdFactsTableTypeId = 181
		END
 
 
		----------------------
		-- c156
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c156' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (182)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 182)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(182, 'CTECONPRGNT', 'CTE Concentrators in Programs for Non-Traditional Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CTECONPRGNT', [TableTypeName] = 'CTE Concentrators in Programs for Non-Traditional Table' where EdFactsTableTypeId = 182
		END
 
 
		----------------------
		-- c157
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c157' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (183)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 183)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(183, 'CTECONTS', 'CTE Concentrators Technical Skills Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CTECONTS', [TableTypeName] = 'CTE Concentrators Technical Skills Table' where EdFactsTableTypeId = 183
		END
 
 
		----------------------
		-- c158
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c158' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (203)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 203)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(203, 'CTECONP', 'CTE Concentrators Placement Table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CTECONP', [TableTypeName] = 'CTE Concentrators Placement Table' where EdFactsTableTypeId = 203
		END
 
 
		----------------------
		-- c160
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c160' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (186)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 186)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(186, 'HSGRDPSENROLL', 'HS graduates postsecondary enrollment table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'HSGRDPSENROLL', [TableTypeName] = 'HS graduates postsecondary enrollment table' where EdFactsTableTypeId = 186
		END
 
 
		----------------------
		-- c169
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c169' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (202)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 202)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(202, 'CTEPLACETYPE', 'CTE concentrators placement type table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CTEPLACETYPE', [TableTypeName] = 'CTE concentrators placement type table' where EdFactsTableTypeId = 202
		END
 
 
		----------------------
		-- c175
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c175' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (50)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 50)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(50, 'STUDPERFM', 'Student Performance Table - Math' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFM', [TableTypeName] = 'Student Performance Table - Math' where EdFactsTableTypeId = 50
		END
 
 
		----------------------
		-- c178
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c178' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (49)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 49)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(49, 'STUDPERFLANG', 'Student Performance Table - Language Arts' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFLANG', [TableTypeName] = 'Student Performance Table - Language Arts' where EdFactsTableTypeId = 49
		END
 
		insert into @recordIds (Id) values (51)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 51)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(51, 'STUDPERFREAD', 'Student Performance Table - Reading ' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFREAD', [TableTypeName] = 'Student Performance Table - Reading ' where EdFactsTableTypeId = 51
		END
 
		insert into @recordIds (Id) values (52)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 52)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(52, 'STUDPERFRLA', 'Student Performance Table - Reading/Language Arts' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFRLA', [TableTypeName] = 'Student Performance Table - Reading/Language Arts' where EdFactsTableTypeId = 52
		END
 
 
		----------------------
		-- c179
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c179' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (53)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 53)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(53, 'STUDPERFS', 'Student Performance Table - Science' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFS', [TableTypeName] = 'Student Performance Table - Science' where EdFactsTableTypeId = 53
		END
 
 
		----------------------
		-- c185
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c185' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (54)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 54)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(54, 'STUDPERFTEST', 'Students Tested Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFTEST', [TableTypeName] = 'Students Tested Tables' where EdFactsTableTypeId = 54
		END
 
		insert into @recordIds (Id) values (201)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 201)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(201, 'STUPARTMATH', 'Assessment participation in mathematics table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUPARTMATH', [TableTypeName] = 'Assessment participation in mathematics table' where EdFactsTableTypeId = 201
		END
 
 
		----------------------
		-- c188
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c188' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (54)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 54)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(54, 'STUDPERFTEST', 'Students Tested Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFTEST', [TableTypeName] = 'Students Tested Tables' where EdFactsTableTypeId = 54
		END
 
		insert into @recordIds (Id) values (200)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 200)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(200, 'STUPARTRLA', 'Assessment participation in reading/language arts table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUPARTRLA', [TableTypeName] = 'Assessment participation in reading/language arts table' where EdFactsTableTypeId = 200
		END
 
 
		----------------------
		-- c189
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c189' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (54)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 54)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(54, 'STUDPERFTEST', 'Students Tested Tables' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUDPERFTEST', [TableTypeName] = 'Students Tested Tables' where EdFactsTableTypeId = 54
		END
 
		insert into @recordIds (Id) values (246)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 246)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(246, 'STUPARTSCI', 'STUPARTSCI' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'STUPARTSCI', [TableTypeName] = 'STUPARTSCI' where EdFactsTableTypeId = 246
		END
 
 
		----------------------
		-- c194
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c194' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (251)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 251)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(251, 'HOMEMVENTOPKS', 'Young homeless children served (McKinney-Vento) table ' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'HOMEMVENTOPKS', [TableTypeName] = 'Young homeless children served (McKinney-Vento) table ' where EdFactsTableTypeId = 251
		END
 
 
		----------------------
		-- c195
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c195' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (252)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 252)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(252, 'CHRONABSENT', 'Chronic absenteeism table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CHRONABSENT', [TableTypeName] = 'Chronic absenteeism table' where EdFactsTableTypeId = 252
		END
 
 
		----------------------
		-- c199
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c199' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (253)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 253)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(253, 'GRADRATESTATUS', 'Graduation rate indicator status table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'GRADRATESTATUS', [TableTypeName] = 'Graduation rate indicator status table' where EdFactsTableTypeId = 253
		END
 
 
		----------------------
		-- c200
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c200' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (258)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 258)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(258, 'ACADACHSTATUS', 'Academic achievement indicator status table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'ACADACHSTATUS', [TableTypeName] = 'Academic achievement indicator status table' where EdFactsTableTypeId = 258
		END
 
 
		----------------------
		-- c201
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c201' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (254)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 254)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(254, 'OTHACADSTATUS', 'Other academic indicator status table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'OTHACADSTATUS', [TableTypeName] = 'Other academic indicator status table' where EdFactsTableTypeId = 254
		END
 
 
		----------------------
		-- c202
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c202' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (255)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 255)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(255, 'SCHQUALSTAT', 'School quality or student success indicator status table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'SCHQUALSTAT', [TableTypeName] = 'School quality or student success indicator status table' where EdFactsTableTypeId = 255
		END
 
 
		----------------------
		-- c203
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c203' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (260)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 260)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(260, 'TEACHER', 'Teachers table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TEACHER', [TableTypeName] = 'Teachers table' where EdFactsTableTypeId = 260
		END
 
 
		----------------------
		-- c204
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c204' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (257)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 257)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(257, 'T3ELEXIT', 'Title III English learners exited' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'T3ELEXIT', [TableTypeName] = 'Title III English learners exited' where EdFactsTableTypeId = 257
		END
 
		insert into @recordIds (Id) values (256)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 256)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(256, 'T3ELNOTPROF', 'Title III English learners not proficient within five years' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'T3ELNOTPROF', [TableTypeName] = 'Title III English learners not proficient within five years' where EdFactsTableTypeId = 256
		END
 
 
		----------------------
		-- c205
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c205' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (259)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 259)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(259, 'PROGENGLANSTATUS', 'Progress achieving English language proficiency indicator status' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'PROGENGLANSTATUS', [TableTypeName] = 'Progress achieving English language proficiency indicator status' where EdFactsTableTypeId = 259
		END
 
----------------------
-- c206
----------------------
declare @TableTypeName nvarchar(50) = 'School Support and Improvement'
declare @TableTypeAbbrv nvarchar(50) = 'SCHOOLSUPIMPV'
select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c206'
--insert into @recordIds (Id) values (259)
If Not exists (Select 1 from App.TableTypes where TableTypeAbbrv = @TableTypeAbbrv)
BEGIN
	INSERT INTO App.TableTypes
	([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
	VALUES
	(0, @TableTypeAbbrv, @TableTypeName)
	SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
	INSERT INTO App.GenerateReport_TableType
	([GenerateReportId], [TableTypeId])
	VALUES
	(@GenerateReportId, @TableTypeId)
END
ELSE
BEGIN
	UPDATE App.TableTypes Set [TableTypeAbbrv] = @TableTypeAbbrv, [TableTypeName] = @TableTypeName where TableTypeAbbrv = @TableTypeAbbrv
END
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
