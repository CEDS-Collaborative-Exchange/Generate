﻿CREATE PROCEDURE [App].[FS143_TestCase] 
	@SchoolYear INT
AS
BEGIN


BEGIN TRY

	BEGIN TRANSACTION

--clear the tables for the next run
		--DROP TABLE IF EXISTS #C143Staging
		--DROP TABLE IF EXISTS #STC01
		--DROP TABLE IF EXISTS #STC02
		--DROP TABLE IF EXISTS #STC03
		--DROP TABLE IF EXISTS #STC04
		--DROP TABLE IF EXISTS #STC05
		--DROP TABLE IF EXISTS #LTC01
		--DROP TABLE IF EXISTS #LTC02
		--DROP TABLE IF EXISTS #LTC03
		--DROP TABLE IF EXISTS #LTC04
		--DROP TABLE IF EXISTS #LTC05

		IF OBJECT_ID('tempdb..#C143Staging') IS NOT NULL
		DROP TABLE #C143Staging

		IF OBJECT_ID('tempdb..#STC01') IS NOT NULL
		DROP TABLE #STC01

		IF OBJECT_ID('tempdb..#STC02') IS NOT NULL
		DROP TABLE #STC02

		IF OBJECT_ID('tempdb..#STC03') IS NOT NULL
		DROP TABLE #STC03

		IF OBJECT_ID('tempdb..#STC04') IS NOT NULL
		DROP TABLE #STC04

		IF OBJECT_ID('tempdb..#STC05') IS NOT NULL
		DROP TABLE #STC05

		IF OBJECT_ID('tempdb..#LTC01') IS NOT NULL
		DROP TABLE #LTC01

		IF OBJECT_ID('tempdb..#LTC02') IS NOT NULL
		DROP TABLE #LTC02

		IF OBJECT_ID('tempdb..#LTC03') IS NOT NULL
		DROP TABLE #LTC03

		IF OBJECT_ID('tempdb..#LTC04') IS NOT NULL
		DROP TABLE #LTC04

		IF OBJECT_ID('tempdb..#LTC05') IS NOT NULL
		DROP TABLE #LTC05

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
				'FS143_UnitTestCase'
			, 'FS143_TestCase'				
			, 'FS143'
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
		WHERE UnitTestName = 'FS143_UnitTestCase'
	END
	
			-- Clear out last run
		DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId


		-- Create test data if needed & doesn't exist (should be rerunnable, but don't insert duplicate records
