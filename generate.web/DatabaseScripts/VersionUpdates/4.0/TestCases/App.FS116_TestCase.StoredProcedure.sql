CREATE PROCEDURE [App].[FS116_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

BEGIN TRY
	BEGIN TRANSACTION

		-- Define the test
		DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = '') 
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
				  'FS116_UnitTestCase'
				, 'FS116_TestCase'				
				, 'FS116'
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
			WHERE UnitTestName = 'FS116_UnitTestCase'
		END
	
		-- Create test data if needed & doesn't exist (should be rerunnable, but don't insert duplicate records
	
		-- Create base data set

		--DROP TABLE IF EXISTS #staging 

		IF OBJECT_ID('tempdb..#staging') IS NOT NULL
		DROP TABLE #staging

		SELECT DISTINCT
			  ske.Student_Identifier_State
			, ske.LEA_Identifier_State
			, ske.School_Identifier_State
			, ske.GradeLevel
			, rdgl.GradeLevelEdFactsCode
			, sppt3.LanguageInstructionProgramServiceType
			, rdt3s.TitleiiiLanguageInstructionEdFactsCode
		INTO #staging
		FROM Staging.K12Enrollment ske
		JOIN Staging.ProgramParticipationTitleIII sppt3
			ON sppt3.Student_Identifier_State = ske.Student_Identifier_State
			AND sppt3.LEA_Identifier_State = ske.LEA_Identifier_State
			AND sppt3.School_Identifier_State = ske.School_Identifier_State
		JOIN RDS.DimGradeLevels rdgl
			ON ske.GradeLevel = rdgl.GradeLevelCode
		JOIN RDS.DimTitleIIIStatuses rdt3s
			ON sppt3.LanguageInstructionProgramServiceType = rdt3s.TitleiiiLanguageInstructionCode
		WHERE rdt3s.TitleiiiLanguageInstructionCode IS NOT NULL

		-- Gather, evaluate & record the results
		/* Test Case 1:
			
		*/
		SELECT 
			  rreksc.GRADELEVEL
			, rreksc.StudentCount 
		FROM RDS.ReportEDFactsK12StudentCounts rreksc
		WHERE ReportCode = 'C116' 
