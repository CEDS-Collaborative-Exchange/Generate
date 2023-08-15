---- Used to generate default category sets for certain file specs that have no TableTypeGroups in ETSS

set nocount on;

declare @GenerateReportId as int
declare @reportYear as varchar(50)
declare @level as int
declare @categorySetId as int
declare @categoryId as int



DECLARE @fileSpecs TABLE
(
	fileSpec nvarchar(10)
)


insert into @fileSpecs (fileSpec) values ('c143')



DECLARE report_cursor CURSOR FOR 
select r.GenerateReportId from @fileSpecs f
inner join app.GenerateReports r on f.fileSpec = r.ReportCode
order by fileSpec


OPEN report_cursor
FETCH NEXT FROM report_cursor INTO @GenerateReportId 

WHILE @@FETCH_STATUS = 0
BEGIN

	DECLARE level_cursor CURSOR FOR 
	select OrganizationLevelId from app.GenerateReport_OrganizationLevels
	where GenerateReportId = @GenerateReportId
	
	OPEN level_cursor
	FETCH NEXT FROM level_cursor INTO @level 

	WHILE @@FETCH_STATUS = 0
	BEGIN
	

		DECLARE submissionYear_cursor CURSOR FOR 
		select DISTINCT TOP 2  SubmissionYear from rds.DimDates where SubmissionYear is not null order by SubmissionYear desc

		OPEN submissionYear_cursor
		FETCH NEXT FROM submissionYear_cursor INTO @reportYear

		WHILE @@FETCH_STATUS = 0
		BEGIN

			DECLARE categorySet_cursor CURSOR FOR 
			select DISTINCT CategorySetId from app.CategorySets 
			where GenerateReportId = @GenerateReportId and OrganizationLevelId = @level and SubmissionYear = @reportYear

			OPEN categorySet_cursor
			FETCH NEXT FROM categorySet_cursor INTO @categorySetId

			WHILE @@FETCH_STATUS = 0
			BEGIN
				select @CategoryId = CategoryId from app.Categories where EdFactsCategoryId = 153
 
				if not exists(select 1 from app.CategorySet_Categories where CategorySetId = @categorySetId and CategoryId = @CategoryId)
				BEGIN
					INSERT INTO App.CategorySet_Categories([CategorySetId], [CategoryId])
					VALUES(@CategorySetId, @CategoryId)

					INSERT INTO App.CategoryOptions(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
					select distinct @CategorySetId, @CategoryId, CategoryOptionCode, CategoryOptionName, 0
					from app.CategoryOptions where CategoryId = @CategoryId
				END

				select @CategoryId = CategoryId from app.Categories where CategoryCode = 'DISCIPLINEACTION'
 
				if not exists(select 1 from app.CategorySet_Categories where CategorySetId = @categorySetId and CategoryId = @CategoryId)
				BEGIN
					INSERT INTO App.CategorySet_Categories([CategorySetId], [CategoryId])
					VALUES(@CategorySetId, @CategoryId)

					INSERT INTO App.CategoryOptions(CategorySetId, CategoryId, CategoryOptionCode, CategoryOptionName, EdFactsCategoryCodeId) 
					select distinct @CategorySetId, @CategoryId, CategoryOptionCode, CategoryOptionName, 0
					from app.CategoryOptions where CategoryId = @CategoryId
				END
				
				

			FETCH NEXT FROM categorySet_cursor INTO @categorySetId
			END

			CLOSE categorySet_cursor
			DEALLOCATE categorySet_cursor
				

		FETCH NEXT FROM submissionYear_cursor INTO @reportYear
		END

		CLOSE submissionYear_cursor
		DEALLOCATE submissionYear_cursor

	FETCH NEXT FROM level_cursor INTO @level
	END

	CLOSE level_cursor
	DEALLOCATE level_cursor
	

FETCH NEXT FROM report_cursor INTO @GenerateReportId 
END

CLOSE report_cursor
DEALLOCATE report_cursor
