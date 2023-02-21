CREATE PROCEDURE [App].[DimK12Staff_TestCase]	
AS
BEGIN

DROP TABLE #Staff

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
			  ske.Personnel_Identifier_State
			, ske.BirthDate
			, ske.FirstName
			, ske.MiddleName
			, ske.LastName
			, ske.PositionTitle
			, ske.RecordStartDateTime
			, ske.RecordEndDateTime
			, rds.DimK12StaffId
		INTO #Staff
		FROM Staging.K12StaffAssignment ske
		LEFT JOIN RDS.DimK12Staff rds
			ON rds.StaffMemberIdentifierState = ske.Personnel_Identifier_State
			AND ISNULL(rds.FirstName, 'MISSING') = ISNULL(ske.FirstName, 'MISSING') 
			AND ISNULL(rds.MiddleName, 'MISSING') = ISNULL(ske.MiddleName, 'MISSING') 
			AND ISNULL(rds.LastOrSurname, 'MISSING') = ISNULL(ske.LastName, 'MISSING') 
			AND ISNULL(rds.BirthDate, '01/01/1900') = ISNULL(ske.BirthDate, '01/01/1900') 
			and ISNULL(rds.PositionTitle,'MISSING') = ISNULL(ske.PositionTitle, 'MISSING')
			AND ISNULL(rds.RecordStartDateTime, '1/1/1900') = ISNULL(ske.RecordStartDateTime, '1/1/1900') 

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
			,(SELECT COUNT(*) FROM #Staff WHERE DimK12StaffId IS NOT NULL)
			,CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM #Staff WHERE DimK12StaffId IS NOT NULL) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #Staff


END
