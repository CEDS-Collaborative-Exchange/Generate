/*

set nocount on;

-- Use two most recent school years
--   Note, this means that older, retired file specs will not be updated if they change

declare @generateMaxSchoolYear as varchar(10)
set @generateMaxSchoolYear = '2022-2023'

declare @latestSchoolYear as int
select @latestSchoolYear = max(ReportingPeriodId) from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.reportingperiod where ReportingPeriodValue = @generateMaxSchoolYear


declare @lastSchoolYear as int
select @lastSchoolYear = max(ReportingPeriodId) from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.reportingperiod where substring(ReportingPeriodAbbrv, 1, 1) = '2' 
and ReportingPeriodId < @latestSchoolYear


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


declare @GenerateReport as varchar(500)
declare @FileTypeDescription as varchar(50)
declare @OrganizationLevelId int
declare @FileRecordLayoutId int
declare @SubmissionYear as varchar(20)

print 'set nocount on'
print 'begin try'
print ''
print '	begin transaction'
print ''

print '		declare @GenerateReportId as Int'	
print '		declare @fileSubmissionId as Int'
print '		declare @fileColumnId as Int'		
print '		declare @headerId INT, @columnId INT'	
	
	
print ''
				
print '		declare @seaId as int, @leaId as int, @schId as int'
print '		select @seaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = ''sea'''
print '		select @leaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = ''lea'''
print '		select @schId = OrganizationLevelId from app.OrganizationLevels where LevelCode = ''sch'''
print ''
print '		declare @edfactsSubmissionReportTypeId as int'
print '		select @edfactsSubmissionReportTypeId = GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode = ''edfactsreport'''

	            
DECLARE report_cursor CURSOR FOR 
select fileSpec from @fileSpecs 
order by fileSpec

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

	BEGIN

	if (@GenerateReport = 'c035')
	begin
		set @latestSchoolYear = @latestSchoolYear - 6
		set @lastSchoolYear = @lastSchoolYear - 6
	end

	DECLARE filesubmission_cursor CURSOR FOR 
	Select frl.FileRecordLayoutID,frl.[FileTypeDescription], frl.[EducationLevelID], sy.ReportingPeriodAbbrv
	from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.FileSpecificationDocument fsd
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.[FileRecordLayout_x_FileSpecificationDocument] frlfsd on fsd.[FileSpecificationDocumentID] = frlfsd.FileSpecificationDocumentID
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.[FileRecordLayout] frl on frl.[FileRecordLayoutID] = frlfsd.[FileRecordLayoutID]
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.ReportingPeriod rp on frl.ReportingPeriodId = rp.ReportingPeriodId
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.ReportingPeriod sy on rp.SchoolYearId = sy.ReportingPeriodId
	and sy.ReportingPeriodId in (@latestSchoolYear, @lastSchoolYear)
	where fsd.FileSpecificationDocumentNumber like 'N%'
	and fsd.FileSpecificationDocumentNumber = 'N' + replace(@GenerateReport, 'c', '')
	order by sy.ReportingPeriodAbbrv, fsd.FileSpecificationDocumentNumber

	OPEN filesubmission_cursor
	FETCH NEXT FROM filesubmission_cursor INTO @FileRecordLayoutId, @FileTypeDescription,@OrganizationLevelId,@SubmissionYear  

	WHILE @@FETCH_STATUS = 0
	BEGIN			
							
		print '		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = '''+  @FileTypeDescription +''' and GenerateReportId = @GenerateReportId and OrganizationLevelId = ' + convert(varchar(20), +  @OrganizationLevelId) +' and SubmissionYear = ''' + left(convert(varchar(20), @SubmissionYear),4) + '-' + right(convert(varchar(20), @SubmissionYear),2)+''')'
		print '		BEGIN'

		print '			INSERT INTO App.FileSubmissions'
		print '			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])'
		print '			values'
		print '			(''' + @FileTypeDescription + ''', @GenerateReportId, ' + convert(varchar(20), @OrganizationLevelId) + ', ''' + left(convert(varchar(20), @SubmissionYear),4) + '-' + right(convert(varchar(20), @SubmissionYear),2) + ''')'			
		print ''
		print '			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)'
		print ''
		print '		END'
		print '		ELSE'
		print '		BEGIN'
		print '			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = '''+  @FileTypeDescription +''' and GenerateReportId = @GenerateReportId and OrganizationLevelId = ' + convert(varchar(20), +  @OrganizationLevelId) +' and SubmissionYear = ''' + left(convert(varchar(20), @SubmissionYear),4) + '-' + right(convert(varchar(20), @SubmissionYear),2)+''''
		print '		END'

		print ''
		print '		-- FileSubmission_FileColumns, FileColumns'
		print ''

		print '		delete from App.FileColumns where FileColumnId in ('
		print '			select FileColumnId from App.FileSubmission_FileColumns'
		print '			where FileSubmissionId = @fileSubmissionId)'
		print ''					
		print '		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId'
		print ''

		declare @FrleID as Integer
		declare @ColumnName as varchar(50)

		DECLARE element_cursor CURSOR FOR 
		SELECT MAX([FileRecordLayoutElementID]),ColumnName
		FROM [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.FileRecordLayoutElement
		Where FileRecordLayoutID = @FileRecordLayoutId
		group by ColumnName
		order by ColumnName

					
		OPEN element_cursor
		FETCH NEXT FROM element_cursor INTO @FrleID, @ColumnName

		WHILE @@FETCH_STATUS = 0
		BEGIN

			declare @XMLElementName as varchar(200)
			declare @DisplayName as varchar(100)
			declare @ColumnLength as Integer
			declare @DataType as varchar(50)
			declare @StartPosition as Integer
			declare @EndPosition as Integer
			declare @optional as varchar(10)
			declare @SeqNumber as Integer

			SELECT @XMLElementName = [XMLElementName], @DisplayName = [DisplayName], @ColumnLength = [ColumnLength],
					@DataType = CASE WHEN [DataFormatTypeID] = 152 THEN 'String'
						WHEN [DataFormatTypeID] = 153 THEN 'Number'
						WHEN [DataFormatTypeID] = 154 THEN 'Control Character'
						WHEN [DataFormatTypeID] = 854 THEN 'Decimal1'
						WHEN [DataFormatTypeID] = 855 THEN 'Decimal2'
						WHEN [DataFormatTypeID] = 856 THEN 'Decimal3'
						WHEN [DataFormatTypeID] = 857 THEN 'Decimal4'
						ELSE NULL
				END,
			@StartPosition = StartPosition, @EndPosition= EndPosition, @SeqNumber = SeqNumber, @optional = CASE WHEN Optionality = 'M' then 'false' ELSE 'true'	END 
			FROM [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.[FileRecordLayoutElement] 
			Where [FileRecordLayoutElementID] = @FrleID

			print '		INSERT INTO App.FileColumns'
			print '		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])'
			print '		VALUES'
			print '		('+ convert(varchar(20), @ColumnLength) + ', ''' + @ColumnName + ''',''' + @DataType + ''', ''' + ISNULL(@DisplayName,'') + ''', ''' + ISNULL(@XMLElementName,'') + ''')'
			print ''						
			print '		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)'
			print ''		

			print '		INSERT INTO App.FileSubmission_FileColumns'
			print '		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])'
			print '		VALUES'
			print '		(@fileSubmissionId, @fileColumnId, ' + convert(varchar(20), @EndPosition) + ', ''' +  @optional + ''', '+ convert(varchar(20), @SeqNumber) + ', ' + convert(varchar(20), @StartPosition) + ')'
																			
			print ''
			FETCH NEXT FROM element_cursor INTO @FrleID, @ColumnName
		END

		CLOSE element_cursor
		DEALLOCATE element_cursor

		print ''

		FETCH NEXT FROM filesubmission_cursor INTO @FileRecordLayoutId, @FileTypeDescription,@OrganizationLevelId,@SubmissionYear  
		END

		CLOSE filesubmission_cursor
		DEALLOCATE filesubmission_cursor

							

	END

	select @latestSchoolYear = max(ReportingPeriodId) from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.reportingperiod where ReportingPeriodValue = @generateMaxSchoolYear
	select @lastSchoolYear = max(ReportingPeriodId) from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.reportingperiod where substring(ReportingPeriodAbbrv, 1, 1) = '2' 
	and ReportingPeriodId < @latestSchoolYear
					

FETCH NEXT FROM report_cursor INTO @GenerateReport
END

CLOSE report_cursor
DEALLOCATE report_cursor		

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
 
		declare @GenerateReportId as Int
		declare @fileSubmissionId as Int
		declare @fileColumnId as Int
		declare @headerId INT, @columnId INT
 
		declare @seaId as int, @leaId as int, @schId as int
		select @seaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'sea'
		select @leaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'lea'
		select @schId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'sch'
 
		declare @edfactsSubmissionReportTypeId as int
		select @edfactsSubmissionReportTypeId = GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode = 'edfactsreport'
 
		----------------------
		-- c002
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c002' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SEA CHILDREN WITH DISABILITIES' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SEA CHILDREN WITH DISABILITIES', @GenerateReportId, 1, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SEA CHILDREN WITH DISABILITIES' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'AgeID','String', 'Age (Early Childhood)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 263, 'true', 19, 249)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Amount', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 504, 'false', 24, 495)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 505, 'false', 25, 505)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'DisabilityCategoryID','String', 'Disability Category (IDEA)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 218, 'true', 16, 204)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'EdEnvironmentID','String', 'Educational Environment (IDEA) SA', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 278, 'true', 20, 264)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 494, 'true', 23, 295)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler10','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 248, 'false', 18, 234)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler11','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 233, 'false', 17, 219)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'false', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler5','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 143, 'false', 11, 129)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler6','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 158, 'false', 12, 144)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler7','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 173, 'false', 13, 159)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler8','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 188, 'false', 14, 174)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler9','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 203, 'false', 15, 189)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'LEPStatusID','String', 'English Learner Status (Both)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 293, 'true', 21, 279)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 294, 'false', 22, 294)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA CHILDREN WITH DISABILITIES' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('LEA CHILDREN WITH DISABILITIES', @GenerateReportId, 2, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'LEA CHILDREN WITH DISABILITIES' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'AgeID','String', 'Age (Early Childhood)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 263, 'true', 19, 249)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Amount', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 504, 'false', 24, 495)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 505, 'false', 25, 505)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'DisabilityCategoryID','String', 'Disability Category (IDEA)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 218, 'true', 16, 204)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'EdEnvironmentID','String', 'Educational Environment (IDEA) SA', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 278, 'true', 20, 264)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 494, 'true', 23, 295)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler10','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 248, 'false', 18, 234)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'false', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 143, 'false', 11, 129)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler5','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 158, 'false', 12, 144)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler6','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 173, 'false', 13, 159)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler7','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 188, 'false', 14, 174)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler8','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 203, 'false', 15, 189)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler9','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 233, 'false', 17, 219)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'LEPStatusID','String', 'English Learner Status (Both)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 293, 'true', 21, 279)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 294, 'false', 22, 294)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL CHILDREN WITH DISABILITIES' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL CHILDREN WITH DISABILITIES', @GenerateReportId, 3, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL CHILDREN WITH DISABILITIES' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'AgeID','String', 'Age (Early Childhood)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 263, 'true', 19, 249)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Amount', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 504, 'false', 24, 495)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 505, 'false', 25, 505)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'DisabilityCategoryID','String', 'Disability Category (IDEA)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 218, 'true', 16, 204)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'EdEnvironmentID','String', 'Educational Environment (IDEA) SA', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 278, 'true', 20, 264)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 494, 'true', 23, 295)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'false', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 143, 'false', 11, 129)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 158, 'false', 12, 144)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler5','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 173, 'false', 13, 159)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler6','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 188, 'false', 14, 174)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler7','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 203, 'false', 15, 189)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler8','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 233, 'false', 17, 219)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler9','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 248, 'false', 18, 234)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'LEPStatusID','String', 'English Learner Status (Both)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 293, 'true', 21, 279)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School ID Number', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 294, 'false', 22, 294)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SEA CHILDREN WITH DISABILITIES' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SEA CHILDREN WITH DISABILITIES', @GenerateReportId, 1, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SEA CHILDREN WITH DISABILITIES' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'AgeID','String', 'Age (School Age)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 263, 'true', 19, 249)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Amount', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 504, 'false', 24, 495)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 505, 'false', 25, 505)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'DisabilityCategoryID','String', 'Disability Category (IDEA)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 218, 'true', 16, 204)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'EdEnvironmentID','String', 'Educational Environment (IDEA) SA', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 278, 'true', 20, 264)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 494, 'true', 23, 295)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler10','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 248, 'false', 18, 234)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler11','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 233, 'false', 17, 219)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'false', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler5','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 143, 'false', 11, 129)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler6','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 158, 'false', 12, 144)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler7','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 173, 'false', 13, 159)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler8','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 188, 'false', 14, 174)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler9','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 203, 'false', 15, 189)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'LEPStatusID','String', 'English Learner Status (Both)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 293, 'true', 21, 279)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 294, 'false', 22, 294)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA CHILDREN WITH DISABILITIES' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('LEA CHILDREN WITH DISABILITIES', @GenerateReportId, 2, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'LEA CHILDREN WITH DISABILITIES' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'AgeID','String', 'Age (School Age)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 263, 'true', 19, 249)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Amount', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 504, 'false', 24, 495)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 505, 'false', 25, 505)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'DisabilityCategoryID','String', 'Disability Category (IDEA)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 218, 'true', 16, 204)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'EdEnvironmentID','String', 'Educational Environment (IDEA) SA', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 278, 'true', 20, 264)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 494, 'true', 23, 295)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler10','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 248, 'false', 18, 234)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'false', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 143, 'false', 11, 129)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler5','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 158, 'false', 12, 144)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler6','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 173, 'false', 13, 159)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler7','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 188, 'false', 14, 174)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler8','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 203, 'false', 15, 189)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler9','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 233, 'false', 17, 219)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'LEPStatusID','String', 'English Learner Status (Both)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 293, 'true', 21, 279)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 294, 'false', 22, 294)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL CHILDREN WITH DISABILITIES' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL CHILDREN WITH DISABILITIES', @GenerateReportId, 3, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL CHILDREN WITH DISABILITIES' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'AgeID','String', 'Age (School Age)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 263, 'true', 19, 249)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Amount', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 504, 'false', 24, 495)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 505, 'false', 25, 505)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'DisabilityCategoryID','String', 'Disability Category (IDEA)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 218, 'true', 16, 204)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'EdEnvironmentID','String', 'Educational Environment (IDEA) SA', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 278, 'true', 20, 264)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 494, 'true', 23, 295)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'false', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 143, 'false', 11, 129)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 158, 'false', 12, 144)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler5','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 173, 'false', 13, 159)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler6','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 188, 'false', 14, 174)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler7','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 203, 'false', 15, 189)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler8','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 233, 'false', 17, 219)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler9','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 248, 'false', 18, 234)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'LEPStatusID','String', 'English Learner Status (Both)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 293, 'true', 21, 279)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School ID Number', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 294, 'false', 22, 294)
 
 
 
		----------------------
		-- c029
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c029' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SEA DIRECTORY INFO' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SEA DIRECTORY INFO', @GenerateReportId, 1, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SEA DIRECTORY INFO' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 1060, 'false', 31, 1060)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(80, 'CSSOEMailAddress','String', '', 'EMAIL')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 859, 'false', 29, 780)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'CSSOFirstName','String', '', 'FIRSTNAME')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 689, 'false', 25, 660)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'CSSOLastName','String', '', 'LASTNAME')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 719, 'false', 26, 690)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'CSSOPhoneNumber','String', '', 'PHONENUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 779, 'false', 28, 770)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(50, 'CSSOTitle','String', '', 'TITLE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 769, 'false', 27, 720)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', '', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 1059, 'true', 30, 860)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(7, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 35, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 55, 'false', 6, 36)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(12, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 67, 'false', 7, 56)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress1','String', 'Location Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 498, 'true', 18, 439)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress2','String', 'Location Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 558, 'true', 19, 499)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress3','String', 'Location Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 618, 'true', 20, 559)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'LocationCity','String', 'Location Address City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 648, 'true', 21, 619)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'LocationPostalStateCode','String', 'Location Address State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 650, 'true', 22, 649)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'LocationZipcode','String', 'Location Address Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 655, 'true', 23, 651)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'LocationZipcodePlus4','String', 'Location Address Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 659, 'true', 24, 656)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress1','String', 'Mailing Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 277, 'false', 11, 218)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress2','String', 'Mailing Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 337, 'true', 12, 278)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress3','String', 'Mailing Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 397, 'true', 13, 338)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'MailingCity','String', 'Mailing Address City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 427, 'false', 14, 398)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'MailingPostalStateCode','String', 'Mailing Address State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 429, 'false', 15, 428)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'MailingZipcode','String', 'Mailing Address Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 434, 'false', 16, 430)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'MailingZipcodePlus4','String', 'Mailing Address Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 438, 'true', 17, 435)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'StateAgencyName','String', 'State Agency Name', 'STATEAGENCYNAME')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 127, 'false', 8, 68)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'StateAgencyPhoneNumber','String', 'Phone Number', 'PHONENUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 217, 'false', 10, 208)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(80, 'StateAgencyWebAddress','String', 'Website Address', 'WEBSITEADDRESS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 207, 'true', 9, 128)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL DIRECTORY INFO' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL DIRECTORY INFO', @GenerateReportId, 3, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL DIRECTORY INFO' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 1061, 'false', 38, 1061)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'CharterSchoolAuthorizerAdditional','String', 'Charter School Authorizer Identifer (Additional)', 'CHRTAUTHADDL')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 860, 'true', 36, 841)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'CharterSchoolAuthorizerPrimary','String', 'Charter School Authorizer Identifer (Primary)', 'CHRTAUTHPRIMARY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 840, 'true', 35, 821)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'CharterSchoolStatus','String', 'Charter Status', 'CHARTERSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 756, 'false', 30, 727)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 1060, 'true', 37, 861)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 820, 'false', 34, 806)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress1','String', 'Location Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 495, 'true', 20, 436)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress2','String', 'Location Address Line 1', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 555, 'true', 21, 496)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress3','String', 'Location Address Line 1', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 615, 'true', 22, 556)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'LocationCity','String', 'Location City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 645, 'true', 23, 616)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'LocationPostalStateCode','String', 'Location State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 647, 'true', 24, 646)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'LocationZipcode','String', 'Location Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 652, 'true', 25, 648)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'LocationZipcodePlus4','String', 'Location Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 656, 'true', 26, 653)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress1','String', 'Mailing Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 274, 'false', 13, 215)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress2','String', 'Mailing Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 334, 'true', 14, 275)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress3','String', 'Mailing Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 394, 'true', 15, 335)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'MailingCity','String', 'Mailing City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 424, 'false', 16, 395)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'MailingPostalStateCode','String', 'Mailing State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 426, 'false', 17, 425)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'MailingZipcode','String', 'Mailing Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 431, 'false', 18, 427)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'MailingZipcodePlus4','String', 'Mailing Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 435, 'true', 19, 432)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(7, 'NCESLEAIDNumber','String', 'NCES LEA ID', 'DISTRICTNCESID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 35, 'true', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'NCESSchoolIDNumber','String', 'NCES School ID', 'NCESSCHOOLNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 60, 'true', 7, 56)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(3, 'OutOfStateInd','String', 'Out of State School', 'OUTOFSTATEIND')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 124, 'true', 10, 122)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'PriorStateLEAID','String', 'Prior State LEA ID', 'PRIORLEAID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 770, 'true', 31, 757)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'PriorStateSchoolID','String', 'Prior State School ID', 'PRIORSCHOOLID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 790, 'true', 32, 771)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'ReconstitutedStatus','String', 'Reconstituted Status', 'RECONSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 805, 'false', 33, 791)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'SchoolName','String', 'School Name', 'NAME')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 120, 'false', 8, 61)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'SchoolOpStatus','String', 'Updated operational status - school', 'CURRENTSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 716, 'true', 28, 687)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'SchoolPhoneNumber','String', 'Phone Number', 'PHONENUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 214, 'false', 12, 205)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'SchoolSysOpStatus','String', 'School year start school operational status', 'SYSTARTSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 686, 'false', 27, 657)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'SchoolType','String', 'School Type', 'TYPE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 121, 'false', 9, 121)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(80, 'SchoolWebAddress','String', 'Web Address', 'WEBSITEADDRESS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 204, 'true', 11, 125)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School ID', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 55, 'false', 6, 36)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'StatusEffectiveDate','String', 'Updated Operational Status Effective Date', 'STATUSEFFDATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 726, 'true', 29, 717)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA DIRECTORY INFO' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('LEA DIRECTORY INFO', @GenerateReportId, 2, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'LEA DIRECTORY INFO' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 985, 'false', 34, 985)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'ChrtSchoolLEAStatusID','String', 'Charter LEA status', 'CHARTERLEASTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 770, 'false', 31, 741)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 984, 'true', 33, 785)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler6','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 55, 'false', 6, 36)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(12, 'Filler7','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 67, 'false', 7, 56)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LEAName','String', 'LEA Name', 'NAME')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 127, 'false', 8, 68)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'LEAOpStatus','String', 'Updated operational status - LEA', 'CURRENTSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 730, 'true', 29, 701)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'LEAPhoneNumber','String', 'Telephone - LEA', 'PHONENUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 228, 'false', 13, 219)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'LEASysOpStatus','String', 'School year start LEA operational status', 'SYSTARTSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 700, 'false', 28, 671)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'LEAType','String', 'Local education agency (LEA) type', 'TYPE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 131, 'false', 10, 131)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(80, 'LEAWebAddress','String', 'Website Address', 'WEBSITEADDRESS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 211, 'true', 11, 132)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress1','String', 'Location Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 509, 'true', 21, 450)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress2','String', 'Location Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 569, 'true', 22, 510)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress3','String', 'Location Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 629, 'true', 23, 570)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'LocationCity','String', 'Location City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 659, 'true', 24, 630)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'LocationPostalStateCode','String', 'Location State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 661, 'true', 25, 660)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'LocationZipcode','String', 'Location Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 666, 'true', 26, 662)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'LocationZipcodePlus4','String', 'Location Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 670, 'true', 27, 667)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress1','String', 'LEA Address Mailing 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 288, 'false', 14, 229)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress2','String', 'LEA Address Mailing 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 348, 'true', 15, 289)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress3','String', 'LEA Address Mailing 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 408, 'true', 16, 349)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'MailingCity','String', 'LEA Mailing City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 438, 'false', 17, 409)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'MailingPostalStateCode','String', 'LEA Mailing USPS', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 440, 'false', 18, 439)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'MailingZipcode','String', 'LEA Mailing Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 445, 'false', 19, 441)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'MailingZipcodePlus4','String', 'LEA Mailing Zipcode Plus 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 449, 'true', 20, 446)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(7, 'NCESLEAIDNumber','String', 'NCES LEA ID', 'DISTRICTNCESID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 35, 'true', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(3, 'OutOfStateInd','String', 'Out of State Indicator', 'OUTOFSTATEIND')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 130, 'true', 9, 128)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'PriorStateLEAID','String', 'Prior State LEA ID', 'PRIORLEAID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 784, 'true', 32, 771)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'StatusEffectiveDate','String', 'LEA Op Status Effective Date', 'STATUSEFFDATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 740, 'true', 30, 731)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(7, 'SupervisoryUnion','String', 'Supervisory Union', 'SUPERVUNIONID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 218, 'true', 12, 212)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SEA DIRECTORY INFO' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SEA DIRECTORY INFO', @GenerateReportId, 1, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SEA DIRECTORY INFO' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 1060, 'false', 31, 1060)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', '', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 1059, 'true', 30, 860)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(7, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 35, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 55, 'false', 6, 36)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(12, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 67, 'false', 7, 56)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'Filler5','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 689, 'false', 25, 660)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'Filler6','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 719, 'false', 26, 690)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(50, 'Filler7','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 769, 'false', 27, 720)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Filler8','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 779, 'false', 28, 770)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(80, 'Filler9','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 859, 'false', 29, 780)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress1','String', 'Location Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 498, 'true', 18, 439)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress2','String', 'Location Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 558, 'true', 19, 499)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress3','String', 'Location Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 618, 'true', 20, 559)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'LocationCity','String', 'Location Address City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 648, 'true', 21, 619)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'LocationPostalStateCode','String', 'Location Address State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 650, 'true', 22, 649)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'LocationZipcode','String', 'Location Address Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 655, 'true', 23, 651)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'LocationZipcodePlus4','String', 'Location Address Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 659, 'true', 24, 656)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress1','String', 'Mailing Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 277, 'false', 11, 218)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress2','String', 'Mailing Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 337, 'true', 12, 278)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress3','String', 'Mailing Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 397, 'true', 13, 338)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'MailingCity','String', 'Mailing Address City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 427, 'false', 14, 398)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'MailingPostalStateCode','String', 'Mailing Address State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 429, 'false', 15, 428)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'MailingZipcode','String', 'Mailing Address Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 434, 'false', 16, 430)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'MailingZipcodePlus4','String', 'Mailing Address Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 438, 'true', 17, 435)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'StateAgencyName','String', 'State Agency Name', 'STATEAGENCYNAME')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 127, 'false', 8, 68)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'StateAgencyPhoneNumber','String', 'Phone Number', 'PHONENUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 217, 'false', 10, 208)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(80, 'StateAgencyWebAddress','String', 'Website Address', 'WEBSITEADDRESS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 207, 'true', 9, 128)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL DIRECTORY INFO' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL DIRECTORY INFO', @GenerateReportId, 3, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL DIRECTORY INFO' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 1061, 'false', 38, 1061)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'CharterSchoolAuthorizerAdditional','String', 'Charter School Authorizer Identifer (Additional)', 'CHRTAUTHADDL')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 860, 'true', 36, 841)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'CharterSchoolAuthorizerPrimary','String', 'Charter School Authorizer Identifer (Primary)', 'CHRTAUTHPRIMARY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 840, 'true', 35, 821)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'CharterSchoolStatus','String', 'Charter Status', 'CHARTERSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 756, 'false', 30, 727)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 1060, 'true', 37, 861)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 820, 'false', 34, 806)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress1','String', 'Location Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 495, 'true', 20, 436)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress2','String', 'Location Address Line 1', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 555, 'true', 21, 496)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress3','String', 'Location Address Line 1', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 615, 'true', 22, 556)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'LocationCity','String', 'Location City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 645, 'true', 23, 616)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'LocationPostalStateCode','String', 'Location State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 647, 'true', 24, 646)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'LocationZipcode','String', 'Location Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 652, 'true', 25, 648)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'LocationZipcodePlus4','String', 'Location Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 656, 'true', 26, 653)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress1','String', 'Mailing Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 274, 'false', 13, 215)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress2','String', 'Mailing Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 334, 'true', 14, 275)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress3','String', 'Mailing Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 394, 'true', 15, 335)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'MailingCity','String', 'Mailing City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 424, 'false', 16, 395)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'MailingPostalStateCode','String', 'Mailing State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 426, 'false', 17, 425)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'MailingZipcode','String', 'Mailing Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 431, 'false', 18, 427)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'MailingZipcodePlus4','String', 'Mailing Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 435, 'true', 19, 432)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(7, 'NCESLEAIDNumber','String', 'NCES LEA ID', 'DISTRICTNCESID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 35, 'true', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'NCESSchoolIDNumber','String', 'NCES School ID', 'NCESSCHOOLNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 60, 'true', 7, 56)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(3, 'OutOfStateInd','String', 'Out of State School', 'OUTOFSTATEIND')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 124, 'true', 10, 122)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'PriorStateLEAID','String', 'Prior State LEA ID', 'PRIORLEAID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 770, 'true', 31, 757)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'PriorStateSchoolID','String', 'Prior State School ID', 'PRIORSCHOOLID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 790, 'true', 32, 771)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'ReconstitutedStatus','String', 'Reconstituted Status', 'RECONSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 805, 'false', 33, 791)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'SchoolName','String', 'School Name', 'NAME')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 120, 'false', 8, 61)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'SchoolOpStatus','String', 'Updated operational status - school', 'CURRENTSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 716, 'true', 28, 687)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'SchoolPhoneNumber','String', 'Phone Number', 'PHONENUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 214, 'false', 12, 205)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'SchoolSysOpStatus','String', 'School year start school operational status', 'SYSTARTSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 686, 'false', 27, 657)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'SchoolType','String', 'School Type', 'TYPE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 121, 'false', 9, 121)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(80, 'SchoolWebAddress','String', 'Web Address', 'WEBSITEADDRESS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 204, 'true', 11, 125)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School ID', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 55, 'false', 6, 36)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'StatusEffectiveDate','String', 'Updated Operational Status Effective Date', 'STATUSEFFDATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 726, 'true', 29, 717)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA DIRECTORY INFO' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('LEA DIRECTORY INFO', @GenerateReportId, 2, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'LEA DIRECTORY INFO' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 985, 'false', 34, 985)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'ChrtSchoolLEAStatusID','String', 'Charter LEA status', 'CHARTERLEASTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 770, 'false', 31, 741)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 984, 'true', 33, 785)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler6','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 55, 'false', 6, 36)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(12, 'Filler7','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 67, 'false', 7, 56)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LEAName','String', 'LEA Name', 'NAME')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 127, 'false', 8, 68)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'LEAOpStatus','String', 'Updated operational status - LEA', 'CURRENTSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 730, 'true', 29, 701)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'LEAPhoneNumber','String', 'Telephone - LEA', 'PHONENUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 228, 'false', 13, 219)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'LEASysOpStatus','String', 'School year start LEA operational status', 'SYSTARTSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 700, 'false', 28, 671)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'LEAType','String', 'Local education agency (LEA) type', 'TYPE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 131, 'false', 10, 131)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(80, 'LEAWebAddress','String', 'Website Address', 'WEBSITEADDRESS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 211, 'true', 11, 132)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress1','String', 'Location Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 509, 'true', 21, 450)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress2','String', 'Location Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 569, 'true', 22, 510)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress3','String', 'Location Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 629, 'true', 23, 570)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'LocationCity','String', 'Location City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 659, 'true', 24, 630)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'LocationPostalStateCode','String', 'Location State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 661, 'true', 25, 660)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'LocationZipcode','String', 'Location Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 666, 'true', 26, 662)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'LocationZipcodePlus4','String', 'Location Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 670, 'true', 27, 667)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress1','String', 'LEA Address Mailing 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 288, 'false', 14, 229)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress2','String', 'LEA Address Mailing 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 348, 'true', 15, 289)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress3','String', 'LEA Address Mailing 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 408, 'true', 16, 349)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'MailingCity','String', 'LEA Mailing City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 438, 'false', 17, 409)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'MailingPostalStateCode','String', 'LEA Mailing USPS', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 440, 'false', 18, 439)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'MailingZipcode','String', 'LEA Mailing Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 445, 'false', 19, 441)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'MailingZipcodePlus4','String', 'LEA Mailing Zipcode Plus 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 449, 'true', 20, 446)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(7, 'NCESLEAIDNumber','String', 'NCES LEA ID', 'DISTRICTNCESID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 35, 'true', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(3, 'OutOfStateInd','String', 'Out of State Indicator', 'OUTOFSTATEIND')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 130, 'true', 9, 128)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'PriorStateLEAID','String', 'Prior State LEA ID', 'PRIORLEAID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 784, 'true', 32, 771)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'StatusEffectiveDate','String', 'LEA Op Status Effective Date', 'STATUSEFFDATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 740, 'true', 30, 731)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(7, 'SupervisoryUnion','String', 'Supervisory Union', 'SUPERVUNIONID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 218, 'true', 12, 212)
 
 
 
		----------------------
		-- c033
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c033' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL FREE AND REDUCED PRICE LUNCH' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL FREE AND REDUCED PRICE LUNCH', @GenerateReportId, 3, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL FREE AND REDUCED PRICE LUNCH' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Amount', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 294, 'false', 10, 285)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 295, 'false', 11, 295)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 284, 'true', 9, 85)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'LunchProgramStatusID','String', 'Lunch Program Status', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School ID Number', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 84, 'false', 8, 84)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL FREE AND REDUCED PRICE LUNCH' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL FREE AND REDUCED PRICE LUNCH', @GenerateReportId, 3, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL FREE AND REDUCED PRICE LUNCH' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Amount', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 294, 'false', 10, 285)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 295, 'false', 11, 295)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 284, 'true', 9, 85)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'LunchProgramStatusID','String', 'Lunch Program Status', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School ID Number', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 84, 'false', 8, 84)
 
 
 
		----------------------
		-- c039
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c039' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA GRADES OFFERED' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('LEA GRADES OFFERED', @GenerateReportId, 2, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'LEA GRADES OFFERED' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 283, 'false', 22, 283)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 282, 'true', 9, 83)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(7, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 35, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 55, 'false', 6, 36)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(12, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 67, 'false', 7, 56)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GradeLevelID','String', 'Grade Level', 'GRADEOFFERED')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 82, 'false', 8, 68)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL GRADES OFFERED' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL GRADES OFFERED', @GenerateReportId, 3, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL GRADES OFFERED' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 283, 'false', 22, 283)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 282, 'true', 9, 83)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(7, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 35, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(12, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 67, 'false', 7, 56)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GradeLevelID','String', 'Grade Level', 'GRADEOFFERED')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 82, 'false', 8, 68)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School ID Number', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 55, 'false', 6, 36)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA GRADES OFFERED' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('LEA GRADES OFFERED', @GenerateReportId, 2, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'LEA GRADES OFFERED' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 283, 'false', 22, 283)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 282, 'true', 9, 83)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(7, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 35, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 55, 'false', 6, 36)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(12, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 67, 'false', 7, 56)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GradeLevelID','String', 'Grade Level', 'GRADEOFFERED')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 82, 'false', 8, 68)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL GRADES OFFERED' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL GRADES OFFERED', @GenerateReportId, 3, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL GRADES OFFERED' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 283, 'false', 22, 283)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 282, 'true', 9, 83)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(7, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 35, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(12, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 67, 'false', 7, 56)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GradeLevelID','String', 'Grade Level', 'GRADEOFFERED')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 82, 'false', 8, 68)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School ID Number', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 55, 'false', 6, 36)
 
 
 
		----------------------
		-- c052
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c052' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SEA MEMBERSHIP TABLE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SEA MEMBERSHIP TABLE', @GenerateReportId, 1, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SEA MEMBERSHIP TABLE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Student Count', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 324, 'false', 12, 315)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 325, 'false', 13, 325)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 314, 'true', 11, 115)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GradeLevelID','String', 'Grade Level (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 114, 'false', 10, 114)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA MEMBERSHIP TABLE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('LEA MEMBERSHIP TABLE', @GenerateReportId, 2, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'LEA MEMBERSHIP TABLE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Student Count', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 324, 'false', 12, 315)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 325, 'false', 13, 325)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 314, 'true', 11, 115)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GradeLevelID','String', 'Grade Level (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 114, 'false', 10, 114)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL MEMBERSHIP TABLE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL MEMBERSHIP TABLE', @GenerateReportId, 3, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL MEMBERSHIP TABLE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Student Count', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 324, 'false', 12, 315)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 325, 'false', 13, 325)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 314, 'true', 11, 115)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GradeLevelID','String', 'Grade Level (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School ID Number', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 114, 'false', 10, 114)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SEA MEMBERSHIP TABLE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SEA MEMBERSHIP TABLE', @GenerateReportId, 1, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SEA MEMBERSHIP TABLE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Student Count', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 324, 'false', 12, 315)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 325, 'false', 13, 325)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 314, 'true', 11, 115)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GradeLevelID','String', 'Grade Level (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 114, 'false', 10, 114)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA MEMBERSHIP TABLE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('LEA MEMBERSHIP TABLE', @GenerateReportId, 2, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'LEA MEMBERSHIP TABLE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Student Count', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 324, 'false', 12, 315)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 325, 'false', 13, 325)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 314, 'true', 11, 115)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GradeLevelID','String', 'Grade Level (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 114, 'false', 10, 114)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL MEMBERSHIP TABLE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL MEMBERSHIP TABLE', @GenerateReportId, 3, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL MEMBERSHIP TABLE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Student Count', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 324, 'false', 12, 315)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 325, 'false', 13, 325)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 314, 'true', 11, 115)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GradeLevelID','String', 'Grade Level (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School ID Number', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 114, 'false', 10, 114)
 
 
 
		----------------------
		-- c059
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c059' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SEA STAFF FTE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SEA STAFF FTE', @GenerateReportId, 1, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SEA STAFF FTE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Amount', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 339, 'false', 13, 330)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 340, 'false', 14, 340)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 329, 'true', 12, 130)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'false', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'false', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler5','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'StaffCategoryID','String', 'Staff Category (CCD)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 129, 'false', 11, 129)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA STAFF FTE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('LEA STAFF FTE', @GenerateReportId, 2, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'LEA STAFF FTE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Amount', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 339, 'false', 13, 330)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 340, 'false', 14, 340)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 329, 'true', 12, 130)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'false', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'false', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'StaffCategoryID','String', 'Staff Category (CCD)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 129, 'false', 11, 129)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL STAFF FTE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL STAFF FTE', @GenerateReportId, 3, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL STAFF FTE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Amount', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 339, 'false', 13, 330)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 340, 'false', 14, 340)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 329, 'true', 12, 130)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'false', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'false', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'false', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School ID Number', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 129, 'false', 11, 129)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SEA STAFF FTE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SEA STAFF FTE', @GenerateReportId, 1, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SEA STAFF FTE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Staff FTE', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 339, 'false', 13, 330)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 340, 'false', 14, 340)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 329, 'true', 12, 130)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'false', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'false', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler5','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'StaffCategoryID','String', 'Staff Category (CCD)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 129, 'false', 11, 129)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA STAFF FTE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('LEA STAFF FTE', @GenerateReportId, 2, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'LEA STAFF FTE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Staff FTE', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 339, 'false', 13, 330)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 340, 'false', 14, 340)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 329, 'true', 12, 130)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'false', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'false', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'StaffCategoryID','String', 'Staff Category (CCD)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'LEA Identifier (state)', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 129, 'false', 11, 129)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL STAFF FTE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL STAFF FTE', @GenerateReportId, 3, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL STAFF FTE' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','String', 'Teachers FTE', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 339, 'false', 13, 330)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 340, 'false', 14, 340)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 329, 'true', 12, 130)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'false', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'false', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler3','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'false', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'LEA Identifier (state)', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'School Identifier (state)', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 129, 'false', 11, 129)
 
 
 
		----------------------
		-- c089
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c089' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SEA CHILDREN WITH DISABILITIES (IDEA) EC ' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SEA CHILDREN WITH DISABILITIES (IDEA) EC ', @GenerateReportId, 1, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SEA CHILDREN WITH DISABILITIES (IDEA) EC ' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'AgeID','String', 'Age (Early Childhood)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','Number', 'Student Count', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 489, 'false', 20, 480)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 490, 'false', 21, 490)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'DisabilityCategoryID','String', 'Disability Category (IDEA)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 143, 'true', 11, 129)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'EarlyChildEdEnvironmentID','String', 'Educational Environment (IDEA) EC', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 278, 'true', 17, 219)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 479, 'true', 19, 280)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler12','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 158, 'false', 12, 144)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler13','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 173, 'false', 13, 159)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler14','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 188, 'false', 14, 174)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler15','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 203, 'false', 15, 189)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler16','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 218, 'false', 16, 204)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler5','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'LEPStatusID','String', 'English Learner Status (Both)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'true', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency ID Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 279, 'false', 18, 279)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA CHILDREN WITH DISABILITIES (IDEA) EC ' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('LEA CHILDREN WITH DISABILITIES (IDEA) EC ', @GenerateReportId, 2, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'LEA CHILDREN WITH DISABILITIES (IDEA) EC ' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'AgeID','String', 'Age (Early Childhood)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','Number', 'Student Count', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 489, 'false', 20, 480)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 490, 'false', 21, 490)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'DisabilityCategoryID','String', 'Disability Category (IDEA)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 143, 'true', 11, 129)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'EarlyChildEdEnvironmentID','String', 'Educational Environment (IDEA) EC', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 278, 'true', 17, 219)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 479, 'true', 19, 280)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler12','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 158, 'false', 12, 144)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler13','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 173, 'false', 13, 159)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler14','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 188, 'false', 14, 174)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler15','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 203, 'false', 15, 189)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler16','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 218, 'false', 16, 204)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler5','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'LEPStatusID','String', 'English Learner Status (Both)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'true', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency ID Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 279, 'false', 18, 279)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SEA CHILDREN WITH DISABILITIES (IDEA) EC' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SEA CHILDREN WITH DISABILITIES (IDEA) EC', @GenerateReportId, 1, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SEA CHILDREN WITH DISABILITIES (IDEA) EC' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'AgeID','String', 'Age (Early Childhood)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','Number', 'Student Count', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 489, 'false', 20, 480)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 490, 'false', 21, 490)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'DisabilityCategoryID','String', 'Disability Category (IDEA)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 143, 'true', 11, 129)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'EarlyChildEdEnvironmentID','String', 'Educational Environment (IDEA) EC', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 278, 'true', 17, 219)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 479, 'true', 19, 280)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler12','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 158, 'false', 12, 144)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler13','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 173, 'false', 13, 159)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler14','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 188, 'false', 14, 174)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler15','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 203, 'false', 15, 189)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler16','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 218, 'false', 16, 204)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler4','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler5','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'LEPStatusID','String', 'English Learner Status (Both)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'true', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency ID Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 279, 'false', 18, 279)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'LEA CHILDREN WITH DISABILITIES (IDEA) EC' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('LEA CHILDREN WITH DISABILITIES (IDEA) EC', @GenerateReportId, 2, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'LEA CHILDREN WITH DISABILITIES (IDEA) EC' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 2 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'AgeID','String', 'Age (Early Childhood)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 113, 'true', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'Amount','Number', 'Student Count', 'AMOUNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 489, 'false', 20, 480)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 490, 'false', 21, 490)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'DisabilityCategoryID','String', 'Disability Category (IDEA)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 143, 'true', 11, 129)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'EarlyChildEdEnvironmentID','String', 'Educational Environment (IDEA) EC', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 278, 'true', 17, 219)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 479, 'true', 19, 280)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler12','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 158, 'false', 12, 144)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler13','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 173, 'false', 13, 159)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler14','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 188, 'false', 14, 174)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler15','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 203, 'false', 15, 189)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler16','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 218, 'false', 16, 204)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler5','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'GenderID','String', 'Sex (Membership)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'LEPStatusID','String', 'English Learner Status (Both)', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'true', 10, 114)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'RaceEthnicityID','String', 'Racial Ethnic', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency ID Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'TotalIndicator','String', 'Total Indicator', 'TOTALINDICATOR')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 279, 'false', 18, 279)
 
 
 
		----------------------
		-- c129
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c129' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'CCD SCHOOL' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('CCD SCHOOL', @GenerateReportId, 3, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'CCD SCHOOL' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 324, 'false', 12, 324)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Expalantion', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 323, 'true', 11, 124)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'MagnetSchoolStatus','String', 'Magnet Status', 'MAGNETSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 93, 'false', 8, 79)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'NSLPstatus','String', 'NSLP status', 'NSLPSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 108, 'false', 9, 94)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'SharedTimeInd','String', 'Shared Time Indicator', 'SHAREDTIMEIND')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 63, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency ID Number', 'STATEAGENCYIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School ID Number', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'TitleISchoolStatus','String', 'Title I School Status', 'TITLEISTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 78, 'false', 7, 64)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'VirtualSchoolStatus','String', 'Virtual school status', 'VIRTUALSCHOOL')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 123, 'false', 10, 109)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'CCD SCHOOL' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('CCD SCHOOL', @GenerateReportId, 3, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'CCD SCHOOL' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 324, 'false', 12, 324)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Expalantion', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 323, 'true', 11, 124)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 78, 'false', 7, 64)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 93, 'false', 8, 79)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'FIPS', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'NSLPstatus','String', 'NSLP status', 'NSLPSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 108, 'false', 9, 94)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'SharedTimeInd','String', 'Shared Time Indicator', 'SHAREDTIMEIND')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 63, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency ID Number', 'STATEAGENCYIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA ID Number', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School ID Number', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'VirtualSchoolStatus','String', 'Virtual school status', 'VIRTUALSCHOOL')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 123, 'false', 10, 109)
 
 
 
		----------------------
		-- c130
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c130' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL NCLB SY START STATUS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL NCLB SY START STATUS', @GenerateReportId, 3, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL NCLB SY START STATUS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 324, 'false', 12, 324)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 323, 'false', 11, 124)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler1','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 108, 'false', 9, 94)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler2','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 123, 'false', 10, 109)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler3','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 93, 'false', 8, 79)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler4','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 63, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'PersistDangerStatus','String', 'Persistently Dangerous Status', 'PERSISTDANGERSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 78, 'false', 7, 64)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'LEA Identifier (State)', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'School Identifier (State)', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL NCLB SY START STATUS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL NCLB SY START STATUS', @GenerateReportId, 3, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL NCLB SY START STATUS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 324, 'false', 12, 324)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 323, 'false', 11, 124)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler1','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 108, 'false', 9, 94)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler2','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 123, 'false', 10, 109)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler3','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 93, 'false', 8, 79)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler4','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 63, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'PersistDangerStatus','String', 'Persistently Dangerous Status', 'PERSISTDANGERSTATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 78, 'false', 7, 64)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'LEA Identifier (State)', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'School Identifier (State)', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
 
 
		----------------------
		-- c190
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c190' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SEA CHARTER AUTHORIZER' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1112 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SEA CHARTER AUTHORIZER', @GenerateReportId, 1112, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SEA CHARTER AUTHORIZER' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1112 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 586, 'false', 23, 586)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'CharterAuthorizerName','String', 'Charter  authorizer name', 'CHARTERAUTHORIZERNAME')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 108, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'CharterAuthorizerStateNumber','String', 'Charter authorizer identifier (state)', 'CHARTERAUTHORIZERSTATENUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 7, 109)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'CharterAuthorizerType','String', 'Charter authorizer type', 'CHARTERAUTHORIZERTYPE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 585, 'false', 22, 571)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress1','String', 'Location Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 409, 'true', 15, 350)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress2','String', 'Location Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 469, 'true', 16, 410)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress3','String', 'Location Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 529, 'true', 17, 470)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'LocationCity','String', 'Location Address City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 559, 'true', 18, 530)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'LocationPostalStateCode','String', 'Location Address State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 561, 'true', 19, 560)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'LocationZipcode','String', 'Location Address Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 566, 'true', 20, 562)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'LocationZipcodePlus4','String', 'Location Address Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 570, 'true', 21, 567)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress1','String', 'Mailing Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 188, 'false', 8, 129)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress2','String', 'Mailing Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 248, 'true', 9, 189)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress3','String', 'Mailing Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 308, 'true', 10, 249)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'MailingCity','String', 'Mailing Address City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 338, 'false', 11, 309)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'MailingPlus4','String', 'Mailing Address Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 349, 'true', 14, 346)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'MailingPostalStateCode','String', 'Mailing Address State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 340, 'false', 12, 339)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'MailingZipcode','String', 'Mailing Address Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 345, 'false', 13, 341)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SEA CHARTER AUTHORIZER' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1112 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SEA CHARTER AUTHORIZER', @GenerateReportId, 1112, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SEA CHARTER AUTHORIZER' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1112 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 586, 'false', 23, 586)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'CharterAuthorizerName','String', 'Charter  authorizer name', 'CHARTERAUTHORIZERNAME')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 108, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'CharterAuthorizerStateNumber','String', 'Charter authorizer identifier (state)', 'CHARTERAUTHORIZERSTATENUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 7, 109)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'CharterAuthorizerType','String', 'Charter authorizer type', 'CHARTERAUTHORIZERTYPE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 585, 'false', 22, 571)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress1','String', 'Location Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 409, 'true', 15, 350)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress2','String', 'Location Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 469, 'true', 16, 410)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress3','String', 'Location Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 529, 'true', 17, 470)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'LocationCity','String', 'Location Address City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 559, 'true', 18, 530)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'LocationPostalStateCode','String', 'Location Address State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 561, 'true', 19, 560)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'LocationZipcode','String', 'Location Address Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 566, 'true', 20, 562)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'LocationZipcodePlus4','String', 'Location Address Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 570, 'true', 21, 567)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress1','String', 'Mailing Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 188, 'false', 8, 129)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress2','String', 'Mailing Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 248, 'true', 9, 189)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress3','String', 'Mailing Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 308, 'true', 10, 249)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'MailingCity','String', 'Mailing Address City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 338, 'false', 11, 309)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'MailingPlus4','String', 'Mailing Address Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 349, 'true', 14, 346)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'MailingPostalStateCode','String', 'Mailing Address State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 340, 'false', 12, 339)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'MailingZipcode','String', 'Mailing Address Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 345, 'false', 13, 341)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
 
 
		----------------------
		-- c196
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c196' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'CHARTER MANAGE ORG' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1182 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('CHARTER MANAGE ORG', @GenerateReportId, 1182, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'CHARTER MANAGE ORG' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1182 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 791, 'false', 24, 791)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'CharterMngmtOrgEmpIdNum','String', 'Employer identification number', 'EMPIDENTNNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 7, 109)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'CharterMngmtOrgName','String', 'Management organization name', 'MANGMTORGNAME')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 108, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'CharterMngmtOrgType','String', 'Management organization type', 'MANGMTORGTYPE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 590, 'false', 22, 571)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 790, 'true', 23, 591)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress1','String', 'Location Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 188, 'true', 8, 129)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress2','String', 'Location Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 248, 'true', 9, 189)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress3','String', 'Location Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 308, 'true', 10, 249)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'LocationCity','String', 'Location Address City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 338, 'true', 11, 309)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'LocationPostalStateCode','String', 'Location Address State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 340, 'true', 12, 339)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'LocationZipcode','String', 'Location Address Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 345, 'true', 13, 341)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'LocationZipcodePlus4','String', 'Location Address Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 349, 'true', 14, 346)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress1','String', 'Mailing Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 409, 'false', 15, 350)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress2','String', 'Mailing Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 469, 'true', 16, 410)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress3','String', 'Mailing Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 529, 'true', 17, 470)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'MailingCity','String', 'Mailing Address City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 559, 'false', 18, 530)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'MailingPlus4','String', 'Mailing Address Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 570, 'true', 21, 567)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'MailingPostalStateCode','String', 'Mailing Address State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 561, 'false', 19, 560)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'MailingZipcode','String', 'Mailing Address Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 566, 'false', 20, 562)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'CHARTER MANAGE ORG' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1182 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('CHARTER MANAGE ORG', @GenerateReportId, 1182, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'CHARTER MANAGE ORG' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 1182 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 791, 'false', 24, 791)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'CharterMngmtOrgEmpIdNum','String', 'Employer identification number', 'EMPIDENTNNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 128, 'false', 7, 109)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'CharterMngmtOrgName','String', 'Management organization name', 'MANGMTORGNAME')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 108, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'CharterMngmtOrgType','String', 'Management organization type', 'MANGMTORGTYPE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 590, 'false', 22, 571)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 790, 'true', 23, 591)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'Filler1','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'Filler2','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress1','String', 'Location Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 188, 'true', 8, 129)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress2','String', 'Location Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 248, 'true', 9, 189)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'LocationAddress3','String', 'Location Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 308, 'true', 10, 249)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'LocationCity','String', 'Location Address City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 338, 'true', 11, 309)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'LocationPostalStateCode','String', 'Location Address State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 340, 'true', 12, 339)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'LocationZipcode','String', 'Location Address Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 345, 'true', 13, 341)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'LocationZipcodePlus4','String', 'Location Address Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 349, 'true', 14, 346)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress1','String', 'Mailing Address Line 1', 'ADDRESSLINE1')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 409, 'false', 15, 350)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress2','String', 'Mailing Address Line 2', 'ADDRESSLINE2')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 469, 'true', 16, 410)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(60, 'MailingAddress3','String', 'Mailing Address Line 3', 'ADDRESSLINE3')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 529, 'true', 17, 470)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(30, 'MailingCity','String', 'Mailing Address City', 'CITY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 559, 'false', 18, 530)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(4, 'MailingPlus4','String', 'Mailing Address Zipcode 4', 'ZIPCODE4')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 570, 'true', 21, 567)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'MailingPostalStateCode','String', 'Mailing Address State', 'STATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 561, 'false', 19, 560)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'MailingZipcode','String', 'Mailing Address Zipcode', 'ZIPCODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 566, 'false', 20, 562)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
 
 
		----------------------
		-- c197
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c197' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCH CHAR ORG CROSSWALK' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCH CHAR ORG CROSSWALK', @GenerateReportId, 3, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCH CHAR ORG CROSSWALK' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', 'Carriage Return / Line Feed (CRLF)', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 301, 'false', 11, 301)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 300, 'true', 10, 101)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'ManagementOrganizationEIN','String', 'Management organization EIN ', 'CHARTMANORGEIN')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 80, 'false', 8, 61)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'ManagementOrgEINUpdated','String', 'Management organization EIN updated  ', 'CHARTMANORGEINUPD')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 100, 'true', 9, 81)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(7, 'NCESLEAIDNumber','String', 'LEA Identifier (NCES)', 'DISTRICTNCESID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 35, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'NCESSchoolNumber','String', 'NCESSCHOOLNUMBER', 'NCESSCHOOLNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 60, 'false', 7, 56)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'LEA Identifier (State)', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'School Identifier (State)', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 55, 'false', 6, 36)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCH CHAR ORG CROSSWALK' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCH CHAR ORG CROSSWALK', @GenerateReportId, 3, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCH CHAR ORG CROSSWALK' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', 'Carriage Return / Line Feed (CRLF)', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 301, 'false', 11, 301)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 300, 'true', 10, 101)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'ManagementOrganizationEIN','String', 'Management organization EIN ', 'CHARTMANORGEIN')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 80, 'false', 8, 61)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'ManagementOrgEINUpdated','String', 'Management organization EIN updated  ', 'CHARTMANORGEINUPD')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 100, 'true', 9, 81)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(7, 'NCESLEAIDNumber','String', 'LEA Identifier (NCES)', 'DISTRICTNCESID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 35, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(5, 'NCESSchoolNumber','String', 'NCESSCHOOLNUMBER', 'NCESSCHOOLNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 60, 'false', 7, 56)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'LEA Identifier (State)', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'School Identifier (State)', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 55, 'false', 6, 36)
 
 
 
		----------------------
		-- c198
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c198' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCH CHAR CONTRACTS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCH CHAR CONTRACTS', @GenerateReportId, 3, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCH CHAR CONTRACTS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 289, 'false', 10, 289)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'CharterContractApprovalDate','String', 'Charter contract approval date', 'CHARCONTAPPROVALDATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 78, 'false', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'CharterContractIDNumber','String', 'Charter contract ID number', 'CHARCONTRACTID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'CharterContractRenewalDate','String', 'Charter contract renewal date', 'CHARCONTRENEWALDATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 88, 'false', 8, 79)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 288, 'true', 9, 89)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA Identifier', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School Identifier', 'STATESCHIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCH*CHAR*CONTRACTS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCH*CHAR*CONTRACTS', @GenerateReportId, 3, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCH*CHAR*CONTRACTS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 289, 'false', 10, 289)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'CharterContractApprovalDate','String', 'Charter Contract Approval Date', 'CHARCONTAPPROVALDATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 78, 'false', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'CharterContractIDNumber','String', 'Charter Contract ID Number', 'CHARCONTRACTID')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'CharterContractRenewalDate','String', 'Charter Contract Renewal Date', 'CHARCONTRENEWALDATE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 88, 'false', 8, 79)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 288, 'true', 9, 89)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'State LEA Identifier', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'State School Identifier', 'STATESCHIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
 
 
		----------------------
		-- c206
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c206' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCH CSI TSI' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCH CSI TSI', @GenerateReportId, 3, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCH CSI TSI' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'AddlTrgtSupImprvmntID','String', 'Additional Targeted Support and Improvement', 'ADDLTRGTSUPIMPRVMNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 93, 'false', 8, 79)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 324, 'false', 12, 324)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'CompSupImprvmntID','String', 'Comprehensive Support and Improvement', 'COMPSUPIMPRVMNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 63, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 323, 'true', 11, 124)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler1','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 108, 'false', 9, 94)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler2','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 123, 'false', 10, 109)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'LEA Identifier (State)', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'School Identifier (State)', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'TrgtSupImprvmntID','String', 'Targeted Support and Improvement', 'TRGTSUPIMPRVMNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 78, 'false', 7, 64)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCH CSI TSI' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCH CSI TSI', @GenerateReportId, 3, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCH CSI TSI' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'AddlTrgtSupImprvmntID','String', 'Additional Targeted Support and Improvement', 'ADDLTRGTSUPIMPRVMNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 93, 'false', 8, 79)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 324, 'false', 12, 324)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'CompSupImprvmntID','String', 'Comprehensive Support and Improvement', 'COMPSUPIMPRVMNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 63, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 323, 'true', 11, 124)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler1','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 108, 'false', 9, 94)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Filler2','String', 'Filler', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 123, 'false', 10, 109)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'LEA Identifier (State)', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'School Identifier (State)', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'TrgtSupImprvmntID','String', 'Targeted Support and Improvement', 'TRGTSUPIMPRVMNT')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 78, 'false', 7, 64)
 
 
 
		----------------------
		-- c207
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c207' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL CHAR STE APPROPRIATIONS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL CHAR STE APPROPRIATIONS', @GenerateReportId, 3, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL CHAR STE APPROPRIATIONS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 264, 'false', 8, 264)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 263, 'true', 7, 64)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'LEA Identifier (State)', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'School Identifier (State)', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'SteAprptnMthdsID','String', 'State Appropriation Methods', 'STEAPRPTNMTHDS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 63, 'false', 6, 49)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL CHAR STE APPROPRIATIONS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL CHAR STE APPROPRIATIONS', @GenerateReportId, 3, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL CHAR STE APPROPRIATIONS' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 264, 'false', 8, 264)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 263, 'true', 7, 64)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'LEA Identifier (State)', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'School Identifier (State)', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'SteAprptnMthdsID','String', 'State Appropriation Methods', 'STEAPRPTNMTHDS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 63, 'false', 6, 49)
 
 
 
		----------------------
		-- c212
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c212' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL CSI TSI REASON' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL CSI TSI REASON', @GenerateReportId, 3, '2021-22')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL CSI TSI REASON' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2021-22'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Amount','String', 'Reason Applicability', 'STATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 314, 'false', 11, 300)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 315, 'false', 12, 315)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'ComprhnsvSupportIdentificationTypeID','String', 'Comprehensive Support Identification Type', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 299, 'true', 10, 100)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'Filler','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 99, 'false', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'LEA Identifier (State)', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'School Identifier (State)', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'TargetIdentificationSubgrpsID','String', 'Target Identification Subgroups', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
 
		If not exists (Select 1 from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL CSI TSI REASON' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23')
		BEGIN
			INSERT INTO App.FileSubmissions
			([FileSubmissionDescription], [GenerateReportId], [OrganizationLevelId], [SubmissionYear])
			values
			('SCHOOL CSI TSI REASON', @GenerateReportId, 3, '2022-23')
 
			SET @fileSubmissionId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
			SELECT @fileSubmissionId = FileSubmissionId from App.FileSubmissions where FileSubmissionDescription = 'SCHOOL CSI TSI REASON' and GenerateReportId = @GenerateReportId and OrganizationLevelId = 3 and SubmissionYear = '2022-23'
		END
 
		-- FileSubmission_FileColumns, FileColumns
 
		delete from App.FileColumns where FileColumnId in (
			select FileColumnId from App.FileSubmission_FileColumns
			where FileSubmissionId = @fileSubmissionId)
 
		delete from App.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'Amount','String', 'Reason Applicability', 'STATUS')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 314, 'false', 11, 300)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'CarriageReturn/LineFeed','Control Character', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 315, 'false', 12, 315)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'ComprhnsvSupportIdentificationTypeID','String', 'Comprehensive Support and Improvement Type', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 83, 'true', 7, 69)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(200, 'Explanation','String', 'Explanation', 'EXPLANATION')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 299, 'true', 10, 100)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(10, 'FileRecordNumber','Number', 'File Record Number', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 10, 'false', 1, 1)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(1, 'Filler','String', '', '')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 99, 'false', 9, 99)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'FIPSStateCode','String', 'State Code', 'FIPSSTATECODE')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 12, 'false', 2, 11)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(2, 'StateAgencyNumber','String', 'State Agency Number', 'STATEAGENCYNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 14, 'false', 3, 13)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(14, 'StateLEAIDNumber','String', 'LEA Identifier (State)', 'STATELEAIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 28, 'false', 4, 15)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'StateSchoolIDNumber','String', 'School Identifier (State)', 'STATESCHOOLIDNUMBER')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 48, 'false', 5, 29)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(20, 'TableTypeAbbrv','String', 'Table Type Abbreviation', 'TYPEABBRV')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 68, 'false', 6, 49)
 
		INSERT INTO App.FileColumns
		([ColumnLength], [ColumnName], [DataType], [DisplayName], [XMLElementName])
		VALUES
		(15, 'TargetIdentificationSubgrpsID','String', 'Identification Subgroups', 'CATEGORY')
 
		SET @fileColumnId = CAST(SCOPE_IDENTITY() AS INT)
 
		INSERT INTO App.FileSubmission_FileColumns
		([FileSubmissionId], [FileColumnId], [EndPosition], [IsOptional], [SequenceNumber], [StartPosition])
		VALUES
		(@fileSubmissionId, @fileColumnId, 98, 'true', 8, 84)
 
 
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