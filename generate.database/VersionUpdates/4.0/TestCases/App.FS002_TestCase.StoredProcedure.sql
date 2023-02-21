CREATE PROCEDURE [App].[FS002_TestCASE]	
	@SchoolYear SMALLINT
AS
BEGIN

BEGIN TRY
	BEGIN TRANSACTION

declare	@SchoolYear SMALLINT = 2021

		-- Define the test
		DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS002_UnitTestCASE') 
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
				  'FS002_UnitTestCASE'
				, 'FS002_TestCASE'				
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
			WHERE UnitTestName = 'FS002_UnitTestCASE'
		END

		-- Clear out last run
		DELETE FROM App.SqlUnitTestCASEResult WHERE SqlUnitTestId = @SqlUnitTestId
	
		-- Create base data set

		-- Get Custom Child Count Date

			DROP TABLE IF EXISTS #staging 

		DECLARE @ChildCountDate DATETIME

		select @ChildCountDate = CAST('10/01/' + cast(@SchoolYear - 1 AS Varchar(4)) AS DATETIME)

		SELECT DISTINCT 
			  ske.Student_Identifier_State
			, ske.LEA_Identifier_State
			, ske.School_Identifier_State
			, sppse.ProgramParticipationBeginDate
			, sppse.ProgramParticipationEndDate
			, ske.Birthdate
			, CASE
				WHEN @ChildCountDate <= sppse.ProgramParticipationEndDate then [RDS].[Get_Age](ske.Birthdate, @ChildCountDate)
			    else [RDS].[Get_Age](ske.BirthDate, DATEADD(year, -1, @ChildCountDate))
			  end as Age
			, GradeLevel
			, sps.PrimaryDisabilityType
			, rdis.PrimaryDisabilityTypeEdFactsCode
			, ske.HispanicLatinoEthnicity
			, spr.RaceType
			, rdr.RaceEdFactsCode
			, sppse.IDEAEducationalEnvironmentForEarlyChildhood
			,sppse.IDEAEducationalEnvironmentForSchoolAge
			, ske.Sex
			, CASE ske.Sex
				WHEN 'Male' THEN 'M'
				WHEN 'Female' THEN 'F'
				ELSE 'MISSING'
			  END AS SexEdFactsCode
			, CASE
				WHEN sppse.ProgramParticipationEndDate BETWEEN sps.EnglishLearner_StatusStartDate AND sps.EnglishLearner_StatusEndDate THEN EnglishLearnerStatus
			    ELSE 0
			  END AS EnglishLearnerStatus
			, CASE
				WHEN sppse.ProgramParticipationEndDate BETWEEN sps.EnglishLearner_StatusStartDate AND sps.EnglishLearner_StatusEndDate THEN 
					CASE 
						WHEN EnglishLearnerStatus = 1 THEN 'LEP'
						WHEN EnglishLearnerStatus = 0 THEN 'NLEP'
						WHEN EnglishLearnerStatus IS NULL THEN 'NLEP'
						ELSE 'MISSING'
					END
			    ELSE 'NLEP'
			  END AS EnglishLearnerStatusEdFactsCode
		INTO #staging
		FROM Staging.K12Enrollment ske
		JOIN Staging.PersonStatus sps
			ON sps.Student_Identifier_State = ske.Student_Identifier_State
			AND sps.LEA_Identifier_State = ske.LEA_Identifier_State
			AND sps.School_Identifier_State = ske.School_Identifier_State
			AND @ChildCountDate BETWEEN IDEA_StatusStartDate AND ISNULL(IDEA_StatusEndDate,GETDATE())
		JOIN Staging.ProgramParticipationSpecialEducation sppse
			ON sppse.Student_Identifier_State = ske.Student_Identifier_State
			AND sppse.LEA_Identifier_State = ske.LEA_Identifier_State
			AND sppse.School_Identifier_State = ske.School_Identifier_State
		LEFT JOIN Staging.PersonRace spr
			ON spr.Student_Identifier_State = ske.Student_Identifier_State
			AND spr.SchoolYear = ske.SchoolYear
			AND sppse.ProgramParticipationEndDate BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, GETDATE())
		LEFT JOIN RDS.DimRaces rdr
			ON (ske.HispanicLatinoEthnicity = 1 AND rdr.RaceEdFactsCode = 'HI7')
				OR (ske.HispanicLatinoEthnicity = 0 AND spr.RaceType = rdr.RaceCode)
		JOIN RDS.DimIdeaStatuses rdis
			ON sps.PrimaryDisabilityType = rdis.PrimaryDisabilityTypeCode
		WHERE ske.SchoolYear = @SchoolYear
		
		DELETE FROM #staging
		WHERE NOT ((Age BETWEEN 6 AND 21) OR (Age = 5 AND GradeLevel NOT IN ('PK')))
			

		-- Uncomment Code below and update with 002 test data. Copied from 009 Test Case. 
		-- -- Gather, evaluate & record the results
		-- /* Test CASE 1:
			-- CSA at the SEA level
		-- */
		-- SELECT 
			  -- SpecialEducationExitReasonEdFactsCode
			-- , Age
			-- , PrimaryDisabilityTypeEdFactsCode
			-- , COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		-- INTO #TC1
		-- FROM #staging 
		-- GROUP BY SpecialEducationExitReasonEdFactsCode
			-- , Age
			-- , PrimaryDisabilityTypeEdFactsCode
		

		-- INSERT INTO App.SqlUnitTestCASEResult 
		-- (
			-- [SqlUnitTestId]
			-- ,[TestCASEName]
			-- ,[TestCASEDetails]
			-- ,[ExpectedResult]
			-- ,[ActualResult]
			-- ,[Passed]
			-- ,[TestDateTime]
		-- )
		-- SELECT 
			 -- @SqlUnitTestId
			-- ,'CSA SEA Match All'
			-- ,'CSA SEA Match All - Age: ' + CAST(s.Age AS VARCHAR(2)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode + '; Disability Type: ' + s.PrimaryDisabilityTypeEdFactsCode
			-- ,s.StudentCount
			-- ,rreksc.StudentCount
			-- ,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
			-- ,GETDATE()
		-- FROM #TC1 s
		-- JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
			-- ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
			-- AND s.Age = rreksc.Age
			-- AND s.PrimaryDisabilityTypeEdFactsCode = rreksc.PrimaryDisabilityType
			-- AND rreksc.ReportCode = 'C002' 
			-- AND rreksc.ReportYear = @SchoolYear
			-- AND rreksc.ReportLevel = 'SEA'
			-- AND rreksc.CategorySetCode = 'CSA'
	

		-- DROP TABLE #TC1

		-- SELECT * from App.SqlUnitTestCASEResult WHERE TestCASEName = 'CSA SEA Match All' AND Passed = 0

	



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