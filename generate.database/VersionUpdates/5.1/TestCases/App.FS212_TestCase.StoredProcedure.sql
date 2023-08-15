CREATE OR ALTER PROCEDURE [dbo].[FS212_TestCase]	
	@schoolYear SMALLINT
AS
BEGIN

BEGIN TRY
	BEGIN TRANSACTION

		-- Define the test
		DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS212_UnitTestCase') 
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
				  'FS212_UnitTestCase'
				, 'FS212_TestCase'				
				, 'FS212'
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
			WHERE UnitTestName = 'FS212_UnitTestCase'
		END
	
		-- Create test data if needed & doesn't exist (should be rerunnable, but don't insert duplicate records
	
		-- Create base data set
		DECLARE @SchoolYear VARCHAR(4)
		SET @SchoolYear = '2021'
	
		SELECT *
		INTO #staging
		FROM 
		(	SELECT [Id]
					  ,[SchoolYear]
					  ,[LEA_Identifier_State]
					  ,[School_Identifier_State]
					  ,[ComprehensiveSupport]
					  ,'' AS [Subgroup]
					  ,[ComprehensiveSupportReasonApplicability]
					  ,[RecordStartDateTime]
					  ,[RecordEndDateTime]
				FROM [Staging].[K12SchoolComprehensiveSupportIdentificationType] 
				WHERE SchoolYear = @SchoolYear
				UNION ALL
				SELECT [Id]
					  ,[SchoolYear]
					  ,[LEA_Identifier_State]
					  ,[School_Identifier_State]
					  ,'' AS [ComprehensiveSupport]
					  ,[Subgroup]
					  ,[ComprehensiveSupportReasonApplicability]
					  ,[RecordStartDateTime]
					  ,[RecordEndDateTime]      
				FROM [Staging].[K12SchoolTargetedSupportIdentificationType]
				WHERE SchoolYear = @SchoolYear
			) K12 

			--SELECT * FROM #staging

		-- Gather, evaluate & record the results
		/* Test Case 1:
			Comprehensive Support Identification Type should have counts for all these codes (and only these codes):
			CSILOWPERF/CSILOWGR/CSIOTHER
		*/
		SELECT @actualResult = OrganizationCount 
		FROM rds.FactOrganizationCountReports 
		WHERE ReportCode = 'C212' 
		AND ReportYear='2021'
		AND ComprehensiveSupportCode = 'CSILOWPERF'

		SELECT @expectedResult = COUNT(*) 
		FROM #staging 
		WHERE ComprehensiveSupport = 'CSILOWPERF'
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
		WHERE ReportCode = 'C212' 
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
		WHERE ReportCode = 'C212' 
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
		WHERE ReportCode = 'C212' 
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
		WHERE ReportCode = 'C212' 
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
		WHERE ReportCode = 'C212' 
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