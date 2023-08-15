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
*	Updated on 06/05/2020
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
 
		insert into @recordIds (Id) values (266)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 266)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(266, 'TTLIIILIEPSTDSRV', 'Title III students served in English language instruction program table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TTLIIILIEPSTDSRV', [TableTypeName] = 'Title III students served in English language instruction program table' where EdFactsTableTypeId = 266
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
