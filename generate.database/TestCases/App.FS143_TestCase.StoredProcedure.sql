CREATE PROCEDURE [App].[FS143_TestCase] 
	@SchoolYear INT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C143Staging') IS NOT NULL
	DROP TABLE #C143Staging

	IF OBJECT_ID('tempdb..#S_CSA') IS NOT NULL
	DROP TABLE #S_CSA
	IF OBJECT_ID('tempdb..#S_CSB') IS NOT NULL
	DROP TABLE #S_CSB
	IF OBJECT_ID('tempdb..#S_CSC') IS NOT NULL
	DROP TABLE #S_CSC
	IF OBJECT_ID('tempdb..#S_CSD') IS NOT NULL
	DROP TABLE #S_CSD
	IF OBJECT_ID('tempdb..#S_ST1') IS NOT NULL
	DROP TABLE #S_ST1

	IF OBJECT_ID('tempdb..#L_CSA') IS NOT NULL
	DROP TABLE #L_CSA
	IF OBJECT_ID('tempdb..#L_CSB') IS NOT NULL
	DROP TABLE #L_CSB
	IF OBJECT_ID('tempdb..#L_CSC') IS NOT NULL
	DROP TABLE #L_CSC
	IF OBJECT_ID('tempdb..#L_CSD') IS NOT NULL
	DROP TABLE #L_CSD
	IF OBJECT_ID('tempdb..#L_ST1') IS NOT NULL
	DROP TABLE #L_ST1

	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT

	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS143_UnitTestCase') 
	BEGIN
		SET @expectedResult = 1
		INSERT INTO App.SqlUnitTest (
			[UnitTestName]
			, [StoredProcedureName]
			, [TestScope]
			, [IsActive]
		)
		VALUES (
			'FS143_UnitTestCase'
			, 'FS143_TestCase'				
			, 'FS143'
			, 1
		)
		SET @SqlUnitTestId = @@IDENTITY
	END 
	ELSE 
	BEGIN
		SELECT 
			@SqlUnitTestId = SqlUnitTestId
		--, @expectedResult = ExpectedResult 
		FROM App.SqlUnitTest 
		WHERE UnitTestName = 'FS143_UnitTestCase'
	END

	-- Clear out last run
	DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
	--Create SY Start / SY End variables
	declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
	declare @SYEnd varchar(10) = CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)

	-- Get Custom Child Count Date
	DECLARE @cutOffMonth INT, @cutOffDay INT, @customFactTypeDate VARCHAR(10), @childCountDate date
	set @cutOffMonth = 11
	set @cutOffDay = 1

	select @customFactTypeDate = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CHDCTDTE'

	select @cutOffMonth = SUBSTRING(@customFactTypeDate, 0, CHARINDEX('/', @customFactTypeDate))
	select @cutOffDay = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)

    select @ChildCountDate = convert(varchar, @CutoffMonth) + '/' + convert(varchar, @CutoffDay) + '/' + convert(varchar, @SchoolYear -1)

	-- Identify studentw who have more than .5 day of duration
	IF OBJECT_ID('tempdb..#StudentsWithEnoughDuration') IS NOT NULL
	DROP TABLE #StudentsWithEnoughDuration

	CREATE TABLE #StudentsWithEnoughDuration (
		StudentIdentifierState	VARCHAR(60)
	)

	INSERT INTO #StudentsWithEnoughDuration
	SELECT ske.StudentIdentifierState 
		FROM Staging.Discipline sd 
		JOIN staging.K12Enrollment ske 
			ON sd.StudentIdentifierState = ske.StudentIdentifierState
			AND ISNULL(sd.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
			AND ISNULL(sd.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
			AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') between ISNULL(ske.EnrollmentEntryDate, '1900-01-01') and ISNULL (ske.EnrollmentExitDate, GETDATE()) 
		JOIN Staging.ProgramParticipationSpecialEducation sppe
			ON sppe.StudentIdentifierState = sd.StudentIdentifierState
			AND ISNULL(sppe.LeaIdentifierSeaAccountability, '') = ISNULL(sd.LeaIdentifierSeaAccountability, '')
			AND ISNULL(sppe.SchoolIdentifierSea, '') = ISNULL(sd.SchoolIdentifierSea, '')
			--Discipline Date within Program Participation range
			AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
				BETWEEN ISNULL(sppe.ProgramParticipationBeginDate, CAST('07/01/' + CAST(2023 - 1 AS VARCHAR(4)) AS DATE)) 
				AND ISNULL(sppe.ProgramParticipationEndDate, CAST('06/30/' + CAST(2023 AS VARCHAR(4)) AS DATE))
			GROUP BY ske.StudentIdentifierState 
			HAVING SUM(CAST(sd.DurationOfDisciplinaryAction AS DECIMAL(6, 3))) >= 0.5

	CREATE INDEX IX_StudentsWithEnoughDuration ON #StudentsWithEnoughDuration(StudentIdentifierState)

	--Get the LEAs that should not be reported against
	IF OBJECT_ID('tempdb..#excludedLeas') IS NOT NULL
	DROP TABLE #excludedLeas

	CREATE TABLE #excludedLeas (
		LeaIdentifierSeaAccountability		VARCHAR(20)
	)

	INSERT INTO #excludedLeas 
	SELECT DISTINCT LEAIdentifierSea
	FROM Staging.K12Organization
	WHERE LEA_IsReportedFederally = 0
		OR LEA_OperationalStatus in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')

	SELECT  
		ske.StudentIdentifierState
		, ske.LeaIdentifierSeaAccountability
		, ske.SchoolIdentifierSea
		, ske.Birthdate
		, ske.HispanicLatinoEthnicity
		, ske.Sex
		, CASE ske.Sex
			WHEN 'Male'		THEN 'M'
			WHEN 'Female'	THEN 'F'
			ELSE 'MISSING'
			END AS SexEdFactsCode
		, sppse.ProgramParticipationEndDate
		, CASE sidt.IdeaDisabilityTypeCode
			WHEN 'Autism'						THEN 'AUT'
            WHEN 'Deafblindness'				THEN 'DB'
            WHEN 'Deafness'						THEN 'DB'
            WHEN 'Developmentaldelay'			THEN 'DD'
            WHEN 'Emotionaldisturbance'			THEN 'EMN'
            WHEN 'Hearingimpairment'			THEN 'HI'
            WHEN 'Intellectualdisability'		THEN 'ID'
            WHEN 'Multipledisabilities'			THEN 'MD'
            WHEN 'Orthopedicimpairment'			THEN 'OI'
            WHEN 'Otherhealthimpairment'		THEN 'OHI'
            WHEN 'Specificlearningdisability'	THEN 'SLD'
            WHEN 'Speechlanguageimpairment'		THEN 'SLI'
            WHEN 'Traumaticbraininjury'			THEN 'TBI'
            WHEN 'Visualimpairment'				THEN 'VI'
            ELSE sidt.IdeaDisabilityTypeCode
		END AS IdeaDisabilityType
		, spr.RaceType
		, rdr.RaceEdFactsCode
		, CASE
			WHEN ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
				BETWEEN ISNULL(sps.EnglishLearner_StatusStartDate, @SYStart) AND ISNULL(sps.EnglishLearner_StatusEndDate, @SYEnd) 
					THEN ISNULL(EnglishLearnerStatus, 0)
			ELSE 0
			END AS EnglishLearnerStatus
		, CASE
			WHEN ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
				BETWEEN ISNULL(sps.EnglishLearner_StatusStartDate, @SYStart) AND ISNULL(sps.EnglishLearner_StatusEndDate, @SYEnd) 
					THEN 
						CASE 
							WHEN EnglishLearnerStatus = 1 THEN 'LEP'
							ELSE 'NLEP'
						END
			ELSE 'NLEP'
			END AS EnglishLearnerStatusEdFactsCode
		, sd.DisciplineMethodOfCwd
        , sd.DisciplinaryActionTaken
        , sd.IdeaInterimRemovalReason
        , sd.IdeaInterimRemoval
		, sd.DurationOfDisciplinaryAction
	INTO #C143Staging
	FROM Staging.K12Enrollment ske
	JOIN Staging.Discipline sd
		ON sd.StudentIdentifierState = ske.StudentIdentifierState
		AND ISNULL(sd.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sd.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(ske.EnrollmentEntryDate, @SYStart) and ISNULL (ske.EnrollmentExitDate, @SYEnd)
	JOIN Staging.ProgramParticipationSpecialEducation sppse
		ON sppse.StudentIdentifierState = ske.StudentIdentifierState
		AND ISNULL(sppse.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sppse.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
		--Discipline Date within Program Participation range
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(sppse.ProgramParticipationBeginDate, @SYStart) AND ISNULL(sppse.ProgramParticipationEndDate, @SYEnd)
	JOIN #StudentsWithEnoughDuration swed
		ON ske.StudentIdentifierState = swed.StudentIdentifierState
	LEFT JOIN Staging.IdeaDisabilityType sidt
        ON ske.StudentIdentifierState = sidt.StudentIdentifierState
        AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(sidt.LeaIdentifierSeaAccountability, '')
        AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(sidt.SchoolIdentifierSea, '')
        AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE)  
			BETWEEN sidt.RecordStartDateTime AND ISNULL(sidt.RecordEndDateTime, GETDATE())
        AND sidt.IsPrimaryDisability = 1
	LEFT JOIN Staging.PersonStatus sps
		ON sps.StudentIdentifierState = sd.StudentIdentifierState
		AND ISNULL(sps.LeaIdentifierSeaAccountability, '') = ISNULL(sd.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sps.SchoolIdentifierSea, '') = ISNULL(sd.SchoolIdentifierSea, '')
		--Discipline Date within English Learner range
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(sps.EnglishLearner_StatusStartDate, @SYStart) and ISNULL (sps.EnglishLearner_StatusEndDate, @SYEnd)
	LEFT JOIN RDS.vwUnduplicatedRaceMap spr --  Using a view that resolves multiple race records by returning the value TwoOrMoreRaces
		ON spr.SchoolYear = @SchoolYear
		AND ske.StudentIdentifierState = spr.StudentIdentifierState
		AND ISNULL(ske.LEAIdentifierSeaAccountability,'')	= ISNULL(spr.LeaIdentifierSeaAccountability,'')
		AND ISNULL(ske.SchoolIdentifierSea,'') 				= ISNULL(spr.SchoolIdentifierSea,'')
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, @SYEnd)
	LEFT JOIN #vwRaces rdr
		ON rdr.SchoolYear = @SchoolYear
		AND ISNULL(rdr.RaceMap, rdr.RaceCode) =
			CASE
				WHEN ske.HispanicLatinoEthnicity = 1 THEN 'HispanicorLatinoEthnicity'
				WHEN spr.RaceMap IS NOT NULL THEN spr.RaceMap
				ELSE 'Missing'
			END
	WHERE sppse.IDEAIndicator = 1
		AND ske.Schoolyear = CAST(@SchoolYear AS VARCHAR)
		AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge, '') NOT IN ('PPPS', 'PPPS_1')
		AND rds.Get_Age(ske.Birthdate, @ChildCountDate) BETWEEN 3 AND 21	
		AND (ISNULL(sd.DisciplineMethodOfCwd, '') <> ''
			OR sd.DisciplinaryActionTaken IN ('03086', '03087', '03086_1', '03087_1')
			OR ISNULL(sd.IdeaInterimRemovalReason, '') <> ''
            OR ISNULL(sd.IdeaInterimRemoval, '') <> '')
		--Discipline Date with SY range 
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN @SYStart AND @SYEnd

