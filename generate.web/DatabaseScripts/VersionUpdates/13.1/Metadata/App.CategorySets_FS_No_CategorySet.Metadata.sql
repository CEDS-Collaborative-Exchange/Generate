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
select @latestSchoolYear = max(ReportingPeriodId) from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.reportingperiod where substring(ReportingPeriodAbbrv, 1, 1) = '2'

declare @lastSchoolYear as int
select @lastSchoolYear = max(ReportingPeriodId) from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.reportingperiod where substring(ReportingPeriodAbbrv, 1, 1) = '2' and ReportingPeriodId <> @latestSchoolYear

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
from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.FileSpecificationDocument fsd
inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.DataElement_x_FileSpecificationDocument defsd on fsd.FileSpecificationDocumentId = defsd.FileSpecificationDocumentId
inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.DataItem di on defsd.DataElementID = di.DataElementID
left outer join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.DataItem_x_Code dicode on dicode.DataItemID = di.DataItemID
inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.Code c on dicode.CodeID = c.CodeID
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

	declare @oldSetType as varchar(500)
	declare @oldReport as varchar(500)
	declare @setCntr as int

	set @setCntr = 0
	set @TableTypeId = NULL
	set @TableTypeGroupId = 0
	set @OrganizationLevel = 'sch'
	set @CategorySetType = 'CategorySet' 
	set @GroupNumber = NULL
	set @SubmissionYear ='2022-23'
	set @TableTypeGroupName =NULL

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
	from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.FileSpecificationDocument fsd
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.DataElement_x_FileSpecificationDocument defsd on fsd.FileSpecificationDocumentId = defsd.FileSpecificationDocumentId
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.DataItem di on defsd.DataElementID = di.DataElementID
	left outer join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.DataItem_x_Code dicode on dicode.DataItemID = di.DataItemID
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.Code c on c.CodeId = dicode.CodeId
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
			from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.FileSpecificationDocument fsd
			inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.DataElement_x_FileSpecificationDocument defsd on fsd.FileSpecificationDocumentId = defsd.FileSpecificationDocumentId
			inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.DataItem di on defsd.DataElementID = di.DataElementID
			left outer join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.DataItem_x_Code dicode on dicode.DataItemID = di.DataItemID
			inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.Code c on c.CodeId = dicode.CodeId
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
*	Updated on January 24, 2023
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
 
		INSERT INTO app.CategorySets
		(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
		VALUES
		(@GenerateReportId, @schId, 0, '2022-23', 'CategorySetA', 'Category Set A')
 
		SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'AddlTrgtSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('AddlTrgtSupImprvmntID','Additional Targeted Support and Improvement', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'AddlTrgtSupImprvmntID'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'AddlTrgtSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('AddlTrgtSupImprvmntID','Additional Targeted Support and Improvement – Exit', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'AddlTrgtSupImprvmntID'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'AddlTrgtSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('AddlTrgtSupImprvmntID','MISSING', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'AddlTrgtSupImprvmntID'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'AddlTrgtSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('AddlTrgtSupImprvmntID','Not Additional Targeted Support and Improvement', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'AddlTrgtSupImprvmntID'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'AddlTrgtSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('AddlTrgtSupImprvmntID','Small School', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'AddlTrgtSupImprvmntID'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSI', 'Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTADDLTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTADDLTSI', 'Not Additional Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'ADDLTSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'ADDLTSIEXIT', 'Additional Targeted Support and Improvement – Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'CompSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('CompSupImprvmntID','Comprehensive Support and Improvement', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'CompSupImprvmntID'
 
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
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'CompSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('CompSupImprvmntID','Comprehensive Support and Improvement - Exit Statu', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'CompSupImprvmntID'
 
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
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'CompSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('CompSupImprvmntID','MISSING', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'CompSupImprvmntID'
 
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
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'CompSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('CompSupImprvmntID','Not Comprehensive Support and Improvement', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'CompSupImprvmntID'
 
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
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'CompSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('CompSupImprvmntID','Small School', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'CompSupImprvmntID'
 
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
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSI', 'Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'CSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'CSIEXIT', 'Comprehensive Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTCSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTCSI', 'Not Comprehensive Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'TrgtSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('TrgtSupImprvmntID','MISSING', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'TrgtSupImprvmntID'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'TrgtSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('TrgtSupImprvmntID','Not Targeted Support and Improvement', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'TrgtSupImprvmntID'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'TrgtSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('TrgtSupImprvmntID','Small School', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'TrgtSupImprvmntID'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'TrgtSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('TrgtSupImprvmntID','Targeted Support and Improvement', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'TrgtSupImprvmntID'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[Categories] WHERE [CategoryCode] = 'TrgtSupImprvmntID')
						INSERT INTO [App].[Categories] 
							([CategoryCode] ,[CategoryName], [EdFactsCategoryId])		
							VALUES ('TrgtSupImprvmntID','Targeted Support and Improvement - Exit Status', 0)
		SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'TrgtSupImprvmntID'
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategorySet_Categories] WHERE [CategorySetId] = @CategorySetId and [CategoryId] = @CategoryId)		
		INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSIEXIT')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSIEXIT', 'Targeted Support and Improvement - Exit Status', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'SMALLSCH')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'SMALLSCH', 'Small School', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'TSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'TSI', 'Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'NOTTSI')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'NOTTSI', 'Not Targeted Support and Improvement', 0)
			END 
 
		IF NOT EXISTS (SELECT 1 FROM [App].[CategoryOptions] co WHERE co.CategoryId = @CategoryId AND CategoryOptionCode = 'MISSING')
			BEGIN 
				INSERT INTO App.CategoryOptions (CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
				VALUES (@CategorySetId, @CategoryId, 'MISSING', 'MISSING', 0)
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