-- Get Custom Child Count Date
		DECLARE @cutOffMonth INT, @cutOffDay INT, @customFactTypeDate VARCHAR(10)
		set @cutOffMonth = 11
		set @cutOffDay = 1

		select @customFactTypeDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q 
			on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'CHDCTDTE'

		select @cutOffMonth = SUBSTRING(@customFactTypeDate, 0, CHARINDEX('/', @customFactTypeDate))
		select @cutOffDay = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)
		
	 SELECT  
			ske.Student_Identifier_State
			, ske.LEA_Identifier_State
			, ske.School_Identifier_State
			, sppse.ProgramParticipationEndDate
			, ske.Birthdate
			, sps.PrimaryDisabilityType
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
				WHEN ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
					BETWEEN ISNULL(sps.EnglishLearner_StatusStartDate, CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE))  
						AND ISNULL(sps.EnglishLearner_StatusEndDate, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)) 
						THEN ISNULL(EnglishLearnerStatus, 0)
			    ELSE 0
			  END AS EnglishLearnerStatus
			, CASE
				WHEN ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
					BETWEEN ISNULL(sps.EnglishLearner_StatusStartDate, CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE))  
						AND ISNULL(sps.EnglishLearner_StatusEndDate, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)) 
						THEN 
							CASE 
								WHEN EnglishLearnerStatus = 1 THEN 'LEP'
								--WHEN ISNULL(EnglishLearnerStatus, 0) = 0 THEN 'NLEP'
								ELSE 'NLEP'
							END
				ELSE 'NLEP'
			  END AS EnglishLearnerStatusEdFactsCode
			, sd.DisciplineMethodOfCwd
            , sd.DisciplinaryActionTaken
            , sd.IdeaInterimRemovalReason
            , sd.IdeaInterimRemoval
			, sd.DurationOfDisciplinaryAction
	INTO #C143Staging
	FROM Staging.K12Enrollment ske
	JOIN Staging.Discipline sd
		ON sd.Student_Identifier_State = ske.Student_Identifier_State
		AND ISNULL(sd.LEA_Identifier_State, '') = ISNULL(ske.LEA_Identifier_State, '')
		AND ISNULL(sd.School_Identifier_State, '') = ISNULL(ske.School_Identifier_State, '')
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') between ISNULL(ske.EnrollmentEntryDate, '1900-01-01') and ISNULL (ske.EnrollmentExitDate, GETDATE())
	JOIN Staging.PersonStatus sps
		ON sps.Student_Identifier_State = sd.Student_Identifier_State
		AND ISNULL(sps.LEA_Identifier_State, '') = ISNULL(sd.LEA_Identifier_State, '')
		AND ISNULL(sps.School_Identifier_State, '') = ISNULL(sd.School_Identifier_State, '')
		--Discipline Date within IDEA range
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN ISNULL(sps.IDEA_StatusStartDate, CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)) 
			AND ISNULL (sps.IDEA_StatusEndDate, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE))
	JOIN Staging.ProgramParticipationSpecialEducation sppse
		ON sppse.Student_Identifier_State = sps.Student_Identifier_State
		AND ISNULL(sppse.LEA_Identifier_State, '') = ISNULL(sps.LEA_Identifier_State, '')
		AND ISNULL(sppse.School_Identifier_State, '') = ISNULL(sps.School_Identifier_State, '')
		--Discipline Date within Program Participation range
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN ISNULL(sppse.ProgramParticipationBeginDate, CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)) 
			AND ISNULL(sppse.ProgramParticipationEndDate, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE))
	LEFT JOIN Staging.PersonRace spr
		ON spr.Student_Identifier_State = ske.Student_Identifier_State
		AND spr.SchoolYear = ske.SchoolYear
		AND ISNULL(sppse.ProgramParticipationEndDate, spr.RecordStartDateTime) 
			BETWEEN spr.RecordStartDateTime 
			AND ISNULL(spr.RecordEndDateTime, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE))
	LEFT JOIN RDS.DimRaces rdr
		ON (ske.HispanicLatinoEthnicity = 1 and rdr.RaceEdFactsCode = 'HI7')
			OR (ske.HispanicLatinoEthnicity = 0 AND spr.RaceType = rdr.RaceCode)
	WHERE sps.IDEAIndicator = 1
		AND ske.Schoolyear = CAST(@SchoolYear AS VARCHAR)
		AND [RDS].[Get_Age](ske.Birthdate, DATEFROMPARTS(CASE WHEN @cutOffMonth >= 7 THEN @SchoolYear - 1 
           ELSE @SchoolYear 
           END, @cutOffMonth, @cutOffDay)
           ) BETWEEN 3 AND 21   
		AND ske.Student_Identifier_State IN (
			SELECT e.Student_Identifier_State 
			FROM Staging.Discipline d 
			JOIN staging.K12Enrollment e 
				ON d.Student_Identifier_State = e.Student_Identifier_State
				AND ISNULL(d.LEA_Identifier_State, '') = ISNULL(e.LEA_Identifier_State, '')
				AND ISNULL(d.School_Identifier_State, '') = ISNULL(e.School_Identifier_State, '')
				AND ISNULL(d.DisciplinaryActionStartDate, '1900-01-01') between ISNULL(e.EnrollmentEntryDate, '1900-01-01') and ISNULL (e.EnrollmentExitDate, GETDATE()) 
			JOIN Staging.ProgramParticipationSpecialEducation pp
				ON pp.Student_Identifier_State = d.Student_Identifier_State
				AND ISNULL(pp.LEA_Identifier_State, '') = ISNULL(d.LEA_Identifier_State, '')
				AND ISNULL(pp.School_Identifier_State, '') = ISNULL(d.School_Identifier_State, '')
				--Discipline Date within Program Participation range
				AND ISNULL(d.DisciplinaryActionStartDate, '1900-01-01') 
					BETWEEN ISNULL(pp.ProgramParticipationBeginDate, CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)) 
					AND ISNULL(pp.ProgramParticipationEndDate, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE))
				GROUP BY e.Student_Identifier_State 
				HAVING SUM(CAST(DurationOfDisciplinaryAction AS DECIMAL(6, 3))) >= 0.5)
		AND sppse.IDEAEducationalEnvironmentForSchoolAge <> 'PPPS'
		AND PrimaryDisabilityType IS NOT NULL 
		AND (sd.DisciplineMethodOfCwd IS NOT NULL
			or sd.DisciplinaryActionTaken IN ('03086', '03087')
			or sd.IdeaInterimRemovalReason IS NOT NULL
            or sd.IdeaInterimRemoval IS NOT NULL )
        --Discipline Date within Enrollment range
        AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
            BETWEEN ske.EnrollmentEntryDate 
            AND ISNULL(ske.EnrollmentExitDate, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE))
        --Discipline Date with SY range 
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE) 
			AND CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)
			
	-- Gather, evaluate & record the results
		/* Test Case 1:
			CSA at the SEA level
		*/
		SELECT 
			  PrimaryDisabilityType
			, COUNT(*) AS StudentCount
		INTO #STC01
		FROM #C143staging 
		GROUP BY PrimaryDisabilityType
		
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
			,'CSA SEA Match All - Disability Type: ' + s.PrimaryDisabilityType
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #STC01 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'C143' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSA'
	

		DROP TABLE #STC01



		/* Test Case 2:
			CSB at the SEA level
		*/
		SELECT 
			  RaceEdFactsCode
			, COUNT(*) AS StudentCount
		INTO #STC02
		FROM #C143staging 
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
			,'CSB SEA Match All'
			,'CSB SEA Match All - Race: ' + CAST(s.RaceEdFactsCode AS VARCHAR(3)) 
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #STC02 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.RaceEdFactsCode = rreksd.RACE
			AND rreksd.ReportCode = 'C143' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSB'

		DROP TABLE #STC02



		/* Test Case 3:
			CSC at the SEA level
		*/
		SELECT 
			  SexEdFactsCode
			, COUNT(*) AS StudentCount
		INTO #STC03
		FROM #C143staging 
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
			,'CSC SEA Match All'
			,'CSC SEA Match All - Sex: ' + CAST(s.SexEdFactsCode AS VARCHAR(10)) 
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #STC03 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'C143' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSC'

		DROP TABLE #STC03

	
		/* Test Case 4:
			CSD at the SEA level
		*/
		SELECT 
			  EnglishLearnerStatusEdFactsCode
			, COUNT(*) AS StudentCount
		INTO #STC04
		FROM #C143staging
		WHERE EnglishLearnerStatusEdFactsCode in ('LEP','NLEP')
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
			,'CSD SEA Match All'
			,'CSD SEA Match All - EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(4)) 
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #STC04 s
		LEFT  JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
			AND rreksd.ReportCode = 'C143' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSD'
			
		DROP TABLE #STC04



			/* Test Case 5:
			ST1 at the SEA level
		*/
		SELECT 
			COUNT(*) AS StudentCount
		INTO #STC05
		FROM #C143staging 
		
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
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #STC05 s
		LEFT  JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON rreksd.ReportCode = 'C143' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'TOT'
			
		DROP TABLE #STC05



		----------------------------------------
		--- LEA level tests					 ---
		----------------------------------------
		-- Gather, evaluate & record the results
		/* Test Case 1:
			CSA at the LEA level
		*/
		SELECT 
			  PrimaryDisabilityType
			, LEA_Identifier_State
			, COUNT(*) AS StudentCount
		INTO #LTC01
		FROM #C143staging 
		GROUP BY LEA_Identifier_State
			, PrimaryDisabilityType
		

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
			,'CSA LEA Match All - LEA_Identifier_State: ' + s.LEA_Identifier_State 
								+ '; Disability Type: ' + s.PrimaryDisabilityType
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LTC01 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'C143' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSA'


		DROP TABLE #LTC01


				-- Gather, evaluate & record the results

