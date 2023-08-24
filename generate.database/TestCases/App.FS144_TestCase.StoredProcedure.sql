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
		INSERT INTO App.SqlUnitTest (
			[UnitTestName]
			, [StoredProcedureName]
			, [TestScope]
			, [IsActive]
		)
		VALUES (
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
		ske.LeaIdentifierSeaAccountability
		, ISNULL(sppse.IDEAIndicator, 0) AS IDEAIndicator
		, sd.EducationalServicesAfterRemoval
		, COUNT(DISTINCT ske.StudentIdentifierState) AS StudentCount
	INTO #C144Staging
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
	WHERE ske.Schoolyear = CAST(@SchoolYear AS VARCHAR)
		AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge, '') <> 'PPPS'
		AND sd.DisciplinaryActionTaken IN ('03086', '03087')
		AND ((ISNULL(sppse.IDEAIndicator, 0) = 1 
			AND rds.Get_Age(ske.Birthdate, @ChildCountDate) BETWEEN 3 AND 21)	
			OR (ISNULL(sppse.IDEAIndicator, 0) = 0 AND ske.GradeLevel in ('KG', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')))
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN @SYStart AND @SYEnd
	GROUP BY ske.LeaIdentifierSeaAccountability
		, ISNULL(sppse.IDEAIndicator, 0)
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
		, 'CSA SEA Match All - Education Services After Removal: ' 
			+ CASE s.EducationalServicesAfterRemoval 
				WHEN 1 THEN 'SERVPROV' 
				WHEN 0 THEN 'SERVNOTPROV' 
				ELSE 'MISSING' 
			END
			+ '; IDEA Indicator: ' 
			+ CASE s.IDEAIndicator 
				WHEN 1 THEN 'WDIS' 
				WHEN 0 THEN 'WODIS' 
				ELSE 'MISSING' 
			END
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, 0) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON CASE s.EducationalServicesAfterRemoval 
			WHEN 1 THEN 'SERVPROV' 
			WHEN 0 THEN 'SERVNOTPROV' 
			ELSE 'MISSING' 
		END = rreksd.EducationalServicesAfterRemoval
		AND CASE s.IDEAIndicator 
			WHEN 1 THEN 'WDIS' 
			ELSE 'WODIS' 
		END = rreksd.IDEAIndicator
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
		s.LeaIdentifierSeaAccountability
		, EducationalServicesAfterRemoval
		, IDEAIndicator		
		, StudentCount
	INTO #L_CSA
	FROM #C144staging  s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	GROUP BY s.LeaIdentifierSeaAccountability
		, EducationalServicesAfterRemoval
		, IDEAIndicator		
		, StudentCount

	INSERT INTO App.SqlUnitTestCaseResult 	(
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
		, 'CSA LEA Match All - Lea Identifier: ' + s.LeaIdentifierSeaAccountability
			+ '; Education Services After Removal: '
			+ CASE s.EducationalServicesAfterRemoval 
				WHEN 1 THEN 'SERVPROV' 
				WHEN 0 THEN 'SERVNOTPROV' 
				ELSE 'MISSING' 
			END
			+ '; IDEA Indicator: ' 
			+ CASE s.IDEAIndicator 
				WHEN 1 THEN 'WDIS' 
				WHEN 0 THEN 'WODIS' 
				ELSE 'MISSING' 
			END
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
		AND CASE s.EducationalServicesAfterRemoval 
			WHEN 1 THEN 'SERVPROV' 
			WHEN 0 THEN 'SERVNOTPROV' 
			ELSE 'MISSING' 
		END = rreksd.EducationalServicesAfterRemoval
		AND CASE s.IDEAIndicator 
			WHEN 1 THEN 'WDIS' 
			ELSE 'WODIS' 
		END = rreksd.IDEAIndicator
		AND rreksd.ReportCode = 'C144' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSA'

	DROP TABLE #L_CSA

	--check the results

	--select *
	--from App.SqlUnitTestCaseResult sr
	--	inner join App.SqlUnitTest s
	--		on s.SqlUnitTestId = sr.SqlUnitTestId
	--where s.UnitTestName like '%144%'
	--and passed = 1

END
