CREATE PROCEDURE [App].[FS141_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN
	IF OBJECT_ID('tempdb..#Staging') IS NOT NULL DROP TABLE #Staging
	IF OBJECT_ID('tempdb..#SEA_CSA') IS NOT NULL DROP TABLE #SEA_CSA
	IF OBJECT_ID('tempdb..#SEA_CSB') IS NOT NULL DROP TABLE #SEA_CSB
	IF OBJECT_ID('tempdb..#SEA_CSC') IS NOT NULL DROP TABLE #SEA_CSC
	IF OBJECT_ID('tempdb..#SEA_CSD') IS NOT NULL DROP TABLE #SEA_CSD
	IF OBJECT_ID('tempdb..#SEA_TOT') IS NOT NULL DROP TABLE #SEA_TOT
	--IF OBJECT_ID('tempdb..#SEA_TC2') IS NOT NULL DROP TABLE #SEA_TC2
	--IF OBJECT_ID('tempdb..#SEA_TC5') IS NOT NULL DROP TABLE #SEA_TC5

	IF OBJECT_ID('tempdb..#LEA_CSA') IS NOT NULL DROP TABLE #LEA_CSA
	IF OBJECT_ID('tempdb..#LEA_CSB') IS NOT NULL DROP TABLE #LEA_CSB
	IF OBJECT_ID('tempdb..#LEA_CSC') IS NOT NULL DROP TABLE #LEA_CSC
	IF OBJECT_ID('tempdb..#LEA_CSD') IS NOT NULL DROP TABLE #LEA_CSD
	IF OBJECT_ID('tempdb..#LEA_TOT') IS NOT NULL DROP TABLE #LEA_TOT
	--IF OBJECT_ID('tempdb..#LEA_TC2') IS NOT NULL DROP TABLE #LEA_TC2
	--IF OBJECT_ID('tempdb..#LEA_TC5') IS NOT NULL DROP TABLE #LEA_TC5

	IF OBJECT_ID('tempdb..#SCH_CSA') IS NOT NULL DROP TABLE #SCH_CSA
	IF OBJECT_ID('tempdb..#SCH_CSB') IS NOT NULL DROP TABLE #SCH_CSB
	IF OBJECT_ID('tempdb..#SCH_CSC') IS NOT NULL DROP TABLE #SCH_CSC
	IF OBJECT_ID('tempdb..#SCH_CSD') IS NOT NULL DROP TABLE #SCH_CSD
	IF OBJECT_ID('tempdb..#SCH_TOT') IS NOT NULL DROP TABLE #SCH_TOT
	--IF OBJECT_ID('tempdb..#SCH_TC2') IS NOT NULL DROP TABLE #SCH_TC2
	--IF OBJECT_ID('tempdb..#SCH_TC5') IS NOT NULL DROP TABLE #SCH_TC5


	DECLARE 
		@UnitTestName VARCHAR(100) = 'FS141_UnitTestCase',
		@StoredProcedureName VARCHAR(100) = 'FS141_TestCase',
		@TestScope VARCHAR(1000) = 'FS141',
		@ReportCode VARCHAR(20) = 'C141',
		
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
		SET @SqlUnitTestId = SCOPE_IDENTITY()
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
	

		--DROP TABLE #staging 
		IF OBJECT_ID('tempdb..#staging') IS NOT NULL
		DROP TABLE #staging

		IF OBJECT_ID('tempdb..#vwStudentDetails') IS NOT NULL
		DROP TABLE #vwStudentDetails

		-- Needed to do this for performance. 
		-- Doing date comparisons directly on the view was causing issues
		select *
		into #vwStudentDetails
		from debug.vwStudentDetails

	DECLARE @ReportingDate Date = '10/1/' + convert(varchar, @SchoolYear - 1)
	

	SELECT 
		StudentIdentifierState,
		LeaIdentifierSeaAccountability,
		SchoolIdentifierSea,
		RaceEdFactsCode,
		CASE 
			when IDEAIndicatorEdFactsCode = 'Yes'
			and isnull(ProgramParticipationBeginDate, @ReportingDate)  <= @ReportingDate
			and isnull(ProgramParticipationEndDate, @ReportingDate) >= @ReportingDate
			then 'WDIS'
		ELSE
			case
				when IDEAIndicatorEdFactsCode = 'MISSING'
				then 'MISSING'
			end
		END	DisabilityStatusEdFactsCode,
		EnglishLearnerStatusEdFactsCode,
		EnglishLearner_StatusStartDate,
		EnglishLearner_StatusEndDate,
		Iso6392LanguageCodeEdFactsCode,
		GradeLevelEdFactsCode
	INTO #staging
	FROM  #vwStudentDetails
	WHERE  
		GradeLevelEdFactsCode in ('KG', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', 'UG')
		and EnglishLearnerStatusEdFactsCode = 'LEP'
		and isnull(EnglishLearner_StatusStartDate, @ReportingDate)  <= @ReportingDate
		and isnull(EnglishLearner_StatusEndDate, @ReportingDate) >= @ReportingDate	
		and isnull(EnrollmentEntryDate, @ReportingDate)  <= @ReportingDate
		and isnull(EnrollmentExitDate, @ReportingDate) >= @ReportingDate	

-- CSA --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSA'

		/******************************************************* 
		Test Case 1: 
			CSA at SEA Level  
			Student Count by:
				GradeLevel
		********************************************************/
		select @ReportLevel = 'SEA'
		SELECT 
			 GradeLevelEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSA
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
		FROM #SEA_CSA s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.GRADELEVEL = s.GradeLevelEdFactsCode

		/******************************************************* 
		Test Case 2: 
			CSA at LEA Level  
			Student Count by:
				GradeLevel
		********************************************************/
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability
			,GradeLevelEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSA
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Grade: ' + s.GradeLevelEdFactsCode
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
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability

		/******************************************************* 
		Test Case 3: 
			CSA at SCH Level  
			Student Count by:
				GradeLevel
		********************************************************/
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea
			,GradeLevelEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSA
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
			,'SchoolIdentifierSEA: ' + s.SchoolIdentifierSea + '  '
			+ 'Grade: ' + s.GradeLevelEdFactsCode
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
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea

-- CSB --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSB'

		/******************************************************* 
		Test Case 4: 
			CSB at SEA Level  
			Student Count by:
				Language
		********************************************************/
		select @ReportLevel = 'SEA'
		SELECT 
			 Iso6392LanguageCodeEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSB
		FROM #staging 
		GROUP BY Iso6392LanguageCodeEdFactsCode

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
			,'Language: ' + s.Iso6392LanguageCodeEdFactsCode
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
			and Fact.ISO6392LanguageCode = s.Iso6392LanguageCodeEdFactsCode

		/******************************************************* 
		Test Case 5: 
			CSB at LEA Level  
			Student Count by:
				Language
		********************************************************/
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability
			,Iso6392LanguageCodeEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSB
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			Iso6392LanguageCodeEdFactsCode

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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Language: ' + s.Iso6392LanguageCodeEdFactsCode
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
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability
			and Fact.ISO6392LanguageCode = s.Iso6392LanguageCodeEdFactsCode

		/******************************************************* 
		Test Case 6: 
			CSB at SCH Level  
			Student Count by:
				Language
		********************************************************/
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea
			,Iso6392LanguageCodeEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSB
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			Iso6392LanguageCodeEdFactsCode

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
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'Language: ' + s.Iso6392LanguageCodeEdFactsCode
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
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea
			and Fact.ISO6392LanguageCode = s.Iso6392LanguageCodeEdFactsCode


-- CSC --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSC'

		/******************************************************* 
		Test Case 7: 
			CSC at SEA Level  
			Student Count by:
				Race
		********************************************************/
		select @ReportLevel = 'SEA'
		SELECT 
			 RaceEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSC
		FROM #staging 
		GROUP BY RaceEdFactsCode

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
			,'Race: ' + s.RaceEdFactsCode
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
			and Fact.RACE = s.RaceEdFactsCode

		/******************************************************* 
		Test Case 8: 
			CSC at LEA Level  
			Student Count by:
				Race
		********************************************************/
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability
			,RaceEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSC
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			RaceEdFactsCode

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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Race: ' + s.RaceEdFactsCode
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
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability
			and Fact.RACE = s.RaceEdFactsCode

		/******************************************************* 
		Test Case 9: 
			CSC at SCH Level  
			Student Count by:
				Race
		********************************************************/
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea
			,RaceEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSC
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			RaceEdFactsCode

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
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'Race: ' + s.RaceEdFactsCode
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
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea
			and Fact.RACE = s.RaceEdFactsCode


-- CSD --------------------------------------------------------------------------------------------------
select @CategorySet = 'CSD'

		/******************************************************* 
		Test Case 7: 
			CSD at SEA Level  
			Student Count by:
				DisabilityStatusEdFactsCode
		********************************************************/
		select @ReportLevel = 'SEA'
		SELECT 
			 DisabilityStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSD
		FROM #staging 
		GROUP BY DisabilityStatusEdFactsCode

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
			,'DisabilityStatusEdFactsCode: ' + s.DisabilityStatusEdFactsCode
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
			and Fact.IDEAINDICATOR = s.DisabilityStatusEdFactsCode

		/******************************************************* 
		Test Case 8: 
			CSD at LEA Level  
			Student Count by:
				DisabilityStatusEdFactsCode
		********************************************************/
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability
			,DisabilityStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSD
		FROM #staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			DisabilityStatusEdFactsCode

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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'DisabilityStatusEdFactsCode: ' + s.DisabilityStatusEdFactsCode
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
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability
			and Fact.IDEAINDICATOR = s.DisabilityStatusEdFactsCode

		/******************************************************* 
		Test Case 9: 
			CSD at SCH Level  
			Student Count by:
				DisabilityStatusEdFactsCode
		********************************************************/
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea
			,DisabilityStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSD
		FROM #staging 
		GROUP BY 
			SchoolIdentifierSea,
			DisabilityStatusEdFactsCode

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
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'DisabilityStatusEdFactsCode: ' + s.DisabilityStatusEdFactsCode
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
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea
			and Fact.IDEAINDICATOR = s.DisabilityStatusEdFactsCode

-- TOT --------------------------------------------------------------------------------------------------
select @CategorySet = 'TOT'

		/******************************************************* 
		Test Case 7: 
			TOTAL at SEA Level  
			Student Count by:
				Total
		********************************************************/
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
			,'TOTAL'
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

		/******************************************************* 
		Test Case 8: 
			TOTAL at LEA Level  
			Student Count by:
				Total
		********************************************************/
		select @ReportLevel = 'LEA'
		SELECT 
			LeaIdentifierSeaAccountability
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Total'
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

		/******************************************************* 
		Test Case 9: 
			TOTAL at SCH Level  
			Student Count by:
				Total
		********************************************************/
		select @ReportLevel = 'SCH'
		SELECT 
			SchoolIdentifierSea
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
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
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'Total'
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

