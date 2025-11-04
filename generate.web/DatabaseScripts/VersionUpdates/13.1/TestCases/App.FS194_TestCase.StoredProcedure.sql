CREATE PROCEDURE [App].[FS194_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C194Staging') IS NOT NULL
	DROP TABLE #C194Staging

	IF OBJECT_ID('tempdb..#S_CSA') IS NOT NULL
	DROP TABLE #S_CSA

	IF OBJECT_ID('tempdb..#L_CSA') IS NOT NULL
	DROP TABLE #L_CSA

	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS194_UnitTestCase') 

	BEGIN
		SET @expectedResult = 1
		INSERT INTO App.SqlUnitTest (
			[UnitTestName]
			, [StoredProcedureName]
			, [TestScope]
			, [IsActive]
		)
		VALUES (
			'FS194_UnitTestCase'
			, 'FS194_TestCase'				
			, 'FS194'
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
		WHERE UnitTestName = 'FS194_UnitTestCase'
	END
	
	-- Clear out last run
	DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
	--Create SY Start / SY End variables
	declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
	declare @SYEnd varchar(10) = CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)

	--Get the LEAs that should not be reported against
	IF OBJECT_ID('tempdb..#excludedLeas') IS NOT NULL
	DROP TABLE #excludedLeas

	CREATE TABLE #excludedLeas (
		LeaIdentifierSeaAccountability		VARCHAR(20)
	)

	INSERT INTO #excludedLeas 
	SELECT DISTINCT LEAIdentifierSea
	FROM Staging.K12Organization sko
	LEFT JOIN Staging.OrganizationPhone sop
			ON sko.LEAIdentifierSea = sop.OrganizationIdentifier
			AND sop.OrganizationType in (	SELECT InputCode
										FROM Staging.SourceSystemReferenceData 
										WHERE TableName = 'RefOrganizationType' 
											AND TableFilter = '001156'
											AND OutputCode = 'LEA' AND SchoolYear = @SchoolYear)
	WHERE LEA_IsReportedFederally = 0
		OR LEA_OperationalStatus in ('Closed', 'FutureAgency', 'Inactive', 'Closed_1', 'FutureAgency_1', 'Inactive_1', 'MISSING')
		OR sop.OrganizationIdentifier IS NULL

	-- Gather, evaluate & record the results
	SELECT  
		ske.StudentIdentifierState
		, ske.LeaIdentifierSeaAccountability
		, ske.SchoolIdentifierSea
		, ske.Birthdate
		, ske.GradeLevel
--Homelessness
		, hmStatus.HomelessServicedIndicator
--Age/Grade
		, CASE	WHEN rda.AgeValue < 3 THEN 'UNDER3'
				WHEN rda.AgeValue in (3,4,5) AND isnull(ske.GradeLevel, 'PK') in ('PK', 'PK_1') THEN '3TO5NOTK'
		END AS AgeEdFactsCode	
	INTO #C194Staging
	FROM Staging.K12Enrollment ske
--McKinneyVento 
	JOIN staging.K12Organization sko
		ON ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(sko.LeaIdentifierSea, '')
		AND sko.LEA_MckinneyVentoSubgrantRecipient = 1 
--homeless
	JOIN Staging.PersonStatus hmStatus
		ON ske.StudentIdentifierState = hmStatus.StudentIdentifierState
		AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(hmStatus.LeaIdentifierSeaAccountability, '')
		AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(hmStatus.SchoolIdentifierSea, '')
		AND hmStatus.Homelessness_StatusStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEnd)
--age
	JOIN RDS.DimAges rda
		ON RDS.Get_Age(ske.Birthdate, @SYStart) = rda.AgeValue

	WHERE hmStatus.HomelessServicedIndicator = 1
	AND ske.Schoolyear = CAST(@SchoolYear AS VARCHAR)
	AND ISNULL(ske.GradeLevel, 'PK') in ('PK', 'PK_1')
	AND rda.AgeValue between 0 and 5
	--Homeless Date with SY range 
	AND ISNULL(hmStatus.Homelessness_StatusStartDate, '1900-01-01') 
		BETWEEN @SYStart AND @SYEnd
	AND ISNULL(hmStatus.Homelessness_StatusStartDate, '1900-01-01') 
		BETWEEN sko.LEA_RecordStartDateTime and ISNULL(sko.LEA_RecordEndDateTime, @SYEnd)


	/**********************************************************************
		Test Case 1:
		CSA at the SEA level - Student Count by Age/Grade (Basic)
	***********************************************************************/
	SELECT 
		AgeEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSA
	FROM #C194staging s
	LEFT JOIN #excludedLeas elea
	ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
	GROUP BY AgeEdFactsCode

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
		, 'CSA SEA Match All - Age/Grade: ' +  s.AgeEdFactsCode
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.AgeEdFactsCode = rreksc.AGE
		AND rreksc.ReportCode = '194' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'SEA'
		AND rreksc.CategorySetCode = 'CSA'
	
	DROP TABLE #S_CSA


	----------------------------------------
	--- LEA level tests					 ---
	----------------------------------------
	/**********************************************************************
		Test Case 1:
		CSA at the LEA level - Student Count by Age/Grade (Basic)
	***********************************************************************/
	SELECT 
		AgeEdFactsCode
		, LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSA
	FROM #C194staging s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
	GROUP BY AgeEdFactsCode
		, LeaIdentifierSeaAccountability
		
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
		, 'CSA LEA Match All - Age/Grade: ' +  s.AgeEdFactsCode
			+ '; LEA Identifier: ' + s.LeaIdentifierSeaAccountability
		, s.StudentCount
		, rreksc.StudentCount
		, CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
		ON s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
		AND s.AgeEdFactsCode = rreksc.Age
		AND rreksc.ReportCode = '194' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'LEA'
		AND rreksc.CategorySetCode = 'CSA'
	
	DROP TABLE #L_CSA

-- IF THE TEST PRODUCES NO RESULTS INSERT A RECORD TO INDICATE THIS -------------------------
if not exists(select top 1 * from app.sqlunittest t
	inner join app.SqlUnitTestCaseResult r
		on t.SqlUnitTestId = r.SqlUnitTestId
		and t.SqlUnitTestId = @SqlUnitTestId)
begin
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
			SELECT DISTINCT
				 @SqlUnitTestId
				,'NO TEST RESULTS'
				,'NO TEST RESULTS'
				,-1
				,-1
				,NULL
				,GETDATE()
end
----------------------------------------------------------------------------------

	--check the results

	--select *
	--from App.SqlUnitTestCaseResult sr
	--	inner join App.SqlUnitTest s
	--		on s.SqlUnitTestId = sr.SqlUnitTestId
	--where s.UnitTestName like '%194%'
	--and passed = 0
	--and convert(date, TestDateTime) = convert(date, GETDATE())

END