CREATE PROCEDURE [App].[FS141_TestCase]	
 	@SchoolYear SMALLINT
AS
BEGIN
	IF OBJECT_ID('tempdb..#C141Staging') IS NOT NULL DROP TABLE #C141Staging
	IF OBJECT_ID('tempdb..#SEA_CSA') IS NOT NULL DROP TABLE #SEA_CSA
	IF OBJECT_ID('tempdb..#SEA_CSB') IS NOT NULL DROP TABLE #SEA_CSB
	IF OBJECT_ID('tempdb..#SEA_CSC') IS NOT NULL DROP TABLE #SEA_CSC
	IF OBJECT_ID('tempdb..#SEA_CSD') IS NOT NULL DROP TABLE #SEA_CSD
	IF OBJECT_ID('tempdb..#SEA_TOT') IS NOT NULL DROP TABLE #SEA_TOT

	IF OBJECT_ID('tempdb..#LEA_CSA') IS NOT NULL DROP TABLE #LEA_CSA
	IF OBJECT_ID('tempdb..#LEA_CSB') IS NOT NULL DROP TABLE #LEA_CSB
	IF OBJECT_ID('tempdb..#LEA_CSC') IS NOT NULL DROP TABLE #LEA_CSC
	IF OBJECT_ID('tempdb..#LEA_CSD') IS NOT NULL DROP TABLE #LEA_CSD
	IF OBJECT_ID('tempdb..#LEA_TOT') IS NOT NULL DROP TABLE #LEA_TOT

	IF OBJECT_ID('tempdb..#SCH_CSA') IS NOT NULL DROP TABLE #SCH_CSA
	IF OBJECT_ID('tempdb..#SCH_CSB') IS NOT NULL DROP TABLE #SCH_CSB
	IF OBJECT_ID('tempdb..#SCH_CSC') IS NOT NULL DROP TABLE #SCH_CSC
	IF OBJECT_ID('tempdb..#SCH_CSD') IS NOT NULL DROP TABLE #SCH_CSD
	IF OBJECT_ID('tempdb..#SCH_TOT') IS NOT NULL DROP TABLE #SCH_TOT

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
	
	--DROP TABLE #C141Staging 
	IF OBJECT_ID('tempdb..#C141Staging') IS NOT NULL
	DROP TABLE #C141Staging

	--Create SY Start / SY End variables
	declare @SYStartDate varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
	declare @SYEndDate varchar(10) = CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)

	declare @ReportingDate Date, @testdate date
	--Reporting Date is the closest school day to Oct 1 according to the file spec
	SELECT @testDate = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-' + '10-01' AS DATE)
	
	SELECT @ReportingDate = 
		CASE DATEPART(DW, @testDate)
			WHEN 1 THEN (SELECT DATEADD(day, 1, @testDate))
			WHEN 7 THEN (SELECT DATEADD(day, -1, @testDate))
			ELSE @testDate
		END	
	
	SELECT DISTINCT
		ske.StudentIdentifierState
		, ske.LeaIdentifierSeaAccountability
		, ske.SchoolIdentifierSea
		, replace(ske.GradeLevel, '_1', '') GradeLevel
		, rdl.Iso6392LanguageCodeEdFactsCode
		, CASE 
			WHEN ske.HispanicLatinoEthnicity = 1 THEN 'HI7' 
			WHEN spr.RaceType = 'AmericanIndianorAlaskaNative' THEN 'AM7'
			WHEN spr.RaceType = 'Asian' THEN 'AS7'
			WHEN spr.RaceType = 'BlackorAfricanAmerican' THEN 'BL7'
			WHEN spr.RaceType = 'NativeHawaiianorOtherPacificIslander' THEN 'PI7'
			WHEN spr.RaceType = 'White' THEN 'WH7'
			WHEN spr.RaceType = 'TwoorMoreRaces' THEN 'MU7'
			WHEN spr.RaceType = 'AmericanIndianorAlaskaNative_1' THEN 'AM7'
			WHEN spr.RaceType = 'Asian_1' THEN 'AS7'
			WHEN spr.RaceType = 'BlackorAfricanAmerican_1' THEN 'BL7'
			WHEN spr.RaceType = 'NativeHawaiianorOtherPacificIslander_1' THEN 'PI7'
			WHEN spr.RaceType = 'White_1' THEN 'WH7'
			WHEN spr.RaceType = 'TwoorMoreRaces_1' THEN 'MU7'
		END AS RaceEdFactsCode
		, CASE ISNULL(sppse.IdeaIndicator, 0)
			WHEN 1 THEN 'WDIS'
			ELSE 'WODIS'
		END AS DisabilityStatus
	INTO #C141Staging
	FROM Staging.K12Enrollment ske
	JOIN Staging.PersonStatus sps
		ON sps.StudentIdentifierState = ske.StudentIdentifierState
		AND sps.LeaIdentifierSeaAccountability = ske.LeaIdentifierSeaAccountability
		AND sps.SchoolIdentifierSea = ske.SchoolIdentifierSea
		AND @ReportingDate BETWEEN sps.EnglishLearner_StatusStartDate AND ISNULL(sps.EnglishLearner_StatusEndDate, @SYEndDate)
	LEFT JOIN (select min(DimLanguageId) DimLanguageId, SchoolYear, Iso6392LanguageCodeCode, Iso6392LanguageMap 
				from rds.vwdimlanguages 
				group by SchoolYear, Iso6392LanguageCodeCode, Iso6392LanguageMap) vwLanguage
		on vwLanguage.SchoolYear = ske.SchoolYear
		and vwLanguage.Iso6392LanguageMap = sps.ISO_639_2_NativeLanguage
	LEFT JOIN RDS.DimLanguages rdl
		on rdl.DimLanguageId = vwLanguage.DimLanguageId
	LEFT JOIN Staging.ProgramParticipationSpecialEducation sppse
		ON sppse.StudentIdentifierState = ske.StudentIdentifierState
		AND sppse.LeaIdentifierSeaAccountability = ske.LeaIdentifierSeaAccountability
		AND sppse.SchoolIdentifierSea = ske.SchoolIdentifierSea
		AND @ReportingDate between sppse.ProgramParticipationBeginDate AND ISNULL(sppse.ProgramParticipationEndDate, @SYEndDate)
	LEFT JOIN Staging.K12PersonRace spr
		ON ske.SchoolYear = spr.SchoolYear
		AND ske.StudentIdentifierState = spr.StudentIdentifierState
		AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(spr.LeaIdentifierSeaAccountability, '')
		AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(spr.SchoolIdentifierSea, '')
		AND spr.RecordStartDateTime is not null
		AND @ReportingDate BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, @SYEndDate)
	WHERE 1 = 1  
		and @ReportingDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEndDate)
		AND ske.GradeLevel in ('KG','01','02','03','04','05','06','07','08','09','10','11','12','13','UG',
			'KG_1','01_1','02_1','03_1','04_1','05_1','06_1','07_1','08_1','09_1','10_1','11_1','12_1','13_1','UG_1')
		AND sps.EnglishLearnerStatus = 1

	--Get the LEAs that should not be reported against
	IF OBJECT_ID('tempdb..#excludedLeas') IS NOT NULL DROP TABLE #excludedLeas

	CREATE TABLE #excludedLeas (
		LeaIdentifierSeaAccountability		VARCHAR(20)
	)

	INSERT INTO #excludedLeas 
	SELECT DISTINCT LEAIdentifierSea
	FROM Staging.K12Organization
	WHERE LEA_IsReportedFederally = 0
		OR LEA_OperationalStatus in ('Closed', 'FutureAgency', 'Inactive', 'Closed_1', 'FutureAgency_1', 'Inactive_1', 'MISSING')

	--Get the Schools that should not be reported against
	IF OBJECT_ID('tempdb..#excludedSchools') IS NOT NULL
	DROP TABLE #excludedSchools

	CREATE TABLE #excludedSchools (
		SchoolIdentifierSea		VARCHAR(20)
	)

	INSERT INTO #excludedSchools 
	SELECT DISTINCT SchoolIdentifierSea
	FROM Staging.K12Organization
	WHERE School_IsReportedFederally = 0
		OR School_OperationalStatus in ('Closed', 'FutureSchool', 'Inactive', 'MISSING', 'Closed_1', 'FutureSchool_1', 'Inactive_1')

