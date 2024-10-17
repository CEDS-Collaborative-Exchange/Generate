IF EXISTS (
select 1 from INFORMATION_SCHEMA.ROUTINES
where ROUTINE_SCHEMA = 'App' AND  ROUTINE_NAME = 'FS224_TestCase'
) 
DROP Procedure App.FS224_TestCase

GO
--EXEC  [App].[FS224_TestCase]	 2024
CREATE PROCEDURE [App].[FS224_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C224Staging') IS NOT NULL
	DROP TABLE #C224Staging

	IF OBJECT_ID('tempdb..#S_CSA') IS NOT NULL
	DROP TABLE #S_CSA

	IF OBJECT_ID('tempdb..#L_CSA') IS NOT NULL
	DROP TABLE #L_CSA

	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS224_UnitTestCase') 

	BEGIN
		SET @expectedResult = 1
		INSERT INTO App.SqlUnitTest (
			[UnitTestName]
			, [StoredProcedureName]
			, [TestScope]
			, [IsActive]
		)
		VALUES (
			'FS224_UnitTestCase'
			, 'FS224_TestCase'				
			, 'FS224'
			, 1
		)
		SET @SqlUnitTestId = @@IDENTITY
	END 
	ELSE 
	BEGIN
		SELECT 
			@SqlUnitTestId = SqlUnitTestId
		FROM App.SqlUnitTest 
		WHERE UnitTestName = 'FS224_UnitTestCase'
	END
	
	-- Clear out last run
	DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
	--Create SY Start / SY End variables
	declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
	declare @SYEnd varchar(10) = CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)


	-- Gather, evaluate & record the results
	SELECT  
		vas.StudentIdentifierState
	   ,vas.SeaOrganizationIdentifierSea
	   ,vas.ProficiencyStatus
	   ,vas.AssessmentAcademicSubject
	INTO #C224Staging
	FROM [Staging].[vwAssessment_StagingTables_C224]  vas
	WHERE ProficiencyStatus <> 'MISSING' AND AssessmentAcademicSubject <> 'MISSING'
	AND SchoolYear = @SchoolYear

	/**********************************************************************
		Test Case 1:
		CSA at the SEA level - Student Count by SEA
	***********************************************************************/
	SELECT SeaOrganizationIdentifierSea
		,AssessmentAcademicSubject
		,ProficiencyStatus
		, COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
	INTO #S_CSA
	FROM #C224staging 
	GROUP BY SeaOrganizationIdentifierSea,ProficiencyStatus,AssessmentAcademicSubject
	
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
		, 'CSA SEA Match All - SEA: ' + s.SeaOrganizationIdentifierSea
		 + '; Academic Subject: ' + rreksa.AssessmentAcademicSubject
		 + '; Proficiency Status: ' + s.ProficiencyStatus
		, s.AssessmentCount
		, rreksa.AssessmentCount
		, CASE WHEN s.AssessmentCount = ISNULL(rreksa.AssessmentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSA s
	LEFT JOIN [RDS].[ReportEdFactsK12StudentAssessments] rreksa 
		ON s.SeaOrganizationIdentifierSea = rreksa.OrganizationIdentifierSea
		AND s.AssessmentAcademicSubject = 
			CASE WHEN rreksa.AssessmentAcademicSubject = 'M' THEN '01166_1'
			     WHEN rreksa.AssessmentAcademicSubject = 'RLA' THEN '13373_1'
				 ELSE rreksa.AssessmentAcademicSubject
			END
		AND s.ProficiencyStatus = rreksa.PROFICIENCYSTATUS
		AND rreksa.ReportCode = 'C224' 
		AND rreksa.ReportYear = @SchoolYear
		AND rreksa.ReportLevel = 'LEA'
		AND rreksa.CategorySetCode = 'CSA'
	DROP TABLE #S_CSA

END