--temp fix to address bad test records
		AND ske.StudentIdentifierState not like 'CIID%'

	-- Gather, evaluate & record the results
	/**********************************************************************
		Test Case 1:
		CSA at the SEA level
	***********************************************************************/
	SELECT 
		IdeaDisabilityType
		, COUNT(*) AS StudentCount
	INTO #S_CSA
	FROM #C143staging 
	GROUP BY IdeaDisabilityType
		
	INSERT INTO App.SqlUnitTestCaseResult (
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
		, 'CSA SEA Match All'
		, 'CSA SEA Match All - Disability Type: ' + s.IdeaDisabilityType
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaDisabilityType = rreksd.IDEADISABILITYTYPE
		AND rreksd.ReportCode = 'C143' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSA'
	
	DROP TABLE #S_CSA

	/**********************************************************************
		Test Case 2:
		CSB at the SEA level
	***********************************************************************/
	SELECT 
		RaceEdFactsCode
		, COUNT(*) AS StudentCount
	INTO #S_CSB
	FROM #C143staging 
	GROUP BY RaceEdFactsCode

	INSERT INTO App.SqlUnitTestCaseResult (
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
		, 'CSB SEA Match All'
		, 'CSB SEA Match All - Race: ' + CAST(s.RaceEdFactsCode AS VARCHAR(3)) 
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.RaceEdFactsCode = rreksd.RACE
		AND rreksd.ReportCode = 'C143' 
		AND rreksd.ReportYear = 2023--@SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSB'

	DROP TABLE #S_CSB

	/**********************************************************************
		Test Case 3:
		CSC at the SEA level
	***********************************************************************/
	SELECT 
		SexEdFactsCode
		, COUNT(*) AS StudentCount
	INTO #S_CSC
	FROM #C143staging 
	WHERE SexEdFactsCode <> 'MISSING'	
	GROUP BY SexEdFactsCode
		
	INSERT INTO App.SqlUnitTestCaseResult (
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
		, 'CSC SEA Match All'
		, 'CSC SEA Match All - Sex: ' + CAST(s.SexEdFactsCode AS VARCHAR(10)) 
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.SexEdFactsCode = rreksd.SEX
		AND rreksd.ReportCode = 'C143' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSC'

	DROP TABLE #S_CSC

	
	/**********************************************************************
		Test Case 4:
		CSD at the SEA level
	***********************************************************************/
	SELECT 
		EnglishLearnerStatusEdFactsCode
		, COUNT(*) AS StudentCount
	INTO #S_CSD
	FROM #C143staging
	WHERE EnglishLearnerStatusEdFactsCode in ('LEP','NLEP')
	GROUP BY EnglishLearnerStatusEdFactsCode
		
	INSERT INTO App.SqlUnitTestCaseResult (
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
		, 'CSD SEA Match All'
		, 'CSD SEA Match All - EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(4)) 
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSD s
	LEFT  JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
		AND rreksd.ReportCode = 'C143' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSD'
			
	DROP TABLE #S_CSD


	/**********************************************************************
		Test Case 5:
		ST1 at the SEA level
	***********************************************************************/
	SELECT 
		COUNT(*) AS StudentCount
	INTO #S_ST1
	FROM #C143staging 
		
	INSERT INTO App.SqlUnitTestCaseResult (
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
		, 'TOT SEA Match All'
		, 'TOT SEA Match All'
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_ST1 s
	LEFT  JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON rreksd.ReportCode = 'C143' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'TOT'
			
	DROP TABLE #S_ST1



	----------------------------------------
	--- LEA level tests					 ---
	----------------------------------------
	/**********************************************************************
		Test Case 1:
		CSA at the LEA level
	***********************************************************************/
	SELECT 
		IdeaDisabilityType
		, s.LeaIdentifierSeaAccountability
		, COUNT(*) AS StudentCount
	INTO #L_CSA
	FROM #C143staging  s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	GROUP BY s.LeaIdentifierSeaAccountability
		, IdeaDisabilityType
		
	INSERT INTO App.SqlUnitTestCaseResult (
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
		, 'CSA LEA Match All'
		, 'CSA LEA Match All - LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability 
			+ '; Disability Type: ' + s.IdeaDisabilityType
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
		AND s.IdeaDisabilityType = rreksd.IdeaDisabilityType
		AND rreksd.ReportCode = 'C143' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSA'

	DROP TABLE #L_CSA


	/**********************************************************************
		Test Case 2:
		CSB at the LEA level
	***********************************************************************/
	SELECT 
		RaceEdFactsCode
		, s.LeaIdentifierSeaAccountability
		, COUNT(*) AS StudentCount
	INTO #L_CSB
	FROM #C143staging  s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	GROUP BY s.LeaIdentifierSeaAccountability
		, RaceEdFactsCode
		

	INSERT INTO App.SqlUnitTestCaseResult (
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
		, 'CSB LEA Match All'
		, 'CSB LEA Match All - LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability 
			+ '; Race: ' + CAST(s.RaceEdFactsCode AS VARCHAR(3))  
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON s.RaceEdFactsCode = rreksd.RACE
		AND s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
		AND rreksd.ReportCode = 'C143' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSB'

	DROP TABLE #L_CSB


	/**********************************************************************
		Test Case 3:
		CSC at the LEA level
	***********************************************************************/
	SELECT 
		SexEdFactsCode
		, s.LeaIdentifierSeaAccountability
		, COUNT(*) AS StudentCount
	INTO #L_CSC
	FROM #C143staging s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	AND SexEdFactsCode <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
		, SexEdFactsCode
		
	INSERT INTO App.SqlUnitTestCaseResult (
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
		, 'CSC LEA Match All'
		, 'CSC LEA Match All - LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability 
			+ '; Sex: ' + CAST(s.SexEdFactsCode AS VARCHAR(10)) 
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON s.SexEdFactsCode = rreksd.SEX
		AND s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
		AND rreksd.ReportCode = 'C143' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSC'

	DROP TABLE #L_CSC


	/**********************************************************************
		Test Case 4:
		CSD at the LEA level
	***********************************************************************/
	SELECT 
		EnglishLearnerStatusEdFactsCode
		, s.LeaIdentifierSeaAccountability
		, COUNT(*) AS StudentCount
	INTO #L_CSD
	FROM #C143staging  s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	AND EnglishLearnerStatusEdFactsCode in ('LEP','NLEP')
	GROUP BY s.LeaIdentifierSeaAccountability
		, EnglishLearnerStatusEdFactsCode
		
	INSERT INTO App.SqlUnitTestCaseResult (
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
		, 'CSD LEA Match All'
		, 'CSD LEA Match All - LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability 
			+ '; EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(4)) 								
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
		AND s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
		AND rreksd.ReportCode = 'C143' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSD'
			
	DROP TABLE #L_CSD


	/**********************************************************************
		Test Case 5:
		TOT at the LEA level
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, COUNT(*) AS StudentCount
	INTO #L_ST1
	FROM #C143staging  s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	GROUP BY s.LeaIdentifierSeaAccountability
		
	INSERT INTO App.SqlUnitTestCaseResult (
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
		, 'TOT LEA Match All'
		, 'TOT LEA Match All - LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability 
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_ST1 s
	LEFT  JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
		AND rreksd.ReportCode = 'C143' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'TOT'
			
	DROP TABLE #L_ST1

	--check the results

	--select *
	--from App.SqlUnitTestCaseResult sr
	--	inner join App.SqlUnitTest s
	--		on s.SqlUnitTestId = sr.SqlUnitTestId
	--where s.UnitTestName like '%143%'
	--and passed = 0


END
