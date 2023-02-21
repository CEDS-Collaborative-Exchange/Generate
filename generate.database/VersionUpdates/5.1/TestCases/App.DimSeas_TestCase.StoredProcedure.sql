CREATE OR ALTER PROCEDURE [App].[DimSeas_TestCase]	
AS
BEGIN

		-- Define the test
		DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'DimSeas_UnitTestCase') 
		BEGIN
			SET @expectedResult = 1
			INSERT INTO App.SqlUnitTest (
				  [UnitTestName]
				, [StoredProcedureName]
				, [TestScope]
				, [IsActive]
			)
			VALUES (
				'DimSeas_UnitTestCase'
				, 'DimSeas_TestCase'				
				, 'DimSeas'
				, 1
			)
			SET @SqlUnitTestId = @@IDENTITY
		END 
		ELSE 
		BEGIN
			SELECT 
				@SqlUnitTestId = SqlUnitTestId
			FROM App.SqlUnitTest 
			WHERE UnitTestName = 'DimSeas_UnitTestCase'
		END

		-- Clear out last run
		DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
		SELECT  
			 [SeaName]
           , [SeaIdentifierState]
           , [StateAnsiCode]
           , [StateAbbreviationCode]
           , [StateAbbreviationDescription]
           , [MailingAddressCity]
           , [MailingAddressPostalCode]
           , [MailingAddressState]
           , [MailingAddressStreet]
           , [PhysicalAddressCity]
           , [PhysicalAddressPostalCode]
           , [PhysicalAddressState]
           , [PhysicalAddressStreet]
           , [Telephone]
           , [Website]
           , [RecordStartDateTime]
           , [RecordEndDateTime]
           , [MailingAddressStreet2]
           , [PhysicalAddressStreet2]
           , [SeaOrganizationId]
           , [MailingCountyAnsiCode]
           , [PhysicalCountyAnsiCode]
		INTO #Students
		FROM Staging.K12Enrollment ske
		LEFT JOIN RDS.DimSeas rds
			ON rds.StateStudentIdentifier = ske.Student_Identifier_State
			AND ISNULL(rds.FirstName, 'MISSING') = ISNULL(ske.FirstName, 'MISSING') 
			AND ISNULL(rds.MiddleName, 'MISSING') = ISNULL(ske.MiddleName, 'MISSING') 
			AND ISNULL(rds.LastName, 'MISSING') = ISNULL(ske.LastName, 'MISSING') 
			AND ISNULL(rds.SexCode, 'MISSING') = ISNULL(ske.Sex, 'MISSING') 
			AND ISNULL(rds.BirthDate, '01/01/1900') = ISNULL(ske.BirthDate, '01/01/1900') 
			AND ISNULL(rds.Cohort, 0) = ISNULL(ske.CohortGraduationYear, 0)
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
			,(SELECT COUNT(*) FROM #Students WHERE DimK12StudentId IS NOT NULL)
			,CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM #Students WHERE DimK12StudentId IS NOT NULL) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #Students

		DROP TABLE #Students

END
