CREATE PROCEDURE [App].[FS005_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C005Staging') IS NOT NULL
	DROP TABLE #C005Staging

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
	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS005_UnitTestCase') 

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
			'FS005_UnitTestCase'
			, 'FS005_TestCase'				
			, 'FS005'
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
		WHERE UnitTestName = 'FS005_UnitTestCase'
	END
	
	-- Clear out last run
	DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId

	--Create SY Start / SY End variables
	declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
	declare @SYEnd varchar(10) = CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)

	-- Get Custom Child Count Date
	DECLARE @cutOffMonth INT, @cutOffDay INT, @customFactTypeDate VARCHAR(10)
	set @cutOffMonth = 11
	set @cutOffDay = 1

	select @customFactTypeDate = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CHDCTDTE'

	select @cutOffMonth = SUBSTRING(@customFactTypeDate, 0, CHARINDEX('/', @customFactTypeDate))
	select @cutOffDay = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)
		
	--Get the LEAs that should not be reported against
	IF OBJECT_ID('tempdb..#notReportedFederallyLeas') IS NOT NULL
	DROP TABLE #notReportedFederallyLeas

	CREATE TABLE #notReportedFederallyLeas (
		LEA_Identifier_State		VARCHAR(20)
	)

	INSERT INTO #notReportedFederallyLeas 
	SELECT DISTINCT LEA_Identifier_State
	FROM Staging.K12Organization
	WHERE LEA_IsReportedFederally = 0

	
	-- Gather, evaluate & record the results
	SELECT  
		ske.Student_Identifier_State
		, ske.LEA_Identifier_State
		, ske.School_Identifier_State
		, sppse.ProgramParticipationEndDate
		, ske.Birthdate
		, sps.PrimaryDisabilityType
		, ske.HispanicLatinoEthnicity
		, spr.RaceType
		, rdr.RaceEdFactsCode
		, ske.Sex
		, CASE ske.Sex
			WHEN 'Male' THEN 'M'
			WHEN 'Female' THEN 'F'
			ELSE 'MISSING'
			END AS SexEdFactsCode
		, CASE
			WHEN ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
				BETWEEN ISNULL(sps.EnglishLearner_StatusStartDate, @SYStart)  
					AND ISNULL(sps.EnglishLearner_StatusEndDate, @SYEnd) 
					THEN ISNULL(EnglishLearnerStatus, 0)
			ELSE 0
			END AS EnglishLearnerStatus
		, CASE
			WHEN ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
				BETWEEN ISNULL(sps.EnglishLearner_StatusStartDate, @SYStart)  
					AND ISNULL(sps.EnglishLearner_StatusEndDate, @SYEnd) 
					THEN 
						CASE 
							WHEN EnglishLearnerStatus = 1 THEN 'LEP'
							--WHEN ISNULL(EnglishLearnerStatus, 0) = 0 THEN 'NLEP'
							ELSE 'NLEP'
						END
			ELSE 'NLEP'
			END AS EnglishLearnerStatusEdFactsCode
		, sd.IdeaInterimRemoval
		, convert(int, round(cast(sd.DurationOfDisciplinaryAction as decimal(5,2)),0,0)) DurationOfDisciplinaryAction
	INTO #C005Staging
	FROM Staging.K12Enrollment ske
	JOIN Staging.Discipline sd
		ON sd.Student_Identifier_State = ske.Student_Identifier_State
		AND ISNULL(sd.LEA_Identifier_State, '') = ISNULL(ske.LEA_Identifier_State, '')
		AND ISNULL(sd.School_Identifier_State, '') = ISNULL(ske.School_Identifier_State, '')
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN ISNULL(ske.EnrollmentEntryDate, @SYStart) and ISNULL (ske.EnrollmentExitDate, @SYEnd)
	JOIN Staging.PersonStatus sps
		ON sps.Student_Identifier_State = sd.Student_Identifier_State
		AND ISNULL(sps.LEA_Identifier_State, '') = ISNULL(sd.LEA_Identifier_State, '')
		AND ISNULL(sps.School_Identifier_State, '') = ISNULL(sd.School_Identifier_State, '')
		--Discipline Date within IDEA range
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN ISNULL(sps.IDEA_StatusStartDate, @SYStart) AND ISNULL (sps.IDEA_StatusEndDate, @SYEnd)
	JOIN Staging.ProgramParticipationSpecialEducation sppse
		ON sppse.Student_Identifier_State = sps.Student_Identifier_State
		AND ISNULL(sppse.LEA_Identifier_State, '') = ISNULL(sps.LEA_Identifier_State, '')
		AND ISNULL(sppse.School_Identifier_State, '') = ISNULL(sps.School_Identifier_State, '')
		--Discipline Date within Program Participation range
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN ISNULL(sppse.ProgramParticipationBeginDate, @SYStart) AND ISNULL(sppse.ProgramParticipationEndDate, @SYEnd)
	LEFT JOIN Staging.PersonRace spr
		ON spr.Student_Identifier_State = ske.Student_Identifier_State
		AND spr.SchoolYear = ske.SchoolYear
		AND ISNULL(sppse.ProgramParticipationEndDate, spr.RecordStartDateTime) 
			BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, @SYEnd)
	LEFT JOIN RDS.DimRaces rdr
		ON (ske.HispanicLatinoEthnicity = 1 and rdr.RaceEdFactsCode = 'HI7')
			OR (ske.HispanicLatinoEthnicity = 0 AND spr.RaceType = rdr.RaceCode)
	WHERE sps.IDEAIndicator = 1
	AND PrimaryDisabilityType IS NOT NULL 
	AND IdeaInterimRemoval in ('REMDW', 'REMHO')
	AND ske.Schoolyear = CAST(@SchoolYear AS VARCHAR)
	AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge, '') <> 'PPPS'
	AND rds.Get_Age(ske.Birthdate, DATEFROMPARTS(CASE WHEN @cutOffMonth >= 7 THEN @SchoolYear - 1 
		ELSE @SchoolYear 
		END, @cutOffMonth, @cutOffDay)
		) BETWEEN 3 AND 21      
	--Discipline Date within Enrollment range
	AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
		BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEnd)
	--Discipline Date with SY range 
	AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
		BETWEEN @SYStart AND @SYEnd

	--Get the students that have more than 45 days removal time
	SELECT e.Student_Identifier_State 
	INTO #tempDurationLengthExceeded
	FROM Staging.Discipline d 
	JOIN staging.K12Enrollment e 
		ON d.Student_Identifier_State = e.Student_Identifier_State
		AND ISNULL(d.LEA_Identifier_State, '') = ISNULL(e.LEA_Identifier_State, '')
		AND ISNULL(d.School_Identifier_State, '') = ISNULL(e.School_Identifier_State, '')
		AND ISNULL(d.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN ISNULL(e.EnrollmentEntryDate, @SYStart) and ISNULL (e.EnrollmentExitDate, @SYEnd) 
	JOIN staging.PersonStatus p 
		ON d.Student_Identifier_State = p.Student_Identifier_State
		AND ISNULL(d.LEA_Identifier_State, '') = ISNULL(p.LEA_Identifier_State, '')
		AND ISNULL(d.School_Identifier_State, '') = ISNULL(p.School_Identifier_State, '')
		AND ISNULL(d.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN ISNULL(p.IDEA_StatusStartDate, @SYStart) and ISNULL (p.IDEA_StatusEndDate, @SYEnd) 
	WHERE d.IdeaInterimRemoval in ('REMDW', 'REMHO')
	GROUP BY e.Student_Identifier_State 
	HAVING SUM(CAST(DurationOfDisciplinaryAction AS DECIMAL(5, 2))) > 45

	--Remove the +45 day students from the staging data used for the test
	DELETE s
	FROM #C005Staging s
	LEFT JOIN #tempDurationLengthExceeded t
		ON s.Student_Identifier_State = t.Student_Identifier_State
	WHERE t.Student_Identifier_State is not null

			
	/**********************************************************************
		Test Case 1:
		CSA at the SEA level
	***********************************************************************/
	SELECT 
			IdeaInterimRemoval
		, PrimaryDisabilityType
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #S_CSA
	FROM #C005staging 
	GROUP BY IdeaInterimRemoval
		, PrimaryDisabilityType
		
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
		, 'CSA SEA Match All'
		, 'CSA SEA Match All - IdeaInterimRemoval: ' +  s.IdeaInterimRemoval 
							+ ' Disability Type: ' + s.PrimaryDisabilityType
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemoval= rreksd.IDEAINTERIMREMOVAL
		AND s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSA'
	
	DROP TABLE #S_CSA


	/**********************************************************************
		Test Case 2:
		CSB at the SEA level
	***********************************************************************/
	SELECT 
		IdeaInterimRemoval
		, RaceEdFactsCode
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #S_CSB
	FROM #C005staging 
	GROUP BY IdeaInterimRemoval
		, RaceEdFactsCode
		

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
		, 'CSB SEA Match All'
		, 'CSB SEA Match All - Race: ' + CAST(s.RaceEdFactsCode AS VARCHAR(3)) 
			+  '; s.IdeaInterimRemoval: ' + s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemoval= rreksd.IDEAINTERIMREMOVAL
		AND s.RaceEdFactsCode = rreksd.RACE
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSB'

	DROP TABLE #S_CSB



	/**********************************************************************
		Test Case 3:
		CSC at the SEA level
	***********************************************************************/
	SELECT 
			IdeaInterimRemoval
		, SexEdFactsCode
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #S_CSC
	FROM #C005staging 
	WHERE SexEdFactsCode <> 'MISSING'
	GROUP BY IdeaInterimRemoval
		, SexEdFactsCode
		
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
		, 'CSC SEA Match All'
		, 'CSC SEA Match All - Sex: ' + s.SexEdFactsCode
			+  '; s.IdeaInterimRemoval: '+ s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemoval= rreksd.IDEAINTERIMREMOVAL
		AND s.SexEdFactsCode = rreksd.SEX
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSC'

	DROP TABLE #S_CSC

	
	/**********************************************************************
		Test Case 4:
		CSD at the SEA level
	***********************************************************************/
	SELECT 
			IdeaInterimRemoval
		, EnglishLearnerStatusEdFactsCode
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #S_CSD
	FROM #C005staging
	WHERE EnglishLearnerStatusEdFactsCode in ('LEP','NLEP')
	GROUP BY IdeaInterimRemoval
		, EnglishLearnerStatusEdFactsCode
		
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
		, 'CSD SEA Match All'
		, 'CSD SEA Match All - EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) 
			+  '; s.IdeaInterimRemoval: ' + s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSD s
	LEFT  JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemoval= rreksd.IDEAINTERIMREMOVAL
		AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSD'
			
	DROP TABLE #S_CSD


	/**********************************************************************
		Test Case 5:
		ST1 at the SEA level
	***********************************************************************/
	SELECT 
			IdeaInterimRemoval
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #S_ST1
	FROM #C005staging 
	GROUP BY IdeaInterimRemoval
		
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
		, 'ST1 SEA Match All'
		, 'ST1 SEA Match All - Interim Removal (IDEA): ' + s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_ST1 s
	LEFT  JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemoval= rreksd.IDEAINTERIMREMOVAL
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'ST1'
			
	DROP TABLE #S_ST1



	----------------------------------------
	--- LEA level tests					 ---
	----------------------------------------
	/**********************************************************************
		Test Case 1:
		CSA at the LEA level
	***********************************************************************/
	SELECT 
			IdeaInterimRemoval
		, PrimaryDisabilityType
		, s.LEA_Identifier_State
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #L_CSA
	FROM #C005staging  s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	GROUP BY s.LEA_Identifier_State
		, IdeaInterimRemoval
		, PrimaryDisabilityType
		

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
		, 'CSA LEA Match All'
		, 'CSA LEA Match All - LEA_Identifier_State: ' + s.LEA_Identifier_State 
			+ '; IdeaInterimRemoval: ' + s.IdeaInterimRemoval 
			+ '; Disability Type: ' + s.PrimaryDisabilityType
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemoval= rreksd.IDEAINTERIMREMOVAL
		AND s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSA'

	DROP TABLE #L_CSA


	/**********************************************************************
		Test Case 2:
		CSB at the LEA level
	***********************************************************************/
	SELECT 
			IdeaInterimRemoval
		, RaceEdFactsCode
		, s.LEA_Identifier_State
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #L_CSB
	FROM #C005staging  s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	GROUP BY s.LEA_Identifier_State
		, IdeaInterimRemoval
		, RaceEdFactsCode
		

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
		, 'CSB LEA Match All'
		, 'CSB LEA Match All - LEA_Identifier_State: ' + s.LEA_Identifier_State 
			+ '; Race: ' + CAST(s.RaceEdFactsCode AS VARCHAR(3))  
			+ '; IdeaInterimRemoval: ' +s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSB s
	JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON s.IdeaInterimRemoval = rreksd.IdeaInterimRemoval
		AND s.RaceEdFactsCode = rreksd.RACE
		AND s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSB'

	DROP TABLE #L_CSB


	/**********************************************************************
		Test Case 3:
		CSC at the LEA level
	***********************************************************************/
	SELECT 
			IdeaInterimRemoval
		, SexEdFactsCode
		, s.LEA_Identifier_State
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #L_CSC
	FROM #C005staging  s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	AND SexEdFactsCode <> 'MISSING'
	GROUP BY s.LEA_Identifier_State
		, IdeaInterimRemoval
		, SexEdFactsCode
		
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
		, 'CSC LEA Match All'
		, 'CSC LEA Match All - LEA_Identifier_State: ' + s.LEA_Identifier_State 
							+ '; Sex: ' + s.SexEdFactsCode
							+ '; IdeaInterimRemoval: ' + s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSC s
	JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON s.IdeaInterimRemoval = rreksd.IdeaInterimRemoval
		AND s.SexEdFactsCode = rreksd.SEX
		AND s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSC'

	DROP TABLE #L_CSC

	/**********************************************************************
		Test Case 4:
		CSD at the LEA level
	***********************************************************************/
	SELECT 
			IdeaInterimRemoval
		, EnglishLearnerStatusEdFactsCode
		, s.LEA_Identifier_State
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #L_CSD
	FROM #C005staging s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	AND EnglishLearnerStatusEdFactsCode in ('LEP','NLEP')
	GROUP BY s.LEA_Identifier_State
		, IdeaInterimRemoval
		, EnglishLearnerStatusEdFactsCode
		
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
		, 'CSD LEA Match All'
		, 'CSD LEA Match All - LEA_Identifier_State: ' + s.LEA_Identifier_State 
							+ '; EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) 
							+  '; IdeaInterimRemoval: ' + s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON s.IdeaInterimRemoval = rreksd.IdeaInterimRemoval
		AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
		AND s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSD'
			
	DROP TABLE #L_CSD


	/**********************************************************************
		Test Case 5:
		ST1 at the LEA level
	***********************************************************************/
	SELECT 
			IdeaInterimRemoval
		, s.LEA_Identifier_State
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #L_ST1
	FROM #C005staging s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	GROUP BY s.LEA_Identifier_State
		, IdeaInterimRemoval
		
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
		, 'ST1 LEA Match All'
		, 'ST1 LEA Match All - LEA_Identifier_State: ' + s.LEA_Identifier_State 
							+ '; IdeaInterimRemoval: ' + s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_ST1 s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON s.IdeaInterimRemoval = rreksd.IdeaInterimRemoval
		AND s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'ST1'
			
	DROP TABLE #L_ST1

END