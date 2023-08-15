CREATE PROCEDURE [App].[FS007_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C007Staging') IS NOT NULL
	DROP TABLE #C007Staging

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
	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS007_UnitTestCase') 
	BEGIN
		SET @expectedResult = 1
		INSERT INTO App.SqlUnitTest (
			[UnitTestName]
			, [StoredProcedureName]
			, [TestScope]
			, [IsActive]
		)
		VALUES (
			'FS007_UnitTestCase'
			, 'FS007_TestCase'				
			, 'FS007'
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
		WHERE UnitTestName = 'FS007_UnitTestCase'
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
	SELECT DISTINCT 
		ske.Student_Identifier_State
		, ske.LEA_Identifier_State
		, ske.School_Identifier_State
		, sppse.ProgramParticipationEndDate
		, ske.Birthdate
		--, [RDS].[Get_Age](ske.BirthDate, DATEADD(year, -1, cast(sd.DisciplinaryActionStartDate as varchar(10)))) Age
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
							WHEN ISNULL(EnglishLearnerStatus, 0) = 0 THEN 'NLEP'
							ELSE 'NLEP'
						END
			ELSE 'NLEP'
			END AS EnglishLearnerStatusEdFactsCode
		, sd.IncidentIdentifier
		, sd.DisciplinaryActionTaken
		, sd.IdeaInterimRemoval
		, CASE sd.IdeaInterimRemoval
			WHEN 'REMDW' THEN 'REMDW'
			WHEN 'REMHO' THEN 'REMHO'
			ELSE 'MISSING'
		END AS IdeaInterimRemovalEdFactsCode
		, sd.IdeaInterimRemovalReason
		, CASE sd.IdeaInterimRemovalReason
			WHEN 'Drugs' THEN 'D'
			WHEN 'Weapons' THEN 'W'
			WHEN 'SeriousBodilyInjury' THEN 'SBI'
			ELSE 'MISSING'
		END as IdeaInterimRemovalReasonEdFactsCode
		, convert(int, round(cast(sd.DurationOfDisciplinaryAction as decimal(5,2)),0,0)) DurationOfDisciplinaryAction
	INTO #C007Staging
	FROM Staging.K12Enrollment ske
	JOIN Staging.Discipline sd
		ON sd.Student_Identifier_State = ske.Student_Identifier_State
		AND ISNULL(sd.LEA_Identifier_State, '') = ISNULL(ske.LEA_Identifier_State, '')
		AND ISNULL(sd.School_Identifier_State, '') = ISNULL(ske.School_Identifier_State, '')
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN ISNULL(ske.EnrollmentEntryDate, @SYStart) AND ISNULL (ske.EnrollmentExitDate, @SYEnd)
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
		AND ske.Schoolyear = CAST(@SchoolYear as varchar)
		AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge, '') <> 'PPPS'
		AND sd.IdeaInterimRemoval in ('REMDW')
--			AND ske.GradeLevel in ('KG', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN sps.IDEA_StatusStartDate AND ISNULL (sps.IDEA_StatusEndDate, @SYEnd)
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEnd)
		AND rds.Get_Age(ske.Birthdate, DATEFROMPARTS(CASE WHEN @cutOffMonth >= 7 THEN @SchoolYear - 1 
														ELSE @SchoolYear 
													END, @cutOffMonth, @cutOffDay)
						) BETWEEN 3 AND 21	

	--Get the students that have more than 45 days removal time
	SELECT d.Student_Identifier_State 
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
	WHERE d.IdeaInterimRemoval in ('REMDW')
	GROUP BY d.Student_Identifier_State
	HAVING SUM(CAST(DurationOfDisciplinaryAction AS DECIMAL(5, 2))) > 45

	--Remove the +45 day students from the staging data used for the test
	DELETE s
	FROM #C007Staging s
	LEFT JOIN #tempDurationLengthExceeded t
		ON s.Student_Identifier_State = t.Student_Identifier_State
	WHERE t.Student_Identifier_State is not null


	/**********************************************************************
		Test Case 1:
		CSA at the SEA level - Student Count by Interim Removal Reason (IDEA) by Disability Category (IDEA)
	***********************************************************************/
	SELECT 
		IdeaInterimRemovalReasonEdFactsCode
		, PrimaryDisabilityType
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #S_CSA
	FROM #C007Staging 
	WHERE IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	GROUP BY IdeaInterimRemovalReasonEdFactsCode
		, PrimaryDisabilityType

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
		, 'CSA SEA Match All - IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			+ '; Disability Type: ' + s.PrimaryDisabilityType
		, s.IncidentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAINTERIMREMOVALREASON
		AND s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSA'
	
	DROP TABLE #S_CSA

	/**********************************************************************
		Test Case 2:
		CSB at the SEA level - Student Count by Interim Removal Reason (IDEA) by Racial Ethnic
	***********************************************************************/
	SELECT 
		IdeaInterimRemovalReasonEdFactsCode
		, RaceEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #S_CSB
	FROM #C007Staging 
	WHERE IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	GROUP BY IdeaInterimRemovalReasonEdFactsCode
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
		,'CSB SEA Match All - IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			+ '; Race: ' + s.RaceEdFactsCode
		,s.IncidentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND s.RaceEdFactsCode = rreksd.Race
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSB'
	
	DROP TABLE #S_CSB

		
	/**********************************************************************
		Test Case 3:
		CSC at the SEA level - Student Count by Interim Removal Reason (IDEA) by Sex (Membership)
	***********************************************************************/
	SELECT 
		IdeaInterimRemovalReasonEdFactsCode
		, SexEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #S_CSC
	FROM #C007Staging 
	WHERE IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	AND SexEdFactsCode <> 'MISSING'
	GROUP BY IdeaInterimRemovalReasonEdFactsCode
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
		,'CSC SEA Match All - IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			+ '; Sex: ' + s.SexEdFactsCode
		,s.IncidentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND s.SexEdFactsCode = rreksd.Sex
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSC'
	
	DROP TABLE #S_CSC

		
	/**********************************************************************
		Test Case 4:
		CSD at the SEA level - Student Count by Interim Removal Reason (IDEA) by English Learner Status (Both)
	***********************************************************************/
	SELECT 
		IdeaInterimRemovalReasonEdFactsCode
		, EnglishLearnerStatusEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #S_CSD
	FROM #C007Staging 
	WHERE IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	GROUP BY IdeaInterimRemovalReasonEdFactsCode
		,  EnglishLearnerStatusEdFactsCode

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
		,'CSD SEA Match All - IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			+ '; English Learner: ' + s.EnglishLearnerStatusEdFactsCode
		,s.IncidentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSD'
	
	DROP TABLE #S_CSD


	/**********************************************************************
		Test Case 5:
		ST1 at the SEA level - Student Count by Interim Removal Reason (IDEA)
	***********************************************************************/
	SELECT 
		IdeaInterimRemovalReasonEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #S_ST1
	FROM #C007Staging 
	WHERE IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	GROUP BY IdeaInterimRemovalReasonEdFactsCode

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
		,'ST1 SEA Match All - IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
		,s.IncidentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_ST1 s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'ST1'
	
	DROP TABLE #S_ST1

		
	----------------------------------------
	--- LEA level tests					 ---
	----------------------------------------
	/**********************************************************************
		Test Case 7:
		CSA at the LEA level - Student Count by Interim Removal Reason (IDEA) by Disability Category (IDEA)
	*/
	SELECT 
		s.LEA_Identifier_State
		, IdeaInterimRemovalReasonEdFactsCode
		, PrimaryDisabilityType
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #L_CSA
	FROM #C007Staging s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	AND IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	GROUP BY s.LEA_Identifier_State
		, IdeaInterimRemovalReasonEdFactsCode
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
			+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			+ '; Disability Type: ' + s.PrimaryDisabilityType
		,s.IncidentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAINTERIMREMOVALREASON
		AND s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSA'
	
	DROP TABLE #L_CSA


	/**********************************************************************
		Test Case 8:
		CSB at the LEA level - Student Count by Interim Removal Reason (IDEA) by Racial Ethnic
	***********************************************************************/
	SELECT 
		s.LEA_Identifier_State
		, IdeaInterimRemovalReasonEdFactsCode
		, RaceEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #L_CSB
	FROM #C007Staging s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	AND IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	GROUP BY s.LEA_Identifier_State
		, IdeaInterimRemovalReasonEdFactsCode
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
			+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			+ '; Race: ' + s.RaceEdFactsCode
		,s.IncidentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND s.RaceEdFactsCode = rreksd.Race
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSB'
	
	DROP TABLE #L_CSB

		
	/**********************************************************************
		Test Case 9:
		CSC at the SEA level - Student Count by Interim Removal Reason (IDEA) by Sex (Membership)
	***********************************************************************/
	SELECT 
		s.LEA_Identifier_State
		, IdeaInterimRemovalReasonEdFactsCode
		, SexEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #L_CSC
	FROM #C007Staging s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	AND SexEdFactsCode <> 'MISSING'
	AND IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	GROUP BY s.LEA_Identifier_State
		, IdeaInterimRemovalReasonEdFactsCode
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
			+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			+ '; Sex: ' + s.SexEdFactsCode
		,s.IncidentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND s.SexEdFactsCode = rreksd.Sex
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSC'
	
	DROP TABLE #L_CSC


	/**********************************************************************
		Test Case 10:
		CSD at the LEA level - Student Count by Interim Removal Reason (IDEA) by English Learner Status (Both)
	***********************************************************************/
	SELECT 
		s.LEA_Identifier_State
		, IdeaInterimRemovalReasonEdFactsCode
		, EnglishLearnerStatusEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #L_CSD
	FROM #C007Staging s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	AND IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	GROUP BY s.LEA_Identifier_State
		, IdeaInterimRemovalReasonEdFactsCode
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
			+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			+ '; English Learner: ' + s.EnglishLearnerStatusEdFactsCode
		,s.IncidentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSD'
	
	DROP TABLE #L_CSD


	/**********************************************************************
		Test Case 11:
		ST1 at the LEA level - Student Count by Interim Removal Reason (IDEA)
	***********************************************************************/
	SELECT 
		s.LEA_Identifier_State
		, IdeaInterimRemovalReasonEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #L_ST1
	FROM #C007Staging s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	AND IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	GROUP BY s.LEA_Identifier_State
		, IdeaInterimRemovalReasonEdFactsCode

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
			+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
		,s.IncidentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_ST1 s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'ST1'
	
	DROP TABLE #L_ST1

END
