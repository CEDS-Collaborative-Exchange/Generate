CREATE PROCEDURE [App].[DimK12Students_TestCase]	
AS
BEGIN


		-- Define the test
		DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'DimK12Students_UnitTestCase') 
		BEGIN
			SET @expectedResult = 1
			INSERT INTO App.SqlUnitTest (
				  [UnitTestName]
				, [StoredProcedureName]
				, [TestScope]
				, [IsActive]
			)
			VALUES (
				'DimK12Students_UnitTestCase'
				, 'DimK12Students_TestCase'				
				, 'DimK12Students'
				, 1
			)
			SET @SqlUnitTestId = @@IDENTITY
		END 
		ELSE 
		BEGIN
			SELECT 
				@SqlUnitTestId = SqlUnitTestId
			FROM App.SqlUnitTest 
			WHERE UnitTestName = 'DimK12Students_UnitTestCase'
		END

		-- Clear out last run
		DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
		SELECT  
			  ske.StudentIdentifierState
			, ske.LeaIdentifierSeaAccountability
			, ske.SchoolIdentifierSea
			, ske.FirstName
			, ske.MiddleName
			, ske.LastOrSurname
			, ske.Birthdate
			, ske.Sex
			, ske.EnrollmentEntryDate AS RecordStartDateTime
			, ske.EnrollmentExitDate AS RecordEndDateTime
			, rds.DimPersonId
		INTO #Students
		FROM Staging.K12Enrollment ske
		LEFT JOIN RDS.DimPeople rds
			ON rds.K12StudentStudentIdentifierState = ske.StudentIdentifierState
			AND ISNULL(rds.FirstName, 'MISSING') = ISNULL(ske.FirstName, 'MISSING') 
			AND ISNULL(rds.MiddleName, 'MISSING') = ISNULL(ske.MiddleName, 'MISSING') 
			AND ISNULL(rds.LastOrSurname, 'MISSING') = ISNULL(ske.LastOrSurname, 'MISSING') 
			AND ISNULL(rds.BirthDate, '01/01/1900') = ISNULL(ske.BirthDate, '01/01/1900') 
			AND ISNULL(rds.RecordStartDateTime, '1/1/1900') = ISNULL(ske.EnrollmentEntryDate, '1/1/1900') 

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
			,'Student Match'
			,'Student Match All'
			,COUNT(*)
			,(SELECT COUNT(*) FROM #Students WHERE DimPersonID IS NOT NULL)
			,CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM #Students WHERE DimPersonID IS NOT NULL) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #Students

		DROP TABLE #Students

END
