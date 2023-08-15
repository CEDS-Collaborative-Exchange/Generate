CREATE PROCEDURE [App].[FS088_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

BEGIN TRY
	BEGIN TRANSACTION

		--clear the temp tables for the next run
		--DROP TABLE IF EXISTS #C088Staging
		--DROP TABLE IF EXISTS #TC1
		--DROP TABLE IF EXISTS #TC2
		--DROP TABLE IF EXISTS #TC3
		--DROP TABLE IF EXISTS #TC4
		--DROP TABLE IF EXISTS #TC5
		--DROP TABLE IF EXISTS #TC6
		--DROP TABLE IF EXISTS #TC7
		--DROP TABLE IF EXISTS #TC8
		--DROP TABLE IF EXISTS #TC9
		--DROP TABLE IF EXISTS #TC10
		--DROP TABLE IF EXISTS #TC11
		--DROP TABLE IF EXISTS #TC12

		IF OBJECT_ID('tempdb..#C088Staging') IS NOT NULL
		DROP TABLE #C088Staging

		IF OBJECT_ID('tempdb..#TC1') IS NOT NULL
		DROP TABLE #TC1

		IF OBJECT_ID('tempdb..#TC2') IS NOT NULL
		DROP TABLE #TC2

		IF OBJECT_ID('tempdb..#TC3') IS NOT NULL
		DROP TABLE #TC3

		IF OBJECT_ID('tempdb..#TC4') IS NOT NULL
		DROP TABLE #TC4

		IF OBJECT_ID('tempdb..#TC5') IS NOT NULL
		DROP TABLE #TC5

		IF OBJECT_ID('tempdb..#TC6') IS NOT NULL
		DROP TABLE #TC6

		IF OBJECT_ID('tempdb..#TC7') IS NOT NULL
		DROP TABLE #TC7

		IF OBJECT_ID('tempdb..#TC8') IS NOT NULL
		DROP TABLE #TC8

		IF OBJECT_ID('tempdb..#TC9') IS NOT NULL
		DROP TABLE #TC9

		IF OBJECT_ID('tempdb..#TC10') IS NOT NULL
		DROP TABLE #TC10

		IF OBJECT_ID('tempdb..#TC11') IS NOT NULL
		DROP TABLE #TC11

		IF OBJECT_ID('tempdb..#TC12') IS NOT NULL
		DROP TABLE #TC12


		-- Define the test
		DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS088_UnitTestCase') 
		BEGIN
			SET @expectedResult = 1
			INSERT INTO App.SqlUnitTest (
				  [UnitTestName]
				, [StoredProcedureName]
				, [TestScope]
				, [IsActive]
			)
			VALUES (
				'FS088_UnitTestCase'
				, 'FS088_TestCase'				
				, 'FS088'
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
			WHERE UnitTestName = 'FS088_UnitTestCase'
		END

		-- Clear out last run
		DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
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
								ELSE 'NLEP'
							END
				ELSE 'NLEP'
			  END AS EnglishLearnerStatusEdFactsCode
			, sd.IdeaInterimRemoval
			, sd.DisciplineMethodOfCwd AS DisciplineMethod
			, sd.DurationOfDisciplinaryAction
			, '         ' as RemovalLength
			, '         ' as LEPRemovalLength
		INTO #C088Staging
		FROM Staging.K12Enrollment ske
		JOIN Staging.Discipline sd
			ON sd.Student_Identifier_State = ske.Student_Identifier_State
			AND ISNULL(sd.LEA_Identifier_State, '') = ISNULL(ske.LEA_Identifier_State, '')
			AND ISNULL(sd.School_Identifier_State, '') = ISNULL(ske.School_Identifier_State, '')
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
			AND sppse.IDEAEducationalEnvironmentForSchoolAge <> 'PPPS'
			AND ISNULL(sd.DisciplineMethodOfCwd, '') in ('InSchool','OutOfSchool')
			AND rds.Get_Age(ske.Birthdate, DATEFROMPARTS(CASE WHEN @cutOffMonth >= 7 THEN @SchoolYear - 1 
															ELSE @SchoolYear 
														END, @cutOffMonth, @cutOffDay)
							) BETWEEN 3 AND 21	
			--Discipline Date within Enrollment range
			AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
				BETWEEN ske.EnrollmentEntryDate 
					AND ISNULL(ske.EnrollmentExitDate, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE))
			--Discipline Date with SY range 
			AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
				BETWEEN CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE) 
					AND CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)

		--Set the EDFacts value for removal length
		UPDATE s
		SET s.RemovalLength = tmp.RemovalLength
		FROM #C088Staging s
			INNER JOIN (
					SELECT Student_Identifier_State
						,CASE 
							WHEN sum(cast(DurationOfDisciplinaryAction as float)) >= 0.5 
								and sum(cast(DurationOfDisciplinaryAction as float)) < 1.5 THEN 'LTOREQ1'
							WHEN sum(cast(DurationOfDisciplinaryAction as float)) >= 1.5 
								and sum(cast(DurationOfDisciplinaryAction as float)) <= 10 THEN '2TO10'
							WHEN sum(cast(DurationOfDisciplinaryAction as float)) > 10 THEN 'GREATER10'
							ELSE 'MISSING'
						END AS RemovalLength
					FROM #C088Staging 
					GROUP BY Student_Identifier_State
			) tmp
			   ON s.Student_Identifier_State =  tmp.Student_Identifier_State

		--Set the EDFacts value for removal length for the LEP status
		UPDATE s
		SET s.LEPRemovalLength = tmp.LEPRemovalLength
		FROM #C088Staging s
			INNER JOIN (
					SELECT Student_Identifier_State, EnglishLearnerStatusEdFactsCode
						,CASE 
							WHEN sum(cast(DurationOfDisciplinaryAction as float)) >= 0.5 
								and sum(cast(DurationOfDisciplinaryAction as float)) < 1.5 THEN 'LTOREQ1'
							WHEN sum(cast(DurationOfDisciplinaryAction as float)) >= 1.5 
								and sum(cast(DurationOfDisciplinaryAction as float)) <= 10 THEN '2TO10'
							WHEN sum(cast(DurationOfDisciplinaryAction as float)) > 10 THEN 'GREATER10'
							ELSE 'MISSING'
						END AS LEPRemovalLength
					FROM #C088Staging 
					GROUP BY Student_Identifier_State, EnglishLearnerStatusEdFactsCode
			) tmp
			   ON s.Student_Identifier_State = tmp.Student_Identifier_State
			   AND s.EnglishLearnerStatusEdFactsCode = tmp.EnglishLearnerStatusEdFactsCode

	-- Gather, evaluate & record the results
		/* Test Case 1:
			CSA at the SEA level - Student Count by Removal Length (IDEA) by Disability Category (IDEA)
		*/
		SELECT 
			RemovalLength
			, PrimaryDisabilityType
			, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC1
		FROM #C088Staging 
		GROUP BY RemovalLength
			, PrimaryDisabilityType

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
			,'CSA SEA Match All'
			,'CSA SEA Match All - RemovalLength: ' + s.RemovalLength 
				+ '; Disability Type: ' + s.PrimaryDisabilityType
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC1 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
			ON s.RemovalLength = rreksd.RemovalLength
			AND s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'C088' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSA'
	
		DROP TABLE #TC1

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSA SEA Match All' 
		--AND t.TestScope = 'FS088'
		--AND Passed = 0

		-- Gather, evaluate & record the results
		/* Test Case 2:
			CSB at the SEA level - Student Count by Removal Length (IDEA) by Racial Ethnic
		*/
		SELECT 
			RemovalLength
			, RaceEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC2
		FROM #C088Staging 
		GROUP BY RemovalLength
			, RaceEdFactsCode

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
			,'CSB SEA Match All'
			,'CSB SEA Match All - RemovalLength: ' + s.RemovalLength 
				+ '; Race: ' + s.RaceEdFactsCode
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC2 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.RemovalLength = rreksd.RemovalLength
			AND s.RaceEdFactsCode = rreksd.Race
			AND rreksd.ReportCode = 'C088' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSB'
	
		DROP TABLE #TC2

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSB SEA Match All' 
		--AND t.TestScope = 'FS088'
		--AND Passed = 0

		
		/* Test Case 3:
			CSC at the SEA level - Student Count by Removal Length (IDEA) by Sex (Membership)
		*/
		SELECT 
			RemovalLength
			, SexEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC3
		FROM #C088Staging 
		GROUP BY RemovalLength
			, SexEdFactsCode

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
			,'CSC SEA Match All'
			,'CSC SEA Match All - RemovalLength: ' + s.RemovalLength 
				+ '; Sex: ' + s.SexEdFactsCode
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC3 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.RemovalLength = rreksd.RemovalLength
			AND s.SexEdFactsCode = rreksd.Sex
			AND rreksd.ReportCode = 'C088' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSC'
	
		DROP TABLE #TC3

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSC SEA Match All' 
		--AND t.TestScope = 'FS088'
		--AND Passed = 0

		
		/* Test Case 4:
			CSD at the SEA level - Student Count by Removal Length (IDEA) by English Learner Status (Both)
		*/
		SELECT 
			LEPRemovalLength
			, EnglishLearnerStatusEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC4
		FROM #C088Staging 
		GROUP BY LEPRemovalLength
			, EnglishLearnerStatusEdFactsCode

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
			,'CSD SEA Match All'
			,'CSD SEA Match All - RemovalLength: ' + s.LEPRemovalLength 
				+ '; English Learner: ' + s.EnglishLearnerStatusEdFactsCode
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC4 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.LEPRemovalLength = rreksd.RemovalLength
			AND s.EnglishLearnerStatusEdFactsCode = rreksd.EnglishLearnerStatus
			AND rreksd.ReportCode = 'C088' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSD'
	
		DROP TABLE #TC4

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSD SEA Match All' 
		--AND t.TestScope = 'FS088'
		--AND Passed = 0


		/* Test Case 5:
			ST1 at the SEA level - Student Count by Removal Length (IDEA)
		*/
		SELECT 
			RemovalLength
			, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC5
		FROM #C088Staging 
		GROUP BY RemovalLength

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
			,'ST1 SEA Match All'
			,'ST1 SEA Match All - RemovalLength: ' + s.RemovalLength 
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC5 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.RemovalLength = rreksd.RemovalLength
			AND rreksd.ReportCode = 'C088' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST1'
	
		DROP TABLE #TC5

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'ST1 SEA Match All' 
		--AND t.TestScope = 'FS088'
		--AND Passed = 0
		

		/* Test Case 6:
			TOT at the SEA level
		*/
		SELECT 
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC6
		FROM #C088Staging 
		WHERE RemovalLength <> 'MISSING'
		
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
		FROM #TC6 s
		LEFT  JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
			ON rreksd.ReportCode = 'C088' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'TOT'
			
		DROP TABLE #TC6

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'TOT SEA Match All' 
		--AND t.TestScope = 'FS088'
		--AND Passed = 0

		----------------------------------------
		--- LEA level tests					 ---
		----------------------------------------
		-- Gather, evaluate & record the results
		/* Test Case 7:
			CSA at the LEA level - Student Count by Removal Length (IDEA) by Disability Category (IDEA)
		*/
		SELECT 
			LEA_Identifier_State
			, RemovalLength
			, PrimaryDisabilityType
			, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC7
		FROM #C088Staging 
		GROUP BY LEA_Identifier_State
			, RemovalLength
			, PrimaryDisabilityType

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
			,'CSA LEA Match All'
			,'CSA LEA Match All - LEA Identifier - ' + s.LEA_Identifier_State
				+ '; RemovalLength: ' + s.RemovalLength 
				+ '; Disability Type: ' + s.PrimaryDisabilityType
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC7 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.RemovalLength = rreksd.RemovalLength
			AND s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'C088' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSA'
	
		DROP TABLE #TC7

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSA LEA Match All' 
		--AND t.TestScope = 'FS088'
		--AND Passed = 0

				-- Gather, evaluate & record the results
		/* Test Case 8:
			CSB at the LEA level - Student Count by Removal Length (IDEA) by Racial Ethnic
		*/
		SELECT 
			LEA_Identifier_State
			, RemovalLength
			, RaceEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC8
		FROM #C088Staging 
		GROUP BY LEA_Identifier_State
			, RemovalLength
			, RaceEdFactsCode

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
			,'CSB LEA Match All'
			,'CSB LEA Match All - LEA Identifier - ' + s.LEA_Identifier_State
				+ '; RemovalLength: ' + s.RemovalLength 
				+ '; Race: ' + s.RaceEdFactsCode
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC8 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.RemovalLength = rreksd.RemovalLength
			AND s.RaceEdFactsCode = rreksd.Race
			AND rreksd.ReportCode = 'C088' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSB'
	
		DROP TABLE #TC8

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSB LEA Match All' 
		--AND t.TestScope = 'FS088'
		--AND Passed = 0

		
		/* Test Case 9:
			CSC at the LEA level - Student Count by Removal Length (IDEA) by Sex (Membership)
		*/
		SELECT 
			LEA_Identifier_State
			, RemovalLength
			, SexEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC9
		FROM #C088Staging 
		GROUP BY LEA_Identifier_State
			, RemovalLength
			, SexEdFactsCode

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
			,'CSC LEA Match All'
			,'CSC LEA Match All - LEA Identifier - ' + s.LEA_Identifier_State
				+ '; RemovalLength: ' + s.RemovalLength 
				+ '; Sex: ' + s.SexEdFactsCode
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC9 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.RemovalLength = rreksd.RemovalLength
			AND s.SexEdFactsCode = rreksd.Sex
			AND rreksd.ReportCode = 'C088' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSC'
	
		DROP TABLE #TC9

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSC LEA Match All' 
		--AND t.TestScope = 'FS088'
		--AND Passed = 0

		
		/* Test Case 10:
			CSD at the LEA level - Student Count by Removal Length (IDEA) by English Learner Status (Both)
		*/
		SELECT 
			LEA_Identifier_State
			, LEPRemovalLength
			, EnglishLearnerStatusEdFactsCode
			, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC10
		FROM #C088Staging 
		GROUP BY LEA_Identifier_State
			, LEPRemovalLength
			, EnglishLearnerStatusEdFactsCode

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
			,'CSD LEA Match All'
			,'CSD LEA Match All - LEA Identifier - ' + s.LEA_Identifier_State
				+ '; RemovalLength: ' + s.LEPRemovalLength 
				+ '; English Learner: ' + s.EnglishLearnerStatusEdFactsCode
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC10 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.LEPRemovalLength = rreksd.RemovalLength
			AND s.EnglishLearnerStatusEdFactsCode = rreksd.EnglishLearnerStatus
			AND rreksd.ReportCode = 'C088' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSD'
	
		DROP TABLE #TC10

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSD LEA Match All' 
		--AND t.TestScope = 'FS088'
		--AND Passed = 0


		/* Test Case 11:
			ST1 at the LEA level - Student Count by Removal Length (IDEA)
		*/
		SELECT 
			LEA_Identifier_State
			, RemovalLength
			, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC11
		FROM #C088Staging 
		GROUP BY LEA_Identifier_State
			, RemovalLength

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
			,'ST1 LEA Match All'
			,'ST1 LEA Match All - LEA Identifier - ' + s.LEA_Identifier_State
				+ '; RemovalLength: ' + s.RemovalLength 
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC11 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.RemovalLength = rreksd.RemovalLength
			AND rreksd.ReportCode = 'C088' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST1'
	
		DROP TABLE #TC11

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'ST1 LEA Match All' 
		--AND t.TestScope = 'FS088'
		--AND Passed = 0
		

		/* Test Case 12:
			TOT at the LEA level
		*/
		SELECT 
			LEA_Identifier_State
			, COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #TC12
		FROM #C088Staging 
		WHERE RemovalLength <> 'MISSING'
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
			,'TOT LEA Match All - LEA Identifier - ' + s.LEA_Identifier_State
			,s.StudentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC12 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND rreksd.ReportCode = 'C088' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'TOT'
			
		DROP TABLE #TC12

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'TOT LEA Match All' 
		--AND t.TestScope = 'FS088'
		--AND Passed = 0



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
