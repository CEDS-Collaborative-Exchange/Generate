CREATE PROCEDURE [App].[FS144_TestCase]
	@SchoolYear INT
AS
BEGIN

	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS144_UnitTestCase') 
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
				'FS144_UnitTestCase'
			, 'FS144_TestCase'				
			, 'FS144'
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
		WHERE UnitTestName = 'FS144_UnitTestCase'
	END
	
	DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId

	DECLARE @cutOffMonth INT, @cutOffDay INT, @customFactTypeDate VARCHAR(10)
	set @cutOffMonth = 11
	set @cutOffDay = 1

	select @customFactTypeDate = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CHDCTDTE'

	select @cutOffMonth = SUBSTRING(@customFactTypeDate, 0, CHARINDEX('/', @customFactTypeDate))
	select @cutOffDay = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)

	-- Create test data if needed & doesn't exist (should be rerunnable, but don't insert duplicate records
	
	SELECT 
		 ske.LEA_Identifier_State
		,ISNULL(ps.IDEAIndicator, 0) AS IDEAIndicator
		,sd.EducationalServicesAfterRemoval
		,COUNT(DISTINCT ske.Student_Identifier_State) AS StudentCount
	INTO #C144Staging
	FROM Staging.K12Enrollment ske
	JOIN Staging.Discipline sd
		on ske.Student_Identifier_State = sd.Student_Identifier_State
		AND ske.LEA_Identifier_State = sd.LEA_Identifier_State
		AND ske.School_Identifier_State = sd.School_Identifier_State
	LEFT JOIN Staging.PersonStatus ps
		on ske.Student_Identifier_State = ps.Student_Identifier_State
		AND ske.LEA_Identifier_State = ps.LEA_Identifier_State
		AND ske.School_Identifier_State = ps.School_Identifier_State
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') between ISNULL(ps.IDEA_StatusStartDate, '1900-01-01') and ISNULL (ps.IDEA_StatusEndDate, GETDATE())
	LEFT JOIN Staging.ProgramParticipationSpecialEducation ppse
		on ske.Student_Identifier_State = ppse.Student_Identifier_State
		AND ske.LEA_Identifier_State = ppse.LEA_Identifier_State
		AND ske.School_Identifier_State = ppse.School_Identifier_State
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') between ISNULL(ppse.ProgramParticipationBeginDate, '1900-01-01') and ISNULL (ppse.ProgramParticipationEndDate, GETDATE())
	WHERE ske.Schoolyear = CAST(@SchoolYear AS VARCHAR)
		AND DisciplinaryActionStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') between CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE) and CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)
		AND sd.DisciplinaryActionTaken IN ('03086', '03087')
		AND (ppse.IDEAEducationalEnvironmentForSchoolAge IS NULL 
			OR ppse.IDEAEducationalEnvironmentForSchoolAge <> 'PPPS')
		AND ((ISNULL(ps.IDEAIndicator, 0) = 1 AND rds.Get_Age(ske.Birthdate, DATEFROMPARTS(CASE WHEN @cutOffMonth >= 7 THEN @SchoolYear - 1 ELSE @SchoolYear END, @cutOffMonth, @cutOffDay)) BETWEEN 3 AND 21)
			OR (ISNULL(ps.IDEAIndicator, 0) = 0 AND ske.GradeLevel in ('KG', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')))
	GROUP BY ske.LEA_Identifier_State
		, ISNULL(ps.IDEAIndicator, 0)
		, sd.EducationalServicesAfterRemoval

	/* Test Case 1: SEA CSA */
		

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
		,'CSA SEA Match All'
		,'CSA SEA Match All - Educational Services After Removal: ' + CASE s.EducationalServicesAfterRemoval WHEN 1 THEN 'SERVPROV' WHEN 0 THEN 'SERVNOTPROV' ELSE 'MISSING' END +  '; IDEA Indicator: ' + CASE s.IDEAIndicator WHEN 1 THEN 'WDIS' ELSE 'WODIS' END
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, 0) THEN 1 ELSE 0 END
		,GETDATE()
	FROM (SELECT EducationalServicesAfterRemoval, IDEAIndicator, SUM(StudentCount) AS StudentCount FROM #C144Staging GROUP BY EducationalServicesAfterRemoval, IDEAIndicator) s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON CASE s.EducationalServicesAfterRemoval WHEN 1 THEN 'SERVPROV' WHEN 0 THEN 'SERVNOTPROV' ELSE 'MISSING' END = rreksd.EducationalServicesAfterRemoval
		AND CASE s.IDEAIndicator WHEN 1 THEN 'WDIS' ELSE 'WODIS' END = rreksd.IDEAIndicator
		AND rreksd.ReportCode = 'C144' 
		AND rreksd.ReportYear = CAST(@SchoolYear AS VARCHAR)
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSA'

			
	/* Test Case 2: LEA CSA */
		

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
		,'CSA LEA Match All'
		,'CSA LEA Match All - LEA: ' + s.LEA_Identifier_State + '; Educational Services After Removal: ' + CASE s.EducationalServicesAfterRemoval WHEN 1 THEN 'SERVPROV' WHEN 0 THEN 'SERVNOTPROV' ELSE 'MISSING' END +  '; IDEA Indicator: ' + CASE s.IDEAIndicator WHEN 1 THEN 'WDIS' ELSE 'WODIS' END
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, 0) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #C144Staging s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON CASE s.EducationalServicesAfterRemoval WHEN 1 THEN 'SERVPROV' WHEN 0 THEN 'SERVNOTPROV' ELSE 'MISSING' END = rreksd.EducationalServicesAfterRemoval
		AND CASE s.IDEAIndicator WHEN 1 THEN 'WDIS' ELSE 'WODIS' END = rreksd.IDEAIndicator
		AND s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND rreksd.ReportCode = 'C144' 
		AND rreksd.ReportYear = CAST(@SchoolYear AS VARCHAR)
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSA'

	--Drop Table
	DROP TABLE #C144Staging

END