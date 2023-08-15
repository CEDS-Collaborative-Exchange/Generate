/*
-- To generate metadata refresh script, run this on DAT on 192.168.51.20
-- Make sure the DAT database was recently refreshed from production

-- TODO - rather than hard-coding the UseCaseId, it would be better to find a way to filter off of the name or source
-- so that this script does not need to be updated when new file specs are added

print 'set nocount off'
print 'begin try'
print '	begin transaction'
print ''
print '		declare @singleQuote as varchar = '''''''''

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
		WHERE UseCaseId  in 
		(	
			771,	--indicator4b
			770,	--indicator4a
			782,	--c188
			781,	--c185
			780,	--c178
			779,	--c175
			796,	--c144
			793,	--c143
			787,	--c112
			788,	--c099
			786,	--c089
			768,	--indicator9
			792,	--c088
			790,	--c009
			795,	--c007
			791,	--c006
			794,	--c005
			785,	--c002
			789,	--c070
			769,	--indicator10
			2908,	--exitspecialeducation
			2907,	--cohortgraduationrate
			2893,	--studentfederalprogramsparticipation
			2902,	--disciplinaryremovals
			2899,	--stateassessmentsperformance
			2969,	--c029
			103,	--c032
			2964,	--c033
			599,	--c036
			2959,	--c037
			649,	--c039
			102,	--c040
			2984,	--c052
			2966,	--c054
			2958,	--c059
			2986,	--c065
			2967,	--c121
			2987,	--c122
			2955,	--c129
			2960,	--c134
			2965,	--c141
			2988,	--c145
			2968,	--c165
			2971,	--c193	
			3065,	--c045
			3066,	--c050
			3069,	--c116
			3070,	--c126
			3068,	--c138
			3071,	--c204
			3076,	--c205
			3073,	--c137
			3075	--c139								
		)
OPEN UseCase_Cursor
FETCH NEXT FROM UseCase_Cursor INTO @UseCaseId, @UsecaseDefinition,@TitleQuestion,@Source
WHILE @@FETCH_STATUS = 0
BEGIN
set @UsecaseDefinition = rtrim(ltrim(replace(replace(replace(@UsecaseDefinition, '''', '\"'), char(13), ' '), char(10), ' ')))	
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


set nocount on
begin try
	begin transaction
 
		declare @singleQuote as varchar = ''''
 
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
		-- IDEA 618 Report | C089: Children with Disabilities (IDEA) Early Childhood (Generate) 2016-17
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  786)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('The unduplicated number of children with disabilities (IDEA) ages 3 through 5.','IDEA 618 Report | C089: Children with Disabilities (IDEA) Early Childhood (Generate) 2016-17','CIID',786)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'The unduplicated number of children with disabilities (IDEA) ages 3 through 5.', CedsConnectionName = 'IDEA 618 Report | C089: Children with Disabilities (IDEA) Early Childhood (Generate) 2016-17', CedsConnectionSource = 'CIID'
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
		-- CCD Report | FS129: CCD Schools (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2955)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS129: CCD Schools (Generate)','SLDS State Support Team',2955)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS129: CCD Schools (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2955
		END
 
		-----------------------------------------
		-- CCD Report | FS059: Staff FTE (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2958)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and CIID.','CCD Report | FS059: Staff FTE (Generate)','SLDS State Support Team',2958)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and CIID.', CedsConnectionName = 'CCD Report | FS059: Staff FTE (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2958
		END
 
		-----------------------------------------
		-- CSPR II Report | FS037: Title I Part A SWP/TAS Participation (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2959)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS037: Title I Part A SWP/TAS Participation (Generate)','SLDS State Support Team',2959)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS037: Title I Part A SWP/TAS Participation (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2959
		END
 
		-----------------------------------------
		-- CSPR II Report | FS134: Title I Part A Participation (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2960)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS134: Title I Part A Participation (Generate)','SLDS State Support Team',2960)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS134: Title I Part A Participation (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2960
		END
 
		-----------------------------------------
		-- CCD Report | FS033 Generate: Free and Reduced Price Lunch (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2964)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS033 Generate: Free and Reduced Price Lunch (Generate)','SLDS State Support Team',2964)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS033 Generate: Free and Reduced Price Lunch (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2964
		END
 
		-----------------------------------------
		-- CCD Report | FS141: LEP Enrolled (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2965)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS141: LEP Enrolled (Generate)','SLDS State Support Team',2965)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS141: LEP Enrolled (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2965
		END
 
		-----------------------------------------
		-- CSPR II Report | FS054: MEP Students Served - 12 Months (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2966)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS054: MEP Students Served - 12 Months (Generate)','SLDS State Support Team',2966)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS054: MEP Students Served - 12 Months (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2966
		END
 
		-----------------------------------------
		-- CSPR II Report | FS121: Migratory Students Eligible - 12 Months  (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2967)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS121: Migratory Students Eligible - 12 Months  (Generate)','SLDS State Support Team',2967)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS121: Migratory Students Eligible - 12 Months  (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2967
		END
 
		-----------------------------------------
		-- CSPR II Report | FS165: Migratory Data (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2968)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS165: Migratory Data (Generate)','SLDS State Support Team',2968)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS165: Migratory Data (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2968
		END
 
		-----------------------------------------
		-- CCD Report | FS029: Directory (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2969)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS029: Directory (Generate)','SLDS State Support Team',2969)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS029: Directory (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2969
		END
 
		-----------------------------------------
		-- CSPR II Report | FS193: Title I Allocations (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2971)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS193: Title I Allocations (Generate)','SLDS State Support Team',2971)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS193: Title I Allocations (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2971
		END
 
		-----------------------------------------
		-- CCD Report | FS052: Membership (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2984)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CCD Report | FS052: Membership (Generate)','SLDS State Support Team',2984)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CCD Report | FS052: Membership (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2984
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
		-- CSPR II Report | FS122: MEP Students Eligible and Served – Summer/Intersession (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2987)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS122: MEP Students Eligible and Served – Summer/Intersession (Generate)','SLDS State Support Team',2987)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS122: MEP Students Eligible and Served – Summer/Intersession (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2987
		END
 
		-----------------------------------------
		-- CSPR II Report | FS145: MEP Services (Generate)
		-----------------------------------------
 
		IF NOT EXISTS (Select 1 from app.[CedsConnections] where [CedsUseCaseId] =  2988)
		BEGIN
			INSERT INTO app.cedsConnections
			([CedsConnectionDescription],[CedsConnectionName],[CedsConnectionSource],[CedsUseCaseId])
			VALUES
			('Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).','CSPR II Report | FS145: MEP Services (Generate)','SLDS State Support Team',2988)
		END
		ELSE
		BEGIN
			update App.CedsConnections
			set CedsConnectionDescription = 'Connection for Generate, EDFacts File FS029, created in collaboration with the EDFacts Partner Support Center (PSC) and the Center for the Integration of IDEA Data (CIID).', CedsConnectionName = 'CSPR II Report | FS145: MEP Services (Generate)', CedsConnectionSource = 'SLDS State Support Team'
			where CedsUseCaseId = 2988
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
