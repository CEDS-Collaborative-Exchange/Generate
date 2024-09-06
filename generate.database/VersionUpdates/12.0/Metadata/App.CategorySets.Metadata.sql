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

	if (@GenerateReport = 'c035')
	begin
		set @latestSchoolYear = @latestSchoolYear - 6
		set @lastSchoolYear = @lastSchoolYear - 6
	end
	

	declare @rowCntr as int
	set @rowCntr = 0

	DECLARE categoryset_cursor CURSOR FOR 
	select ttg.TableTypeId, ttg.TableTypeGroupId,
	case
		when ttg.EducationLevelId = 1 then 'sea'
		when ttg.EducationLevelId = 2 then 'lea'
		when ttg.EducationLevelId = 3 then 'sch'
		else '???'
	end
	as OrganizationLevel,
	case when 
		ttg.TotalIndicator = 0 then 'CategorySet'
		else 'Subtotal'
	end as CategorySetType,
	ttg.GroupNumber,
	sy.ReportingPeriodAbbrv,
	ttg.TableTypeGroupName
	from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.FileSpecificationDocument fsd
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.DataElement_x_FileSpecificationDocument defsd on fsd.FileSpecificationDocumentId = defsd.FileSpecificationDocumentId
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.TableType_x_DataElement ttde on defsd.DataElementId = ttde.DataElementId
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.TableTypeGroup ttg on ttde.TableTypeId = ttg.TableTypeId
	and ttg.ReportingPeriodId = defsd.ReportingPeriodId
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.ReportingPeriod rp on ttg.ReportingPeriodId = rp.ReportingPeriodId
	inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.ReportingPeriod sy on rp.SchoolYearId = sy.ReportingPeriodId
	and sy.ReportingPeriodId in (@latestSchoolYear, @lastSchoolYear)
	where fsd.FileSpecificationDocumentNumber like 'N%'
	and fsd.FileSpecificationDocumentNumber = 'N' + replace(@GenerateReport, 'c', '')
	order by sy.SchoolYearId, fsd.FileSpecificationDocumentNumber, ttg.EducationLevelId, ttg.TotalIndicator, ttg.GroupNumber

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

		if @TableTypeGroupName is null or len(@TableTypeGroupName) < 3
		begin

			if @CategorySetType = 'CategorySet'
			begin
				set @CategorySetCode = 'CategorySet?' + char(64 + @setCntr)
				set @CategorySetName = 'Category Set? ' + char(64 + @setCntr)
			end
			else
			begin
				set @CategorySetCode = 'Subtotal?' + convert(varchar(200), @setCntr)
				set @CategorySetName = 'Subtotal? ' + convert(varchar(200), @setCntr)
			end

		end
		else
		begin
			set @CategorySetCode = @TableTypeGroupName
						
			if @TableTypeGroupName = 'EUT'
			begin
				set @CategorySetCode = 'TOT' -- setting to TOT so that it sorts at the end
				set @CategorySetName = 'Total of the Education Unit'
			end
			else if left(@TableTypeGroupName,2) = 'ST'
			begin
				set @CategorySetName = 'Subtotal ' + replace(@TableTypeGroupName, 'ST', '')
			end
			else if left(@TableTypeGroupName,2) = 'CS'
			begin
				set @CategorySetName = 'Category Set ' + replace(@TableTypeGroupName, 'CS', '')
			end


		end

		print '		insert into @recordIds (Id) values (' + convert(varchar(20), @TableTypeGroupId) + ')'
		print ''


		print '		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = ' + convert(varchar(20), @TableTypeGroupId) + ')'
		print '		BEGIN'

		print '			-- CategorySets'
		print ''		
		print '			INSERT INTO app.CategorySets'
		print '			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)'	
		print '			VALUES'
		print '			(@GenerateReportId, @' + @OrganizationLevel + 'Id, ' + convert(varchar(20), @TableTypeId) + ', ' + convert(varchar(20), @TableTypeGroupId) + ', ''' + right(convert(varchar(20), @SubmissionYear),4) + ''', ''' + @CategorySetCode + ''', ''' + @CategorySetName + ''')'
		print ''
		print '			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)'
		print ''	
		PRINT '		END'
		print '		ELSE'
		print '		BEGIN'
		print ''
		PRINT '			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = ' + convert(varchar(20), @TableTypeGroupId)

		print '			-- CategorySets'
		print ''		
		print '			UPDATE app.CategorySets'
		print '			SET EdFactsTableTypeId = ' + convert(varchar(20), @TableTypeId) + ', GenerateReportId = @GenerateReportId, OrganizationLevelId = @' + @OrganizationLevel + 'Id, SubmissionYear = ''' + right(convert(varchar(20), @SubmissionYear),4) + ''', CategorySetCode = ''' + @CategorySetCode + ''', CategorySetName = ''' + @CategorySetName + ''''
		print '			WHERE CategorySetId = @CategorySetId'

		print ''
		print '		END'

		print ''
		print '		-- CategorySet_Categories, CategoryOptions'
		print ''		
		print '		delete from App.CategoryOptions where CategorySetId = @CategorySetId'
		print '		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId'
		print ''

		declare @edfactsCategoryId as int

		DECLARE categorysetcategory_cursor CURSOR FOR 
		select distinct ttg.TableTypeGroupId,c.CategoryId
		from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.TableTypeGroup ttg 
		inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.TableTypeGroup_x_CategoryCode ttgcc on ttg.TableTypeGroupId = ttgcc.TableTypeGroupId
		inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.Category c on ttgcc.CategoryId = c.CategoryId
		where ttg.TableTypeGroupId = @TableTypeGroupId
		and c.CategoryId <> -100
		order by ttg.TableTypeGroupId, c.CategoryId

		OPEN categorysetcategory_cursor
		FETCH NEXT FROM categorysetcategory_cursor INTO @TableTypeGroupId, @edfactsCategoryId

		WHILE @@FETCH_STATUS = 0
		BEGIN
									
			print '		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = ' + convert(varchar(20), @edfactsCategoryId)
			print ''										
			print '		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )'
			print '		BEGIN'
			print '			INSERT INTO App.CategorySet_Categories'
			print '			([CategorySetId], [CategoryId])'
			print '			VALUES'
			print '			(@CategorySetId, @CategoryId)'
			print '		END'
			print ''

			DECLARE categoryoption_cursor CURSOR FOR 
			select distinct cc.CategoryCodeId, cc.CategoryCodeAbbrv, cc.CategoryCodeValue
			from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.TableTypeGroup ttg 
			inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.TableTypeGroup_x_CategoryCode ttgcc on ttg.TableTypeGroupId = ttgcc.TableTypeGroupId
			inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.Category c on ttgcc.CategoryId = c.CategoryId
			inner join [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.CategoryCode cc on ttgcc.CategoryCodeId = cc.CategoryCodeId
			where ttg.TableTypeGroupId = @TableTypeGroupId
			and ttgcc.CategoryID = @edfactsCategoryId
			and c.CategoryId <> -100
			order by cc.CategoryCodeId


			OPEN categoryoption_cursor
			FETCH NEXT FROM categoryoption_cursor INTO  @CategoryCodeId, @CategoryCodeAbbrv, @CategoryCodeValue

			WHILE @@FETCH_STATUS = 0
			BEGIN

				PRINT ''
				print '		INSERT INTO App.CategoryOptions'
				print '		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) '
				print '		values'
				print '		(@CategorySetId, @CategoryId, ''' + @CategoryCodeAbbrv + ''', ''' + replace(@CategoryCodeValue, '''', '''''') + ''', ' + convert(varchar(20), @CategoryCodeId) + ' )'
				print ''

				FETCH NEXT FROM categoryoption_cursor INTO  @CategoryCodeId, @CategoryCodeAbbrv, @CategoryCodeValue
			END

			CLOSE categoryoption_cursor
			DEALLOCATE categoryoption_cursor


			FETCH NEXT FROM categorysetcategory_cursor INTO @TableTypeGroupId, @edfactsCategoryId
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

	select @latestSchoolYear = max(ReportingPeriodId) from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.reportingperiod where ReportingPeriodValue = @generateMaxSchoolYear
	select @lastSchoolYear = max(ReportingPeriodId) from [SQL01.EDMITS-AEM.COM,3748].EDENDB.dbo.reportingperiod where substring(ReportingPeriodAbbrv, 1, 1) = '2' 
	and ReportingPeriodId < @latestSchoolYear

					
	FETCH NEXT FROM report_cursor INTO @GenerateReport
	END

