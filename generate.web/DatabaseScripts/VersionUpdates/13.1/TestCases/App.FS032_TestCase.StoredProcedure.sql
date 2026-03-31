CREATE PROCEDURE [App].[FS032_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

	/***************************************************************
	CSA = Grade Level, Race, Sex
	CSB = Grade Level, Disability Status
	CSC = Grade Level, English Learner Status
	CSD = Grade Level, Economically Disadvantaged Status
	CDE = Grade Level, Migratory Status
	CDF = Grade Level, Homeless Enrolled Status
	ST1 = Grade Level Total
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
		@UnitTestName VARCHAR(100) = 'FS032_UnitTestCase',
		@StoredProcedureName VARCHAR(100) = 'FS032_TestCase',
		@TestScope VARCHAR(1000) = 'FS032',
		@ReportCode VARCHAR(20) = '032',
		
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
	
	DECLARE @ReportingDate Date = '10/1/' + convert(varchar, @SchoolYear - 1)

		--DROP TABLE #staging 
		IF OBJECT_ID('tempdb..#staging') IS NOT NULL
		DROP TABLE #staging

		IF OBJECT_ID('tempdb..#vwStudentDetails') IS NOT NULL
		DROP TABLE #vwStudentDetails

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
			case when sps.EconomicDisadvantageStatus = 1 then 'ECODIS' else '' end EconomicDisadvantageStatusEdFactsCode,
			case when sps.MigrantStatus = 1 then 'MS' else '' end MigrantStatusEdFactsCode,
			case when sps.HomelessnessStatus = 1 then 'HOMELSENRL' else '' end HomelessnessStatusEdFactsCode
		into #staging
		from #vwStudentDetails vsd
		inner join staging.K12Enrollment ske
			on vsd.StudentIdentifierState = ske.StudentIdentifierState
			and vsd.LeaIdentifierSeaAccountability = ske.LeaIdentifierSeaAccountability
			and vsd.SchoolIdentifierSea = ske.SchoolIdentifierSea
			and vsd.schoolyear = ske.SchoolYear
			and vsd.EnrollmentEntryDate = ske.EnrollmentEntryDate
		inner join staging.PersonStatus sps
			on ske.StudentIdentifierState = sps.StudentIdentifierState
			and ske.LeaIdentifierSeaAccountability = sps.LeaIdentifierSeaAccountability
			and ske.SchoolIdentifierSea = sps.SchoolIdentifierSea
		JOIN RDS.DimSeas rds
			ON vsd.EnrollmentEntryDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, GETDATE())
		JOIN RDS.DimLeas rdl
			ON ske.LeaIdentifierSeaAccountability = rdl.LeaIdentifierSea
			AND ske.EnrollmentEntryDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, GETDATE())

		JOIN RDS.DimK12Schools rdksch
			ON ske.SchoolIdentifierSea = rdksch.SchoolIdentifierSea
			AND ske.EnrollmentEntryDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, GETDATE())

		where ske.ExitOrWithdrawalType = '01927'



-- CSA --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSA'

		/******************************************************* 
		Student Count by:
			GradeLevel, Race, Sex
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			 GradeLevelEdFactsCode, RaceEdFactsCode, SexEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSA
		FROM #staging 
		GROUP BY GradeLevelEdFactsCode, RaceEdFactsCode, SexEdFactsCode

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
			,'Grade: ' + s.GradeLevelEdFactsCode + '  Race: ' + s.RaceEdFactsCode + '  Sex: ' + s.SexEdFactsCode
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.RACE = s.RaceEdFactsCode
			and Fact.SEX = s.SexEdFactsCode

	-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			 GradeLevelEdFactsCode, RaceEdFactsCode, SexEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSA
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			GradeLevelEdFactsCode, RaceEdFactsCode, SexEdFactsCode

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
			'Grade: ' + s.GradeLevelEdFactsCode + '  Race: ' + s.RaceEdFactsCode + '  Sex: ' + s.SexEdFactsCode
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.RACE = s.RaceEdFactsCode
			and Fact.SEX = s.SexEdFactsCode
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability


		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			 GradeLevelEdFactsCode, RaceEdFactsCode, SexEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSA
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			GradeLevelEdFactsCode, RaceEdFactsCode, SexEdFactsCode

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
			'Grade: ' + s.GradeLevelEdFactsCode + '  Race: ' + s.RaceEdFactsCode + '  Sex: ' + s.SexEdFactsCode
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.RACE = s.RaceEdFactsCode
			and Fact.SEX = s.SexEdFactsCode
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea




-- CSB --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSB'

		/******************************************************* 
		Student Count by:
			GradeLevel, Disability Status
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			 GradeLevelEdFactsCode, DisabilityStatus
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSB
		FROM #staging 
		GROUP BY GradeLevelEdFactsCode, DisabilityStatus

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
			,'Grade: ' + s.GradeLevelEdFactsCode + '  DisabilityStatus: ' + s.DisabilityStatus 
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.IDEAINDICATOR = s.DisabilityStatus

		-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			 GradeLevelEdFactsCode, DisabilityStatus
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSB
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			GradeLevelEdFactsCode, DisabilityStatus

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
			'Grade: ' + s.GradeLevelEdFactsCode + '  DisabilityStatus: ' + s.DisabilityStatus 
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.IDEAINDICATOR = s.DisabilityStatus
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability

		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			 GradeLevelEdFactsCode, DisabilityStatus
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSB
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			GradeLevelEdFactsCode, DisabilityStatus

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
			'Grade: ' + s.GradeLevelEdFactsCode + '  DisabilityStatus: ' + s.DisabilityStatus 
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.IDEAINDICATOR = s.DisabilityStatus
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea


-- CSC --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSC'

		/******************************************************* 
		Student Count by:
			GradeLevel, English Learner Status
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			 GradeLevelEdFactsCode, EnglishLearnerStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSC
		FROM #staging 
		GROUP BY GradeLevelEdFactsCode, EnglishLearnerStatusEdFactsCode

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
			,'Grade: ' + s.GradeLevelEdFactsCode + '  ELStatus: ' + s.EnglishLearnerStatusEdFactsCode 
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.ENGLISHLEARNERSTATUS = s.EnglishLearnerStatusEdFactsCode

		-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			 GradeLevelEdFactsCode, EnglishLearnerStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSC
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			GradeLevelEdFactsCode, EnglishLearnerStatusEdFactsCode
		
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
			'Grade: ' + s.GradeLevelEdFactsCode + '  ELStatus: ' + s.EnglishLearnerStatusEdFactsCode 
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.ENGLISHLEARNERSTATUS = s.EnglishLearnerStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability

		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			 GradeLevelEdFactsCode, EnglishLearnerStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSC
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			GradeLevelEdFactsCode, EnglishLearnerStatusEdFactsCode

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
			'Grade: ' + s.GradeLevelEdFactsCode + '  ELStatus: ' + s.EnglishLearnerStatusEdFactsCode 
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.ENGLISHLEARNERSTATUS = s.EnglishLearnerStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea


-- CSD --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSD'


		/******************************************************* 
		Student Count by:
			GradeLevel, Economically Disadvantaged Status
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			 GradeLevelEdFactsCode, EconomicDisadvantageStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSD
		FROM #staging 
		GROUP BY GradeLevelEdFactsCode, EconomicDisadvantageStatusEdFactsCode

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
			,'Grade: ' + s.GradeLevelEdFactsCode + '  EcoStatus: ' + convert(varchar, s.EconomicDisadvantageStatusEdFactsCode)
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.ECONOMICDISADVANTAGESTATUS = s.EconomicDisadvantageStatusEdFactsCode

		-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			 GradeLevelEdFactsCode, EconomicDisadvantageStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSD
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			 GradeLevelEdFactsCode, EconomicDisadvantageStatusEdFactsCode
		
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
			'Grade: ' + s.GradeLevelEdFactsCode + '  EcoStatus: ' + convert(varchar, s.EconomicDisadvantageStatusEdFactsCode)			
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.ECONOMICDISADVANTAGESTATUS = s.EconomicDisadvantageStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability

		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			 GradeLevelEdFactsCode, EconomicDisadvantageStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSD
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			 GradeLevelEdFactsCode, EconomicDisadvantageStatusEdFactsCode

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
			'Grade: ' + s.GradeLevelEdFactsCode + '  EcoStatus: ' + convert(varchar, s.EconomicDisadvantageStatusEdFactsCode) 
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.ECONOMICDISADVANTAGESTATUS = s.EconomicDisadvantageStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea

-- CSE --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSE'


		/******************************************************* 
		Student Count by:
			GradeLevel, Migratory Status
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			 GradeLevelEdFactsCode, MigrantStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSE
		FROM #staging 
		GROUP BY GradeLevelEdFactsCode, MigrantStatusEdFactsCode

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
			,'Grade: ' + s.GradeLevelEdFactsCode + '  MigrantStatus: ' + convert(varchar, s.MigrantStatusEdFactsCode)
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.MIGRANTSTATUS = s.MigrantStatusEdFactsCode

		-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			 GradeLevelEdFactsCode, MigrantStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSE
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			 GradeLevelEdFactsCode, MigrantStatusEdFactsCode
		
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
			'Grade: ' + s.GradeLevelEdFactsCode + '  MigrantStatus: ' + convert(varchar, s.MigrantStatusEdFactsCode)			
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.MIGRANTSTATUS = s.MigrantStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability

		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			 GradeLevelEdFactsCode, MigrantStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSE
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			 GradeLevelEdFactsCode, MigrantStatusEdFactsCode

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
			'Grade: ' + s.GradeLevelEdFactsCode + '  MigrantStatus: ' + convert(varchar, s.MigrantStatusEdFactsCode) 
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.MIGRANTSTATUS = s.MigrantStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea


-- CSF --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSF'


		/******************************************************* 
		Student Count by:
			GradeLevel, Migratory Status
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			 GradeLevelEdFactsCode, HomelessnessStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSF
		FROM #staging 
		GROUP BY GradeLevelEdFactsCode, HomelessnessStatusEdFactsCode

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
			,'Grade: ' + s.GradeLevelEdFactsCode + '  HomelessStatus: ' + convert(varchar, s.HomelessnessStatusEdFactsCode)
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.HOMELESSNESSSTATUS = s.HomelessnessStatusEdFactsCode

		-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			 GradeLevelEdFactsCode, HomelessnessStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSF
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			 GradeLevelEdFactsCode, HomelessnessStatusEdFactsCode
		
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
			'Grade: ' + s.GradeLevelEdFactsCode + '  HomelessStatus: ' + convert(varchar, s.HomelessnessStatusEdFactsCode)			
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.HOMELESSNESSSTATUS = s.HomelessnessStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability

		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			 GradeLevelEdFactsCode, HomelessnessStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSF
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			 GradeLevelEdFactsCode, HomelessnessStatusEdFactsCode

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
			'Grade: ' + s.GradeLevelEdFactsCode + '  HomelessStatus: ' + convert(varchar, s.HomelessnessStatusEdFactsCode) 
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.HOMELESSNESSSTATUS = s.HomelessnessStatusEdFactsCode
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea

-- ST1 --------------------------------------------------------------------------------------------------
select @CategorySet = 'ST1'

		/******************************************************* 
		Student Count by:
			GradeLevel
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			 GradeLevelEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_ST1
		FROM #staging 
		GROUP BY GradeLevelEdFactsCode

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
			,'Grade: ' + s.GradeLevelEdFactsCode 
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode

		-- LEA ---------------------------------------------------------
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability,
			 GradeLevelEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_ST1
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			 GradeLevelEdFactsCode
		
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
			'Grade: ' + s.GradeLevelEdFactsCode
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability

		-- SCH ------------------------------------------------------------
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea,
			 GradeLevelEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_ST1
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			 GradeLevelEdFactsCode

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
			'Grade: ' + s.GradeLevelEdFactsCode
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
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea

-- TOT --------------------------------------------------------------------------------------------------
select @CategorySet = 'TOT'

		/******************************************************* 
		Student Count by:
			GradeLevel
		********************************************************/

		-- SEA -----------------------------------------------------
		select @ReportLevel = 'SEA'
		SELECT 
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_TOT
		FROM #staging 

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

