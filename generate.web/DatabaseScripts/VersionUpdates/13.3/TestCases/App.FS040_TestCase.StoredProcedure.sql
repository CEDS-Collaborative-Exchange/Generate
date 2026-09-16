create PROCEDURE [App].[FS040_TestCase]	
--declare	
@SchoolYear SMALLINT
--= 2023
AS
BEGIN

	/***************************************************************
	CSA = Diploma/Credential, Sex, Race
	CSB = Diploma/Credential, Sex, Disability Status
	CSC = Diploma/Credential, Sex, English Learner Status
	CSD = Diploma/Credential, Economically Disadvantaged Status
	CSE = Diploma/Credential, Migratory Status
	CSF = Diploma/Credential, Homeless Enrolled Status
	ST1 = Diploma/Credential
	TOT = Total
	****************************************************************/

	IF OBJECT_ID('tempdb..#Staging') IS NOT NULL DROP TABLE #Staging
	IF OBJECT_ID('tempdb..#SEA_CSA') IS NOT NULL DROP TABLE #SEA_CSA
	IF OBJECT_ID('tempdb..#SEA_CSB') IS NOT NULL DROP TABLE #SEA_CSB
	IF OBJECT_ID('tempdb..#SEA_CSC') IS NOT NULL DROP TABLE #SEA_CSC
	IF OBJECT_ID('tempdb..#SEA_CSD') IS NOT NULL DROP TABLE #SEA_CSD
	IF OBJECT_ID('tempdb..#SEA_CSE') IS NOT NULL DROP TABLE #SEA_CSE
	IF OBJECT_ID('tempdb..#SEA_CSF') IS NOT NULL DROP TABLE #SEA_CSF
	IF OBJECT_ID('tempdb..#SEA_ST1') IS NOT NULL DROP TABLE #SEA_ST1
	IF OBJECT_ID('tempdb..#SEA_TOT') IS NOT NULL DROP TABLE #SEA_TOT

	IF OBJECT_ID('tempdb..#LEA_CSA') IS NOT NULL DROP TABLE #LEA_CSA
	IF OBJECT_ID('tempdb..#LEA_CSB') IS NOT NULL DROP TABLE #LEA_CSB
	IF OBJECT_ID('tempdb..#LEA_CSC') IS NOT NULL DROP TABLE #LEA_CSC
	IF OBJECT_ID('tempdb..#LEA_CSD') IS NOT NULL DROP TABLE #LEA_CSD
	IF OBJECT_ID('tempdb..#LEA_CSE') IS NOT NULL DROP TABLE #LEA_CSE
	IF OBJECT_ID('tempdb..#LEA_CSF') IS NOT NULL DROP TABLE #LEA_CSF
	IF OBJECT_ID('tempdb..#LEA_ST1') IS NOT NULL DROP TABLE #LEA_ST1
	IF OBJECT_ID('tempdb..#LEA_TOT') IS NOT NULL DROP TABLE #LEA_TOT

	IF OBJECT_ID('tempdb..#SCH_CSA') IS NOT NULL DROP TABLE #SCH_CSA
	IF OBJECT_ID('tempdb..#SCH_CSB') IS NOT NULL DROP TABLE #SCH_CSB
	IF OBJECT_ID('tempdb..#SCH_CSC') IS NOT NULL DROP TABLE #SCH_CSC
	IF OBJECT_ID('tempdb..#SCH_CSD') IS NOT NULL DROP TABLE #SCH_CSD
	IF OBJECT_ID('tempdb..#SCH_CSE') IS NOT NULL DROP TABLE #SCH_CSE
	IF OBJECT_ID('tempdb..#SCH_CSF') IS NOT NULL DROP TABLE #SCH_CSF
	IF OBJECT_ID('tempdb..#SCH_ST1') IS NOT NULL DROP TABLE #SCH_ST1
	IF OBJECT_ID('tempdb..#SCH_TOT') IS NOT NULL DROP TABLE #SCH_TOT


	DECLARE 
		@UnitTestName VARCHAR(100) = 'FS040_UnitTestCase',
		@StoredProcedureName VARCHAR(100) = 'FS040_TestCase',
		@TestScope VARCHAR(1000) = 'FS040',
		@ReportCode VARCHAR(20) = '040',
		
		@CategorySet varchar(5) = '',
		@ReportLevel varchar(5) = ''
 


	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = @UnitTestName) 
	BEGIN
		SET @expectedResult = 1
		INSERT INTO App.SqlUnitTest 
		(
			  [UnitTestName]
			, [StoredProcedureName]
			, [TestScope]
			, [IsActive]
		)
		VALUES 
		(
			  @UnitTestName
			, @StoredProcedureName				
			, @TestScope
			, 1
		)
		SET @SqlUnitTestId = SCOPE_IDENTITY() --34
	END 
	ELSE 
	BEGIN
		SELECT 
			@SqlUnitTestId = SqlUnitTestId
		--, @expectedResult = ExpectedResult 
		FROM App.SqlUnitTest 
		WHERE UnitTestName = @UnitTestName
	END

	-- Clear out last run
	DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
		--Set the reporting period as 10-01 to 09-30
		DECLARE @ReportingStartDate Date = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-10-01'AS DATE)
		DECLARE @ReportingEndDate Date = CAST(CAST(@SchoolYear AS CHAR(4)) + '-09-30'AS DATE)

		--DROP TABLE #staging 
		IF OBJECT_ID('tempdb..#staging') IS NOT NULL
		DROP TABLE #staging

		IF OBJECT_ID('tempdb..#vwStudentDetails') IS NOT NULL
		DROP TABLE #vwStudentDetails

		IF OBJECT_ID('tempdb..#vwDiplomaType') IS NOT NULL
		DROP TABLE #vwDiplomaType

		select vaward.SchoolYear, vaward.HighSchoolDiplomaTypeCode, vaward.HighSchoolDiplomaTypeMap, award.HighSchoolDiplomaTypeEdFactsCode 
		into #vwDiplomaType
		from RDS.vwDimK12AcademicAwardStatuses vaward
		inner join RDS.DimK12AcademicAwardStatuses award
			on vaward.SchoolYear = @SchoolYear
			and vaward.HighSchoolDiplomaTypeCode = award.HighSchoolDiplomaTypeCode


		select SchoolYear, StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, EnrollmentEntryDate,
			GradeLevel_STG, Grade_SSRDOut, 
			case when GradeLevelEdFactsCode in ('PK', 'KG', '01', '02', '03', '04', '05', '06') then 'BELOW7' else GradeLevelEdFactsCode end GradeLevelEdFactsCode,
			IDEAIndicator_STG, IDEAIndicatorEdFactsCode, 
			case IDEAIndicatorEdFactsCode when 'IDEA' then 'WDIS' when 'No' then 'WODIS' else 'MISSING' end as DisabilityStatus,
			Race_STG, Race_SSRDOut, RaceEdFactsCode,
			Sex_STG, Sex_SSRDOut, SexEdFactsCode,
			ELStatus_STG, EnglishLearnerStatusEdFactsCode
		into #vwStudentDetails
		from debug.vwStudentDetails vw
		where SchoolYear = @SchoolYear

		--select * from #vwStudentDetails

		-- #Staging table should have the entire population of students and attributes needed for the test cases
		select vsd.*, 
			case when eco.EconomicDisadvantageStatus = 1 then 'ECODIS' else '' end EconomicDisadvantageStatusEdFactsCode,
			case when migrant.MigrantStatus = 1 then 'MS' else '' end MigrantStatusEdFactsCode,
			case when homeless.HomelessnessStatus = 1 then 'HOMELSENRL' else '' end HomelessnessStatusEdFactsCode,
			award.HighSchoolDiplomaTypeEdFactsCode
		into #staging
		from #vwStudentDetails vsd
		inner join staging.K12Enrollment ske
			on vsd.StudentIdentifierState = ske.StudentIdentifierState
			and vsd.LeaIdentifierSeaAccountability = ske.LeaIdentifierSeaAccountability
			and vsd.SchoolIdentifierSea = ske.SchoolIdentifierSea
			and vsd.schoolyear = ske.SchoolYear
			and vsd.EnrollmentEntryDate = ske.EnrollmentEntryDate

		JOIN RDS.DimSeas rds
			ON vsd.EnrollmentEntryDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, GETDATE())
		JOIN RDS.DimLeas rdl
			ON ske.LeaIdentifierSeaAccountability = rdl.LeaIdentifierSea
			AND ske.EnrollmentEntryDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, GETDATE())

		JOIN RDS.DimK12Schools rdksch
			ON ske.SchoolIdentifierSea = rdksch.SchoolIdentifierSea
			AND ske.EnrollmentEntryDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, GETDATE())

		--JOIN RDS.vwDimK12AcademicAwardStatuses AAS
		--	on AAS.SchoolYear = ske.SchoolYear
		--	and AAS.HighSchoolDiplomaTypeMap = ske.HighSchoolDiplomaType

		JOIN #vwDiplomaType award
			on ske.HighSchoolDiplomaType = award.HighSchoolDiplomaTypeMap
			and award.HighSchoolDiplomaTypeEdFactsCode in ('REGDIP', 'OTHCOM') 


		left join staging.PersonStatus eco
			on ske.StudentIdentifierState = eco.StudentIdentifierState
			and ske.LeaIdentifierSeaAccountability = eco.LeaIdentifierSeaAccountability
			and ske.SchoolIdentifierSea = eco.SchoolIdentifierSea
			AND ((eco.EconomicDisadvantage_StatusStartDate BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (eco.EconomicDisadvantage_StatusStartDate < @ReportingStartDate AND ISNULL(eco.EconomicDisadvantage_StatusEndDate, GETDATE()) > @ReportingStartDate))

		left join staging.PersonStatus migrant
			on ske.StudentIdentifierState = migrant.StudentIdentifierState
			and ske.LeaIdentifierSeaAccountability = migrant.LeaIdentifierSeaAccountability
			and ske.SchoolIdentifierSea = migrant.SchoolIdentifierSea
			AND ((migrant.Migrant_StatusStartDate BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (migrant.Migrant_StatusStartDate < @ReportingStartDate AND ISNULL(migrant.Migrant_StatusEndDate, GETDATE()) > @ReportingStartDate))

	--homelessness
		LEFT JOIN Staging.PersonStatus homeless 
			ON ske.StudentIdentifierState = homeless.StudentIdentifierState
			AND ISNULL(ske.LEAIdentifierSeaAccountability, '') = ISNULL(homeless.LEAIdentifierSeaAccountability, '') 
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(homeless.SchoolIdentifierSea, '')
			AND homeless.HomelessnessStatus = 1
			AND ((homeless.Homelessness_StatusStartDate BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (homeless.Homelessness_StatusStartDate < @ReportingStartDate AND ISNULL(homeless.Homelessness_StatusEndDate, GETDATE()) > @ReportingStartDate))


		where
		((ske.EnrollmentEntryDate BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (ske.EnrollmentEntryDate < @ReportingStartDate AND ISNULL(ske.EnrollmentExitDate, GETDATE()) > @ReportingStartDate))
			AND ske.HighSchoolDiplomaType is not null


-- CSA --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSA'

		/******************************************************* 
		Student Count by:
			Diploma/Credential, Sex, Race
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			 HighSchoolDiplomaTypeEdFactsCode, RaceEdFactsCode, SexEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSA
		FROM #staging 
		GROUP BY HighSchoolDiplomaTypeEdFactsCode, RaceEdFactsCode, SexEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  Race: ' + s.RaceEdFactsCode + '  Sex: ' + s.SexEdFactsCode
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SEA_CSA s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode	
			and Fact.RACE = s.RaceEdFactsCode
			and Fact.SEX = s.SexEdFactsCode


	-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			 HighSchoolDiplomaTypeEdFactsCode, RaceEdFactsCode, SexEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSA
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			HighSchoolDiplomaTypeEdFactsCode, RaceEdFactsCode, SexEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  ' +
			'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  Race: ' + s.RaceEdFactsCode + '  Sex: ' + s.SexEdFactsCode
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LEA_CSA s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.RACE = s.RaceEdFactsCode
			and Fact.SEX = s.SexEdFactsCode
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability


		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			 HighSchoolDiplomaTypeEdFactsCode, RaceEdFactsCode, SexEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSA
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			HighSchoolDiplomaTypeEdFactsCode, RaceEdFactsCode, SexEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'SchoolIdentifierSEA: ' + s.SchoolIdentifierSea + '  ' +
			'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  Race: ' + s.RaceEdFactsCode + '  Sex: ' + s.SexEdFactsCode
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSA s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.RACE = s.RaceEdFactsCode
			and Fact.SEX = s.SexEdFactsCode
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea


-- CSB --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSB'

		/******************************************************* 
		Student Count by:
		Diploma/Credential, Sex, Disability Status
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			 HighSchoolDiplomaTypeEdFactsCode, DisabilityStatus, SexEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSB
		FROM #staging 
		GROUP BY HighSchoolDiplomaTypeEdFactsCode, DisabilityStatus, SexEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  DisabilityStatus: ' + s.DisabilityStatus + '  Sex:  ' + s.SexEdFactsCode
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SEA_CSB s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.IDEAINDICATOR = s.DisabilityStatus
			and Fact.SEX = s.SexEdFactsCode



		-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			 HighSchoolDiplomaTypeEdFactsCode, DisabilityStatus, SexEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSB
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			HighSchoolDiplomaTypeEdFactsCode, DisabilityStatus, SexEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  ' +
			'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  DisabilityStatus: ' + s.DisabilityStatus + '  Sex:  ' + s.SexEdFactsCode
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LEA_CSB s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.IDEAINDICATOR = s.DisabilityStatus
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability
			and Fact.SEX = s.SexEdFactsCode

		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			 HighSchoolDiplomaTypeEdFactsCode, DisabilityStatus, SexEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSB
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			HighSchoolDiplomaTypeEdFactsCode, DisabilityStatus, SexEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'SchoolIdentifierSEA: ' + s.SchoolIdentifierSea + '  ' + 
			'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  DisabilityStatus: ' + s.DisabilityStatus + '  Sex:  ' + s.SexEdFactsCode
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSB s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.IDEAINDICATOR = s.DisabilityStatus
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea
			and Fact.SEX = s.SexEdFactsCode


-- CSC --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSC'

		/******************************************************* 
		Student Count by:
			Diploma/Credential, English Learner Status, SexEdFactsCode
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			 HighSchoolDiplomaTypeEdFactsCode, EnglishLearnerStatusEdFactsCode, SexEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSC
		FROM #staging 
		GROUP BY HighSchoolDiplomaTypeEdFactsCode, EnglishLearnerStatusEdFactsCode, SexEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  ELStatus: ' + s.EnglishLearnerStatusEdFactsCode  + '  Sex:  ' + s.SexEdFactsCode
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SEA_CSC s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.ENGLISHLEARNERSTATUS = s.EnglishLearnerStatusEdFactsCode
			and Fact.SEX = s.SexEdFactsCode

		-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			 HighSchoolDiplomaTypeEdFactsCode, EnglishLearnerStatusEdFactsCode, SexEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSC
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			HighSchoolDiplomaTypeEdFactsCode, EnglishLearnerStatusEdFactsCode, SexEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  ' +
			'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  ELStatus: ' + s.EnglishLearnerStatusEdFactsCode  + '  Sex:  ' + s.SexEdFactsCode
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LEA_CSC s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.ENGLISHLEARNERSTATUS = s.EnglishLearnerStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability
			and Fact.SEX = s.SexEdFactsCode

		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			 HighSchoolDiplomaTypeEdFactsCode, EnglishLearnerStatusEdFactsCode, SexEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSC
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			HighSchoolDiplomaTypeEdFactsCode, EnglishLearnerStatusEdFactsCode, SexEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'SchoolIdentifierSEA: ' + s.SchoolIdentifierSea + '  ' +
			'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  ELStatus: ' + s.EnglishLearnerStatusEdFactsCode  + '  Sex:  ' + s.SexEdFactsCode
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSC s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.ENGLISHLEARNERSTATUS = s.EnglishLearnerStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea
			and Fact.SEX = s.SexEdFactsCode


-- CSD --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSD'


		/******************************************************* 
		Student Count by:
			Diploma/Credential, Economically Disadvantaged Status
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			 HighSchoolDiplomaTypeEdFactsCode, EconomicDisadvantageStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSD
		FROM #staging 
		GROUP BY HighSchoolDiplomaTypeEdFactsCode, EconomicDisadvantageStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  EcoStatus: ' + convert(varchar, s.EconomicDisadvantageStatusEdFactsCode)
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SEA_CSD s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.ECONOMICDISADVANTAGESTATUS = s.EconomicDisadvantageStatusEdFactsCode

		-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			 HighSchoolDiplomaTypeEdFactsCode, EconomicDisadvantageStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSD
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			 HighSchoolDiplomaTypeEdFactsCode, EconomicDisadvantageStatusEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  ' +
			'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  EcoStatus: ' + convert(varchar, s.EconomicDisadvantageStatusEdFactsCode)			
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LEA_CSD s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.ECONOMICDISADVANTAGESTATUS = s.EconomicDisadvantageStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability

		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			 HighSchoolDiplomaTypeEdFactsCode, EconomicDisadvantageStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSD
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			 HighSchoolDiplomaTypeEdFactsCode, EconomicDisadvantageStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'SchoolIdentifierSEA: ' + s.SchoolIdentifierSea + '  ' +
			'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  EcoStatus: ' + convert(varchar, s.EconomicDisadvantageStatusEdFactsCode) 
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSD s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.ECONOMICDISADVANTAGESTATUS = s.EconomicDisadvantageStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea

-- CSE --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSE'


		/******************************************************* 
		Student Count by:
			Diploma/Credential, Migratory Status
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			 HighSchoolDiplomaTypeEdFactsCode, MigrantStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSE
		FROM #staging 
		GROUP BY HighSchoolDiplomaTypeEdFactsCode, MigrantStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  MigrantStatus: ' + convert(varchar, s.MigrantStatusEdFactsCode)
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SEA_CSE s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.MIGRANTSTATUS = s.MigrantStatusEdFactsCode

		-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			 HighSchoolDiplomaTypeEdFactsCode, MigrantStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSE
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			 HighSchoolDiplomaTypeEdFactsCode, MigrantStatusEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  ' +
			'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  MigrantStatus: ' + convert(varchar, s.MigrantStatusEdFactsCode)			
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LEA_CSE s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.MIGRANTSTATUS = s.MigrantStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability

		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			 HighSchoolDiplomaTypeEdFactsCode, MigrantStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSE
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			 HighSchoolDiplomaTypeEdFactsCode, MigrantStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'SchoolIdentifierSEA: ' + s.SchoolIdentifierSea + '  ' +
			'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  MigrantStatus: ' + convert(varchar, s.MigrantStatusEdFactsCode) 
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSE s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.MIGRANTSTATUS = s.MigrantStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea


-- CSF --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSF'


		/******************************************************* 
		Student Count by:
			Diploma/Credential, Migratory Status
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			 HighSchoolDiplomaTypeEdFactsCode, HomelessnessStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSF
		FROM #staging 
		GROUP BY HighSchoolDiplomaTypeEdFactsCode, HomelessnessStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  HomelessStatus: ' + convert(varchar, s.HomelessnessStatusEdFactsCode)
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SEA_CSF s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.HOMELESSNESSSTATUS = s.HomelessnessStatusEdFactsCode

		-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			 HighSchoolDiplomaTypeEdFactsCode, HomelessnessStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSF
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			 HighSchoolDiplomaTypeEdFactsCode, HomelessnessStatusEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  ' +
			'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  HomelessStatus: ' + convert(varchar, s.HomelessnessStatusEdFactsCode)			
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LEA_CSF s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.HOMELESSNESSSTATUS = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability

		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			 HighSchoolDiplomaTypeEdFactsCode, HomelessnessStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSF
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			 HighSchoolDiplomaTypeEdFactsCode, HomelessnessStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'SchoolIdentifierSEA: ' + s.SchoolIdentifierSea + '  ' +
			'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode + '  HomelessStatus: ' + convert(varchar, s.HomelessnessStatusEdFactsCode) 
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSF s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.HOMELESSNESSSTATUS = s.HomelessnessStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea

-- ST1 --------------------------------------------------------------------------------------------------
select @CategorySet = 'ST1'

		/******************************************************* 
		Student Count by:
			Diploma/Credential
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			 HighSchoolDiplomaTypeEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_ST1
		FROM #staging 
		GROUP BY HighSchoolDiplomaTypeEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode 
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SEA_ST1 s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode

		-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			 HighSchoolDiplomaTypeEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_ST1
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			 HighSchoolDiplomaTypeEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  ' +
			'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LEA_ST1 s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability

		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			 HighSchoolDiplomaTypeEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_ST1
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			 HighSchoolDiplomaTypeEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'SchoolIdentifierSEA: ' + s.SchoolIdentifierSea + '  ' +
			'Diploma: ' + s.HighSchoolDiplomaTypeEdFactsCode
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_ST1 s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.HIGHSCHOOLDIPLOMATYPE = s.HighSchoolDiplomaTypeEdFactsCode
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea

-- TOT --------------------------------------------------------------------------------------------------
select @CategorySet = 'TOT'

		/******************************************************* 
		Student Count by:
			Total
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_TOT
		FROM #staging 
		WHERE HighSchoolDiplomaTypeEdFactsCode in ('REGDIP', 'OTHCOM')

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'SEA Total'
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SEA_TOT s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet

		-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_TOT
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability
		
		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LEA_TOT s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability

		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_TOT
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			 @SqlUnitTestId
			,@CategorySet + ' ' + @ReportLevel
			,'SchoolIdentifierSEA: ' + s.SchoolIdentifierSea
			,s.StudentCount
			,Fact.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea

-- IF THE TEST PRODUCES NO RESULTS INSERT A RECORD TO INDICATE THIS -------------------------
if not exists(select top 1 * from app.sqlunittest t
	inner join app.SqlUnitTestCaseResult r
		on t.SqlUnitTestId = r.SqlUnitTestId
		and t.SqlUnitTestId = @SqlUnitTestId)
begin
			INSERT INTO App.SqlUnitTestCaseResult 
			(
				[SqlUnitTestId]
				,[TestCaseName]
				,[TestCaseDetails]
				,[ExpectedResult]
				,[ActualResult]
				,[Passed]
				,[TestDateTime]
			)
			SELECT DISTINCT
				 @SqlUnitTestId
				,'NO TEST RESULTS'
				,'NO TEST RESULTS'
				,-1
				,-1
				,NULL
				,GETDATE()
end
----------------------------------------------------------------------------------

END