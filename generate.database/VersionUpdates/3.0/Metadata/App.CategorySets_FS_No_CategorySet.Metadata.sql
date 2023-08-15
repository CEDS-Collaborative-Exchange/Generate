/*
--
-- To generate metadata refresh script, run this on EDENDB on 192.168.71.30
-- To generate categoryset metadata for the file specifications without categoryset
--
-- November 29, 2018
--
set nocount on;

-- Use two most recent school years
--   Note, this means that older, retired file specs will not be updated if they change

declare @latestSchoolYear as int
select @latestSchoolYear = max(ReportingPeriodId) from reportingperiod where substring(ReportingPeriodAbbrv, 1, 1) = '2'

declare @lastSchoolYear as int
select @lastSchoolYear = max(ReportingPeriodId) from reportingperiod where substring(ReportingPeriodAbbrv, 1, 1) = '2' and ReportingPeriodId <> @latestSchoolYear

declare @GenerateReport as varchar(500)
declare @FileTypeDescription as varchar(50)
declare @OrganizationLevelId int
declare @FileRecordLayoutId int
declare @SubmissionYear as varchar(20)
declare @TableTypeId as int
declare @TableTypeGroupId as int
declare @OrganizationLevel as varchar(500)
declare @CategorySetType as varchar(500)
declare @CategorySetCode as varchar(500)
declare @CategorySetName as varchar(500)
declare @GroupNumber as int
declare @TableTypeGroupName as varchar(20)
declare @CategoryCodeId as int
declare @CategoryCodeAbbrv as varchar(200)
declare @CategoryCodeValue as varchar(500)
declare @syName as varchar(20)

DECLARE @fileSpecs TABLE
(
	fileSpec nvarchar(10)
)


insert into @fileSpecs (fileSpec) values ('c206')



print 'set nocount on'
print 'begin try'
print ''
print '	begin transaction'
print ''

print '		DECLARE @recordIds TABLE'
print '		('
print '		Id int'
print '		)'
print ''
print '		declare @GenerateReportId as Int'	
print '		declare @CategorySetId as int'
print '		declare @ToggleSectionTypeId as int'
print '		declare @CategoryId as int'
	
	
print ''
				
print '		declare @seaId as int, @leaId as int, @schId as int'
print '		select @seaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = ''sea'''
print '		select @leaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = ''lea'''
print '		select @schId = OrganizationLevelId from app.OrganizationLevels where LevelCode = ''sch'''
print ''
print '		declare @edfactsSubmissionReportTypeId as int'
print '		select @edfactsSubmissionReportTypeId = GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode = ''edfactsreport'''

DECLARE report_cursor CURSOR FOR 
Select distinct 'c' + substring(fsd.FileSpecificationDocumentNumber, 2, 3) as GenerateReport
from FileSpecificationDocument fsd
inner join DataElement_x_FileSpecificationDocument defsd on fsd.FileSpecificationDocumentId = defsd.FileSpecificationDocumentId
inner join DataElement_x_Code dc on dc.[DataElementID] = defsd.[DataElementID]
where fsd.FileSpecificationDocumentNumber like 'N206%'
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

	declare @rowCntr as int
	set @rowCntr = 0

	DECLARE categoryset_cursor CURSOR FOR 
	select DISTINCT null as TableTypeId, 0 as TableTypeGroupId,
	'sch' as OrganizationLevel,
	'CategorySet' as CategorySetType,
	NULL AS GroupNumber,
	'2018-19' AS ReportingPeriodAbbrv,
	NULL AS TableTypeGroupName
	from FileSpecificationDocument fsd
	inner join DataElement_x_FileSpecificationDocument defsd on fsd.FileSpecificationDocumentId = defsd.FileSpecificationDocumentId
	where fsd.FileSpecificationDocumentNumber like 'N%'
	and fsd.FileSpecificationDocumentNumber = 'N' + replace(@GenerateReport, 'c', '')

	declare @oldSetType as varchar(500)
	declare @oldReport as varchar(500)
	declare @setCntr as int

	set @setCntr = 0

	OPEN categoryset_cursor
	FETCH NEXT FROM categoryset_cursor INTO @TableTypeId, @TableTypeGroupId, @OrganizationLevel, @CategorySetType, @GroupNumber, @SubmissionYear, @TableTypeGroupName

	WHILE @@FETCH_STATUS = 0
	BEGIN

		set @rowCntr = @rowCntr + 1
		set @setCntr = @setCntr + 1

		if @oldReport <> @GenerateReport or @oldSetType <> @CategorySetType
		begin
			set @setCntr = 1
		end

		set @CategorySetCode = @CategorySetType
		set @CategorySetName = @CategorySetType

		set @CategorySetCode = 'CategorySet' + char(64 + @setCntr)
		set @CategorySetName = 'Category Set ' + char(64 + @setCntr)



		print '		insert into @recordIds (Id) values (' + convert(varchar(20), @TableTypeGroupId) + ')'
		print ''

		print '		-- CategorySets'
		print ''		
		print '		INSERT INTO app.CategorySets'
		print '		(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)'	
		print '		VALUES'
		print '		(@GenerateReportId, @' + @OrganizationLevel + 'Id, '  + convert(varchar(20), @TableTypeGroupId) + ', ''' + left(convert(varchar(20), @SubmissionYear),4) + '-' + right(convert(varchar(20), @SubmissionYear),2) + ''', ''' + @CategorySetCode + ''', ''' + @CategorySetName + ''')'
		print ''
		print '		SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)'
		print ''	

		print ''
		print '		-- CategorySet_Categories, CategoryOptions'
		print ''		
		print '		delete from App.CategoryOptions where CategorySetId = @CategorySetId'
		print '		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId'
		print ''

		declare @edfactsCategoryId as int
		declare @CodeGroup nvarchar(50), @CodeValue nvarchar(50)

		DECLARE categorysetcategory_cursor CURSOR FOR 
		Select distinct  c.CodeGroup, c.CodeValue
		from FileSpecificationDocument fsd
		inner join DataElement_x_FileSpecificationDocument defsd on fsd.FileSpecificationDocumentId = defsd.FileSpecificationDocumentId
		inner join DataElement_x_Code dc on dc.[DataElementID] = defsd.[DataElementID]
		inner join Code c on c.CodeId = dc.CodeId
		where fsd.FileSpecificationDocumentNumber like 'N206%'


		OPEN categorysetcategory_cursor
		FETCH NEXT FROM categorysetcategory_cursor INTO @CodeGroup, @CodeValue

		WHILE @@FETCH_STATUS = 0
		BEGIN
			print '		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = ''' + @CodeGroup + ''')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES (''' +  @CodeGroup + ''','  + '''' + @CodeValue + ''', 0)'		
									
			print '		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = ''' + convert(varchar(50), @CodeGroup) + ''''
			print ''	
			print '		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		'							
			print '		INSERT INTO App.CategorySet_Categories'
			print '			([CategorySetId], [CategoryId])'
			print '			VALUES'
			print '			(@CategorySetId, @CategoryId)'
			print ''

			DECLARE categoryoption_cursor CURSOR FOR 
			Select c.CodeAbbrv, c.Codevalue
				from FileSpecificationDocument fsd
				inner join DataElement_x_FileSpecificationDocument defsd on fsd.FileSpecificationDocumentId = defsd.FileSpecificationDocumentId
				inner join DataElement_x_Code dc on dc.[DataElementID] = defsd.[DataElementID]
				inner join Code c on c.CodeId = dc.CodeId
				where fsd.FileSpecificationDocumentNumber like 'N206%'
				and c.CodeGroup = @CodeGroup

			declare @CodeAbbrv nvarchar(50)
			OPEN categoryoption_cursor
			FETCH NEXT FROM categoryoption_cursor INTO  @CategoryCodeAbbrv, @CategoryCodeValue

			WHILE @@FETCH_STATUS = 0
			BEGIN
			    print '		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = ''' + @CategoryCodeAbbrv + ''')'
				print '			BEGIN '
				print '				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) '
				print '				VALUES (@CategorySetId, @CategoryId, ''' + @CategoryCodeAbbrv + ''', ''' + replace(@CategoryCodeValue, '''', '''''') + ''', 0)'
				print '			END '
				print ''

				FETCH NEXT FROM categoryoption_cursor INTO  @CategoryCodeAbbrv, @CategoryCodeValue
			END

			CLOSE categoryoption_cursor
			DEALLOCATE categoryoption_cursor


			FETCH NEXT FROM categorysetcategory_cursor INTO @CodeGroup, @CodeValue
		END

		CLOSE categorysetcategory_cursor
		DEALLOCATE categorysetcategory_cursor


		print ''
		set @oldReport = @GenerateReport
		set @oldSetType = @CategorySetType

		FETCH NEXT FROM categoryset_cursor INTO @TableTypeId, @TableTypeGroupId, @OrganizationLevel, @CategorySetType, @GroupNumber, @SubmissionYear, @TableTypeGroupName
	END

	CLOSE categoryset_cursor
	DEALLOCATE categoryset_cursor
				
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

/***************************************************************************
*
*	Updated on December 20th, 2018
*   Please remove the ID after run the script if there is 'ID' as suffix
*
***************************************************************************/

