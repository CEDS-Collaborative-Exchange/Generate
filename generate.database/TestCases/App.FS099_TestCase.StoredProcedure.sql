CREATE PROCEDURE [App].[FS099_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#Staging') IS NOT NULL
	DROP TABLE #Staging

	IF OBJECT_ID('tempdb..#TC1') IS NOT NULL
	DROP TABLE #TC1

	IF OBJECT_ID('tempdb..#TC2') IS NOT NULL
	DROP TABLE #TC2

	IF OBJECT_ID('tempdb..#TC3') IS NOT NULL
	DROP TABLE #TC3

	IF OBJECT_ID('tempdb..#TC4') IS NOT NULL
	DROP TABLE #TC4

	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS099_UnitTestCase') 
	BEGIN
		SET @expectedResult = 1
		INSERT INTO App.SqlUnitTest (
				[UnitTestName]
			, [StoredProcedureName]
			, [TestScope]
			, [IsActive]
		)
		VALUES (
			'FS099_UnitTestCase'
			, 'FS099_TestCase'				
			, 'FS099'
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
		WHERE UnitTestName = 'FS099_UnitTestCase'
	END

	-- Clear out last run
	DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
	--Get the Special Education program code
	DECLARE @SPEDProgram varchar(5)
	SELECT @SPEDProgram = [code] from dbo.RefProgramType where [Definition] = 'Special Education Services'

	--Get School Year End Date
	--Create SY Start / SY End variables
	declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
	declare @SYEnd varchar(10) = CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)

	-- Get Custom Child Count Date
	DECLARE @ChildCountDate DATETIME
	select @ChildCountDate = CAST('10/01/' + cast(@SchoolYear - 1 AS Varchar(4)) AS DATETIME)

	SELECT DISTINCT 
		StaffMemberIdentifierState
		, sksa.LeaIdentifierSea
		, sksa.SchoolIdentifierSea
		, FullTimeEquivalency
		, SpecialEducationStaffCategory
		, CASE SpecialEducationStaffCategory
			WHEN 'PSYCH'			THEN 'PSYCH'
			WHEN 'SOCIALWORK' 		THEN 'SOCIALWORK' 
			WHEN 'OCCTHERAP'		THEN 'OCCTHERAP'
			WHEN 'AUDIO'			THEN 'AUDIO'
			WHEN 'PEANDREC'			THEN 'PEANDREC'
			WHEN 'PHYSTHERAP'		THEN 'PHYSTHERAP'
			WHEN 'SPEECHPATH' 		THEN 'SPEECHPATH' 
			WHEN 'INTERPRET'		THEN 'INTERPRET'
			WHEN 'COUNSELOR'		THEN 'COUNSELOR'
			WHEN 'ORIENTMOBIL'		THEN 'ORIENTMOBIL'
			WHEN 'MEDNURSE'			THEN 'MEDNURSE'
			WHEN 'PSYCH_1'			THEN 'PSYCH'
			WHEN 'SOCIALWORK_1' 	THEN 'SOCIALWORK' 
			WHEN 'OCCTHERAP_1'		THEN 'OCCTHERAP'
			WHEN 'AUDIO_1'			THEN 'AUDIO'
			WHEN 'PEANDREC_1'		THEN 'PEANDREC'
			WHEN 'PHYSTHERAP_1'		THEN 'PHYSTHERAP'
			WHEN 'SPEECHPATH_1' 	THEN 'SPEECHPATH' 
			WHEN 'INTERPRET_1'		THEN 'INTERPRET'
			WHEN 'COUNSELOR_1'		THEN 'COUNSELOR'
			WHEN 'ORIENTMOBIL_1'	THEN 'ORIENTMOBIL'
			WHEN 'MEDNURSE_1'		THEN 'MEDNURSE'
			ELSE 'MISSING'
		END AS SpecialEducationSupportServicesCategoryEdFactsCode
		, sksa.EdFactsCertificationStatus
		, CredentialIssuanceDate
		, CredentialExpirationDate
		, AssignmentStartDate
		, AssignmentEndDate
		, CASE WHEN sko.LEA_IsReportedFederally = 1
			AND sko.LEA_OperationalStatus IN ('New', 'Added', 'Open', 'Reopened', 'ChangedBoundary', 'New_1', 'Added_1', 'Open_1', 'Reopened_1', 'ChangedBoundary_1') THEN 1
			ELSE 0
			END AS [IsLeaReportedFederally]
	INTO #staging
	FROM Staging.K12StaffAssignment sksa
	JOIN Staging.K12Organization sko
		ON sksa.LeaIdentifierSea = sko.LeaIdentifierSea
	WHERE @ChildCountDate BETWEEN AssignmentStartDate AND ISNULL(AssignmentEndDate, @SYEnd)
		AND @ChildCountDate BETWEEN sko.LEA_RecordStartDateTime AND ISNULL(sko.LEA_RecordEndDateTime, @SYEnd)
--		AND ProgramTypeCode = @SPEDProgram
--		WHERE sksa.SchoolYear = @SchoolYear

/* Test Case 1:
CSA at the SEA level 
Teachers (FTE) by Credential Status and SPED Support Services Category
*/

	-- Gather, evaluate & record the results
	SELECT 
		count(distinct StaffMemberIdentifierState) as StaffCount
		, SpecialEducationSupportServicesCategoryEdFactsCode
		, EdFactsCertificationStatus
		, sum(FullTimeEquivalency) as FullTimeEquivalency
	INTO #TC1
	FROM #staging 
	GROUP BY SpecialEducationSupportServicesCategoryEdFactsCode
		, EdFactsCertificationStatus

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
		,'CSA SEA Match All - SPED Support Services Category: ' + s.SpecialEducationSupportServicesCategoryEdFactsCode
			+ '; Certification Status: ' + s.EdFactsCertificationStatus
			+ '; Full Time Equivalency: ' + cast(s.FullTimeEquivalency as varchar(10))
		,s.FullTimeEquivalency
		,rreksc.StaffFullTimeEquivalency
		,CASE WHEN s.FullTimeEquivalency = ISNULL(rreksc.StaffFullTimeEquivalency, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #TC1 s
	LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc  
		ON s.SpecialEducationSupportServicesCategoryEdFactsCode = rreksc.SpecialEducationSupportServicesCategory
		AND replace(s.EdFactsCertificationStatus, '_1', '') = rreksc.EDFACTSCERTIFICATIONSTATUS
		AND rreksc.ReportCode = 'C099' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'SEA'
		AND rreksc.CategorySetCode = 'CSA'
	
	DROP TABLE #TC1

/* Test Case 2:
ST1 at the SEA level
Subtotal by SPED Support Services Category
*/

	-- Gather, evaluate & record the results
	SELECT 
		COUNT(DISTINCT StaffMemberIdentifierState) AS StaffCount
		, SpecialEducationSupportServicesCategoryEdFactsCode
		, sum(FullTimeEquivalency) as FullTimeEquivalency
	INTO #TC2
	FROM #staging 
	GROUP BY SpecialEducationSupportServicesCategoryEdFactsCode

	INSERT INTO App.SqlUnitTestCaseResult (
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
		,'ST1 SEA Match All'
		,'ST1 SEA Match All - SPED Support Services Category: ' + s.SpecialEducationSupportServicesCategoryEdFactsCode + '
			Full Time Equivalency: ' + CAST(s.FullTimeEquivalency as varchar(10))
		,s.FullTimeEquivalency
		,rreksc.StaffFullTimeEquivalency
		,CASE WHEN s.FullTimeEquivalency = ISNULL(rreksc.StaffFullTimeEquivalency, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #TC2 s
	LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc  
		ON s.SpecialEducationSupportServicesCategoryEdFactsCode = rreksc.SpecialEducationSupportServicesCategory
		AND rreksc.ReportCode = 'C099' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'SEA'
		AND rreksc.CategorySetCode = 'ST1'

	DROP TABLE #TC2

	----------------------------------------
	--- LEA level tests					 ---
	----------------------------------------

/* Test Case 3:
CSA at the LEA level 
Teachers (FTE) by Credential Status and SPED Support Services Category
*/

	-- Gather, evaluate & record the results
	SELECT 
		count(distinct StaffMemberIdentifierState) as StaffCount
		, LeaIdentifierSea
		, SpecialEducationSupportServicesCategoryEdFactsCode
		, EdFactsCertificationStatus
		, sum(FullTimeEquivalency) as FullTimeEquivalency
	INTO #TC3
	FROM #staging 
	WHERE IsLeaReportedFederally = 1
	GROUP BY LeaIdentifierSea
		, SpecialEducationSupportServicesCategoryEdFactsCode
		, EdFactsCertificationStatus

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
		,'CSA LEA Match All - LEA Identifier: ' + s.LeaIdentifierSea
			+ '; SPED Support Services Category: ' + s.SpecialEducationSupportServicesCategoryEdFactsCode
			+ '; Certification Status: ' + s.EdFactsCertificationStatus
			+ '; Full Time Equivalency: ' + cast(s.FullTimeEquivalency as varchar(10))
		,s.FullTimeEquivalency
		,rreksc.StaffFullTimeEquivalency
		,CASE WHEN s.FullTimeEquivalency = ISNULL(rreksc.StaffFullTimeEquivalency, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #TC3 s
	LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc  
		ON s.SpecialEducationSupportServicesCategoryEdFactsCode = rreksc.SpecialEducationSupportServicesCategory
		AND replace(s.EdFactsCertificationStatus, '_1', '') = rreksc.EDFACTSCERTIFICATIONSTATUS
		AND s.LeaIdentifierSea = rreksc.OrganizationIdentifierSea
		AND rreksc.ReportCode = 'C099' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'LEA'
		AND rreksc.CategorySetCode = 'CSA'
	
	DROP TABLE #TC3

/* Test Case 4:
ST1 at the LEA level
Subtotal by SPED Support Services Category
*/

	-- Gather, evaluate & record the results
	SELECT 
		COUNT(DISTINCT StaffMemberIdentifierState) AS StaffCount
		, LeaIdentifierSea
		, SpecialEducationSupportServicesCategoryEdFactsCode
		, sum(FullTimeEquivalency) as FullTimeEquivalency
	INTO #TC4
	FROM #staging 
	WHERE IsLeaReportedFederally = 1
	GROUP BY LeaIdentifierSea
			, SpecialEducationSupportServicesCategoryEdFactsCode

	INSERT INTO App.SqlUnitTestCaseResult (
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
		,'ST1 LEA Match All'
		,'ST1 LEA Match All - LEA Identifier: ' + s.LeaIdentifierSea
			+ '; SPED Support Services Category: ' + s.SpecialEducationSupportServicesCategoryEdFactsCode
			+ '; Full Time Equivalency: ' + CAST(s.FullTimeEquivalency as varchar(10))
		,s.FullTimeEquivalency
		,rreksc.StaffFullTimeEquivalency
		,CASE WHEN s.FullTimeEquivalency = ISNULL(rreksc.StaffFullTimeEquivalency, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #TC4 s
	LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc  
		ON s.SpecialEducationSupportServicesCategoryEdFactsCode = rreksc.SpecialEducationSupportServicesCategory
		AND s.LeaIdentifierSea = rreksc.OrganizationIdentifierSea
		AND rreksc.ReportCode = 'C099' 
		AND rreksc.ReportYear = @SchoolYear
		AND rreksc.ReportLevel = 'LEA'
		AND rreksc.CategorySetCode = 'ST1'

	DROP TABLE #TC4

	--Query to find the tests that did not pass
	--select * 
	--from App.SqlUnitTestCaseResult r
	--	inner join App.SqlUnitTest t
	--		on r.SqlUnitTestId = t.SqlUnitTestId
	--WHERE t.TestScope = 'FS099'
	--AND Passed = 0
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
END