CLOSE report_cursor
DEALLOCATE report_cursor
	
-- Do not include this delete, since there may be some non-EDFacts data in there and we are also not including all school years
--print '	delete from app.CategoryOptions where CategorySetId in (select CategorySetId from App.CategorySets where EdFactsTableTypeGroupId not in (select Id from @recordIds))'	
--print '	delete from app.CategorySets where EdFactsTableTypeGroupId not in (select Id from @recordIds)'
--print ''

print '	-- Set App.CategorySets.TableTypeId'
print '	update app.CategorySets set TableTypeId = (select TableTypeId from App.TableTypes where EdFactsTableTypeId = cs.EdFactsTableTypeId)'
print '	from App.CategorySets cs'
print '	where (cs.TableTypeId is null or cs.TableTypeId = 0) and cs.EdFactsTableTypeId is not null'
print ''


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
*	Updated on 1/24/2023
*
*************************************************************/

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
		-- c002
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c002' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (21284)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21284)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 21284, '2022', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21284
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21285)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21285)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 21285, '2022', 'CSB', 'Category Set B')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21285
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'CSB', CategorySetName = 'Category Set B'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21293)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21293)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 21293, '2022', 'CSC', 'Category Set C')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21293
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'CSC', CategorySetName = 'Category Set C'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21286)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21286)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 21286, '2022', 'CSD', 'Category Set D')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21286
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'CSD', CategorySetName = 'Category Set D'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21290)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21290)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 21290, '2022', 'CSE', 'Category Set E')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21290
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'CSE', CategorySetName = 'Category Set E'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21294)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21294)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 21294, '2022', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21294
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21295)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21295)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 21295, '2022', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21295
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
 
		insert into @recordIds (Id) values (21296)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21296)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 21296, '2022', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21296
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
 
		insert into @recordIds (Id) values (21311)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21311)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 21311, '2022', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21311
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (21314)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21314)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 21314, '2022', 'ST5', 'Subtotal 5')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21314
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST5', CategorySetName = 'Subtotal 5'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
 
		insert into @recordIds (Id) values (21317)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21317)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 21317, '2022', 'ST6', 'Subtotal 6')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21317
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST6', CategorySetName = 'Subtotal 6'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21320)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21320)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 21320, '2022', 'ST7', 'Subtotal 7')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21320
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST7', CategorySetName = 'Subtotal 7'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21297)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21297)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 21297, '2022', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21297
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into @recordIds (Id) values (21287)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21287)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 21287, '2022', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21287
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21288)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21288)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 21288, '2022', 'CSB', 'Category Set B')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21288
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'CSB', CategorySetName = 'Category Set B'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21298)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21298)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 21298, '2022', 'CSC', 'Category Set C')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21298
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'CSC', CategorySetName = 'Category Set C'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21289)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21289)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 21289, '2022', 'CSD', 'Category Set D')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21289
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'CSD', CategorySetName = 'Category Set D'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21291)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21291)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 21291, '2022', 'CSE', 'Category Set E')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21291
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'CSE', CategorySetName = 'Category Set E'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21299)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21299)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 21299, '2022', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21299
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21300)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21300)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 21300, '2022', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21300
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
 
		insert into @recordIds (Id) values (21301)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21301)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 21301, '2022', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21301
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
 
		insert into @recordIds (Id) values (21312)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21312)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 21312, '2022', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21312
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (21315)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21315)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 21315, '2022', 'ST5', 'Subtotal 5')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21315
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST5', CategorySetName = 'Subtotal 5'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
 
		insert into @recordIds (Id) values (21318)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21318)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 21318, '2022', 'ST6', 'Subtotal 6')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21318
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST6', CategorySetName = 'Subtotal 6'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21321)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21321)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 21321, '2022', 'ST7', 'Subtotal 7')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21321
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST7', CategorySetName = 'Subtotal 7'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21302)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21302)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 21302, '2022', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21302
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into @recordIds (Id) values (21308)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21308)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 21308, '2022', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21308
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21309)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21309)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 21309, '2022', 'CSB', 'Category Set B')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21309
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'CSB', CategorySetName = 'Category Set B'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21303)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21303)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 21303, '2022', 'CSC', 'Category Set C')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21303
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'CSC', CategorySetName = 'Category Set C'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21310)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21310)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 21310, '2022', 'CSD', 'Category Set D')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21310
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'CSD', CategorySetName = 'Category Set D'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21292)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21292)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 21292, '2022', 'CSE', 'Category Set E')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21292
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'CSE', CategorySetName = 'Category Set E'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21304)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21304)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 21304, '2022', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21304
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21305)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21305)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 21305, '2022', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21305
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
 
		insert into @recordIds (Id) values (21306)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21306)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 21306, '2022', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21306
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
 
		insert into @recordIds (Id) values (21313)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21313)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 21313, '2022', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21313
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (21316)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21316)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 21316, '2022', 'ST5', 'Subtotal 5')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21316
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'ST5', CategorySetName = 'Subtotal 5'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
 
		insert into @recordIds (Id) values (21319)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21319)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 21319, '2022', 'ST6', 'Subtotal 6')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21319
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'ST6', CategorySetName = 'Subtotal 6'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21322)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21322)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 21322, '2022', 'ST7', 'Subtotal 7')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21322
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'ST7', CategorySetName = 'Subtotal 7'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (21307)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21307)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 21307, '2022', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21307
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into @recordIds (Id) values (22184)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22184)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 22184, '2023', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22184
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22185)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22185)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 22185, '2023', 'CSB', 'Category Set B')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22185
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'CSB', CategorySetName = 'Category Set B'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22193)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22193)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 22193, '2023', 'CSC', 'Category Set C')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22193
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'CSC', CategorySetName = 'Category Set C'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22186)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22186)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 22186, '2023', 'CSD', 'Category Set D')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22186
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'CSD', CategorySetName = 'Category Set D'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22190)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22190)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 22190, '2023', 'CSE', 'Category Set E')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22190
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'CSE', CategorySetName = 'Category Set E'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22194)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22194)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 22194, '2023', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22194
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22195)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22195)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 22195, '2023', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22195
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
 
		insert into @recordIds (Id) values (22196)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22196)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 22196, '2023', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22196
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
 
		insert into @recordIds (Id) values (22211)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22211)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 22211, '2023', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22211
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (22214)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22214)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 22214, '2023', 'ST5', 'Subtotal 5')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22214
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST5', CategorySetName = 'Subtotal 5'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
 
		insert into @recordIds (Id) values (22217)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22217)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 22217, '2023', 'ST6', 'Subtotal 6')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22217
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST6', CategorySetName = 'Subtotal 6'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22220)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22220)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 22220, '2023', 'ST7', 'Subtotal 7')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22220
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST7', CategorySetName = 'Subtotal 7'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22197)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22197)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 19, 22197, '2023', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22197
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into @recordIds (Id) values (22187)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22187)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 22187, '2023', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22187
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22188)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22188)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 22188, '2023', 'CSB', 'Category Set B')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22188
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'CSB', CategorySetName = 'Category Set B'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22198)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22198)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 22198, '2023', 'CSC', 'Category Set C')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22198
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'CSC', CategorySetName = 'Category Set C'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22189)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22189)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 22189, '2023', 'CSD', 'Category Set D')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22189
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'CSD', CategorySetName = 'Category Set D'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22191)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22191)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 22191, '2023', 'CSE', 'Category Set E')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22191
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'CSE', CategorySetName = 'Category Set E'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22199)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22199)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 22199, '2023', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22199
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22200)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22200)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 22200, '2023', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22200
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
 
		insert into @recordIds (Id) values (22201)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22201)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 22201, '2023', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22201
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
 
		insert into @recordIds (Id) values (22212)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22212)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 22212, '2023', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22212
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (22215)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22215)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 22215, '2023', 'ST5', 'Subtotal 5')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22215
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST5', CategorySetName = 'Subtotal 5'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
 
		insert into @recordIds (Id) values (22218)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22218)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 22218, '2023', 'ST6', 'Subtotal 6')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22218
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST6', CategorySetName = 'Subtotal 6'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22221)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22221)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 22221, '2023', 'ST7', 'Subtotal 7')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22221
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST7', CategorySetName = 'Subtotal 7'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22202)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22202)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 19, 22202, '2023', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22202
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into @recordIds (Id) values (22208)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22208)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 22208, '2023', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22208
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22209)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22209)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 22209, '2023', 'CSB', 'Category Set B')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22209
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'CSB', CategorySetName = 'Category Set B'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22203)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22203)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 22203, '2023', 'CSC', 'Category Set C')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22203
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'CSC', CategorySetName = 'Category Set C'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22210)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22210)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 22210, '2023', 'CSD', 'Category Set D')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22210
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'CSD', CategorySetName = 'Category Set D'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22192)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22192)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 22192, '2023', 'CSE', 'Category Set E')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22192
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'CSE', CategorySetName = 'Category Set E'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22204)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22204)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 22204, '2023', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22204
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22205)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22205)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 22205, '2023', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22205
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
 
		insert into @recordIds (Id) values (22206)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22206)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 22206, '2023', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22206
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
 
		insert into @recordIds (Id) values (22213)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22213)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 22213, '2023', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22213
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (22216)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22216)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 22216, '2023', 'ST5', 'Subtotal 5')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22216
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'ST5', CategorySetName = 'Subtotal 5'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
 
		insert into @recordIds (Id) values (22219)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22219)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 22219, '2023', 'ST6', 'Subtotal 6')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22219
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'ST6', CategorySetName = 'Subtotal 6'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22222)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22222)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 22222, '2023', 'ST7', 'Subtotal 7')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22222
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'ST7', CategorySetName = 'Subtotal 7'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 139
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Age 10', 826 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Age 11', 829 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Age 12', 832 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Age 13', 837 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '14', 'Age 14', 841 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '15', 'Age 15', 845 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '16', 'Age 16', 848 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '17', 'Age 17', 849 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '18', 'Age 18', 850 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '19', 'Age 19', 852 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '20', 'Age 20', 857 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '21', 'Age 21', 858 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '6', 'Age 6', 870 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '7', 'Age 7', 874 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '8', 'Age 8', 875 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '9', 'Age 9', 897 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05K', 'Age 5 (Kindergarten)', 9452 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 152
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HH', 'Homebound/Hospital', 994 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CF', 'Correctional Facilities', 2791 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PPPS', 'Parentally placed in private schools', 2792 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC80', 'Inside regular class 80% or more of the day', 2793 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC79TO40', 'Inside regular class 40% through 79% of the day', 2794 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RC39', 'Inside regular class less than 40% of the day', 2795 )
 
 
		insert into @recordIds (Id) values (22207)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22207)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 19, 22207, '2023', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22207
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 19, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
 
		----------------------
		-- c029
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c029' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
 
		----------------------
		-- c033
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c033' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
 
		----------------------
		-- c039
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c039' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
 
		----------------------
		-- c052
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c052' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (21229)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21229)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 33, 21229, '2022', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21229
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21230)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21230)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 33, 21230, '2022', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21230
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (21231)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21231)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 33, 21231, '2022', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21231
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21232)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21232)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 33, 21232, '2022', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21232
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21226)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21226)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 33, 21226, '2022', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21226
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
 
		insert into @recordIds (Id) values (21233)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21233)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 33, 21233, '2022', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21233
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into @recordIds (Id) values (21216)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21216)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 33, 21216, '2022', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21216
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21217)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21217)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 33, 21217, '2022', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21217
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (21218)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21218)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 33, 21218, '2022', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21218
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21219)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21219)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 33, 21219, '2022', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21219
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21227)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21227)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 33, 21227, '2022', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21227
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
 
		insert into @recordIds (Id) values (21220)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21220)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 33, 21220, '2022', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21220
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into @recordIds (Id) values (21221)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21221)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 33, 21221, '2022', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21221
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21222)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21222)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 33, 21222, '2022', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21222
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (21223)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21223)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 33, 21223, '2022', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21223
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21224)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21224)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 33, 21224, '2022', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21224
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21228)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21228)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 33, 21228, '2022', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21228
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
 
		insert into @recordIds (Id) values (21225)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21225)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 33, 21225, '2022', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21225
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into @recordIds (Id) values (22261)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22261)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 33, 22261, '2023', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22261
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22262)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22262)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 33, 22262, '2023', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22262
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (22263)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22263)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 33, 22263, '2023', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22263
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22264)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22264)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 33, 22264, '2023', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22264
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22258)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22258)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 33, 22258, '2023', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22258
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
 
		insert into @recordIds (Id) values (22265)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22265)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 33, 22265, '2023', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22265
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into @recordIds (Id) values (22248)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22248)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 33, 22248, '2023', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22248
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22249)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22249)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 33, 22249, '2023', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22249
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (22250)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22250)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 33, 22250, '2023', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22250
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22251)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22251)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 33, 22251, '2023', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22251
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22259)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22259)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 33, 22259, '2023', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22259
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
 
		insert into @recordIds (Id) values (22252)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22252)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 33, 22252, '2023', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22252
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into @recordIds (Id) values (22253)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22253)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 33, 22253, '2023', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22253
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22254)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22254)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 33, 22254, '2023', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22254
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (22255)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22255)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 33, 22255, '2023', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22255
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22256)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22256)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 33, 22256, '2023', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22256
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22260)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22260)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 33, 22260, '2023', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22260
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 38
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '01', 'Grade 1', 799 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '02', 'Grade 2', 801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '03', 'Grade 3', 803 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '04', 'Grade 4', 806 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '05', 'Grade 5', 809 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '06', 'Grade 6', 814 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '07', 'Grade 7', 817 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '08', 'Grade 8', 819 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '09', 'Grade 9', 822 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '10', 'Grade 10', 828 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '11', 'Grade 11', 831 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '12', 'Grade 12', 834 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AE', 'Adult Education', 905 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'KG', 'Kindergarten', 1009 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PK', 'Pre-Kindergarten', 1116 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'UG', 'Ungraded', 1196 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '13', 'Grade 13', 8576 )
 
 
		insert into @recordIds (Id) values (22257)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22257)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 33, 22257, '2023', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22257
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 33, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
 
		----------------------
		-- c059
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c059' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
 
		----------------------
		-- c089
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c089' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (21262)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21262)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 21262, '2022', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21262
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 144
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '3', 'Age 3', 861 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '4', 'Age 4', 868 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05NOTK', 'Age 5 (Not Kindergarten)', 9453 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (21264)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21264)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 21264, '2022', 'CSB', 'Category Set B')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21264
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'CSB', CategorySetName = 'Category Set B'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (21266)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21266)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 21266, '2022', 'CSC', 'Category Set C')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21266
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'CSC', CategorySetName = 'Category Set C'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (21268)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21268)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 21268, '2022', 'CSD', 'Category Set D')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21268
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'CSD', CategorySetName = 'Category Set D'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (21270)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21270)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 21270, '2022', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21270
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21272)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21272)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 21272, '2022', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21272
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 144
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '3', 'Age 3', 861 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '4', 'Age 4', 868 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05NOTK', 'Age 5 (Not Kindergarten)', 9453 )
 
 
		insert into @recordIds (Id) values (21271)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21271)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 21271, '2022', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21271
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
 
		insert into @recordIds (Id) values (21278)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21278)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 21278, '2022', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21278
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (21280)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21280)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 21280, '2022', 'ST5', 'Subtotal 5')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21280
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST5', CategorySetName = 'Subtotal 5'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
 
		insert into @recordIds (Id) values (21282)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21282)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 21282, '2022', 'ST6', 'Subtotal 6')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21282
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'ST6', CategorySetName = 'Subtotal 6'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (21273)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21273)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 21273, '2022', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21273
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2022', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into @recordIds (Id) values (21263)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21263)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 21263, '2022', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21263
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 144
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '3', 'Age 3', 861 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '4', 'Age 4', 868 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05NOTK', 'Age 5 (Not Kindergarten)', 9453 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (21265)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21265)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 21265, '2022', 'CSB', 'Category Set B')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21265
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'CSB', CategorySetName = 'Category Set B'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (21267)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21267)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 21267, '2022', 'CSC', 'Category Set C')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21267
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'CSC', CategorySetName = 'Category Set C'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (21269)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21269)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 21269, '2022', 'CSD', 'Category Set D')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21269
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'CSD', CategorySetName = 'Category Set D'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (21274)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21274)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 21274, '2022', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21274
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (21276)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21276)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 21276, '2022', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21276
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 144
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '3', 'Age 3', 861 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '4', 'Age 4', 868 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05NOTK', 'Age 5 (Not Kindergarten)', 9453 )
 
 
		insert into @recordIds (Id) values (21275)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21275)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 21275, '2022', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21275
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
 
		insert into @recordIds (Id) values (21279)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21279)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 21279, '2022', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21279
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (21281)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21281)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 21281, '2022', 'ST5', 'Subtotal 5')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21281
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST5', CategorySetName = 'Subtotal 5'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
 
		insert into @recordIds (Id) values (21283)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21283)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 21283, '2022', 'ST6', 'Subtotal 6')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21283
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'ST6', CategorySetName = 'Subtotal 6'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (21277)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 21277)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 21277, '2022', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 21277
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2022', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into @recordIds (Id) values (22223)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22223)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 22223, '2023', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22223
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 144
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '3', 'Age 3', 861 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '4', 'Age 4', 868 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05NOTK', 'Age 5 (Not Kindergarten)', 9453 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (22225)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22225)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 22225, '2023', 'CSB', 'Category Set B')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22225
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'CSB', CategorySetName = 'Category Set B'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (22227)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22227)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 22227, '2023', 'CSC', 'Category Set C')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22227
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'CSC', CategorySetName = 'Category Set C'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (22229)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22229)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 22229, '2023', 'CSD', 'Category Set D')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22229
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'CSD', CategorySetName = 'Category Set D'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (22231)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22231)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 22231, '2023', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22231
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22233)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22233)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 22233, '2023', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22233
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 144
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '3', 'Age 3', 861 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '4', 'Age 4', 868 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05NOTK', 'Age 5 (Not Kindergarten)', 9453 )
 
 
		insert into @recordIds (Id) values (22232)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22232)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 22232, '2023', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22232
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
 
		insert into @recordIds (Id) values (22239)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22239)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 22239, '2023', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22239
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (22241)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22241)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 22241, '2023', 'ST5', 'Subtotal 5')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22241
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST5', CategorySetName = 'Subtotal 5'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
 
		insert into @recordIds (Id) values (22243)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22243)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 22243, '2023', 'ST6', 'Subtotal 6')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22243
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'ST6', CategorySetName = 'Subtotal 6'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (22234)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22234)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @seaId, 110, 22234, '2023', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22234
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @seaId, SubmissionYear = '2023', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
		insert into @recordIds (Id) values (22224)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22224)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 22224, '2023', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22224
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 144
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '3', 'Age 3', 861 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '4', 'Age 4', 868 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05NOTK', 'Age 5 (Not Kindergarten)', 9453 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (22226)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22226)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 22226, '2023', 'CSB', 'Category Set B')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22226
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'CSB', CategorySetName = 'Category Set B'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (22228)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22228)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 22228, '2023', 'CSC', 'Category Set C')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22228
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'CSC', CategorySetName = 'Category Set C'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (22230)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22230)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 22230, '2023', 'CSD', 'Category Set D')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22230
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'CSD', CategorySetName = 'Category Set D'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (22235)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22235)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 22235, '2023', 'ST1', 'Subtotal 1')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22235
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST1', CategorySetName = 'Subtotal 1'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 138
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'F', 'Female', 976 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'M', 'Male', 1036 )
 
 
		insert into @recordIds (Id) values (22237)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22237)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 22237, '2023', 'ST2', 'Subtotal 2')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22237
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST2', CategorySetName = 'Subtotal 2'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 144
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '3', 'Age 3', 861 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, '4', 'Age 4', 868 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AGE05NOTK', 'Age 5 (Not Kindergarten)', 9453 )
 
 
		insert into @recordIds (Id) values (22236)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22236)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 22236, '2023', 'ST3', 'Subtotal 3')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22236
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST3', CategorySetName = 'Subtotal 3'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 19
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AUT', 'Autism', 917 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DB', 'Deaf-blindness', 944 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'DD', 'Developmental delay', 945 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'EMN', 'Emotional disturbance', 964 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI', 'Hearing impairment', 995 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MD', 'Multiple disabilities', 1041 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OHI', 'Other health impairment', 1093 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'OI', 'Orthopedic impairment', 1094 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLD', 'Specific learning disability', 1163 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SLI', 'Speech or language impairment', 1164 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'TBI', 'Traumatic brain injury', 1180 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'VI', 'Visual impairment', 1203 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ID', 'Intellectual disability', 9498 )
 
 
		insert into @recordIds (Id) values (22240)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22240)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 22240, '2023', 'ST4', 'Subtotal 4')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22240
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST4', CategorySetName = 'Subtotal 4'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 76
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AM7', 'American Indian or Alaska Native', 8324 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'AS7', 'Asian', 8325 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'BL7', 'Black or African American', 8326 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'HI7', 'Hispanic/Latino', 8327 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'PI7', 'Native Hawaiian or Other Pacific Islander', 8328 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WH7', 'White', 8329 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MU7', 'Two or more races', 8330 )
 
 
		insert into @recordIds (Id) values (22242)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22242)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 22242, '2023', 'ST5', 'Subtotal 5')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22242
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST5', CategorySetName = 'Subtotal 5'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 126
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'NLEP', 'Non-English learner', 2060 )
 
 
		insert into @recordIds (Id) values (22244)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22244)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 22244, '2023', 'ST6', 'Subtotal 6')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22244
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'ST6', CategorySetName = 'Subtotal 6'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 145
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'H', 'Home', 990 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'RF', 'Residential Facility', 1139 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SS', 'Separate School', 1170 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SPL', 'Service Provider Location', 2801 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'SC', 'Separate Class', 2802 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YSVCS', 'Services in Regular Early Childhood Program (at least 10 hours)', 8472 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC10YOTHLOC', 'Other Location Regular Early Childhood Program (at least 10 hours)', 8473 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YSVCS', 'Services in Regular Early Childhood Program (less than 10 hours)', 8474 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'REC09YOTHLOC', 'Other Location Regular Early Childhood Program (less than 10 hours)', 8475 )
 
 
		insert into @recordIds (Id) values (22238)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22238)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @leaId, 110, 22238, '2023', 'TOT', 'Total of the Education Unit')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22238
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 110, GenerateReportId = @GenerateReportId, OrganizationLevelId = @leaId, SubmissionYear = '2023', CategorySetCode = 'TOT', CategorySetName = 'Total of the Education Unit'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
 
 
		----------------------
		-- c129
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c129' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
 
		----------------------
		-- c130
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c130' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
 
		----------------------
		-- c190
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c190' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
 
		----------------------
		-- c196
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c196' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
 
		----------------------
		-- c197
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c197' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
 
		----------------------
		-- c198
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c198' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
 
		----------------------
		-- c206
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c206' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
 
		----------------------
		-- c207
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c207' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
 
		----------------------
		-- c212
		----------------------
 
		select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c212' and GenerateReportTypeId = @edfactsSubmissionReportTypeId
 
		insert into @recordIds (Id) values (20801)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 20801)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 261, 20801, '2022', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 20801
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 261, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 605
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CSILOWPERF', 'Lowest-performing school', 9449 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CSILOWGR', 'Low graduation rate high school', 9450 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CSIOTHER', 'ATSI school not exiting such status', 9451 )
 
 
		insert into @recordIds (Id) values (20802)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 20802)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 262, 20802, '2022', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 20802
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 262, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2022', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 606
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ECODIS', 'Economically Disadvantaged (ED) Students', 956 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WDIS', 'Children with one or more disabilities (IDEA)', 1206 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learner', 2061 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MA', 'Asian', 8362 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MAN', 'American Indian \ Alaska Native \ Native American', 8363 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MAP', 'Asian \ Pacific Islander', 8364 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MB', 'Black (not Hispanic) African American', 8365 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MF', 'Filipino', 8366 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MHL', 'Hispanic \ Latino', 8367 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MHN', 'Hispanic (not Puerto Rican)', 8368 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MM', 'Multicultural \ Multiethnic \ Multiracial \ other', 8369 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MNP', 'Native Hawaiian \ other Pacific Islander \ Pacific Islander', 8370 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MPR', 'Puerto Rican', 8371 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MW', 'White (not Hispanic) \ Caucasian', 8372 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'USETH', 'Underserved Race/Ethnicity', 9501 )
 
 
		insert into @recordIds (Id) values (22179)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22179)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 261, 22179, '2023', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22179
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 261, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 605
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CSILOWPERF', 'Lowest-performing school', 9449 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CSILOWGR', 'Low graduation rate high school', 9450 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CSIOTHER', 'ATSI school not exiting such status', 9451 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'CSINOTEXIT', 'CSI school not exiting such status', 9514 )
 
 
		insert into @recordIds (Id) values (22180)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22180)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 262, 22180, '2023', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22180
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 262, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 606
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ECODIS', 'Economically Disadvantaged (ED) Students', 956 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WDIS', 'Children with one or more disabilities (IDEA)', 1206 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MA', 'Asian', 8362 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MAN', 'American Indian \ Alaska Native \ Native American', 8363 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MAP', 'Asian \ Pacific Islander', 8364 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MB', 'Black (not Hispanic) African American', 8365 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MF', 'Filipino', 8366 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MHL', 'Hispanic \ Latino', 8367 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MHN', 'Hispanic (not Puerto Rican)', 8368 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MM', 'Multicultural \ Multiethnic \ Multiracial \ other', 8369 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MNP', 'Native Hawaiian \ other Pacific Islander \ Pacific Islander', 8370 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MPR', 'Puerto Rican', 8371 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MW', 'White (not Hispanic) \ Caucasian', 8372 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'STEDFNDSUBGRP1', 'State-defined subgroup 1', 9511 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'STEDFNDSUBGRP2', 'State-defined subgroup 2', 9512 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'STEDFNDSUBGRP3', 'State-defined subgroup 3', 9513 )
 
 
		insert into @recordIds (Id) values (22181)
 
		If NOT exists (SELECT 1 from app.Categorysets where EdFactsTableTypeGroupId = 22181)
		BEGIN
			-- CategorySets
 
			INSERT INTO app.CategorySets
			(GenerateReportId, OrganizationLevelId, EdFactsTableTypeId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES
			(@GenerateReportId, @schId, 284, 22181, '2023', 'CSA', 'Category Set A')
 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
 
		END
		ELSE
		BEGIN
 
			SELECT @CategorySetId = CategorySetId from app.Categorysets where EdFactsTableTypeGroupId = 22181
			-- CategorySets
 
			UPDATE app.CategorySets
			SET EdFactsTableTypeId = 284, GenerateReportId = @GenerateReportId, OrganizationLevelId = @schId, SubmissionYear = '2023', CategorySetCode = 'CSA', CategorySetName = 'Category Set A'
			WHERE CategorySetId = @CategorySetId
 
		END
 
		-- CategorySet_Categories, CategoryOptions
 
		delete from App.CategoryOptions where CategorySetId = @CategorySetId
		delete from App.CategorySet_Categories where CategorySetId = @CategorySetId
 
		SELECT @CategoryId = CategoryId FROM App.Categories Where EdFactsCategoryId = 606
 
		IF NOT EXISTS (SELECT 1 from App.CategorySet_Categories where CategoryId =  @CategoryId AND CategorySetId =  @CategorySetId )
		BEGIN
			INSERT INTO App.CategorySet_Categories
			([CategorySetId], [CategoryId])
			VALUES
			(@CategorySetId, @CategoryId)
		END
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MISSING', 'Missing', -1 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'ECODIS', 'Economically Disadvantaged (ED) Students', 956 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'WDIS', 'Children with one or more disabilities (IDEA)', 1206 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'LEP', 'English learners', 2059 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MA', 'Asian', 8362 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MAN', 'American Indian \ Alaska Native \ Native American', 8363 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MAP', 'Asian \ Pacific Islander', 8364 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MB', 'Black (not Hispanic) African American', 8365 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MF', 'Filipino', 8366 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MHL', 'Hispanic \ Latino', 8367 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MHN', 'Hispanic (not Puerto Rican)', 8368 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MM', 'Multicultural \ Multiethnic \ Multiracial \ other', 8369 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MNP', 'Native Hawaiian \ other Pacific Islander \ Pacific Islander', 8370 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MPR', 'Puerto Rican', 8371 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'MW', 'White (not Hispanic) \ Caucasian', 8372 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'STEDFNDSUBGRP1', 'State-defined subgroup 1', 9511 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'STEDFNDSUBGRP2', 'State-defined subgroup 2', 9512 )
 
 
		INSERT INTO App.CategoryOptions
		(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
		values
		(@CategorySetId, @CategoryId, 'STEDFNDSUBGRP3', 'State-defined subgroup 3', 9513 )
 
 
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
