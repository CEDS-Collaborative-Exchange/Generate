	declare	@dimSchoolYearId INT 
	declare @dimFactTypeId as int
	set @dimFactTypeId = 3
 
	set @dimSchoolYearId = 24
	declare @SubmissionYear INT
	SELECT @SubmissionYear = SchoolYear
	FROM RDS.DimSchoolYears
	WHERE DimSchoolYearId = @dimSchoolYearId
 
	---------------------------					
	-- Permitted Values
	---------------------------
	IF OBJECT_ID('tempdb..#PermittedValues') IS NOT NULL DROP TABLE #PermittedValues
	
	create table #PermittedValues (
		  Code varchar(100)
		, CategoryCode varchar(100)
	)
					 
	DELETE FROM #PermittedValues
			
	insert into #PermittedValues
	SELECT distinct 
		  o.CategoryOptionCode
		, c.CategoryCode
	from app.CategoryOptions o
	join app.Categories c 
		on o.CategoryId = c.CategoryId
	join app.CategorySet_Categories csc
		on c.CategoryId = csc.CategoryId
	join app.CategorySets cs
		on csc.CategorySetId = cs.CategorySetId
		and cs.SubmissionYear = 2023
	join app.GenerateReports gr
		on cs.GenerateReportId = gr.GenerateReportId
	where gr.ReportCode = 'c002'
					
	-----------------------------------------------
	-- Select valid student records for aggregation
	-----------------------------------------------
	IF OBJECT_ID('tempdb..#categoryset') IS NOT NULL DROP TABLE #categoryset

	create table #categorySet (	
		  DimSeaId int
		, DimLeaId int
		, DimK12SchoolId int
		, DimStudentId int
		, K12StudentStudentIdentifierState varchar(50)
		, DISABCATIDEA varchar(100)
		, RACEETHNIC varchar(100)
		, SEX varchar(100)
		, AGESA varchar(100)
		, EDENVIRIDEASA varchar(100)
		, LEPBOTH varchar(100)
		, StudentCount int
	) 
								
	CREATE INDEX IDX_CategorySet_DimSeaId ON #CategorySet (DimSeaId)
	CREATE INDEX IDX_CategorySet_DimLeaId ON #CategorySet (DimSeaId)
	CREATE INDEX IDX_CategorySet_DimK12SchoolId ON #CategorySet (DimSeaId)
						
 
	truncate table #categorySet
 
 
	-- Actual Counts
	insert into #categorySet (
		  DimSeaId
		, DimLeaId
		, DimK12SchoolId
		, DimStudentId
		, K12StudentStudentIdentifierState
		, DISABCATIDEA
		, RACEETHNIC
		, SEX
		, AGESA
		, EDENVIRIDEASA
		, LEPBOTH
		, StudentCount)
	select  
		  fact.SeaId
		, fact.LeaId
		, fact.K12SchoolId
		, fact.K12StudentId
		, rdp.K12StudentStudentIdentifierState
		, rdidt.IdeaDisabilityTypeEdFactsCode
		, rdr.RaceEdFactsCode
		, rdkd.SexEdFactsCode
		, rda.AgeEdFactsCode
		, rdis.IdeaEducationalEnvironmentForSchoolAgeEdFactsCode
		, rdels.EnglishLearnerStatusEdFactsCode
		, isnull(fact.StudentCount, 0)
	from rds.FactK12StudentCounts fact 
	join RDS.DimIdeaStatuses rdis 
		on fact.IdeaStatusId = rdis.DimIdeaStatusId
		AND rdis.IdeaIndicatorEdFactsCode = 'IDEA'
		AND rdis.IdeaEducationalEnvironmentForSchoolAgeCode IN (SELECT Code FROM #PermittedValues WHERE CategoryCode = 'EDENVIRIDEASA')
	JOIN RDS.DimAges rda
		ON fact.AgeId = rda.DimAgeId
		AND rda.AgeValue >= 5 and rda.AgeValue <= 21
		AND rda.AgeEdFactsCode IN (SELECT Code FROM #PermittedValues WHERE CategoryCode = 'AGESA')
	join rds.DimGradeLevels rdgl
		on fact.GradeLevelId = rdgl.DimGradeLevelId
		and (CASE WHEN rda.AgeValue = 5 and rdgl.GradeLevelEdFactsCode in ('MISSING','PK')
			THEN ''
			ELSE rdgl.GradeLevelEdFactsCode
			END) = rdgl.GradeLevelEdFactsCode
	join RDS.DimIdeaDisabilityTypes rdidt 
		on fact.PrimaryDisabilityTypeId = rdidt.DimIdeaDisabilityTypeId
		AND rdidt.IdeaDisabilityTypeEdFactsCode IN (SELECT Code FROM #PermittedValues WHERE CategoryCode = 'DISABCATIDEA')
	join rds.DimRaces rdr 
		on fact.RaceId = rdr.DimRaceId 
		AND rdr.RaceEdFactsCode IN (SELECT Code FROM #PermittedValues WHERE CategoryCode = 'RACEETHNIC')
	join RDS.DimK12Demographics rdkd 
		on fact.K12DemographicId = rdkd.DimK12DemographicId
		AND rdkd.SexEdFactsCode IN (SELECT Code FROM #PermittedValues WHERE CategoryCode = 'SEX')
	join RDS.DimEnglishLearnerStatuses rdels
		on fact.EnglishLearnerStatusId = rdels.DimEnglishLearnerStatusId
		AND rdels.EnglishLearnerStatusEdFactsCode IN (SELECT Code FROM #PermittedValues WHERE CategoryCode = 'LEPBOTH')
	join RDS.DimPeople rdp
		ON fact.K12StudentId = rdp.DimPersonId
	WHERE fact.FactTypeId = @dimFactTypeId
		AND fact.SchoolYearId = @dimSchoolYearId  


																			
	--select * from #categorySet	
				
				
	----------------------------
	-- Remove Missing Counts
	----------------------------
	--exec RDS.RemoveMissingValues 'C002', @SubmissionYear, 'K12StudentStudentIdentifierState'
	exec RDS.RemoveMissingValues 'C002', '2023', 'K12StudentStudentIdentifierState'

	-- Remove DD counts for invalid ages
	delete from #categorySet where DISABCATIDEA = 'DD'
					
 
	----------------------------
	-- Create Debugging Tables
	----------------------------
	--exec RDS.CreateDebugTables 'C002', @SubmissionYear, 'K12StudentStudentIdentifierState'
	exec RDS.CreateDebugTables 'C002', '2023', 'K12StudentStudentIdentifierState'

	-- insert sea sql
	exec RDS.InsertCountsIntoReportTable 'C002', '2023', 'ReportEDFactsK12StudentCounts', 'K12StudentStudentIdentifierState', 'StudentCount', 1
