/*
-- To generate metadata refresh script, run this on EDENDB on 192.168.71.30

set nocount on;

-- Use two most recent school years
--   Note, this means that older, retired file specs will not be updated if they change

declare @latestSchoolYear as int
select @latestSchoolYear = max(ReportingPeriodId) from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.reportingperiod where substring(ReportingPeriodAbbrv, 1, 1) = '2'

declare @lastSchoolYear as int
select @lastSchoolYear = max(ReportingPeriodId) from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.reportingperiod where substring(ReportingPeriodAbbrv, 1, 1) = '2' and ReportingPeriodId <> @latestSchoolYear


DECLARE @fileSpecs TABLE
(
	fileSpec nvarchar(10)
)


insert into @fileSpecs (fileSpec) values ('c029')
insert into @fileSpecs (fileSpec) values ('c039')
insert into @fileSpecs (fileSpec) values ('c190')
insert into @fileSpecs (fileSpec) values ('c196')
insert into @fileSpecs (fileSpec) values ('c197')
insert into @fileSpecs (fileSpec) values ('c198')
insert into @fileSpecs (fileSpec) values ('c207')
insert into @fileSpecs (fileSpec) values ('c206')
insert into @fileSpecs (fileSpec) values ('c212')
insert into @fileSpecs (fileSpec) values ('c130')
insert into @fileSpecs (fileSpec) values ('c002')
insert into @fileSpecs (fileSpec) values ('c089')
insert into @fileSpecs (fileSpec) values ('c033')
insert into @fileSpecs (fileSpec) values ('c052')
insert into @fileSpecs (fileSpec) values ('c129')
insert into @fileSpecs (fileSpec) values ('c059')

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
from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.FileSpecificationDocument fsd
inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.DataElement_x_FileSpecificationDocument defsd on fsd.FileSpecificationDocumentId = defsd.FileSpecificationDocumentId
inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.TableType_x_DataElement ttde on defsd.DataElementId = ttde.DataElementId
inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.TableTypeGroup ttg on ttde.TableTypeId = ttg.TableTypeId
and ttg.ReportingPeriodId = defsd.ReportingPeriodId
inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.ReportingPeriod rp on ttg.ReportingPeriodId = rp.ReportingPeriodId
inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.ReportingPeriod sy on rp.SchoolYearId = sy.ReportingPeriodId
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
	from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.FileSpecificationDocument fsd
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.DataElement_x_FileSpecificationDocument defsd on fsd.FileSpecificationDocumentId = defsd.FileSpecificationDocumentId
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.TableType_x_DataElement ttde on defsd.DataElementId = ttde.DataElementId
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.TableType tt on ttde.TableTypeID = tt.TableTypeID
	where fsd.FileSpecificationDocumentNumber = 'N' + replace(@GenerateReport, 'c', '')

	OPEN tabletype_cursor
	FETCH NEXT FROM tabletype_cursor INTO @TableTypeAbbrv

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		declare @EdFactsTableTypeId as int
		declare @TableTypeName as varchar(200)

		SELECT @EdFactsTableTypeId = TableTypeID, @TableTypeName = TableTypeName
		FROM [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.TableType
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
*	Updated on 01/24/2023
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
		-- c212
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c212' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (284)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 284)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(284, 'ATSIREASONS', 'Additional targeted support and improvement identification table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'ATSIREASONS', [TableTypeName] = 'Additional targeted support and improvement identification table' where EdFactsTableTypeId = 284
		END
 
		insert into @recordIds (Id) values (261)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 261)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(261, 'CSIREASONS', 'Comprehensive support and improvement identification table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'CSIREASONS', [TableTypeName] = 'Comprehensive support and improvement identification table' where EdFactsTableTypeId = 261
		END
 
		insert into @recordIds (Id) values (262)
 
		If Not exists (Select 1 from App.TableTypes where EdFactsTableTypeId = 262)
		BEGIN
			INSERT INTO App.TableTypes
			([EdFactsTableTypeId], [TableTypeAbbrv], [TableTypeName])
			VALUES
			(262, 'TSIREASONS', 'Targeted support and improvement identification table' )
 
			SET @TableTypeId = CAST(SCOPE_IDENTITY() AS INT)
 
			INSERT INTO App.GenerateReport_TableType
			([GenerateReportId], [TableTypeId])
			VALUES
			(@GenerateReportId, @TableTypeId)
		END
		ELSE
		BEGIN
			UPDATE App.TableTypes Set [TableTypeAbbrv] = 'TSIREASONS', [TableTypeName] = 'Targeted support and improvement identification table' where EdFactsTableTypeId = 262
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