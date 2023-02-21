CREATE PROCEDURE [App].[FS006_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C006Staging') IS NOT NULL
	DROP TABLE #C006Staging

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
	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS006_UnitTestCase') 
	BEGIN
		SET @expectedResult = 1
		INSERT INTO App.SqlUnitTest (
			[UnitTestName]
			, [StoredProcedureName]
			, [TestScope]
			, [IsActive]
		)
		VALUES (
			'FS006_UnitTestCase'
			, 'FS006_TestCase'				
			, 'FS006'
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
		WHERE UnitTestName = 'FS006_UnitTestCase'
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
		, sd.IdeaInterimRemoval
		, sd.DisciplineMethodOfCwd AS DisciplineMethod
		, sd.DurationOfDisciplinaryAction
		, '         ' as RemovalLength
		, '         ' as LEPRemovalLength
	INTO #C006Staging
	FROM Staging.K12Enrollment ske
	JOIN Staging.Discipline sd
		ON sd.Student_Identifier_State = ske.Student_Identifier_State
		AND ISNULL(sd.LEA_Identifier_State, '') = ISNULL(ske.LEA_Identifier_State, '')
		AND ISNULL(sd.School_Identifier_State, '') = ISNULL(ske.School_Identifier_State, '')
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
		AND ske.Schoolyear = CAST(@SchoolYear AS VARCHAR)
		AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge, '') <> 'PPPS'
		AND ISNULL(sd.DisciplineMethodOfCwd, '') in ('InSchool','OutOfSchool')
		AND ISNULL(sd.IdeaInterimRemoval, '') NOT IN ('REMDW', 'REMHO')
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

	--Set the EDFacts value for removal length
	UPDATE s
	SET s.RemovalLength = tmp.RemovalLength
	FROM #C006Staging s
		INNER JOIN (
				SELECT Student_Identifier_State, DisciplineMethod
					,CASE 
						WHEN sum(cast(DurationOfDisciplinaryAction as float)) >= 0.5 
							and sum(cast(DurationOfDisciplinaryAction as float)) <= 10 THEN 'LTOREQ10'
						WHEN sum(cast(DurationOfDisciplinaryAction as float)) > 10 THEN 'GREATER10'
						ELSE 'MISSING'
					END AS RemovalLength
				FROM #C006Staging 
				GROUP BY Student_Identifier_State, DisciplineMethod
		) tmp
			ON s.Student_Identifier_State =  tmp.Student_Identifier_State
			AND s.DisciplineMethod = tmp.DisciplineMethod

	--Set the EDFacts value for removal length for the LEP status
	UPDATE s
	SET s.LEPRemovalLength = tmp.LEPRemovalLength
	FROM #C006Staging s
		INNER JOIN (
				SELECT Student_Identifier_State, DisciplineMethod, EnglishLearnerStatusEdFactsCode
					,CASE 
						WHEN sum(cast(DurationOfDisciplinaryAction as float)) >= 0.5 
							and sum(cast(DurationOfDisciplinaryAction as float)) <= 10 THEN 'LTOREQ10'
						WHEN sum(cast(DurationOfDisciplinaryAction as float)) > 10 THEN 'GREATER10'
						ELSE 'MISSING'
					END AS LEPRemovalLength
				FROM #C006Staging 
				GROUP BY Student_Identifier_State, DisciplineMethod, EnglishLearnerStatusEdFactsCode
		) tmp
			ON s.Student_Identifier_State = tmp.Student_Identifier_State
			AND s.DisciplineMethod = tmp.DisciplineMethod
			AND s.EnglishLearnerStatusEdFactsCode = tmp.EnglishLearnerStatusEdFactsCode


	/**********************************************************************
		Test Case 1:
		CSA at the SEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by Disability Category (IDEA)
	***********************************************************************/
	SELECT 
		DisciplineMethod
		, RemovalLength
		, PrimaryDisabilityType
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #S_CSA
	FROM #C006Staging 
	WHERE RemovalLength <> 'MISSING'
	GROUP BY DisciplineMethod
		, RemovalLength
		, PrimaryDisabilityType

	INSERT INTO App.SqlUnitTestCaseResult (
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
		,'CSA SEA Match All'
		,'CSA SEA Match All - Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Disability Type: ' + s.PrimaryDisabilityType
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON s.DisciplineMethod  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSA'

	DROP TABLE #S_CSA

	/**********************************************************************
		Test Case 2:
		CSB at the SEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by Racial Ethnic
	***********************************************************************/
	SELECT 
		DisciplineMethod
		, RemovalLength
		, RaceEdFactsCode
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #S_CSB
	FROM #C006Staging 
	WHERE RemovalLength <> 'MISSING'
	GROUP BY DisciplineMethod
		, RemovalLength
		, RaceEdFactsCode

	INSERT INTO App.SqlUnitTestCaseResult (
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
		,'CSB SEA Match All'
		,'CSB SEA Match All - Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Race: ' + s.RaceEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.DisciplineMethod  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND s.RaceEdFactsCode = rreksd.Race
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSB'
	
	DROP TABLE #S_CSB

		
	/**********************************************************************
		Test Case 3:
		CSC at the SEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by Sex (Membership)
	***********************************************************************/
	SELECT 
		DisciplineMethod
		, RemovalLength
		, SexEdFactsCode
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #S_CSC
	FROM #C006Staging 
	WHERE RemovalLength <> 'MISSING'
	AND SexEdFactsCode <> 'MISSING'
	GROUP BY DisciplineMethod
		, RemovalLength
		, SexEdFactsCode

	INSERT INTO App.SqlUnitTestCaseResult (
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
		,'CSC SEA Match All'
		,'CSC SEA Match All - Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Sex: ' + s.SexEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.DisciplineMethod  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND s.SexEdFactsCode = rreksd.Sex
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSC'
	
	DROP TABLE #S_CSC

		
	/**********************************************************************
		Test Case 4:
		CSD at the SEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by English Learner Status (Both)
	***********************************************************************/
	SELECT 
		DisciplineMethod
		, LEPRemovalLength
		, EnglishLearnerStatusEdFactsCode
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #S_CSD
	FROM #C006Staging 
	WHERE LEPRemovalLength <> 'MISSING'
	GROUP BY DisciplineMethod
		, LEPRemovalLength
		, EnglishLearnerStatusEdFactsCode

	INSERT INTO App.SqlUnitTestCaseResult (
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
		,'CSD SEA Match All'
		,'CSD SEA Match All - Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.LEPRemovalLength 
			+ '; English Learner: ' + s.EnglishLearnerStatusEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.DisciplineMethod  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.LEPRemovalLength = rreksd.RemovalLength
		AND s.EnglishLearnerStatusEdFactsCode = rreksd.EnglishLearnerStatus
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSD'
	
	DROP TABLE #S_CSD


	/**********************************************************************
		Test Case 5:
		ST1 at the SEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions)
	***********************************************************************/
	SELECT 
		DisciplineMethod
		, RemovalLength
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #S_ST1
	FROM #C006Staging 
	WHERE RemovalLength <> 'MISSING'
	GROUP BY DisciplineMethod
		, RemovalLength

	INSERT INTO App.SqlUnitTestCaseResult (
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
		,'ST1 SEA Match All'
		,'ST1 SEA Match All - Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_ST1 s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.DisciplineMethod = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'ST1'
	
	DROP TABLE #S_ST1


	----------------------------------------
	--- LEA level tests					 ---
	----------------------------------------
	/**********************************************************************
		Test Case 7:
		CSA at the LEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by Disability Category (IDEA)
	***********************************************************************/
	SELECT 
		s.LEA_Identifier_State
		, DisciplineMethod
		, RemovalLength
		, PrimaryDisabilityType
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #L_CSA
	FROM #C006Staging s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	AND RemovalLength <> 'MISSING'
	GROUP BY s.LEA_Identifier_State
		, DisciplineMethod
		, RemovalLength
		, PrimaryDisabilityType

	INSERT INTO App.SqlUnitTestCaseResult (
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
		,'CSA LEA Match All'
		,'CSA LEA Match All - LEA Identifier - ' + s.LEA_Identifier_State
			+ '; Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Disability Type: ' + s.PrimaryDisabilityType
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND s.DisciplineMethod  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSA'
	
	DROP TABLE #L_CSA


	/**********************************************************************
		Test Case 8:
		CSB at the LEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by Racial Ethnic
	***********************************************************************/
	SELECT 
		s.LEA_Identifier_State
		, DisciplineMethod
		, RemovalLength
		, RaceEdFactsCode
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #L_CSB
	FROM #C006Staging s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	AND RemovalLength <> 'MISSING'
	GROUP BY s.LEA_Identifier_State
		, DisciplineMethod
		, RemovalLength
		, RaceEdFactsCode

	INSERT INTO App.SqlUnitTestCaseResult (
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
		,'CSB LEA Match All'
		,'CSB LEA Match All - LEA Identifier - ' + s.LEA_Identifier_State
			+ '; Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Race: ' + s.RaceEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND s.DisciplineMethod  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND s.RaceEdFactsCode = rreksd.Race
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSB'
	
	DROP TABLE #L_CSB

		
	/**********************************************************************
		Test Case 9:
		CSC at the LEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by Sex (Membership)
	***********************************************************************/
	SELECT 
		s.LEA_Identifier_State
		, DisciplineMethod
		, RemovalLength
		, SexEdFactsCode
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #L_CSC
	FROM #C006Staging s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	AND RemovalLength <> 'MISSING'
	AND SexEdFactsCode <> 'MISSING'
	GROUP BY s.LEA_Identifier_State
		, DisciplineMethod
		, RemovalLength
		, SexEdFactsCode

	INSERT INTO App.SqlUnitTestCaseResult (
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
		,'CSC LEA Match All'
		,'CSC LEA Match All - LEA Identifier - ' + s.LEA_Identifier_State
			+ '; Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Sex: ' + s.SexEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND s.DisciplineMethod  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND s.SexEdFactsCode = rreksd.Sex
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSC'
	
	DROP TABLE #L_CSC

		
	/**********************************************************************
		Test Case 10:
		CSD at the LEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by English Learner Status (Both)
	***********************************************************************/
	SELECT 
		s.LEA_Identifier_State
		, DisciplineMethod
		, LEPRemovalLength
		, EnglishLearnerStatusEdFactsCode
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #L_CSD
	FROM #C006Staging s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	AND LEPRemovalLength <> 'MISSING'
	GROUP BY s.LEA_Identifier_State
		, DisciplineMethod
		, LEPRemovalLength
		, EnglishLearnerStatusEdFactsCode

	INSERT INTO App.SqlUnitTestCaseResult (
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
		,'CSD LEA Match All'
		,'CSD LEA Match All - LEA Identifier - ' + s.LEA_Identifier_State
			+ '; Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.LEPRemovalLength 
			+ '; English Learner: ' + s.EnglishLearnerStatusEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND s.DisciplineMethod  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.LEPRemovalLength = rreksd.RemovalLength
		AND s.EnglishLearnerStatusEdFactsCode = rreksd.EnglishLearnerStatus
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSD'
	
	DROP TABLE #L_CSD


	/**********************************************************************
		Test Case 11:
		ST1 at the LEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions)
	***********************************************************************/
	SELECT 
		s.LEA_Identifier_State
		, DisciplineMethod
		, RemovalLength
		, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
	INTO #L_ST1
	FROM #C006Staging s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	AND RemovalLength <> 'MISSING'
	GROUP BY s.LEA_Identifier_State
		, DisciplineMethod
		, RemovalLength

	INSERT INTO App.SqlUnitTestCaseResult (
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
		,'ST1 LEA Match All'
		,'ST1 LEA Match All - LEA Identifier - ' + s.LEA_Identifier_State
			+ '; Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_ST1 s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND s.DisciplineMethod  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'ST1'
	
	DROP TABLE #L_ST1

END
