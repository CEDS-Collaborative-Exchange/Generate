CREATE PROCEDURE [App].[FS144_TestCase]
	@SchoolYear INT
AS
BEGIN

	IF OBJECT_ID('tempdb..#C144Staging') IS NOT NULL
	DROP TABLE #C144Staging

	IF OBJECT_ID('tempdb..#S_CSA') IS NOT NULL
	DROP TABLE #S_CSA

	IF OBJECT_ID('tempdb..#L_CSA') IS NOT NULL
	DROP TABLE #L_CSA

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
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
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

	SELECT 
		ske.LEA_Identifier_State
		, ISNULL(ps.IDEAIndicator, 0) AS IDEAIndicator
		, sd.EducationalServicesAfterRemoval
		, COUNT(DISTINCT ske.Student_Identifier_State) AS StudentCount
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
		AND ISNULL(ppse.IDEAEducationalEnvironmentForSchoolAge, '') <> 'PPPS'
		AND ((ISNULL(ps.IDEAIndicator, 0) = 1 AND rds.Get_Age(ske.Birthdate, DATEFROMPARTS(CASE WHEN @cutOffMonth >= 7 THEN @SchoolYear - 1 ELSE @SchoolYear END, @cutOffMonth, @cutOffDay)) BETWEEN 3 AND 21)
			OR (ISNULL(ps.IDEAIndicator, 0) = 0 AND ske.GradeLevel in ('KG', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')))
	GROUP BY ske.LEA_Identifier_State
		, ISNULL(ps.IDEAIndicator, 0)
		, sd.EducationalServicesAfterRemoval

	/**********************************************************************
		Test Case 1: 
		SEA CSA 
	***********************************************************************/
	SELECT 
		EducationalServicesAfterRemoval
		, IDEAIndicator		
		, SUM(StudentCount) AS StudentCount
	INTO #S_CSA
	FROM #C144staging 
	GROUP BY EducationalServicesAfterRemoval
		, IDEAIndicator		

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
		, 'CSA SEA Match All - Education Services After Removal: ' + CASE s.EducationalServicesAfterRemoval WHEN 1 THEN 'SERVPROV' WHEN 0 THEN 'SERVNOTPROV' ELSE 'MISSING' END
			+ '; IDEA Indicator: ' + CASE s.IDEAIndicator WHEN 1 THEN 'WDIS' WHEN 0 THEN 'WODIS' ELSE 'MISSING' END
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, 0) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON CASE s.EducationalServicesAfterRemoval WHEN 1 THEN 'SERVPROV' WHEN 0 THEN 'SERVNOTPROV' ELSE 'MISSING' END = rreksd.EducationalServicesAfterRemoval
		AND CASE s.IDEAIndicator WHEN 1 THEN 'WDIS' ELSE 'WODIS' END = rreksd.IDEAIndicator
		AND rreksd.ReportCode = 'C144' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSA'

	DROP TABLE #S_CSA

	/**********************************************************************
		Test Case 2: 
		LEA CSA 
	***********************************************************************/
	SELECT
		s.Lea_Identifier_State
		, EducationalServicesAfterRemoval
		, IDEAIndicator		
		, StudentCount
	INTO #L_CSA
	FROM #C144staging  s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.Lea_Identifier_State = nrflea.Lea_Identifier_State
	WHERE nrflea.Lea_Identifier_State IS NULL -- exclude non-federally reported LEAs
	GROUP BY s.LEA_Identifier_State
		, EducationalServicesAfterRemoval
		, IDEAIndicator		
		, StudentCount

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
		, 'CSA LEA Match All - Lea Identifier: ' + s.Lea_Identifier_State
			+ '; Education Services After Removal: ' + CASE s.EducationalServicesAfterRemoval WHEN 1 THEN 'SERVPROV' WHEN 0 THEN 'SERVNOTPROV' ELSE 'MISSING' END
			+ '; IDEA Indicator: ' + CASE s.IDEAIndicator WHEN 1 THEN 'WDIS' WHEN 0 THEN 'WODIS' ELSE 'MISSING' END
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LEA_Identifier_State = rreksd.OrganizationStateId
		AND CASE s.EducationalServicesAfterRemoval WHEN 1 THEN 'SERVPROV' WHEN 0 THEN 'SERVNOTPROV' ELSE 'MISSING' END = rreksd.EducationalServicesAfterRemoval
		AND CASE s.IDEAIndicator WHEN 1 THEN 'WDIS' ELSE 'WODIS' END = rreksd.IDEAIndicator
		AND rreksd.ReportCode = 'C144' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSA'

	DROP TABLE #L_CSA

END