/*
-- To generate metadata refresh script, run this on DAT on 192.168.51.20
-- Make sure the DAT database was recently refreshed from production

-- TODO - rather than hard-coding the UseCaseId, it would be better to find a way to filter off of the name or source
-- so that this script does not need to be updated when new file specs are added

print 'set nocount on'
print 'begin try'
print '	begin transaction'
print ''

declare @UseCaseId as int
declare @TermId as int
declare @GPTopic as varchar(500)
declare @PTopic as varchar(500)
declare @Topic as varchar(500)
declare @Name as varchar(500)
DECLARE @version VARCHAR(20)
DECLARE @TermDefinition as varchar(max)	
DECLARE @ETitleQuestion as varchar(500)		
declare @SortOrder as decimal

DECLARE @UsecaseDefinition as varchar(max)
DECLARE @TitleQuestion as varchar(500)
DECLARE @Source as varchar(500)
				

declare @rowCntr as int
set @rowCntr = 0

DECLARE UseCase_Cursor CURSOR FOR 
	SELECT UseCaseId, [Description], TitleQuestion, [Source] FROM [dat].dbo.UseCase 
		WHERE Source like '%EDFacts%' OR Source like '%SLDS%' OR Source like '%CIID%'
OPEN UseCase_Cursor
FETCH NEXT FROM UseCase_Cursor INTO @UseCaseId, @UsecaseDefinition,@TitleQuestion,@Source
WHILE @@FETCH_STATUS = 0
BEGIN

set @UsecaseDefinition = rtrim(ltrim(replace(replace(replace(@UsecaseDefinition, '''', ''''''), char(13), ' '), char(10), ' ')))	
set @TitleQuestion = rtrim(ltrim(replace(replace(replace(@TitleQuestion, '''', ''''''), char(13), ' '), char(10), ' ')))	

Print ''
Print '		-----------------------------------------'
print '		-- ' + @TitleQuestion
Print '		-----------------------------------------'
print ''
print '		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  ' + convert(varchar(20), @UseCaseId) + ')'
PRINT '		BEGIN'
PRINT '			INSERT INTO app.cedsConnections'
print '			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])'
print '			VALUES'
print '			(''' + @UsecaseDefinition + '''' + ',' + '''' + @TitleQuestion  + '''' + ',' + '''' + @Source + '''' + ',' +  convert(varchar(20), @UseCaseId) + ')'					
print '		END'
print '		ELSE'
print '		BEGIN'
PRINT '			update App.CedsConnections'
print '			set CedsConnectionDescription = ''' + @UsecaseDefinition + ''', CedsConnectionName = ''' + @TitleQuestion + ''', CedsConnectionSource = ''' + @Source + ''''
PRINT '			where CedsUseCaseId = ' + convert(varchar(20), @UseCaseId) 
PRINT '		END'		

FETCH NEXT FROM UseCase_Cursor INTO @UseCaseId, @UsecaseDefinition,@TitleQuestion,@Source
END

CLOSE UseCase_Cursor
DEALLOCATE UseCase_Cursor
				
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

*/

/*********************************************************************
*
*	Updated on 6/08/2020 - based on production data from 05/29/2020
*
*********************************************************************/

set nocount on
begin try
	begin transaction
 
 
		-----------------------------------------
		-- Data Group 32: AYP Status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the state, district, or school met the Adequate Yearly Progress (AYP) requirements for the school year, as determined by the state-established criteria.','Data Group 32: AYP Status','EDFacts',2)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the state, district, or school met the Adequate Yearly Progress (AYP) requirements for the school year, as determined by the state-established criteria.', CedsConnectionName = 'Data Group 32: AYP Status', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 2
		END
 
		-----------------------------------------
		-- Data Group 739: HS graduates postsecondary enrollment table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of graduates from two school years prior to the current school year.','Data Group 739: HS graduates postsecondary enrollment table','EDFacts',3)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of graduates from two school years prior to the current school year.', CedsConnectionName = 'Data Group 739: HS graduates postsecondary enrollment table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 3
		END
 
		-----------------------------------------
		-- Data Group 703: CTE participants in programs for non-traditional table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE participants who participated in a program that leads to employment in non-traditional fields.','Data Group 703: CTE participants in programs for non-traditional table','EDFacts',4)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE participants who participated in a program that leads to employment in non-traditional fields.', CedsConnectionName = 'Data Group 703: CTE participants in programs for non-traditional table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 4
		END
 
		-----------------------------------------
		-- What  are the characteristics of districts/schools that meet or do not meet accountability requirements, specifically characteristics of funding, programs, average class size, staff allocations, and teacher qualifications?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  7)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What  are the characteristics of districts/schools that meet or do not meet accountability requirements, specifically characteristics of funding, programs, average class size, staff allocations, and teacher qualifications?','What  are the characteristics of districts/schools that meet or do not meet accountability requirements, specifically characteristics of funding, programs, average class size, staff allocations, and teacher qualifications?','SLDS Community',7)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What  are the characteristics of districts/schools that meet or do not meet accountability requirements, specifically characteristics of funding, programs, average class size, staff allocations, and teacher qualifications?', CedsConnectionName = 'What  are the characteristics of districts/schools that meet or do not meet accountability requirements, specifically characteristics of funding, programs, average class size, staff allocations, and teacher qualifications?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 7
		END
 
		-----------------------------------------
		-- What are the attendance patterns and proficiency levels of students who drop out by subgroup?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  8)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What are the attendance patterns and proficiency levels of students who drop out by subgroup?','What are the attendance patterns and proficiency levels of students who drop out by subgroup?','SLDS Community',8)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What are the attendance patterns and proficiency levels of students who drop out by subgroup?', CedsConnectionName = 'What are the attendance patterns and proficiency levels of students who drop out by subgroup?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 8
		END
 
		-----------------------------------------
		-- To what extent does free and reduced price lunch enrollment drop off in high school?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  9)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('To what extent does free and reduced price lunch enrollment drop off in high school?','To what extent does free and reduced price lunch enrollment drop off in high school?','SLDS Community',9)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'To what extent does free and reduced price lunch enrollment drop off in high school?', CedsConnectionName = 'To what extent does free and reduced price lunch enrollment drop off in high school?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 9
		END
 
		-----------------------------------------
		-- How many high school graduates enroll in a public postsecondary institution within three years of graduating high school?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  11)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('How many high school graduates enroll in a public postsecondary institution within three years of graduating high school?','How many high school graduates enroll in a public postsecondary institution within three years of graduating high school?','SLDS Community',11)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'How many high school graduates enroll in a public postsecondary institution within three years of graduating high school?', CedsConnectionName = 'How many high school graduates enroll in a public postsecondary institution within three years of graduating high school?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 11
		END
 
		-----------------------------------------
		-- What are the college enrollment and workforce patterns of students who drop out of high school, and how do they compare to students who receive a high school diploma?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  18)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What are the college enrollment and workforce patterns of students who drop out of high school, and how do they compare to students who receive a high school diploma?','What are the college enrollment and workforce patterns of students who drop out of high school, and how do they compare to students who receive a high school diploma?','SLDS Community',18)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What are the college enrollment and workforce patterns of students who drop out of high school, and how do they compare to students who receive a high school diploma?', CedsConnectionName = 'What are the college enrollment and workforce patterns of students who drop out of high school, and how do they compare to students who receive a high school diploma?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 18
		END
 
		-----------------------------------------
		-- What is the growth profile of  students and subgroups at the state, district, and school levels?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  20)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What is the growth profile of  students and subgroups at the state, district, and school levels?','What is the growth profile of  students and subgroups at the state, district, and school levels?','SLDS Community',20)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What is the growth profile of  students and subgroups at the state, district, and school levels?', CedsConnectionName = 'What is the growth profile of  students and subgroups at the state, district, and school levels?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 20
		END
 
		-----------------------------------------
		-- What is the grade-to-grade progress of student subgroups on the state assessments in reading and mathematics, i.e., what percent of students initially below proficient reach proficiency and what percent either maintain or lose proficiency over time?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  22)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What is the grade-to-grade progress of student subgroups on the state assessments in reading and mathematics, i.e., what percent of students initially below proficient reach proficiency and what percent either maintain or lose proficiency over time?','What is the grade-to-grade progress of student subgroups on the state assessments in reading and mathematics, i.e., what percent of students initially below proficient reach proficiency and what percent either maintain or lose proficiency over time?','SLDS Community',22)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What is the grade-to-grade progress of student subgroups on the state assessments in reading and mathematics, i.e., what percent of students initially below proficient reach proficiency and what percent either maintain or lose proficiency over time?', CedsConnectionName = 'What is the grade-to-grade progress of student subgroups on the state assessments in reading and mathematics, i.e., what percent of students initially below proficient reach proficiency and what percent either maintain or lose proficiency over time?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 22
		END
 
		-----------------------------------------
		-- How many low-income children are enrolled in the following programs: Head Start, publicly funded Pre-K, publicly funded child care programs or family child care homes, early intervention programs, and special education services?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  41)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('How many low-income children are enrolled in the following programs: Head Start, publicly funded Pre-K, publicly funded child care programs or family child care homes, early intervention programs, and special education services?','How many low-income children are enrolled in the following programs: Head Start, publicly funded Pre-K, publicly funded child care programs or family child care homes, early intervention programs, and special education services?','SLDS Community',41)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'How many low-income children are enrolled in the following programs: Head Start, publicly funded Pre-K, publicly funded child care programs or family child care homes, early intervention programs, and special education services?', CedsConnectionName = 'How many low-income children are enrolled in the following programs: Head Start, publicly funded Pre-K, publicly funded child care programs or family child care homes, early intervention programs, and special education services?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 41
		END
 
		-----------------------------------------
		-- What percentage of early childhood teachers and assistant teachers in each program setting has earned a college degree or higher?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  52)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What percentage of early childhood teachers and assistant teachers in each program setting has earned a college degree or higher?','What percentage of early childhood teachers and assistant teachers in each program setting has earned a college degree or higher?','SLDS Community',52)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What percentage of early childhood teachers and assistant teachers in each program setting has earned a college degree or higher?', CedsConnectionName = 'What percentage of early childhood teachers and assistant teachers in each program setting has earned a college degree or higher?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 52
		END
 
		-----------------------------------------
		-- Is the percent of community college students (or graduates) transferring to four-year institutions increasing?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  57)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Is the percent of community college students (or graduates) transferring to four-year institutions increasing?','Is the percent of community college students (or graduates) transferring to four-year institutions increasing?','SLDS Community',57)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Is the percent of community college students (or graduates) transferring to four-year institutions increasing?', CedsConnectionName = 'Is the percent of community college students (or graduates) transferring to four-year institutions increasing?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 57
		END
 
		-----------------------------------------
		-- Are students transferring from one institution to another and completing their degrees at the institution they transferred into without any loss of time?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  58)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Are students transferring from one institution to another and completing their degrees at the institution they transferred into without any loss of  time?','Are students transferring from one institution to another and completing their degrees at the institution they transferred into without any loss of time?','SLDS Community',58)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Are students transferring from one institution to another and completing their degrees at the institution they transferred into without any loss of  time?', CedsConnectionName = 'Are students transferring from one institution to another and completing their degrees at the institution they transferred into without any loss of time?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 58
		END
 
		-----------------------------------------
		-- What are the persistence rates of low income young adults at Community Colleges over five years?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  59)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What are the persistence rates of low income young adults at Community Colleges over five years?','What are the persistence rates of low income young adults at Community Colleges over five years?','SLDS Community',59)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What are the persistence rates of low income young adults at Community Colleges over five years?', CedsConnectionName = 'What are the persistence rates of low income young adults at Community Colleges over five years?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 59
		END
 
		-----------------------------------------
		-- Compared to full-time college students, how many more part-time college students did not complete their degree?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  60)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Compared to full-time college students, how many more part-time college students did not complete their degree?','Compared to full-time college students, how many more part-time college students did not complete their degree?','SLDS Community',60)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Compared to full-time college students, how many more part-time college students did not complete their degree?', CedsConnectionName = 'Compared to full-time college students, how many more part-time college students did not complete their degree?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 60
		END
 
		-----------------------------------------
		-- What are the district and school enrollment trends at different grade levels by gender, ethnicity, and economic disadvantage, special education, ELL programs statuses, and combinations for each grade level compared to the overall state trends?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  61)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What are the district and school enrollment trends at different grade levels by gender, ethnicity, economic disadvantage status, students in special education, students in ELL programs, and combinations for each grade level compared to the overall state trends?','What are the district and school enrollment trends at different grade levels by gender, ethnicity, and economic disadvantage, special education, ELL programs statuses, and combinations for each grade level compared to the overall state trends?','SLDS Community',61)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What are the district and school enrollment trends at different grade levels by gender, ethnicity, economic disadvantage status, students in special education, students in ELL programs, and combinations for each grade level compared to the overall state trends?', CedsConnectionName = 'What are the district and school enrollment trends at different grade levels by gender, ethnicity, and economic disadvantage, special education, ELL programs statuses, and combinations for each grade level compared to the overall state trends?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 61
		END
 
		-----------------------------------------
		-- Do students in dual enrollment programs complete their baccalaureate degrees faster than students who do not enroll in these acceleration programs?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  62)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Do students in dual enrollment programs complete their baccalaureate degrees faster than students who do not enroll in these acceleration programs?','Do students in dual enrollment programs complete their baccalaureate degrees faster than students who do not enroll in these acceleration programs?','SLDS Community',62)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Do students in dual enrollment programs complete their baccalaureate degrees faster than students who do not enroll in these acceleration programs?', CedsConnectionName = 'Do students in dual enrollment programs complete their baccalaureate degrees faster than students who do not enroll in these acceleration programs?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 62
		END
 
		-----------------------------------------
		-- How do community college transfer students fare at the receiving institutions with regard to their academic performance and persistence to degree attainment?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  63)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('How do community college transfer students fare at the receiving institutions with regard to their academic performance and persistence to degree attainment?','How do community college transfer students fare at the receiving institutions with regard to their academic performance and persistence to degree attainment?','SLDS Community',63)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'How do community college transfer students fare at the receiving institutions with regard to their academic performance and persistence to degree attainment?', CedsConnectionName = 'How do community college transfer students fare at the receiving institutions with regard to their academic performance and persistence to degree attainment?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 63
		END
 
		-----------------------------------------
		-- How do the state high stakes assessment results for this LEA compare to the results of other LEAs in the state?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  64)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('How do the state high stakes assessment results for this LEA compare to the results of other LEAs in the state?','How do the state high stakes assessment results for this LEA compare to the results of other LEAs in the state?','SLDS Community',64)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'How do the state high stakes assessment results for this LEA compare to the results of other LEAs in the state?', CedsConnectionName = 'How do the state high stakes assessment results for this LEA compare to the results of other LEAs in the state?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 64
		END
 
		-----------------------------------------
		-- How does this school’s attendance and promotion rates compare to other schools in the LEA and to all schools in the state?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  65)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('How does this school’s attendance and promotion rates compare to other schools in the LEA and to all schools in the state?','How does this school’s attendance and promotion rates compare to other schools in the LEA and to all schools in the state?','SLDS Community',65)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'How does this school’s attendance and promotion rates compare to other schools in the LEA and to all schools in the state?', CedsConnectionName = 'How does this school’s attendance and promotion rates compare to other schools in the LEA and to all schools in the state?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 65
		END
 
		-----------------------------------------
		-- How many low-income children are in the following programs: Head Start, publicly funded Pre-K, publicly funded child care programs or family child care homes, early intervention programs, and special education services?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  67)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('How many low-income children are in the following programs: Head Start, publicly funded Pre-K, publicly funded child care programs or family child care homes, early intervention programs, and special education services?','How many low-income children are in the following programs: Head Start, publicly funded Pre-K, publicly funded child care programs or family child care homes, early intervention programs, and special education services?','SLDS Community',67)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'How many low-income children are in the following programs: Head Start, publicly funded Pre-K, publicly funded child care programs or family child care homes, early intervention programs, and special education services?', CedsConnectionName = 'How many low-income children are in the following programs: Head Start, publicly funded Pre-K, publicly funded child care programs or family child care homes, early intervention programs, and special education services?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 67
		END
 
		-----------------------------------------
		-- How many students who earned a GED continued into postsecondary education and what were their postsecondary outcomes?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  69)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('How many students who earned a GED continued into postsecondary education and what were their postsecondary outcomes?','How many students who earned a GED continued into postsecondary education and what were their postsecondary outcomes?','SLDS Community',69)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'How many students who earned a GED continued into postsecondary education and what were their postsecondary outcomes?', CedsConnectionName = 'How many students who earned a GED continued into postsecondary education and what were their postsecondary outcomes?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 69
		END
 
		-----------------------------------------
		-- Of the students who enroll in postsecondary institutions and earn a degree, what is the average number of years to earn a degree?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  70)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Of the students who enroll in postsecondary institutions and earn a degree, what is the average number of years to earn a degree?','Of the students who enroll in postsecondary institutions and earn a degree, what is the average number of years to earn a degree?','SLDS Community',70)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Of the students who enroll in postsecondary institutions and earn a degree, what is the average number of years to earn a degree?', CedsConnectionName = 'Of the students who enroll in postsecondary institutions and earn a degree, what is the average number of years to earn a degree?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 70
		END
 
		-----------------------------------------
		-- What is the number of low-income young adults who by age 26 earn a postsecondary education credential?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  77)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What is the number of low-income young adults who by age 26 earn a postsecondary education credential?','What is the number of low-income young adults who by age 26 earn a postsecondary education credential?','SLDS Community',77)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What is the number of low-income young adults who by age 26 earn a postsecondary education credential?', CedsConnectionName = 'What is the number of low-income young adults who by age 26 earn a postsecondary education credential?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 77
		END
 
		-----------------------------------------
		-- What percentage of last year''s high school graduates need remediation in college, and how do these percentages vary by student demographic characteristics?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  79)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What percentage of last year''s high school graduates need remediation in college, and how do these percentages vary by student demographic characteristics?','What percentage of last year''s high school graduates need remediation in college, and how do these percentages vary by student demographic characteristics?','SLDS Community',79)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What percentage of last year''s high school graduates need remediation in college, and how do these percentages vary by student demographic characteristics?', CedsConnectionName = 'What percentage of last year''s high school graduates need remediation in college, and how do these percentages vary by student demographic characteristics?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 79
		END
 
		-----------------------------------------
		-- What proportion of students that enter in a particular grade maintain continuous enrollment and complete that grade in a timely manner?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  80)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What proportion of students that enter in a particular grade maintain continuous enrollment and complete that grade in a timely manner?','What proportion of students that enter in a particular grade maintain continuous enrollment and complete that grade in a timely manner?','SLDS Community',80)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What proportion of students that enter in a particular grade maintain continuous enrollment and complete that grade in a timely manner?', CedsConnectionName = 'What proportion of students that enter in a particular grade maintain continuous enrollment and complete that grade in a timely manner?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 80
		END
 
		-----------------------------------------
		-- Who participates in developmental education courses in reading, writing, and math and how does this relate to high school test results?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  81)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Who participates in developmental education courses in reading, writing, and math and how does this relate to high school test results?','Who participates in developmental education courses in reading, writing, and math and how does this relate to high school test results?','SLDS Community',81)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Who participates in developmental education courses in reading, writing, and math and how does this relate to high school test results?', CedsConnectionName = 'Who participates in developmental education courses in reading, writing, and math and how does this relate to high school test results?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 81
		END
 
		-----------------------------------------
		-- Data Group 1: LEA identifier (NCES)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  85)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The seven-digit unique identifier assigned to the LEA by NCES also known as NCES Education Agency ID.','Data Group 1: LEA identifier (NCES)','EdFacts',85)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The seven-digit unique identifier assigned to the LEA by NCES also known as NCES Education Agency ID.', CedsConnectionName = 'Data Group 1: LEA identifier (NCES)', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 85
		END
 
		-----------------------------------------
		-- Data Group 4: LEA identifier (state)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  86)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The identifier assigned to an LEA by the SEA. Also known as State LEA Identification Number (ID).','Data Group 4: LEA identifier (state)','EdFacts',86)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The identifier assigned to an LEA by the SEA. Also known as State LEA Identification Number (ID).', CedsConnectionName = 'Data Group 4: LEA identifier (state)', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 86
		END
 
		-----------------------------------------
		-- Data Group 5: School identifier (state)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  87)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The identifier assigned to a school by the SEA. Also known as State School Identification Number (ID).','Data Group 5: School identifier (state)','EdFacts',87)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The identifier assigned to a school by the SEA. Also known as State School Identification Number (ID).', CedsConnectionName = 'Data Group 5: School identifier (state)', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 87
		END
 
		-----------------------------------------
		-- Data Group 7: Education entity name
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  88)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The full legally accepted name of the school, LEA, SEA, or other entity reporting education data.','Data Group 7: Education entity name','EdFacts',88)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The full legally accepted name of the school, LEA, SEA, or other entity reporting education data.', CedsConnectionName = 'Data Group 7: Education entity name', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 88
		END
 
		-----------------------------------------
		-- Data Group 8: Address Mailing
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  89)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The set of elements that describes the mailing address of the education entity, including the mailing address, city, state, ZIP Code and ZIP Code   4.','Data Group 8: Address Mailing','EdFacts',89)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The set of elements that describes the mailing address of the education entity, including the mailing address, city, state, ZIP Code and ZIP Code   4.', CedsConnectionName = 'Data Group 8: Address Mailing', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 89
		END
 
		-----------------------------------------
		-- Data Group 9: Address Location
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  90)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The set of elements that describes the physical location of the education entity, including the street address, city, state, ZIP Code and ZIP Code   4.','Data Group 9: Address Location','EdFacts',90)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The set of elements that describes the physical location of the education entity, including the street address, city, state, ZIP Code and ZIP Code   4.', CedsConnectionName = 'Data Group 9: Address Location', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 90
		END
 
		-----------------------------------------
		-- Data Group 10: Telephone-education entity
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  91)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The 10-digit telephone number, including the area code, for the education entity.','Data Group 10: Telephone-education entity','EdFacts',91)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The 10-digit telephone number, including the area code, for the education entity.', CedsConnectionName = 'Data Group 10: Telephone-education entity', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 91
		END
 
		-----------------------------------------
		-- Data Group 11: Web site Address
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  92)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The Uniform Resource Locator (URL) for the unique address of a Web page of an education entity.','Data Group 11: Web site Address','EdFacts',92)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The Uniform Resource Locator (URL) for the unique address of a Web page of an education entity.', CedsConnectionName = 'Data Group 11: Web site Address', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 92
		END
 
		-----------------------------------------
		-- Data Group 18, File Specification C039 Grades Offered
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  94)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The grade level(s) offered by the school or district.','Data Group 18, File Specification C039 Grades Offered','EDFacts File Specification v 9.0/National Center for Education Statistics',94)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The grade level(s) offered by the school or district.', CedsConnectionName = 'Data Group 18, File Specification C039 Grades Offered', CedsConnectionSource = 'EDFacts File Specification v 9.0/National Center for Education Statistics'
			where CedsUseCaseId = 94
		END
 
		-----------------------------------------
		-- Data Group 22, File Specification C129 Title I School Status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  96)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication that a school is designated under state and federal regulations as being eligible for participation in programs authorized by Title I of ESEA as amended and whether it has a Title I program.','Data Group 22, File Specification C129 Title I School Status','EDFacts File Specification v 9.0/National Center for Education Statistics',96)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication that a school is designated under state and federal regulations as being eligible for participation in programs authorized by Title I of ESEA as amended and whether it has a Title I program.', CedsConnectionName = 'Data Group 22, File Specification C129 Title I School Status', CedsConnectionSource = 'EDFacts File Specification v 9.0/National Center for Education Statistics'
			where CedsUseCaseId = 96
		END
 
		-----------------------------------------
		-- Data Group 24, File Specification C129 Magnet Status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  97)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school is a magnet school or has a magnet program within the school.','Data Group 24, File Specification C129 Magnet Status','EDFacts File Specification v 9.0/National Center for Education Statistics',97)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school is a magnet school or has a magnet program within the school.', CedsConnectionName = 'Data Group 24, File Specification C129 Magnet Status', CedsConnectionSource = 'EDFacts File Specification v 9.0/National Center for Education Statistics'
			where CedsUseCaseId = 97
		END
 
		-----------------------------------------
		-- Data Group 39, File Specification C052 Membership Table (School)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  99)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The official unduplicated October 1st student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.    This connection is for the School level data.','Data Group 39, File Specification C052 Membership Table (School)','EDFacts File Specification v 9.0/National Center for Education Statistics',99)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The official unduplicated October 1st student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.    This connection is for the School level data.', CedsConnectionName = 'Data Group 39, File Specification C052 Membership Table (School)', CedsConnectionSource = 'EDFacts File Specification v 9.0/National Center for Education Statistics'
			where CedsUseCaseId = 99
		END
 
		-----------------------------------------
		-- Data Group 123, File Specification C046 LEP students in LEP program table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  101)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of Limited English Proficient (LEP) students enrolled in English language instruction educational programs designed for LEP students.','Data Group 123, File Specification C046 LEP students in LEP program table','EDFacts File Specification v 9.0/Office of Elementary and Secondary Education',101)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of Limited English Proficient (LEP) students enrolled in English language instruction educational programs designed for LEP students.', CedsConnectionName = 'Data Group 123, File Specification C046 LEP students in LEP program table', CedsConnectionSource = 'EDFacts File Specification v 9.0/Office of Elementary and Secondary Education'
			where CedsUseCaseId = 101
		END
 
		-----------------------------------------
		-- Data Group 306, File Specification C040 Graduates Completers Table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  102)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who graduated from high school or completed some other education program that is approved by the state or local education agency (SEA or LEA) during the school year and the subsequent summer school.','Data Group 306, File Specification C040 Graduates Completers Table','EDFacts File Specification v 9.0/National Center for Education Statistics',102)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who graduated from high school or completed some other education program that is approved by the state or local education agency (SEA or LEA) during the school year and the subsequent summer school.', CedsConnectionName = 'Data Group 306, File Specification C040 Graduates Completers Table', CedsConnectionSource = 'EDFacts File Specification v 9.0/National Center for Education Statistics'
			where CedsUseCaseId = 102
		END
 
		-----------------------------------------
		-- Data Group 326, File Specification C032 Dropouts table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  103)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of dropouts (students who were enrolled in school at some time during the school year, were not enrolled the following school year, were expected to be in membership, did not graduate from high school or completed a state or district-approved educational program, and did not meet any of the following conditions: (1) transfer to another school, or district, or state or approved educational program, (2) temporary school-recognized absence, or (3) death).','Data Group 326, File Specification C032 Dropouts table','EDFacts File Specification v 9.0/National Center for Education Statistics',103)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of dropouts (students who were enrolled in school at some time during the school year, were not enrolled the following school year, were expected to be in membership, did not graduate from high school or completed a state or district-approved educational program, and did not meet any of the following conditions: (1) transfer to another school, or district, or state or approved educational program, (2) temporary school-recognized absence, or (3) death).', CedsConnectionName = 'Data Group 326, File Specification C032 Dropouts table', CedsConnectionSource = 'EDFacts File Specification v 9.0/National Center for Education Statistics'
			where CedsUseCaseId = 103
		END
 
		-----------------------------------------
		-- Data Group 669: Out of State Indicator
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  105)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication that the mailing or location address of the LEA or school is outside of the state.','Data Group 669: Out of State Indicator','EdFacts',105)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication that the mailing or location address of the LEA or school is outside of the state.', CedsConnectionName = 'Data Group 669: Out of State Indicator', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 105
		END
 
		-----------------------------------------
		-- Data Group 458: Chief state school officer contact information
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  107)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The contact information of the chief state school officer, including first and last name, official title, phone number, and email address.','Data Group 458: Chief state school officer contact information','EdFacts',107)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The contact information of the chief state school officer, including first and last name, official title, phone number, and email address.', CedsConnectionName = 'Data Group 458: Chief state school officer contact information', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 107
		END
 
		-----------------------------------------
		-- Data Group 529: School Identifier (NCES)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  108)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The twelve-digit unique identifier assigned to the school by NCES. Also known as NCES School ID.','Data Group 529: School Identifier (NCES)','EdFacts',108)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The twelve-digit unique identifier assigned to the school by NCES. Also known as NCES School ID.', CedsConnectionName = 'Data Group 529: School Identifier (NCES)', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 108
		END
 
		-----------------------------------------
		-- Data Group 551: Supervisory Union Identification Number
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  109)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The three-digit unique identifier assigned to the supervisory union by the state.','Data Group 551: Supervisory Union Identification Number','EdFacts',109)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The three-digit unique identifier assigned to the supervisory union by the state.', CedsConnectionName = 'Data Group 551: Supervisory Union Identification Number', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 109
		END
 
		-----------------------------------------
		-- Data Group 559: State Code
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  111)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The two-digit American National Standards Insitute (ANSI) code for the state, District of Columbia, and the possessions and freely associated areas of the United States.','Data Group 559: State Code','EdFacts',111)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The two-digit American National Standards Insitute (ANSI) code for the state, District of Columbia, and the possessions and freely associated areas of the United States.', CedsConnectionName = 'Data Group 559: State Code', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 111
		END
 
		-----------------------------------------
		-- Data Group 570: State Agency Number
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  112)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A number used to uniquely identify state agencies.','Data Group 570: State Agency Number','EdFacts',112)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A number used to uniquely identify state agencies.', CedsConnectionName = 'Data Group 570: State Agency Number', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 112
		END
 
		-----------------------------------------
		-- Data Group 571: Effective Date
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  113)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The date a change in a directory data element takes place.','Data Group 571: Effective Date','EdFacts',113)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The date a change in a directory data element takes place.', CedsConnectionName = 'Data Group 571: Effective Date', CedsConnectionSource = 'EdFacts'
			where CedsUseCaseId = 113
		END
 
		-----------------------------------------
		-- Data Group 528, File Specification C059 Staff FTE Table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  114)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) staff.','Data Group 528, File Specification C059 Staff FTE Table','EDFacts File Specification v 9.0/National Center for Education Statistics',114)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) staff.', CedsConnectionName = 'Data Group 528, File Specification C059 Staff FTE Table', CedsConnectionSource = 'EDFacts File Specification v 9.0/National Center for Education Statistics'
			where CedsUseCaseId = 114
		END
 
		-----------------------------------------
		-- Data Group 644, File Specification C059 Teachers (FTE)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  115)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) classroom teachers.','Data Group 644, File Specification C059 Teachers (FTE)','EDFacts File Specification v 9.0/National Center for Education Statistics',115)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) classroom teachers.', CedsConnectionName = 'Data Group 644, File Specification C059 Teachers (FTE)', CedsConnectionSource = 'EDFacts File Specification v 9.0/National Center for Education Statistics'
			where CedsUseCaseId = 115
		END
 
		-----------------------------------------
		-- Data Group 31: School poverty percentage
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  133)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The percentage of students in the school identified as economically disadvantaged according to the state definition. Also known as School Poverty Level.','Data Group 31: School poverty percentage','EDFacts',133)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The percentage of students in the school identified as economically disadvantaged according to the state definition. Also known as School Poverty Level.', CedsConnectionName = 'Data Group 31: School poverty percentage', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 133
		END
 
		-----------------------------------------
		-- Data Group 34: Improvement status - school
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  134)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of the improvement stage of the school.','Data Group 34: Improvement status - school','EDFacts',134)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of the improvement stage of the school.', CedsConnectionName = 'Data Group 34: Improvement status - school', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 134
		END
 
		-----------------------------------------
		-- Data Group 36: Persistently dangerous status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  137)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school is identified as persistently dangerous in accordance with state definition.','Data Group 36: Persistently dangerous status','EDFacts',137)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school is identified as persistently dangerous in accordance with state definition.', CedsConnectionName = 'Data Group 36: Persistently dangerous status', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 137
		END
 
		-----------------------------------------
		-- Data Group 56: Economically disadvantaged students
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  138)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who met the state criteria for classification as economically disadvantaged according to the state definition.','Data Group 56: Economically disadvantaged students','EDFacts',138)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who met the state criteria for classification as economically disadvantaged according to the state definition.', CedsConnectionName = 'Data Group 56: Economically disadvantaged students', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 138
		END
 
		-----------------------------------------
		-- Data Group 85: Children with disabilities (IDEA) exiting special education table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  139)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 14 through 21 and were in special education at the start of the reporting period and were not in special education at the end of the reporting period.','Data Group 85: Children with disabilities (IDEA) exiting special education table','EDFacts',139)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 14 through 21 and were in special education at the start of the reporting period and were not in special education at the end of the reporting period.', CedsConnectionName = 'Data Group 85: Children with disabilities (IDEA) exiting special education table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 139
		END
 
		-----------------------------------------
		-- Data Group 102: MEP students served 12-month table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  140)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of participating migrant students who received instructional or support services in a Migrant Education Program (MEP).','Data Group 102: MEP students served 12-month table','EDFacts',140)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of participating migrant students who received instructional or support services in a Migrant Education Program (MEP).', CedsConnectionName = 'Data Group 102: MEP students served 12-month table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 140
		END
 
		-----------------------------------------
		-- Data Group 110: Migrant students eligible regular school year
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  141)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of eligible migrant students enrolled in a public school during the regular school year.','Data Group 110: Migrant students eligible regular school year','EDFacts',141)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of eligible migrant students enrolled in a public school during the regular school year.', CedsConnectionName = 'Data Group 110: Migrant students eligible regular school year', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 141
		END
 
		-----------------------------------------
		-- Data Group 151: Title III LEP English language proficiency results table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  142)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of limited English proficient (LEP) students who were assessed in the annual state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA funds.','Data Group 151: Title III LEP English language proficiency results table','EDFacts',142)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of limited English proficient (LEP) students who were assessed in the annual state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA funds.', CedsConnectionName = 'Data Group 151: Title III LEP English language proficiency results table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 142
		END
 
		-----------------------------------------
		-- Data Group 320: CTE concentrators graduates table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  143)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of career and technical education (CTE) concentrators who left secondary education and who received a high school diploma or its recognized equivalent.','Data Group 320: CTE concentrators graduates table','EDFacts',143)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of career and technical education (CTE) concentrators who left secondary education and who received a high school diploma or its recognized equivalent.', CedsConnectionName = 'Data Group 320: CTE concentrators graduates table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 143
		END
 
		-----------------------------------------
		-- Data Group 565, File Specification C033 Free and reduced price lunch table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  144)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who are eligible to participate in the Free Lunch and Reduced-Price Lunch Programs under the National School Lunch Act of 1946.','Data Group 565, File Specification C033 Free and reduced price lunch table','EDFacts File Specification v 9.0/National Center for Education Statistics',144)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who are eligible to participate in the Free Lunch and Reduced-Price Lunch Programs under the National School Lunch Act of 1946.', CedsConnectionName = 'Data Group 565, File Specification C033 Free and reduced price lunch table', CedsConnectionSource = 'EDFacts File Specification v 9.0/National Center for Education Statistics'
			where CedsUseCaseId = 144
		END
 
		-----------------------------------------
		-- Data Group 573, File Specification C129 Shared time status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  145)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication that a school offers vocational/technical education or other educational services in which some or all students are enrolled at a separate school of record and attend the shared-time school on a part-time basis.','Data Group 573, File Specification C129 Shared time status','EDFacts File Specification v 9.0/National Center for Education Statistics',145)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication that a school offers vocational/technical education or other educational services in which some or all students are enrolled at a separate school of record and attend the shared-time school on a part-time basis.', CedsConnectionName = 'Data Group 573, File Specification C129 Shared time status', CedsConnectionSource = 'EDFacts File Specification v 9.0/National Center for Education Statistics'
			where CedsUseCaseId = 145
		END
 
		-----------------------------------------
		-- Data Group 583, File Specification C175 Academic achievement in mathematics table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  146)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in mathematics for whom a proficiency level was assigned.  This connection also includes a listing of the other Data Groups necessary for submitting file C175 - Academic Achievement in Mathematics.','Data Group 583, File Specification C175 Academic achievement in mathematics table','EDFacts File Specification v 9.0/Office of Elementary and Secondary Education',146)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in mathematics for whom a proficiency level was assigned.  This connection also includes a listing of the other Data Groups necessary for submitting file C175 - Academic Achievement in Mathematics.', CedsConnectionName = 'Data Group 583, File Specification C175 Academic achievement in mathematics table', CedsConnectionSource = 'EDFacts File Specification v 9.0/Office of Elementary and Secondary Education'
			where CedsUseCaseId = 146
		END
 
		-----------------------------------------
		-- Data Group 584, File Specification C178 Academic achievement in reading language arts table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  147)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.  This connection also includes a listing of the other Data Groups necessary for submitting file C178 - Academic Achievement in reading - language arts table.','Data Group 584, File Specification C178 Academic achievement in reading language arts table','EDFacts File Specification v 9.0/Office of Elementary and Secondary Education',147)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.  This connection also includes a listing of the other Data Groups necessary for submitting file C178 - Academic Achievement in reading - language arts table.', CedsConnectionName = 'Data Group 584, File Specification C178 Academic achievement in reading language arts table', CedsConnectionSource = 'EDFacts File Specification v 9.0/Office of Elementary and Secondary Education'
			where CedsUseCaseId = 147
		END
 
		-----------------------------------------
		-- Data Group 585, File Specification C179 Academic achievement in science table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  148)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in science for whom a proficiency level was assigned.  This connection also includes a listing of the other Data Groups necessary for submitting file C179 - Academic Achievement in Science.','Data Group 585, File Specification C179 Academic achievement in science table','EDFacts File Specification v 9.0/Office of Elementary and Secondary Education',148)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in science for whom a proficiency level was assigned.  This connection also includes a listing of the other Data Groups necessary for submitting file C179 - Academic Achievement in Science.', CedsConnectionName = 'Data Group 585, File Specification C179 Academic achievement in science table', CedsConnectionSource = 'EDFacts File Specification v 9.0/Office of Elementary and Secondary Education'
			where CedsUseCaseId = 148
		END
 
		-----------------------------------------
		-- Data Group 588, File Specificaton C185 Assessment participation in mathematics table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  149)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students enrolled during the period of the state assessment in mathematics.  This connection also includes a listing of the other Data Groups necessary for submitting file C185 - Academic Participation in Mathmatics.','Data Group 588, File Specificaton C185 Assessment participation in mathematics table','EDFacts File Specification v 9.0/Office of Elementary and Secondary Education',149)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students enrolled during the period of the state assessment in mathematics.  This connection also includes a listing of the other Data Groups necessary for submitting file C185 - Academic Participation in Mathmatics.', CedsConnectionName = 'Data Group 588, File Specificaton C185 Assessment participation in mathematics table', CedsConnectionSource = 'EDFacts File Specification v 9.0/Office of Elementary and Secondary Education'
			where CedsUseCaseId = 149
		END
 
		-----------------------------------------
		-- Data Group 589, File Specification C188 Assessment participation in reading language arts table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  150)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.  This connection also includes a listing of the other Data Groups necessary for submitting file C188 - Academic Participation in reading/language arts.','Data Group 589, File Specification C188 Assessment participation in reading language arts table','EDFacts File Specification v 9.0/Office of Elementary and Secondary Education',150)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.  This connection also includes a listing of the other Data Groups necessary for submitting file C188 - Academic Participation in reading/language arts.', CedsConnectionName = 'Data Group 589, File Specification C188 Assessment participation in reading language arts table', CedsConnectionSource = 'EDFacts File Specification v 9.0/Office of Elementary and Secondary Education'
			where CedsUseCaseId = 150
		END
 
		-----------------------------------------
		-- Data Group 590,  File Specification C189 Assessment participation in science table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  151)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in science.  This connection also includes a listing of the other Data Groups necessary for submitting file C189 - Academic Participation in Science.','Data Group 590,  File Specification C189 Assessment participation in science table','EDFacts File Specification v 9.0\Office of Elementary and Secondary Education',151)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in science.  This connection also includes a listing of the other Data Groups necessary for submitting file C189 - Academic Participation in Science.', CedsConnectionName = 'Data Group 590,  File Specification C189 Assessment participation in science table', CedsConnectionSource = 'EDFacts File Specification v 9.0\Office of Elementary and Secondary Education'
			where CedsUseCaseId = 151
		END
 
		-----------------------------------------
		-- Data Group 613, File Specification C089 Children with disabilities (IDEA) early childhood table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  152)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 3 through 5.','Data Group 613, File Specification C089 Children with disabilities (IDEA) early childhood table','EDFacts File Specification v 9.0/Office of Special Education Programs',152)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 3 through 5.', CedsConnectionName = 'Data Group 613, File Specification C089 Children with disabilities (IDEA) early childhood table', CedsConnectionSource = 'EDFacts File Specification v 9.0/Office of Special Education Programs'
			where CedsUseCaseId = 152
		END
 
		-----------------------------------------
		-- Data Group 695, File Specification C150 Regulatory four-year adjusted-cohort graduation rate table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  153)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students who graduate in four years or less with a regular high school diploma divided by the number of students who formed the cohort.  This connection also includes a listing of other Data Groups necessary for submitting file C150- Regulaory Adjusted-Cohort Graduation Rate.','Data Group 695, File Specification C150 Regulatory four-year adjusted-cohort graduation rate table','EDFacts File Specification v 9.0/Office of Elementary and Secondary Education',153)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students who graduate in four years or less with a regular high school diploma divided by the number of students who formed the cohort.  This connection also includes a listing of other Data Groups necessary for submitting file C150- Regulaory Adjusted-Cohort Graduation Rate.', CedsConnectionName = 'Data Group 695, File Specification C150 Regulatory four-year adjusted-cohort graduation rate table', CedsConnectionSource = 'EDFacts File Specification v 9.0/Office of Elementary and Secondary Education'
			where CedsUseCaseId = 153
		END
 
		-----------------------------------------
		-- Data Group 697, File Specification C150 Regulatory five-year adjusted-cohort graduation rate
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  154)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students who graduate in five years or less with a regular high school diploma divided by the number of students who formed the cohort.  This connection also includes a listing of other Data Groups necessary for submitting file C150- Regulaory Adjusted-Cohort Graduation Rate.','Data Group 697, File Specification C150 Regulatory five-year adjusted-cohort graduation rate','EDFacts File Specification v 9.0/Office of Elementary and Secondary Education',154)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students who graduate in five years or less with a regular high school diploma divided by the number of students who formed the cohort.  This connection also includes a listing of other Data Groups necessary for submitting file C150- Regulaory Adjusted-Cohort Graduation Rate.', CedsConnectionName = 'Data Group 697, File Specification C150 Regulatory five-year adjusted-cohort graduation rate', CedsConnectionSource = 'EDFacts File Specification v 9.0/Office of Elementary and Secondary Education'
			where CedsUseCaseId = 154
		END
 
		-----------------------------------------
		-- Data Group 755, File Specification C150 Regulatory six-year adjusted-cohort graduation rate
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  155)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students who graduate in six years or less with a regular high school diploma divided by the number of students who formed the cohort.  This connection also includes a listing of other Data Groups necessary for submitting file C150- Regulatory Adjusted-Cohort Graduation Rate.','Data Group 755, File Specification C150 Regulatory six-year adjusted-cohort graduation rate','EDFacts File Specification v 9.0\Office of Elementary and Secondary Education',155)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students who graduate in six years or less with a regular high school diploma divided by the number of students who formed the cohort.  This connection also includes a listing of other Data Groups necessary for submitting file C150- Regulatory Adjusted-Cohort Graduation Rate.', CedsConnectionName = 'Data Group 755, File Specification C150 Regulatory six-year adjusted-cohort graduation rate', CedsConnectionSource = 'EDFacts File Specification v 9.0\Office of Elementary and Secondary Education'
			where CedsUseCaseId = 155
		END
 
		-----------------------------------------
		-- Among all young children from birth to age 5 (before kindergarten entry) receiving early childhood services (e.g., child care, pre-k, Head Start, home visiting, early intervention, special education preschool), what percentage receives more than one
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  156)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Among all young children from birth to age 5 (before kindergarten entry) receiving early childhood services (e.g., child care, pre-k, Head Start, home visiting, early intervention, special education preschool), what percentage receives more than one type of early childhood service?','Among all young children from birth to age 5 (before kindergarten entry) receiving early childhood services (e.g., child care, pre-k, Head Start, home visiting, early intervention, special education preschool), what percentage receives more than one','SLDS Community',156)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Among all young children from birth to age 5 (before kindergarten entry) receiving early childhood services (e.g., child care, pre-k, Head Start, home visiting, early intervention, special education preschool), what percentage receives more than one type of early childhood service?', CedsConnectionName = 'Among all young children from birth to age 5 (before kindergarten entry) receiving early childhood services (e.g., child care, pre-k, Head Start, home visiting, early intervention, special education preschool), what percentage receives more than one', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 156
		END
 
		-----------------------------------------
		-- Data Group 696, File Specification C151 Cohorts for regulatory four-year adjusted-cohort graduation rate table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  157)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students in the adjusted cohort for the regulatory four-year adjusted-cohort graduation rate.  This connection also includes a listing of other Data Groups necessary for submitting file C151- Cohorts for Regulatory Adjusted-Cohort Graduation Rate.','Data Group 696, File Specification C151 Cohorts for regulatory four-year adjusted-cohort graduation rate table','EDFacts File Specification v 9.0/Office of Elementary and Secondary Education',157)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students in the adjusted cohort for the regulatory four-year adjusted-cohort graduation rate.  This connection also includes a listing of other Data Groups necessary for submitting file C151- Cohorts for Regulatory Adjusted-Cohort Graduation Rate.', CedsConnectionName = 'Data Group 696, File Specification C151 Cohorts for regulatory four-year adjusted-cohort graduation rate table', CedsConnectionSource = 'EDFacts File Specification v 9.0/Office of Elementary and Secondary Education'
			where CedsUseCaseId = 157
		END
 
		-----------------------------------------
		-- Data Group 698, File Specification C151 Cohorts for regulatory five-year adjusted-cohort graduation rate table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  158)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students in the adjusted cohort for the regulatory five-year adjusted-cohort graduation rate.  This connection also includes a listing of other Data Groups necessary for submitting file C151- Cohorts for Regulatory Adjusted-Cohort Graduation Rate.','Data Group 698, File Specification C151 Cohorts for regulatory five-year adjusted-cohort graduation rate table','EDFacts File Specification v 9.0/Office of Elementary and Secondary Education',158)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students in the adjusted cohort for the regulatory five-year adjusted-cohort graduation rate.  This connection also includes a listing of other Data Groups necessary for submitting file C151- Cohorts for Regulatory Adjusted-Cohort Graduation Rate.', CedsConnectionName = 'Data Group 698, File Specification C151 Cohorts for regulatory five-year adjusted-cohort graduation rate table', CedsConnectionSource = 'EDFacts File Specification v 9.0/Office of Elementary and Secondary Education'
			where CedsUseCaseId = 158
		END
 
		-----------------------------------------
		-- Data Group 756, File Specification C151 Cohorts for regulatory six-year adjusted-cohort graduation rate table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  159)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students in the adjusted cohort for the regulatory six-year adjusted-cohort graduation rate.  This connection also includes a listing of other Data Groups necessary for submitting file C151- Cohorts for Regulatory Adjusted-Cohort Graduation Rate.','Data Group 756, File Specification C151 Cohorts for regulatory six-year adjusted-cohort graduation rate table','EDFacts File Specification v 9.0/Office of Elementary and Secondary Education',159)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students in the adjusted cohort for the regulatory six-year adjusted-cohort graduation rate.  This connection also includes a listing of other Data Groups necessary for submitting file C151- Cohorts for Regulatory Adjusted-Cohort Graduation Rate.', CedsConnectionName = 'Data Group 756, File Specification C151 Cohorts for regulatory six-year adjusted-cohort graduation rate table', CedsConnectionSource = 'EDFacts File Specification v 9.0/Office of Elementary and Secondary Education'
			where CedsUseCaseId = 159
		END
 
		-----------------------------------------
		-- Data Group 381: Teacher quality in elementary classes table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  160)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of elementary classes in core academic subjects.','Data Group 381: Teacher quality in elementary classes table','EDFacts',160)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of elementary classes in core academic subjects.', CedsConnectionName = 'Data Group 381: Teacher quality in elementary classes table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 160
		END
 
		-----------------------------------------
		-- Data Group 383: Teacher quality in core secondary classes table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  161)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of elementary classes in core academic subjects.','Data Group 383: Teacher quality in core secondary classes table','EDFacts',161)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of elementary classes in core academic subjects.', CedsConnectionName = 'Data Group 383: Teacher quality in core secondary classes table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 161
		END
 
		-----------------------------------------
		-- Data Group 422: Title III teachers table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  162)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated headcount of teachers who taught in language instruction educational programs designed for limited English proficient (LEP) students supported with Title III of ESEA funds.','Data Group 422: Title III teachers table','EDFacts',162)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated headcount of teachers who taught in language instruction educational programs designed for limited English proficient (LEP) students supported with Title III of ESEA funds.', CedsConnectionName = 'Data Group 422: Title III teachers table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 162
		END
 
		-----------------------------------------
		-- Data Group 475: Children with disabilities (IDEA) suspensions/expulsions table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  163)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who are ages 3 through 21 and suspended or expelled for disciplinary reasons.','Data Group 475: Children with disabilities (IDEA) suspensions/expulsions table','EDFacts',163)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who are ages 3 through 21 and suspended or expelled for disciplinary reasons.', CedsConnectionName = 'Data Group 475: Children with disabilities (IDEA) suspensions/expulsions table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 163
		END
 
		-----------------------------------------
		-- Data Group 476: Children with disabilities (IDEA) reasons for unilateral removal table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  164)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of times children with disabilities (IDEA) who are ages 3 through 21 and unilaterally removed by school personnel (not the IEP team) from their current educational placement to an interim alternative educational setting (determined by the IEP team) due to drug or weapon offenses or serious bodily injury.','Data Group 476: Children with disabilities (IDEA) reasons for unilateral removal table','EDFacts',164)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of times children with disabilities (IDEA) who are ages 3 through 21 and unilaterally removed by school personnel (not the IEP team) from their current educational placement to an interim alternative educational setting (determined by the IEP team) due to drug or weapon offenses or serious bodily injury.', CedsConnectionName = 'Data Group 476: Children with disabilities (IDEA) reasons for unilateral removal table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 164
		END
 
		-----------------------------------------
		-- Data Group 486: Special education teachers (FTE) table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  165)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full- time equivalent (FTE) special education teachers employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.','Data Group 486: Special education teachers (FTE) table','EDFacts',165)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full- time equivalent (FTE) special education teachers employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.', CedsConnectionName = 'Data Group 486: Special education teachers (FTE) table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 165
		END
 
		-----------------------------------------
		-- Data Group 491: Children with disabilities (IDEA) not participating in assessments table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  166)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who did not participate in and receive a valid score on the state assessments.','Data Group 491: Children with disabilities (IDEA) not participating in assessments table','EDFacts',166)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who did not participate in and receive a valid score on the state assessments.', CedsConnectionName = 'Data Group 491: Children with disabilities (IDEA) not participating in assessments table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 166
		END
 
		-----------------------------------------
		-- Data Group 512: Children with disabilities (IDEA) removal to interim alternative educational setting table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  167)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who are ages 3 through 21 and removed to an interim alternative educational setting.','Data Group 512: Children with disabilities (IDEA) removal to interim alternative educational setting table','EDFacts',167)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who are ages 3 through 21 and removed to an interim alternative educational setting.', CedsConnectionName = 'Data Group 512: Children with disabilities (IDEA) removal to interim alternative educational setting table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 167
		END
 
		-----------------------------------------
		-- Data Group 514: Consolidated MEP funds status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  168)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school has a schoolwide program, as defined by Title I of ESEA as amended, in which federal Migrant Education Program (MEP) funds are consolidated as authorized under 34 CFR Section 200.29.','Data Group 514: Consolidated MEP funds status','EDFacts',168)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school has a schoolwide program, as defined by Title I of ESEA as amended, in which federal Migrant Education Program (MEP) funds are consolidated as authorized under 34 CFR Section 200.29.', CedsConnectionName = 'Data Group 514: Consolidated MEP funds status', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 168
		END
 
		-----------------------------------------
		-- Data Group 515: MEP personnel (FTE) table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  169)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) staff whose salaries are paid by the Title I, Part C Migrant Education Program (MEP) of ESEA as amended.','Data Group 515: MEP personnel (FTE) table','EDFacts',169)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) staff whose salaries are paid by the Title I, Part C Migrant Education Program (MEP) of ESEA as amended.', CedsConnectionName = 'Data Group 515: MEP personnel (FTE) table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 169
		END
 
		-----------------------------------------
		-- Data Group 518: AMAO II ELP attainment
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  170)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication whether the state, district or school met the Annual Measurable Achievement Objectives (AMAO) for attaining English proficiency for limited English proficient (LEP) students under Title III of ESEA','Data Group 518: AMAO II ELP attainment','EDFacts',170)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication whether the state, district or school met the Annual Measurable Achievement Objectives (AMAO) for attaining English proficiency for limited English proficient (LEP) students under Title III of ESEA', CedsConnectionName = 'Data Group 518: AMAO II ELP attainment', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 170
		END
 
		-----------------------------------------
		-- Data Group 544: Public school choice - transferred
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  171)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of eligible students who transferred to another school under the provisions for public school choice in accordance with Title I, Part A, Section 1116 of ESEA as amended.','Data Group 544: Public school choice - transferred','EDFacts',171)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of eligible students who transferred to another school under the provisions for public school choice in accordance with Title I, Part A, Section 1116 of ESEA as amended.', CedsConnectionName = 'Data Group 544: Public school choice - transferred', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 171
		END
 
		-----------------------------------------
		-- Data Group 574: Public school choice - applied for transfer
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  172)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of eligible students who applied/requested to transfer to another public school under the provisions for public school choice in accordance with Title I, Part A, Section 1116 of ESEA as amended.','Data Group 574: Public school choice - applied for transfer','EDFacts',172)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of eligible students who applied/requested to transfer to another public school under the provisions for public school choice in accordance with Title I, Part A, Section 1116 of ESEA as amended.', CedsConnectionName = 'Data Group 574: Public school choice - applied for transfer', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 172
		END
 
		-----------------------------------------
		-- Data Group 700: Public school choice - eligible
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  173)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of students eligible to transfer to another public school under the provisions for public school choice in accordance with Title I, Part A, Section 1116 of ESEA, as amended.','Data Group 700: Public school choice - eligible','EDFacts',173)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of students eligible to transfer to another public school under the provisions for public school choice in accordance with Title I, Part A, Section 1116 of ESEA, as amended.', CedsConnectionName = 'Data Group 700: Public school choice - eligible', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 173
		END
 
		-----------------------------------------
		-- Data Group 523: Discipline incidents table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  174)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative number of times that students were removed from their regular education program for at least an entire school day for discipline.','Data Group 523: Discipline incidents table','EDFacts',174)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative number of times that students were removed from their regular education program for at least an entire school day for discipline.', CedsConnectionName = 'Data Group 523: Discipline incidents table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 174
		END
 
		-----------------------------------------
		-- Data Group 549: Title I TAS services table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  175)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in and served by targeted assistance (TAS) programs under Title I, Part A, Section 1115 of ESEA.','Data Group 549: Title I TAS services table','EDFacts',175)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in and served by targeted assistance (TAS) programs under Title I, Part A, Section 1115 of ESEA.', CedsConnectionName = 'Data Group 549: Title I TAS services table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 175
		END
 
		-----------------------------------------
		-- Data Group 548: Title I SWP/TAS participation table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  176)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of students participating in and served by Title I of ESEA, Part A, Sections 1114 (Schoolwide Programs (SWP)) and 1115 (targeted assistance (TAS) programs).','Data Group 548: Title I SWP/TAS participation table','EDFacts',176)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of students participating in and served by Title I of ESEA, Part A, Sections 1114 (Schoolwide Programs (SWP)) and 1115 (targeted assistance (TAS) programs).', CedsConnectionName = 'Data Group 548: Title I SWP/TAS participation table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 176
		END
 
		-----------------------------------------
		-- Data Group 560: Homeless served (McKinney-Vento) table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  177)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of homeless children/youth enrolled in public schools who receive services under program subgrants funded by the McKinney-Vento Homeless Education Assistance Improvements Act of 2001.','Data Group 560: Homeless served (McKinney-Vento) table','EDFacts',177)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of homeless children/youth enrolled in public schools who receive services under program subgrants funded by the McKinney-Vento Homeless Education Assistance Improvements Act of 2001.', CedsConnectionName = 'Data Group 560: Homeless served (McKinney-Vento) table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 177
		END
 
		-----------------------------------------
		-- Data Group 519: Immigrant table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  178)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who meet the definition of immigrant children and youth in Title III of ESEA as amended Section 3301(6) and are enrolled in elementary and secondary schools.','Data Group 519: Immigrant table','EDFacts',178)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who meet the definition of immigrant children and youth in Title III of ESEA as amended Section 3301(6) and are enrolled in elementary and secondary schools.', CedsConnectionName = 'Data Group 519: Immigrant table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 178
		END
 
		-----------------------------------------
		-- Data Group 550: Title I TAS staff funded (FTE) table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  179)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) targeted assistance (TAS) program staff funded by Title I, Part A, Section 1115 of ESEA as amended.','Data Group 550: Title I TAS staff funded (FTE) table','EDFacts',179)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) targeted assistance (TAS) program staff funded by Title I, Part A, Section 1115 of ESEA as amended.', CedsConnectionName = 'Data Group 550: Title I TAS staff funded (FTE) table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 179
		END
 
		-----------------------------------------
		-- Data Group 625: MEP personnel (headcount) table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  180)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated headcount of staff whose salaries are paid by the Title I, Part C Migrant Education Program (MEP) of ESEA as amended.','Data Group 625: MEP personnel (headcount) table','EDFacts',180)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated headcount of staff whose salaries are paid by the Title I, Part C Migrant Education Program (MEP) of ESEA as amended.', CedsConnectionName = 'Data Group 625: MEP personnel (headcount) table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 180
		END
 
		-----------------------------------------
		-- Data Group 521: CTE concentrators exiting table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  181)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of career and technical education (CTE) concentrators who left secondary education.','Data Group 521: CTE concentrators exiting table','EDFacts',181)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of career and technical education (CTE) concentrators who left secondary education.', CedsConnectionName = 'Data Group 521: CTE concentrators exiting table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 181
		END
 
		-----------------------------------------
		-- Data Group 596: Students involved with firearms table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  182)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were involved in an incident involving a firearm.','Data Group 596: Students involved with firearms table','EDFacts',182)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were involved in an incident involving a firearm.', CedsConnectionName = 'Data Group 596: Students involved with firearms table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 182
		END
 
		-----------------------------------------
		-- Data Group 598: Children with disabilities (IDEA) disciplinary removals table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  183)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 3 through 21 who were subject to any kind of disciplinary removal during the school year.','Data Group 598: Children with disabilities (IDEA) disciplinary removals table','EDFacts',183)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 3 through 21 who were subject to any kind of disciplinary removal during the school year.', CedsConnectionName = 'Data Group 598: Children with disabilities (IDEA) disciplinary removals table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 183
		END
 
		-----------------------------------------
		-- Data Group 601: Firearm incidents table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  184)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of incidents involving students who brought or possessed firearms at school.','Data Group 601: Firearm incidents table','EDFacts',184)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of incidents involving students who brought or possessed firearms at school.', CedsConnectionName = 'Data Group 601: Firearm incidents table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 184
		END
 
		-----------------------------------------
		-- Data Group 609: Special education related services personnel (FTE) table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  185)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) related services personnel employed or contracted to provide related services for children with disabilities (IDEA) who are ages 3 through 21.','Data Group 609: Special education related services personnel (FTE) table','EDFacts',185)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) related services personnel employed or contracted to provide related services for children with disabilities (IDEA) who are ages 3 through 21.', CedsConnectionName = 'Data Group 609: Special education related services personnel (FTE) table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 185
		END
 
		-----------------------------------------
		-- Data Group 569: AMAO I ELP making progress
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  186)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication whether the state, district, or school met the Annual Measurable Achievement Objective (AMAO) for making progress in learning English for limited English proficient (LEP) students under Title III of ESEA as amended.','Data Group 569: AMAO I ELP making progress','EDFacts',186)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication whether the state, district, or school met the Annual Measurable Achievement Objective (AMAO) for making progress in learning English for limited English proficient (LEP) students under Title III of ESEA as amended.', CedsConnectionName = 'Data Group 569: AMAO I ELP making progress', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 186
		END
 
		-----------------------------------------
		-- Data Group 617: Alternate approach status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  187)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the district or school used an approved alternate approach for calculating Adequate Yearly Progress (AYP).','Data Group 617: Alternate approach status','EDFacts',187)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the district or school used an approved alternate approach for calculating Adequate Yearly Progress (AYP).', CedsConnectionName = 'Data Group 617: Alternate approach status', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 187
		END
 
		-----------------------------------------
		-- Data Group 688: AMAO III AYP for LEP
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  188)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the state or district met the annual measurable objectives for the Limited English Proficient (LEP) student subgroup in mathematics and reading/language arts.','Data Group 688: AMAO III AYP for LEP','EDFacts',188)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the state or district met the annual measurable objectives for the Limited English Proficient (LEP) student subgroup in mathematics and reading/language arts.', CedsConnectionName = 'Data Group 688: AMAO III AYP for LEP', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 188
		END
 
		-----------------------------------------
		-- Data Group 699: State poverty designation
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  189)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The designation of a school’s poverty quartile for purposes of determining classes taught by highly qualified teachers in high and low poverty schools, according to state’s indicator of poverty.','Data Group 699: State poverty designation','EDFacts',189)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The designation of a school’s poverty quartile for purposes of determining classes taught by highly qualified teachers in high and low poverty schools, according to state’s indicator of poverty.', CedsConnectionName = 'Data Group 699: State poverty designation', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 189
		END
 
		-----------------------------------------
		-- Data Group 556: Elementary/middle additional indicator status table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  190)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or district met the Elementary/Middle Additional Indicator requirement in accordance with state definition.','Data Group 556: Elementary/middle additional indicator status table','EDFacts',190)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or district met the Elementary/Middle Additional Indicator requirement in accordance with state definition.', CedsConnectionName = 'Data Group 556: Elementary/middle additional indicator status table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 190
		END
 
		-----------------------------------------
		-- Data Group 557: High school graduation rate indicator status table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  191)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or district met the High School Graduation Rate requirement in accordance with state definition.','Data Group 557: High school graduation rate indicator status table','EDFacts',191)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or district met the High School Graduation Rate requirement in accordance with state definition.', CedsConnectionName = 'Data Group 557: High school graduation rate indicator status table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 191
		END
 
		-----------------------------------------
		-- Data Group 555: Mathematics participation status table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  192)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or district met the 95 percent participation requirement in the mathematics assessment in accordance with state definition.','Data Group 555: Mathematics participation status table','EDFacts',192)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or district met the 95 percent participation requirement in the mathematics assessment in accordance with state definition.', CedsConnectionName = 'Data Group 555: Mathematics participation status table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 192
		END
 
		-----------------------------------------
		-- Data Group 554: AMO mathematics status table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  193)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or district met the math proficiency target in accordance with state definition.','Data Group 554: AMO mathematics status table','EDFacts',193)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or district met the math proficiency target in accordance with state definition.', CedsConnectionName = 'Data Group 554: AMO mathematics status table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 193
		END
 
		-----------------------------------------
		-- Data Group 553: Reading/language arts participation status table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  194)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or district met the 95 percent participation requirement on the reading/language arts assessment in accordance with state definition.','Data Group 553: Reading/language arts participation status table','EDFacts',194)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or district met the 95 percent participation requirement on the reading/language arts assessment in accordance with state definition.', CedsConnectionName = 'Data Group 553: Reading/language arts participation status table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 194
		END
 
		-----------------------------------------
		-- Data Group 552: AMO reading/language arts status table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  195)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or district met the reading/language arts proficiency target in accordance with state definition.','Data Group 552: AMO reading/language arts status table','EDFacts',195)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or district met the reading/language arts proficiency target in accordance with state definition.', CedsConnectionName = 'Data Group 552: AMO reading/language arts status table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 195
		END
 
		-----------------------------------------
		-- Data Group 647: Special education paraprofessionals (FTE) table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  196)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) paraprofessionals employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.','Data Group 647: Special education paraprofessionals (FTE) table','EDFacts',196)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) paraprofessionals employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.', CedsConnectionName = 'Data Group 647: Special education paraprofessionals (FTE) table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 196
		END
 
		-----------------------------------------
		-- Data Group 628: N or D academic achievement table - State Agency
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  197)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students served by Title I, Part D, Subpart 1 of ESEA as amended for at least 90 consecutive days during the reporting period who took both a pre- and post-test.','Data Group 628: N or D academic achievement table - State Agency','EDFacts',197)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students served by Title I, Part D, Subpart 1 of ESEA as amended for at least 90 consecutive days during the reporting period who took both a pre- and post-test.', CedsConnectionName = 'Data Group 628: N or D academic achievement table - State Agency', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 197
		END
 
		-----------------------------------------
		-- Data Group 655: Homeless students enrolled table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  198)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of homeless students enrolled in public schools at any time during the school year.','Data Group 655: Homeless students enrolled table','EDFacts',198)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of homeless students enrolled in public schools at any time during the school year.', CedsConnectionName = 'Data Group 655: Homeless students enrolled table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 198
		END
 
		-----------------------------------------
		-- Data Group 656: N or D participation table for State Agency
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  199)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (state agencies) of ESEA as amended by NCLB.','Data Group 656: N or D participation table for State Agency','EDFacts',199)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (state agencies) of ESEA as amended by NCLB.', CedsConnectionName = 'Data Group 656: N or D participation table for State Agency', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 199
		END
 
		-----------------------------------------
		-- Data Group 634: Migrant students eligible 12-month table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  200)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of eligible migrant students.','Data Group 634: Migrant students eligible 12-month table','EDFacts',200)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of eligible migrant students.', CedsConnectionName = 'Data Group 634: Migrant students eligible 12-month table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 200
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C122 MEP Students Eligible and Served – Summer/Intersession
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  201)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of eligible migrant students served by a Migrant Education Program (MEP) during the summer/intersession term.','SY 2014-15 EDFacts File Specification C122 MEP Students Eligible and Served – Summer/Intersession','EDFacts File Specification C122 Version 11.1',201)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of eligible migrant students served by a Migrant Education Program (MEP) during the summer/intersession term.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C122 MEP Students Eligible and Served – Summer/Intersession', CedsConnectionSource = 'EDFacts File Specification C122 Version 11.1'
			where CedsUseCaseId = 201
		END
 
		-----------------------------------------
		-- Data Group 637: MEP students served summer/intersession table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  202)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of participating migrant students who received instructional or support services in a Migrant Education Program (MEP) during the summer/intersession term.','Data Group 637: MEP students served summer/intersession table','EDFacts',202)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of participating migrant students who received instructional or support services in a Migrant Education Program (MEP) during the summer/intersession term.', CedsConnectionName = 'Data Group 637: MEP students served summer/intersession table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 202
		END
 
		-----------------------------------------
		-- Data Group 636: MEP students served regular school year table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  203)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of participating migrant students who received instructional or supporting services in a Migrant Education Program (MEP).','Data Group 636: MEP students served regular school year table','EDFacts',203)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of participating migrant students who received instructional or supporting services in a Migrant Education Program (MEP).', CedsConnectionName = 'Data Group 636: MEP students served regular school year table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 203
		END
 
		-----------------------------------------
		-- Data Group 629: N or D academic achievement table - LEA
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  204)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students served by Title I, Part D, Subpart 2 of ESEA as amended for at least 90 consecutive days during the reporting period who took both a pre- and post-test.','Data Group 629: N or D academic achievement table - LEA','EDFacts',204)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students served by Title I, Part D, Subpart 2 of ESEA as amended for at least 90 consecutive days during the reporting period who took both a pre- and post-test.', CedsConnectionName = 'Data Group 629: N or D academic achievement table - LEA', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 204
		END
 
		-----------------------------------------
		-- Data Group 648: Title III LEP students served table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  205)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of limited English proficient (LEP) students served by an English language instruction educational program supported with Title III of ESEA funds.','Data Group 648: Title III LEP students served table','EDFacts',205)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of limited English proficient (LEP) students served by an English language instruction educational program supported with Title III of ESEA funds.', CedsConnectionName = 'Data Group 648: Title III LEP students served table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 205
		END
 
		-----------------------------------------
		-- Data Group 668: Title III former LEP students table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  206)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of monitored former LEP students who are no longer receiving services and are being monitored for two consecutive years on content achievement under Title III of ESEA as amended.','Data Group 668: Title III former LEP students table','EDFacts',206)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of monitored former LEP students who are no longer receiving services and are being monitored for two consecutive years on content achievement under Title III of ESEA as amended.', CedsConnectionName = 'Data Group 668: Title III former LEP students table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 206
		END
 
		-----------------------------------------
		-- Data Group 657: N or D participation table - LEA
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  207)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected, delinquent, or at-risk students (N or D) under Title I, Part D, Subpart 2 (LEA) of ESEA as amended.','Data Group 657: N or D participation table - LEA','EDFacts',207)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected, delinquent, or at-risk students (N or D) under Title I, Part D, Subpart 2 (LEA) of ESEA as amended.', CedsConnectionName = 'Data Group 657: N or D participation table - LEA', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 207
		END
 
		-----------------------------------------
		-- Data Group 546: SES - received services
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  208)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of eligible students who received supplemental educational services during the school year in accordance with Title I, Part A, Section 1116 of ESEA as amended.','Data Group 546: SES - received services','EDFacts',208)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of eligible students who received supplemental educational services during the school year in accordance with Title I, Part A, Section 1116 of ESEA as amended.', CedsConnectionName = 'Data Group 546: SES - received services', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 208
		END
 
		-----------------------------------------
		-- Data Group 575: SES - applied to receive services
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  209)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of eligible students who applied/requested to receive supplemental educational services under Title 1 of ESEA as amended, Part A, Section 1116 during the school year.','Data Group 575: SES - applied to receive services','EDFacts',209)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of eligible students who applied/requested to receive supplemental educational services under Title 1 of ESEA as amended, Part A, Section 1116 during the school year.', CedsConnectionName = 'Data Group 575: SES - applied to receive services', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 209
		END
 
		-----------------------------------------
		-- Data Group 578: SES - eligible to receive services
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  210)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of students who were eligible to receive supplemental educational services during the school year under Section 1116 of Title I, Part A of ESEA as amended.','Data Group 578: SES - eligible to receive services','EDFacts',210)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of students who were eligible to receive supplemental educational services during the school year under Section 1116 of Title I, Part A of ESEA as amended.', CedsConnectionName = 'Data Group 578: SES - eligible to receive services', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 210
		END
 
		-----------------------------------------
		-- Data Group 662: Improvement status - LEA
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  211)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of the improvement stage of the local education agency (LEA).','Data Group 662: Improvement status - LEA','EDFacts',211)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of the improvement stage of the local education agency (LEA).', CedsConnectionName = 'Data Group 662: Improvement status - LEA', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 211
		END
 
		-----------------------------------------
		-- Data Group 741: Persistently lowest-achieving school
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  212)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether or not the school has been identified by the state as persistently lowest-achieving','Data Group 741: Persistently lowest-achieving school','EDFacts',212)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether or not the school has been identified by the state as persistently lowest-achieving', CedsConnectionName = 'Data Group 741: Persistently lowest-achieving school', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 212
		END
 
		-----------------------------------------
		-- Data Group 524: Integrated technology status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  213)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of the extent to which the district has effectively and fully integrated technology, as defined by the state','Data Group 524: Integrated technology status','EDFacts',213)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of the extent to which the district has effectively and fully integrated technology, as defined by the state', CedsConnectionName = 'Data Group 524: Integrated technology status', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 213
		END
 
		-----------------------------------------
		-- Data Group 614: REAP alternative funding status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  214)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication that the local education agency (LEA) notified the state of the LEA''s intention to use REAP-Flex Alternative Uses of Funding Authority during the school year as specified in the Title VI, Section 6211 of ESEA as amended.','Data Group 614: REAP alternative funding status','EDFacts',214)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication that the local education agency (LEA) notified the state of the LEA''s intention to use REAP-Flex Alternative Uses of Funding Authority during the school year as specified in the Title VI, Section 6211 of ESEA as amended.', CedsConnectionName = 'Data Group 614: REAP alternative funding status', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 214
		END
 
		-----------------------------------------
		-- Data Group 693: School Improvement Funds status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  215)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school received funds under Section 1003 of ESEA, as amended.','Data Group 693: School Improvement Funds status','EDFacts',215)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school received funds under Section 1003 of ESEA, as amended.', CedsConnectionName = 'Data Group 693: School Improvement Funds status', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 215
		END
 
		-----------------------------------------
		-- Data Group 694: School Improvement Funds allocation table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  216)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Economically disadvantaged students, School Improvement Funds status, School poverty percentage','Data Group 694: School Improvement Funds allocation table','EDFacts',216)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Economically disadvantaged students, School Improvement Funds status, School poverty percentage', CedsConnectionName = 'Data Group 694: School Improvement Funds allocation table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 216
		END
 
		-----------------------------------------
		-- Data Group 670: Title I participation table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  217)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of students participating in and served by programs under Title I, Part A of ESEA as amended.','Data Group 670: Title I participation table','EDFacts',217)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of students participating in and served by programs under Title I, Part A of ESEA as amended.', CedsConnectionName = 'Data Group 670: Title I participation table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 217
		END
 
		-----------------------------------------
		-- Data Group 671: N or D long term table - LEA
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  218)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students served for at least 90 consecutive days during the reporting period by Title I, Part D, Subpart 2 of ESEA as amended.','Data Group 671: N or D long term table - LEA','EDFacts',218)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students served for at least 90 consecutive days during the reporting period by Title I, Part D, Subpart 2 of ESEA as amended.', CedsConnectionName = 'Data Group 671: N or D long term table - LEA', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 218
		END
 
		-----------------------------------------
		-- Data Group 672: N or D long term table - State Agency
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  219)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students served for at least 90 consecutive days during the reporting period by Title I, Part D, Subpart 1 of ESEA as amended.','Data Group 672: N or D long term table - State Agency','EDFacts',219)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students served for at least 90 consecutive days during the reporting period by Title I, Part D, Subpart 1 of ESEA as amended.', CedsConnectionName = 'Data Group 672: N or D long term table - State Agency', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 219
		END
 
		-----------------------------------------
		-- Data Group 673: Students disciplined table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  220)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students removed from their regular education program for at least an entire school day for discipline.','Data Group 673: Students disciplined table','EDFacts',220)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students removed from their regular education program for at least an entire school day for discipline.', CedsConnectionName = 'Data Group 673: Students disciplined table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 220
		END
 
		-----------------------------------------
		-- Data Group 674: LEP English language proficiency test table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  221)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of LEP students who were enrolled at the time of the State annual English language proficiency assessment.','Data Group 674: LEP English language proficiency test table','EDFacts',221)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of LEP students who were enrolled at the time of the State annual English language proficiency assessment.', CedsConnectionName = 'Data Group 674: LEP English language proficiency test table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 221
		END
 
		-----------------------------------------
		-- Data Group 675: Title III LEP English language proficiency test table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  222)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the time of the state annual English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA funds.','Data Group 675: Title III LEP English language proficiency test table','EDFacts',222)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the time of the state annual English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA funds.', CedsConnectionName = 'Data Group 675: Title III LEP English language proficiency test table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 222
		END
 
		-----------------------------------------
		-- Data Group 676: LEP English language proficiency results table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  223)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of LEP students who took the annual state English language proficiency assessment.','Data Group 676: LEP English language proficiency results table','EDFacts',223)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of LEP students who took the annual state English language proficiency assessment.', CedsConnectionName = 'Data Group 676: LEP English language proficiency results table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 223
		END
 
		-----------------------------------------
		-- Data Group 678: LEP enrolled table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  224)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of LEP students enrolled in an elementary or secondary school at any time during the school year.','Data Group 678: LEP enrolled table','EDFacts',224)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of LEP students enrolled in an elementary or secondary school at any time during the school year.', CedsConnectionName = 'Data Group 678: LEP enrolled table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 224
		END
 
		-----------------------------------------
		-- Data Group 681: CTE concentrators academic achievement table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  225)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of career and technical education (CTE) concentrators who left secondary education during the school year for whom a proficiency score on the state assessment was included in the state’s calculation of adequate yearly progress (AYP).','Data Group 681: CTE concentrators academic achievement table','EDFacts',225)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of career and technical education (CTE) concentrators who left secondary education during the school year for whom a proficiency score on the state assessment was included in the state’s calculation of adequate yearly progress (AYP).', CedsConnectionName = 'Data Group 681: CTE concentrators academic achievement table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 225
		END
 
		-----------------------------------------
		-- Data Group 682: Children with disabilities (IDEA) total disciplinary removals table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  226)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of times children with disabilities (IDEA) who are ages 3 through 21 and subject to any kind of disciplinary action.','Data Group 682: Children with disabilities (IDEA) total disciplinary removals table','EDFacts',226)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of times children with disabilities (IDEA) who are ages 3 through 21 and subject to any kind of disciplinary action.', CedsConnectionName = 'Data Group 682: Children with disabilities (IDEA) total disciplinary removals table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 226
		END
 
		-----------------------------------------
		-- Data Group 683: Educational services during expulsion table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  227)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children (students) who were removed for disciplinary reasons from their regular school program for the remainder of the school year or longer, including all removals resulting from violations of the Gun-Free Schools Act (GFSA) of 1994.','Data Group 683: Educational services during expulsion table','EDFacts',227)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children (students) who were removed for disciplinary reasons from their regular school program for the remainder of the school year or longer, including all removals resulting from violations of the Gun-Free Schools Act (GFSA) of 1994.', CedsConnectionName = 'Data Group 683: Educational services during expulsion table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 227
		END
 
		-----------------------------------------
		-- Data Group 684: MEP services table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  228)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of participating migrant children who receive services funded by MEP.','Data Group 684: MEP services table','EDFacts',228)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of participating migrant children who receive services funded by MEP.', CedsConnectionName = 'Data Group 684: MEP services table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 228
		END
 
		-----------------------------------------
		-- Data Group 689: Children with disabilities (IDEA) alternate assessment caps table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  229)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who scored at or above proficient on an alternate assessment and were counted as proficient for adequate yearly progress (AYP) determinations.','Data Group 689: Children with disabilities (IDEA) alternate assessment caps table','EDFacts',229)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who scored at or above proficient on an alternate assessment and were counted as proficient for adequate yearly progress (AYP) determinations.', CedsConnectionName = 'Data Group 689: Children with disabilities (IDEA) alternate assessment caps table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 229
		END
 
		-----------------------------------------
		-- Data Group 686: Corrective actions table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  230)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of schools in improvement status implementing a corrective action.','Data Group 686: Corrective actions table','EDFacts',230)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of schools in improvement status implementing a corrective action.', CedsConnectionName = 'Data Group 686: Corrective actions table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 230
		END
 
		-----------------------------------------
		-- Data Group 687: Restructuring action table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  231)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of schools in improvement status implementing a restructuring action.','Data Group 687: Restructuring action table','EDFacts',231)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of schools in improvement status implementing a restructuring action.', CedsConnectionName = 'Data Group 687: Restructuring action table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 231
		END
 
		-----------------------------------------
		-- Data Group 702: CTE concentrator in graduate rate table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  232)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who were included in the state’s computation of its graduation rate as described in section 1111 (b)(2)(C)(vi) of the ESEA.','Data Group 702: CTE concentrator in graduate rate table','EDFacts',232)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who were included in the state’s computation of its graduation rate as described in section 1111 (b)(2)(C)(vi) of the ESEA.', CedsConnectionName = 'Data Group 702: CTE concentrator in graduate rate table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 232
		END
 
		-----------------------------------------
		-- Data Group 704: CTE concentrators in programs for non-traditional table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  233)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who completed a program that leads to employment in non-traditional fields.','Data Group 704: CTE concentrators in programs for non-traditional table','EDFacts',233)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who completed a program that leads to employment in non-traditional fields.', CedsConnectionName = 'Data Group 704: CTE concentrators in programs for non-traditional table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 233
		END
 
		-----------------------------------------
		-- Data Group 705: CTE concentrators technical skills table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  234)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who took technical skill assessments that are aligned with industry-recognized standards.','Data Group 705: CTE concentrators technical skills table','EDFacts',234)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who took technical skill assessments that are aligned with industry-recognized standards.', CedsConnectionName = 'Data Group 705: CTE concentrators technical skills table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 234
		END
 
		-----------------------------------------
		-- Data Group 736: CTE concentrators placement table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  235)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of career and technical education (CTE) concentrators who left secondary education in the cohort which graduated the prior program year.','Data Group 736: CTE concentrators placement table','EDFacts',235)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of career and technical education (CTE) concentrators who left secondary education in the cohort which graduated the prior program year.', CedsConnectionName = 'Data Group 736: CTE concentrators placement table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 235
		END
 
		-----------------------------------------
		-- Data Group 753: CTE concentrators placement type table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  236)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of career and technical education (CTE) concentrators who left secondary education in the cohort which graduated the prior program year and were placed.','Data Group 753: CTE concentrators placement type table','EDFacts',236)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of career and technical education (CTE) concentrators who left secondary education in the cohort which graduated the prior program year and were placed.', CedsConnectionName = 'Data Group 753: CTE concentrators placement type table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 236
		END
 
		-----------------------------------------
		-- Data Group 730: Average scale score table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  237)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The average scale scores on the state assessments in mathematics and reading/language arts for students for whom a scale score was determined','Data Group 730: Average scale score table','EDFacts',237)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The average scale scores on the state assessments in mathematics and reading/language arts for students for whom a scale score was determined', CedsConnectionName = 'Data Group 730: Average scale score table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 237
		END
 
		-----------------------------------------
		-- Data Group 751: Achievement percentile table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  238)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The scale score at the cut point for a specific achievement percentile on the state assessments in mathematics and reading/language arts.','Data Group 751: Achievement percentile table','EDFacts',238)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The scale score at the cut point for a specific achievement percentile on the state assessments in mathematics and reading/language arts.', CedsConnectionName = 'Data Group 751: Achievement percentile table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 238
		END
 
		-----------------------------------------
		-- Data Group 740: HS graduates postsecondary credit earned table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  239)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Students who enroll in a public IHE (as defined in section 101(a) of the HEA) in the state within 16 months of receiving a regular high school diploma and who complete at least one year''s worth of college credit applicable to a degree within two years of enrollment in the IHE.','Data Group 740: HS graduates postsecondary credit earned table','EDFacts',239)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Students who enroll in a public IHE (as defined in section 101(a) of the HEA) in the state within 16 months of receiving a regular high school diploma and who complete at least one year''s worth of college credit applicable to a degree within two years of enrollment in the IHE.', CedsConnectionName = 'Data Group 740: HS graduates postsecondary credit earned table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 239
		END
 
		-----------------------------------------
		-- Data Group 603: GFSA reporting status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  240)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or local education agency (LEA) submitted a Gun-Free Schools Act (GFSA) of 1994 report to the state, as defined by Title 18, Section 921.','Data Group 603: GFSA reporting status','EDFacts',240)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or local education agency (LEA) submitted a Gun-Free Schools Act (GFSA) of 1994 report to the state, as defined by Title 18, Section 921.', CedsConnectionName = 'Data Group 603: GFSA reporting status', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 240
		END
 
		-----------------------------------------
		-- Data Group 664: Truants
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  241)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of truants as defined by state, using threshold definition.','Data Group 664: Truants','EDFacts',241)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of truants as defined by state, using threshold definition.', CedsConnectionName = 'Data Group 664: Truants', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 241
		END
 
		-----------------------------------------
		-- Data Group 651: SES funds spent
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  242)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The dollar amount spent on supplemental educational services during the school year under Title I, Part A, Section 1116 of ESEA as amended.','Data Group 651: SES funds spent','EDFacts',242)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The dollar amount spent on supplemental educational services during the school year under Title I, Part A, Section 1116 of ESEA as amended.', CedsConnectionName = 'Data Group 651: SES funds spent', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 242
		END
 
		-----------------------------------------
		-- Data Group 652: Public school choice funds spent
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  243)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The dollar amount spent on transportation for public school choice during the school year under Title I of ESEA as amended, Part A, Section 1116.','Data Group 652: Public school choice funds spent','EDFacts',243)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The dollar amount spent on transportation for public school choice during the school year under Title I of ESEA as amended, Part A, Section 1116.', CedsConnectionName = 'Data Group 652: Public school choice funds spent', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 243
		END
 
		-----------------------------------------
		-- Data Group 679: Public school choice/SES 20 percent obligation
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  244)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The dollar amount of the 20 percent reservation for supplemental educational services and choice-related transportation.','Data Group 679: Public school choice/SES 20 percent obligation','EDFacts',244)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The dollar amount of the 20 percent reservation for supplemental educational services and choice-related transportation.', CedsConnectionName = 'Data Group 679: Public school choice/SES 20 percent obligation', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 244
		END
 
		-----------------------------------------
		-- Data Group 680: SES per pupil expenditure
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  245)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The maximum dollar amount that may be spent per child for expenditures related to supplemental educational services under Title I of the ESEA.','Data Group 680: SES per pupil expenditure','EDFacts',245)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The maximum dollar amount that may be spent per child for expenditures related to supplemental educational services under Title I of the ESEA.', CedsConnectionName = 'Data Group 680: SES per pupil expenditure', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 245
		END
 
		-----------------------------------------
		-- Data Group 701: Public school choice implementation
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  246)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the LEA was able to implement the provisions for public school choice under Title I, Part A, Section 1116 of ESEA as amended','Data Group 701: Public school choice implementation','EDFacts',246)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the LEA was able to implement the provisions for public school choice under Title I, Part A, Section 1116 of ESEA as amended', CedsConnectionName = 'Data Group 701: Public school choice implementation', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 246
		END
 
		-----------------------------------------
		-- Data Group 737: Teacher evaluations table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  247)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of teachers','Data Group 737: Teacher evaluations table','EDFacts',247)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of teachers', CedsConnectionName = 'Data Group 737: Teacher evaluations table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 247
		END
 
		-----------------------------------------
		-- Data Group 738: Principal evaluations table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  248)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of principals','Data Group 738: Principal evaluations table','EDFacts',248)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of principals', CedsConnectionName = 'Data Group 738: Principal evaluations table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 248
		END
 
		-----------------------------------------
		-- Data Group 747: Teacher performance level names table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  249)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The name of the levels used in district evaluation systems for assigning teacher performance ratings','Data Group 747: Teacher performance level names table','EDFacts',249)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The name of the levels used in district evaluation systems for assigning teacher performance ratings', CedsConnectionName = 'Data Group 747: Teacher performance level names table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 249
		END
 
		-----------------------------------------
		-- Data Group 748: Principal performance level names table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  250)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The name of the levels used in district evaluation systems for assigning principal performance ratings','Data Group 748: Principal performance level names table','EDFacts',250)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The name of the levels used in district evaluation systems for assigning principal performance ratings', CedsConnectionName = 'Data Group 748: Principal performance level names table', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 250
		END
 
		-----------------------------------------
		-- Data Group 728: Intervention used
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  251)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The type of intervention used by the school under the School Improvement Grant (SIG)','Data Group 728: Intervention used','EDFacts',251)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The type of intervention used by the school under the School Improvement Grant (SIG)', CedsConnectionName = 'Data Group 728: Intervention used', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 251
		END
 
		-----------------------------------------
		-- Data Group 729: School year minutes
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  252)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of minutes that all students were required to be at school and any additional learning time (e.g., before or after school, weekend school, summer school) for which all students had the opportunity to participate.','Data Group 729: School year minutes','EDFacts',252)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of minutes that all students were required to be at school and any additional learning time (e.g., before or after school, weekend school, summer school) for which all students had the opportunity to participate.', CedsConnectionName = 'Data Group 729: School year minutes', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 252
		END
 
		-----------------------------------------
		-- Data Group 731: Student attendance rate
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  253)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The attendance rate based on the state''s definition of attendance in state law or regulation or in the absence of a state law or regulation, the student attendance rate is the count of school days during the regular school year (plus summer, as applicable, if part of implementing the restart, transformation, or turnaround model) students attended school divided by the maximum number of days students were enrolled in school during the regular school year.','Data Group 731: Student attendance rate','EDFacts',253)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The attendance rate based on the state''s definition of attendance in state law or regulation or in the absence of a state law or regulation, the student attendance rate is the count of school days during the regular school year (plus summer, as applicable, if part of implementing the restart, transformation, or turnaround model) students attended school divided by the maximum number of days students were enrolled in school during the regular school year.', CedsConnectionName = 'Data Group 731: Student attendance rate', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 253
		END
 
		-----------------------------------------
		-- Data Group 732: Advanced coursework
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  254)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students who complete advanced coursework (such as Advanced Placement, International Baccalaureate classes, or advanced mathematics).','Data Group 732: Advanced coursework','EDFacts',254)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students who complete advanced coursework (such as Advanced Placement, International Baccalaureate classes, or advanced mathematics).', CedsConnectionName = 'Data Group 732: Advanced coursework', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 254
		END
 
		-----------------------------------------
		-- Data Group 733: Dual enrollment classes
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  255)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of high school students who complete at least one class in a postsecondary institution.','Data Group 733: Dual enrollment classes','EDFacts',255)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of high school students who complete at least one class in a postsecondary institution.', CedsConnectionName = 'Data Group 733: Dual enrollment classes', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 255
		END
 
		-----------------------------------------
		-- Data Group 734: Advanced coursework / dual enrollment classes
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  256)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students who complete advance coursework AND complete at least one class in a postsecondary institution.','Data Group 734: Advanced coursework / dual enrollment classes','EDFacts',256)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students who complete advance coursework AND complete at least one class in a postsecondary institution.', CedsConnectionName = 'Data Group 734: Advanced coursework / dual enrollment classes', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 256
		END
 
		-----------------------------------------
		-- Data Group 735: Teacher attendance rate
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  257)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of FTE days teachers worked divided by the maximum number of FTE-teacher working days.','Data Group 735: Teacher attendance rate','EDFacts',257)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of FTE days teachers worked divided by the maximum number of FTE-teacher working days.', CedsConnectionName = 'Data Group 735: Teacher attendance rate', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 257
		END
 
		-----------------------------------------
		-- Data Group 745: Increased learning time
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  258)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The types of increased learning time provided','Data Group 745: Increased learning time','EDFacts',258)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The types of increased learning time provided', CedsConnectionName = 'Data Group 745: Increased learning time', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 258
		END
 
		-----------------------------------------
		-- Data Group 752: Baseline indicator status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  259)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An Indication that the data are baseline data.','Data Group 752: Baseline indicator status','EDFacts',259)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An Indication that the data are baseline data.', CedsConnectionName = 'Data Group 752: Baseline indicator status', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 259
		END
 
		-----------------------------------------
		-- Data Group 594: Charter - approval agency type
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  260)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The type of agency that approved the establishment or continuation of a charter school.','Data Group 594: Charter - approval agency type','EDFacts',260)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The type of agency that approved the establishment or continuation of a charter school.', CedsConnectionName = 'Data Group 594: Charter - approval agency type', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 260
		END
 
		-----------------------------------------
		-- Data Group 605: Charter - school year approved
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  261)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The school year in which a charter school was initially approved.','Data Group 605: Charter - school year approved','EDFacts',261)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The school year in which a charter school was initially approved.', CedsConnectionName = 'Data Group 605: Charter - school year approved', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 261
		END
 
		-----------------------------------------
		-- Data Group 606: Charter - school year school opened
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  262)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The school year that a school initially began providing educational instruction to students.','Data Group 606: Charter - school year school opened','EDFacts',262)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The school year that a school initially began providing educational instruction to students.', CedsConnectionName = 'Data Group 606: Charter - school year school opened', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 262
		END
 
		-----------------------------------------
		-- Data Group 653: Charter school LEA status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  263)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The status of a charter school as an LEA for purposes of federal programs.','Data Group 653: Charter school LEA status','EDFacts',263)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The status of a charter school as an LEA for purposes of federal programs.', CedsConnectionName = 'Data Group 653: Charter school LEA status', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 263
		END
 
		-----------------------------------------
		-- Data Group 654: Charter - school year closed
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  264)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The school year in which a charter school was legally closed.','Data Group 654: Charter - school year closed','EDFacts',264)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The school year in which a charter school was legally closed.', CedsConnectionName = 'Data Group 654: Charter - school year closed', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 264
		END
 
		-----------------------------------------
		-- Data Group 742: Charter school closure reason
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  265)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The school year in which a charter school was legally closed.','Data Group 742: Charter school closure reason','EDFacts',265)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The school year in which a charter school was legally closed.', CedsConnectionName = 'Data Group 742: Charter school closure reason', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 265
		END
 
		-----------------------------------------
		-- Data Group 754: McKinney-Vento subgrant recipient flag
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  266)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the LEA received a McKinney-Vento subgrant.','Data Group 754: McKinney-Vento subgrant recipient flag','EDFacts',266)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the LEA received a McKinney-Vento subgrant.', CedsConnectionName = 'Data Group 754: McKinney-Vento subgrant recipient flag', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 266
		END
 
		-----------------------------------------
		-- Data Group 743: Reconstituted Status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  268)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication that the school was restructured, transformed or otherwise changed as a consequence of the state’s accountability system under ESEA or as a result of School Improvement Grants (SIG), but is not recognized as a new school for CCD purposes.','Data Group 743: Reconstituted Status','EDFacts',268)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication that the school was restructured, transformed or otherwise changed as a consequence of the state’s accountability system under ESEA or as a result of School Improvement Grants (SIG), but is not recognized as a new school for CCD purposes.', CedsConnectionName = 'Data Group 743: Reconstituted Status', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 268
		END
 
		-----------------------------------------
		-- Data Group 39, File Specification C052 Membership Table (LEA)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  317)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The official unduplicated October 1st student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.    This connection is for the LEA level data.','Data Group 39, File Specification C052 Membership Table (LEA)','EDFacts File Specification v 9.0/ National Center for Education Statistics',317)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The official unduplicated October 1st student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.    This connection is for the LEA level data.', CedsConnectionName = 'Data Group 39, File Specification C052 Membership Table (LEA)', CedsConnectionSource = 'EDFacts File Specification v 9.0/ National Center for Education Statistics'
			where CedsUseCaseId = 317
		END
 
		-----------------------------------------
		-- Data Group 39, File Specification C052 Membership Table (State)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  318)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The official unduplicated October 1st student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.    This connection is for the SEA level data.','Data Group 39, File Specification C052 Membership Table (State)','EDFacts File Specification v 9.0/National Center for Education Statistics',318)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The official unduplicated October 1st student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.    This connection is for the SEA level data.', CedsConnectionName = 'Data Group 39, File Specification C052 Membership Table (State)', CedsConnectionSource = 'EDFacts File Specification v 9.0/National Center for Education Statistics'
			where CedsUseCaseId = 318
		END
 
		-----------------------------------------
		-- Basic Directory Data for File Specification N029
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  330)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The basic directory identification and contact information for file specification N029.','Basic Directory Data for File Specification N029','EDFacts',330)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The basic directory identification and contact information for file specification N029.', CedsConnectionName = 'Basic Directory Data for File Specification N029', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 330
		END
 
		-----------------------------------------
		-- Other Directory Data for File Specification N029
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  331)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This connection contains the following Data Groups:    Data Group 551: Supervisory Union Identification Number  Data Group 571: Effective Date  Data Group 669: Out of State Indicator','Other Directory Data for File Specification N029','EDFacts File Specification v 9.0/National Center for Education Statistics',331)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This connection contains the following Data Groups:    Data Group 551: Supervisory Union Identification Number  Data Group 571: Effective Date  Data Group 669: Out of State Indicator', CedsConnectionName = 'Other Directory Data for File Specification N029', CedsConnectionSource = 'EDFacts File Specification v 9.0/National Center for Education Statistics'
			where CedsUseCaseId = 331
		END
 
		-----------------------------------------
		-- Basic Directory Data for File Specification N029
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  333)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This includes the following Data Groups:    Data Group 1: LEA Identifier  Data Group 4: LEA Identifier (state)  Data Group 5: School Identifier (state)  Data Group 7: Education Entity Name  Data Group 8: Address Mailing  Data Group 9: Address Location  Data Group 10: Telephone – Education Entity  Data Group 11: Website Address  Data Group 458: CCSSO Contact  Data Group 570: State Agency Number','Basic Directory Data for File Specification N029','EDFacts File Specification v 9.0/National Center for Education Statistics',333)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This includes the following Data Groups:    Data Group 1: LEA Identifier  Data Group 4: LEA Identifier (state)  Data Group 5: School Identifier (state)  Data Group 7: Education Entity Name  Data Group 8: Address Mailing  Data Group 9: Address Location  Data Group 10: Telephone – Education Entity  Data Group 11: Website Address  Data Group 458: CCSSO Contact  Data Group 570: State Agency Number', CedsConnectionName = 'Basic Directory Data for File Specification N029', CedsConnectionSource = 'EDFacts File Specification v 9.0/National Center for Education Statistics'
			where CedsUseCaseId = 333
		END
 
		-----------------------------------------
		-- EDFacts File Specification C129, CCD School File
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  341)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This connection includes the the following Data Groups: 573 - Shared Time Status, 22 - Title I School Status, 24 - Magnet Status, in addition to a listing of the other data groups necessary for submitting this file','EDFacts File Specification C129, CCD School File','EDFacts File Specification v 9.0',341)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This connection includes the the following Data Groups: 573 - Shared Time Status, 22 - Title I School Status, 24 - Magnet Status, in addition to a listing of the other data groups necessary for submitting this file', CedsConnectionName = 'EDFacts File Specification C129, CCD School File', CedsConnectionSource = 'EDFacts File Specification v 9.0'
			where CedsUseCaseId = 341
		END
 
		-----------------------------------------
		-- Which children and families are and are not being served by which programs/services?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  394)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Which children and families are and are not being served by which programs/services?','Which children and families are and are not being served by which programs/services?','Wisconsin SLDS',394)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Which children and families are and are not being served by which programs/services?', CedsConnectionName = 'Which children and families are and are not being served by which programs/services?', CedsConnectionSource = 'Wisconsin SLDS'
			where CedsUseCaseId = 394
		END
 
		-----------------------------------------
		-- What are the definable characteristics of the state’s Birth-8 workforce?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  395)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What are the definable characteristics of the state’s Birth-8 workforce?','What are the definable characteristics of the state’s Birth-8 workforce?','Maine SLDS',395)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What are the definable characteristics of the state’s Birth-8 workforce?', CedsConnectionName = 'What are the definable characteristics of the state’s Birth-8 workforce?', CedsConnectionSource = 'Maine SLDS'
			where CedsUseCaseId = 395
		END
 
		-----------------------------------------
		-- test replication
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  465)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The official unduplicated October 1st student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.    This connection is for the LEA level data.','test replication','EDFacts',465)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The official unduplicated October 1st student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.    This connection is for the LEA level data.', CedsConnectionName = 'test replication', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 465
		END
 
		-----------------------------------------
		-- What are the definable characteristics of the state''s children who are entering grades K-2
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  498)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('CONNECTION adapted from Maine’s SLDS Early Childhood Policy Questions - Draft 9.26.2012','What are the definable characteristics of the state''s children who are entering grades K-2','Maine SLDS',498)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'CONNECTION adapted from Maine’s SLDS Early Childhood Policy Questions - Draft 9.26.2012', CedsConnectionName = 'What are the definable characteristics of the state''s children who are entering grades K-2', CedsConnectionSource = 'Maine SLDS'
			where CedsUseCaseId = 498
		END
 
		-----------------------------------------
		-- What are the definable characteristics of our state’s Birth to 5 programs?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  499)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Generally lists data elements that might be used to compare birth to age programs.  (This use could be further defined as more focused connections that identify specific questions and the required elements.)','What are the definable characteristics of our state’s Birth to 5 programs?','Adapted from Maine’s SLDS Early Childhood Policy Questions - Draft 9.26.2012',499)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Generally lists data elements that might be used to compare birth to age programs.  (This use could be further defined as more focused connections that identify specific questions and the required elements.)', CedsConnectionName = 'What are the definable characteristics of our state’s Birth to 5 programs?', CedsConnectionSource = 'Adapted from Maine’s SLDS Early Childhood Policy Questions - Draft 9.26.2012'
			where CedsUseCaseId = 499
		END
 
		-----------------------------------------
		-- What definable characteristics exist to measure state schools ability to receive kindergarteners
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  500)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This is a list of data elements that might be used to compare schools on factors that might indicate levels of ability to receive kindergarteners.  (This list may be narrowed down to specific policy questions.  Each could be a connection requiring a more limited set of source data elements and analysis recommendations.)','What definable characteristics exist to measure state schools ability to receive kindergarteners','adapted from Maine’s SLDS Early Childhood Policy Questions - Draft 9.26.2012',500)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This is a list of data elements that might be used to compare schools on factors that might indicate levels of ability to receive kindergarteners.  (This list may be narrowed down to specific policy questions.  Each could be a connection requiring a more limited set of source data elements and analysis recommendations.)', CedsConnectionName = 'What definable characteristics exist to measure state schools ability to receive kindergarteners', CedsConnectionSource = 'adapted from Maine’s SLDS Early Childhood Policy Questions - Draft 9.26.2012'
			where CedsUseCaseId = 500
		END
 
		-----------------------------------------
		-- EDFacts Data Group 39: File Spec C052 Membership : Multi-state based Connection
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  502)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C052 Membership.  This file is the official unduplicated October 1st student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.','EDFacts Data Group 39: File Spec C052 Membership : Multi-state based Connection','EDFacts CEDS Connections Workgroup',502)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C052 Membership.  This file is the official unduplicated October 1st student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.', CedsConnectionName = 'EDFacts Data Group 39: File Spec C052 Membership : Multi-state based Connection', CedsConnectionSource = 'EDFacts CEDS Connections Workgroup'
			where CedsUseCaseId = 502
		END
 
		-----------------------------------------
		-- EDFacts Data Group 696: File Spec C151 Cohorts for Regulatory Adjusted Cohort Graduation Rate - Multi-state based Connection
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  508)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the processes and aggregations necessary to submit this EDFacts file. The number of students in the adjusted cohort for the regulatory four-year adjusted-cohort graduation rate.  This connection also includes a listing of other Data Groups necessary for submitting file C150-  Regulatory Adjusted-Cohort Graduation Rate.','EDFacts Data Group 696: File Spec C151 Cohorts for Regulatory Adjusted Cohort Graduation Rate - Multi-state based Connection','EDFacts CEDS Connection Workgroup',508)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the processes and aggregations necessary to submit this EDFacts file. The number of students in the adjusted cohort for the regulatory four-year adjusted-cohort graduation rate.  This connection also includes a listing of other Data Groups necessary for submitting file C150-  Regulatory Adjusted-Cohort Graduation Rate.', CedsConnectionName = 'EDFacts Data Group 696: File Spec C151 Cohorts for Regulatory Adjusted Cohort Graduation Rate - Multi-state based Connection', CedsConnectionSource = 'EDFacts CEDS Connection Workgroup'
			where CedsUseCaseId = 508
		END
 
		-----------------------------------------
		-- EDFacts Data Group 326: File Spec C032 Dropouts - Multi-state based Connection
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  509)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C032 Dropouts.  The unduplicated number of dropouts','EDFacts Data Group 326: File Spec C032 Dropouts - Multi-state based Connection','EDFacts CEDS Connection Workgroup',509)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C032 Dropouts.  The unduplicated number of dropouts', CedsConnectionName = 'EDFacts Data Group 326: File Spec C032 Dropouts - Multi-state based Connection', CedsConnectionSource = 'EDFacts CEDS Connection Workgroup'
			where CedsUseCaseId = 509
		END
 
		-----------------------------------------
		-- EDFacts File Spec 167 School Improvement Grants - Multi-state based Connection
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  510)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the processes and aggregations necessary for submitting EDFacts File C167 School Improvement Grants.  This file collects data used in monitoring of Tier I and Tier II schools that receive School Improvement Grant Funding under 1003(g) of ESEA.','EDFacts File Spec 167 School Improvement Grants - Multi-state based Connection','EDFacts CEDS Connections Workgroup',510)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the processes and aggregations necessary for submitting EDFacts File C167 School Improvement Grants.  This file collects data used in monitoring of Tier I and Tier II schools that receive School Improvement Grant Funding under 1003(g) of ESEA.', CedsConnectionName = 'EDFacts File Spec 167 School Improvement Grants - Multi-state based Connection', CedsConnectionSource = 'EDFacts CEDS Connections Workgroup'
			where CedsUseCaseId = 510
		END
 
		-----------------------------------------
		-- EDFacts Data Group 548, File 037 Title 1 SWP/TAS Participation - Multi-state based Connection
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  511)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C037 Title 1 Part A Participation.  This file collects the cumulative unduplicated number of students participating in and served by Title I of ESEA, Part A, Sections 1114 (Schoolwide Programs (SWPs)) and 1115 (targeted assistance (TAS) programs).','EDFacts Data Group 548, File 037 Title 1 SWP/TAS Participation - Multi-state based Connection','EDFacts CEDS  Connections Workgroup',511)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C037 Title 1 Part A Participation.  This file collects the cumulative unduplicated number of students participating in and served by Title I of ESEA, Part A, Sections 1114 (Schoolwide Programs (SWPs)) and 1115 (targeted assistance (TAS) programs).', CedsConnectionName = 'EDFacts Data Group 548, File 037 Title 1 SWP/TAS Participation - Multi-state based Connection', CedsConnectionSource = 'EDFacts CEDS  Connections Workgroup'
			where CedsUseCaseId = 511
		END
 
		-----------------------------------------
		-- What is the relationship between student mobility and eighth grade reading/English assessment performance?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  571)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This question is intended to help the SEA understand the relationship between intra- and inter-year mobility rates for subgroups of students attending schools (by size and location) on literacy and reading performance at the end of middle school.','What is the relationship between student mobility and eighth grade reading/English assessment performance?','SEA K12 SLDS',571)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This question is intended to help the SEA understand the relationship between intra- and inter-year mobility rates for subgroups of students attending schools (by size and location) on literacy and reading performance at the end of middle school.', CedsConnectionName = 'What is the relationship between student mobility and eighth grade reading/English assessment performance?', CedsConnectionSource = 'SEA K12 SLDS'
			where CedsUseCaseId = 571
		END
 
		-----------------------------------------
		-- EDFacts Data Group 523, File Spec C030 Discipline Incidents, Multi-state based Connection
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  598)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C030 Discipline Incidents.  This file collects the cumulative number of times that students were removed from their regular education program for at least an entire school day for discipline.','EDFacts Data Group 523, File Spec C030 Discipline Incidents, Multi-state based Connection','EDFacts CEDS Connections Workgroup',598)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C030 Discipline Incidents.  This file collects the cumulative number of times that students were removed from their regular education program for at least an entire school day for discipline.', CedsConnectionName = 'EDFacts Data Group 523, File Spec C030 Discipline Incidents, Multi-state based Connection', CedsConnectionSource = 'EDFacts CEDS Connections Workgroup'
			where CedsUseCaseId = 598
		END
 
		-----------------------------------------
		-- EDFacts Data Group 549, File C036 Title 1 Part A TAS Services, Multi-state based Connection
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  599)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C036 Title 1 Part A TAS Services.  This file collects the number of students participating in and served by targeted assistance (TAS) programs under Title I, Part A, Section 1115 of ESEA.','EDFacts Data Group 549, File C036 Title 1 Part A TAS Services, Multi-state based Connection','EDFacts CEDS Connections Workgroup',599)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C036 Title 1 Part A TAS Services.  This file collects the number of students participating in and served by targeted assistance (TAS) programs under Title I, Part A, Section 1115 of ESEA.', CedsConnectionName = 'EDFacts Data Group 549, File C036 Title 1 Part A TAS Services, Multi-state based Connection', CedsConnectionSource = 'EDFacts CEDS Connections Workgroup'
			where CedsUseCaseId = 599
		END
 
		-----------------------------------------
		-- EDFacts Data Group 151, File Spec 050 Title III LEP English Proficiency Results, Multi-state based Connection
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  600)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C040 Title III LEP English Proficiency Results. This file collects the unduplicated number of limited English proficient (LEP) students who were assessed in the annual state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA funds.','EDFacts Data Group 151, File Spec 050 Title III LEP English Proficiency Results, Multi-state based Connection','EDFacts CEDS Connections Workgroup',600)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C040 Title III LEP English Proficiency Results. This file collects the unduplicated number of limited English proficient (LEP) students who were assessed in the annual state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA funds.', CedsConnectionName = 'EDFacts Data Group 151, File Spec 050 Title III LEP English Proficiency Results, Multi-state based Connection', CedsConnectionSource = 'EDFacts CEDS Connections Workgroup'
			where CedsUseCaseId = 600
		END
 
		-----------------------------------------
		-- EDFacts Data Group 655, File Specification C118 Homeless Enrolled, Multi-state based Connection
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  601)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the processes and aggregations needed to submit EDFacts File C118 Homeless Students Enrolled.  This file collects the cumulative unduplicated number of homeless students enrolled in public schools at any time during the school year','EDFacts Data Group 655, File Specification C118 Homeless Enrolled, Multi-state based Connection','EDFacts CEDS Connections Workgroup',601)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the processes and aggregations needed to submit EDFacts File C118 Homeless Students Enrolled.  This file collects the cumulative unduplicated number of homeless students enrolled in public schools at any time during the school year', CedsConnectionName = 'EDFacts Data Group 655, File Specification C118 Homeless Enrolled, Multi-state based Connection', CedsConnectionSource = 'EDFacts CEDS Connections Workgroup'
			where CedsUseCaseId = 601
		END
 
		-----------------------------------------
		-- EDFacts File Specs C119 and C127 Neglected or Delinquent Participation Multi-state based Connection
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  602)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the processes and aggregations necessary to submit EDFacts Files C119 and C127 Neglected and Delinquent Participation. These files collect the number of students participating in programs for neglected, delinquent, or at–risk students (N or D) under Title I, Part D, Subpart1 (SEA) and Subpart 2 (LEA) of ESEA as amended.','EDFacts File Specs C119 and C127 Neglected or Delinquent Participation Multi-state based Connection','EDFacts CEDS Connections Workgroup',602)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the processes and aggregations necessary to submit EDFacts Files C119 and C127 Neglected and Delinquent Participation. These files collect the number of students participating in programs for neglected, delinquent, or at–risk students (N or D) under Title I, Part D, Subpart1 (SEA) and Subpart 2 (LEA) of ESEA as amended.', CedsConnectionName = 'EDFacts File Specs C119 and C127 Neglected or Delinquent Participation Multi-state based Connection', CedsConnectionSource = 'EDFacts CEDS Connections Workgroup'
			where CedsUseCaseId = 602
		END
 
		-----------------------------------------
		-- EDFacts File Spec 129 CCD Schools, Multi-state based Connection
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  603)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C129 CCD Schools.  This file collects Shared Time Status, Title 1 School Status, Magnet Status and NSLP Status. The data collected using this file specification are used primarily for the Nonfiscal Survey of the Common Core of Data (CCD).','EDFacts File Spec 129 CCD Schools, Multi-state based Connection','EDFacts CEDS Connections Workgroup',603)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C129 CCD Schools.  This file collects Shared Time Status, Title 1 School Status, Magnet Status and NSLP Status. The data collected using this file specification are used primarily for the Nonfiscal Survey of the Common Core of Data (CCD).', CedsConnectionName = 'EDFacts File Spec 129 CCD Schools, Multi-state based Connection', CedsConnectionSource = 'EDFacts CEDS Connections Workgroup'
			where CedsUseCaseId = 603
		END
 
		-----------------------------------------
		-- EDFacts Data Group 684, File Specification C145 MEP Services, Multi-state based Connection
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  604)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C145 MEP Services.  This file collects the number of participating migrant children who receive services funded by MEP.','EDFacts Data Group 684, File Specification C145 MEP Services, Multi-state based Connection','EDFacts CEDS Connections Workgroup',604)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the process and aggregations necessary to submit EDFacts File Specification C145 MEP Services.  This file collects the number of participating migrant children who receive services funded by MEP.', CedsConnectionName = 'EDFacts Data Group 684, File Specification C145 MEP Services, Multi-state based Connection', CedsConnectionSource = 'EDFacts CEDS Connections Workgroup'
			where CedsUseCaseId = 604
		END
 
		-----------------------------------------
		-- EDFacts Data Group 740, File Specification C161 High School Graduate Postsecondary Credits, Multi-state based Connection
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  605)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the processes and aggregations necessary to submit EDFacts files C161 High School Graduates Post-Secondary Credits.  This file collects data about students who enroll in a public institution of higher education in the state within 16 months of receiving a regular high school diploma and who either complete or do not complete at least one year''s worth of college credit applicable to a degree within two years of enrollment in the IHE.','EDFacts Data Group 740, File Specification C161 High School Graduate Postsecondary Credits, Multi-state based Connection','EDFacts CEDS Connections',605)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the processes and aggregations necessary to submit EDFacts files C161 High School Graduates Post-Secondary Credits.  This file collects data about students who enroll in a public institution of higher education in the state within 16 months of receiving a regular high school diploma and who either complete or do not complete at least one year''s worth of college credit applicable to a degree within two years of enrollment in the IHE.', CedsConnectionName = 'EDFacts Data Group 740, File Specification C161 High School Graduate Postsecondary Credits, Multi-state based Connection', CedsConnectionSource = 'EDFacts CEDS Connections'
			where CedsUseCaseId = 605
		END
 
		-----------------------------------------
		-- EDFacts File Spec C166 Evaluation of Staff, Multi-state based Connection
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  606)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the processes and aggregations necessary to submit EDFacts File C161 Evaluation of Staff.  This file collects data on teacher and principal evaluations and performance levels.','EDFacts File Spec C166 Evaluation of Staff, Multi-state based Connection','EDFacts CEDS Connections Workgroup',606)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the processes and aggregations necessary to submit EDFacts File C161 Evaluation of Staff.  This file collects data on teacher and principal evaluations and performance levels.', CedsConnectionName = 'EDFacts File Spec C166 Evaluation of Staff, Multi-state based Connection', CedsConnectionSource = 'EDFacts CEDS Connections Workgroup'
			where CedsUseCaseId = 606
		END
 
		-----------------------------------------
		-- Chronic Absenteeism
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  608)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The goal of this indicator is to identify the extent to which chronic absenteeism occurs by grade level and then to drill down to understand the district, schools, and types of students most impacted.','Chronic Absenteeism','SLDS Community',608)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The goal of this indicator is to identify the extent to which chronic absenteeism occurs by grade level and then to drill down to understand the district, schools, and types of students most impacted.', CedsConnectionName = 'Chronic Absenteeism', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 608
		END
 
		-----------------------------------------
		-- Teacher Effectiveness and Experience
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  609)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The goal of this connection is to understand how teacher effectiveness, as defined as staff evaluation ratings, are related to teachers’ years of experience. We use years of experience in this connection as a measure for teacher quality since research shows that there is a positive relationship between years of experience and teacher effectiveness (as measured by teacher value-added estimates) in the first three to five years of teaching.','Teacher Effectiveness and Experience','SLDS Community',609)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The goal of this connection is to understand how teacher effectiveness, as defined as staff evaluation ratings, are related to teachers’ years of experience. We use years of experience in this connection as a measure for teacher quality since research shows that there is a positive relationship between years of experience and teacher effectiveness (as measured by teacher value-added estimates) in the first three to five years of teaching.', CedsConnectionName = 'Teacher Effectiveness and Experience', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 609
		END
 
		-----------------------------------------
		-- Teacher Effectiveness
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  610)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The goal of this connection is to understand how teacher effectiveness is distributed across states first, and then to better understand how placement might vary at the district and school levels within that state. This metric provide a simple descriptive analysis of teacher effectiveness, which is defined for this connection as a teacher’s staff evaluation outcome.','Teacher Effectiveness','SLDS Community',610)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The goal of this connection is to understand how teacher effectiveness is distributed across states first, and then to better understand how placement might vary at the district and school levels within that state. This metric provide a simple descriptive analysis of teacher effectiveness, which is defined for this connection as a teacher’s staff evaluation outcome.', CedsConnectionName = 'Teacher Effectiveness', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 610
		END
 
		-----------------------------------------
		-- What does placement, retention and evaluation in K-12 look like by four-year undergraduate teacher preparation programs?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  611)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The goal of this connection is to understand how teacher preparation programs differ in the employment outcomes for their students who become teachers of record. This connection spans sectors, potentially K-12, post-secondary and workforce. We primarily focus on this connection as it spans the K-12 and post-secondary sectors. As such, we must track graduates of teacher preparation programs when they are students in post-secondary institutions to when they enter K-12 systems as teachers.','What does placement, retention and evaluation in K-12 look like by four-year undergraduate teacher preparation programs?','SLDS Community',611)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The goal of this connection is to understand how teacher preparation programs differ in the employment outcomes for their students who become teachers of record. This connection spans sectors, potentially K-12, post-secondary and workforce. We primarily focus on this connection as it spans the K-12 and post-secondary sectors. As such, we must track graduates of teacher preparation programs when they are students in post-secondary institutions to when they enter K-12 systems as teachers.', CedsConnectionName = 'What does placement, retention and evaluation in K-12 look like by four-year undergraduate teacher preparation programs?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 611
		END
 
		-----------------------------------------
		-- Do students taking high school science, technology, engineering and math (STEM) courses go on to postsecondary in STEM areas?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  612)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The goal of this connection is to understand STEM course-taking in high school relates to high school graduation, postsecondary enrollment and ultimately, postsecondary major in a STEM field.','Do students taking high school science, technology, engineering and math (STEM) courses go on to postsecondary in STEM areas?','SLDS Community',612)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The goal of this connection is to understand STEM course-taking in high school relates to high school graduation, postsecondary enrollment and ultimately, postsecondary major in a STEM field.', CedsConnectionName = 'Do students taking high school science, technology, engineering and math (STEM) courses go on to postsecondary in STEM areas?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 612
		END
 
		-----------------------------------------
		-- Are students who graduate with test scores that deem them college and career ready less likely to take remedial courses in college?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  613)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The goal of this connection is to understand how well college and career readiness standards translate when students go on to a postsecondary education. In particular, we focus on whether these students are less likely to take remedial courses than students who do not take an assessment in high school that deems them college and career ready.','Are students who graduate with test scores that deem them college and career ready less likely to take remedial courses in college?','SLDS Community',613)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The goal of this connection is to understand how well college and career readiness standards translate when students go on to a postsecondary education. In particular, we focus on whether these students are less likely to take remedial courses than students who do not take an assessment in high school that deems them college and career ready.', CedsConnectionName = 'Are students who graduate with test scores that deem them college and career ready less likely to take remedial courses in college?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 613
		END
 
		-----------------------------------------
		-- How many students complete the FAFSA by high school characteristics?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  614)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The goal of this connection is to understand differences in financial aid application completion by high school characteristics. Underlying this question is a question in part about higher education access. Since financing is often a barrier for students entering higher education, completion of the FAFSA would signify one barrier to higher education access that has removed.','How many students complete the FAFSA by high school characteristics?','SLDS Community',614)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The goal of this connection is to understand differences in financial aid application completion by high school characteristics. Underlying this question is a question in part about higher education access. Since financing is often a barrier for students entering higher education, completion of the FAFSA would signify one barrier to higher education access that has removed.', CedsConnectionName = 'How many students complete the FAFSA by high school characteristics?', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 614
		END
 
		-----------------------------------------
		-- What are the definable characteristics of Maine''s B-5 programs?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  617)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Early childhood data systems','What are the definable characteristics of Maine''s B-5 programs?','SLDS',617)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Early childhood data systems', CedsConnectionName = 'What are the definable characteristics of Maine''s B-5 programs?', CedsConnectionSource = 'SLDS'
			where CedsUseCaseId = 617
		END
 
		-----------------------------------------
		-- EDFacts File Spec C002 - Test
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  645)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 6 through 21.','EDFacts File Spec C002 - Test','CIID Training',645)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 6 through 21.', CedsConnectionName = 'EDFacts File Spec C002 - Test', CedsConnectionSource = 'CIID Training'
			where CedsUseCaseId = 645
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification N029 - Directory
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  648)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Directory records are used to       •	Report program data;  •	Publish the official Directory of all schools and districts;  •	Serve as sampling frame for statistical studies (i.e., NAEP, SASS);  •	Define the universe for the Civil Rights Data Collection (CRDC);  •	Populate the list of schools used on the Free Application for Federal Student Aid (FAFSA)      This document contains technical instructions for building fixed and delimited files used to submit the Directory for each education level.','SY 2014-15 EDFacts File Specification N029 - Directory','EDFacts File Specification v 11.2',648)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Directory records are used to       •	Report program data;  •	Publish the official Directory of all schools and districts;  •	Serve as sampling frame for statistical studies (i.e., NAEP, SASS);  •	Define the universe for the Civil Rights Data Collection (CRDC);  •	Populate the list of schools used on the Free Application for Federal Student Aid (FAFSA)      This document contains technical instructions for building fixed and delimited files used to submit the Directory for each education level.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification N029 - Directory', CedsConnectionSource = 'EDFacts File Specification v 11.2'
			where CedsUseCaseId = 648
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C039 Grades Offered
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  649)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The grade level(s) offered by the school or district.','SY 2014-15 EDFacts File Specification C039 Grades Offered','EDFacts File Specification C039  Version 11.0',649)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The grade level(s) offered by the school or district.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C039 Grades Offered', CedsConnectionSource = 'EDFacts File Specification C039  Version 11.0'
			where CedsUseCaseId = 649
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts Specification C129 CCD Schools
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  650)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This connection includes the the following Data Groups: 573 - Shared Time Status, 22 - Title I School Status, 24 - Magnet Status, in addition to a listing of the other data groups necessary for submitting this file','SY 2014-15 EDFacts Specification C129 CCD Schools','EDFacts File Specification C129, version 11.0',650)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This connection includes the the following Data Groups: 573 - Shared Time Status, 22 - Title I School Status, 24 - Magnet Status, in addition to a listing of the other data groups necessary for submitting this file', CedsConnectionName = 'SY 2014-15 EDFacts Specification C129 CCD Schools', CedsConnectionSource = 'EDFacts File Specification C129, version 11.0'
			where CedsUseCaseId = 650
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts Specification C033 Free and Reduced Price Lunch
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  651)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who are eligible to participate in the Free Lunch and Reduced-Price Lunch Programs under the National School Lunch Act of 1946.','SY 2014-15 EDFacts Specification C033 Free and Reduced Price Lunch','EDFacts File Specification C033 Version 11.0',651)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who are eligible to participate in the Free Lunch and Reduced-Price Lunch Programs under the National School Lunch Act of 1946.', CedsConnectionName = 'SY 2014-15 EDFacts Specification C033 Free and Reduced Price Lunch', CedsConnectionSource = 'EDFacts File Specification C033 Version 11.0'
			where CedsUseCaseId = 651
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C130 ESEA Status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  652)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This file includes the following data groups: DG 34 ( Improvement status- School), DG 36 (Persistently Dangerous Status), DG 662 ( Improvement Status - LEA), DG 741 ( Persistently Lowest-Achieving School), DG 778 (Reward Schools), DG 779 ( State Defined School Status)','SY 2014-15 EDFacts File Specification C130 ESEA Status','EDFacts File Specification C130 version 11.0',652)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This file includes the following data groups: DG 34 ( Improvement status- School), DG 36 (Persistently Dangerous Status), DG 662 ( Improvement Status - LEA), DG 741 ( Persistently Lowest-Achieving School), DG 778 (Reward Schools), DG 779 ( State Defined School Status)', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C130 ESEA Status', CedsConnectionSource = 'EDFacts File Specification C130 version 11.0'
			where CedsUseCaseId = 652
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C178 Academic Achievement in Reading(LA)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  657)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.  This connection also includes a listing of the other Data Groups necessary for submitting file C178 - Academic Achievement in reading - language arts table.','SY 2014-15 EDFacts File Specification C178 Academic Achievement in Reading(LA)','EDFacts File Specification 11.0',657)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.  This connection also includes a listing of the other Data Groups necessary for submitting file C178 - Academic Achievement in reading - language arts table.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C178 Academic Achievement in Reading(LA)', CedsConnectionSource = 'EDFacts File Specification 11.0'
			where CedsUseCaseId = 657
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C150 Regulatory Adjusted Cohort Graduation Rate
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  658)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students who graduate in four years or less with a regular high school diploma divided by the number of students who formed the cohort.  This connection also includes a listing of other Data Groups necessary for submitting file C150- Regulaory Adjusted-Cohort Graduation Rate.','SY 2014-15 EDFacts File Specification C150 Regulatory Adjusted Cohort Graduation Rate','EDFacts File Specification 11.0',658)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students who graduate in four years or less with a regular high school diploma divided by the number of students who formed the cohort.  This connection also includes a listing of other Data Groups necessary for submitting file C150- Regulaory Adjusted-Cohort Graduation Rate.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C150 Regulatory Adjusted Cohort Graduation Rate', CedsConnectionSource = 'EDFacts File Specification 11.0'
			where CedsUseCaseId = 658
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C151 Cohorts for the Regulatory Adjusted-Cohort Graduation Rate
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  659)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students in the adjusted cohort for the regulatory four-year adjusted-cohort graduation rate.  This connection also includes a listing of other Data Groups necessary for submitting file C151- Cohorts for Regulatory Adjusted-Cohort Graduation Rate.','SY 2014-15 EDFacts File Specification C151 Cohorts for the Regulatory Adjusted-Cohort Graduation Rate','EDFacts File Specification C151 Version 11.0',659)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students in the adjusted cohort for the regulatory four-year adjusted-cohort graduation rate.  This connection also includes a listing of other Data Groups necessary for submitting file C151- Cohorts for Regulatory Adjusted-Cohort Graduation Rate.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C151 Cohorts for the Regulatory Adjusted-Cohort Graduation Rate', CedsConnectionSource = 'EDFacts File Specification C151 Version 11.0'
			where CedsUseCaseId = 659
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C052 Membership
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  660)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The official unduplicated October 1st student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.','SY 2014-15 EDFacts File Specification C052 Membership','EDFacts Specification C052 Version 11.0',660)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The official unduplicated October 1st student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C052 Membership', CedsConnectionSource = 'EDFacts Specification C052 Version 11.0'
			where CedsUseCaseId = 660
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C175 Academic Achievement in Mathematics
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  661)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in mathematics for whom a proficiency level was assigned.  This connection also includes a listing of the other Data Groups necessary for submitting file C175 - Academic Achievement in Mathematics.','SY 2014-15 EDFacts File Specification C175 Academic Achievement in Mathematics','EDFacts File Specification C175 Version 11.0',661)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in mathematics for whom a proficiency level was assigned.  This connection also includes a listing of the other Data Groups necessary for submitting file C175 - Academic Achievement in Mathematics.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C175 Academic Achievement in Mathematics', CedsConnectionSource = 'EDFacts File Specification C175 Version 11.0'
			where CedsUseCaseId = 661
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C179 Academic Achievement in Science
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  662)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in science for whom a proficiency level was assigned.  This connection also includes a listing of the other Data Groups necessary for submitting file C179 - Academic Achievement in Science.','SY 2014-15 EDFacts File Specification C179 Academic Achievement in Science','EDFacts File Specificatoin C179 Version 11.0',662)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in science for whom a proficiency level was assigned.  This connection also includes a listing of the other Data Groups necessary for submitting file C179 - Academic Achievement in Science.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C179 Academic Achievement in Science', CedsConnectionSource = 'EDFacts File Specificatoin C179 Version 11.0'
			where CedsUseCaseId = 662
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C185 Assessment Participation in Mathematics
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  663)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students enrolled during the period of the state assessment in mathematics.  This connection also includes a listing of the other Data Groups necessary for submitting file C185 - Academic Participation in Mathmatics.','SY 2014-15 EDFacts File Specification C185 Assessment Participation in Mathematics','EDFacts File Specification C185 Version 11.0',663)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students enrolled during the period of the state assessment in mathematics.  This connection also includes a listing of the other Data Groups necessary for submitting file C185 - Academic Participation in Mathmatics.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C185 Assessment Participation in Mathematics', CedsConnectionSource = 'EDFacts File Specification C185 Version 11.0'
			where CedsUseCaseId = 663
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C188 Assessment Participation in Reading (LA)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  664)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.  This connection also includes a listing of the other Data Groups necessary for submitting file C188 - Academic Participation in reading/language arts.','SY 2014-15 EDFacts File Specification C188 Assessment Participation in Reading (LA)','EDFacts File Specification C188 Version 11.0',664)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.  This connection also includes a listing of the other Data Groups necessary for submitting file C188 - Academic Participation in reading/language arts.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C188 Assessment Participation in Reading (LA)', CedsConnectionSource = 'EDFacts File Specification C188 Version 11.0'
			where CedsUseCaseId = 664
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C189 Assessment Participation in Science
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  665)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in science.  This connection also includes a listing of the other Data Groups necessary for submitting file C189 - Academic Participation in Science.','SY 2014-15 EDFacts File Specification C189 Assessment Participation in Science','EDFacts File Specificatoin C188 Version 11.0',665)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in science.  This connection also includes a listing of the other Data Groups necessary for submitting file C189 - Academic Participation in Science.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C189 Assessment Participation in Science', CedsConnectionSource = 'EDFacts File Specificatoin C188 Version 11.0'
			where CedsUseCaseId = 665
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C170 LEA Subgrant Status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  666)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the LEA received a McKinney-Vento subgrant.','SY 2014-15 EDFacts File Specification C170 LEA Subgrant Status','EDFacts File Specification C170 Version 11.0',666)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the LEA received a McKinney-Vento subgrant.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C170 LEA Subgrant Status', CedsConnectionSource = 'EDFacts File Specification C170 Version 11.0'
			where CedsUseCaseId = 666
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C171 Academic Achievement - Flexibility Subgroups
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  667)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment for whom a proficiency level was assigned for mathematics, reading and language arts, and science.  The data collected using EDFacts fileC171 are required to provide transparency around SEA implementation of new reforms and accountability measures under ESEA Flexibility requests.','SY 2014-15 EDFacts File Specification C171 Academic Achievement - Flexibility Subgroups','EDFacts File Specification C171 Version 11.0',667)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment for whom a proficiency level was assigned for mathematics, reading and language arts, and science.  The data collected using EDFacts fileC171 are required to provide transparency around SEA implementation of new reforms and accountability measures under ESEA Flexibility requests.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C171 Academic Achievement - Flexibility Subgroups', CedsConnectionSource = 'EDFacts File Specification C171 Version 11.0'
			where CedsUseCaseId = 667
		END
 
		-----------------------------------------
		-- SY 2014-15  EDFacts File Specification C172 Assessment Participation – Flexibility Subgroups
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  668)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students  enrolled during the period of the state assessment in mathematics, reading and language arts, and science.   The data collected using this file specification are required to provide transparency around SEA implementation of new reforms and accountability measures under ESEA Flexibility requests. This file needs to be submitted only by states with approved ESEA Flexibility requests that include the use of combined subgroups.','SY 2014-15  EDFacts File Specification C172 Assessment Participation – Flexibility Subgroups','EDFacts File Specification C172 Version 11.0',668)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students  enrolled during the period of the state assessment in mathematics, reading and language arts, and science.   The data collected using this file specification are required to provide transparency around SEA implementation of new reforms and accountability measures under ESEA Flexibility requests. This file needs to be submitted only by states with approved ESEA Flexibility requests that include the use of combined subgroups.', CedsConnectionName = 'SY 2014-15  EDFacts File Specification C172 Assessment Participation – Flexibility Subgroups', CedsConnectionSource = 'EDFacts File Specification C172 Version 11.0'
			where CedsUseCaseId = 668
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C173 Flexibility Subgroups
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  669)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or district met the 95 percent participation requirement on the mathematics and reading/language arts assessments , the mathematics and reading/language arts proficiency targets and the High School Graduation Rate requirements in accordance with state definition.    This file needs to be submitted only by states with approved ESEA Flexibility requests that include the use of combined subgroups','SY 2014-15 EDFacts File Specification C173 Flexibility Subgroups','EDFacts File Specification C173 Version 11.0',669)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or district met the 95 percent participation requirement on the mathematics and reading/language arts assessments , the mathematics and reading/language arts proficiency targets and the High School Graduation Rate requirements in accordance with state definition.    This file needs to be submitted only by states with approved ESEA Flexibility requests that include the use of combined subgroups', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C173 Flexibility Subgroups', CedsConnectionSource = 'EDFacts File Specification C173 Version 11.0'
			where CedsUseCaseId = 669
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C190 Charter Authorizer Directory
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  670)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Directory information for authorized public chartering agencies including full legally accepted name, identifier, address information and type of charter authorizer organization, as classified by its primary focus.','SY 2014-15 EDFacts File Specification C190 Charter Authorizer Directory','EDFacts File Specificatoin C190 Version 11.2',670)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Directory information for authorized public chartering agencies including full legally accepted name, identifier, address information and type of charter authorizer organization, as classified by its primary focus.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C190 Charter Authorizer Directory', CedsConnectionSource = 'EDFacts File Specificatoin C190 Version 11.2'
			where CedsUseCaseId = 670
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C176 State Interventions - Flexibility
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  671)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of the intervention(s) used in a school designated as a priority  or focus school in a state with an approved flexibility request.    The data collected using this file specification are used to monitor and report performance on programs and activities supported by the Elementary and Secondary Education Act, as amended','SY 2014-15 EDFacts File Specification C176 State Interventions - Flexibility','EDFacts File Specification C176 Version 11.1',671)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of the intervention(s) used in a school designated as a priority  or focus school in a state with an approved flexibility request.    The data collected using this file specification are used to monitor and report performance on programs and activities supported by the Elementary and Secondary Education Act, as amended', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C176 State Interventions - Flexibility', CedsConnectionSource = 'EDFacts File Specification C176 Version 11.1'
			where CedsUseCaseId = 671
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C193 - Title I Allocations
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  672)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The dollar amount of Title I, Part A  allocation reserved by the LEA for parental involvement activities and the dollar amount of funds awarded to an LEA by its SEA in accordance with the ESEA’s regulations that govern the process an SEA uses to adjust the ED-determined Title I, Part A allocations.','SY 2014-15 EDFacts File Specification C193 - Title I Allocations','EDFacts File Specification C193- Version 11.2',672)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The dollar amount of Title I, Part A  allocation reserved by the LEA for parental involvement activities and the dollar amount of funds awarded to an LEA by its SEA in accordance with the ESEA’s regulations that govern the process an SEA uses to adjust the ED-determined Title I, Part A allocations.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C193 - Title I Allocations', CedsConnectionSource = 'EDFacts File Specification C193- Version 11.2'
			where CedsUseCaseId = 672
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C183 Title I Allocations - Flexibility
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  673)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The dollar amount of Title I, Part A funds allocated to a priority or focus school by its LEA under section 1113 of the ESEA and the number of children from low-income families that was used by the school district for allocating Title I, Part A funds to priority and focus schools under section 1113.','SY 2014-15 EDFacts File Specification C183 Title I Allocations - Flexibility','EDFacts File Specification C183 Version 11.0',673)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The dollar amount of Title I, Part A funds allocated to a priority or focus school by its LEA under section 1113 of the ESEA and the number of children from low-income families that was used by the school district for allocating Title I, Part A funds to priority and focus schools under section 1113.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C183 Title I Allocations - Flexibility', CedsConnectionSource = 'EDFacts File Specification C183 Version 11.0'
			where CedsUseCaseId = 673
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C174 Graduation Rates - Flexibility Subgroups
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  674)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students who graduate in four years or less with a regular high school diploma divided by the number of students who form the adjusted-cohort for the regulatory four-year adjusted-cohort graduation rate. This file also includes the data groups necessary to submit EDFacts File C174 - Graduation Rates - Flexibility Subgroups','SY 2014-15 EDFacts File Specification C174 Graduation Rates - Flexibility Subgroups','EDFacts File Specification C174 Version 11.0',674)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students who graduate in four years or less with a regular high school diploma divided by the number of students who form the adjusted-cohort for the regulatory four-year adjusted-cohort graduation rate. This file also includes the data groups necessary to submit EDFacts File C174 - Graduation Rates - Flexibility Subgroups', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C174 Graduation Rates - Flexibility Subgroups', CedsConnectionSource = 'EDFacts File Specification C174 Version 11.0'
			where CedsUseCaseId = 674
		END
 
		-----------------------------------------
		-- SY 2014-15 ED Facts File Specification C177  Cohorts for Graduation Rates - Flexibility Subgroup
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  679)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students in the adjusted cohort for the regulatory four-year adjusted-cohort graduation rate.  This connection also includes a listing of other Data Groups necessary for submitting file C177  Cohorts for Graduation Rates - Flexibility Subgroup.    This file needs to be submitted only by states with approved ESEA Flexibility requests that include the use of combined subgroups.','SY 2014-15 ED Facts File Specification C177  Cohorts for Graduation Rates - Flexibility Subgroup','EDFacts file Specificatoin C177 Version 11.0',679)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students in the adjusted cohort for the regulatory four-year adjusted-cohort graduation rate.  This connection also includes a listing of other Data Groups necessary for submitting file C177  Cohorts for Graduation Rates - Flexibility Subgroup.    This file needs to be submitted only by states with approved ESEA Flexibility requests that include the use of combined subgroups.', CedsConnectionName = 'SY 2014-15 ED Facts File Specification C177  Cohorts for Graduation Rates - Flexibility Subgroup', CedsConnectionSource = 'EDFacts file Specificatoin C177 Version 11.0'
			where CedsUseCaseId = 679
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C103 Accountability
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  680)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of Adequate Yearly Progress (AYP) Status , Alternate Approach Status, Annual Measurable Achievement Objective (AMAO) I ELP Making Progress, Annual Measurable Achievement Objective (AMAO) II ELP Attainment, Annual Measurable Achievement Objective (AMAO) III AYP for LEP, and the State Poverty Designation','SY 2014-15 EDFacts File Specification C103 Accountability','EDFacts File Specification C103 Version 11.1',680)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of Adequate Yearly Progress (AYP) Status , Alternate Approach Status, Annual Measurable Achievement Objective (AMAO) I ELP Making Progress, Annual Measurable Achievement Objective (AMAO) II ELP Attainment, Annual Measurable Achievement Objective (AMAO) III AYP for LEP, and the State Poverty Designation', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C103 Accountability', CedsConnectionSource = 'EDFacts File Specification C103 Version 11.1'
			where CedsUseCaseId = 680
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C106 Elementary/Middle Additional Indicator
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  681)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or district met the Elementary/Middle Additional Indicator requirement in accordance with state definition.','SY 2014-15 EDFacts File Specification C106 Elementary/Middle Additional Indicator','EDFacts File Specification C106 Version 11.0',681)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or district met the Elementary/Middle Additional Indicator requirement in accordance with state definition.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C106 Elementary/Middle Additional Indicator', CedsConnectionSource = 'EDFacts File Specification C106 Version 11.0'
			where CedsUseCaseId = 681
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C107 High School Graduation Rate Indicator
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  682)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or district met the High School Graduation Rate requirement in accordance with state definition.','SY 2014-15 EDFacts File Specification C107 High School Graduation Rate Indicator','EDFacts File Specification C107 Version 11.0',682)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or district met the High School Graduation Rate requirement in accordance with state definition.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C107 High School Graduation Rate Indicator', CedsConnectionSource = 'EDFacts File Specification C107 Version 11.0'
			where CedsUseCaseId = 682
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C108 Mathematics Participation Status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  683)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or district met the 95 percent participation requirement in the mathematics assessment in accordance with state definition.','SY 2014-15 EDFacts File Specification C108 Mathematics Participation Status','EDFacts File Specification C108 Version 11.0',683)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or district met the 95 percent participation requirement in the mathematics assessment in accordance with state definition.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C108 Mathematics Participation Status', CedsConnectionSource = 'EDFacts File Specification C108 Version 11.0'
			where CedsUseCaseId = 683
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C109 AMO Mathematics Status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  684)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or district met the math proficiency target in accordance with state definition.','SY 2014-15 EDFacts File Specification C109 AMO Mathematics Status','EDFacts File Specification C109 Version 11.0',684)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or district met the math proficiency target in accordance with state definition.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C109 AMO Mathematics Status', CedsConnectionSource = 'EDFacts File Specification C109 Version 11.0'
			where CedsUseCaseId = 684
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C110  Reading/Language Arts Participation Status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  685)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or district met the 95 percent participation requirement on the reading/language arts assessment in accordance with state definition.','SY 2014-15 EDFacts File Specification C110  Reading/Language Arts Participation Status','EDfacts File Specification C110 Version 11.0',685)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or district met the 95 percent participation requirement on the reading/language arts assessment in accordance with state definition.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C110  Reading/Language Arts Participation Status', CedsConnectionSource = 'EDfacts File Specification C110 Version 11.0'
			where CedsUseCaseId = 685
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C111 AMO Reading/Language Arts Status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  686)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or district met the reading/language arts proficiency target in accordance with state definition.','SY 2014-15 EDFacts File Specification C111 AMO Reading/Language Arts Status','EDFacts File Specification C111 Version 11.0',686)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or district met the reading/language arts proficiency target in accordance with state definition.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C111 AMO Reading/Language Arts Status', CedsConnectionSource = 'EDFacts File Specification C111 Version 11.0'
			where CedsUseCaseId = 686
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C082 CTE Concentrators Exiting
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  687)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of career and technical education (CTE) concentrators who left secondary education.','SY 2014-15 EDFacts File Specification C082 CTE Concentrators Exiting','EDFacts File Specification C082 Version 11.1',687)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of career and technical education (CTE) concentrators who left secondary education.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C082 CTE Concentrators Exiting', CedsConnectionSource = 'EDFacts File Specification C082 Version 11.1'
			where CedsUseCaseId = 687
		END
 
		-----------------------------------------
		-- SY 2013-14 EDFacts File Specification C083 CTE Concentrator Graduates
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  688)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of career and technical education (CTE) concentrators who left secondary education and who received a high school diploma or its recognized equivalent.','SY 2013-14 EDFacts File Specification C083 CTE Concentrator Graduates','EDFacts File Specification C083 Version 11.1',688)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of career and technical education (CTE) concentrators who left secondary education and who received a high school diploma or its recognized equivalent.', CedsConnectionName = 'SY 2013-14 EDFacts File Specification C083 CTE Concentrator Graduates', CedsConnectionSource = 'EDFacts File Specification C083 Version 11.1'
			where CedsUseCaseId = 688
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C142 CTE Concentrators Academic Attainment
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  690)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of career and technical education (CTE) concentrators who left secondary education during the school year for whom a proficiency score on the state assessment was included in the state’s calculation of adequate yearly progress (AYP).','SY 2014-15 EDFacts File Specification C142 CTE Concentrators Academic Attainment','EDFacts File Specification C142 Version 11.1',690)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of career and technical education (CTE) concentrators who left secondary education during the school year for whom a proficiency score on the state assessment was included in the state’s calculation of adequate yearly progress (AYP).', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C142 CTE Concentrators Academic Attainment', CedsConnectionSource = 'EDFacts File Specification C142 Version 11.1'
			where CedsUseCaseId = 690
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C046 LEP Students in LEP Program
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  692)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of limited English proficient (LEP) students enrolled in English language instruction educational programs designed for LEP students.','SY 2014-15 EDFacts File Specification C046 LEP Students in LEP Program','EDFacts File Specification v 11.0',692)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of limited English proficient (LEP) students enrolled in English language instruction educational programs designed for LEP students.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C046 LEP Students in LEP Program', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 692
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C154 CTE Concentrators in Graduation Rate
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  693)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who were included in the state’s computation of its graduation rate as described in section 1111 (b)(2)(C)(vi) of the ESEA.','SY 2014-15 EDFacts File Specification C154 CTE Concentrators in Graduation Rate','EDFacts File Specification C154  version 11.1',693)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who were included in the state’s computation of its graduation rate as described in section 1111 (b)(2)(C)(vi) of the ESEA.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C154 CTE Concentrators in Graduation Rate', CedsConnectionSource = 'EDFacts File Specification C154  version 11.1'
			where CedsUseCaseId = 693
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C155 CTE Participants in Programs for Non-traditional
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  694)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE participants who participated in a program that leads to employment in non-traditional fields.','SY 2014-15 EDFacts File Specification C155 CTE Participants in Programs for Non-traditional','EDFacts File Specification C155 Version 11.1',694)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE participants who participated in a program that leads to employment in non-traditional fields.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C155 CTE Participants in Programs for Non-traditional', CedsConnectionSource = 'EDFacts File Specification C155 Version 11.1'
			where CedsUseCaseId = 694
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C032 Dropouts
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  695)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of dropouts. See Analysis Recommendations section for a description of "dropouts."','SY 2014-15 EDFacts File Specification C032 Dropouts','EDFacts File Specification v 11.0',695)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of dropouts. See Analysis Recommendations section for a description of "dropouts."', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C032 Dropouts', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 695
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C059 Staff FTE
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  696)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) staff and the number of full time equivalent (FTE) classroom teachers in the school.','SY 2014-15 EDFacts File Specification C059 Staff FTE','EDFacts File Specification v 11.0',696)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) staff and the number of full time equivalent (FTE) classroom teachers in the school.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C059 Staff FTE', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 696
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C043 Homeless Served (McKinney-Vento)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  697)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of homeless children/youth enrolled in public schools who receive services under program subgrants funded by the McKinney-Vento Homeless Education Assistance Improvements Act of 2001.','SY 2014-15 EDFacts File Specification C043 Homeless Served (McKinney-Vento)','EDFacts File Specification v 11.0',697)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of homeless children/youth enrolled in public schools who receive services under program subgrants funded by the McKinney-Vento Homeless Education Assistance Improvements Act of 2001.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C043 Homeless Served (McKinney-Vento)', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 697
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C045 Immigrant
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  698)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who meet the definition of immigrant children and youth in Title III of ESEA as amended, Section 3301(6) and are enrolled in elementary and secondary schools.','SY 2014-15 EDFacts File Specification C045 Immigrant','EDFacts File Specification v 11.0',698)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who meet the definition of immigrant children and youth in Title III of ESEA as amended, Section 3301(6) and are enrolled in elementary and secondary schools.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C045 Immigrant', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 698
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C050 Title III LEP English Language Proficiency Results
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  699)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of limited English proficient (LEP) students who were assessed in the annual state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA funds.','SY 2014-15 EDFacts File Specification C050 Title III LEP English Language Proficiency Results','EDFacts File Specification v 11.0',699)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of limited English proficient (LEP) students who were assessed in the annual state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA funds.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C050 Title III LEP English Language Proficiency Results', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 699
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C063 Teacher Quality in Elementary Classes
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  700)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of elementary classes in core academic subjects.','SY 2014-15 EDFacts File Specification C063 Teacher Quality in Elementary Classes','EDFacts File Specification v 11.0',700)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of elementary classes in core academic subjects.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C063 Teacher Quality in Elementary Classes', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 700
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C156 CTE Concentrators in Programs for Non-traditional
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  701)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who completed a program that leads to employment in non-traditional fields.','SY 2014-15 EDFacts File Specification C156 CTE Concentrators in Programs for Non-traditional','EDFacts File Specification C156 Version 11.1',701)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who completed a program that leads to employment in non-traditional fields.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C156 CTE Concentrators in Programs for Non-traditional', CedsConnectionSource = 'EDFacts File Specification C156 Version 11.1'
			where CedsUseCaseId = 701
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C064 Teacher Quality in Core Secondary Classes
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  702)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of secondary classes in core academic subjects.','SY 2014-15 EDFacts File Specification C064 Teacher Quality in Core Secondary Classes','EDFacts File Specification  11.0',702)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of secondary classes in core academic subjects.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C064 Teacher Quality in Core Secondary Classes', CedsConnectionSource = 'EDFacts File Specification  11.0'
			where CedsUseCaseId = 702
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C157 CTE Concentrators Technical Skills
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  703)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who took technical skill assessments that are aligned with industry-recognized standards.','SY 2014-15 EDFacts File Specification C157 CTE Concentrators Technical Skills','EDFacts File Specification C157 V11.1',703)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who took technical skill assessments that are aligned with industry-recognized standards.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C157 CTE Concentrators Technical Skills', CedsConnectionSource = 'EDFacts File Specification C157 V11.1'
			where CedsUseCaseId = 703
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C158 CTE Concentrators Placement
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  704)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of career and technical education (CTE) concentrators who left secondary education in the cohort which graduated the prior program year.','SY 2014-15 EDFacts File Specification C158 CTE Concentrators Placement','EDFacts File Specification C158 Version 11.1',704)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of career and technical education (CTE) concentrators who left secondary education in the cohort which graduated the prior program year.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C158 CTE Concentrators Placement', CedsConnectionSource = 'EDFacts File Specification C158 Version 11.1'
			where CedsUseCaseId = 704
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specifications C169 CTE Type of Placement
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  705)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of career and technical education (CTE) concentrators who left secondary education in the cohort which graduated the prior program year and were placed..','SY 2014-15 EDFacts File Specifications C169 CTE Type of Placement','EDFacts File Specification C169 Version 11.1',705)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of career and technical education (CTE) concentrators who left secondary education in the cohort which graduated the prior program year and were placed..', CedsConnectionName = 'SY 2014-15 EDFacts File Specifications C169 CTE Type of Placement', CedsConnectionSource = 'EDFacts File Specification C169 Version 11.1'
			where CedsUseCaseId = 705
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C113 Neglected or Delinquent Academic Achievement - State Agency
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  706)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students served by Title I, Part D, Subpart 1 of ESEA as amended for at least 90 consecutive days during the reporting period who took both a pre- and post-test.','SY 2014-15 EDFacts File Specification C113 Neglected or Delinquent Academic Achievement - State Agency','EDFacts File Specification C113 Version 11.0',706)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students served by Title I, Part D, Subpart 1 of ESEA as amended for at least 90 consecutive days during the reporting period who took both a pre- and post-test.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C113 Neglected or Delinquent Academic Achievement - State Agency', CedsConnectionSource = 'EDFacts File Specification C113 Version 11.0'
			where CedsUseCaseId = 706
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C119 N or D Participation — State Agency
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  707)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (state agencies) of ESEA as amended by NCLB.','SY 2014-15 EDFacts File Specification C119 N or D Participation — State Agency','EDFacts File Specification C119 Version 11.0',707)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (state agencies) of ESEA as amended by NCLB.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C119 N or D Participation — State Agency', CedsConnectionSource = 'EDFacts File Specification C119 Version 11.0'
			where CedsUseCaseId = 707
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specifications C125 N or D Academic Achievement — LEA
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  708)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students served by Title I, Part D, Subpart 2 of ESEA as amended for at least 90 consecutive days during the reporting period who took both a pre- and post-test.','SY 2014-15 EDFacts File Specifications C125 N or D Academic Achievement — LEA','EDFacts File Specification C125 Version 11.0',708)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students served by Title I, Part D, Subpart 2 of ESEA as amended for at least 90 consecutive days during the reporting period who took both a pre- and post-test.', CedsConnectionName = 'SY 2014-15 EDFacts File Specifications C125 N or D Academic Achievement — LEA', CedsConnectionSource = 'EDFacts File Specification C125 Version 11.0'
			where CedsUseCaseId = 708
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C127 N or D Participation—LEA
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  709)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected, delinquent, or at-risk students (N or D) under Title I, Part D, Subpart 2 (LEA) of ESEA as amended.','SY 2014-15 EDFacts File Specification C127 N or D Participation—LEA','EDFacts File Specification C127 Version 11.0',709)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected, delinquent, or at-risk students (N or D) under Title I, Part D, Subpart 2 (LEA) of ESEA as amended.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C127 N or D Participation—LEA', CedsConnectionSource = 'EDFacts File Specification C127 Version 11.0'
			where CedsUseCaseId = 709
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C067 Title III Teacher
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  710)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated headcount of teachers who taught in language instruction educational programs designed for limited English proficient (LEP) students supported with Title III of ESEA funds.','SY 2014-15 EDFacts File Specification C067 Title III Teacher','EDFacts File Specification v 11.0',710)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated headcount of teachers who taught in language instruction educational programs designed for limited English proficient (LEP) students supported with Title III of ESEA funds.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C067 Title III Teacher', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 710
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C116 Title III LEP Students Served
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  711)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of limited English proficient (LEP) students served by an English language instruction educational program (LIEP) supported with Title III of ESEA funds.','SY 2014-15 EDFacts File Specification C116 Title III LEP Students Served','EDFacts File Specification v 11.0',711)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of limited English proficient (LEP) students served by an English language instruction educational program (LIEP) supported with Title III of ESEA funds.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C116 Title III LEP Students Served', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 711
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C118 Homeless Students Enrolled
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  712)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of homeless students enrolled in public schools at any time during the school year.','SY 2014-15 EDFacts File Specification C118 Homeless Students Enrolled','EDFacts File Specification v 11.0',712)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of homeless students enrolled in public schools at any time during the school year.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C118 Homeless Students Enrolled', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 712
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C126 Former LEP Students
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  713)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of monitored former LEP students who are no longer receiving services and are being monitored for two consecutive years on content achievement under Title III of ESEA as amended.','SY 2014-15 EDFacts File Specification C126 Former LEP Students','EDFacts File Specification C126',713)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of monitored former LEP students who are no longer receiving services and are being monitored for two consecutive years on content achievement under Title III of ESEA as amended.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C126 Former LEP Students', CedsConnectionSource = 'EDFacts File Specification C126'
			where CedsUseCaseId = 713
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C164 PSC/SES Data
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  714)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This file contains data related to supplemental educational services, public school choice, and other topics. See the "Author''s Comments" section below for definitions of each data group included in this file.','SY 2014-15 EDFacts File Specification C164 PSC/SES Data','EDFacts File Specification C164',714)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This file contains data related to supplemental educational services, public school choice, and other topics. See the "Author''s Comments" section below for definitions of each data group included in this file.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C164 PSC/SES Data', CedsConnectionSource = 'EDFacts File Specification C164'
			where CedsUseCaseId = 714
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C010 Public School Choice
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  716)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This file contains three data groups related to public school choice. See the "Author''s Comments" section below for definitions of the data groups contained in this file.','SY 2014-15 EDFacts File Specification C010 Public School Choice','EDFacts File Specification v 11.0',716)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This file contains three data groups related to public school choice. See the "Author''s Comments" section below for definitions of the data groups contained in this file.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C010 Public School Choice', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 716
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C180  N or D In Program Outcomes
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  717)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency) and Subpart 2 (LEA) of ESEA, as amended, who attained academic and vocational outcomes while enrolled in the programs.','SY 2014-15 EDFacts File Specification C180  N or D In Program Outcomes','EDFacts File Specification C180 Version 11.0',717)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency) and Subpart 2 (LEA) of ESEA, as amended, who attained academic and vocational outcomes while enrolled in the programs.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C180  N or D In Program Outcomes', CedsConnectionSource = 'EDFacts File Specification C180 Version 11.0'
			where CedsUseCaseId = 717
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C181 N or D Exited Program - Outcomes
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  718)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency) and Subpart 2 (LEA) of ESEA, as amended, who attained academic and vocational outcomes while enrolled in the programs.','SY 2014-15 EDFacts File Specification C181 N or D Exited Program - Outcomes','EDFacts File Specification C181 Version 11.0',718)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency) and Subpart 2 (LEA) of ESEA, as amended, who attained academic and vocational outcomes while enrolled in the programs.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C181 N or D Exited Program - Outcomes', CedsConnectionSource = 'EDFacts File Specification C181 Version 11.0'
			where CedsUseCaseId = 718
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C182 N or D Transition Services
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  719)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated count of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency)  or Titile I Part D, Subpart 2 (LEA) of ESEA, as amended, who received transition services.','SY 2014-15 EDFacts File Specification C182 N or D Transition Services','EDFacts File Specification C182 Version 11.0',719)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated count of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency)  or Titile I Part D, Subpart 2 (LEA) of ESEA, as amended, who received transition services.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C182 N or D Transition Services', CedsConnectionSource = 'EDFacts File Specification C182 Version 11.0'
			where CedsUseCaseId = 719
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C030 Discipline Incidents
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  720)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative number of times that students were removed from their regular education program for at least an entire school day for discipline.','SY 2014-15 EDFacts File Specification C030 Discipline Incidents','EDFacts File Specifiction C030 Version 11.0',720)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative number of times that students were removed from their regular education program for at least an entire school day for discipline.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C030 Discipline Incidents', CedsConnectionSource = 'EDFacts File Specifiction C030 Version 11.0'
			where CedsUseCaseId = 720
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C121 Migrant Students Eligible - 12 months
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  721)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of eligible migrant students.','SY 2014-15 EDFacts File Specification C121 Migrant Students Eligible - 12 months','EDFacts File Specificiation C121 Version 11.1',721)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of eligible migrant students.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C121 Migrant Students Eligible - 12 months', CedsConnectionSource = 'EDFacts File Specificiation C121 Version 11.1'
			where CedsUseCaseId = 721
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C165 Migrant Data
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  722)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of eligible migrant students enrolled in a public school during the regular school year and an indication of whether the school has a school-wide program, as defined by Title I of ESEA as amended, in which federal Migrant Education Program (MEP) funds are consolidated as authorized under 34 CFR Section 200.29','SY 2014-15 EDFacts File Specification C165 Migrant Data','EDFacts File Specificatoin C165 Version 11.0',722)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of eligible migrant students enrolled in a public school during the regular school year and an indication of whether the school has a school-wide program, as defined by Title I of ESEA as amended, in which federal Migrant Education Program (MEP) funds are consolidated as authorized under 34 CFR Section 200.29', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C165 Migrant Data', CedsConnectionSource = 'EDFacts File Specificatoin C165 Version 11.0'
			where CedsUseCaseId = 722
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C192 MEP Students Priority Services
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  723)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of participating migrant students who received instructional or support services in a Migrant Education Program (MEP) and were classified as having a priority for services.','SY 2014-15 EDFacts File Specification C192 MEP Students Priority Services','EDFacts File Specification C192 Version 11.0',723)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of participating migrant students who received instructional or support services in a Migrant Education Program (MEP) and were classified as having a priority for services.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C192 MEP Students Priority Services', CedsConnectionSource = 'EDFacts File Specification C192 Version 11.0'
			where CedsUseCaseId = 723
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C145 MEP Services
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  724)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of participating migrant children who receive services funded by MEP.','SY 2014-15 EDFacts File Specification C145 MEP Services','EDFacts File Specificatoin C145 Version 11.0',724)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of participating migrant children who receive services funded by MEP.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C145 MEP Services', CedsConnectionSource = 'EDFacts File Specificatoin C145 Version 11.0'
			where CedsUseCaseId = 724
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C134 Title I Part A Participation
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  725)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of students participating in and served by programs under Title I, Part A of ESEA as amended.','SY 2014-15 EDFacts File Specification C134 Title I Part A Participation','EDFacts File Specification C134 Version 11.0',725)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of students participating in and served by programs under Title I, Part A of ESEA as amended.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C134 Title I Part A Participation', CedsConnectionSource = 'EDFacts File Specification C134 Version 11.0'
			where CedsUseCaseId = 725
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C086 Students Involved with Firearms
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  726)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were involved in an incident involving a firearm.','SY 2014-15 EDFacts File Specification C086 Students Involved with Firearms','EDFacts File Specification C086 Version 11.0',726)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were involved in an incident involving a firearm.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C086 Students Involved with Firearms', CedsConnectionSource = 'EDFacts File Specification C086 Version 11.0'
			where CedsUseCaseId = 726
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C094 Firearm Incidents
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  727)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of incidents involving students who brought or possessed firearms at school.','SY 2014-15 EDFacts File Specification C094 Firearm Incidents','EDFacts File Specification C094 Version 11.0',727)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of incidents involving students who brought or possessed firearms at school.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C094 Firearm Incidents', CedsConnectionSource = 'EDFacts File Specification C094 Version 11.0'
			where CedsUseCaseId = 727
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C163 Discipline Data
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  728)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or local education agency (LEA) submitted a Gun-Free Schools Act (GFSA) of 1994 report to the state, as defined by Title 18, Section 921 and the unduplicated number of truants as defined by state, using threshold definition.','SY 2014-15 EDFacts File Specification C163 Discipline Data','EDFacts File Specification C163 Version 11.0',728)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or local education agency (LEA) submitted a Gun-Free Schools Act (GFSA) of 1994 report to the state, as defined by Title 18, Section 921 and the unduplicated number of truants as defined by state, using threshold definition.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C163 Discipline Data', CedsConnectionSource = 'EDFacts File Specification C163 Version 11.0'
			where CedsUseCaseId = 728
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C040 Graduates/Completers
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  729)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who graduated from high school or completed some other education program that is approved by the state or local education agency (SEA or LEA) during the school year and the subsequent summer school.','SY 2014-15 EDFacts File Specification C040 Graduates/Completers','EDFacts File Specification C040 Version 11.0',729)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who graduated from high school or completed some other education program that is approved by the state or local education agency (SEA or LEA) during the school year and the subsequent summer school.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C040 Graduates/Completers', CedsConnectionSource = 'EDFacts File Specification C040 Version 11.0'
			where CedsUseCaseId = 729
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C131 LEA End of the School Year Status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  730)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication that the local education agency (LEA) notified the state of the LEA''s intention to use REAP-Flex Alternative Uses of Funding Authority during the school year as specified in the Title VI, Section 6211 of ESEA as amended.','SY 2014-15 EDFacts File Specification C131 LEA End of the School Year Status','EDFacts File Specification C131 Version 11.0',730)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication that the local education agency (LEA) notified the state of the LEA''s intention to use REAP-Flex Alternative Uses of Funding Authority during the school year as specified in the Title VI, Section 6211 of ESEA as amended.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C131 LEA End of the School Year Status', CedsConnectionSource = 'EDFacts File Specification C131 Version 11.0'
			where CedsUseCaseId = 730
		END
 
		-----------------------------------------
		-- EDFacts File Specification C035 Federal Programs
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  731)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The amount of federal dollars distributed to local education agencies (LEAs), retained by the state education agency (SEA) for program administration or other approved state-level activities (including unallocated, transferred to another state agency, or distributed to entities other than LEAs).','EDFacts File Specification C035 Federal Programs','EDFacts File Specification C035 Version 8.0',731)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The amount of federal dollars distributed to local education agencies (LEAs), retained by the state education agency (SEA) for program administration or other approved state-level activities (including unallocated, transferred to another state agency, or distributed to entities other than LEAs).', CedsConnectionName = 'EDFacts File Specification C035 Federal Programs', CedsConnectionSource = 'EDFacts File Specification C035 Version 8.0'
			where CedsUseCaseId = 731
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C036 Title I Part A TAS Services
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  733)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in and served by targeted assistance (TAS) programs under Title I, Part A, Section 1115 of ESEA.','SY 2014-15 EDFacts File Specification C036 Title I Part A TAS Services','EDFacts File Specification v 11.0',733)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in and served by targeted assistance (TAS) programs under Title I, Part A, Section 1115 of ESEA.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C036 Title I Part A TAS Services', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 733
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C037 Title I Part A SWP/TAS Participation
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  734)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of students participating in and served by Title I of ESEA, Part A, Sections 1114 (Schoolwide Programs (SWP)) and 1115 (targeted assistance (TAS) programs).','SY 2014-15 EDFacts File Specification C037 Title I Part A SWP/TAS Participation','EDFacts File Specification v 11.0',734)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of students participating in and served by Title I of ESEA, Part A, Sections 1114 (Schoolwide Programs (SWP)) and 1115 (targeted assistance (TAS) programs).', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C037 Title I Part A SWP/TAS Participation', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 734
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C054 MEP Students Served – 12 Months
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  735)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The cumulative unduplicated number of participating migrant students who received instructional or support services in a Migrant Education Program (MEP).','SY 2014-15 EDFacts File Specification C054 MEP Students Served – 12 Months','EDFacts File Specification v 11.0',735)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The cumulative unduplicated number of participating migrant students who received instructional or support services in a Migrant Education Program (MEP).', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C054 MEP Students Served – 12 Months', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 735
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C065 Federally Funded Staff
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  736)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This file contains three data groups related to federally funded staff. Descriptions of these three data groups can be found in the "Author''s Comments" section below.','SY 2014-15 EDFacts File Specification C065 Federally Funded Staff','EDFacts File Specification v 11.0',736)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This file contains three data groups related to federally funded staff. Descriptions of these three data groups can be found in the "Author''s Comments" section below.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C065 Federally Funded Staff', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 736
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C128 Supplemental Education Services
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  737)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This file contains three data groups related to Supplemental Education Services. You can find definitions of the three data groups in the "Author''s Comments" section below.','SY 2014-15 EDFacts File Specification C128 Supplemental Education Services','EDFacts File Specification v 11.0',737)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This file contains three data groups related to Supplemental Education Services. You can find definitions of the three data groups in the "Author''s Comments" section below.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C128 Supplemental Education Services', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 737
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C132 School End of Year Status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  738)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This file contains five data groups related to a school''s end of year status. You can find definitions of these data groups in the "Author''s Comments" section below.','SY 2014-15 EDFacts File Specification C132 School End of Year Status','EDFacts File Specification v 11.0',738)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This file contains five data groups related to a school''s end of year status. You can find definitions of these data groups in the "Author''s Comments" section below.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C132 School End of Year Status', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 738
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C137 LEP English Language Proficiency Test
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  739)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of LEP students who were enrolled at the time of the State annual English language proficiency assessment.','SY 2014-15 EDFacts File Specification C137 LEP English Language Proficiency Test','EDFacts File Specification v 11.0',739)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of LEP students who were enrolled at the time of the State annual English language proficiency assessment.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C137 LEP English Language Proficiency Test', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 739
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C138 Title III LEP English Language Proficiency Test
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  740)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the time of the state annual English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA funds.','SY 2014-15 EDFacts File Specification C138 Title III LEP English Language Proficiency Test','EDFacts File Specification v 11.0',740)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the time of the state annual English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA funds.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C138 Title III LEP English Language Proficiency Test', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 740
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C139 LEP English Language Proficiency Test
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  741)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of LEP students who took the annual state English language proficiency assessment.','SY 2014-15 EDFacts File Specification C139 LEP English Language Proficiency Test','EDFacts File Specification v 11.0',741)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of LEP students who took the annual state English language proficiency assessment.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C139 LEP English Language Proficiency Test', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 741
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C141 LEP Enrollment
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  742)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of LEP students enrolled in an elementary or secondary school at any time during the school year.','SY 2014-15 EDFacts File Specification C141 LEP Enrollment','EDFacts File Specification v 11.0',742)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of LEP students enrolled in an elementary or secondary school at any time during the school year.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C141 LEP Enrollment', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 742
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C004 Children with Disabilities (IDEA) Not Participating in Assessments
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  743)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who did not participate in and receive a valid score on the state assessments.','SY 2014-15 EDFacts File Specification C004 Children with Disabilities (IDEA) Not Participating in Assessments','EDFacts Files Specification v 11.1',743)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who did not participate in and receive a valid score on the state assessments.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C004 Children with Disabilities (IDEA) Not Participating in Assessments', CedsConnectionSource = 'EDFacts Files Specification v 11.1'
			where CedsUseCaseId = 743
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C005 Children with Disabilities (IDEA) Removal to Interim Alternative Education Setting
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  744)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who are ages 3 through 21 and removed to an interim alternative educational setting.','SY 2014-15 EDFacts File Specification C005 Children with Disabilities (IDEA) Removal to Interim Alternative Education Setting','EDFacts File Specification v 11.0',744)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who are ages 3 through 21 and removed to an interim alternative educational setting.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C005 Children with Disabilities (IDEA) Removal to Interim Alternative Education Setting', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 744
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C006 Children with Disabilities (IDEA) Suspensions/Expulsions
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  745)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who are ages 3 through 21 and suspended or expelled for disciplinary reasons.','SY 2014-15 EDFacts File Specification C006 Children with Disabilities (IDEA) Suspensions/Expulsions','EDFacts File Specification v 11.0',745)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who are ages 3 through 21 and suspended or expelled for disciplinary reasons.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C006 Children with Disabilities (IDEA) Suspensions/Expulsions', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 745
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C007 Children with Disabilities Reasons for Unilateral Removal
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  746)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of times children with disabilities (IDEA) who are ages 3 through 21 and unilaterally removed by school personnel (not the IEP team) from their current educational placement to an interim alternative educational setting (determined by the IEP team) due to drug or weapon offenses or serious bodily injury.','SY 2014-15 EDFacts File Specification C007 Children with Disabilities Reasons for Unilateral Removal','EDFacts File Specification v 11.0',746)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of times children with disabilities (IDEA) who are ages 3 through 21 and unilaterally removed by school personnel (not the IEP team) from their current educational placement to an interim alternative educational setting (determined by the IEP team) due to drug or weapon offenses or serious bodily injury.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C007 Children with Disabilities Reasons for Unilateral Removal', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 746
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C009 Children with Disabilities Exiting Special Education
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  747)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 14 through 21 and were in special education at the start of the reporting period and were not in special education at the end of the reporting period.','SY 2014-15 EDFacts File Specification C009 Children with Disabilities Exiting Special Education','EDFacts File Specification v 11.0',747)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 14 through 21 and were in special education at the start of the reporting period and were not in special education at the end of the reporting period.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C009 Children with Disabilities Exiting Special Education', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 747
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C070 Special Education Teachers (FTE)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  748)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full- time equivalent (FTE) special education teachers employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.','SY 2014-15 EDFacts File Specification C070 Special Education Teachers (FTE)','EDFacts File Specification v 11.0',748)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full- time equivalent (FTE) special education teachers employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C070 Special Education Teachers (FTE)', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 748
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C088 Children with Disabilities (IDEA) Disciplinary Removals
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  749)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 3 through 21 who were subject to any kind of disciplinary removal during the school year.','SY 2014-15 EDFacts File Specification C088 Children with Disabilities (IDEA) Disciplinary Removals','EDFacts File Specification v 11.0',749)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 3 through 21 who were subject to any kind of disciplinary removal during the school year.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C088 Children with Disabilities (IDEA) Disciplinary Removals', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 749
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C089 Children with Disabilities (IDEA) Early Childhood
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  750)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 3 through 5.','SY 2014-15 EDFacts File Specification C089 Children with Disabilities (IDEA) Early Childhood','EDFacts File Specification v 11.0',750)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 3 through 5.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C089 Children with Disabilities (IDEA) Early Childhood', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 750
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts Files Specification C099 Special Education Related Services Personnel
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  751)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) related services personnel employed or contracted to provide related services for children with disabilities (IDEA) who are ages 3 through 21.','SY 2014-15 EDFacts Files Specification C099 Special Education Related Services Personnel','EDFacts File Specification v 11.0',751)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) related services personnel employed or contracted to provide related services for children with disabilities (IDEA) who are ages 3 through 21.', CedsConnectionName = 'SY 2014-15 EDFacts Files Specification C099 Special Education Related Services Personnel', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 751
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C112 Special Education Paraprofessionals
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  752)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) paraprofessionals employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.','SY 2014-15 EDFacts File Specification C112 Special Education Paraprofessionals','EDFacts File Specification v 11.0',752)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) paraprofessionals employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C112 Special Education Paraprofessionals', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 752
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C143 Children with Disabilities (IDEA) Total Disciplinary Removals
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  753)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of times children with disabilities (IDEA) who are ages 3 through 21 were subject to any kind of disciplinary removal.','SY 2014-15 EDFacts File Specification C143 Children with Disabilities (IDEA) Total Disciplinary Removals','EDFacts File Specification v 11.0',753)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of times children with disabilities (IDEA) who are ages 3 through 21 were subject to any kind of disciplinary removal.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C143 Children with Disabilities (IDEA) Total Disciplinary Removals', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 753
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C144 Educational Services During Expulsion Age
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  754)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children (students) who were removed for disciplinary reasons from their regular school program for the remainder of the school year or longer, including all removals resulting from violations of the Gun-Free Schools Act (GFSA) of 1994.','SY 2014-15 EDFacts File Specification C144 Educational Services During Expulsion Age','EDFacts File Specification v 11.0',754)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children (students) who were removed for disciplinary reasons from their regular school program for the remainder of the school year or longer, including all removals resulting from violations of the Gun-Free Schools Act (GFSA) of 1994.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C144 Educational Services During Expulsion Age', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 754
		END
 
		-----------------------------------------
		-- EDFacts File Specification C141 LEP Enrollment
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  755)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of LEP students enrolled in an elementary or secondary school at any time during the school year.','EDFacts File Specification C141 LEP Enrollment','EDFacts',755)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of LEP students enrolled in an elementary or secondary school at any time during the school year.', CedsConnectionName = 'EDFacts File Specification C141 LEP Enrollment', CedsConnectionSource = 'EDFacts'
			where CedsUseCaseId = 755
		END
 
		-----------------------------------------
		-- EDFacts File Specification C152 Corrective Action
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  756)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of schools in improvement status implementing a corrective action.','EDFacts File Specification C152 Corrective Action','EDFacts File Specification v 11.0',756)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of schools in improvement status implementing a corrective action.', CedsConnectionName = 'EDFacts File Specification C152 Corrective Action', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 756
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C159 Average Scale Scores
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  757)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This file contains the following data groups:    730 - The average scale scores on the state assessments in mathematics and reading/language arts for students for whom a scale score was determined    751 - The scale score at the cut point for a specific achievement percentile on the state assessments in mathematics and reading/language arts','SY 2014-15 EDFacts File Specification C159 Average Scale Scores','EDFacts File Specification v 11.0',757)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This file contains the following data groups:    730 - The average scale scores on the state assessments in mathematics and reading/language arts for students for whom a scale score was determined    751 - The scale score at the cut point for a specific achievement percentile on the state assessments in mathematics and reading/language arts', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C159 Average Scale Scores', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 757
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C160 High School Graduates Postsecondary Enrollment
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  758)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of graduates from two school years prior to the current school year who enrolled or did not enroll in an institution of higher education (IHE) within 16 months of receiving a regular high school diploma.','SY 2014-15 EDFacts File Specification C160 High School Graduates Postsecondary Enrollment','EDFacts File Specification v 11.0',758)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of graduates from two school years prior to the current school year who enrolled or did not enroll in an institution of higher education (IHE) within 16 months of receiving a regular high school diploma.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C160 High School Graduates Postsecondary Enrollment', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 758
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C161 High School Graduates Postsecondary Credits Earned
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  759)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A multi-state based perspective on the processes and aggregations necessary to submit EDFacts files C161 High School Graduates Post-Secondary Credits.  This file collects data about students who enroll in a public institution of higher education in the state within 16 months of receiving a regular high school diploma and who either complete or do not complete at least one year''s worth of college credit applicable to a degree within two years of enrollment in the IHE.','SY 2014-15 EDFacts File Specification C161 High School Graduates Postsecondary Credits Earned','EDFacts CEDS Connections',759)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A multi-state based perspective on the processes and aggregations necessary to submit EDFacts files C161 High School Graduates Post-Secondary Credits.  This file collects data about students who enroll in a public institution of higher education in the state within 16 months of receiving a regular high school diploma and who either complete or do not complete at least one year''s worth of college credit applicable to a degree within two years of enrollment in the IHE.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C161 High School Graduates Postsecondary Credits Earned', CedsConnectionSource = 'EDFacts CEDS Connections'
			where CedsUseCaseId = 759
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C161 High School Graduates Postsecondary Credits Earned
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  760)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Students who enroll in a public institution of higher education (IHE) (as defined in section 101(a) of the HEA) in the state within 16 months of receiving a regular high school diploma and who complete at least one year''s worth of college credit applicable to a degree within two years of enrollment in the IHE.','SY 2014-15 EDFacts File Specification C161 High School Graduates Postsecondary Credits Earned','EDFacts File Specification v 11.0',760)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Students who enroll in a public institution of higher education (IHE) (as defined in section 101(a) of the HEA) in the state within 16 months of receiving a regular high school diploma and who complete at least one year''s worth of college credit applicable to a degree within two years of enrollment in the IHE.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C161 High School Graduates Postsecondary Credits Earned', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 760
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C167 School Improvement Grants
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  761)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This file contains 9 data groups related to School Improvement Grants. You can find definitions of each of these data groups in the "Author''s Comments" section below.','SY 2014-15 EDFacts File Specification C167 School Improvement Grants','EDFacts File Specification C167',761)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This file contains 9 data groups related to School Improvement Grants. You can find definitions of each of these data groups in the "Author''s Comments" section below.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C167 School Improvement Grants', CedsConnectionSource = 'EDFacts File Specification C167'
			where CedsUseCaseId = 761
		END
 
		-----------------------------------------
		-- SY 2014-15 EDFacts File Specification C166 Evaluation of Staff
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  762)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The data collected using this file specification are used to monitor and report performance on the School Improvement Grant (SIG) program, authorized under section 1003(g) of the Elementary and Secondary Education Act (ESEA) of 1965 as amended.    This file contains four data groups related to evaluation of staff. For definitions of these four data groups, see the "Author''s Comments" section below.','SY 2014-15 EDFacts File Specification C166 Evaluation of Staff','EDFacts File Specification v 11.0',762)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The data collected using this file specification are used to monitor and report performance on the School Improvement Grant (SIG) program, authorized under section 1003(g) of the Elementary and Secondary Education Act (ESEA) of 1965 as amended.    This file contains four data groups related to evaluation of staff. For definitions of these four data groups, see the "Author''s Comments" section below.', CedsConnectionName = 'SY 2014-15 EDFacts File Specification C166 Evaluation of Staff', CedsConnectionSource = 'EDFacts File Specification v 11.0'
			where CedsUseCaseId = 762
		END
 
		-----------------------------------------
		-- IDEA SPP/APR Indicator 9: Disproportionate representation (Generate) 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  768)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Percent of districts with disproportionate representation of racial and ethnic groups in special education and related services that is the result of inappropriate identification.','IDEA SPP/APR Indicator 9: Disproportionate representation (Generate) 2015-16','CIID',768)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Percent of districts with disproportionate representation of racial and ethnic groups in special education and related services that is the result of inappropriate identification.', CedsConnectionName = 'IDEA SPP/APR Indicator 9: Disproportionate representation (Generate) 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 768
		END
 
		-----------------------------------------
		-- IDEA SPP/APR Indicator 10: Disproportionate representation by disability category (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  769)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Percent of districts with disproportionate representation of racial and ethnic groups in specific disability categories that is the result of inappropriate identification.','IDEA SPP/APR Indicator 10: Disproportionate representation by disability category (Generate) SY 2015-16','CIID',769)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Percent of districts with disproportionate representation of racial and ethnic groups in specific disability categories that is the result of inappropriate identification.', CedsConnectionName = 'IDEA SPP/APR Indicator 10: Disproportionate representation by disability category (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 769
		END
 
		-----------------------------------------
		-- IDEA SPP/APR Indicator 4A: Rates of suspension and expulsion (Generate) 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  770)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Percentage of districts that have a significant discrepancy in the rate of suspensions and expulsions greater than 10 days in a school year for children with IEPs.','IDEA SPP/APR Indicator 4A: Rates of suspension and expulsion (Generate) 2015-16','CIID',770)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Percentage of districts that have a significant discrepancy in the rate of suspensions and expulsions greater than 10 days in a school year for children with IEPs.', CedsConnectionName = 'IDEA SPP/APR Indicator 4A: Rates of suspension and expulsion (Generate) 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 770
		END
 
		-----------------------------------------
		-- IDEA SPP/APR Indicator 4B: Rates of suspension and expulsion by race/ethnicity (Generate) 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  771)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Percent of districts that have a significant discrepancy in the rate of suspensions and expulsions greater than 10 days in a school year for children with IEPs.','IDEA SPP/APR Indicator 4B: Rates of suspension and expulsion by race/ethnicity (Generate) 2015-16','CIID',771)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Percent of districts that have a significant discrepancy in the rate of suspensions and expulsions greater than 10 days in a school year for children with IEPs.', CedsConnectionName = 'IDEA SPP/APR Indicator 4B: Rates of suspension and expulsion by race/ethnicity (Generate) 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 771
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C004: Children with Disabilities (IDEA) Not Participating in Assessments (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  778)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who did not participate in and receive a valid score on the state assessments.','IDEA 618 Report | C004: Children with Disabilities (IDEA) Not Participating in Assessments (Generate) SY 2016-17','CIID',778)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who did not participate in and receive a valid score on the state assessments.', CedsConnectionName = 'IDEA 618 Report | C004: Children with Disabilities (IDEA) Not Participating in Assessments (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 778
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C175: Academic Achievement in Mathematics (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  779)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in mathematics for whom a proficiency level was assigned.','IDEA 618 Report | C175: Academic Achievement in Mathematics (Generate) SY 2016-17','CIID',779)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in mathematics for whom a proficiency level was assigned.', CedsConnectionName = 'IDEA 618 Report | C175: Academic Achievement in Mathematics (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 779
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C178: Academic Achievement in Reading (Language Arts) (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  780)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.','IDEA 618 Report | C178: Academic Achievement in Reading (Language Arts) (Generate) SY 2016-17','CIID',780)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.', CedsConnectionName = 'IDEA 618 Report | C178: Academic Achievement in Reading (Language Arts) (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 780
		END
 
		-----------------------------------------
		-- Generate - IDEA 618 Report | C185: Assessment Participation in Mathematics
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  781)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students enrolled during the period of the state assessment in mathematics.','Generate - IDEA 618 Report | C185: Assessment Participation in Mathematics','CIID',781)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students enrolled during the period of the state assessment in mathematics.', CedsConnectionName = 'Generate - IDEA 618 Report | C185: Assessment Participation in Mathematics', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 781
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C188: Assessment Participation in Reading/Language Arts (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  782)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.','IDEA 618 Report | C188: Assessment Participation in Reading/Language Arts (Generate) SY 2016-17','CIID',782)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.', CedsConnectionName = 'IDEA 618 Report | C188: Assessment Participation in Reading/Language Arts (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 782
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C171: Academic Achievement - Flexibility Subgroups
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  783)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in mathematics (DG760), reading/language arts (DG761), and science (DG762) for whom a proficiency level was assigned.','IDEA 618 Report | C171: Academic Achievement - Flexibility Subgroups','CIID',783)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in mathematics (DG760), reading/language arts (DG761), and science (DG762) for whom a proficiency level was assigned.', CedsConnectionName = 'IDEA 618 Report | C171: Academic Achievement - Flexibility Subgroups', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 783
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C172: Assessment Participation - Flexibility Subgroups
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  784)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students enrolled during the period of the state assessment in mathematics (DG763), reading/language arts (DG764) or science (DG765).','IDEA 618 Report | C172: Assessment Participation - Flexibility Subgroups','CIID',784)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students enrolled during the period of the state assessment in mathematics (DG763), reading/language arts (DG764) or science (DG765).', CedsConnectionName = 'IDEA 618 Report | C172: Assessment Participation - Flexibility Subgroups', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 784
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C002: Children with Disabilities (IDEA) School Age (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  785)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) ages 6 through 21','IDEA 618 Report | C002: Children with Disabilities (IDEA) School Age (Generate) SY 2016-17','CIID',785)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) ages 6 through 21', CedsConnectionName = 'IDEA 618 Report | C002: Children with Disabilities (IDEA) School Age (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 785
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C089: Children with Disabilities (IDEA) Early Childhood (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  786)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) ages 3 through 5.','IDEA 618 Report | C089: Children with Disabilities (IDEA) Early Childhood (Generate) SY 2016-17','CIID',786)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) ages 3 through 5.', CedsConnectionName = 'IDEA 618 Report | C089: Children with Disabilities (IDEA) Early Childhood (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 786
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C112: Special Education Paraprofessionals (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  787)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) paraprofessionals employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.','IDEA 618 Report | C112: Special Education Paraprofessionals (Generate) SY 2016-17','CIID',787)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) paraprofessionals employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.', CedsConnectionName = 'IDEA 618 Report | C112: Special Education Paraprofessionals (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 787
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C099: Special Education Related Services Personnel (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  788)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) related services personnel employed or contracted to provide related services for children with disabilities (IDEA) who are ages 3 through 21.','IDEA 618 Report | C099: Special Education Related Services Personnel (Generate) SY 2016-17','CIID',788)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) related services personnel employed or contracted to provide related services for children with disabilities (IDEA) who are ages 3 through 21.', CedsConnectionName = 'IDEA 618 Report | C099: Special Education Related Services Personnel (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 788
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C070: Special Education Teachers (FTE) (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  789)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) special education teachers employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.','IDEA 618 Report | C070: Special Education Teachers (FTE) (Generate) SY 2016-17','CIID',789)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) special education teachers employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.', CedsConnectionName = 'IDEA 618 Report | C070: Special Education Teachers (FTE) (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 789
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C009: Children with Disabilities (IDEA) Exiting Special Education (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  790)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 14 through 21 and were in special education at the start of the reporting period and were not in special education at the end of the reporting period.','IDEA 618 Report | C009: Children with Disabilities (IDEA) Exiting Special Education (Generate) SY 2016-17','CIID',790)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 14 through 21 and were in special education at the start of the reporting period and were not in special education at the end of the reporting period.', CedsConnectionName = 'IDEA 618 Report | C009: Children with Disabilities (IDEA) Exiting Special Education (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 790
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C006: Children with Disabilities (IDEA) Suspensions/Expulsions (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  791)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who are ages 3 through 21 and suspended or expelled for disciplinary reasons.','IDEA 618 Report | C006: Children with Disabilities (IDEA) Suspensions/Expulsions (Generate) SY 2016-17','CIID',791)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who are ages 3 through 21 and suspended or expelled for disciplinary reasons.', CedsConnectionName = 'IDEA 618 Report | C006: Children with Disabilities (IDEA) Suspensions/Expulsions (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 791
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C088: Children with Disabilities (IDEA) Disciplinary Removals (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  792)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 3 through 21 who were subject to any kind of disciplinary removal during the school year.','IDEA 618 Report | C088: Children with Disabilities (IDEA) Disciplinary Removals (Generate) SY 2016-17','CIID',792)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 3 through 21 who were subject to any kind of disciplinary removal during the school year.', CedsConnectionName = 'IDEA 618 Report | C088: Children with Disabilities (IDEA) Disciplinary Removals (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 792
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C143: Children with Disabilities (IDEA) Total Disciplinary Removals (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  793)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of times children with disabilities (IDEA) who are ages 3 through 21 were subject to any kind of disciplinary removal.','IDEA 618 Report | C143: Children with Disabilities (IDEA) Total Disciplinary Removals (Generate) SY 2016-17','CIID',793)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of times children with disabilities (IDEA) who are ages 3 through 21 were subject to any kind of disciplinary removal.', CedsConnectionName = 'IDEA 618 Report | C143: Children with Disabilities (IDEA) Total Disciplinary Removals (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 793
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  794)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who are ages 3 through 21 and  removed to an interim alternative educational setting.','IDEA 618 Report | C005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting (Generate) SY 2016-17','CIID',794)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who are ages 3 through 21 and  removed to an interim alternative educational setting.', CedsConnectionName = 'IDEA 618 Report | C005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 794
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C007: Children with Disabilities (IDEA) Reasons for Unilateral Removal (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  795)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of times children with disabilities (IDEA) who are ages 3 through 21 were unilaterally removed by school personnel (not the IEP team) from their current educational placement to an interim alternative educational setting (determined by the IEP team) due to drug or weapon offenses or serious bodily injury.','IDEA 618 Report | C007: Children with Disabilities (IDEA) Reasons for Unilateral Removal (Generate) SY 2016-17','CIID',795)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of times children with disabilities (IDEA) who are ages 3 through 21 were unilaterally removed by school personnel (not the IEP team) from their current educational placement to an interim alternative educational setting (determined by the IEP team) due to drug or weapon offenses or serious bodily injury.', CedsConnectionName = 'IDEA 618 Report | C007: Children with Disabilities (IDEA) Reasons for Unilateral Removal (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 795
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C144: Educational Services During Expulsion (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  796)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children (students) who were removed for disciplinary reasons from their regular school program for the remainder of the school year or longer, including all removals resulting from violations of the Gun-Free Schools Act (GFSA) of 1994.','IDEA 618 Report | C144: Educational Services During Expulsion (Generate) SY 2016-17','CIID',796)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children (students) who were removed for disciplinary reasons from their regular school program for the remainder of the school year or longer, including all removals resulting from violations of the Gun-Free Schools Act (GFSA) of 1994.', CedsConnectionName = 'IDEA 618 Report | C144: Educational Services During Expulsion (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 796
		END
 
		-----------------------------------------
		-- Military Student Indicator - ESSA
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  1833)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection provides information states may need to consider when collecting and reporting if a student''s family is on military active duty or not.','Military Student Indicator - ESSA','SLDS Workgroup',1833)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection provides information states may need to consider when collecting and reporting if a student''s family is on military active duty or not.', CedsConnectionName = 'Military Student Indicator - ESSA', CedsConnectionSource = 'SLDS Workgroup'
			where CedsUseCaseId = 1833
		END
 
		-----------------------------------------
		-- IDEA SPP/APR indicator 10: Disproportionate representation by disability category
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  1840)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Percent of districts with disproportionate representation of racial and ethnic groups in special education and related services that is the result of inappropriate identification.','IDEA SPP/APR indicator 10: Disproportionate representation by disability category','CIID',1840)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Percent of districts with disproportionate representation of racial and ethnic groups in special education and related services that is the result of inappropriate identification.', CedsConnectionName = 'IDEA SPP/APR indicator 10: Disproportionate representation by disability category', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 1840
		END
 
		-----------------------------------------
		-- CEDS Elements for IDEA 618 and SPP/APR data (Iteration I) By File Type (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  1844)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A compilation of the CEDS elements, by file type, required to report the IDEA 618 and SPP/APR data that is included in Generate, Iteration I.','CEDS Elements for IDEA 618 and SPP/APR data (Iteration I) By File Type (Generate)','CIID',1844)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A compilation of the CEDS elements, by file type, required to report the IDEA 618 and SPP/APR data that is included in Generate, Iteration I.', CedsConnectionName = 'CEDS Elements for IDEA 618 and SPP/APR data (Iteration I) By File Type (Generate)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 1844
		END
 
		-----------------------------------------
		-- CEDS Elements for IDEA 618 and SPP/APR data (Iteration I) All Elements (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  1845)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The full list of CEDS elements required for Generate, Iteration I','CEDS Elements for IDEA 618 and SPP/APR data (Iteration I) All Elements (Generate)','CIID',1845)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The full list of CEDS elements required for Generate, Iteration I', CedsConnectionName = 'CEDS Elements for IDEA 618 and SPP/APR data (Iteration I) All Elements (Generate)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 1845
		END
 
		-----------------------------------------
		-- K12 Student Program Participation
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2864)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Analysis of student performance by program participation','K12 Student Program Participation','CIID',2864)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Analysis of student performance by program participation', CedsConnectionName = 'K12 Student Program Participation', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2864
		END
 
		-----------------------------------------
		-- U.S. Department of Education Accountability and Reporting Provisions of ESEA as amended by ESSA, Academic Achievement Indicators
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2865)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of a school’s progress on the Academic Achievement Indicator for Mathematics and/or Reading/Language Art','U.S. Department of Education Accountability and Reporting Provisions of ESEA as amended by ESSA, Academic Achievement Indicators','EDFacts Data Set SY 2017-18 and 2018-19 Changes from SY 2016-17 ',2865)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of a school’s progress on the Academic Achievement Indicator for Mathematics and/or Reading/Language Art', CedsConnectionName = 'U.S. Department of Education Accountability and Reporting Provisions of ESEA as amended by ESSA, Academic Achievement Indicators', CedsConnectionSource = 'EDFacts Data Set SY 2017-18 and 2018-19 Changes from SY 2016-17 '
			where CedsUseCaseId = 2865
		END
 
		-----------------------------------------
		-- EDFacts New Data Group SY 2018-19: Accountability and Reporting Provisions of ESEA, as amended by ESSA,  Comprehensive Support or Targeted Support
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2866)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication the school is designated by the state as a comprehensive support or targeted support and improvement school.','EDFacts New Data Group SY 2018-19: Accountability and Reporting Provisions of ESEA, as amended by ESSA,  Comprehensive Support or Targeted Support','EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17',2866)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication the school is designated by the state as a comprehensive support or targeted support and improvement school.', CedsConnectionName = 'EDFacts New Data Group SY 2018-19: Accountability and Reporting Provisions of ESEA, as amended by ESSA,  Comprehensive Support or Targeted Support', CedsConnectionSource = 'EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17'
			where CedsUseCaseId = 2866
		END
 
		-----------------------------------------
		-- EDFacts New Data Group SY 2017-18: English Learner Students and Title III of ESEA, as amended by ESSA
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2867)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of English learners served by an English language instruction educational program supported with Title III of ESEA, as amended, funds who have not attained proficiency after five years of identification as an English learner.','EDFacts New Data Group SY 2017-18: English Learner Students and Title III of ESEA, as amended by ESSA','EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17',2867)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of English learners served by an English language instruction educational program supported with Title III of ESEA, as amended, funds who have not attained proficiency after five years of identification as an English learner.', CedsConnectionName = 'EDFacts New Data Group SY 2017-18: English Learner Students and Title III of ESEA, as amended by ESSA', CedsConnectionSource = 'EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17'
			where CedsUseCaseId = 2867
		END
 
		-----------------------------------------
		-- EDFacts New Data Category SY 2017-18:  Foster Care Status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2868)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication that students are in foster care.','EDFacts New Data Category SY 2017-18:  Foster Care Status','EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17',2868)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication that students are in foster care.', CedsConnectionName = 'EDFacts New Data Category SY 2017-18:  Foster Care Status', CedsConnectionSource = 'EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17'
			where CedsUseCaseId = 2868
		END
 
		-----------------------------------------
		-- EDFacts New Data Category SY 2017-18: Military Connected Student Status
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2869)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication that the students are military connected.','EDFacts New Data Category SY 2017-18: Military Connected Student Status','EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17',2869)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication that the students are military connected.', CedsConnectionName = 'EDFacts New Data Category SY 2017-18: Military Connected Student Status', CedsConnectionSource = 'EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17'
			where CedsUseCaseId = 2869
		END
 
		-----------------------------------------
		-- EDFacts New Data Group SY 2017-18: Accountability and Reporting Provisions of ESEA, as amended by ESSA, Academic Achievement and Progress Indicators
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2871)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of a school’s progress on the Academic Achievement or Progress Indicator for Mathematics and  Reading/Language Arts.','EDFacts New Data Group SY 2017-18: Accountability and Reporting Provisions of ESEA, as amended by ESSA, Academic Achievement and Progress Indicators','EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17',2871)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of a school’s progress on the Academic Achievement or Progress Indicator for Mathematics and  Reading/Language Arts.', CedsConnectionName = 'EDFacts New Data Group SY 2017-18: Accountability and Reporting Provisions of ESEA, as amended by ESSA, Academic Achievement and Progress Indicators', CedsConnectionSource = 'EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17'
			where CedsUseCaseId = 2871
		END
 
		-----------------------------------------
		-- EDFacts New Data Group SY 2017-18:  Accountability and Reporting Provisions of ESEA, as amended by ESSA, Graduation Rate Indicator
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2872)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of a school’s progress on the Graduation Rate Indicator.','EDFacts New Data Group SY 2017-18:  Accountability and Reporting Provisions of ESEA, as amended by ESSA, Graduation Rate Indicator','EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17',2872)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of a school’s progress on the Graduation Rate Indicator.', CedsConnectionName = 'EDFacts New Data Group SY 2017-18:  Accountability and Reporting Provisions of ESEA, as amended by ESSA, Graduation Rate Indicator', CedsConnectionSource = 'EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17'
			where CedsUseCaseId = 2872
		END
 
		-----------------------------------------
		-- EDFacts Proposed Items: Accountability and Reporting Provisions of ESEA, as amended by ESSA, Progress on the Summative Rating
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2873)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of a school’s progress on the Summative Rating. (Proposed EDFacts Data Groups based on ESEA, as amended by ESSA)','EDFacts Proposed Items: Accountability and Reporting Provisions of ESEA, as amended by ESSA, Progress on the Summative Rating','EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17',2873)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of a school’s progress on the Summative Rating. (Proposed EDFacts Data Groups based on ESEA, as amended by ESSA)', CedsConnectionName = 'EDFacts Proposed Items: Accountability and Reporting Provisions of ESEA, as amended by ESSA, Progress on the Summative Rating', CedsConnectionSource = 'EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17'
			where CedsUseCaseId = 2873
		END
 
		-----------------------------------------
		-- EDFacts New Data Group SY 2017-18:  Accountability and Reporting Provisions of ESEA, as amended by ESSA, State Specified Indicators
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2874)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of a school’s progress on the state specific indicators of school quality or student success.','EDFacts New Data Group SY 2017-18:  Accountability and Reporting Provisions of ESEA, as amended by ESSA, State Specified Indicators','EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17',2874)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of a school’s progress on the state specific indicators of school quality or student success.', CedsConnectionName = 'EDFacts New Data Group SY 2017-18:  Accountability and Reporting Provisions of ESEA, as amended by ESSA, State Specified Indicators', CedsConnectionSource = 'EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17'
			where CedsUseCaseId = 2874
		END
 
		-----------------------------------------
		-- EDFacts New Data Group SY 2017-18:  Accountability and Reporting Provisions of ESEA, as amended by ESSA, Achieving English Language Proficiency Indicator
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2875)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of a school’s progress in Achieving English Language Proficiency Indicator.','EDFacts New Data Group SY 2017-18:  Accountability and Reporting Provisions of ESEA, as amended by ESSA, Achieving English Language Proficiency Indicator','EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17',2875)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of a school’s progress in Achieving English Language Proficiency Indicator.', CedsConnectionName = 'EDFacts New Data Group SY 2017-18:  Accountability and Reporting Provisions of ESEA, as amended by ESSA, Achieving English Language Proficiency Indicator', CedsConnectionSource = 'EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17'
			where CedsUseCaseId = 2875
		END
 
		-----------------------------------------
		-- EDFacts New Data Group SY 2017-18: Accountability and Reporting Provisions of ESEA, as amended by ESSA, Teachers Tables
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2876)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of teachers table.','EDFacts New Data Group SY 2017-18: Accountability and Reporting Provisions of ESEA, as amended by ESSA, Teachers Tables','EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17',2876)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of teachers table.', CedsConnectionName = 'EDFacts New Data Group SY 2017-18: Accountability and Reporting Provisions of ESEA, as amended by ESSA, Teachers Tables', CedsConnectionSource = 'EDFacts Data Set SY 2017-18 and 2018-19 Proposed Changes from SY 2016-17'
			where CedsUseCaseId = 2876
		END
 
		-----------------------------------------
		-- What are the employment rates of high school and college graduates six months after graduation?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2878)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Determining the employment rates of high school and college graduates six months after graduation.','What are the employment rates of high school and college graduates six months after graduation?','SLDS Workgroup',2878)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Determining the employment rates of high school and college graduates six months after graduation.', CedsConnectionName = 'What are the employment rates of high school and college graduates six months after graduation?', CedsConnectionSource = 'SLDS Workgroup'
			where CedsUseCaseId = 2878
		END
 
		-----------------------------------------
		-- IDEA Students in Title I Schools
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2881)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Number of students in Title I schools who are served under IDEA.','IDEA Students in Title I Schools','CIID',2881)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Number of students in Title I schools who are served under IDEA.', CedsConnectionName = 'IDEA Students in Title I Schools', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2881
		END
 
		-----------------------------------------
		-- What percentage of postsecondary or program completers are employed in the state?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2882)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection is about determining the percentage of postsecondary or program completers who are employed in the state.  This is useful for program evaluations that relate to workforce or economic development issues.  Note that high school students are not included in this question.','What percentage of postsecondary or program completers are employed in the state?','SLDS Employment Outcomes Indicator Workgroup',2882)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection is about determining the percentage of postsecondary or program completers who are employed in the state.  This is useful for program evaluations that relate to workforce or economic development issues.  Note that high school students are not included in this question.', CedsConnectionName = 'What percentage of postsecondary or program completers are employed in the state?', CedsConnectionSource = 'SLDS Employment Outcomes Indicator Workgroup'
			where CedsUseCaseId = 2882
		END
 
		-----------------------------------------
		-- Generate - IDEA 618 Report | C188: Assessment Participation in Reading/Language Arts (2)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2883)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.','Generate - IDEA 618 Report | C188: Assessment Participation in Reading/Language Arts (2)','CIID',2883)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.', CedsConnectionName = 'Generate - IDEA 618 Report | C188: Assessment Participation in Reading/Language Arts (2)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2883
		END
 
		-----------------------------------------
		-- Generate - IDEA 618 Report | C185: Assessment Participation in Mathematics (2)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2884)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students enrolled during the period of the state assessment in mathematics.','Generate - IDEA 618 Report | C185: Assessment Participation in Mathematics (2)','CIID',2884)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students enrolled during the period of the state assessment in mathematics.', CedsConnectionName = 'Generate - IDEA 618 Report | C185: Assessment Participation in Mathematics (2)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2884
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C185: Assessment Participation in Mathematics (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2885)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in mathematics.','IDEA 618 Report | C185: Assessment Participation in Mathematics (Generate) SY 2016-17','CIID',2885)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in mathematics.', CedsConnectionName = 'IDEA 618 Report | C185: Assessment Participation in Mathematics (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2885
		END
 
		-----------------------------------------
		-- What are the earnings two, five, and ten years after completion by program?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2887)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection is about how to determine the earnings of program completers (postsecondary, high school, or non-credit) two, five, and ten years after completion.  Examples will include mean, median, and interquartiles.','What are the earnings two, five, and ten years after completion by program?','SLDS Employment Outcomes Indicator Workgroup',2887)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection is about how to determine the earnings of program completers (postsecondary, high school, or non-credit) two, five, and ten years after completion.  Examples will include mean, median, and interquartiles.', CedsConnectionName = 'What are the earnings two, five, and ten years after completion by program?', CedsConnectionSource = 'SLDS Employment Outcomes Indicator Workgroup'
			where CedsUseCaseId = 2887
		END
 
		-----------------------------------------
		-- What are the employment rates of secondary and postsecondary or program completers in the second quarter after graduation?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2888)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection is about determining the employment rates of secondary and postsecondary or program completers in the second quarter after graduation.  This is useful for program evaluations that relate to workforce or economic development issues.','What are the employment rates of secondary and postsecondary or program completers in the second quarter after graduation?','SLDS Employment Outcomes Indicator Workgroup',2888)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection is about determining the employment rates of secondary and postsecondary or program completers in the second quarter after graduation.  This is useful for program evaluations that relate to workforce or economic development issues.', CedsConnectionName = 'What are the employment rates of secondary and postsecondary or program completers in the second quarter after graduation?', CedsConnectionSource = 'SLDS Employment Outcomes Indicator Workgroup'
			where CedsUseCaseId = 2888
		END
 
		-----------------------------------------
		-- What is the value add for secondary and postsecondary or program education and training programs?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2890)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection provides several examples of the way the value added by secondary and postsecondary or program education and training programs could be determined and the process for conducting that analysis.','What is the value add for secondary and postsecondary or program education and training programs?','SLDS Employment Outcomes Indicator Workgroup',2890)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection provides several examples of the way the value added by secondary and postsecondary or program education and training programs could be determined and the process for conducting that analysis.', CedsConnectionName = 'What is the value add for secondary and postsecondary or program education and training programs?', CedsConnectionSource = 'SLDS Employment Outcomes Indicator Workgroup'
			where CedsUseCaseId = 2890
		END
 
		-----------------------------------------
		-- Participation of Students in Multiple Federal Programs (Generate - State Designed Report)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2893)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Students Participating in Multiple Federal Programs','Participation of Students in Multiple Federal Programs (Generate - State Designed Report)','CIID',2893)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Students Participating in Multiple Federal Programs', CedsConnectionName = 'Participation of Students in Multiple Federal Programs (Generate - State Designed Report)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2893
		END
 
		-----------------------------------------
		-- Demographic Characteristic Report (Generate - State Designed Report)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2897)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Generate report will allow SEA users to: 1) Select and view both numbers and percentages of SWD by characteristics as per state annual child count date(s). 2) View a calculated disability incident rate calculated as: SWD/(SWD plus SWOD) for students ages 5-18 (as of child count date). 3) View PRIMARY disability incident rate of SWD with a specific primary disability/(all other SWD plus SWOD) (students ages 5-18 as of child count date).','Demographic Characteristic Report (Generate - State Designed Report)','CIID',2897)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Generate report will allow SEA users to: 1) Select and view both numbers and percentages of SWD by characteristics as per state annual child count date(s). 2) View a calculated disability incident rate calculated as: SWD/(SWD plus SWOD) for students ages 5-18 (as of child count date). 3) View PRIMARY disability incident rate of SWD with a specific primary disability/(all other SWD plus SWOD) (students ages 5-18 as of child count date).', CedsConnectionName = 'Demographic Characteristic Report (Generate - State Designed Report)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2897
		END
 
		-----------------------------------------
		-- Performance on state assessments (CIID-Generate - State Designed Report)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2899)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Student performance report developed for Generate. Report can be produced at the SEA or LEA levels, for all students, for students with disabilities, and for students without disabilities for each type of assessment and grade.','Performance on state assessments (CIID-Generate - State Designed Report)','CIID',2899)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Student performance report developed for Generate. Report can be produced at the SEA or LEA levels, for all students, for students with disabilities, and for students without disabilities for each type of assessment and grade.', CedsConnectionName = 'Performance on state assessments (CIID-Generate - State Designed Report)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2899
		END
 
		-----------------------------------------
		-- Children with Disabilities (IDEA) Total Disciplinary Removals (Generate - State Designed Report)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2901)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This report provides the number of times children with disabilities (IDEA) ages 3 through 21 were subject to any kind of disciplinary removal, disaggregated by the report categories of sex, LEP Status, disability and racial/ethnic.','Children with Disabilities (IDEA) Total Disciplinary Removals (Generate - State Designed Report)','CIID',2901)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This report provides the number of times children with disabilities (IDEA) ages 3 through 21 were subject to any kind of disciplinary removal, disaggregated by the report categories of sex, LEP Status, disability and racial/ethnic.', CedsConnectionName = 'Children with Disabilities (IDEA) Total Disciplinary Removals (Generate - State Designed Report)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2901
		END
 
		-----------------------------------------
		-- Disciplinary Removals by Sex (Generate - State Designed Report)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2902)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This report disaggregates the number of children with disciplinary removals by sex.','Disciplinary Removals by Sex (Generate - State Designed Report)','CIID',2902)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This report disaggregates the number of children with disciplinary removals by sex.', CedsConnectionName = 'Disciplinary Removals by Sex (Generate - State Designed Report)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2902
		END
 
		-----------------------------------------
		-- Disciplinary Removals by Racial/Ethnic (Generate - State Designed Report)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2903)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) ages 3 through 21 who were subject to any kind of disciplinary removal during the school year.','Disciplinary Removals by Racial/Ethnic (Generate - State Designed Report)','CIID',2903)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) ages 3 through 21 who were subject to any kind of disciplinary removal during the school year.', CedsConnectionName = 'Disciplinary Removals by Racial/Ethnic (Generate - State Designed Report)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2903
		END
 
		-----------------------------------------
		-- Number of Students with Disciplinary Removals (Generate - State Designed Report)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2904)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This report provides the number of students with Disciplinary Removals.','Number of Students with Disciplinary Removals (Generate - State Designed Report)','CIID',2904)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This report provides the number of students with Disciplinary Removals.', CedsConnectionName = 'Number of Students with Disciplinary Removals (Generate - State Designed Report)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2904
		END
 
		-----------------------------------------
		-- Disciplinary Removals by LEP Status (Generate - State Designed Report)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2905)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This report disaggregates the number of children with disciplinary removals by LEP status.','Disciplinary Removals by LEP Status (Generate - State Designed Report)','CIID',2905)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This report disaggregates the number of children with disciplinary removals by LEP status.', CedsConnectionName = 'Disciplinary Removals by LEP Status (Generate - State Designed Report)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2905
		END
 
		-----------------------------------------
		-- Disciplinary Removals by Disability (Generate State Designed Report)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2906)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This report disaggregates the number of children with disciplinary removals by disability.','Disciplinary Removals by Disability (Generate State Designed Report)','CIID',2906)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This report disaggregates the number of children with disciplinary removals by disability.', CedsConnectionName = 'Disciplinary Removals by Disability (Generate State Designed Report)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2906
		END
 
		-----------------------------------------
		-- Adjusted Cohort Graduation Rate (Generate - State Designed Report)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2907)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This report shows students with and without disabilities, graduating from high school with a regular diploma by the varying time it takes a student, from the first time they enter 9th grade, to graduate (cohort year). The graphics show a breakdown of several student demographics, including disability status, disability category, sex, race/ethnicity, LEP Status and those special education students who returned to general education.','Adjusted Cohort Graduation Rate (Generate - State Designed Report)','CIID',2907)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This report shows students with and without disabilities, graduating from high school with a regular diploma by the varying time it takes a student, from the first time they enter 9th grade, to graduate (cohort year). The graphics show a breakdown of several student demographics, including disability status, disability category, sex, race/ethnicity, LEP Status and those special education students who returned to general education.', CedsConnectionName = 'Adjusted Cohort Graduation Rate (Generate - State Designed Report)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2907
		END
 
		-----------------------------------------
		-- Exit From Special Education (Generate - State Designed Report)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2908)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This report gives the user a set of raw data in which they can then create personalized data charts, tables, and graphics that are of particular use to them.','Exit From Special Education (Generate - State Designed Report)','CIID',2908)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This report gives the user a set of raw data in which they can then create personalized data charts, tables, and graphics that are of particular use to them.', CedsConnectionName = 'Exit From Special Education (Generate - State Designed Report)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2908
		END
 
		-----------------------------------------
		-- CEDS Elements for State Designed Reports - All Elements (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2911)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The full list of CEDS elements required for Generate''s State Designed Reports.','CEDS Elements for State Designed Reports - All Elements (Generate)','CIID',2911)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The full list of CEDS elements required for Generate''s State Designed Reports.', CedsConnectionName = 'CEDS Elements for State Designed Reports - All Elements (Generate)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2911
		END
 
		-----------------------------------------
		-- Common High School Feedback Report
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2912)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The elements and analysis that are used in many of the high school feedback reports across the country.','Common High School Feedback Report','SLDS Best Practices Conference Workgroup',2912)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The elements and analysis that are used in many of the high school feedback reports across the country.', CedsConnectionName = 'Common High School Feedback Report', CedsConnectionSource = 'SLDS Best Practices Conference Workgroup'
			where CedsUseCaseId = 2912
		END
 
		-----------------------------------------
		-- Demonstration HS Feedback Report
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2913)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('High school feedback report example.','Demonstration HS Feedback Report','SLDS Best Practices CEDS Session',2913)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'High school feedback report example.', CedsConnectionName = 'Demonstration HS Feedback Report', CedsConnectionSource = 'SLDS Best Practices CEDS Session'
			where CedsUseCaseId = 2913
		END
 
		-----------------------------------------
		-- Demonstration High School Feedback Report
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2914)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('High School Feedback Report Example','Demonstration High School Feedback Report','SLDS Best Practices CEDS Session',2914)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'High School Feedback Report Example', CedsConnectionName = 'Demonstration High School Feedback Report', CedsConnectionSource = 'SLDS Best Practices CEDS Session'
			where CedsUseCaseId = 2914
		END
 
		-----------------------------------------
		-- Demonstration HS Feedback Report
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2915)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('High School Feedback Report','Demonstration HS Feedback Report','SLDS Best Practices CEDS Session',2915)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'High School Feedback Report', CedsConnectionName = 'Demonstration HS Feedback Report', CedsConnectionSource = 'SLDS Best Practices CEDS Session'
			where CedsUseCaseId = 2915
		END
 
		-----------------------------------------
		-- Demonstration HS Feedback Report
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2916)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('High School Feedback Report Example','Demonstration HS Feedback Report','SLDS Best Practices CEDS Session',2916)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'High School Feedback Report Example', CedsConnectionName = 'Demonstration HS Feedback Report', CedsConnectionSource = 'SLDS Best Practices CEDS Session'
			where CedsUseCaseId = 2916
		END
 
		-----------------------------------------
		-- Demonstation High School Feedback
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2917)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('High School Feedback Report Example','Demonstation High School Feedback','SLDS Best Practices CEDS Session',2917)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'High School Feedback Report Example', CedsConnectionName = 'Demonstation High School Feedback', CedsConnectionSource = 'SLDS Best Practices CEDS Session'
			where CedsUseCaseId = 2917
		END
 
		-----------------------------------------
		-- Demostration HS Feedback Report
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2918)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Hihg School Feedback Report Example','Demostration HS Feedback Report','SLDS Best Practices CEDS Session',2918)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Hihg School Feedback Report Example', CedsConnectionName = 'Demostration HS Feedback Report', CedsConnectionSource = 'SLDS Best Practices CEDS Session'
			where CedsUseCaseId = 2918
		END
 
		-----------------------------------------
		-- Demonstration High School Feedback Report
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2919)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('High School Feedback Report Example','Demonstration High School Feedback Report','SLDS Best Practices CEDS Session',2919)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'High School Feedback Report Example', CedsConnectionName = 'Demonstration High School Feedback Report', CedsConnectionSource = 'SLDS Best Practices CEDS Session'
			where CedsUseCaseId = 2919
		END
 
		-----------------------------------------
		-- Demonstration HS Feedback Report
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2920)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('High School Feedback Report Example','Demonstration HS Feedback Report','SLDS Best Practices CEDS Session',2920)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'High School Feedback Report Example', CedsConnectionName = 'Demonstration HS Feedback Report', CedsConnectionSource = 'SLDS Best Practices CEDS Session'
			where CedsUseCaseId = 2920
		END
 
		-----------------------------------------
		-- Demonstration HS Feedback Report
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2921)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('High School Feedback Report Example','Demonstration HS Feedback Report','SLDS Best Practices CEDS Session',2921)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'High School Feedback Report Example', CedsConnectionName = 'Demonstration HS Feedback Report', CedsConnectionSource = 'SLDS Best Practices CEDS Session'
			where CedsUseCaseId = 2921
		END
 
		-----------------------------------------
		-- Demonstration HS Feedback Report
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2922)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('High School Feedback Report Example','Demonstration HS Feedback Report','SLDS Best Practices CEDS Session',2922)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'High School Feedback Report Example', CedsConnectionName = 'Demonstration HS Feedback Report', CedsConnectionSource = 'SLDS Best Practices CEDS Session'
			where CedsUseCaseId = 2922
		END
 
		-----------------------------------------
		-- Graduation Rates
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2923)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('graduation','Graduation Rates','SLDS Conference',2923)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'graduation', CedsConnectionName = 'Graduation Rates', CedsConnectionSource = 'SLDS Conference'
			where CedsUseCaseId = 2923
		END
 
		-----------------------------------------
		-- Demonstration HS Feedback Report
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2924)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('High School Feedback Report','Demonstration HS Feedback Report','SLDS Best Practices CEDS Session',2924)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'High School Feedback Report', CedsConnectionName = 'Demonstration HS Feedback Report', CedsConnectionSource = 'SLDS Best Practices CEDS Session'
			where CedsUseCaseId = 2924
		END
 
		-----------------------------------------
		-- Demonstrators HS Feedback ReportSL
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2925)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('High School Feedback Report Example','Demonstrators HS Feedback ReportSL','SLDS Best Practice CEDS Session',2925)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'High School Feedback Report Example', CedsConnectionName = 'Demonstrators HS Feedback ReportSL', CedsConnectionSource = 'SLDS Best Practice CEDS Session'
			where CedsUseCaseId = 2925
		END
 
		-----------------------------------------
		-- Generate Selection Criteria Template
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2954)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Cohorts for four-year, five-year, and six-year adjusted-cohort graduation rate table.','Generate Selection Criteria Template','SLDS State Support Team',2954)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Cohorts for four-year, five-year, and six-year adjusted-cohort graduation rate table.', CedsConnectionName = 'Generate Selection Criteria Template', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2954
		END
 
		-----------------------------------------
		-- CCD Report | FS129: CCD Schools (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2955)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS129, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS129: CCD Schools (Generate) SY 2017-18','SLDS State Support Team',2955)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS129, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS129: CCD Schools (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2955
		END
 
		-----------------------------------------
		-- CSPR II Report | FS036: Title I Part A TAS Services (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2957)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS036, created in collaboration with the EDFacts PSC and CIID.','CSPR II Report | FS036: Title I Part A TAS Services (Generate)','SLDS State Support Team',2957)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS036, created in collaboration with the EDFacts PSC and CIID.', CedsConnectionName = 'CSPR II Report | FS036: Title I Part A TAS Services (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2957
		END
 
		-----------------------------------------
		-- CCD Report | FS059: Staff FTE (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2958)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS059, created in collaboration with the EDFacts Partner Support Center (PSC) and CIID.','CCD Report | FS059: Staff FTE (Generate) SY 2017-18','SLDS State Support Team',2958)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS059, created in collaboration with the EDFacts Partner Support Center (PSC) and CIID.', CedsConnectionName = 'CCD Report | FS059: Staff FTE (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2958
		END
 
		-----------------------------------------
		-- CSPR II Report | FS037: Title I Part A SWP/TAS Participation (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2959)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS037, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS037: Title I Part A SWP/TAS Participation (Generate) SY 2017-18','SLDS State Support Team',2959)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS037, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS037: Title I Part A SWP/TAS Participation (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2959
		END
 
		-----------------------------------------
		-- CSPR II Report | FS134: Title I Part A Participation (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2960)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS134, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS134: Title I Part A Participation (Generate) SY 2017-18','SLDS State Support Team',2960)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS134, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS134: Title I Part A Participation (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2960
		END
 
		-----------------------------------------
		-- EdFacts Membership C052
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2962)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The official unduplicated student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.','EdFacts Membership C052','CIID',2962)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The official unduplicated student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.', CedsConnectionName = 'EdFacts Membership C052', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2962
		END
 
		-----------------------------------------
		-- Generate EdFacts C052 - Membership
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2963)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who graduated from high school or completed some other education program that is approved by the state or local education agency (SEA or LEA) during the school year and the subsequent summer school.','Generate EdFacts C052 - Membership','CIID',2963)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who graduated from high school or completed some other education program that is approved by the state or local education agency (SEA or LEA) during the school year and the subsequent summer school.', CedsConnectionName = 'Generate EdFacts C052 - Membership', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2963
		END
 
		-----------------------------------------
		-- CCD Report | FS033 Generate: Free and Reduced Price Lunch (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2964)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS033, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS033 Generate: Free and Reduced Price Lunch (Generate) SY 2017-18','SLDS State Support Team',2964)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS033, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS033 Generate: Free and Reduced Price Lunch (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2964
		END
 
		-----------------------------------------
		-- CCD Report | FS141: LEP Enrolled (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2965)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS141, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS141: LEP Enrolled (Generate) SY 2017-18','SLDS State Support Team',2965)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS141, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS141: LEP Enrolled (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2965
		END
 
		-----------------------------------------
		-- CSPR II Report | FS054: MEP Students Served - 12 Months (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2966)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS054, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS054: MEP Students Served - 12 Months (Generate) SY 2017-18','SLDS State Support Team',2966)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS054, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS054: MEP Students Served - 12 Months (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2966
		END
 
		-----------------------------------------
		-- CSPR II Report | FS121: Migratory Students Eligible - 12 Months  (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2967)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS121, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS121: Migratory Students Eligible - 12 Months  (Generate) SY 2017-18','SLDS State Support Team',2967)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS121, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS121: Migratory Students Eligible - 12 Months  (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2967
		END
 
		-----------------------------------------
		-- CSPR II Report | FS165: Migratory Data (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2968)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS165, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS165: Migratory Data (Generate) SY 2017-18','SLDS State Support Team',2968)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS165, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS165: Migratory Data (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2968
		END
 
		-----------------------------------------
		-- CCD Report | FS029: Directory (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2969)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS029: Directory (Generate) SY 2017-18','SLDS State Support Team',2969)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS029: Directory (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2969
		END
 
		-----------------------------------------
		-- Generate EdFacts 040 Graduates/Completers
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2970)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who graduated from high school or completed some other education program that is approved by the state or local education agency (SEA or LEA) during the school year and the subsequent summer school.','Generate EdFacts 040 Graduates/Completers','CIID',2970)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who graduated from high school or completed some other education program that is approved by the state or local education agency (SEA or LEA) during the school year and the subsequent summer school.', CedsConnectionName = 'Generate EdFacts 040 Graduates/Completers', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2970
		END
 
		-----------------------------------------
		-- CSPR II Report | FS193: Title I Allocations (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2971)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS193, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS193: Title I Allocations (Generate) SY 2017-18','SLDS State Support Team',2971)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS193, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS193: Title I Allocations (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2971
		END
 
		-----------------------------------------
		-- CCD Report | FS032: Dropouts (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2973)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS032, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS032: Dropouts (Generate) SY 2018-19','SLDS State Support Team',2973)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS032, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS032: Dropouts (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2973
		END
 
		-----------------------------------------
		-- Kindergarten Readiness
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2977)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection provides the elements that would be needed to store Kindergarten Readiness information.  It also provides examples of Kindergarten Readiness competencies used by some states as well as examples of reports run related to subgroups of children and their readiness for kindergarten.','Kindergarten Readiness','SLDS Kindergarten Readiness Workgroup',2977)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection provides the elements that would be needed to store Kindergarten Readiness information.  It also provides examples of Kindergarten Readiness competencies used by some states as well as examples of reports run related to subgroups of children and their readiness for kindergarten.', CedsConnectionName = 'Kindergarten Readiness', CedsConnectionSource = 'SLDS Kindergarten Readiness Workgroup'
			where CedsUseCaseId = 2977
		END
 
		-----------------------------------------
		-- CCD Report | C052: Membership (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2980)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The official unduplicated student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.','CCD Report | C052: Membership (Generate)','CIID',2980)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The official unduplicated student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.', CedsConnectionName = 'CCD Report | C052: Membership (Generate)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2980
		END
 
		-----------------------------------------
		-- CCD Report | C052 Membership (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2982)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The official unduplicated student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.','CCD Report | C052 Membership (Generate)','CIID',2982)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The official unduplicated student enrollment, including students both present and absent, excluding duplicate counts of students within a specific school or local education agency or students whose membership is reported by another school or LEA.', CedsConnectionName = 'CCD Report | C052 Membership (Generate)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2982
		END
 
		-----------------------------------------
		-- CCD Report | FS040: Graduates/Completers (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2983)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS040, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS040: Graduates/Completers (Generate) SY 2017-18','SLDS State Support Team',2983)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS040, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS040: Graduates/Completers (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2983
		END
 
		-----------------------------------------
		-- CCD Report | FS052: Membership (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2984)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS052, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS052: Membership (Generate) SY 2017-18','SLDS State Support Team',2984)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS052, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS052: Membership (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2984
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C032: Dropouts (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2985)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection can be used as a template for new EDFacts reports in Generate.  The categories, data elements, analysis recommends, and related connections should be reviewed and updated to meet the needs of the EDFacts report.','IDEA 618 Report | C032: Dropouts (Generate)','CIID',2985)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection can be used as a template for new EDFacts reports in Generate.  The categories, data elements, analysis recommends, and related connections should be reviewed and updated to meet the needs of the EDFacts report.', CedsConnectionName = 'IDEA 618 Report | C032: Dropouts (Generate)', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2985
		END
 
		-----------------------------------------
		-- CSPR II Report | FS065: Federally Funded Staff (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2986)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS065, created in collaboration with the EDFacts PSC and CIID.','CSPR II Report | FS065: Federally Funded Staff (Generate)','SLDS State Support Team',2986)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS065, created in collaboration with the EDFacts PSC and CIID.', CedsConnectionName = 'CSPR II Report | FS065: Federally Funded Staff (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2986
		END
 
		-----------------------------------------
		-- CSPR II Report | FS122: MEP Students Eligible and Served – Summer/Intersession (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2987)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS122, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS122: MEP Students Eligible and Served – Summer/Intersession (Generate) SY 2017-18','SLDS State Support Team',2987)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS122, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS122: MEP Students Eligible and Served – Summer/Intersession (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2987
		END
 
		-----------------------------------------
		-- CSPR II Report | FS145: MEP Services (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2988)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS145, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS145: MEP Services (Generate) SY 2017-18','SLDS State Support Team',2988)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS145, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS145: MEP Services (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2988
		END
 
		-----------------------------------------
		-- CIID CEDS Demonstration EDFacts C009
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2989)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('CIID CEDS Presentation Demonstration','CIID CEDS Demonstration EDFacts C009','CIID CEDS Demonstration',2989)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'CIID CEDS Presentation Demonstration', CedsConnectionName = 'CIID CEDS Demonstration EDFacts C009', CedsConnectionSource = 'CIID CEDS Demonstration'
			where CedsUseCaseId = 2989
		END
 
		-----------------------------------------
		-- DQR Child Count Year to Year Change
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2991)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Year to Year Change Analysis on Child Count','DQR Child Count Year to Year Change','CIID',2991)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Year to Year Change Analysis on Child Count', CedsConnectionName = 'DQR Child Count Year to Year Change', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2991
		END
 
		-----------------------------------------
		-- DQR Environments Year to Year Change
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2992)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Year to Year Change Analysis on Child Count','DQR Environments Year to Year Change','CIID',2992)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Year to Year Change Analysis on Child Count', CedsConnectionName = 'DQR Environments Year to Year Change', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2992
		END
 
		-----------------------------------------
		-- DQR Exit Year to Year Change
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2993)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Year to Year Change for students age 14-21 who exit special education','DQR Exit Year to Year Change','CIID',2993)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Year to Year Change for students age 14-21 who exit special education', CedsConnectionName = 'DQR Exit Year to Year Change', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2993
		END
 
		-----------------------------------------
		-- DQR Removals Year to Year
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2994)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who are ages 3 through 21 and suspended or expelled for disciplinary reasons.','DQR Removals Year to Year','CIID',2994)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who are ages 3 through 21 and suspended or expelled for disciplinary reasons.', CedsConnectionName = 'DQR Removals Year to Year', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 2994
		END
 
		-----------------------------------------
		-- CCD Report | FS039: Grades Offered (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3003)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS039, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS039: Grades Offered (Generate) SY 2017-18','SLDS State Support Team',3003)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS039, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS039: Grades Offered (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3003
		END
 
		-----------------------------------------
		-- DQR Student Summary
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3004)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Year to Year Change Analysis on Child Count','DQR Student Summary','CIID',3004)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Year to Year Change Analysis on Child Count', CedsConnectionName = 'DQR Student Summary', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3004
		END
 
		-----------------------------------------
		-- CCD Report | All Elements (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3005)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts Files, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | All Elements (Generate)','SLDS State Support Team',3005)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts Files, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | All Elements (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3005
		END
 
		-----------------------------------------
		-- CSPR II Report | All Elements (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3006)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts Files were created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | All Elements (Generate)','SLDS State Support Team',3006)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts Files were created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | All Elements (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3006
		END
 
		-----------------------------------------
		-- Teacher Effectiveness and Experience_
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3015)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The goal of this connection is to understand how teacher effectiveness, as defined as staff evaluation ratings, are related to teachers’ years of experience. We use years of experience in this connection as a measure for teacher quality since research shows that there is a positive relationship between years of experience and teacher effectiveness (as measured by teacher value-added estimates) in the first three to five years of teaching.','Teacher Effectiveness and Experience_','SLDS Community',3015)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The goal of this connection is to understand how teacher effectiveness, as defined as staff evaluation ratings, are related to teachers’ years of experience. We use years of experience in this connection as a measure for teacher quality since research shows that there is a positive relationship between years of experience and teacher effectiveness (as measured by teacher value-added estimates) in the first three to five years of teaching.', CedsConnectionName = 'Teacher Effectiveness and Experience_', CedsConnectionSource = 'SLDS Community'
			where CedsUseCaseId = 3015
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3021)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 6 through 21','IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) SY 2017-18','CIID',3021)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 6 through 21', CedsConnectionName = 'IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3021
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C002: Children with Disabilities (IDEA) School Age (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3022)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 6 through 21','IDEA 618 Report | C002: Children with Disabilities (IDEA) School Age (Generate) SY 2015-16','CIID',3022)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 6 through 21', CedsConnectionName = 'IDEA 618 Report | C002: Children with Disabilities (IDEA) School Age (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3022
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C004: Children with Disabilities (IDEA) Not Participating in Assessments (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3023)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who did not participate in and receive a valid score on the state assessments.','IDEA 618 Report | C004: Children with Disabilities (IDEA) Not Participating in Assessments (Generate) SY 2015-16','CIID',3023)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who did not participate in and receive a valid score on the state assessments.', CedsConnectionName = 'IDEA 618 Report | C004: Children with Disabilities (IDEA) Not Participating in Assessments (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3023
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS004: Children with Disabilities (IDEA) Not Participating in Assessments (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3024)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who did not participate in and receive a valid score on the state assessments.','IDEA 618 Report | FS004: Children with Disabilities (IDEA) Not Participating in Assessments (Generate) SY 2017-18','CIID',3024)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who did not participate in and receive a valid score on the state assessments.', CedsConnectionName = 'IDEA 618 Report | FS004: Children with Disabilities (IDEA) Not Participating in Assessments (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3024
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3025)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who are ages 3 through 21 and  removed to an interim alternative educational setting.','IDEA 618 Report | C005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting (Generate) SY 2015-16','CIID',3025)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who are ages 3 through 21 and  removed to an interim alternative educational setting.', CedsConnectionName = 'IDEA 618 Report | C005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3025
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3026)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who are ages 3 through 21 and removed to an interim alternative educational setting.','IDEA 618 Report | FS005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting (Generate) SY 2017-18','CIID',3026)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who are ages 3 through 21 and removed to an interim alternative educational setting.', CedsConnectionName = 'IDEA 618 Report | FS005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3026
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C006: Children with Disabilities (IDEA) Suspensions/Expulsions (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3027)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who are ages 3 through 21 and suspended or expelled for disciplinary reasons.','IDEA 618 Report | C006: Children with Disabilities (IDEA) Suspensions/Expulsions (Generate) SY 2015-16','CIID',3027)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who are ages 3 through 21 and suspended or expelled for disciplinary reasons.', CedsConnectionName = 'IDEA 618 Report | C006: Children with Disabilities (IDEA) Suspensions/Expulsions (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3027
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS006: Children with Disabilities (IDEA) Suspensions/Expulsions (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3028)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who are ages 3 through 21 and suspended or expelled for disciplinary reasons.','IDEA 618 Report | FS006: Children with Disabilities (IDEA) Suspensions/Expulsions (Generate) SY 2017-18','CIID',3028)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who are ages 3 through 21 and suspended or expelled for disciplinary reasons.', CedsConnectionName = 'IDEA 618 Report | FS006: Children with Disabilities (IDEA) Suspensions/Expulsions (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3028
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C007: Children with Disabilities (IDEA) Reasons for Unilateral Removal (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3029)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of times children with disabilities (IDEA) who are ages 3 through 21 were unilaterally removed by school personnel (not the IEP team) from their current educational placement to an interim alternative educational setting (determined by the IEP team) due to drug or weapon offenses or serious bodily injury.','IDEA 618 Report | C007: Children with Disabilities (IDEA) Reasons for Unilateral Removal (Generate) SY 2015-16','CIID',3029)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of times children with disabilities (IDEA) who are ages 3 through 21 were unilaterally removed by school personnel (not the IEP team) from their current educational placement to an interim alternative educational setting (determined by the IEP team) due to drug or weapon offenses or serious bodily injury.', CedsConnectionName = 'IDEA 618 Report | C007: Children with Disabilities (IDEA) Reasons for Unilateral Removal (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3029
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS007: Children with Disabilities (IDEA) Reasons for Unilateral Removal (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3030)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of times children with disabilities (IDEA) who were ages 3 through 21 and unilaterally removed by school personnel (not the IEP team) from their current educational placement to an interim alternative educational setting (determined by the IEP team) due to drug or weapon offense or serious bodily injury.','IDEA 618 Report | FS007: Children with Disabilities (IDEA) Reasons for Unilateral Removal (Generate) SY 2017-18','CIID',3030)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of times children with disabilities (IDEA) who were ages 3 through 21 and unilaterally removed by school personnel (not the IEP team) from their current educational placement to an interim alternative educational setting (determined by the IEP team) due to drug or weapon offense or serious bodily injury.', CedsConnectionName = 'IDEA 618 Report | FS007: Children with Disabilities (IDEA) Reasons for Unilateral Removal (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3030
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C009: Children with Disabilities (IDEA) Exiting Special Education (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3031)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 14 through 21 and were in special education at the start of the reporting period and were not in special education at the end of the reporting period.','IDEA 618 Report | C009: Children with Disabilities (IDEA) Exiting Special Education (Generate) SY 2015-16','CIID',3031)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 14 through 21 and were in special education at the start of the reporting period and were not in special education at the end of the reporting period.', CedsConnectionName = 'IDEA 618 Report | C009: Children with Disabilities (IDEA) Exiting Special Education (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3031
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS009: Children with Disabilities (IDEA) Exiting Special Education (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3032)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students with disabilities (IDEA) who are ages 14 through 21, were in special education at the start of the reporting period, and were not in special education at the end of the reporting period.','IDEA 618 Report | FS009: Children with Disabilities (IDEA) Exiting Special Education (Generate) SY 2017-18','CIID',3032)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students with disabilities (IDEA) who are ages 14 through 21, were in special education at the start of the reporting period, and were not in special education at the end of the reporting period.', CedsConnectionName = 'IDEA 618 Report | FS009: Children with Disabilities (IDEA) Exiting Special Education (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3032
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C070: Special Education Teachers (FTE) (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3033)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) special education teachers employed or contracted to work with children with disabilities (IDEA) who were ages 3 through 21.','IDEA 618 Report | C070: Special Education Teachers (FTE) (Generate) SY 2015-16','CIID',3033)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) special education teachers employed or contracted to work with children with disabilities (IDEA) who were ages 3 through 21.', CedsConnectionName = 'IDEA 618 Report | C070: Special Education Teachers (FTE) (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3033
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS070: Special Education Teachers (FTE) (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3034)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) special education teachers employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.','IDEA 618 Report | FS070: Special Education Teachers (FTE) (Generate) SY 2017-18','CIID',3034)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) special education teachers employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.', CedsConnectionName = 'IDEA 618 Report | FS070: Special Education Teachers (FTE) (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3034
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C088: Children with Disabilities (IDEA) Disciplinary Removals (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3035)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 3 through 21 who were subject to any kind of disciplinary removal during the school year.','IDEA 618 Report | C088: Children with Disabilities (IDEA) Disciplinary Removals (Generate) SY 2015-16','CIID',3035)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 3 through 21 who were subject to any kind of disciplinary removal during the school year.', CedsConnectionName = 'IDEA 618 Report | C088: Children with Disabilities (IDEA) Disciplinary Removals (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3035
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS088: Children with Disabilities (IDEA) Disciplinary Removals (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3036)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 3 through 21 who were subject to any kind of disciplinary removal during the school year.','IDEA 618 Report | FS088: Children with Disabilities (IDEA) Disciplinary Removals (Generate) SY 2017-18','CIID',3036)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 3 through 21 who were subject to any kind of disciplinary removal during the school year.', CedsConnectionName = 'IDEA 618 Report | FS088: Children with Disabilities (IDEA) Disciplinary Removals (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3036
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C089: Children with Disabilities (IDEA) Early Childhood (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3037)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) ages 3 through 5.','IDEA 618 Report | C089: Children with Disabilities (IDEA) Early Childhood (Generate) SY 2015-16','CIID',3037)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) ages 3 through 5.', CedsConnectionName = 'IDEA 618 Report | C089: Children with Disabilities (IDEA) Early Childhood (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3037
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS089: Children with Disabilities (IDEA) Early Childhood (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3038)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 3 through 5.','IDEA 618 Report | FS089: Children with Disabilities (IDEA) Early Childhood (Generate) SY 2017-18','CIID',3038)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 3 through 5.', CedsConnectionName = 'IDEA 618 Report | FS089: Children with Disabilities (IDEA) Early Childhood (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3038
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C099: Special Education Related Services Personnel (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3039)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) related services personnel employed or contracted to provide related services for children with disabilities (IDEA) who are ages 3 through 21.','IDEA 618 Report | C099: Special Education Related Services Personnel (Generate) SY 2015-16','CIID',3039)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) related services personnel employed or contracted to provide related services for children with disabilities (IDEA) who are ages 3 through 21.', CedsConnectionName = 'IDEA 618 Report | C099: Special Education Related Services Personnel (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3039
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS099: Special Education Related Services Personnel (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3040)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) related services personnel employed or contracted to provide related services for children with disabilities (IDEA) who were ages 3 through 21.','IDEA 618 Report | FS099: Special Education Related Services Personnel (Generate) SY 2017-18','CIID',3040)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) related services personnel employed or contracted to provide related services for children with disabilities (IDEA) who were ages 3 through 21.', CedsConnectionName = 'IDEA 618 Report | FS099: Special Education Related Services Personnel (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3040
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS112: Special Education Paraprofessionals (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3041)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) paraprofessionals employed or contracted to work with children with disabilities (IDEA) who were ages 3 through 21.','IDEA 618 Report | FS112: Special Education Paraprofessionals (Generate) SY 2017-18','CIID',3041)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) paraprofessionals employed or contracted to work with children with disabilities (IDEA) who were ages 3 through 21.', CedsConnectionName = 'IDEA 618 Report | FS112: Special Education Paraprofessionals (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3041
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C112: Special Education Paraprofessionals (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3042)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) paraprofessionals employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.','IDEA 618 Report | C112: Special Education Paraprofessionals (Generate) SY 2015-16','CIID',3042)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) paraprofessionals employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.', CedsConnectionName = 'IDEA 618 Report | C112: Special Education Paraprofessionals (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3042
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C143: Children with Disabilities (IDEA) Total Disciplinary Removals (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3043)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of times children with disabilities (IDEA) who are ages 3 through 21 were subject to any kind of disciplinary removal.','IDEA 618 Report | C143: Children with Disabilities (IDEA) Total Disciplinary Removals (Generate) SY 2015-16','CIID',3043)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of times children with disabilities (IDEA) who are ages 3 through 21 were subject to any kind of disciplinary removal.', CedsConnectionName = 'IDEA 618 Report | C143: Children with Disabilities (IDEA) Total Disciplinary Removals (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3043
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS143: Children with Disabilities (IDEA) Total Disciplinary Removals (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3044)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of times children with disabilities (IDEA) who were ages 3 through 21 were subject to any kind of disciplinary removal.','IDEA 618 Report | FS143: Children with Disabilities (IDEA) Total Disciplinary Removals (Generate) SY 2017-18','CIID',3044)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of times children with disabilities (IDEA) who were ages 3 through 21 were subject to any kind of disciplinary removal.', CedsConnectionName = 'IDEA 618 Report | FS143: Children with Disabilities (IDEA) Total Disciplinary Removals (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3044
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C144: Educational Services During Expulsion (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3045)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children (students) who were removed for disciplinary reasons from their regular school program for the remainder of the school year or longer, including all removals resulting from violations of the Gun-Free Schools Act (GFSA) of 1994.','IDEA 618 Report | C144: Educational Services During Expulsion (Generate) SY 2015-16','CIID',3045)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children (students) who were removed for disciplinary reasons from their regular school program for the remainder of the school year or longer, including all removals resulting from violations of the Gun-Free Schools Act (GFSA) of 1994.', CedsConnectionName = 'IDEA 618 Report | C144: Educational Services During Expulsion (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3045
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS144: Educational Services During Expulsion (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3046)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children (students) who were removed for disciplinary reasons from their regular school program for the remainder of the school year or longer, including all removals resulting from violations of the Gun-Free Schools Act (GFSA) of 1994.','IDEA 618 Report | FS144: Educational Services During Expulsion (Generate) SY 2017-18','CIID',3046)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children (students) who were removed for disciplinary reasons from their regular school program for the remainder of the school year or longer, including all removals resulting from violations of the Gun-Free Schools Act (GFSA) of 1994.', CedsConnectionName = 'IDEA 618 Report | FS144: Educational Services During Expulsion (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3046
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C175: Academic Achievement in Mathematics (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3047)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in mathematics for whom a proficiency level was assigned.','IDEA 618 Report | C175: Academic Achievement in Mathematics (Generate) SY 2015-16','CIID',3047)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in mathematics for whom a proficiency level was assigned.', CedsConnectionName = 'IDEA 618 Report | C175: Academic Achievement in Mathematics (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3047
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS175: Academic Achievement in Mathematics (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3048)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in mathematics for whom a proficiency level was assigned.','IDEA 618 Report | FS175: Academic Achievement in Mathematics (Generate) SY 2017-18','CIID',3048)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in mathematics for whom a proficiency level was assigned.', CedsConnectionName = 'IDEA 618 Report | FS175: Academic Achievement in Mathematics (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3048
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C178: Academic Achievement in Reading (Language Arts) (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3049)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.','IDEA 618 Report | C178: Academic Achievement in Reading (Language Arts) (Generate) SY 2015-16','CIID',3049)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.', CedsConnectionName = 'IDEA 618 Report | C178: Academic Achievement in Reading (Language Arts) (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3049
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS178: Academic Achievement in Reading (Language Arts) (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3050)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.','IDEA 618 Report | FS178: Academic Achievement in Reading (Language Arts) (Generate) SY 2017-18','CIID',3050)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.', CedsConnectionName = 'IDEA 618 Report | FS178: Academic Achievement in Reading (Language Arts) (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3050
		END
 
		-----------------------------------------
		-- IDEA SPP/APR Indicator 10: Disproportionate representation by disability category (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3051)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Percent of districts with disproportionate representation of racial and ethnic groups in specific disability categories that is the result of inappropriate identification.','IDEA SPP/APR Indicator 10: Disproportionate representation by disability category (Generate) SY 2017-18','CIID',3051)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Percent of districts with disproportionate representation of racial and ethnic groups in specific disability categories that is the result of inappropriate identification.', CedsConnectionName = 'IDEA SPP/APR Indicator 10: Disproportionate representation by disability category (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3051
		END
 
		-----------------------------------------
		-- IDEA SPP/APR Indicator 10: Disproportionate representation by disability category (Generate) SY 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3052)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Percent of districts with disproportionate representation of racial and ethnic groups in specific disability categories that is the result of inappropriate identification.','IDEA SPP/APR Indicator 10: Disproportionate representation by disability category (Generate) SY 2016-17','CIID',3052)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Percent of districts with disproportionate representation of racial and ethnic groups in specific disability categories that is the result of inappropriate identification.', CedsConnectionName = 'IDEA SPP/APR Indicator 10: Disproportionate representation by disability category (Generate) SY 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3052
		END
 
		-----------------------------------------
		-- IDEA SPP/APR Indicator 4A: Rates of suspension and expulsion (Generate) 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3053)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Percentage of districts that have a significant discrepancy in the rate of suspensions and expulsions greater than 10 days in a school year for children with IEPs.','IDEA SPP/APR Indicator 4A: Rates of suspension and expulsion (Generate) 2016-17','CIID',3053)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Percentage of districts that have a significant discrepancy in the rate of suspensions and expulsions greater than 10 days in a school year for children with IEPs.', CedsConnectionName = 'IDEA SPP/APR Indicator 4A: Rates of suspension and expulsion (Generate) 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3053
		END
 
		-----------------------------------------
		-- IDEA SPP/APR Indicator 4B: Rates of suspension and expulsion by race/ethnicity (Generate) 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3054)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Percent of districts that have a significant discrepancy in the rate of suspensions and expulsions greater than 10 days in a school year for children with IEPs.','IDEA SPP/APR Indicator 4B: Rates of suspension and expulsion by race/ethnicity (Generate) 2016-17','CIID',3054)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Percent of districts that have a significant discrepancy in the rate of suspensions and expulsions greater than 10 days in a school year for children with IEPs.', CedsConnectionName = 'IDEA SPP/APR Indicator 4B: Rates of suspension and expulsion by race/ethnicity (Generate) 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3054
		END
 
		-----------------------------------------
		-- IDEA SPP/APR Indicator 9: Disproportionate representation (Generate) 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3055)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Percent of districts with disproportionate representation of racial and ethnic groups in special education and related services that is the result of inappropriate identification.','IDEA SPP/APR Indicator 9: Disproportionate representation (Generate) 2016-17','CIID',3055)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Percent of districts with disproportionate representation of racial and ethnic groups in special education and related services that is the result of inappropriate identification.', CedsConnectionName = 'IDEA SPP/APR Indicator 9: Disproportionate representation (Generate) 2016-17', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3055
		END
 
		-----------------------------------------
		-- CEDS Elements for IDEA 618 and SPP/APR data (Iteration I) All Elements (Generate) - BACKUP 1-23-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3056)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The full list of CEDS elements required for Generate, Iteration I','CEDS Elements for IDEA 618 and SPP/APR data (Iteration I) All Elements (Generate) - BACKUP 1-23-18','CIID',3056)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The full list of CEDS elements required for Generate, Iteration I', CedsConnectionName = 'CEDS Elements for IDEA 618 and SPP/APR data (Iteration I) All Elements (Generate) - BACKUP 1-23-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3056
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C185: Assessment Participation in Mathematics (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3058)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in mathematics.','IDEA 618 Report | C185: Assessment Participation in Mathematics (Generate) SY 2015-16','CIID',3058)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in mathematics.', CedsConnectionName = 'IDEA 618 Report | C185: Assessment Participation in Mathematics (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3058
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS185: Assessment Participation in Mathematics (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3059)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in mathematics.','IDEA 618 Report | FS185: Assessment Participation in Mathematics (Generate) SY 2017-18','CIID',3059)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in mathematics.', CedsConnectionName = 'IDEA 618 Report | FS185: Assessment Participation in Mathematics (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3059
		END
 
		-----------------------------------------
		-- IDEA 618 Report | C188: Assessment Participation in Reading/Language Arts (Generate) SY 2015-16
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3060)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.','IDEA 618 Report | C188: Assessment Participation in Reading/Language Arts (Generate) SY 2015-16','CIID',3060)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.', CedsConnectionName = 'IDEA 618 Report | C188: Assessment Participation in Reading/Language Arts (Generate) SY 2015-16', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3060
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS188: Assessment Participation in Reading/Language Arts (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3061)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.','IDEA 618 Report | FS188: Assessment Participation in Reading/Language Arts (Generate) SY 2017-18','CIID',3061)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.', CedsConnectionName = 'IDEA 618 Report | FS188: Assessment Participation in Reading/Language Arts (Generate) SY 2017-18', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3061
		END
 
		-----------------------------------------
		-- C179: Academic Achievement in Science
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3064)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.','C179: Academic Achievement in Science','CIID',3064)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.', CedsConnectionName = 'C179: Academic Achievement in Science', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3064
		END
 
		-----------------------------------------
		-- FS045: Immigrant (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3065)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who meet the definition of immigrant children and youth in Title III of ESEA, as amended.','FS045: Immigrant (Generate) SY 2017-18','SLDS State Support Team',3065)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who meet the definition of immigrant children and youth in Title III of ESEA, as amended.', CedsConnectionName = 'FS045: Immigrant (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3065
		END
 
		-----------------------------------------
		-- FS050: Title III English Language Proficiency Results (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3066)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of English learners who were assessed on the annual state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA, as amended, funds','FS050: Title III English Language Proficiency Results (Generate) SY 2017-18','SLDS State Support Team',3066)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of English learners who were assessed on the annual state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA, as amended, funds', CedsConnectionName = 'FS050: Title III English Language Proficiency Results (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3066
		END
 
		-----------------------------------------
		-- FS138 - Title III English Language Proficiency Test (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3068)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of English learners who were enrolled during the time of the state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA, as amended, funds.','FS138 - Title III English Language Proficiency Test (Generate) SY 2017-18','SLDS State Support Team',3068)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of English learners who were enrolled during the time of the state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA, as amended, funds.', CedsConnectionName = 'FS138 - Title III English Language Proficiency Test (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3068
		END
 
		-----------------------------------------
		-- FS116 — Title III Students Served (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3069)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of English learners served by an English language instruction educational program supported with Title III of ESEA, as amended, funds.','FS116 — Title III Students Served (Generate) 2017-18','SLDS State Support Team',3069)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of English learners served by an English language instruction educational program supported with Title III of ESEA, as amended, funds.', CedsConnectionName = 'FS116 — Title III Students Served (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3069
		END
 
		-----------------------------------------
		-- FS126 — Title III Former EL Students (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3070)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of former English learners who are meeting and not meeting the challenging State academic standards as measured by proficiency for each of the four years after such children are no longer receiving services under Title III of ESEA, as amended.','FS126 — Title III Former EL Students (Generate) SY 2017-18','SLDS State Support Team',3070)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of former English learners who are meeting and not meeting the challenging State academic standards as measured by proficiency for each of the four years after such children are no longer receiving services under Title III of ESEA, as amended.', CedsConnectionName = 'FS126 — Title III Former EL Students (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3070
		END
 
		-----------------------------------------
		-- FS204 — Title III English Learners (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3071)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Title III English learners not proficient within five years and Title III English learners exited.','FS204 — Title III English Learners (Generate) 2017-18','SLDS State Support Team',3071)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Title III English learners not proficient within five years and Title III English learners exited.', CedsConnectionName = 'FS204 — Title III English Learners (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3071
		END
 
		-----------------------------------------
		-- FS137– English Language Proficiency Test (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3073)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of English learners who were enrolled at the time of the state annual English language proficiency assessment.','FS137– English Language Proficiency Test (Generate) SY 2017-18','SLDS State Support Team',3073)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of English learners who were enrolled at the time of the state annual English language proficiency assessment.', CedsConnectionName = 'FS137– English Language Proficiency Test (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3073
		END
 
		-----------------------------------------
		-- FS139 — English Language Proficiency Results (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3075)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of English learners who took the annual state English language proficiency assessment.','FS139 — English Language Proficiency Results (Generate) SY 2017-18','SLDS State Support Team',3075)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of English learners who took the annual state English language proficiency assessment.', CedsConnectionName = 'FS139 — English Language Proficiency Results (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3075
		END
 
		-----------------------------------------
		-- FS205 — Progress Achieving English Language Proficiency Indicator Status (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3076)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A school’s performance on the progress in achieving English Language proficiency indicator.','FS205 — Progress Achieving English Language Proficiency Indicator Status (Generate) SY 2017-18','SLDS State Support Team',3076)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A school’s performance on the progress in achieving English Language proficiency indicator.', CedsConnectionName = 'FS205 — Progress Achieving English Language Proficiency Indicator Status (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3076
		END
 
		-----------------------------------------
		-- FS190 — Charter Authorizer Directory (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3077)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The data collected using this file specification are required to ensure completeness of data on charter schools and authorizers','FS190 — Charter Authorizer Directory (Generate) SY 2017-18','SLDS State Support Team',3077)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The data collected using this file specification are required to ensure completeness of data on charter schools and authorizers', CedsConnectionName = 'FS190 — Charter Authorizer Directory (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3077
		END
 
		-----------------------------------------
		-- FS198 — Charter Contracts (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3078)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The data collected using this file specification are to enable OII/CSP to obtain a complete list of charter schools in the United States. OII/CSP goes through a complex reconciliation process to compile a directory of all charter schools that are in operation across the nation. These data will fill in the data gaps so that for each school year OII/CSP has a complete and accurate directory of charter schools.','FS198 — Charter Contracts (Generate) 2017-18','SLDS State Support Team',3078)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The data collected using this file specification are to enable OII/CSP to obtain a complete list of charter schools in the United States. OII/CSP goes through a complex reconciliation process to compile a directory of all charter schools that are in operation across the nation. These data will fill in the data gaps so that for each school year OII/CSP has a complete and accurate directory of charter schools.', CedsConnectionName = 'FS198 — Charter Contracts (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3078
		END
 
		-----------------------------------------
		-- Generate Report - Achievement Gap
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3079)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This report provides data on the differences in achievement scores for math and language arts between students with and without disabilities, by grade, by exceptionality label/disability label, and by relevant student subgroups. (Achievement gap).','Generate Report - Achievement Gap','CIID',3079)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This report provides data on the differences in achievement scores for math and language arts between students with and without disabilities, by grade, by exceptionality label/disability label, and by relevant student subgroups. (Achievement gap).', CedsConnectionName = 'Generate Report - Achievement Gap', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3079
		END
 
		-----------------------------------------
		-- Generate Report - Transition Matrix
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3080)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This report provides data on the changes in proficiency levels from one year or one test administration to the next in math and language arts for students with and without disabilities, by grade, by disability status and type, and by relevant student subgroups. (Transition Matrix).','Generate Report - Transition Matrix','CIID',3080)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This report provides data on the changes in proficiency levels from one year or one test administration to the next in math and language arts for students with and without disabilities, by grade, by disability status and type, and by relevant student subgroups. (Transition Matrix).', CedsConnectionName = 'Generate Report - Transition Matrix', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3080
		END
 
		-----------------------------------------
		-- FS196 — Management Organizations Directory (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3081)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('In this file, states submit the list of organizations that manage one or more charter school in the state.','FS196 — Management Organizations Directory (Generate) SY 2017-18','SLDS State Support Team',3081)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'In this file, states submit the list of organizations that manage one or more charter school in the state.', CedsConnectionName = 'FS196 — Management Organizations Directory (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3081
		END
 
		-----------------------------------------
		-- FS197 — Crosswalk of Charter Schools to Management Organizations (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3082)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The data collected using this file specification are gathered to provide the Charter School Program Office of the U.S. Department of Education insight into the extent and scope of the relationships between CMOs and EMOs with charter schools.','FS197 — Crosswalk of Charter Schools to Management Organizations (Generate) 2017-18','SLDS State Support Team',3082)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The data collected using this file specification are gathered to provide the Charter School Program Office of the U.S. Department of Education insight into the extent and scope of the relationships between CMOs and EMOs with charter schools.', CedsConnectionName = 'FS197 — Crosswalk of Charter Schools to Management Organizations (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3082
		END
 
		-----------------------------------------
		-- FS082 - CTE Concentrators Exiting (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3098)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who left secondary education.','FS082 - CTE Concentrators Exiting (Generate) SY 2017-18','SLDS State Support Team',3098)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who left secondary education.', CedsConnectionName = 'FS082 - CTE Concentrators Exiting (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3098
		END
 
		-----------------------------------------
		-- FS083 — CTE Concentrator Graduates (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3099)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who left secondary education and who received a high school diploma or its recognized equivalent.','FS083 — CTE Concentrator Graduates (Generate) SY 2017-18','SLDS State Support Team',3099)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who left secondary education and who received a high school diploma or its recognized equivalent.', CedsConnectionName = 'FS083 — CTE Concentrator Graduates (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3099
		END
 
		-----------------------------------------
		-- FS142 — CTE Concentrators Academic Achievement (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3100)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of CTE concentrators who left secondary education during the school year for whom a proficiency score on the state assessment was included in the state’s calculation of adequate yearly progress (AYP).','FS142 — CTE Concentrators Academic Achievement (Generate) SY 2017-18','SLDS State Support Team',3100)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of CTE concentrators who left secondary education during the school year for whom a proficiency score on the state assessment was included in the state’s calculation of adequate yearly progress (AYP).', CedsConnectionName = 'FS142 — CTE Concentrators Academic Achievement (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3100
		END
 
		-----------------------------------------
		-- FS154 — CTE Concentrators in Graduation Rate (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3101)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who were included in the state’s computation of its graduation rate as described in section 1111 (b)(2)(C)(vi) of the ESEA, as amended.','FS154 — CTE Concentrators in Graduation Rate (Generate) SY 2017-18','SLDS State Support Team',3101)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who were included in the state’s computation of its graduation rate as described in section 1111 (b)(2)(C)(vi) of the ESEA, as amended.', CedsConnectionName = 'FS154 — CTE Concentrators in Graduation Rate (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3101
		END
 
		-----------------------------------------
		-- FS155 – CTE Participants in Programs for Non-traditional (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3102)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE participants who participated in a program that leads to employment in non-traditional fields.','FS155 – CTE Participants in Programs for Non-traditional (Generate) SY 2017-18','SLDS State Support Team',3102)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE participants who participated in a program that leads to employment in non-traditional fields.', CedsConnectionName = 'FS155 – CTE Participants in Programs for Non-traditional (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3102
		END
 
		-----------------------------------------
		-- FS156 — CTE Concentrators in Programs for Non-traditional (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3103)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection can be used as a template for new EDFacts reports in Generate.  The categories, data elements, analysis recommends, and related connections should be reviewed and updated to meet the needs of the EDFacts report.','FS156 — CTE Concentrators in Programs for Non-traditional (Generate) SY 2017-18','SLDS State Support Team',3103)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection can be used as a template for new EDFacts reports in Generate.  The categories, data elements, analysis recommends, and related connections should be reviewed and updated to meet the needs of the EDFacts report.', CedsConnectionName = 'FS156 — CTE Concentrators in Programs for Non-traditional (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3103
		END
 
		-----------------------------------------
		-- FS179 - Academic Achievement in Science (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3104)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in science and for whom a proficiency level was assigned.','FS179 - Academic Achievement in Science (Generate) SY 2017-18','SLDS State Support Team',3104)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in science and for whom a proficiency level was assigned.', CedsConnectionName = 'FS179 - Academic Achievement in Science (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3104
		END
 
		-----------------------------------------
		-- FS156 – CTE Concentrators in Programs for Non-traditional Fields (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3106)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who completed a program that leads to employment in non-traditional fields.','FS156 – CTE Concentrators in Programs for Non-traditional Fields (Generate) SY 2017-18','SLDS State Support Team',3106)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who completed a program that leads to employment in non-traditional fields.', CedsConnectionName = 'FS156 – CTE Concentrators in Programs for Non-traditional Fields (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3106
		END
 
		-----------------------------------------
		-- FS157 — CTE Concentrators Technical Skills (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3107)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who took technical skill assessments that are aligned with industry-recognized standards.','FS157 — CTE Concentrators Technical Skills (Generate) SY 2017-18','SLDS State Support Team',3107)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who took technical skill assessments that are aligned with industry-recognized standards.', CedsConnectionName = 'FS157 — CTE Concentrators Technical Skills (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3107
		END
 
		-----------------------------------------
		-- FS158 — CTE Concentrators Placement (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3108)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who left secondary education in the cohort which graduated the prior program year.','FS158 — CTE Concentrators Placement (Generate) 2017-18','SLDS State Support Team',3108)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who left secondary education in the cohort which graduated the prior program year.', CedsConnectionName = 'FS158 — CTE Concentrators Placement (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3108
		END
 
		-----------------------------------------
		-- FS189 – Assessment Participation in Science (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3109)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in science.','FS189 – Assessment Participation in Science (Generate) SY 2017-18','SLDS State Support Team',3109)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in science.', CedsConnectionName = 'FS189 – Assessment Participation in Science (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3109
		END
 
		-----------------------------------------
		-- Does the type of licensure impact teacher quality, retention, salary, or length of career?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3110)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection explores which licenses or endorsement lead to greater retention, teacher quality, higher salary and longer teaching careers.','Does the type of licensure impact teacher quality, retention, salary, or length of career?','SLDS Workgroup on Teacher Labor Market Analysis',3110)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection explores which licenses or endorsement lead to greater retention, teacher quality, higher salary and longer teaching careers.', CedsConnectionName = 'Does the type of licensure impact teacher quality, retention, salary, or length of career?', CedsConnectionSource = 'SLDS Workgroup on Teacher Labor Market Analysis'
			where CedsUseCaseId = 3110
		END
 
		-----------------------------------------
		-- What are the placement patterns and demographic implications of new teachers, based on the location of the assigned school and the distance from the teacher prep program and the teacher''s permanent address while in postsecondary?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3111)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection will explore the placement patterns of new teachers.  In particular, the analysis will explore if teachers are placed near their teacher prep program or if placement is seemingly random.','What are the placement patterns and demographic implications of new teachers, based on the location of the assigned school and the distance from the teacher prep program and the teacher''s permanent address while in postsecondary?','SLDS Workgroup on Teacher Labor Market Analysis',3111)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection will explore the placement patterns of new teachers.  In particular, the analysis will explore if teachers are placed near their teacher prep program or if placement is seemingly random.', CedsConnectionName = 'What are the placement patterns and demographic implications of new teachers, based on the location of the assigned school and the distance from the teacher prep program and the teacher''s permanent address while in postsecondary?', CedsConnectionSource = 'SLDS Workgroup on Teacher Labor Market Analysis'
			where CedsUseCaseId = 3111
		END
 
		-----------------------------------------
		-- Are new teachers exiting teacher prep programs with endorsements that meet the need of critical shortage areas?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3112)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection will explore whether the new teachers with endorsements meet the need of the critical shortage areas within the state.','Are new teachers exiting teacher prep programs with endorsements that meet the need of critical shortage areas?','SLDS Workgroup on Teacher Labor Market Analysis',3112)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection will explore whether the new teachers with endorsements meet the need of the critical shortage areas within the state.', CedsConnectionName = 'Are new teachers exiting teacher prep programs with endorsements that meet the need of critical shortage areas?', CedsConnectionSource = 'SLDS Workgroup on Teacher Labor Market Analysis'
			where CedsUseCaseId = 3112
		END
 
		-----------------------------------------
		-- Participation of Students in Federal Programs (Generate - State Designed Report)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3114)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Students Participating in Multiple Federal Programs','Participation of Students in Federal Programs (Generate - State Designed Report)','Center for the Integration of IDEA Data (CIID)',3114)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Students Participating in Multiple Federal Programs', CedsConnectionName = 'Participation of Students in Federal Programs (Generate - State Designed Report)', CedsConnectionSource = 'Center for the Integration of IDEA Data (CIID)'
			where CedsUseCaseId = 3114
		END
 
		-----------------------------------------
		-- School Age Child Count by Environments (Generate - State Designed Reports)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3115)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Year to Year Change Analysis on Child Count','School Age Child Count by Environments (Generate - State Designed Reports)','Center for the Integration of IDEA Data (CIID)',3115)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Year to Year Change Analysis on Child Count', CedsConnectionName = 'School Age Child Count by Environments (Generate - State Designed Reports)', CedsConnectionSource = 'Center for the Integration of IDEA Data (CIID)'
			where CedsUseCaseId = 3115
		END
 
		-----------------------------------------
		-- Early Childhood Child Count by Environments (Generate - State Designed Reports)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3116)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Early childhood child count by environments','Early Childhood Child Count by Environments (Generate - State Designed Reports)','Center for the Integration of IDEA Data (CIID)',3116)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Early childhood child count by environments', CedsConnectionName = 'Early Childhood Child Count by Environments (Generate - State Designed Reports)', CedsConnectionSource = 'Center for the Integration of IDEA Data (CIID)'
			where CedsUseCaseId = 3116
		END
 
		-----------------------------------------
		-- FS158 – CTE Concentrators Placement File Specifications (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3117)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who left secondary education in the cohort which graduated the prior program year.','FS158 – CTE Concentrators Placement File Specifications (Generate) 2017-18','SLDS State Support Team',3117)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who left secondary education in the cohort which graduated the prior program year.', CedsConnectionName = 'FS158 – CTE Concentrators Placement File Specifications (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3117
		END
 
		-----------------------------------------
		-- FS169 – CTE Type of Placement (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3118)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of CTE concentrators who left secondary education in the cohort which graduated the prior program year and were placed.','FS169 – CTE Type of Placement (Generate) SY 2017-18','SLDS State Support Team',3118)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of CTE concentrators who left secondary education in the cohort which graduated the prior program year and were placed.', CedsConnectionName = 'FS169 – CTE Type of Placement (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3118
		END
 
		-----------------------------------------
		-- FS130 – ESEA Status (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3123)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The classification of the improvement stage of the school; and an indication of whether the school is identified as persistently dangerous in accordance with state definition.','FS130 – ESEA Status (Generate) SY 2017-18','SLDS State Support Team',3123)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The classification of the improvement stage of the school; and an indication of whether the school is identified as persistently dangerous in accordance with state definition.', CedsConnectionName = 'FS130 – ESEA Status (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3123
		END
 
		-----------------------------------------
		-- FS103 — Accountability (Generate) 2017-18 (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3126)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The classification of a school’s poverty quartile for purposes of determining the number of inexperienced, emergency/provisional credentialed, and out-of-field teachers in high and low poverty schools, according to state’s indicator of poverty.','FS103 — Accountability (Generate) 2017-18 (Generate) 2017-18','SLDS State Support Team',3126)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The classification of a school’s poverty quartile for purposes of determining the number of inexperienced, emergency/provisional credentialed, and out-of-field teachers in high and low poverty schools, according to state’s indicator of poverty.', CedsConnectionName = 'FS103 — Accountability (Generate) 2017-18 (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3126
		END
 
		-----------------------------------------
		-- FS118 — Homeless Students Enrolled (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3127)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection can be used as a template for new EDFacts reports in Generate.  The categories, data elements, analysis recommends, and related connections should be reviewed and updated to meet the needs of the EDFacts report.','FS118 — Homeless Students Enrolled (Generate) SY 2017-18','SLDS State Support Team',3127)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection can be used as a template for new EDFacts reports in Generate.  The categories, data elements, analysis recommends, and related connections should be reviewed and updated to meet the needs of the EDFacts report.', CedsConnectionName = 'FS118 — Homeless Students Enrolled (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3127
		END
 
		-----------------------------------------
		-- FS132 — Section 1003 Funds (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3128)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The data collected using this file specification are used to monitor and report performance on programs and activities supported by the Elementary and Secondary Education Act (ESEA), as amended.  Data group 794 will be used to populate the Consolidated State Performance Report (CSPR).','FS132 — Section 1003 Funds (Generate) SY 2017-18','SLDS State Support Team',3128)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The data collected using this file specification are used to monitor and report performance on programs and activities supported by the Elementary and Secondary Education Act (ESEA), as amended.  Data group 794 will be used to populate the Consolidated State Performance Report (CSPR).', CedsConnectionName = 'FS132 — Section 1003 Funds (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3128
		END
 
		-----------------------------------------
		-- FS170 — LEA Subgrant Status (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3129)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the LEA received a McKinney-Vento subgrant.','FS170 — LEA Subgrant Status (Generate) SY 2017-18','SLDS State Support Team',3129)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the LEA received a McKinney-Vento subgrant.', CedsConnectionName = 'FS170 — LEA Subgrant Status (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3129
		END
 
		-----------------------------------------
		-- FS195 — Chronic Absenteeism (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3130)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students absent 10% or more school days during the school year','FS195 — Chronic Absenteeism (Generate) SY 2017-18','SLDS State Support Team',3130)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students absent 10% or more school days during the school year', CedsConnectionName = 'FS195 — Chronic Absenteeism (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3130
		END
 
		-----------------------------------------
		-- FS194 — Young Homeless Children Served (McKinney-Vento) (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3131)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of homeless children who are birth through age 5 (not Kindergarten) and received services under program subgrants funded by Subtitle VII-B of the McKinney-Vento Homeless Assistance Act (2015).','FS194 — Young Homeless Children Served (McKinney-Vento) (Generate) SY 2017-18','SLDS State Support Team',3131)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of homeless children who are birth through age 5 (not Kindergarten) and received services under program subgrants funded by Subtitle VII-B of the McKinney-Vento Homeless Assistance Act (2015).', CedsConnectionName = 'FS194 — Young Homeless Children Served (McKinney-Vento) (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3131
		END
 
		-----------------------------------------
		-- FS086 — Students Involved with Firearms (Generate) SY2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3132)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were involved in an incident involving a firearm.','FS086 — Students Involved with Firearms (Generate) SY2017-18','SLDS State Support Team',3132)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were involved in an incident involving a firearm.', CedsConnectionName = 'FS086 — Students Involved with Firearms (Generate) SY2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3132
		END
 
		-----------------------------------------
		-- FS131 — LEA End of School Year Status (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3133)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication that the local educational agency (LEA) notified the state of the LEA''s intention to use REAP-Flex Alternative Uses of Funding Authority during the school year as specified in the Title V, Section 5211 of ESEA, as amended.','FS131 — LEA End of School Year Status (Generate) SY 2017-18','SLDS State Support Team',3133)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication that the local educational agency (LEA) notified the state of the LEA''s intention to use REAP-Flex Alternative Uses of Funding Authority during the school year as specified in the Title V, Section 5211 of ESEA, as amended.', CedsConnectionName = 'FS131 — LEA End of School Year Status (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3133
		END
 
		-----------------------------------------
		-- FS163 — Discipline Data (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3134)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or local education agency (LEA) submitted a Gun-Free Schools Act (GFSA) of 1994 report to the state, as defined by Title 18, Section 921.','FS163 — Discipline Data (Generate) SY 2017-18','SLDS State Support Team',3134)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or local education agency (LEA) submitted a Gun-Free Schools Act (GFSA) of 1994 report to the state, as defined by Title 18, Section 921.', CedsConnectionName = 'FS163 — Discipline Data (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3134
		END
 
		-----------------------------------------
		-- What percentage of postsecondary or program completers are employed in the state ?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3135)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection is about determining the percentage of postsecondary or program completers who are employed in the state.  This is useful for program evaluations that relate to workforce or economic development issues.  Note that high school students are not included in this question.','What percentage of postsecondary or program completers are employed in the state ?','SLDS Employment Outcomes Indicator Workgroup',3135)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection is about determining the percentage of postsecondary or program completers who are employed in the state.  This is useful for program evaluations that relate to workforce or economic development issues.  Note that high school students are not included in this question.', CedsConnectionName = 'What percentage of postsecondary or program completers are employed in the state ?', CedsConnectionSource = 'SLDS Employment Outcomes Indicator Workgroup'
			where CedsUseCaseId = 3135
		END
 
		-----------------------------------------
		-- What percentage of postsecondary or program completers are employed in the state?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3136)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection is about determining the percentage of postsecondary or program completers who are employed in the state.  This is useful for program evaluations that relate to workforce or economic development issues.  Note that high school students are not included in this question.','What percentage of postsecondary or program completers are employed in the state?','SLDS Employment Outcomes Indicator Workgroup',3136)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection is about determining the percentage of postsecondary or program completers who are employed in the state.  This is useful for program evaluations that relate to workforce or economic development issues.  Note that high school students are not included in this question.', CedsConnectionName = 'What percentage of postsecondary or program completers are employed in the state?', CedsConnectionSource = 'SLDS Employment Outcomes Indicator Workgroup'
			where CedsUseCaseId = 3136
		END
 
		-----------------------------------------
		-- FS150 — Adjusted-Cohort Graduation Rate (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3140)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Cohorts for four-year, five-year, and six-year adjusted-cohort graduation rate table.','FS150 — Adjusted-Cohort Graduation Rate (Generate) SY 2017-18','SLDS State Support Team',3140)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Cohorts for four-year, five-year, and six-year adjusted-cohort graduation rate table.', CedsConnectionName = 'FS150 — Adjusted-Cohort Graduation Rate (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3140
		END
 
		-----------------------------------------
		-- FS160 — High School Graduates Postsecondary Enrollment (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3141)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students who graduated the previous academic year who enrolled or did not enroll in an institution of higher education (IHE) during the academic year immediately following the previous academic year.','FS160 — High School Graduates Postsecondary Enrollment (Generate) SY 2017-18','SLDS State Support Team',3141)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students who graduated the previous academic year who enrolled or did not enroll in an institution of higher education (IHE) during the academic year immediately following the previous academic year.', CedsConnectionName = 'FS160 — High School Graduates Postsecondary Enrollment (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3141
		END
 
		-----------------------------------------
		-- FS199 — Graduation Rate Indicator Status (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3142)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A school’s performance on the Graduation Rate Indicator.','FS199 — Graduation Rate Indicator Status (Generate) SY 2017-18','SLDS State Support Team',3142)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A school’s performance on the Graduation Rate Indicator.', CedsConnectionName = 'FS199 — Graduation Rate Indicator Status (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3142
		END
 
		-----------------------------------------
		-- FS151 — Cohorts for Adjusted-Cohort Graduation Rate (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3146)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Cohorts for four-year, five-year, and six-year adjusted-cohort graduation rate table.','FS151 — Cohorts for Adjusted-Cohort Graduation Rate (Generate) SY 2017-18','SLDS State Support Team',3146)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Cohorts for four-year, five-year, and six-year adjusted-cohort graduation rate table.', CedsConnectionName = 'FS151 — Cohorts for Adjusted-Cohort Graduation Rate (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3146
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Group SY 19-20: Magnet Curriculum
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3155)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether a magnet school offers a special curriculum capable of attracting substantial numbers of students of different racial backgrounds.','Proposed EDFacts Data Group SY 19-20: Magnet Curriculum','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3155)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether a magnet school offers a special curriculum capable of attracting substantial numbers of students of different racial backgrounds.', CedsConnectionName = 'Proposed EDFacts Data Group SY 19-20: Magnet Curriculum', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3155
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Groups SY 19-20: Charter School Data Groups
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3156)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('New data groups being proposed to describe charter schools.','Proposed EDFacts Data Groups SY 19-20: Charter School Data Groups','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3156)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'New data groups being proposed to describe charter schools.', CedsConnectionName = 'Proposed EDFacts Data Groups SY 19-20: Charter School Data Groups', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3156
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Group SY 19-20: Regulatory extended year adjusted-cohort graduation rate table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3157)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students who graduate (1) in a certain number of years or less with a regular high school diploma awarded to a preponderance of students in the state or (2) a State-defined alternate high school diploma for students with the most significant cognitive disabilities divided by the number of students who form the adjusted-cohort for the regulatory adjusted-cohort graduation rate.','Proposed EDFacts Data Group SY 19-20: Regulatory extended year adjusted-cohort graduation rate table','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3157)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students who graduate (1) in a certain number of years or less with a regular high school diploma awarded to a preponderance of students in the state or (2) a State-defined alternate high school diploma for students with the most significant cognitive disabilities divided by the number of students who form the adjusted-cohort for the regulatory adjusted-cohort graduation rate.', CedsConnectionName = 'Proposed EDFacts Data Group SY 19-20: Regulatory extended year adjusted-cohort graduation rate table', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3157
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Group SY 19-20: Cohorts for the extended year adjusted-cohort graduation rate table
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3158)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students in the adjusted-cohort for the regulatory adjusted-cohort graduation rate who did or did not graduate (1) in a certain number of years or less with a regular high school diploma awarded to a preponderance of students or (2) a State-defined alternate high school diploma for students with the most significant cognitive disabilities.','Proposed EDFacts Data Group SY 19-20: Cohorts for the extended year adjusted-cohort graduation rate table','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3158)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students in the adjusted-cohort for the regulatory adjusted-cohort graduation rate who did or did not graduate (1) in a certain number of years or less with a regular high school diploma awarded to a preponderance of students or (2) a State-defined alternate high school diploma for students with the most significant cognitive disabilities.', CedsConnectionName = 'Proposed EDFacts Data Group SY 19-20: Cohorts for the extended year adjusted-cohort graduation rate table', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3158
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Group SY 19-20: Pathways to Completion
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3159)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students in the cohort.','Proposed EDFacts Data Group SY 19-20: Pathways to Completion','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3159)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students in the cohort.', CedsConnectionName = 'Proposed EDFacts Data Group SY 19-20: Pathways to Completion', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3159
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Group SY 19-20: Title III students served table in English language instruction program
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3160)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of English learners served by an English language instruction educational program supported with Title III of ESEA, as amended, funds.','Proposed EDFacts Data Group SY 19-20: Title III students served table in English language instruction program','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3160)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of English learners served by an English language instruction educational program supported with Title III of ESEA, as amended, funds.', CedsConnectionName = 'Proposed EDFacts Data Group SY 19-20: Title III students served table in English language instruction program', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3160
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Category SY 19-20: Grade Span (Special Education Staff)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3161)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The grade span the staff member serves. (Data Groups 486 and 674)','Proposed EDFacts Data Category SY 19-20: Grade Span (Special Education Staff)','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3161)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The grade span the staff member serves. (Data Groups 486 and 674)', CedsConnectionName = 'Proposed EDFacts Data Category SY 19-20: Grade Span (Special Education Staff)', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3161
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Group SY 19-20: CTE Enrollment
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3162)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The Perkins V enrollment form.','Proposed EDFacts Data Group SY 19-20: CTE Enrollment','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3162)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The Perkins V enrollment form.', CedsConnectionName = 'Proposed EDFacts Data Group SY 19-20: CTE Enrollment', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3162
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3163)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Perkins V Performance Data Report','Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3163)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Perkins V Performance Data Report', CedsConnectionName = 'Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3163
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3164)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Perkins V Performance Data Report','Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3164)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Perkins V Performance Data Report', CedsConnectionName = 'Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3164
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3165)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Perkins V Performance Data Report','Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3165)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Perkins V Performance Data Report', CedsConnectionName = 'Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3165
		END
 
		-----------------------------------------
		-- AH_Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3166)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Perkins V Performance Data Report','AH_Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3166)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Perkins V Performance Data Report', CedsConnectionName = 'AH_Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3166
		END
 
		-----------------------------------------
		-- TEST for Beth 6
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3167)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Perkins V Performance Data Report','TEST for Beth 6','EDFacts Data Collection Package SY 2019-20 through 2021-22',3167)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Perkins V Performance Data Report', CedsConnectionName = 'TEST for Beth 6', CedsConnectionSource = 'EDFacts Data Collection Package SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3167
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Group SY 2020-2021: Perkins V Secondary Concentrator Performance Data Groups
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3168)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Perkins V Performance Data Report','Proposed EDFacts Data Group SY 2020-2021: Perkins V Secondary Concentrator Performance Data Groups','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3168)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Perkins V Performance Data Report', CedsConnectionName = 'Proposed EDFacts Data Group SY 2020-2021: Perkins V Secondary Concentrator Performance Data Groups', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3168
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3169)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Perkins V Performance Data Report','Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3169)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Perkins V Performance Data Report', CedsConnectionName = 'Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3169
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups TEST
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3170)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Perkins V Performance Data Report','Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups TEST','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3170)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Perkins V Performance Data Report', CedsConnectionName = 'Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups TEST', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3170
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3171)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Perkins V Performance Data Report','Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3171)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Perkins V Performance Data Report', CedsConnectionName = 'Proposed EDFacts Data Group SY 20-21: Perkins V Secondary Concentrator Performance Data Groups', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3171
		END
 
		-----------------------------------------
		-- FS113 — N or D Academic Achievement - State Agency (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3172)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students served by Title I, Part D, Subpart 1 of ESEA, as amended, for at least 90 consecutive days during the reporting period who took both a pre- and post-test.','FS113 — N or D Academic Achievement - State Agency (Generate) 2017-18','SLDS State Support Team',3172)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students served by Title I, Part D, Subpart 1 of ESEA, as amended, for at least 90 consecutive days during the reporting period who took both a pre- and post-test.', CedsConnectionName = 'FS113 — N or D Academic Achievement - State Agency (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3172
		END
 
		-----------------------------------------
		-- FS119 — N or D Participation - State Agency (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3173)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency) of ESEA as amended.','FS119 — N or D Participation - State Agency (Generate) 2017-18','SLDS State Support Team',3173)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency) of ESEA as amended.', CedsConnectionName = 'FS119 — N or D Participation - State Agency (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3173
		END
 
		-----------------------------------------
		-- FS125 — N or D Academic Achievement - LEA (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3174)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students served by Title I, Part D, Subpart 2 of ESEA, as amended, for at least 90 consecutive days during the reporting period who took both a pre- and post-test.','FS125 — N or D Academic Achievement - LEA (Generate) 2017-18','SLDS State Support Team',3174)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students served by Title I, Part D, Subpart 2 of ESEA, as amended, for at least 90 consecutive days during the reporting period who took both a pre- and post-test.', CedsConnectionName = 'FS125 — N or D Academic Achievement - LEA (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3174
		END
 
		-----------------------------------------
		-- FS127 — N or D Participation – LEA (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3175)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected, delinquent, or at-risk students (N or D) under Title I, Part D, Subpart 2 (LEA) of ESEA as amended.','FS127 — N or D Participation – LEA (Generate) SY 2017-18','SLDS State Support Team',3175)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected, delinquent, or at-risk students (N or D) under Title I, Part D, Subpart 2 (LEA) of ESEA as amended.', CedsConnectionName = 'FS127 — N or D Participation – LEA (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3175
		END
 
		-----------------------------------------
		-- FS180 — N or D In Program Outcomes (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3176)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency and LEA) of ESEA, as amended, who attained academic and career and technical outcomes while enrolled in the programs.','FS180 — N or D In Program Outcomes (Generate) 2017-18','SLDS State Support Team',3176)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency and LEA) of ESEA, as amended, who attained academic and career and technical outcomes while enrolled in the programs.', CedsConnectionName = 'FS180 — N or D In Program Outcomes (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3176
		END
 
		-----------------------------------------
		-- FS181 — N or D Exited Program Outcomes (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3177)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency and LEA) of ESEA, as amended, who attained academic and career and technical outcomes while enrolled in the programs.','FS181 — N or D Exited Program Outcomes (Generate) 2017-18','SLDS State Support Team',3177)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency and LEA) of ESEA, as amended, who attained academic and career and technical outcomes while enrolled in the programs.', CedsConnectionName = 'FS181 — N or D Exited Program Outcomes (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3177
		END
 
		-----------------------------------------
		-- Proposed EDFacts Data Group SY 20-21: Postsecondary CTE
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3178)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Performance measures for CTE concentrators in postsecondary','Proposed EDFacts Data Group SY 20-21: Postsecondary CTE','EDFacts Data Collection Package: SY 2019-20 through 2021-22',3178)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Performance measures for CTE concentrators in postsecondary', CedsConnectionName = 'Proposed EDFacts Data Group SY 20-21: Postsecondary CTE', CedsConnectionSource = 'EDFacts Data Collection Package: SY 2019-20 through 2021-22'
			where CedsUseCaseId = 3178
		END
 
		-----------------------------------------
		-- FS200 — Academic Achievement Indicator Status (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3181)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A school''s performance on the Academic Achievement Indicator for both Mathematics and Reading/Language Arts','FS200 — Academic Achievement Indicator Status (Generate) 2017-18','SLDS State Support Team',3181)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A school''s performance on the Academic Achievement Indicator for both Mathematics and Reading/Language Arts', CedsConnectionName = 'FS200 — Academic Achievement Indicator Status (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3181
		END
 
		-----------------------------------------
		-- FS201 — Other Academic Indicator Status (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3182)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A school’s performance on the Other Academic Indicator.','FS201 — Other Academic Indicator Status (Generate) SY 2017-18','SLDS State Support Team',3182)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A school’s performance on the Other Academic Indicator.', CedsConnectionName = 'FS201 — Other Academic Indicator Status (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3182
		END
 
		-----------------------------------------
		-- FS202 — School Quality or Student Success Indicator Status (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3183)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A school''s performance on the state-specific indicators of school quality or student success.','FS202 — School Quality or Student Success Indicator Status (Generate) 2017-18','SLDS State Support Team',3183)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A school''s performance on the state-specific indicators of school quality or student success.', CedsConnectionName = 'FS202 — School Quality or Student Success Indicator Status (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3183
		END
 
		-----------------------------------------
		-- FS203 — Teachers (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3184)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent teachers.','FS203 — Teachers (Generate) 2017-18','SLDS State Support Team',3184)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent teachers.', CedsConnectionName = 'FS203 — Teachers (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3184
		END
 
		-----------------------------------------
		-- Median annual earnings for post secondary graduates
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3186)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection can be used to provide employment outcomes information (number of grads, number employed, and median annual earnings) for a cohort of college-graduates who completed an associate or bachelor’s degree.  The cohort will be graduates from a single year and will follow them into employment. The number of grads and number employed can be used to calculate the percent employed.','Median annual earnings for post secondary graduates','SLDS Employment Outcomes Metrics Work group',3186)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection can be used to provide employment outcomes information (number of grads, number employed, and median annual earnings) for a cohort of college-graduates who completed an associate or bachelor’s degree.  The cohort will be graduates from a single year and will follow them into employment. The number of grads and number employed can be used to calculate the percent employed.', CedsConnectionName = 'Median annual earnings for post secondary graduates', CedsConnectionSource = 'SLDS Employment Outcomes Metrics Work group'
			where CedsUseCaseId = 3186
		END
 
		-----------------------------------------
		-- CCD Report | FS039: Grades Offered (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3188)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS039, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS039: Grades Offered (Generate) SY 2018-19','SLDS State Support Team',3188)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS039, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS039: Grades Offered (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3188
		END
 
		-----------------------------------------
		-- FS190 — Charter Authorizer Directory (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3189)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The data collected using this file specification are required to ensure completeness of data on charter schools and authorizers','FS190 — Charter Authorizer Directory (Generate) SY 2018-19','SLDS State Support Team',3189)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The data collected using this file specification are required to ensure completeness of data on charter schools and authorizers', CedsConnectionName = 'FS190 — Charter Authorizer Directory (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3189
		END
 
		-----------------------------------------
		-- FS196 — Management Organizations Directory (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3190)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('In this file, states submit the list of organizations that manage one or more charter school in the state.','FS196 — Management Organizations Directory (Generate) SY 2018-19','SLDS State Support Team',3190)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'In this file, states submit the list of organizations that manage one or more charter school in the state.', CedsConnectionName = 'FS196 — Management Organizations Directory (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3190
		END
 
		-----------------------------------------
		-- FS198 — Charter Contracts (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3191)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The data collected using this file specification are to enable OII/CSP to obtain a complete list of charter schools in the United States. OII/CSP goes through a complex reconciliation process to compile a directory of all charter schools that are in operation across the nation. These data will fill in the data gaps so that for each school year OII/CSP has a complete and accurate directory of charter schools.','FS198 — Charter Contracts (Generate) 2018-19','SLDS State Support Team',3191)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The data collected using this file specification are to enable OII/CSP to obtain a complete list of charter schools in the United States. OII/CSP goes through a complex reconciliation process to compile a directory of all charter schools that are in operation across the nation. These data will fill in the data gaps so that for each school year OII/CSP has a complete and accurate directory of charter schools.', CedsConnectionName = 'FS198 — Charter Contracts (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3191
		END
 
		-----------------------------------------
		-- FS197 — Crosswalk of Charter Schools to Management Organizations (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3192)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The data collected using this file specification are gathered to provide the Charter School Program Office of the U.S. Department of Education insight into the extent and scope of the relationships between CMOs and EMOs with charter schools.','FS197 — Crosswalk of Charter Schools to Management Organizations (Generate) 2018-19','SLDS State Support Team',3192)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The data collected using this file specification are gathered to provide the Charter School Program Office of the U.S. Department of Education insight into the extent and scope of the relationships between CMOs and EMOs with charter schools.', CedsConnectionName = 'FS197 — Crosswalk of Charter Schools to Management Organizations (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3192
		END
 
		-----------------------------------------
		-- FS130 – ESEA Status (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3193)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The classification of the improvement stage of the school; and an indication of whether the school is identified as persistently dangerous in accordance with state definition.','FS130 – ESEA Status (Generate) SY 2018-19','SLDS State Support Team',3193)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The classification of the improvement stage of the school; and an indication of whether the school is identified as persistently dangerous in accordance with state definition.', CedsConnectionName = 'FS130 – ESEA Status (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3193
		END
 
		-----------------------------------------
		-- CCD Report | FS033 Generate: Free and Reduced Price Lunch (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3194)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS033, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS033 Generate: Free and Reduced Price Lunch (Generate) SY 2018-19','SLDS State Support Team',3194)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS033, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS033 Generate: Free and Reduced Price Lunch (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3194
		END
 
		-----------------------------------------
		-- CCD Report | FS052: Membership (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3195)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS052, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS052: Membership (Generate) SY 2018-19','SLDS State Support Team',3195)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS052, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS052: Membership (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3195
		END
 
		-----------------------------------------
		-- CCD Report | FS129: CCD Schools (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3196)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS129, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS129: CCD Schools (Generate) SY 2018-19','SLDS State Support Team',3196)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS129, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS129: CCD Schools (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3196
		END
 
		-----------------------------------------
		-- xIDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3197)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 6 through 21','xIDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) SY 2018-19','CIID',3197)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 6 through 21', CedsConnectionName = 'xIDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3197
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS089: Children with Disabilities (IDEA) Early Childhood (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3198)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 3 through 5.','IDEA 618 Report | FS089: Children with Disabilities (IDEA) Early Childhood (Generate) 2018-19','CIID',3198)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 3 through 5.', CedsConnectionName = 'IDEA 618 Report | FS089: Children with Disabilities (IDEA) Early Childhood (Generate) 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3198
		END
 
		-----------------------------------------
		-- CCD Report | FS141: LEP Enrolled (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3199)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS141, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS141: LEP Enrolled (Generate) SY 2018-19','SLDS State Support Team',3199)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS141, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS141: LEP Enrolled (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3199
		END
 
		-----------------------------------------
		-- CCD Report | FS029: Directory (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3200)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS029: Directory (Generate) SY 2018-19','SLDS State Support Team',3200)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS029: Directory (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3200
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3201)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) ages 6 through 21','IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) SY 2018-19','Center for the Integration of IDEA Data (CIID)',3201)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) ages 6 through 21', CedsConnectionName = 'IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) SY 2018-19', CedsConnectionSource = 'Center for the Integration of IDEA Data (CIID)'
			where CedsUseCaseId = 3201
		END
 
		-----------------------------------------
		-- FS206 — School Support and Improvement SY 2018-19 (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3204)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication the school is designated by the state as a comprehensive support and improvement (CSI) or targeted support and improvement (TSI) school. The reasons for identification for comprehensive support and improvement (CSI). The reason for identification for targeted support and improvement (TSI).','FS206 — School Support and Improvement SY 2018-19 (Generate)','SLDS State Support Team',3204)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication the school is designated by the state as a comprehensive support and improvement (CSI) or targeted support and improvement (TSI) school. The reasons for identification for comprehensive support and improvement (CSI). The reason for identification for targeted support and improvement (TSI).', CedsConnectionName = 'FS206 — School Support and Improvement SY 2018-19 (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3204
		END
 
		-----------------------------------------
		-- FS067 — Title III Teachers (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3205)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated headcount of teachers who taught in language instruction educational programs designed for English learners supported with Title III of ESEA, as amended by ESSA, funds.','FS067 — Title III Teachers (Generate) SY 2017-18','SLDS State Support Team',3205)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated headcount of teachers who taught in language instruction educational programs designed for English learners supported with Title III of ESEA, as amended by ESSA, funds.', CedsConnectionName = 'FS067 — Title III Teachers (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3205
		END
 
		-----------------------------------------
		-- Generate EDFacts Elements - ARCHIVE
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3207)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Comprehensive list of elements used in the Generate EDFacts Connections','Generate EDFacts Elements - ARCHIVE','CIID Generate Connections',3207)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Comprehensive list of elements used in the Generate EDFacts Connections', CedsConnectionName = 'Generate EDFacts Elements - ARCHIVE', CedsConnectionSource = 'CIID Generate Connections'
			where CedsUseCaseId = 3207
		END
 
		-----------------------------------------
		-- Generate EDFacts Elements_backup4-2-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3208)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Comprehensive list of elements used in the Generate EDFacts Connections','Generate EDFacts Elements_backup4-2-19','CIID Generate Connections',3208)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Comprehensive list of elements used in the Generate EDFacts Connections', CedsConnectionName = 'Generate EDFacts Elements_backup4-2-19', CedsConnectionSource = 'CIID Generate Connections'
			where CedsUseCaseId = 3208
		END
 
		-----------------------------------------
		-- Generate EDFacts Elements_backup 4-1-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3209)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Comprehensive list of elements used in the Generate EDFacts Connections','Generate EDFacts Elements_backup 4-1-19','CIID Generate Connections',3209)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Comprehensive list of elements used in the Generate EDFacts Connections', CedsConnectionName = 'Generate EDFacts Elements_backup 4-1-19', CedsConnectionSource = 'CIID Generate Connections'
			where CedsUseCaseId = 3209
		END
 
		-----------------------------------------
		-- Generate EDFacts Elements
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3211)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Comprehensive list of elements and Connections for EDFacts reporting','Generate EDFacts Elements','Generate EDFacts Connections',3211)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Comprehensive list of elements and Connections for EDFacts reporting', CedsConnectionName = 'Generate EDFacts Elements', CedsConnectionSource = 'Generate EDFacts Connections'
			where CedsUseCaseId = 3211
		END
 
		-----------------------------------------
		-- CCD Report | FS032: Dropouts (Generate) SY 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3214)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS032, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS032: Dropouts (Generate) SY 2017-18','SLDS State Support Team',3214)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS032, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS032: Dropouts (Generate) SY 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3214
		END
 
		-----------------------------------------
		-- CSPR II Report | FS037: Title I Part A SWP/TAS Participation (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3215)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS037, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS037: Title I Part A SWP/TAS Participation (Generate) SY 2018-19','SLDS State Support Team',3215)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS037, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS037: Title I Part A SWP/TAS Participation (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3215
		END
 
		-----------------------------------------
		-- CCD Report | FS040: Graduates/Completers (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3216)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS040, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS040: Graduates/Completers (Generate) SY 2018-19','SLDS State Support Team',3216)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS040, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS040: Graduates/Completers (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3216
		END
 
		-----------------------------------------
		-- CCD Report | FS059: Staff FTE (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3217)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS059, created in collaboration with the EDFacts Partner Support Center (PSC) and CIID.','CCD Report | FS059: Staff FTE (Generate) SY 2018-19','SLDS State Support Team',3217)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS059, created in collaboration with the EDFacts Partner Support Center (PSC) and CIID.', CedsConnectionName = 'CCD Report | FS059: Staff FTE (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3217
		END
 
		-----------------------------------------
		-- FS160 — High School Graduates Postsecondary Enrollment (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3218)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students who graduated the previous academic year who enrolled or did not enroll in an institution of higher education (IHE) during the academic year immediately following the previous academic year.','FS160 — High School Graduates Postsecondary Enrollment (Generate) SY 2018-19','SLDS State Support Team',3218)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students who graduated the previous academic year who enrolled or did not enroll in an institution of higher education (IHE) during the academic year immediately following the previous academic year.', CedsConnectionName = 'FS160 — High School Graduates Postsecondary Enrollment (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3218
		END
 
		-----------------------------------------
		-- FS163 — Discipline Data (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3219)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the school or local education agency (LEA) submitted a Gun-Free Schools Act (GFSA) of 1994 report to the state, as defined by Title 18, Section 921.','FS163 — Discipline Data (Generate) SY 2018-19','SLDS State Support Team',3219)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the school or local education agency (LEA) submitted a Gun-Free Schools Act (GFSA) of 1994 report to the state, as defined by Title 18, Section 921.', CedsConnectionName = 'FS163 — Discipline Data (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3219
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS175: Academic Achievement in Mathematics (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3220)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in mathematics for whom a proficiency level was assigned.','IDEA 618 Report | FS175: Academic Achievement in Mathematics (Generate) SY 2018-19','CIID',3220)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in mathematics for whom a proficiency level was assigned.', CedsConnectionName = 'IDEA 618 Report | FS175: Academic Achievement in Mathematics (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3220
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS178: Academic Achievement in Reading (Language Arts) (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3221)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.','IDEA 618 Report | FS178: Academic Achievement in Reading (Language Arts) (Generate) SY 2018-19','CIID',3221)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.', CedsConnectionName = 'IDEA 618 Report | FS178: Academic Achievement in Reading (Language Arts) (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3221
		END
 
		-----------------------------------------
		-- FS179 - Academic Achievement in Science (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3222)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in science and for whom a proficiency level was assigned.','FS179 - Academic Achievement in Science (Generate) SY 2018-19','SLDS State Support Team',3222)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in science and for whom a proficiency level was assigned.', CedsConnectionName = 'FS179 - Academic Achievement in Science (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3222
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS185: Assessment Participation in Mathematics (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3223)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in mathematics.','IDEA 618 Report | FS185: Assessment Participation in Mathematics (Generate) SY 2018-19','CIID',3223)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in mathematics.', CedsConnectionName = 'IDEA 618 Report | FS185: Assessment Participation in Mathematics (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3223
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS188: Assessment Participation in Reading/Language Arts (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3224)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.','IDEA 618 Report | FS188: Assessment Participation in Reading/Language Arts (Generate) SY 2018-19','CIID',3224)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.', CedsConnectionName = 'IDEA 618 Report | FS188: Assessment Participation in Reading/Language Arts (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3224
		END
 
		-----------------------------------------
		-- FS189 – Assessment Participation in Science File Specifications (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3225)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in science.','FS189 – Assessment Participation in Science File Specifications (Generate) SY 2018-19','SLDS State Support Team',3225)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in science.', CedsConnectionName = 'FS189 – Assessment Participation in Science File Specifications (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3225
		END
 
		-----------------------------------------
		-- FS189 – Assessment Participation in Science (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3226)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in science.','FS189 – Assessment Participation in Science (Generate) SY 2018-19','SLDS State Support Team',3226)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in science.', CedsConnectionName = 'FS189 – Assessment Participation in Science (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3226
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3227)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who are ages 3 through 21 and removed to an interim alternative educational setting.','IDEA 618 Report | FS005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting (Generate) SY 2018-19','CIID',3227)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who are ages 3 through 21 and removed to an interim alternative educational setting.', CedsConnectionName = 'IDEA 618 Report | FS005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3227
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS006: Children with Disabilities (IDEA) Suspensions/Expulsions (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3228)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who are ages 3 through 21 and suspended or expelled for disciplinary reasons.','IDEA 618 Report | FS006: Children with Disabilities (IDEA) Suspensions/Expulsions (Generate) SY 2018-19','CIID',3228)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who are ages 3 through 21 and suspended or expelled for disciplinary reasons.', CedsConnectionName = 'IDEA 618 Report | FS006: Children with Disabilities (IDEA) Suspensions/Expulsions (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3228
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS007: Children with Disabilities (IDEA) Reasons for Unilateral Removal (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3229)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of times children with disabilities (IDEA) who were ages 3 through 21 and unilaterally removed by school personnel (not the IEP team) from their current educational placement to an interim alternative educational setting (determined by the IEP team) due to drug or weapon offense or serious bodily injury.','IDEA 618 Report | FS007: Children with Disabilities (IDEA) Reasons for Unilateral Removal (Generate) SY 2018-19','CIID',3229)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of times children with disabilities (IDEA) who were ages 3 through 21 and unilaterally removed by school personnel (not the IEP team) from their current educational placement to an interim alternative educational setting (determined by the IEP team) due to drug or weapon offense or serious bodily injury.', CedsConnectionName = 'IDEA 618 Report | FS007: Children with Disabilities (IDEA) Reasons for Unilateral Removal (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3229
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS009: Children with Disabilities (IDEA) Exiting Special Education (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3230)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students with disabilities (IDEA) who are ages 14 through 21, were in special education at the start of the reporting period, and were not in special education at the end of the reporting period.','IDEA 618 Report | FS009: Children with Disabilities (IDEA) Exiting Special Education (Generate) SY 2018-19','CIID',3230)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students with disabilities (IDEA) who are ages 14 through 21, were in special education at the start of the reporting period, and were not in special education at the end of the reporting period.', CedsConnectionName = 'IDEA 618 Report | FS009: Children with Disabilities (IDEA) Exiting Special Education (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3230
		END
 
		-----------------------------------------
		-- FS045: Immigrant (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3231)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who meet the definition of immigrant children and youth in Title III of ESEA, as amended.','FS045: Immigrant (Generate) SY 2018-19','SLDS State Support Team',3231)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who meet the definition of immigrant children and youth in Title III of ESEA, as amended.', CedsConnectionName = 'FS045: Immigrant (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3231
		END
 
		-----------------------------------------
		-- FS050: Title III English Language Proficiency Results (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3232)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of English learners who were assessed on the annual state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA, as amended, funds','FS050: Title III English Language Proficiency Results (Generate) SY 2018-19','SLDS State Support Team',3232)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of English learners who were assessed on the annual state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA, as amended, funds', CedsConnectionName = 'FS050: Title III English Language Proficiency Results (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3232
		END
 
		-----------------------------------------
		-- CSPR II Report | FS054: MEP Students Served - 12 Months (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3233)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS054, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS054: MEP Students Served - 12 Months (Generate) SY 2018-19','SLDS State Support Team',3233)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS054, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS054: MEP Students Served - 12 Months (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3233
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS070: Special Education Teachers (FTE) (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3234)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) special education teachers employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.','IDEA 618 Report | FS070: Special Education Teachers (FTE) (Generate) SY 2018-19','CIID',3234)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) special education teachers employed or contracted to work with children with disabilities (IDEA) who are ages 3 through 21.', CedsConnectionName = 'IDEA 618 Report | FS070: Special Education Teachers (FTE) (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3234
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS088: Children with Disabilities (IDEA) Disciplinary Removals (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3235)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are ages 3 through 21 who were subject to any kind of disciplinary removal during the school year.','IDEA 618 Report | FS088: Children with Disabilities (IDEA) Disciplinary Removals (Generate) SY 2018-19','CIID',3235)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are ages 3 through 21 who were subject to any kind of disciplinary removal during the school year.', CedsConnectionName = 'IDEA 618 Report | FS088: Children with Disabilities (IDEA) Disciplinary Removals (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3235
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS099: Special Education Related Services Personnel (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3236)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) related services personnel employed or contracted to provide related services for children with disabilities (IDEA) who were ages 3 through 21.','IDEA 618 Report | FS099: Special Education Related Services Personnel (Generate) SY 2018-19','CIID',3236)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) related services personnel employed or contracted to provide related services for children with disabilities (IDEA) who were ages 3 through 21.', CedsConnectionName = 'IDEA 618 Report | FS099: Special Education Related Services Personnel (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3236
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS112: Special Education Paraprofessionals (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3237)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent (FTE) paraprofessionals employed or contracted to work with children with disabilities (IDEA) who were ages 3 through 21.','IDEA 618 Report | FS112: Special Education Paraprofessionals (Generate) SY 2018-19','CIID',3237)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent (FTE) paraprofessionals employed or contracted to work with children with disabilities (IDEA) who were ages 3 through 21.', CedsConnectionName = 'IDEA 618 Report | FS112: Special Education Paraprofessionals (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3237
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS143: Children with Disabilities (IDEA) Total Disciplinary Removals (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3238)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of times children with disabilities (IDEA) who were ages 3 through 21 were subject to any kind of disciplinary removal.','IDEA 618 Report | FS143: Children with Disabilities (IDEA) Total Disciplinary Removals (Generate) SY 2018-19','CIID',3238)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of times children with disabilities (IDEA) who were ages 3 through 21 were subject to any kind of disciplinary removal.', CedsConnectionName = 'IDEA 618 Report | FS143: Children with Disabilities (IDEA) Total Disciplinary Removals (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3238
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS144: Educational Services During Expulsion (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3239)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children (students) who were removed for disciplinary reasons from their regular school program for the remainder of the school year or longer, including all removals resulting from violations of the Gun-Free Schools Act (GFSA) of 1994.','IDEA 618 Report | FS144: Educational Services During Expulsion (Generate) SY 2018-19','CIID',3239)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children (students) who were removed for disciplinary reasons from their regular school program for the remainder of the school year or longer, including all removals resulting from violations of the Gun-Free Schools Act (GFSA) of 1994.', CedsConnectionName = 'IDEA 618 Report | FS144: Educational Services During Expulsion (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3239
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS004: Children with Disabilities (IDEA) Not Participating in Assessments (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3240)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of children with disabilities (IDEA) who did not participate in and receive a valid score on the state assessments.','IDEA 618 Report | FS004: Children with Disabilities (IDEA) Not Participating in Assessments (Generate) SY 2018-19','CIID',3240)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of children with disabilities (IDEA) who did not participate in and receive a valid score on the state assessments.', CedsConnectionName = 'IDEA 618 Report | FS004: Children with Disabilities (IDEA) Not Participating in Assessments (Generate) SY 2018-19', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 3240
		END
 
		-----------------------------------------
		-- CSPR II Report | FS121: Migratory Students Eligible - 12 Months  (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3241)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS121, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS121: Migratory Students Eligible - 12 Months  (Generate) SY 2018-19','SLDS State Support Team',3241)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS121, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS121: Migratory Students Eligible - 12 Months  (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3241
		END
 
		-----------------------------------------
		-- CSPR II Report | FS122: MEP Students Eligible and Served – Summer/Intersession (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3242)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS122, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS122: MEP Students Eligible and Served – Summer/Intersession (Generate) SY 2018-19','SLDS State Support Team',3242)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS122, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS122: MEP Students Eligible and Served – Summer/Intersession (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3242
		END
 
		-----------------------------------------
		-- CSPR II Report | FS134: Title I Part A Participation (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3243)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS134, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS134: Title I Part A Participation (Generate) SY 2018-19','SLDS State Support Team',3243)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS134, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS134: Title I Part A Participation (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3243
		END
 
		-----------------------------------------
		-- CSPR II Report | FS145: MEP Services (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3244)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS145, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS145: MEP Services (Generate) SY 2018-19','SLDS State Support Team',3244)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS145, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS145: MEP Services (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3244
		END
 
		-----------------------------------------
		-- FS082 - CTE Concentrators Exiting (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3245)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who left secondary education.','FS082 - CTE Concentrators Exiting (Generate) SY 2018-19','SLDS State Support Team',3245)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who left secondary education.', CedsConnectionName = 'FS082 - CTE Concentrators Exiting (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3245
		END
 
		-----------------------------------------
		-- FS083 — CTE Concentrator Graduates (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3246)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who left secondary education and who received a high school diploma or its recognized equivalent.','FS083 — CTE Concentrator Graduates (Generate) SY 2018-19','SLDS State Support Team',3246)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who left secondary education and who received a high school diploma or its recognized equivalent.', CedsConnectionName = 'FS083 — CTE Concentrator Graduates (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3246
		END
 
		-----------------------------------------
		-- FS086 — Students Involved with Firearms (Generate) SY2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3247)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were involved in an incident involving a firearm.','FS086 — Students Involved with Firearms (Generate) SY2018-19','SLDS State Support Team',3247)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were involved in an incident involving a firearm.', CedsConnectionName = 'FS086 — Students Involved with Firearms (Generate) SY2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3247
		END
 
		-----------------------------------------
		-- FS103 — Accountability (Generate) 2017-18 (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3248)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The classification of a school’s poverty quartile for purposes of determining the number of inexperienced, emergency/provisional credentialed, and out-of-field teachers in high and low poverty schools, according to state’s indicator of poverty.','FS103 — Accountability (Generate) 2017-18 (Generate) 2018-19','SLDS State Support Team',3248)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The classification of a school’s poverty quartile for purposes of determining the number of inexperienced, emergency/provisional credentialed, and out-of-field teachers in high and low poverty schools, according to state’s indicator of poverty.', CedsConnectionName = 'FS103 — Accountability (Generate) 2017-18 (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3248
		END
 
		-----------------------------------------
		-- FS113 — N or D Academic Achievement - State Agency (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3249)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students served by Title I, Part D, Subpart 1 of ESEA, as amended, for at least 90 consecutive days during the reporting period who took both a pre- and post-test.','FS113 — N or D Academic Achievement - State Agency (Generate) 2018-19','SLDS State Support Team',3249)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students served by Title I, Part D, Subpart 1 of ESEA, as amended, for at least 90 consecutive days during the reporting period who took both a pre- and post-test.', CedsConnectionName = 'FS113 — N or D Academic Achievement - State Agency (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3249
		END
 
		-----------------------------------------
		-- FS116 — Title III Students Served (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3250)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of English learners served by an English language instruction educational program supported with Title III of ESEA, as amended, funds.','FS116 — Title III Students Served (Generate) 2018-19','SLDS State Support Team',3250)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of English learners served by an English language instruction educational program supported with Title III of ESEA, as amended, funds.', CedsConnectionName = 'FS116 — Title III Students Served (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3250
		END
 
		-----------------------------------------
		-- FS118 — Homeless Students Enrolled (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3251)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('This Connection can be used as a template for new EDFacts reports in Generate.  The categories, data elements, analysis recommends, and related connections should be reviewed and updated to meet the needs of the EDFacts report.','FS118 — Homeless Students Enrolled (Generate) SY 2018-19','SLDS State Support Team',3251)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'This Connection can be used as a template for new EDFacts reports in Generate.  The categories, data elements, analysis recommends, and related connections should be reviewed and updated to meet the needs of the EDFacts report.', CedsConnectionName = 'FS118 — Homeless Students Enrolled (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3251
		END
 
		-----------------------------------------
		-- FS119 — N or D Participation - State Agency (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3252)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency) of ESEA as amended.','FS119 — N or D Participation - State Agency (Generate) 2018-19','SLDS State Support Team',3252)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency) of ESEA as amended.', CedsConnectionName = 'FS119 — N or D Participation - State Agency (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3252
		END
 
		-----------------------------------------
		-- FS125 — N or D Academic Achievement - LEA (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3253)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students served by Title I, Part D, Subpart 2 of ESEA, as amended, for at least 90 consecutive days during the reporting period who took both a pre- and post-test.','FS125 — N or D Academic Achievement - LEA (Generate) 2018-19','SLDS State Support Team',3253)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students served by Title I, Part D, Subpart 2 of ESEA, as amended, for at least 90 consecutive days during the reporting period who took both a pre- and post-test.', CedsConnectionName = 'FS125 — N or D Academic Achievement - LEA (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3253
		END
 
		-----------------------------------------
		-- FS126 — Title III Former EL Students (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3254)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of former English learners who are meeting and not meeting the challenging State academic standards as measured by proficiency for each of the four years after such children are no longer receiving services under Title III of ESEA, as amended.','FS126 — Title III Former EL Students (Generate) SY 2018-19','SLDS State Support Team',3254)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of former English learners who are meeting and not meeting the challenging State academic standards as measured by proficiency for each of the four years after such children are no longer receiving services under Title III of ESEA, as amended.', CedsConnectionName = 'FS126 — Title III Former EL Students (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3254
		END
 
		-----------------------------------------
		-- FS127 — N or D Participation – LEA (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3255)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected, delinquent, or at-risk students (N or D) under Title I, Part D, Subpart 2 (LEA) of ESEA as amended.','FS127 — N or D Participation – LEA (Generate) 2018-19','SLDS State Support Team',3255)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected, delinquent, or at-risk students (N or D) under Title I, Part D, Subpart 2 (LEA) of ESEA as amended.', CedsConnectionName = 'FS127 — N or D Participation – LEA (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3255
		END
 
		-----------------------------------------
		-- FS131 — LEA End of School Year Status (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3256)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication that the local educational agency (LEA) notified the state of the LEA''s intention to use REAP-Flex Alternative Uses of Funding Authority during the school year as specified in the Title V, Section 5211 of ESEA, as amended.','FS131 — LEA End of School Year Status (Generate) SY 2018-19','SLDS State Support Team',3256)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication that the local educational agency (LEA) notified the state of the LEA''s intention to use REAP-Flex Alternative Uses of Funding Authority during the school year as specified in the Title V, Section 5211 of ESEA, as amended.', CedsConnectionName = 'FS131 — LEA End of School Year Status (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3256
		END
 
		-----------------------------------------
		-- FS132 — Section 1003 Funds (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3257)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The data collected using this file specification are used to monitor and report performance on programs and activities supported by the Elementary and Secondary Education Act (ESEA), as amended.  Data group 794 will be used to populate the Consolidated State Performance Report (CSPR).','FS132 — Section 1003 Funds (Generate) SY 2018-19','SLDS State Support Team',3257)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The data collected using this file specification are used to monitor and report performance on programs and activities supported by the Elementary and Secondary Education Act (ESEA), as amended.  Data group 794 will be used to populate the Consolidated State Performance Report (CSPR).', CedsConnectionName = 'FS132 — Section 1003 Funds (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3257
		END
 
		-----------------------------------------
		-- FS138 - Title III English Language Proficiency Test (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3258)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of English learners who were enrolled during the time of the state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA, as amended, funds.','FS138 - Title III English Language Proficiency Test (Generate) SY 2018-19','SLDS State Support Team',3258)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of English learners who were enrolled during the time of the state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA, as amended, funds.', CedsConnectionName = 'FS138 - Title III English Language Proficiency Test (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3258
		END
 
		-----------------------------------------
		-- FS139 — English Language Proficiency Results (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3259)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of English learners who took the annual state English language proficiency assessment.','FS139 — English Language Proficiency Results (Generate) SY 2018-19','SLDS State Support Team',3259)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of English learners who took the annual state English language proficiency assessment.', CedsConnectionName = 'FS139 — English Language Proficiency Results (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3259
		END
 
		-----------------------------------------
		-- FS142 — CTE Concentrators Academic Achievement (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3260)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of CTE concentrators who left secondary education during the school year for whom a proficiency score on the state assessment was included in the state’s calculation of adequate yearly progress (AYP).','FS142 — CTE Concentrators Academic Achievement (Generate) SY 2018-19','SLDS State Support Team',3260)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of CTE concentrators who left secondary education during the school year for whom a proficiency score on the state assessment was included in the state’s calculation of adequate yearly progress (AYP).', CedsConnectionName = 'FS142 — CTE Concentrators Academic Achievement (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3260
		END
 
		-----------------------------------------
		-- FS150 — Adjusted-Cohort Graduation Rate (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3261)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Cohorts for four-year, five-year, and six-year adjusted-cohort graduation rate table.','FS150 — Adjusted-Cohort Graduation Rate (Generate) SY 2018-19','SLDS State Support Team',3261)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Cohorts for four-year, five-year, and six-year adjusted-cohort graduation rate table.', CedsConnectionName = 'FS150 — Adjusted-Cohort Graduation Rate (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3261
		END
 
		-----------------------------------------
		-- FS151 — Cohorts for Adjusted-Cohort Graduation Rate (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3262)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Cohorts for four-year, five-year, and six-year adjusted-cohort graduation rate table.','FS151 — Cohorts for Adjusted-Cohort Graduation Rate (Generate) SY 2018-19','SLDS State Support Team',3262)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Cohorts for four-year, five-year, and six-year adjusted-cohort graduation rate table.', CedsConnectionName = 'FS151 — Cohorts for Adjusted-Cohort Graduation Rate (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3262
		END
 
		-----------------------------------------
		-- FS154 — CTE Concentrators in Graduation Rate (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3263)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who were included in the state’s computation of its graduation rate as described in section 1111 (b)(2)(C)(vi) of the ESEA, as amended.','FS154 — CTE Concentrators in Graduation Rate (Generate) SY 2018-19','SLDS State Support Team',3263)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who were included in the state’s computation of its graduation rate as described in section 1111 (b)(2)(C)(vi) of the ESEA, as amended.', CedsConnectionName = 'FS154 — CTE Concentrators in Graduation Rate (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3263
		END
 
		-----------------------------------------
		-- FS155 – CTE Participants in Programs for Non-traditional (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3264)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE participants who participated in a program that leads to employment in non-traditional fields.','FS155 – CTE Participants in Programs for Non-traditional (Generate) SY 2018-19','SLDS State Support Team',3264)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE participants who participated in a program that leads to employment in non-traditional fields.', CedsConnectionName = 'FS155 – CTE Participants in Programs for Non-traditional (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3264
		END
 
		-----------------------------------------
		-- FS156 – CTE Concentrators in Programs for Non-traditional Fields (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3265)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who completed a program that leads to employment in non-traditional fields.','FS156 – CTE Concentrators in Programs for Non-traditional Fields (Generate) SY 2018-19','SLDS State Support Team',3265)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who completed a program that leads to employment in non-traditional fields.', CedsConnectionName = 'FS156 – CTE Concentrators in Programs for Non-traditional Fields (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3265
		END
 
		-----------------------------------------
		-- FS157 — CTE Concentrators Technical Skills (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3266)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who took technical skill assessments that are aligned with industry-recognized standards.','FS157 — CTE Concentrators Technical Skills (Generate) SY 2018-19','SLDS State Support Team',3266)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who took technical skill assessments that are aligned with industry-recognized standards.', CedsConnectionName = 'FS157 — CTE Concentrators Technical Skills (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3266
		END
 
		-----------------------------------------
		-- FS158 — CTE Concentrators Placement (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3267)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who left secondary education in the cohort which graduated the prior program year.','FS158 — CTE Concentrators Placement (Generate) 2018-19','SLDS State Support Team',3267)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who left secondary education in the cohort which graduated the prior program year.', CedsConnectionName = 'FS158 — CTE Concentrators Placement (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3267
		END
 
		-----------------------------------------
		-- FS169 – CTE Type of Placement (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3268)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of CTE concentrators who left secondary education in the cohort which graduated the prior program year and were placed.','FS169 – CTE Type of Placement (Generate) SY 2018-19','SLDS State Support Team',3268)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of CTE concentrators who left secondary education in the cohort which graduated the prior program year and were placed.', CedsConnectionName = 'FS169 – CTE Type of Placement (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3268
		END
 
		-----------------------------------------
		-- FS180 — N or D In Program Outcomes (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3269)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency and LEA) of ESEA, as amended, who attained academic and career and technical outcomes while enrolled in the programs.','FS180 — N or D In Program Outcomes (Generate) 2018-19','SLDS State Support Team',3269)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency and LEA) of ESEA, as amended, who attained academic and career and technical outcomes while enrolled in the programs.', CedsConnectionName = 'FS180 — N or D In Program Outcomes (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3269
		END
 
		-----------------------------------------
		-- FS181 — N or D Exited Program Outcomes (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3270)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency and LEA) of ESEA, as amended, who attained academic and career and technical outcomes while enrolled in the programs.','FS181 — N or D Exited Program Outcomes (Generate) 2018-19','SLDS State Support Team',3270)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected or delinquent students (N or D) under Title I, Part D, Subpart 1 (State Agency and LEA) of ESEA, as amended, who attained academic and career and technical outcomes while enrolled in the programs.', CedsConnectionName = 'FS181 — N or D Exited Program Outcomes (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3270
		END
 
		-----------------------------------------
		-- CSPR II Report | FS193: Title I Allocations (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3271)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS193, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS193: Title I Allocations (Generate) SY 2018-19','SLDS State Support Team',3271)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS193, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS193: Title I Allocations (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3271
		END
 
		-----------------------------------------
		-- FS195 — Chronic Absenteeism (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3272)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students absent 10% or more school days during the school year','FS195 — Chronic Absenteeism (Generate) SY 2018-19','SLDS State Support Team',3272)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students absent 10% or more school days during the school year', CedsConnectionName = 'FS195 — Chronic Absenteeism (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3272
		END
 
		-----------------------------------------
		-- FS200 — Academic Achievement Indicator Status (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3273)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A school''s performance on the Academic Achievement Indicator for both Mathematics and Reading/Language Arts','FS200 — Academic Achievement Indicator Status (Generate) 2018-19','SLDS State Support Team',3273)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A school''s performance on the Academic Achievement Indicator for both Mathematics and Reading/Language Arts', CedsConnectionName = 'FS200 — Academic Achievement Indicator Status (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3273
		END
 
		-----------------------------------------
		-- FS201 — Other Academic Indicator Status (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3274)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A school’s performance on the Other Academic Indicator.','FS201 — Other Academic Indicator Status (Generate) SY 2018-19','SLDS State Support Team',3274)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A school’s performance on the Other Academic Indicator.', CedsConnectionName = 'FS201 — Other Academic Indicator Status (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3274
		END
 
		-----------------------------------------
		-- FS202 — School Quality or Student Success Indicator Status (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3275)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A school''s performance on the state-specific indicators of school quality or student success.','FS202 — School Quality or Student Success Indicator Status (Generate) 2018-19','SLDS State Support Team',3275)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A school''s performance on the state-specific indicators of school quality or student success.', CedsConnectionName = 'FS202 — School Quality or Student Success Indicator Status (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3275
		END
 
		-----------------------------------------
		-- FS203 — Teachers (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3276)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of full-time equivalent teachers.','FS203 — Teachers (Generate) 2018-19','SLDS State Support Team',3276)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of full-time equivalent teachers.', CedsConnectionName = 'FS203 — Teachers (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3276
		END
 
		-----------------------------------------
		-- FS204 — Title III English Learners (Generate) 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3277)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Title III English learners not proficient within five years and Title III English learners exited.','FS204 — Title III English Learners (Generate) 2018-19','SLDS State Support Team',3277)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Title III English learners not proficient within five years and Title III English learners exited.', CedsConnectionName = 'FS204 — Title III English Learners (Generate) 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3277
		END
 
		-----------------------------------------
		-- FS205 — Progress Achieving English Language Proficiency Indicator Status (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  3278)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A school’s performance on the progress in achieving English Language proficiency indicator.','FS205 — Progress Achieving English Language Proficiency Indicator Status (Generate) SY 2018-19','SLDS State Support Team',3278)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A school’s performance on the progress in achieving English Language proficiency indicator.', CedsConnectionName = 'FS205 — Progress Achieving English Language Proficiency Indicator Status (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 3278
		END
 
		-----------------------------------------
		-- CSPR II Report | FS165: Migratory Data (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4271)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS165, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS165: Migratory Data (Generate) SY 2018-19','SLDS State Support Team',4271)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS165, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS165: Migratory Data (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4271
		END
 
		-----------------------------------------
		-- FS127 - N or D Participation - LEA (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4272)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of students participating in programs for neglected, delinquent, or at-risk students (N or D) under Title I, Part D, Subpart 2 (LEA) of ESEA as amended.','FS127 - N or D Participation - LEA (Generate) SY 2018-19','SLDS State Support Team',4272)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of students participating in programs for neglected, delinquent, or at-risk students (N or D) under Title I, Part D, Subpart 2 (LEA) of ESEA as amended.', CedsConnectionName = 'FS127 - N or D Participation - LEA (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4272
		END
 
		-----------------------------------------
		-- FS067 - Title III Teachers (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4273)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated headcount of teachers who taught in language instruction educational programs designed for English learners supported with Title III of ESEA, as amended by ESSA, funds.','FS067 - Title III Teachers (Generate) SY 2018-19','SLDS State Support Team',4273)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated headcount of teachers who taught in language instruction educational programs designed for English learners supported with Title III of ESEA, as amended by ESSA, funds.', CedsConnectionName = 'FS067 - Title III Teachers (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4273
		END
 
		-----------------------------------------
		-- FS137 - English Language Proficiency Test (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4274)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of English learners who were enrolled at the time of the state annual English language proficiency assessment.','FS137 - English Language Proficiency Test (Generate) SY 2018-19','SLDS State Support Team',4274)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of English learners who were enrolled at the time of the state annual English language proficiency assessment.', CedsConnectionName = 'FS137 - English Language Proficiency Test (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4274
		END
 
		-----------------------------------------
		-- FS170 — LEA Subgrant Status (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4275)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('An indication of whether the LEA received a McKinney-Vento subgrant.','FS170 — LEA Subgrant Status (Generate) SY 2018-19','SLDS State Support Team',4275)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'An indication of whether the LEA received a McKinney-Vento subgrant.', CedsConnectionName = 'FS170 — LEA Subgrant Status (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4275
		END
 
		-----------------------------------------
		-- FS199 — Graduation Rate Indicator Status (Generate) SY 2018-19
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4276)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('A school’s performance on the Graduation Rate Indicator.','FS199 — Graduation Rate Indicator Status (Generate) SY 2018-19','SLDS State Support Team',4276)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'A school’s performance on the Graduation Rate Indicator.', CedsConnectionName = 'FS199 — Graduation Rate Indicator Status (Generate) SY 2018-19', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4276
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4278)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) ages 6 through 21','IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) 2019-20','Center for the Integration of IDEA Data (CIID)',4278)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) ages 6 through 21', CedsConnectionName = 'IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) 2019-20', CedsConnectionSource = 'Center for the Integration of IDEA Data (CIID)'
			where CedsUseCaseId = 4278
		END
 
		-----------------------------------------
		-- What are the student characteristics and schooling experiences of those students who do and do not participate in Early Head Start and Head Start programs?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4308)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What are the predictive factors related to third-grade reading proficiency in the CNMI?','What are the student characteristics and schooling experiences of those students who do and do not participate in Early Head Start and Head Start programs?','SLDS Workgroup - Scaling Research with CEDS',4308)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What are the predictive factors related to third-grade reading proficiency in the CNMI?', CedsConnectionName = 'What are the student characteristics and schooling experiences of those students who do and do not participate in Early Head Start and Head Start programs?', CedsConnectionSource = 'SLDS Workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4308
		END
 
		-----------------------------------------
		-- What percentage of last year''s high school graduates need remediation in college, and how do these percentages vary with student demographics characteristics?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4309)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('College Remediation for high school graduates','What percentage of last year''s high school graduates need remediation in college, and how do these percentages vary with student demographics characteristics?','SLDS Workgroup - Scaling Research with CEDS',4309)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'College Remediation for high school graduates', CedsConnectionName = 'What percentage of last year''s high school graduates need remediation in college, and how do these percentages vary with student demographics characteristics?', CedsConnectionSource = 'SLDS Workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4309
		END
 
		-----------------------------------------
		-- Test early childhood
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4310)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Test early childhood','Test early childhood','SLDS Workgroup - Scaling Research with CEDS',4310)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Test early childhood', CedsConnectionName = 'Test early childhood', CedsConnectionSource = 'SLDS Workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4310
		END
 
		-----------------------------------------
		-- Enrollment of low-income Public Pre-K students
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4311)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Un-duplicated count of Economically disadvantaged children enrolled in public Pre K on Oct 1.','Enrollment of low-income Public Pre-K students','SLDS workgroup - Scaling Research with CEDS',4311)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Un-duplicated count of Economically disadvantaged children enrolled in public Pre K on Oct 1.', CedsConnectionName = 'Enrollment of low-income Public Pre-K students', CedsConnectionSource = 'SLDS workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4311
		END
 
		-----------------------------------------
		-- Early Childhood program enrollment
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4312)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connecting existing data elements for Kansas Early Childhood enrollment','Early Childhood program enrollment','SLDS Workgroup - Scaling Research with CEDS',4312)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connecting existing data elements for Kansas Early Childhood enrollment', CedsConnectionName = 'Early Childhood program enrollment', CedsConnectionSource = 'SLDS Workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4312
		END
 
		-----------------------------------------
		-- What percentage of last years high school graduates need remediation in college, and how do these percentages vary by student demographics?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4313)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('HS graduates needing remediation','What percentage of last years high school graduates need remediation in college, and how do these percentages vary by student demographics?','SLDS Workgroup - Scaling Research with CEDS',4313)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'HS graduates needing remediation', CedsConnectionName = 'What percentage of last years high school graduates need remediation in college, and how do these percentages vary by student demographics?', CedsConnectionSource = 'SLDS Workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4313
		END
 
		-----------------------------------------
		-- How many students who earned a GED continued into post-secondary education and what were their post-secondary outcomes?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4314)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Post-secondary outcomes for GED attainers','How many students who earned a GED continued into post-secondary education and what were their post-secondary outcomes?','SLDS Workgroup - Scaling Research with CEDS',4314)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Post-secondary outcomes for GED attainers', CedsConnectionName = 'How many students who earned a GED continued into post-secondary education and what were their post-secondary outcomes?', CedsConnectionSource = 'SLDS Workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4314
		END
 
		-----------------------------------------
		-- What are the student characteristics and schooling experiences of those students  who do and do not achieve proficiency on the grade 3 ACT Aspire assessment?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4315)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What are the predictive factors related to third-grade reading proficiency in the CNMI?','What are the student characteristics and schooling experiences of those students  who do and do not achieve proficiency on the grade 3 ACT Aspire assessment?','SLDS Workgroup - Scaling Research with CEDS',4315)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What are the predictive factors related to third-grade reading proficiency in the CNMI?', CedsConnectionName = 'What are the student characteristics and schooling experiences of those students  who do and do not achieve proficiency on the grade 3 ACT Aspire assessment?', CedsConnectionSource = 'SLDS Workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4315
		END
 
		-----------------------------------------
		-- How many students who earned a GED continues into post-secondary education and what were their post-secondary outcomes?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4316)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Post-secondary outcomes for GED retainers','How many students who earned a GED continues into post-secondary education and what were their post-secondary outcomes?','SLDS Workgroup - Scaling Research With CEDS',4316)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Post-secondary outcomes for GED retainers', CedsConnectionName = 'How many students who earned a GED continues into post-secondary education and what were their post-secondary outcomes?', CedsConnectionSource = 'SLDS Workgroup - Scaling Research With CEDS'
			where CedsUseCaseId = 4316
		END
 
		-----------------------------------------
		-- Attendance Patterns and Proficiency Outcomes by Subgroup
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4317)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What are the attendance patterns and proficiency levels of students who drop out by subgroup?','Attendance Patterns and Proficiency Outcomes by Subgroup','SLDS Workgroup - Scaling Research with CEDS',4317)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What are the attendance patterns and proficiency levels of students who drop out by subgroup?', CedsConnectionName = 'Attendance Patterns and Proficiency Outcomes by Subgroup', CedsConnectionSource = 'SLDS Workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4317
		END
 
		-----------------------------------------
		-- What are the attendance patterns and proficiency levels of students who drop out by subgroup?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4318)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Attendance patterns and proficiency outcomes by subgroup.','What are the attendance patterns and proficiency levels of students who drop out by subgroup?','SLDS Workgroup -  Scaling Research with CEDS',4318)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Attendance patterns and proficiency outcomes by subgroup.', CedsConnectionName = 'What are the attendance patterns and proficiency levels of students who drop out by subgroup?', CedsConnectionSource = 'SLDS Workgroup -  Scaling Research with CEDS'
			where CedsUseCaseId = 4318
		END
 
		-----------------------------------------
		-- What percentage of last year’s high school graduates need remediation in college and how do these percentages vary by student demographic characteristics?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4319)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('College Remediation Rates for Subgroups','What percentage of last year’s high school graduates need remediation in college and how do these percentages vary by student demographic characteristics?','SLDS Workgroup - Scaling Research with CEDS',4319)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'College Remediation Rates for Subgroups', CedsConnectionName = 'What percentage of last year’s high school graduates need remediation in college and how do these percentages vary by student demographic characteristics?', CedsConnectionSource = 'SLDS Workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4319
		END
 
		-----------------------------------------
		-- What percentage of last year''s high school graduates need remediation in college, and how do these percentages vary by student demopgraphic characteristics?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4320)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('college remediation rates for subgroups','What percentage of last year''s high school graduates need remediation in college, and how do these percentages vary by student demopgraphic characteristics?','SLDS Workgroup - Scaling Research with CEDS',4320)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'college remediation rates for subgroups', CedsConnectionName = 'What percentage of last year''s high school graduates need remediation in college, and how do these percentages vary by student demopgraphic characteristics?', CedsConnectionSource = 'SLDS Workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4320
		END
 
		-----------------------------------------
		-- Workforce and post-secondary enrollment outcomes for dropouts vs. completers
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4321)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('What are the college enrollment and workforce patterns of students who drop out of high school, and how do they compare to students who receive a high school diploma?','Workforce and post-secondary enrollment outcomes for dropouts vs. completers','SLDS Workgroup - Scaling Research with CEDS',4321)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'What are the college enrollment and workforce patterns of students who drop out of high school, and how do they compare to students who receive a high school diploma?', CedsConnectionName = 'Workforce and post-secondary enrollment outcomes for dropouts vs. completers', CedsConnectionSource = 'SLDS Workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4321
		END
 
		-----------------------------------------
		-- What are the characteristics of districts/schools that meet or do not meet accountability requirements, specifically characteristics of funding, programs, average class size, staff allocations, and teacher qualifications?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4322)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Schoolwide difference in accountability ratings','What are the characteristics of districts/schools that meet or do not meet accountability requirements, specifically characteristics of funding, programs, average class size, staff allocations, and teacher qualifications?','SLDS Workgroup - Scaling Research with CEDS',4322)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Schoolwide difference in accountability ratings', CedsConnectionName = 'What are the characteristics of districts/schools that meet or do not meet accountability requirements, specifically characteristics of funding, programs, average class size, staff allocations, and teacher qualifications?', CedsConnectionSource = 'SLDS Workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4322
		END
 
		-----------------------------------------
		-- How many students who earned a GED continued into post-secondary education and what were their post-secondary outcomes?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4323)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Post-secondary outcomes for GED attainers','How many students who earned a GED continued into post-secondary education and what were their post-secondary outcomes?','SLDS Workgroup - Scaling Research with CEDS',4323)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Post-secondary outcomes for GED attainers', CedsConnectionName = 'How many students who earned a GED continued into post-secondary education and what were their post-secondary outcomes?', CedsConnectionSource = 'SLDS Workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4323
		END
 
		-----------------------------------------
		-- How many low-income children are enrolled in the following programs: Head Start, publicly funded Pre-K, publicly funded child care programs or family child care homes, early intervention programs, and special education services?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4324)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Early childhood program enrollment','How many low-income children are enrolled in the following programs: Head Start, publicly funded Pre-K, publicly funded child care programs or family child care homes, early intervention programs, and special education services?','SLDS Workgroup-Scaling_Research_With_CEDS',4324)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Early childhood program enrollment', CedsConnectionName = 'How many low-income children are enrolled in the following programs: Head Start, publicly funded Pre-K, publicly funded child care programs or family child care homes, early intervention programs, and special education services?', CedsConnectionSource = 'SLDS Workgroup-Scaling_Research_With_CEDS'
			where CedsUseCaseId = 4324
		END
 
		-----------------------------------------
		-- What are the attendance patterns and proficiency levels of students who drop out by subgroups?
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4325)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('SLDS Workgroup - Scaling Research with CEDS - Answering question - What are the attendance patterns and proficiency levels of students who drop out by subgroups?','What are the attendance patterns and proficiency levels of students who drop out by subgroups?','SLDS Workgroup - Scaling Research with CEDS',4325)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'SLDS Workgroup - Scaling Research with CEDS - Answering question - What are the attendance patterns and proficiency levels of students who drop out by subgroups?', CedsConnectionName = 'What are the attendance patterns and proficiency levels of students who drop out by subgroups?', CedsConnectionSource = 'SLDS Workgroup - Scaling Research with CEDS'
			where CedsUseCaseId = 4325
		END
 
		-----------------------------------------
		--  IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4337)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are receiving services and are ages 5 (in kindergarten) through 21',' IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) 2019-20','Center for the Integration of IDEA Data (CIID)',4337)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are receiving services and are ages 5 (in kindergarten) through 21', CedsConnectionName = ' IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) 2019-20', CedsConnectionSource = 'Center for the Integration of IDEA Data (CIID)'
			where CedsUseCaseId = 4337
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4338)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) who are receiving services and are ages 5 (in kindergarten) through 21.','IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) SY 2019-20','Center for the Integration of IDEA Data (CIID)',4338)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) who are receiving services and are ages 5 (in kindergarten) through 21.', CedsConnectionName = 'IDEA 618 Report | FS002: Children with Disabilities (IDEA) School Age (Generate) SY 2019-20', CedsConnectionSource = 'Center for the Integration of IDEA Data (CIID)'
			where CedsUseCaseId = 4338
		END
 
		-----------------------------------------
		-- CCD Report | FS059: Staff FTE (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4340)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS059, created in collaboration with the EDFacts Partner Support Center (PSC) and CIID.','CCD Report | FS059: Staff FTE (Generate) SY 2019-20','SLDS State Support Team',4340)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS059, created in collaboration with the EDFacts Partner Support Center (PSC) and CIID.', CedsConnectionName = 'CCD Report | FS059: Staff FTE (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4340
		END
 
		-----------------------------------------
		-- FS196 — Management Organizations Directory (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4341)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('In this file, states submit the list of organizations that manage one or more charter school in the state.','FS196 — Management Organizations Directory (Generate) SY 2019-20','SLDS State Support Team',4341)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'In this file, states submit the list of organizations that manage one or more charter school in the state.', CedsConnectionName = 'FS196 — Management Organizations Directory (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4341
		END
 
		-----------------------------------------
		-- FS206 — School Support and Improvement SY 2019-20 (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4342)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Designation by the state of a school for comprehensive support and improvement, targeted support and improvement, and additional targeted support and improvement.','FS206 — School Support and Improvement SY 2019-20 (Generate)','SLDS State Support Team',4342)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Designation by the state of a school for comprehensive support and improvement, targeted support and improvement, and additional targeted support and improvement.', CedsConnectionName = 'FS206 — School Support and Improvement SY 2019-20 (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4342
		END
 
		-----------------------------------------
		-- CCD Report | FS029: Directory (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4345)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS029: Directory (Generate) SY 2019-20','SLDS State Support Team',4345)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS029: Directory (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4345
		END
 
		-----------------------------------------
		-- CCD Report | FS039: Grades Offered (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4346)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS039, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS039: Grades Offered (Generate) SY 2019-20','SLDS State Support Team',4346)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS039, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS039: Grades Offered (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4346
		END
 
		-----------------------------------------
		-- FS130 – ESEA Status (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4347)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The classification of the improvement stage of the school; and an indication of whether the school is identified as persistently dangerous in accordance with state definition.','FS130 – ESEA Status (Generate) SY 2019-20','SLDS State Support Team',4347)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The classification of the improvement stage of the school; and an indication of whether the school is identified as persistently dangerous in accordance with state definition.', CedsConnectionName = 'FS130 – ESEA Status (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4347
		END
 
		-----------------------------------------
		-- FS190 — Charter Authorizer Directory (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4348)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The data collected using this file specification are required to ensure completeness of data on charter schools and authorizers','FS190 — Charter Authorizer Directory (Generate) SY 2019-20','SLDS State Support Team',4348)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The data collected using this file specification are required to ensure completeness of data on charter schools and authorizers', CedsConnectionName = 'FS190 — Charter Authorizer Directory (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4348
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS175: Academic Achievement in Mathematics (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4349)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in mathematics and for whom a proficiency level was assigned.','IDEA 618 Report | FS175: Academic Achievement in Mathematics (Generate) SY 2019-20','CIID',4349)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in mathematics and for whom a proficiency level was assigned.', CedsConnectionName = 'IDEA 618 Report | FS175: Academic Achievement in Mathematics (Generate) SY 2019-20', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 4349
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS178: Academic Achievement in Reading (Language Arts) (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4350)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.','IDEA 618 Report | FS178: Academic Achievement in Reading (Language Arts) (Generate) SY 2019-20','CIID',4350)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in reading/language arts for whom a proficiency level was assigned.', CedsConnectionName = 'IDEA 618 Report | FS178: Academic Achievement in Reading (Language Arts) (Generate) SY 2019-20', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 4350
		END
 
		-----------------------------------------
		-- FS179 - Academic Achievement in Science (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4351)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who completed the state assessment in science and for whom a proficiency level was assigned.','FS179 - Academic Achievement in Science (Generate) SY 2019-20','SLDS State Support Team',4351)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who completed the state assessment in science and for whom a proficiency level was assigned.', CedsConnectionName = 'FS179 - Academic Achievement in Science (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4351
		END
 
		-----------------------------------------
		-- FS142 — CTE Concentrators Academic Achievement (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4352)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The number of CTE concentrators who left secondary education during the school year for whom a proficiency score on the state assessment was included in the state’s calculation of adequate yearly progress (AYP).','FS142 — CTE Concentrators Academic Achievement (Generate) SY 2019-20','SLDS State Support Team',4352)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The number of CTE concentrators who left secondary education during the school year for whom a proficiency score on the state assessment was included in the state’s calculation of adequate yearly progress (AYP).', CedsConnectionName = 'FS142 — CTE Concentrators Academic Achievement (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4352
		END
 
		-----------------------------------------
		-- FS154 — CTE Concentrators in Graduation Rate (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4353)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who were included in the state’s computation of its graduation rate as described in section 1111 (b)(2)(C)(vi) of the ESEA, as amended.','FS154 — CTE Concentrators in Graduation Rate (Generate) SY 2019-20','SLDS State Support Team',4353)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who were included in the state’s computation of its graduation rate as described in section 1111 (b)(2)(C)(vi) of the ESEA, as amended.', CedsConnectionName = 'FS154 — CTE Concentrators in Graduation Rate (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4353
		END
 
		-----------------------------------------
		-- FS154 - CTE Concentrators in Graduation Rate (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4354)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who were included in the state’s computation of its graduation rate as described in section 1111 (b)(2)(C)(vi) of the ESEA, as amended.','FS154 - CTE Concentrators in Graduation Rate (Generate) SY 2019-20','SLDS State Support Team',4354)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who were included in the state’s computation of its graduation rate as described in section 1111 (b)(2)(C)(vi) of the ESEA, as amended.', CedsConnectionName = 'FS154 - CTE Concentrators in Graduation Rate (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4354
		END
 
		-----------------------------------------
		-- FS154 — CTE Concentrators in Graduation Rate (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4355)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who were included in the state’s computation of its graduation rate as described in section 1111 (b)(2)(C)(vi) of the ESEA, as amended.','FS154 — CTE Concentrators in Graduation Rate (Generate) SY 2019-20','SLDS State Support Team',4355)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who were included in the state’s computation of its graduation rate as described in section 1111 (b)(2)(C)(vi) of the ESEA, as amended.', CedsConnectionName = 'FS154 — CTE Concentrators in Graduation Rate (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4355
		END
 
		-----------------------------------------
		-- FS158 - CTE Concentrators Placement (Generate) 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  4356)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of CTE concentrators who left secondary education in the cohort which graduated the prior program year.','FS158 - CTE Concentrators Placement (Generate) 2019-20','SLDS State Support Team',4356)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of CTE concentrators who left secondary education in the cohort which graduated the prior program year.', CedsConnectionName = 'FS158 - CTE Concentrators Placement (Generate) 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 4356
		END
 
		-----------------------------------------
		-- FS050: Title III English Language Proficiency Results (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5355)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of English learners who were assessed on the annual state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA, as amended, funds','FS050: Title III English Language Proficiency Results (Generate) SY 2019-20','SLDS State Support Team',5355)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of English learners who were assessed on the annual state English language proficiency assessment and who received services in an English language instruction educational program supported with Title III of ESEA, as amended, funds', CedsConnectionName = 'FS050: Title III English Language Proficiency Results (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 5355
		END
 
		-----------------------------------------
		-- FS118 - Homeless Students Enrolled (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5356)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of homeless students enrolled in public schools at any time during the school year.','FS118 - Homeless Students Enrolled (Generate) SY 2019-20','SLDS State Support Team',5356)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of homeless students enrolled in public schools at any time during the school year.', CedsConnectionName = 'FS118 - Homeless Students Enrolled (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 5356
		END
 
		-----------------------------------------
		-- FS137 - English Language Proficiency Test (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5357)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of English learners who were enrolled at the time of the state annual English language proficiency assessment.','FS137 - English Language Proficiency Test (Generate) SY 2019-20','SLDS State Support Team',5357)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of English learners who were enrolled at the time of the state annual English language proficiency assessment.', CedsConnectionName = 'FS137 - English Language Proficiency Test (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 5357
		END
 
		-----------------------------------------
		-- State Appropriations for Charter Schools
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5363)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('How charter schools receive state appropriations.','State Appropriations for Charter Schools','SLDS State Support Team',5363)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'How charter schools receive state appropriations.', CedsConnectionName = 'State Appropriations for Charter Schools', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 5363
		END
 
		-----------------------------------------
		-- FS207 - State Appropriations for Charter Schools 2019-20 (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5364)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('How charter schools receive state appropriations.','FS207 - State Appropriations for Charter Schools 2019-20 (Generate)','SLDS State Support Team ',5364)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'How charter schools receive state appropriations.', CedsConnectionName = 'FS207 - State Appropriations for Charter Schools 2019-20 (Generate)', CedsConnectionSource = 'SLDS State Support Team '
			where CedsUseCaseId = 5364
		END
 
		-----------------------------------------
		-- FS209 - CTE Enrollment 19-20 (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5365)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The data are being collected for the Consolidated Annual Performance (CAR), Accountability, and Financial Status Report for the State Basic Grant Program under the Carl D. Perkins Vocational and Technical Education Act (Perkins V).  This measure is CTE concentrator enrollment.','FS209 - CTE Enrollment 19-20 (Generate)','SLDS State Support Team',5365)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The data are being collected for the Consolidated Annual Performance (CAR), Accountability, and Financial Status Report for the State Basic Grant Program under the Carl D. Perkins Vocational and Technical Education Act (Perkins V).  This measure is CTE concentrator enrollment.', CedsConnectionName = 'FS209 - CTE Enrollment 19-20 (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 5365
		END
 
		-----------------------------------------
		-- CCD Report | FS033 Generate: Free and Reduced Price Lunch (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5368)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS033, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS033 Generate: Free and Reduced Price Lunch (Generate) SY 2019-20','SLDS State Support Team',5368)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS033, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS033 Generate: Free and Reduced Price Lunch (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 5368
		END
 
		-----------------------------------------
		-- CCD Report | FS052: Membership (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5369)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS052, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS052: Membership (Generate) SY 2019-20','SLDS State Support Team',5369)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS052, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS052: Membership (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 5369
		END
 
		-----------------------------------------
		-- CCD Report | FS129: CCD Schools (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5370)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS129, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS129: CCD Schools (Generate) SY 2019-20','SLDS State Support Team',5370)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS129, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS129: CCD Schools (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 5370
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS185: Assessment Participation in Mathematics (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5371)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in mathematics.','IDEA 618 Report | FS185: Assessment Participation in Mathematics (Generate) SY 2019-20','CIID',5371)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in mathematics.', CedsConnectionName = 'IDEA 618 Report | FS185: Assessment Participation in Mathematics (Generate) SY 2019-20', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 5371
		END
 
		-----------------------------------------
		-- IDEA 618 Report | FS188: Assessment Participation in Reading/Language Arts (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5372)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.','IDEA 618 Report | FS188: Assessment Participation in Reading/Language Arts (Generate) SY 2019-20','CIID',5372)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in reading/language arts.', CedsConnectionName = 'IDEA 618 Report | FS188: Assessment Participation in Reading/Language Arts (Generate) SY 2019-20', CedsConnectionSource = 'CIID'
			where CedsUseCaseId = 5372
		END
 
		-----------------------------------------
		-- FS189 – Assessment Participation in Science (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5373)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of students who were enrolled during the period of the state assessment in science.','FS189 – Assessment Participation in Science (Generate) SY 2019-20','SLDS State Support Team',5373)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of students who were enrolled during the period of the state assessment in science.', CedsConnectionName = 'FS189 – Assessment Participation in Science (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 5373
		END
 
		-----------------------------------------
		-- FS197 — Crosswalk of Charter Schools to Management Organizations (Generate) 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5374)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The data collected using this file specification are gathered to provide the Charter School Program Office of the U.S. Department of Education insight into the extent and scope of the relationships between CMOs and EMOs with charter schools.','FS197 — Crosswalk of Charter Schools to Management Organizations (Generate) 2019-20','SLDS State Support Team',5374)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The data collected using this file specification are gathered to provide the Charter School Program Office of the U.S. Department of Education insight into the extent and scope of the relationships between CMOs and EMOs with charter schools.', CedsConnectionName = 'FS197 — Crosswalk of Charter Schools to Management Organizations (Generate) 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 5374
		END
 
		-----------------------------------------
		-- FS198 — Charter Contracts (Generate) 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5375)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The data collected using this file specification are to enable OII/CSP to obtain a complete list of charter schools in the United States. OII/CSP goes through a complex reconciliation process to compile a directory of all charter schools that are in operation across the nation. These data will fill in the data gaps so that for each school year OII/CSP has a complete and accurate directory of charter schools.','FS198 — Charter Contracts (Generate) 2019-20','SLDS State Support Team',5375)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The data collected using this file specification are to enable OII/CSP to obtain a complete list of charter schools in the United States. OII/CSP goes through a complex reconciliation process to compile a directory of all charter schools that are in operation across the nation. These data will fill in the data gaps so that for each school year OII/CSP has a complete and accurate directory of charter schools.', CedsConnectionName = 'FS198 — Charter Contracts (Generate) 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 5375
		END
 
		-----------------------------------------
		-- FS212 — Comprehensive Support and Targeted Support Identification SY 2019-20 (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5376)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('FS212 captures the reasons for identification of schools reported in FS206 as "comprehensive support and improvement (CSI)" and the reasons for identification as "targeted support and improvement (TSI) and/or Additional Targeted Support and Improvement (ATSI)."','FS212 — Comprehensive Support and Targeted Support Identification SY 2019-20 (Generate)','SLDS State Support Team',5376)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'FS212 captures the reasons for identification of schools reported in FS206 as "comprehensive support and improvement (CSI)" and the reasons for identification as "targeted support and improvement (TSI) and/or Additional Targeted Support and Improvement (ATSI)."', CedsConnectionName = 'FS212 — Comprehensive Support and Targeted Support Identification SY 2019-20 (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 5376
		END
 
		-----------------------------------------
		-- CCD Report | FS141: LEP Enrolled (Generate) SY 2019-20
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5381)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS141, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS141: LEP Enrolled (Generate) SY 2019-20','SLDS State Support Team',5381)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS141, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS141: LEP Enrolled (Generate) SY 2019-20', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 5381
		END
 
		-----------------------------------------
		-- FS035 - Federal Programs (Generate) 2017-18
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  5411)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The amount of federal dollars distributed to local education agencies (LEAs), retained by the state education agency (SEA) for program administration or other approved state-level activities (including unallocated, transferred to another state agency, or distributed to entities other than LEAs).','FS035 - Federal Programs (Generate) 2017-18','SLDS State Support Team',5411)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The amount of federal dollars distributed to local education agencies (LEAs), retained by the state education agency (SEA) for program administration or other approved state-level activities (including unallocated, transferred to another state agency, or distributed to entities other than LEAs).', CedsConnectionName = 'FS035 - Federal Programs (Generate) 2017-18', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 5411
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