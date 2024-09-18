﻿---- Used to generate default category sets for certain file specs that have no TableTypeGroups in ETSS

set nocount on;

declare @GenerateReportId as int
declare @reportYear as varchar(50), @reportCode as varchar(50)
declare @level as int



DECLARE @fileSpecs TABLE
(
	fileSpec nvarchar(10)
)


insert into @fileSpecs (fileSpec) values ('c029')
insert into @fileSpecs (fileSpec) values ('c039')
insert into @fileSpecs (fileSpec) values ('c103')
insert into @fileSpecs (fileSpec) values ('c129')
insert into @fileSpecs (fileSpec) values ('c190')
insert into @fileSpecs (fileSpec) values ('c196')
insert into @fileSpecs (fileSpec) values ('c197')
insert into @fileSpecs (fileSpec) values ('c198')
insert into @fileSpecs (fileSpec) values ('c130')
insert into @fileSpecs (fileSpec) values ('c131')
insert into @fileSpecs (fileSpec) values ('c207')
insert into @fileSpecs (fileSpec) values ('c170')



DECLARE report_cursor CURSOR FOR 
select r.GenerateReportId, r.reportCode from @fileSpecs f
inner join app.GenerateReports r on f.fileSpec = r.ReportCode
order by fileSpec


OPEN report_cursor
FETCH NEXT FROM report_cursor INTO @GenerateReportId, @reportCode

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
		select DISTINCT TOP 2  SchoolYear from rds.DimSchoolYears where SchoolYear is not null order by SchoolYear desc

		OPEN submissionYear_cursor
		FETCH NEXT FROM submissionYear_cursor INTO @reportYear

		WHILE @@FETCH_STATUS = 0
		BEGIN
				IF(@reportCode = 'c207' AND @reportYear = '2019')
				BEGIN
					IF exists (Select 1 from [App].[CategorySets] where CategorySetCode = 'CSA' and GenerateReportId = @GenerateReportId and OrganizationLevelId = @level and SubmissionYear = @reportYear)
					BEGIN
						delete from app.CategorySets where GenerateReportId = @GenerateReportId and SubmissionYear = @reportYear
						and OrganizationLevelId = @level
					END	
				END
				ELSE
				BEGIN
					IF Not exists (Select 1 from [App].[CategorySets] where CategorySetCode = 'CSA' and GenerateReportId = @GenerateReportId and OrganizationLevelId = @level
					 and SubmissionYear = @reportYear)
					BEGIN
						INSERT INTO [App].[CategorySets]([CategorySetCode],[CategorySetName],[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
						VALUES('CSA','Category Set A',0,@GenerateReportId,@level,@reportYear)

					END	
				END

		FETCH NEXT FROM submissionYear_cursor INTO @reportYear
		END

		CLOSE submissionYear_cursor
		DEALLOCATE submissionYear_cursor

	FETCH NEXT FROM level_cursor INTO @level
	END

	CLOSE level_cursor
	DEALLOCATE level_cursor
	

FETCH NEXT FROM report_cursor INTO @GenerateReportId, @reportCode
END

CLOSE report_cursor
DEALLOCATE report_cursor