---------------------------------
-- CSA
---------------------------------
	select @CategorySet = 'CSA'

	/******************************************************* 
		Test Case 1: 
		CSA at SEA Level - Student Count by GradeLevel
	********************************************************/
	select @ReportLevel = 'SEA'
	SELECT 
		GradeLevel
		,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #SEA_CSA
	FROM #C141Staging 
	GROUP BY GradeLevel

	INSERT INTO App.SqlUnitTestCaseResult 
	(
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT 
		@SqlUnitTestId
		, @CategorySet + ' ' + @ReportLevel
		, 'Grade: ' + s.GradeLevel
		, s.StudentCount
		, Fact.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #SEA_CSA s
	JOIN RDS.ReportEdFactsK12StudentCounts Fact
		ON Fact.ReportCode = @ReportCode
		and Fact.ReportYear = @SchoolYear
		and Fact.ReportLevel = @ReportLevel
		and Fact.CategorySetCode = @CategorySet
		and Fact.GRADELEVEL = s.GradeLevel

	/******************************************************* 
		Test Case 2: 
		CSA at LEA Level - Student Count by GradeLevel
	********************************************************/
	select @ReportLevel = 'LEA'
	SELECT 
		s.LeaIdentifierSeaAccountability
		,GradeLevel
		,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #LEA_CSA
	FROM #C141Staging s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reportable LEAs
	GROUP BY 
		s.LeaIdentifierSeaAccountability,
		GradeLevel

	INSERT INTO App.SqlUnitTestCaseResult 
	(
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT 
		@SqlUnitTestId
		, @CategorySet + ' ' + @ReportLevel
		, 'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
		+ 'Grade: ' + s.GradeLevel
		, s.StudentCount
		, Fact.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #LEA_CSA s
	JOIN RDS.ReportEdFactsK12StudentCounts Fact
		ON Fact.ReportCode = @ReportCode
		and Fact.ReportYear = @SchoolYear
		and Fact.ReportLevel = @ReportLevel
		and Fact.CategorySetCode = @CategorySet
		and Fact.GRADELEVEL = s.GradeLevel
		and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability

	/******************************************************* 
		Test Case 3: 
		CSA at SCH Level - Student Count by GradeLevel
	********************************************************/
	select @ReportLevel = 'SCH'
	SELECT 
		s.SchoolIdentifierSea
		,GradeLevel
		,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #SCH_CSA
	FROM #C141Staging s
	LEFT JOIN #excludedSchools esch
		ON s.SchoolIdentifierSea = esch.SchoolIdentifierSea
	WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reportable Schools
	GROUP BY 
		s.SchoolIdentifierSea,
		GradeLevel

	INSERT INTO App.SqlUnitTestCaseResult 
	(
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT 
		@SqlUnitTestId
		, @CategorySet + ' ' + @ReportLevel
		, 'SchoolIdentifierSEA: ' + s.SchoolIdentifierSea + '  '
		+  'Grade: ' + s.GradeLevel
		, s.StudentCount
		, Fact.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #SCH_CSA s
	JOIN RDS.ReportEdFactsK12StudentCounts Fact
		ON Fact.ReportCode = @ReportCode
		and Fact.ReportYear = @SchoolYear
		and Fact.ReportLevel = @ReportLevel
		and Fact.CategorySetCode = @CategorySet
		and Fact.GRADELEVEL = s.GradeLevel
		and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea

---------------------------------
-- CSB
---------------------------------
	select @CategorySet = 'CSB'

	/******************************************************* 
		Test Case 4: 
		CSA at SEA Level - Student Count by Language
	********************************************************/
		select @ReportLevel = 'SEA'
		SELECT 
			 Iso6392LanguageCodeEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSB
		FROM #C141Staging 
		GROUP BY Iso6392LanguageCodeEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT 
			@SqlUnitTestId
			, @CategorySet + ' ' + @ReportLevel
			, 'Language: ' + s.Iso6392LanguageCodeEdFactsCode
			, s.StudentCount
			, Fact.StudentCount
			, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			, GETDATE()
		FROM #SEA_CSB s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.ISO6392LanguageCode = s.Iso6392LanguageCodeEdFactsCode

	/******************************************************* 
		Test Case 5: 
		CSA at LEA Level - Student Count by Language
	********************************************************/
		select @ReportLevel = 'LEA'
		SELECT 
			s.LeaIdentifierSeaAccountability
			,Iso6392LanguageCodeEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSB
		FROM #C141Staging s
		LEFT JOIN #excludedLeas elea
			ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reportable LEAs
		GROUP BY 
			s.LeaIdentifierSeaAccountability,
			Iso6392LanguageCodeEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT 
			@SqlUnitTestId
			, @CategorySet + ' ' + @ReportLevel
			, 'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Language: ' + s.Iso6392LanguageCodeEdFactsCode
			, s.StudentCount
			, Fact.StudentCount
			, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			, GETDATE()
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
		CSA at SCH Level - Student Count by Language
	********************************************************/
		select @ReportLevel = 'SCH'
		SELECT 
			s.SchoolIdentifierSea
			,Iso6392LanguageCodeEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSB
		FROM #C141Staging s
		LEFT JOIN #excludedSchools esch
			ON s.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reportable Schools
		GROUP BY 
			s.SchoolIdentifierSea,
			Iso6392LanguageCodeEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT 
			@SqlUnitTestId
			, @CategorySet + ' ' + @ReportLevel
			, 'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'Language: ' + s.Iso6392LanguageCodeEdFactsCode
			, s.StudentCount
			, Fact.StudentCount
			, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			, GETDATE()
		FROM #SCH_CSB s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea
			and Fact.ISO6392LanguageCode = s.Iso6392LanguageCodeEdFactsCode


---------------------------------
-- CSC
---------------------------------
	select @CategorySet = 'CSC'

	/******************************************************* 
		Test Case 7: 
		CSA at SEA Level - Student Count by Race
	********************************************************/
		select @ReportLevel = 'SEA'
		SELECT 
			 RaceEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSC
		FROM #C141Staging 
		GROUP BY RaceEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT 
			@SqlUnitTestId
			, @CategorySet + ' ' + @ReportLevel
			, 'Race: ' + s.RaceEdFactsCode
			, s.StudentCount
			, Fact.StudentCount
			, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			, GETDATE()
		FROM #SEA_CSC s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.RACE = s.RaceEdFactsCode

	/******************************************************* 
		Test Case 8: 
		CSA at LEA Level - Student Count by Race
	********************************************************/
		select @ReportLevel = 'LEA'
		SELECT 
			s.LeaIdentifierSeaAccountability
			,RaceEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSC
		FROM #C141Staging s
		LEFT JOIN #excludedLeas elea
			ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reportable LEAs
		GROUP BY 
			s.LeaIdentifierSeaAccountability,
			RaceEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT 
			@SqlUnitTestId
			, @CategorySet + ' ' + @ReportLevel
			, 'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Race: ' + s.RaceEdFactsCode
			, s.StudentCount
			, Fact.StudentCount
			, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			, GETDATE()
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
		CSA at SCH Level - Student Count by Race
	********************************************************/
		select @ReportLevel = 'SCH'
		SELECT 
			s.SchoolIdentifierSea
			,RaceEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSC
		FROM #C141Staging s
		LEFT JOIN #excludedSchools esch
			ON s.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reportable Schools
		GROUP BY 
			s.SchoolIdentifierSea,
			RaceEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT 
			@SqlUnitTestId
			, @CategorySet + ' ' + @ReportLevel
			, 'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'Race: ' + s.RaceEdFactsCode
			, s.StudentCount
			, Fact.StudentCount
			, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			, GETDATE()
		FROM #SCH_CSC s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea
			and Fact.RACE = s.RaceEdFactsCode


---------------------------------
-- CSD
---------------------------------
	select @CategorySet = 'CSD'

	/******************************************************* 
		Test Case 10: 
		CSA at SEA Level - Student Count by Disability Status
	********************************************************/

		select @ReportLevel = 'SEA'
		SELECT 
			 DisabilityStatus
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_CSD
		FROM #C141Staging 
		GROUP BY DisabilityStatus

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT 
			@SqlUnitTestId
			, @CategorySet + ' ' + @ReportLevel
			, 'DisabilityStatus: ' + s.DisabilityStatus
			, s.StudentCount
			, Fact.StudentCount
			, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			, GETDATE()
		FROM #SEA_CSD s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.IDEAINDICATOR = s.DisabilityStatus

	/******************************************************* 
		Test Case 11: 
		CSA at LEA Level - Student Count by Disability Status
	********************************************************/
		select @ReportLevel = 'LEA'
		SELECT 
			s.LeaIdentifierSeaAccountability
			,DisabilityStatus
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_CSD
		FROM #C141Staging s
		LEFT JOIN #excludedLeas elea
			ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reportable LEAs
		GROUP BY 
			s.LeaIdentifierSeaAccountability,
			DisabilityStatus

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT 
			@SqlUnitTestId
			, @CategorySet + ' ' + @ReportLevel
			, 'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'DisabilityStatus: ' + s.DisabilityStatus
			, s.StudentCount
			, Fact.StudentCount
			, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			, GETDATE()
		FROM #LEA_CSD s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability
			and Fact.IDEAINDICATOR = s.DisabilityStatus

	/******************************************************* 
		Test Case 12: 
		CSA at SCH Level - Student Count by Disability Status
	********************************************************/
		select @ReportLevel = 'SCH'
		SELECT 
			s.SchoolIdentifierSea
			,DisabilityStatus
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSD
		FROM #C141Staging s
		LEFT JOIN #excludedSchools esch
			ON s.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reportable Schools
		GROUP BY 
			s.SchoolIdentifierSea,
			DisabilityStatus

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT 
			@SqlUnitTestId
			, @CategorySet + ' ' + @ReportLevel
			, 'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'DisabilityStatus: ' + s.DisabilityStatus
			, s.StudentCount
			, Fact.StudentCount
			, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			, GETDATE()
		FROM #SCH_CSD s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea
			and Fact.IDEAINDICATOR = s.DisabilityStatus

---------------------------------
-- TOT
---------------------------------
	select @CategorySet = 'TOT'

	/******************************************************* 
		Test Case 13: 
		CSA at SEA Level - Student Count by Total
	********************************************************/
		select @ReportLevel = 'SEA'
		SELECT 
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SEA_TOT
		FROM #C141Staging 

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT 
			@SqlUnitTestId
			, @CategorySet + ' ' + @ReportLevel
			, 'TOTAL'
			, s.StudentCount
			, Fact.StudentCount
			, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			, GETDATE()
		FROM #SEA_TOT s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet

	/******************************************************* 
		Test Case 14: 
		CSA at LEA Level - Student Count by Total
	********************************************************/
		select @ReportLevel = 'LEA'
		SELECT 
			s.LeaIdentifierSeaAccountability
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #LEA_TOT
		FROM #C141Staging s
		LEFT JOIN #excludedLeas elea
			ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reportable LEAs
		GROUP BY 
			s.LeaIdentifierSeaAccountability

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT 
			@SqlUnitTestId
			, @CategorySet + ' ' + @ReportLevel
			, 'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Total'
			, s.StudentCount
			, Fact.StudentCount
			, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			, GETDATE()
		FROM #LEA_TOT s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.OrganizationIdentifierSea = s.LeaIdentifierSeaAccountability

	/******************************************************* 
		Test Case 15: 
		CSA at SCH Level - Student Count by Total
	********************************************************/
		select @ReportLevel = 'SCH'
		SELECT 
			s.SchoolIdentifierSea
			,COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_TOT
		FROM #C141Staging s
		LEFT JOIN #excludedSchools esch
			ON s.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reportable Schools
		GROUP BY 
			s.SchoolIdentifierSea

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT 
			@SqlUnitTestId
			, @CategorySet + ' ' + @ReportLevel
			, 'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'Total'
			, s.StudentCount
			, Fact.StudentCount
			, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END
			, GETDATE()
		FROM #SCH_TOT s
		JOIN RDS.ReportEdFactsK12StudentCounts Fact
			ON Fact.ReportCode = @ReportCode
			and Fact.ReportYear = @SchoolYear
			and Fact.ReportLevel = @ReportLevel
			and Fact.CategorySetCode = @CategorySet
			and Fact.OrganizationIdentifierSea = s.SchoolIdentifierSea

	-- IF THE TEST PRODUCES NO RESULTS INSERT A RECORD TO INDICATE THIS
	if not exists(select top 1 * from app.sqlunittest t
		inner join app.SqlUnitTestCaseResult r
			on t.SqlUnitTestId = r.SqlUnitTestId
			and t.SqlUnitTestId = @SqlUnitTestId)
	begin
		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT DISTINCT
			@SqlUnitTestId
			, 'NO TEST RESULTS'
			, 'NO TEST RESULTS'
			, -1
			, -1
			, 0 
			, GETDATE()
	end

	--check the results
	--  select *
	--  from App.SqlUnitTestCaseResult sr
	--  	inner join App.SqlUnitTest s
	--  		on s.SqlUnitTestId = sr.SqlUnitTestId
	--  where s.TestScope = 'FS141'
	--  and passed = 0
	--  and convert(date, TestDateTime) = convert(date, GETDATE())

END
