CREATE PROCEDURE [App].[FS194_TestCase]	
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
			, LEA_Identifier_State
			, School_Identifier_State
			, FullTimeEquivalency
			, SpecialEducationStaffCategory
			, CASE SpecialEducationStaffCategory
				WHEN 'PSYCH'		THEN 'PSYCH'
				WHEN 'SOCIALWORK' 	THEN 'SOCIALWORK' 
				WHEN 'OCCTHERAP'	THEN 'OCCTHERAP'
				WHEN 'AUDIO'		THEN 'AUDIO'
				WHEN 'PEANDREC'		THEN 'PEANDREC'
				WHEN 'PHYSTHERAP'	THEN 'PHYSTHERAP'
				WHEN 'SPEECHPATH' 	THEN 'SPEECHPATH' 
				WHEN 'INTERPRET'	THEN 'INTERPRET'
				WHEN 'COUNSELOR'	THEN 'COUNSELOR'
				WHEN 'ORIENTMOBIL'	THEN 'ORIENTMOBIL'
				WHEN 'MEDNURSE'		THEN 'MEDNURSE'
				ELSE 'MISSING'
			END AS SpecialEducationSupportServicesCategoryEdFactsCode
			, CredentialType
			, CASE 
				WHEN CredentialType in ('Certification', 'Licensure')
					AND CredentialIssuanceDate <= CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)
					AND isnull(CredentialExpirationDate, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)) >= CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)
					THEN 'FC'
				ELSE 'NFC'
			END AS CertificationStatusEdFactsCode
			, CredentialIssuanceDate
			, CredentialExpirationDate
			, AssignmentStartDate
			, AssignmentEndDate
		INTO #staging
		FROM Staging.K12StaffAssignment sksa
		WHERE K12StaffClassification in ('AdministrativeSupportStaff','Administrators','AllOtherSupportStaff','ElementaryTeachers','InstructionalCoordinators',
			'KindergartenTeachers','LibraryMediaSpecialists','LibraryMediaSupportStaff','Paraprofessionals','Pre-KindergartenTeachers','SchoolCounselors',
			'SchoolPsychologist','SecondaryTeachers','SpecialEducationTeachers','StudentSupportServicesStaff','UngradedTeachers')
		AND ISNULL(AssignmentEndDate, GETDATE()) > @SYStartDate
--		AND ProgramTypeCode = @SPEDProgram
--		WHERE sksa.SchoolYear = @SchoolYear