set nocount on
begin try
 
	begin transaction
 
		DECLARE @recordIds TABLE
		(
		Id int
		)
 
		declare @GenerateReportId as Int
		declare @CategorySetId as int
		declare @ToggleSectionTypeId as int
		declare @CategoryId as int
 
		declare @seaId as int, @leaId as int, @schId as int
		select @seaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'sea'
		select @leaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'lea'
		select @schId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'sch'
 
		declare @edfactsSubmissionReportTypeId as int
		select @edfactsSubmissionReportTypeId = GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode = 'edfactsreport'
 
		----------------------
		-- c206
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c206' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (0)
 
		-- CategorySets
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySets] WHERE GenerateReportId = @GenerateReportId and OrganizationLevelId = @schId and  SubmissionYear = '2018-19' and CategorySetCode = 'CSA')
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 0, '2018-19', 'CSA', 'Category Set A')
 
		SELECT @CategorySetId = CategorySetId FROM [App].[CategorySets] WHERE GenerateReportId = @GenerateReportId and OrganizationLevelId = @schId and  SubmissionYear = '2018-19' and CategorySetCode = 'CSA'
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'COMPREHENSIVESUPPORTIDENTIFICATIONTYPE')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES ('COMPREHENSIVESUPPORTIDENTIFICATIONTYPE','Additional targeted support school not exiting suc', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'COMPREHENSIVESUPPORTIDENTIFICATIONTYPE'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSILOWPERF')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSILOWPERF', 'Lowest-performing school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSILOWGR')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSILOWGR', 'Low graduation rate high school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIOTHER')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIOTHER', 'Additional targeted support school not exiting such status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'Missing', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'COMPREHENSIVESUPPORTIDENTIFICATIONTYPE')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES ('COMPREHENSIVESUPPORTIDENTIFICATIONTYPE','Low graduation rate high school', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'COMPREHENSIVESUPPORTIDENTIFICATIONTYPE'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSILOWPERF')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSILOWPERF', 'Lowest-performing school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSILOWGR')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSILOWGR', 'Low graduation rate high school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIOTHER')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIOTHER', 'Additional targeted support school not exiting such status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'Missing', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'COMPREHENSIVESUPPORTIDENTIFICATIONTYPE')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES ('COMPREHENSIVESUPPORTIDENTIFICATIONTYPE','Lowest-performing school', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'COMPREHENSIVESUPPORTIDENTIFICATIONTYPE'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSILOWPERF')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSILOWPERF', 'Lowest-performing school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSILOWGR')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSILOWGR', 'Low graduation rate high school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIOTHER')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIOTHER', 'Additional targeted support school not exiting such status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'Missing', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'COMPREHENSIVESUPPORTIDENTIFICATIONTYPE')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES ('COMPREHENSIVESUPPORTIDENTIFICATIONTYPE','Missing', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'COMPREHENSIVESUPPORTIDENTIFICATIONTYPE'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSILOWPERF')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSILOWPERF', 'Lowest-performing school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSILOWGR')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSILOWGR', 'Low graduation rate high school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIOTHER')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIOTHER', 'Additional targeted support school not exiting such status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'Missing', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES ('COMPREHENSIVETARGETEDSUPPORTSCHTYPE','Comprehensive Support and Improvement', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSITSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'Missing', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES ('COMPREHENSIVETARGETEDSUPPORTSCHTYPE','Comprehensive Support and Improvement – Exit Statu', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSITSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'Missing', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES ('COMPREHENSIVETARGETEDSUPPORTSCHTYPE','Missing', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSITSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'Missing', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES ('COMPREHENSIVETARGETEDSUPPORTSCHTYPE','Not Comprehensive Support and Improvement or Targe', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSITSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'Missing', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES ('COMPREHENSIVETARGETEDSUPPORTSCHTYPE','Small school', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSITSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'Missing', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES ('COMPREHENSIVETARGETEDSUPPORTSCHTYPE','Targeted Support and Improvement', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSITSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'Missing', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES ('COMPREHENSIVETARGETEDSUPPORTSCHTYPE','Targeted Support and Improvement – Exit Status', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'COMPREHENSIVETARGETEDSUPPORTSCHTYPE'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSITSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSITSI', 'Not Comprehensive Support and Improvement or Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'Missing', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'TARGETEDSUPPORTIDENTIFICATIONTYPE')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES ('TARGETEDSUPPORTIDENTIFICATIONTYPE','Additional targeted support and improvement school', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'TARGETEDSUPPORTIDENTIFICATIONTYPE'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIUNDER ')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIUNDER ', 'Consistently underperforming low-performing subgroups school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIOTHER')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIOTHER', 'Additional targeted support and improvement school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'Missing', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'TARGETEDSUPPORTIDENTIFICATIONTYPE')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES ('TARGETEDSUPPORTIDENTIFICATIONTYPE','Consistently underperforming low-performing subgro', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'TARGETEDSUPPORTIDENTIFICATIONTYPE'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIUNDER ')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIUNDER ', 'Consistently underperforming low-performing subgroups school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIOTHER')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIOTHER', 'Additional targeted support and improvement school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'Missing', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'TARGETEDSUPPORTIDENTIFICATIONTYPE')
							INSERT INTO [App].[Categories] 
								([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
								VALUES ('TARGETEDSUPPORTIDENTIFICATIONTYPE','Missing', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'TARGETEDSUPPORTIDENTIFICATIONTYPE'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIUNDER ')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIUNDER ', 'Consistently underperforming low-performing subgroups school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIOTHER')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIOTHER', 'Additional targeted support and improvement school', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'Missing', 0)
			END 
 
 
	-- Set App.CategorySets.TableTypeId
	update app.CategorySets set TableTypeId = (select TableTypeId from App.TableTypes where EdFactsTableTypeId = cs.EdFactsTableTypeId)
	from App.CategorySets cs
	where (cs.TableTypeId is null or cs.TableTypeId = 0) and cs.EdFactsTableTypeId is not null


 
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
