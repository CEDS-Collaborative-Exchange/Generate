IF EXISTS (
select 1 from INFORMATION_SCHEMA.ROUTINES
where ROUTINE_SCHEMA = 'App' AND  ROUTINE_NAME = 'FS221_TestCase'
) 
DROP Procedure App.FS221_TestCase

GO

CREATE PROCEDURE App.FS221_TestCase
	@SchoolYear SMALLINT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C221Staging') IS NOT NULL
	DROP TABLE #C221Staging

	IF OBJECT_ID('tempdb..#S_CSA') IS NOT NULL
	DROP TABLE #S_CSA

	IF OBJECT_ID('tempdb..#L_CSA') IS NOT NULL
	DROP TABLE #L_CSA

	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS221_UnitTestCase') 

	BEGIN
		SET @expectedResult = 1
		INSERT INTO App.SqlUnitTest (
			[UnitTestName]
			, [StoredProcedureName]
			, [TestScope]
			, [IsActive]
		)
		VALUES (
			'FS221_UnitTestCase'
			, 'FS221_TestCase'				
			, 'FS221'
			, 1
		)
		SET @SqlUnitTestId = @@IDENTITY
	END 
	ELSE 
	BEGIN
		SELECT 
			@SqlUnitTestId = SqlUnitTestId
		FROM App.SqlUnitTest 
		WHERE UnitTestName = 'FS221_UnitTestCase'
	END
	
	-- Clear out last run
	DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
	--Create SY Start / SY End variables
	declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
	declare @SYEnd varchar(10) = CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)


	-- Gather, evaluate & record the results
	SELECT  
		vnor.StudentIdentifierState
	   ,vnor.[SeaOrganizationIdentifierSea]
	   ,vnor.LEAIdentifierSeaAccountability
	   ,vnor.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType
	INTO #C221Staging
	FROM [Staging].[vwNeglectedOrDelinquent_StagingTables_C221]  vnor
	WHERE EdFactsAcademicOrCareerAndTechnicalOutcomeExitType <> 'MISSING'
	AND SchoolYear = @SchoolYear

	/**********************************************************************
		Test Case 1:
		CSA at the LEA level - Student Count by LEA
	***********************************************************************/
	SELECT 
		LEAIdentifierSeaAccountability
		,EdFactsAcademicOrCareerAndTechnicalOutcomeExitType
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSA
	FROM #C221staging 
	GROUP BY LEAIdentifierSeaAccountability
	,EdFactsAcademicOrCareerAndTechnicalOutcomeExitType

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
		, 'CSA LEA Match All - LEA Identifier: ' + s.LeaIdentifierSeaAccountability
			+ '; Exit Outcome Type: ' + s.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
		AND s.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType = rreksc.EDFACTSACADEMICORCAREERANDTECHNICALOUTCOMEEXITTYPE
		AND rreksc.ReportCode = 'C221' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'LEA'
		AND rreksc.CategorySetCode = 'CSA'
	DROP TABLE #L_CSA

END