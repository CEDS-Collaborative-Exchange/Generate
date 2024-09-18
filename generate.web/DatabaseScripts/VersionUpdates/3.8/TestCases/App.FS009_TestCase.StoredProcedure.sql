CREATE PROCEDURE [App].[FS009_TestCase] 
	@SchoolYear SMALLINT
AS
BEGIN

BEGIN TRY
	BEGIN TRANSACTION

		-- Define the test
		DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS009_UnitTestCase') 
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
				  'FS009_UnitTestCase'
				, 'FS009_TestCase'				
				, 'FS009'
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
			WHERE UnitTestName = 'FS009_UnitTestCase'
		END

		-- Clear out last run
		DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId

		-- Create base data set
		-- Get Custom Child Count Date

		
		UPDATE rds.DimSchoolYearDataMigrationTypes
		SET IsSelected = 0

		UPDATE rds.DimSchoolYearDataMigrationTypes
		SET IsSelected = 1
		FROM rds.DimSchoolYearDataMigrationTypes sydmt
		JOIN rds.DimSchoolYears sy 
			ON sydmt.DimSchoolYearId = sy.DimSchoolYearId
		WHERE sy.SchoolYear = @SchoolYear

		--DROP TABLE IF EXISTS #staging 

		IF OBJECT_ID('tempdb..#staging') IS NOT NULL
		DROP TABLE #staging

		DECLARE @ChildCountDate DATETIME

 		select @ChildCountDate = CAST('10/01/' + cast(@SchoolYear - 1 AS Varchar(4)) AS DATETIME)

		--DROP TABLE IF EXISTS #disabilityCodes

		IF OBJECT_ID('tempdb..#disabilityCodes') IS NOT NULL
		DROP TABLE #disabilityCodes

		SELECT distinct o.CategoryOptionCode
		INTO #disabilityCodes
		from app.CategoryOptions o
		inner join app.Categories c on o.CategoryId = c.CategoryId
		and c.CategoryCode = 'DISABCATIDEAEXIT'
		inner join app.CategorySets cs
			on o.CategorySetId = cs.CategorySetId
		inner join app.ToggleResponses r on o.CategoryOptionName = 
				case
					when o.CategoryOptionCode = 'MISSING' then o.CategoryOptionName
					else r.ResponseValue
				end
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId 
		where q.EmapsQuestionAbbrv = 'CHDCTDISCAT'
			AND SubmissionYear = @SchoolYear


		CREATE TABLE #catchmentType ( CatchmentArea varchar(100) )
		INSERT INTO #catchmentType VALUES ( 'Districtwide (students moving out of district)' )
		INSERT INTO #catchmentType VALUES ( 'Entire state (students moving out of state)' )
		
		DECLARE @catchmentArea VARCHAR(50)

		DECLARE db_cursor CURSOR FOR 
		SELECT CatchmentArea 
		FROM #catchmentType

		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @catchmentArea

		WHILE @@FETCH_STATUS = 0  
		BEGIN  

			DELETE FROM RDS.ReportEDFactsK12StudentCounts WHERE ReportCode = 'C009' and ReportYear = @schoolYear

			UPDATE atr
			SET atr.ToggleQuestionOptionId = atqo.ToggleQuestionOptionId
			FROM app.ToggleQuestions atq
			JOIN app.ToggleResponses atr
				ON atr.ToggleQuestionId = atq.ToggleQuestionId
			JOIN app.ToggleQuestionOptions atqo
				ON atr.ToggleQuestionOptionId = atqo.ToggleQuestionOptionId
			WHERE atq.EmapsQuestionAbbrv IN ('DEFEXMOVCONSEA', 'DEFEXMOVCONLEA')
				AND atqo.OptionText = @catchmentArea

			delete from rds.ReportEDFactsK12StudentCounts WHERE ReportCode = 'C009'
			UPDATE app.GenerateReports SET IsLocked = 1 WHERE ReportCode = 'C009'
			EXEC RDS.Create_ReportData 'C009', 'specedexit', 0
	
			--DROP TABLE IF EXISTS #staging
			--DROP TABLE IF EXISTS #stuLea

			IF OBJECT_ID('tempdb..#staging') IS NOT NULL
			DROP TABLE #staging

			IF OBJECT_ID('tempdb..#stuLea') IS NOT NULL
			DROP TABLE #stuLea



			CREATE TABLE #stuLeaTemp (
				  Student_Identifier_State	VARCHAR(20)
				, Lea_Identifier_State		VARCHAR(20)
			)

			IF @catchmentArea = 'Districtwide (students moving out of district)' BEGIN
			
				INSERT INTO #stuLeaTemp
				SELECT DISTINCT
					  Student_Identifier_State
					, Lea_Identifier_State
				FROM Staging.ProgramParticipationSpecialEducation
				WHERE ProgramParticipationEndDate IS NOT NULL
				GROUP BY Student_Identifier_State
					, Lea_Identifier_State
					, ProgramParticipationEndDate
				HAVING ProgramParticipationEndDate  = MIN(ProgramParticipationEndDate)
			
			END ELSE BEGIN
			
				INSERT INTO #stuLeaTemp
				SELECT DISTINCT
					  Student_Identifier_State
					, Lea_Identifier_State
				FROM Staging.ProgramParticipationSpecialEducation
				WHERE ProgramParticipationEndDate IS NOT NULL
				GROUP BY Student_Identifier_State
					, Lea_Identifier_State
					, ProgramParticipationEndDate
				HAVING ProgramParticipationEndDate  = MAX(ProgramParticipationEndDate)

			END

			
			CREATE TABLE #stuLea (
				  Student_Identifier_State	VARCHAR(20)
				, Lea_Identifier_State		VARCHAR(20)
				, SpecialEducationServicesExitDate DATETIME
			)

			INSERT INTO #stuLea
			SELECT
				  sppse.Student_Identifier_State
				, sppse.Lea_Identifier_State
				, MAX(sppse.ProgramParticipationEndDate)
			FROM Staging.ProgramParticipationSpecialEducation sppse
			JOIN #stuLeaTemp temp	
				ON sppse.Student_Identifier_State = temp.Student_Identifier_State
				AND sppse.Lea_Identifier_State = temp.Lea_Identifier_State
			GROUP BY sppse.Student_Identifier_State
				, sppse.Lea_Identifier_State


			SELECT DISTINCT 
				  ske.Student_Identifier_State
				, ske.LEA_Identifier_State
				, ske.School_Identifier_State
				, ske.Birthdate
				, case
					when @ChildCountDate <= sppse.ProgramParticipationEndDate then [RDS].[Get_Age](ske.Birthdate, @ChildCountDate)
					else [RDS].[Get_Age](ske.BirthDate, DATEADD(year, -1, @ChildCountDate))
					end as Age
				, sppse.SpecialEducationExitReason
				, rdis.SpecialEducationExitReasonEdFactsCode
				, sps.PrimaryDisabilityType
				, rdis.PrimaryDisabilityTypeEdFactsCode
				, ske.HispanicLatinoEthnicity
				, spr.RaceType
				, rdr.RaceEdFactsCode
				, ske.Sex
				, CASE ske.Sex
					WHEN 'Male' THEN 'M'
					WHEN 'Female' THEN 'F'
					ELSE 'MISSING'
					END AS SexEdFactsCode
				, CASE
					WHEN sppse.ProgramParticipationEndDate BETWEEN sps.EnglishLearner_StatusStartDate AND ISNULL(sps.EnglishLearner_StatusEndDate, GETDATE()) THEN EnglishLearnerStatus
					ELSE 0
					END AS EnglishLearnerStatus
				, CASE
					WHEN sppse.ProgramParticipationEndDate BETWEEN sps.EnglishLearner_StatusStartDate AND ISNULL(sps.EnglishLearner_StatusEndDate, GETDATE()) THEN 
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
			JOIN #stuLea lea
				ON ske.Student_Identifier_State = lea.Student_Identifier_State
				AND  ske.Lea_Identifier_State = lea.Lea_Identifier_State
			JOIN Staging.PersonStatus sps
				ON sps.Student_Identifier_State = ske.Student_Identifier_State
				AND sps.LEA_Identifier_State = ske.LEA_Identifier_State
				AND sps.School_Identifier_State = ske.School_Identifier_State
			JOIN Staging.ProgramParticipationSpecialEducation sppse
				ON sppse.Student_Identifier_State = ske.Student_Identifier_State
				AND sppse.LEA_Identifier_State = ske.LEA_Identifier_State
				AND sppse.School_Identifier_State = ske.School_Identifier_State
			JOIN #stuLea latest
				ON sppse.Student_Identifier_State = latest.Student_Identifier_State
				AND sppse.LEA_Identifier_State = latest.LEA_Identifier_State
				AND sppse.ProgramParticipationEndDate = latest.SpecialEducationServicesExitDate
			LEFT JOIN Staging.PersonRace spr
				ON spr.Student_Identifier_State = ske.Student_Identifier_State
				AND spr.SchoolYear = ske.SchoolYear
				AND sppse.ProgramParticipationEndDate BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, GETDATE())
			left JOIN RDS.DimRaces rdr
				ON (ske.HispanicLatinoEthnicity = 1 and rdr.RaceEdFactsCode = 'HI7')
					OR (ske.HispanicLatinoEthnicity = 0 AND spr.RaceType = rdr.RaceCode)
			JOIN RDS.DimIdeaStatuses rdis
				ON sps.PrimaryDisabilityType = rdis.PrimaryDisabilityTypeCode
				AND sppse.SpecialEducationExitReason = rdis.SpecialEducationExitReasonCode
			WHERE sppse.ProgramParticipationEndDate is not null
				AND sppse.IDEAEducationalEnvironmentForSchoolAge <> 'PPPS'
				AND sppse.SpecialEducationExitReason IS NOT NULL
				AND ske.SchoolYear = @SchoolYear
				--and sppse.ProgramParticipationEndDate BETWEEN ske.EnrollmentEntryDate and ISNULL(ske.EnrollmentExitDate, getdate())

			
			DELETE FROM #staging
			WHERE Age NOT BETWEEN 14 AND 21


			-- Gather, evaluate & record the results
			/* Test Case 1:
				CSA at the SEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, Age
				, PrimaryDisabilityTypeEdFactsCode
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC1
			FROM #staging s
			JOIN #disabilityCodes d
				ON s.PrimaryDisabilityTypeEdFactsCode = d.CategoryOptionCode
			GROUP BY SpecialEducationExitReasonEdFactsCode
				, Age
				, PrimaryDisabilityTypeEdFactsCode
				
			

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
				,'CSA SEA Match All'
				,'CSA SEA Match All = Catchment Area: ' + @catchmentArea + ';  Age: ' + CAST(s.Age AS VARCHAR(2)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode + '; Disability Type: ' + s.PrimaryDisabilityTypeEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC1 s
			LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.Age = rreksc.Age
				AND s.PrimaryDisabilityTypeEdFactsCode = rreksc.PrimaryDisabilityType
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'CSA'
	

			DROP TABLE #TC1

					-- Gather, evaluate & record the results
			/* Test Case 2:
				CSB at the SEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, RaceEdFactsCode
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC2
			FROM #staging 
			GROUP BY SpecialEducationExitReasonEdFactsCode
				, RaceEdFactsCode
				
			

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
				,'CSB SEA Match All'
				,'CSB SEA Match All = Catchment Area: ' + @catchmentArea + ';  Race: ' + CAST(s.RaceEdFactsCode AS VARCHAR(3)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC2 s
			LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.RaceEdFactsCode = rreksc.RACE
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'CSB'

			DROP TABLE #TC2

		
			/* Test Case 3:
				CSC at the SEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, SexEdFactsCode
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC3
			FROM #staging 
			WHERE SexEdFactsCode <> 'MISSING'
			GROUP BY SpecialEducationExitReasonEdFactsCode
				, SexEdFactsCode
				
			

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
				,'CSC SEA Match All'
				,'CSC SEA Match All = Catchment Area: ' + @catchmentArea + ';  Sex: ' + CAST(s.SexEdFactsCode AS VARCHAR(2)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC3 s
			LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.SexEdFactsCode = rreksc.SEX
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'CSC'

			DROP TABLE #TC3

		
		
			/* Test Case 4:
				CSD at the SEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, EnglishLearnerStatusEdFactsCode
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC4
			FROM #staging 
			GROUP BY SpecialEducationExitReasonEdFactsCode
				, EnglishLearnerStatusEdFactsCode
				
			
		
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
				,'CSD SEA Match All'
				,'CSD SEA Match All = Catchment Area: ' + @catchmentArea + ';  EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(4)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC4 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.EnglishLearnerStatusEdFactsCode = rreksc.ENGLISHLEARNERSTATUS
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'CSD'
			
			DROP TABLE #TC4


			/* Test Case 5:
				ST1 at the SEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC5
			FROM #staging 
			GROUP BY SpecialEducationExitReasonEdFactsCode
			
			

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
				,'ST1 SEA Match All'
				,'ST1 SEA Match All = Catchment Area: ' + @catchmentArea + ';  Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC5 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'ST1'
			
			DROP TABLE #TC5

		
		

			/* Test Case 6:
				ST2 at the SEA level
			*/
			SELECT 
				  Age
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC6
			FROM #staging 
			GROUP BY Age
				
			

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
				,'ST2 SEA Match All'
				,'ST2 SEA Match All = Catchment Area: ' + @catchmentArea + ';  Age: ' + CAST(s.Age as VARCHAR(2))
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC6 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.Age = rreksc.AGE
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'ST2'
			
			DROP TABLE #TC6

		

			/* Test Case 7:
				ST3 at the SEA level
			*/
			SELECT 
				  RaceEdFactsCode
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC7
			FROM #staging 
			GROUP BY RaceEdFactsCode
				
			

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
				,'ST3 SEA Match All'
				,'ST3 SEA Match All = Catchment Area: ' + @catchmentArea + ';  Race: ' + s.RaceEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC7 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.RaceEdFactsCode = rreksc.Race
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'ST3'
			
			DROP TABLE #TC7

		

			/* Test Case 8:
				ST4 at the SEA level
			*/
			SELECT 
				  SexEdFactsCode
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC8
			FROM #staging 
			WHERE SexEdFactsCode <> 'MISSING'
			GROUP BY SexEdFactsCode
				
			

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
				,'ST4 SEA Match All'
				,'ST4 SEA Match All = Catchment Area: ' + @catchmentArea + ';  Sex: ' + s.SexEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC8 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SexEdFactsCode = rreksc.Sex
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'ST4'
			
			DROP TABLE #TC8

		


			/* Test Case 9:
				ST5 at the SEA level
			*/
			SELECT 
				  EnglishLearnerStatusEdFactsCode
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC9
			FROM #staging 
			GROUP BY EnglishLearnerStatusEdFactsCode
				
			

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
				,'ST5 SEA Match All'
				,'ST5 SEA Match All = Catchment Area: ' + @catchmentArea + ';  EL Status: ' + s.EnglishLearnerStatusEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC9 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.EnglishLearnerStatusEdFactsCode = rreksc.ENGLISHLEARNERSTATUS
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'ST5'
			
			DROP TABLE #TC9

		

			/* Test Case 10:
				ST6 at the SEA level
			*/
			SELECT 
				  PrimaryDisabilityTypeEdFactsCode
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC10
			FROM #staging s
			JOIN #disabilityCodes d
				ON s.PrimaryDisabilityTypeEdFactsCode = d.CategoryOptionCode
			GROUP BY PrimaryDisabilityTypeEdFactsCode
				
			

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
				,'ST6 SEA Match All'
				,'ST6 SEA Match All = Catchment Area: ' + @catchmentArea + ';  Primary Disability Type: ' + s.PrimaryDisabilityTypeEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC10 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.PrimaryDisabilityTypeEdFactsCode = rreksc.PRIMARYDISABILITYTYPE
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'ST6'
			
			DROP TABLE #TC10

		

			/* Test Case 11:
				TOT at the SEA level
			*/
			SELECT 
				COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC11
			FROM #staging 

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
				,'TOT SEA Match All'
				,'TOT SEA Match All'
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC11 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'TOT'
			
			DROP TABLE #TC11

		


			----------------------------------------
			--- LEA level tests					 ---
			----------------------------------------
			-- Gather, evaluate & record the results
			/* Test Case 1:
				CSA at the LEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, Age
				, PrimaryDisabilityTypeEdFactsCode
				, LEA_Identifier_State
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC12
			FROM #staging s
			JOIN #disabilityCodes d
				ON s.PrimaryDisabilityTypeEdFactsCode = d.CategoryOptionCode
			GROUP BY LEA_Identifier_State
				, SpecialEducationExitReasonEdFactsCode
				, Age
				, PrimaryDisabilityTypeEdFactsCode
				
			


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
				,'CSA LEA Match All'
				,'CSA LEA Match All = Catchment Area: ' + @catchmentArea + ';  LEA_Identifier_State: ' + s.LEA_Identifier_State + '; Age: ' + CAST(s.Age AS VARCHAR(2)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode + '; Disability Type: ' + s.PrimaryDisabilityTypeEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC12 s
			LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.Age = rreksc.Age
				AND s.LEA_Identifier_State = rreksc.OrganizationStateId
				AND s.PrimaryDisabilityTypeEdFactsCode = rreksc.PrimaryDisabilityType
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'CSA'


	

			DROP TABLE #TC12

		
					-- Gather, evaluate & record the results
			/* Test Case 2:
				CSB at the LEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, RaceEdFactsCode
				, LEA_Identifier_State
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC13
			FROM #staging 
			GROUP BY LEA_Identifier_State
				, SpecialEducationExitReasonEdFactsCode
				, RaceEdFactsCode
				
			


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
				,'CSB LEA Match All'
				,'CSB LEA Match All = Catchment Area: ' + @catchmentArea + ';  LEA_Identifier_State: ' + s.LEA_Identifier_State + '; Race: ' + CAST(s.RaceEdFactsCode AS VARCHAR(3)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC13 s
			LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.RaceEdFactsCode = rreksc.RACE
				AND s.LEA_Identifier_State = rreksc.OrganizationStateId
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'CSB'

			DROP TABLE #TC13

		

			/* Test Case 3:
				CSC at the LEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, SexEdFactsCode
				, LEA_Identifier_State
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC14
			FROM #staging
			WHERE SexEdFactsCode <> 'MISSING'
			GROUP BY LEA_Identifier_State
				, SpecialEducationExitReasonEdFactsCode
				, SexEdFactsCode
				
			

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
				,'CSC LEA Match All'
				,'CSC LEA Match All = Catchment Area: ' + @catchmentArea + ';  LEA_Identifier_State: ' + s.LEA_Identifier_State + '; Sex: ' + CAST(s.SexEdFactsCode AS VARCHAR(2)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC14 s
			LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.SexEdFactsCode = rreksc.SEX
				AND s.LEA_Identifier_State = rreksc.OrganizationStateId
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'CSC'

			DROP TABLE #TC14

		
		
			/* Test Case 4:
				CSD at the LEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, EnglishLearnerStatusEdFactsCode
				, LEA_Identifier_State
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC15
			FROM #staging 
			GROUP BY LEA_Identifier_State
				, SpecialEducationExitReasonEdFactsCode
				, EnglishLearnerStatusEdFactsCode
				
			

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
				,'CSD LEA Match All'
				,'CSD LEA Match All = Catchment Area: ' + @catchmentArea + ';  LEA_Identifier_State: ' + s.LEA_Identifier_State + '; EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC15 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.EnglishLearnerStatusEdFactsCode = rreksc.ENGLISHLEARNERSTATUS
				AND s.LEA_Identifier_State = rreksc.OrganizationStateId
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'CSD'
			
			DROP TABLE #TC15

		
		


			/* Test Case 5:
				ST1 at the LEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, LEA_Identifier_State
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC16
			FROM #staging 
			GROUP BY LEA_Identifier_State
				, SpecialEducationExitReasonEdFactsCode
				
			

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
				,'ST1 LEA Match All'
				,'ST1 LEA Match All = Catchment Area: ' + @catchmentArea + ';  LEA_Identifier_State: ' + s.LEA_Identifier_State + '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC16 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.LEA_Identifier_State = rreksc.OrganizationStateId
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'ST1'
			
			DROP TABLE #TC16

		

			/* Test Case 6:
				ST2 at the LEA level
			*/
			SELECT 
				  Age
				, LEA_Identifier_State
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC17
			FROM #staging 
			GROUP BY LEA_Identifier_State
				, Age
				
			

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
				,'ST2 LEA Match All = Catchment Area: ' + @catchmentArea + ';  LEA_Identifier_State: ' + s.LEA_Identifier_State + '; Age: ' + CAST(s.Age as VARCHAR(2))
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC17 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.Age = rreksc.AGE
				AND s.LEA_Identifier_State = rreksc.OrganizationStateId
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'ST2'
			
			DROP TABLE #TC17

		


			/* Test Case 7:
				ST3 at the LEA level
			*/
			SELECT 
				  RaceEdFactsCode
				, LEA_Identifier_State
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC18
			FROM #staging 
			GROUP BY LEA_Identifier_State
				, RaceEdFactsCode
				
			

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
				,'ST3 LEA Match All'
				,'ST3 LEA Match All = Catchment Area: ' + @catchmentArea + ';  LEA_Identifier_State: ' + s.LEA_Identifier_State + '; Race: ' + s.RaceEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC18 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.RaceEdFactsCode = rreksc.Race
				AND s.LEA_Identifier_State = rreksc.OrganizationStateId
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'ST3'
			
			DROP TABLE #TC18

		


			/* Test Case 8:
				ST4 at the LEA level
			*/
			SELECT 
				  SexEdFactsCode
				, LEA_Identifier_State
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC19
			FROM #staging 
			WHERE SexEdFactsCode <> 'MISSING'
			GROUP BY LEA_Identifier_State
				, SexEdFactsCode
				
			

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
				,'ST4 LEA Match All'
				,'ST4 LEA Match All = Catchment Area: ' + @catchmentArea + ';  LEA_Identifier_State: ' + s.LEA_Identifier_State + '; Sex: ' + s.SexEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC19 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SexEdFactsCode = rreksc.Sex
				AND s.LEA_Identifier_State = rreksc.OrganizationStateId
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'ST4'
			
			DROP TABLE #TC19

		


			/* Test Case 9:
				ST5 at the LEA level
			*/
			SELECT 
				  EnglishLearnerStatusEdFactsCode
				, LEA_Identifier_State
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC20
			FROM #staging 
			GROUP BY LEA_Identifier_State
				, EnglishLearnerStatusEdFactsCode
				
			

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
				,'ST5 LEA Match All'
				,'ST5 LEA Match All = Catchment Area: ' + @catchmentArea + ';  LEA_Identifier_State: ' + s.LEA_Identifier_State + '; EL Status: ' + s.EnglishLearnerStatusEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC20 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.EnglishLearnerStatusEdFactsCode = rreksc.ENGLISHLEARNERSTATUS
				AND s.LEA_Identifier_State = rreksc.OrganizationStateId
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'ST5'
			
			DROP TABLE #TC20

		

		
			/* Test Case 10:
				ST6 at the LEA level
			*/
			SELECT 
				  PrimaryDisabilityTypeEdFactsCode
				, LEA_Identifier_State
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC21
			FROM #staging s
			JOIN #disabilityCodes d
				ON s.PrimaryDisabilityTypeEdFactsCode = d.CategoryOptionCode
			GROUP BY LEA_Identifier_State
				, PrimaryDisabilityTypeEdFactsCode
				
			

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
				,'ST6 LEA Match All'
				,'ST6 LEA Match All = Catchment Area: ' + @catchmentArea + ';  LEA_Identifier_State: ' + s.LEA_Identifier_State + '; Primary Disability Type: ' + s.PrimaryDisabilityTypeEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC21 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.PrimaryDisabilityTypeEdFactsCode = rreksc.PRIMARYDISABILITYTYPE
				AND s.LEA_Identifier_State = rreksc.OrganizationStateId
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'ST6'
			
			DROP TABLE #TC21

		
			/* Test Case 11:
				TOT at the LEA level
			*/
			SELECT 
				  LEA_Identifier_State
				, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
			INTO #TC22
			FROM #staging 
			GROUP BY LEA_Identifier_State
			
			

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
				,'TOT LEA Match All'
				,'TOT LEA Match All = Catchment Area: ' + @catchmentArea + ';  LEA_Identifier_State: ' + s.LEA_Identifier_State
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC22 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.LEA_Identifier_State = rreksc.OrganizationStateId
				AND rreksc.ReportCode = 'C009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'TOT'
			
			DROP TABLE #TC22
			
			--DROP TABLE IF EXISTS #stuLea
			--DROP TABLE IF EXISTS #stuLeaTemp

			IF OBJECT_ID('tempdb..#stuLea') IS NOT NULL
			DROP TABLE #stuLea

			IF OBJECT_ID('tempdb..#stuLeaTemp') IS NOT NULL
			DROP TABLE #stuLeaTemp

		FETCH NEXT FROM db_cursor INTO @catchmentArea 
	END 

	CLOSE db_cursor  
	DEALLOCATE db_cursor


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