/* Test Case 2:
			CSB at the LEA level
		*/
		SELECT 
			  RaceEdFactsCode
			, LEA_Identifier_State
			, COUNT(*) AS StudentCount
		INTO #LTC02
		FROM #C143staging 
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
			,'CSB LEA Match All'
			,'CSB LEA Match All - LEA_Identifier_State: ' + s.LEA_Identifier_State 
								+ '; Race: ' + CAST(s.RaceEdFactsCode AS VARCHAR(3))  
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LTC02 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
			ON s.RaceEdFactsCode = rreksd.RACE
			AND s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND rreksd.ReportCode = 'C143' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSB'

		DROP TABLE #LTC02


/* Test Case 3:
			CSC at the LEA level
		*/
		SELECT 
			  SexEdFactsCode
			, LEA_Identifier_State
			, COUNT(*) AS StudentCount
		INTO #LTC03
		FROM #C143staging 
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
			,'CSC LEA Match All'
			,'CSC LEA Match All - LEA_Identifier_State: ' + s.LEA_Identifier_State 
								+ '; Sex: ' + CAST(s.SexEdFactsCode AS VARCHAR(10)) 
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LTC03 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
			ON s.SexEdFactsCode = rreksd.SEX
			AND s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND rreksd.ReportCode = 'C143' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSC'

		DROP TABLE #LTC03



		/* Test Case 4:
			CSD at the LEA level
		*/
		SELECT 
			 EnglishLearnerStatusEdFactsCode
			, LEA_Identifier_State
			, COUNT(*) AS StudentCount
		INTO #LTC04
		FROM #C143staging
		WHERE EnglishLearnerStatusEdFactsCode in ('LEP','NLEP')
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
			,'CSD LEA Match All'
			,'CSD LEA Match All - LEA_Identifier_State: ' + s.LEA_Identifier_State 
								+ '; EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(4)) 								
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LTC04 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
			ON s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
			AND s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND rreksd.ReportCode = 'C143' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSD'
			
		DROP TABLE #LTC04


		/* Test Case 5:
			TOT at the LEA level
		*/
		SELECT 
			  LEA_Identifier_State
			, COUNT(*) AS StudentCount
		INTO #LTC05
		FROM #C143staging 
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
			,'TOT LEA Match All - LEA_Identifier_State: ' + s.LEA_Identifier_State 
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #LTC05 s
		LEFT  JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND rreksd.ReportCode = 'C143' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'TOT'
			
		DROP TABLE #LTC05


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

	--clear the tables for the next run
	--DROP TABLE IF EXISTS #C143Staging
	--DROP TABLE IF EXISTS #STC01
	--DROP TABLE IF EXISTS #STC02
	--DROP TABLE IF EXISTS #STC03
	--DROP TABLE IF EXISTS #STC04
	--DROP TABLE IF EXISTS #STC05
	--DROP TABLE IF EXISTS #LTC01
	--DROP TABLE IF EXISTS #LTC02
	--DROP TABLE IF EXISTS #LTC03
	--DROP TABLE IF EXISTS #LTC04
	--DROP TABLE IF EXISTS #LTC05

	IF OBJECT_ID('tempdb..#C143Staging') IS NOT NULL
		DROP TABLE #C143Staging

		IF OBJECT_ID('tempdb..#STC01') IS NOT NULL
		DROP TABLE #STC01

		IF OBJECT_ID('tempdb..#STC02') IS NOT NULL
		DROP TABLE #STC02

		IF OBJECT_ID('tempdb..#STC03') IS NOT NULL
		DROP TABLE #STC03

		IF OBJECT_ID('tempdb..#STC04') IS NOT NULL
		DROP TABLE #STC04

		IF OBJECT_ID('tempdb..#STC05') IS NOT NULL
		DROP TABLE #STC05

		IF OBJECT_ID('tempdb..#LTC01') IS NOT NULL
		DROP TABLE #LTC01

		IF OBJECT_ID('tempdb..#LTC02') IS NOT NULL
		DROP TABLE #LTC02

		IF OBJECT_ID('tempdb..#LTC03') IS NOT NULL
		DROP TABLE #LTC03

		IF OBJECT_ID('tempdb..#LTC04') IS NOT NULL
		DROP TABLE #LTC04

		IF OBJECT_ID('tempdb..#LTC05') IS NOT NULL
		DROP TABLE #LTC05

END