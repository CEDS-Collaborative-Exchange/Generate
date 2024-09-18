CREATE PROCEDURE [App].[FS002_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

BEGIN TRY
	BEGIN TRANSACTION

			-- Define the test
		DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'General_UnitTestCase') 
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
				  'FS002_UnitTestCase'
				, 'FS002_TestCase'				
				, 'FS002'
				, 1
			)
			SET @SqlUnitTestId = @@IDENTITY
		END 
		ELSE 
		BEGIN
			SELECT 
				@SqlUnitTestId = SqlUnitTestId
			FROM App.SqlUnitTest 
			WHERE UnitTestName = 'FS002_UnitTestCase'
		END

		-- Clear out last run
		DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	

		 /* Test Case 1:
			 CSA at the SEA level
		 */
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
		 SELECT 
			  @SqlUnitTestId
			 ,'CIID-4495'
			 ,'Stageing.PPSE PersonIds Unique'
			 ,0
			 ,COUNT(*)
			 ,CASE WHEN COUNT(*) > 0 THEN 0 ELSE 1 END
			 ,GETDATE()
		FROM (SELECT PersonId AS DuplicatePersonIds FROM Staging.ProgramParticipationSpecialEducation GROUP BY PersonId HAVING COUNT(*) > 1) dups


	

		-- SELECT * from App.SqlUnitTestCaseResult WHERE TestCaseName = 'CSA SEA Match All' AND Passed = 0

	



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