--			AND ReportYear = @SchoolYear
			AND TableTypeAbbrv = 'TTLIIILEPSTDSRV'
			AND CategorySetCode = 'CSA'
			AND ReportLevel = 'SEA'

		SELECT 
			  GradeLevelEdFactsCode
			, COUNT(*)
		FROM #staging 
		GROUP BY GradeLevelEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		VALUES 
		(
			@SqlUnitTestId
			,'Test Case 1'
			,@expectedResult
			,@actualResult
			,CASE WHEN @actualResult = @expectedResult THEN 1 ELSE 0 END
			,GETDATE()
		)

		/* Test Case 2:
			Target Identification Subgroups should have counts for all these codes (and only these codes):
			ECODIS,WDIS,LEP,MAN,MA,AP,MB,MF,MHN,MHL,MM,MNP,MPR,MW
		*/
		SELECT @actualResult = OrganizationCount 
		FROM rds.FactOrganizationCountReports 
		WHERE ReportCode = 'C116' 
		AND ReportYear='2021'
		AND SubgroupCode = 'LEP'

		SELECT @expectedResult = COUNT(*) 
		FROM #staging 
		WHERE Subgroup = 'LEP'
		AND SchoolYear = @SchoolYear

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		VALUES 
		(
			@SqlUnitTestId
			,'Test Case 2'
			,@expectedResult
			,@actualResult
			,CASE WHEN @actualResult = @expectedResult THEN 1 ELSE 0 END
			,GETDATE()
		)

		/* Test Case 3:
			Disability Status (IDEA) should have counts for all the below code 
			ECODIS
		*/
		SELECT COUNT(SubgroupCode)
		FROM [RDS].[FactOrganizationCountReports]
		WHERE ReportCode = 'C116' 
		AND ReportYear='2020-21'		
		AND CategorySetCode='CSA'	
		AND SubgroupCode = 'ECODIS'
		AND ComprehensiveSupportCode = 'CSILOWPERF'
		AND ReasonApplicabilityCode = 'RESNAPPLYES'

		SELECT @expectedResult = COUNT(*) 
		FROM #staging 
		WHERE Subgroup = 'EconomicDisadvantage'
		AND ComprehensiveSupport = 'CSILOWPERF'
		AND ComprehensiveSupportReasonApplicability = 'ReasonApplies'
		AND SchoolYear = @SchoolYear

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		VALUES 
		(
			@SqlUnitTestId
			,'Test Case 3'
			,@expectedResult
			,@actualResult
			,CASE WHEN @actualResult = @expectedResult THEN 1 ELSE 0 END
			,GETDATE()
		)

		/* Test Case 4:
		Disability Status (IDEA) should have counts for all the below code 
		WDIS
		*/
		SELECT COUNT(SubgroupCode)
		FROM [RDS].[FactOrganizationCountReports]
		WHERE ReportCode = 'C116' 
		AND ReportYear='2020-21'		
		AND CategorySetCode='CSA'	
		AND SubgroupCode = 'WDIS'
		AND ComprehensiveSupportCode = 'CSILOWPERF'
		AND ReasonApplicabilityCode = 'RESNAPPLYES'

		SELECT @expectedResult = COUNT(*) 
		FROM #staging 
		WHERE Subgroup = 'IDEA'
		AND ComprehensiveSupport = 'CSILOWPERF'
		AND ComprehensiveSupportReasonApplicability = 'ReasonApplies'
		AND SchoolYear = @SchoolYear

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		VALUES 
		(
			@SqlUnitTestId
			,'Test Case 4'
			,@expectedResult
			,@actualResult
			,CASE WHEN @actualResult = @expectedResult THEN 1 ELSE 0 END
			,GETDATE()
		)

		/* Test Case 5:
		English Learner Status should have counts for LEP
		*/
		SELECT COUNT(SubgroupCode)
		FROM [RDS].[FactOrganizationCountReports]
		WHERE ReportCode = 'C116' 
		AND ReportYear='2020-21'		
		AND CategorySetCode='CSA'	
		AND SubgroupCode = 'LEP'
		AND ComprehensiveSupportCode = 'CSILOWPERF'
		AND ReasonApplicabilityCode = 'RESNAPPLYES'

		SELECT @expectedResult = COUNT(*) 
		FROM #staging 
		WHERE Subgroup = 'LEP'
		AND ComprehensiveSupport = 'CSILOWPERF'
		AND ComprehensiveSupportReasonApplicability = 'ReasonApplies'
		AND SchoolYear = @SchoolYear

		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		VALUES 
		(
			@SqlUnitTestId
			,'Test Case 5'
			,@expectedResult
			,@actualResult
			,CASE WHEN @actualResult = @expectedResult THEN 1 ELSE 0 END
			,GETDATE()
		)

		/* Test Case 6:
		MajorRacial Groups should have counts for all these codes (and only these codes):
		MAN,MA,AP,MB,MF,MHN,MHL,MM,MNP,MPR,MW
		*/
		SELECT COUNT(SubgroupCode)
		FROM [RDS].[FactOrganizationCountReports]
		WHERE ReportCode = 'C116' 
		AND ReportYear='2020-21'		
		AND CategorySetCode='CSA'	
		AND SubgroupCode = 'MNP'
		AND ComprehensiveSupportCode = 'CSILOWPERF'
		AND ReasonApplicabilityCode = 'RESNAPPLYES'

		SELECT @expectedResult = COUNT(*) 
		FROM #staging 
		WHERE Subgroup = 'NativeHawaiianorOtherPacificIslander'
		AND ComprehensiveSupport = 'CSILOWPERF'
		AND ComprehensiveSupportReasonApplicability = 'ReasonApplies'
		AND SchoolYear = @SchoolYear
	
		INSERT INTO App.SqlUnitTestCaseResult 
		(
			[SqlUnitTestId]
			,[TestCaseName]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		VALUES 
		(
			@SqlUnitTestId
			,'Test Case 6'
			,@expectedResult
			,@actualResult
			,CASE WHEN @actualResult = @expectedResult THEN 1 ELSE 0 END
			,GETDATE()
		)
		   	 
		--Drop Table
		DROP TABLE #staging
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


END