/* Test Case 1:
	CSA at the SEA level 
	Teachers (FTE) by Credential Status and SPED Support Services Category
*/

		-- Gather, evaluate & record the results
		SELECT 
			count(distinct Personnel_Identifier_State) as StaffCount
			, SpecialEducationSupportServicesCategoryEdFactsCode
			, CertificationStatusEdFactsCode
			, sum(FullTimeEquivalency) as FullTimeEquivalency
		INTO #TC1
		FROM #staging 
		GROUP BY SpecialEducationSupportServicesCategoryEdFactsCode
			, CertificationStatusEdFactsCode

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
				+ '; Certification Status: ' + s.CertificationStatusEdFactsCode
				+ '; Full Time Equivalency: ' + cast(s.FullTimeEquivalency as varchar(10))
			,s.StaffCount
			,rreksc.StaffCount
			,CASE WHEN s.StaffCount = ISNULL(rreksc.StaffCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC1 s
		LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc  
			ON s.SpecialEducationSupportServicesCategoryEdFactsCode = rreksc.SpecialEducationSupportServicesCategory
			AND s.CertificationStatusEdFactsCode = rreksc.CertificationStatus
			AND rreksc.ReportCode = 'C194' 
			AND rreksc.ReportYear = @SchoolYear
			AND rreksc.ReportLevel = 'SEA'
			AND rreksc.CategorySetCode = 'CSA'
	
		DROP TABLE #TC1

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSA SEA Match All' 
		--AND t.TestScope = 'FS194'
		--AND Passed = 0

/* Test Case 2:
	ST1 at the SEA level
	Subtotal by SPED Support Services Category
*/

		-- Gather, evaluate & record the results
		SELECT 
			COUNT(DISTINCT Personnel_Identifier_State) AS StaffCount
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
			,s.StaffCount
			,rreksc.StaffCount
			,CASE WHEN s.StaffCount = ISNULL(rreksc.StaffCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC2 s
		LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc  
			ON s.SpecialEducationSupportServicesCategoryEdFactsCode = rreksc.SpecialEducationSupportServicesCategory
			AND rreksc.ReportCode = 'C194' 
			AND rreksc.ReportYear = @SchoolYear
			AND rreksc.ReportLevel = 'SEA'
			AND rreksc.CategorySetCode = 'ST1'

		DROP TABLE #TC2

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'ST1 SEA Match All' 
		--AND t.TestScope = 'FS194'
		--AND Passed = 0

		----------------------------------------
		--- LEA level tests					 ---
		----------------------------------------

/* Test Case 3:
	CSA at the LEA level 
	Teachers (FTE) by Credential Status and SPED Support Services Category
*/

		-- Gather, evaluate & record the results
		SELECT 
			count(distinct Personnel_Identifier_State) as StaffCount
			, LEA_Identifier_State
			, SpecialEducationSupportServicesCategoryEdFactsCode
			, CertificationStatusEdFactsCode
			, sum(FullTimeEquivalency) as FullTimeEquivalency
		INTO #TC3
		FROM #staging 
		GROUP BY LEA_Identifier_State
			, SpecialEducationSupportServicesCategoryEdFactsCode
			, CertificationStatusEdFactsCode

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
				+ '; SPED Support Services Category: ' + s.SpecialEducationSupportServicesCategoryEdFactsCode
				+ '; Certification Status: ' + s.CertificationStatusEdFactsCode
				+ '; Full Time Equivalency: ' + cast(s.FullTimeEquivalency as varchar(10))
			,s.StaffCount
			,rreksc.StaffCount
			,CASE WHEN s.StaffCount = ISNULL(rreksc.StaffCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC3 s
		LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc  
			ON s.SpecialEducationSupportServicesCategoryEdFactsCode = rreksc.SpecialEducationSupportServicesCategory
			AND s.CertificationStatusEdFactsCode = rreksc.CertificationStatus
			AND s.LEA_Identifier_State = rreksc.OrganizationStateId
			AND rreksc.ReportCode = 'C194' 
			AND rreksc.ReportYear = @SchoolYear
			AND rreksc.ReportLevel = 'LEA'
			AND rreksc.CategorySetCode = 'CSA'
	
		DROP TABLE #TC3

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSA LEA Match All' 
		--AND t.TestScope = 'FS194'
		--AND Passed = 0

/* Test Case 4:
	ST1 at the LEA level
	Subtotal by SPED Support Services Category
*/

		-- Gather, evaluate & record the results
		SELECT 
			COUNT(DISTINCT Personnel_Identifier_State) AS StaffCount
			, LEA_Identifier_State
			, SpecialEducationSupportServicesCategoryEdFactsCode
			, sum(FullTimeEquivalency) as FullTimeEquivalency
		INTO #TC4
		FROM #staging 
		GROUP BY LEA_Identifier_State
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
			,'ST1 LEA Match All - LEA Identifier: ' + s.LEA_Identifier_State
				+ '; SPED Support Services Category: ' + s.SpecialEducationSupportServicesCategoryEdFactsCode
				+ '; Full Time Equivalency: ' + CAST(s.FullTimeEquivalency as varchar(10))
			,s.StaffCount
			,rreksc.StaffCount
			,CASE WHEN s.StaffCount = ISNULL(rreksc.StaffCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC4 s
		LEFT JOIN RDS.ReportEDFactsK12StaffCounts rreksc  
			ON s.SpecialEducationSupportServicesCategoryEdFactsCode = rreksc.SpecialEducationSupportServicesCategory
			AND s.LEA_Identifier_State = rreksc.OrganizationStateId
			AND rreksc.ReportCode = 'C194' 
			AND rreksc.ReportYear = @SchoolYear
			AND rreksc.ReportLevel = 'LEA'
			AND rreksc.CategorySetCode = 'ST1'

		DROP TABLE #TC4

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'ST1 LEA Match All' 
		--AND t.TestScope = 'FS194'
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

END

