CREATE PROCEDURE [App].[FS112_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

	BEGIN TRY
	BEGIN TRANSACTION

		--clear the tables for the next run
		--DROP TABLE #Staging
		--DROP TABLE #TC1
		--DROP TABLE #TC2
		--DROP TABLE #TC3
		--DROP TABLE #TC4
		--DROP TABLE #TC5
		--DROP TABLE #TC6
		--DROP TABLE #TC7
		--DROP TABLE #TC8

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

		IF OBJECT_ID('tempdb..#TC5') IS NOT NULL
		DROP TABLE #TC5

		IF OBJECT_ID('tempdb..#TC6') IS NOT NULL
		DROP TABLE #TC6

		IF OBJECT_ID('tempdb..#TC7') IS NOT NULL
		DROP TABLE #TC7

		IF OBJECT_ID('tempdb..#TC8') IS NOT NULL
		DROP TABLE #TC8

		-- Define the test
		DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS112_UnitTestCase') 
		BEGIN
			SET @expectedResult = 1
			INSERT INTO App.SqlUnitTest (
				  [UnitTestName]
				, [StoredProcedureName]
				, [TestScope]
				, [IsActive]
			)
			VALUES (
				'FS112_UnitTestCase'
				, 'FS112_TestCase'				
				, 'FS112'
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
			WHERE UnitTestName = 'FS112_UnitTestCase'
		END

		-- Clear out last run
		DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
		--Get the Special Education program code
		DECLARE @SPEDProgram varchar(5)
		SELECT @SPEDProgram = [code] from dbo.RefProgramType where [Definition] = 'Special Education Services'

		--Get School Year End Date
		DECLARE @SYStartDate datetime = staging.GetFiscalYearStartDate(@schoolYear)

		-- Get Custom Child Count Date
		DECLARE @ChildCountDate DATETIME
		select @ChildCountDate = CAST('10/01/' + cast(@SchoolYear - 1 AS Varchar(4)) AS DATETIME)

		SELECT DISTINCT 
			Personnel_Identifier_State
			, sksa.LEA_Identifier_State
			, sksa.School_Identifier_State
			, FullTimeEquivalency
			, K12StaffClassification
			, CASE K12StaffClassification
				WHEN 'SpecialEducationTeachers' THEN 'SpecialEducationTeachers'
				WHEN 'Paraprofessionals' THEN 'Paraprofessionals'
				ELSE 'MISSING'
			END AS K12StaffClassificationEdFactsCode
			, CredentialType
			, ParaprofessionalQualification
			, CASE ParaprofessionalQualification
				WHEN 'Qualified' THEN 'Q'
				WHEN 'NotQualified' THEN 'NQ'
				ELSE 'MISSING'
			END AS ParaprofessionalQualificationEdFactsCode
			, SpecialEducationAgeGroupTaught
			, CASE SpecialEducationAgeGroupTaught
				WHEN '3TO5' THEN '3TO5'
				WHEN '6TO21' THEN '6TO21'
				ELSE 'MISSING'
			END AS SpecialEducationAgeGroupTaughtEdFactsCode
			, AssignmentStartDate
			, AssignmentEndDate
			, CASE WHEN (sko.LEA_IsReportedFederally IS NULL OR sko.LEA_IsReportedFederally = 1)
				AND sko.LEA_OperationalStatus IN ('New', 'Added', 'Open', 'Reopened', 'ChangedBoundary') THEN 1
				ELSE 0
			  END AS [IsLeaReportedFederally]
		INTO #staging
		FROM Staging.K12StaffAssignment sksa
		JOIN Staging.K12Organization sko
			ON sksa.LEA_Identifier_State = sko.LEA_Identifier_State
		WHERE K12StaffClassification = 'Paraprofessionals' 
			AND @ChildCountDate BETWEEN sksa.AssignmentStartDate AND ISNULL(sksa.AssignmentEndDate, GETDATE())
			AND @ChildCountDate BETWEEN sko.LEA_RecordStartDateTime AND ISNULL(sko.LEA_RecordEndDateTime, GETDATE())
--		AND ProgramTypeCode = @SPEDProgram
--		WHERE sksa.SchoolYear = @SchoolYear


/* Test Case 1:
	CSA at the SEA level 
	Teachers (FTE) by Qualification Status (Paraprofessional) and Age Group
*/

		-- Gather, evaluate & record the results
		SELECT 
			count(distinct Personnel_Identifier_State) as StaffCount
			, SpecialEducationAgeGroupTaughtEdFactsCode
			, ParaprofessionalQualificationEdFactsCode
			, sum(FullTimeEquivalency) as FullTimeEquivalency
		INTO #TC1
		FROM #staging 
		--WHERE CredentialType in ('Certification','Licensure')
		GROUP BY ParaprofessionalQualificationEdFactsCode
			, SpecialEducationAgeGroupTaughtEdFactsCode

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
			,'CSA SEA Match All - Qualification Status: ' + s.ParaprofessionalQualificationEdFactsCode 
				+ '; Special Ed Age Group Taught: ' + s.SpecialEducationAgeGroupTaughtEdFactsCode 
				+ '; Full Time Equivalency: ' + cast(s.FullTimeEquivalency as varchar(10))
			,s.StaffCount
			,rreksc.StaffCount
			,CASE WHEN s.StaffCount = ISNULL(rreksc.StaffCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC1 s
		LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc  
			ON s.ParaprofessionalQualificationEdFactsCode = rreksc.QualificationStatus
			AND s.SpecialEducationAgeGroupTaughtEdFactsCode = rreksc.SpecialEducationAgeGroupTaught
			AND rreksc.ReportCode = 'C112' 
			AND rreksc.ReportYear = @SchoolYear
			AND rreksc.ReportLevel = 'SEA'
			AND rreksc.CategorySetCode = 'CSA'

		DROP TABLE #TC1

		--Query to find the tests that did not match
		--select *
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSA SEA Match All' 
		--AND t.TestScope = 'FS112'
		--AND Passed = 0


/* Test Case 2:
	ST1 at the SEA level
	Subtotal by Qualification Status (Paraprofessional)
*/

		-- Gather, evaluate & record the results
		SELECT 
			COUNT(DISTINCT Personnel_Identifier_State) AS StaffCount
			, ParaprofessionalQualificationEdFactsCode
			, sum(FullTimeEquivalency) as FullTimeEquivalency
		INTO #TC2
		FROM #staging 
		--WHERE CredentialType in ('Certification','Licensure')
		GROUP BY ParaprofessionalQualificationEdFactsCode

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
			,'ST1 SEA Match All - Qualification Status: ' + s.ParaprofessionalQualificationEdFactsCode 
				+ 'Full Time Equivalency: ' + CAST(s.FullTimeEquivalency as varchar(10))
			,s.StaffCount
			,rreksc.StaffCount
			,CASE WHEN s.StaffCount = ISNULL(rreksc.StaffCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC2 s
		LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc  
			ON s.ParaprofessionalQualificationEdFactsCode = rreksc.QualificationStatus
			AND rreksc.ReportCode = 'C112' 
			AND rreksc.ReportYear = @SchoolYear
			AND rreksc.ReportLevel = 'SEA'
			AND rreksc.CategorySetCode = 'ST1'

		DROP TABLE #TC2

		--Query to find the tests that did not match
		--select *
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'ST1 SEA Match All' 
		--AND t.TestScope = 'FS112'
		--AND Passed = 0

		
/* Test Case 3:
	ST2 at the SEA level
	Subtotal by Age Group Taught (Paraprofessional)
*/

		-- Gather, evaluate & record the results
		SELECT 
			COUNT(DISTINCT Personnel_Identifier_State) AS StaffCount
			, SpecialEducationAgeGroupTaught
			, sum(FullTimeEquivalency) as FullTimeEquivalency
		INTO #TC3
		FROM #staging 
		GROUP BY SpecialEducationAgeGroupTaught

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
			,'ST2 SEA Match All'
			,'ST2 SEA Match All - Age Group Taught: ' + s.SpecialEducationAgeGroupTaught 
				+ ' Full Time Equivalency: ' + CAST(s.FullTimeEquivalency as varchar(10))
			,s.StaffCount
			,rreksc.StaffCount
			,CASE WHEN s.StaffCount = ISNULL(rreksc.StaffCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC3 s
		LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc  
			ON s.SpecialEducationAgeGroupTaught = rreksc.SpecialEducationAgeGroupTaught
			AND rreksc.ReportCode = 'C112' 
			AND rreksc.ReportYear = @SchoolYear
			AND rreksc.ReportLevel = 'SEA'
			AND rreksc.CategorySetCode = 'ST2'

		DROP TABLE #TC3

		--Query to find the tests that did not match
		--select *
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'ST2 SEA Match All' 
		--AND t.TestScope = 'FS112'
		--AND Passed = 0


/* Test Case 4:
	TOT at the SEA level
*/
		SELECT 
			COUNT(DISTINCT Personnel_Identifier_State) AS StaffCount
		INTO #TC4
		FROM #staging 
		
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
			,'TOT SEA Match All'
			,'TOT SEA Match All'
			,s.StaffCount
			,rreksc.StaffCount
			,CASE WHEN s.StaffCount = ISNULL(rreksc.StaffCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC4 s
		LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc 
			ON rreksc.ReportCode = 'C112' 
			AND rreksc.ReportYear = @SchoolYear
			AND rreksc.ReportLevel = 'SEA'
			AND rreksc.CategorySetCode = 'TOT'
			
		DROP TABLE #TC4

		--Query to find the tests that did not match
		--select *
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'TOT SEA Match All' 
		--AND t.TestScope = 'FS112'
		--AND Passed = 0
	
		----------------------------------------
		--- LEA level tests					 ---
		----------------------------------------

/* Test Case 5:
	CSA at the LEA level 
	Teachers (FTE) by Qualification Status (Paraprofessional) and Age Group
*/

		-- Gather, evaluate & record the results
		SELECT 
			count(distinct Personnel_Identifier_State) as StaffCount
			, LEA_Identifier_State
			, SpecialEducationAgeGroupTaughtEdFactsCode
			, ParaprofessionalQualificationEdFactsCode
			, sum(FullTimeEquivalency) as FullTimeEquivalency
		INTO #TC5
		FROM #staging 
		WHERE --CredentialType in ('Certification','Licensure')
			IsLeaReportedFederally = 1
		GROUP BY LEA_Identifier_State
			, ParaprofessionalQualificationEdFactsCode
			, SpecialEducationAgeGroupTaughtEdFactsCode
			 

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
			,'CSA LEA Match All - LEA Identifier: ' + s.LEA_Identifier_State
				+ '; Qualification Status: ' + s.ParaprofessionalQualificationEdFactsCode
				+ '; Special Ed Age Group Taught: ' + s.SpecialEducationAgeGroupTaughtEdFactsCode
				+ '; Full Time Equivalency: ' + cast(s.FullTimeEquivalency as varchar(10))
			,s.StaffCount
			,rreksc.StaffCount
			,CASE WHEN s.StaffCount = ISNULL(rreksc.StaffCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC5 s
		LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc  
			ON s.LEA_Identifier_State = rreksc.OrganizationStateId
			AND s.ParaprofessionalQualificationEdFactsCode = rreksc.QualificationStatus
			AND s.SpecialEducationAgeGroupTaughtEdFactsCode = rreksc.SpecialEducationAgeGroupTaught
			AND rreksc.ReportCode = 'C112' 
			AND rreksc.ReportYear = @SchoolYear
			AND rreksc.ReportLevel = 'LEA'
			AND rreksc.CategorySetCode = 'CSA'

		DROP TABLE #TC5
	
		--Query to find the tests that did not match
		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSA LEA Match All' 
		--AND t.TestScope = 'FS112'
		--AND Passed = 0

/* Test Case 6:
	ST1 at the LEA level
	Subtotal by Qualification Status (Paraprofessional)
*/

		-- Gather, evaluate & record the results
		SELECT 
			COUNT(DISTINCT Personnel_Identifier_State) AS StaffCount
			, LEA_Identifier_State
			, ParaprofessionalQualificationEdFactsCode
			, sum(FullTimeEquivalency) as FullTimeEquivalency
		INTO #TC6
		FROM #staging 
		WHERE --CredentialType in ('Certification','Licensure')
			IsLeaReportedFederally = 1
		GROUP BY LEA_Identifier_State
				, ParaprofessionalQualificationEdFactsCode

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
			,'ST1 LEA Match All - LEA Identifier ' + LEA_Identifier_State
				 + 'Qualification Status: ' + s.ParaprofessionalQualificationEdFactsCode
				 + 'Full Time Equivalency: ' + CAST(s.FullTimeEquivalency as varchar(10))
			,s.StaffCount
			,rreksc.StaffCount
			,CASE WHEN s.StaffCount = ISNULL(rreksc.StaffCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC6 s
		LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc  
			ON s.LEA_Identifier_State = rreksc.OrganizationStateId
			AND s.ParaprofessionalQualificationEdFactsCode = rreksc.QualificationStatus
			AND rreksc.ReportCode = 'C112' 
			AND rreksc.ReportYear = @SchoolYear
			AND rreksc.ReportLevel = 'LEA'
			AND rreksc.CategorySetCode = 'ST1'

		DROP TABLE #TC6

		--Query to find the tests that did not match
		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'ST1 LEA Match All' 
		--AND t.TestScope = 'FS112'
		--AND Passed = 0

		
/* Test Case 7:
	ST2 at the LEA level
	Subtotal by Age Group Taught (Paraprofessional)
*/

		-- Gather, evaluate & record the results
		SELECT 
			COUNT(DISTINCT Personnel_Identifier_State) AS StaffCount
			, LEA_Identifier_State
			, SpecialEducationAgeGroupTaught
			, sum(FullTimeEquivalency) as FullTimeEquivalency
		INTO #TC7
		FROM #staging 
		WHERE IsLeaReportedFederally = 1
		GROUP BY LEA_Identifier_State
				, SpecialEducationAgeGroupTaught

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
			,'ST2 LEA Match All'
			,'ST2 LEA Match All - LEA Identifier ' + LEA_Identifier_State
				+ ' Age Group Taught: ' + s.SpecialEducationAgeGroupTaught 
				+ ' Full Time Equivalency: ' + CAST(s.FullTimeEquivalency as varchar(10))
			,s.StaffCount
			,rreksc.StaffCount
			,CASE WHEN s.StaffCount = ISNULL(rreksc.StaffCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC7 s
		LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc  
			ON s.LEA_Identifier_State = rreksc.OrganizationStateId
			AND s.SpecialEducationAgeGroupTaught = rreksc.SpecialEducationAgeGroupTaught
			AND rreksc.ReportCode = 'C112' 
			AND rreksc.ReportYear = @SchoolYear
			AND rreksc.ReportLevel = 'LEA'
			AND rreksc.CategorySetCode = 'ST2'

		DROP TABLE #TC7

		--Query to find the tests that did not match
		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'ST2 LEA Match All' 
		--AND t.TestScope = 'FS112'
		--AND Passed = 0


/* Test Case 8:
	TOT at the LEA level
*/
		SELECT 
			COUNT(DISTINCT Personnel_Identifier_State) AS StaffCount
			, LEA_Identifier_State
		INTO #TC8
		FROM #staging 
		WHERE IsLeaReportedFederally = 1
		GROUP BY LEA_Identifier_State
		
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
			,'TOT LEA Match All'
			,'TOT LEA Match All - LEA_Identifier_State: ' + s.LEA_Identifier_State
			,s.StaffCount
			,rreksc.StaffCount
			,CASE WHEN s.StaffCount = ISNULL(rreksc.StaffCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC8 s
		LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc 
			ON s.LEA_Identifier_State = rreksc.OrganizationStateId
			AND rreksc.ReportCode = 'C112' 
			AND rreksc.ReportYear = @SchoolYear
			AND rreksc.ReportLevel = 'LEA'
			AND rreksc.CategorySetCode = 'TOT'
			AND s.LEA_Identifier_State = rreksc.OrganizationStateId
			
		DROP TABLE #TC8

		--Query to find the tests that did not match
		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'TOT LEA Match All' 
		--AND t.TestScope = 'FS112'
		--AND Passed = 0
		
		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END

		DECLARE @msg AS NVARCHAR(MAX)
		SET @msg = ERROR_MESSAGE()
		DECLARE @sev AS INT
		SET @sev = ERROR_SEVERITY()

		RAISERROR(@msg, @sev, 1)

	END CATCH; 

	--clean up
	--DROP TABLE #Staging
	--DROP TABLE #TC1
	--DROP TABLE #TC2
	--DROP TABLE #TC3
	--DROP TABLE #TC4
	--DROP TABLE #TC5
	--DROP TABLE #TC6
	--DROP TABLE #TC7
	--DROP TABLE #TC8

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

		IF OBJECT_ID('tempdb..#TC5') IS NOT NULL
		DROP TABLE #TC5

		IF OBJECT_ID('tempdb..#TC6') IS NOT NULL
		DROP TABLE #TC6

		IF OBJECT_ID('tempdb..#TC7') IS NOT NULL
		DROP TABLE #TC7

		IF OBJECT_ID('tempdb..#TC8') IS NOT NULL
		DROP TABLE #TC8

END

