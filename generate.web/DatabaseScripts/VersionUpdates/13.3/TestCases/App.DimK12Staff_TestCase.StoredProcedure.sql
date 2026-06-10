CREATE PROCEDURE [App].[DimK12Staff_TestCase]	
AS
BEGIN

		IF OBJECT_ID('tempdb..#Staff') IS NOT NULL DROP TABLE #Staff

		-- Define the test
		DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'DimK12Staff_UnitTestCase') 
		BEGIN
			SET @expectedResult = 1
			INSERT INTO App.SqlUnitTest (
				  [UnitTestName]
				, [StoredProcedureName]
				, [TestScope]
				, [IsActive]
			)
			VALUES (
				'DimK12Staff_UnitTestCase'
				, 'DimK12Staff_TestCase'				
				, 'DimK12Staff'
				, 1
			)
			SET @SqlUnitTestId = @@IDENTITY
		END 
		ELSE 
		BEGIN
			SELECT 
				@SqlUnitTestId = SqlUnitTestId
			FROM App.SqlUnitTest 
			WHERE UnitTestName = 'DimK12Staff_UnitTestCase'
		END

		-- Clear out last run
		DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
		SELECT  
			  ske.StaffMemberIdentifierState
			, ske.RecordStartDateTime
			, rds.DimPersonId
		INTO #Staff
		FROM Staging.K12StaffAssignment ske
		LEFT JOIN RDS.DimPeople rds
			ON rds.K12StaffStaffMemberIdentifierState = ske.StaffMemberIdentifierState
			AND ISNULL(rds.RecordStartDateTime, '1/1/1900') = ISNULL(ske.RecordStartDateTime, '1/1/1900') 
			AND rds.IsActiveK12Staff = 1

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
			,'Staff Match'
			,'Staff Match All'
			,COUNT(*)
			,(SELECT COUNT(*) FROM #Staff WHERE DimPersonId IS NOT NULL)
			,CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM #Staff WHERE DimPersonId IS NOT NULL) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #Staff

END
