CREATE PROCEDURE [App].[FS007_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

BEGIN TRY
	BEGIN TRANSACTION

		--declare	@SchoolYear SMALLINT = 2021

		--clear the tables for the next run
		--DROP TABLE IF EXISTS #Staging
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

		IF OBJECT_ID('tempdb..#Staging') IS NOT NULL
		DROP TABLE #Staging

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
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS007_UnitTestCase') 
		BEGIN
			SET @expectedResult = 1
			INSERT INTO App.SqlUnitTest (
				  [UnitTestName]
				, [StoredProcedureName]
				, [TestScope]
				, [IsActive]
			)
			VALUES (
				'FS007_UnitTestCase'
				, 'FS007_TestCase'				
				, 'FS007'
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
			WHERE UnitTestName = 'FS007_UnitTestCase'
		END

		-- Clear out last run
		DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
		-- Create base data set

		-- Get Custom Child Count Date

		--DROP TABLE IF EXISTS #staging 

		IF OBJECT_ID('tempdb..#staging') IS NOT NULL
		DROP TABLE #staging

		
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





		SELECT DISTINCT 
			ske.Student_Identifier_State
			, ske.LEA_Identifier_State
			, ske.School_Identifier_State
			, sppse.ProgramParticipationEndDate
			, ske.Birthdate
			--, [RDS].[Get_Age](ske.BirthDate, DATEADD(year, -1, cast(sd.DisciplinaryActionStartDate as varchar(10)))) Age
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
								WHEN ISNULL(EnglishLearnerStatus, 0) = 0 THEN 'NLEP'
								ELSE 'NLEP'
							END
				ELSE 'NLEP'
			  END AS EnglishLearnerStatusEdFactsCode
			, sd.IncidentIdentifier
			, sd.DisciplinaryActionTaken
			, sd.IdeaInterimRemoval
			, CASE sd.IdeaInterimRemoval
				WHEN 'REMDW' THEN 'REMDW'
				WHEN 'REMHO' THEN 'REMHO'
				ELSE 'MISSING'
			END AS IdeaInterimRemovalEdFactsCode
			, sd.IdeaInterimRemovalReason
			, CASE sd.IdeaInterimRemovalReason
				WHEN 'Drugs' THEN 'D'
				WHEN 'Weapons' THEN 'W'
				WHEN 'SeriousBodilyInjury' THEN 'SBI'
				ELSE 'MISSING'
			END as IdeaInterimRemovalReasonEdFactsCode
			, convert(int, round(cast(sd.DurationOfDisciplinaryAction as decimal(5,2)),0,0)) DurationOfDisciplinaryAction
		INTO #staging
		FROM Staging.K12Enrollment ske
		JOIN Staging.PersonStatus sps
			ON sps.Student_Identifier_State = ske.Student_Identifier_State
			AND sps.LEA_Identifier_State = ske.LEA_Identifier_State
			AND sps.School_Identifier_State = ske.School_Identifier_State
		JOIN Staging.ProgramParticipationSpecialEducation sppse
			ON sppse.Student_Identifier_State = ske.Student_Identifier_State
			AND sppse.LEA_Identifier_State = ske.LEA_Identifier_State
			AND sppse.School_Identifier_State = ske.School_Identifier_State
		JOIN Staging.Discipline sd
			ON sd.Student_Identifier_State = sppse.Student_Identifier_State
			AND sd.LEA_Identifier_State = sppse.LEA_Identifier_State
			AND sd.School_Identifier_State = sppse.School_Identifier_State
		LEFT JOIN Staging.PersonRace spr
			ON spr.Student_Identifier_State = ske.Student_Identifier_State
			AND spr.SchoolYear = ske.SchoolYear
			AND ISNULL(sppse.ProgramParticipationEndDate, spr.RecordStartDateTime) BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, GETDATE())
		left JOIN RDS.DimRaces rdr
			ON (ske.HispanicLatinoEthnicity = 1 and rdr.RaceEdFactsCode = 'HI7')
				OR (ske.HispanicLatinoEthnicity = 0 AND spr.RaceType = rdr.RaceCode)
		--JOIN RDS.DimIdeaStatuses rdis
		--	ON sps.PrimaryDisabilityType = rdis.PrimaryDisabilityTypeCode
		WHERE sps.IDEAIndicator = 1
			AND ske.Schoolyear = CAST(@SchoolYear as varchar)
			AND sppse.IDEAEducationalEnvironmentForSchoolAge <> 'PPPS'
--			AND ske.GradeLevel in ('KG', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
			AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') between sps.IDEA_StatusStartDate and ISNULL (sps.IDEA_StatusEndDate, GETDATE ())
			AND rds.Get_Age(ske.Birthdate, DATEFROMPARTS(CASE WHEN @cutOffMonth >= 7 THEN @SchoolYear - 1 
															ELSE @SchoolYear 
														END, @cutOffMonth, @cutOffDay)
							) BETWEEN 3 AND 21	
			AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') between ske.EnrollmentEntryDate and ISNULL(ske.EnrollmentExitDate, GETDATE())
			AND sd.IdeaInterimRemoval = 'REMDW' 
			and sd.Student_Identifier_State NOT IN (SELECT Student_Identifier_State FROM Staging.Discipline sd
			 GROUP BY Student_Identifier_State, sd.IdeaInterimRemoval, IdeaInterimRemovalReason HAVING convert(int, sum(round(cast(sd.DurationOfDisciplinaryAction as decimal(5,2)),0,0))) > 45) 




		--select * from #staging

		--DELETE FROM #staging
		--WHERE Age NOT BETWEEN 3 AND 21
			
		-- Gather, evaluate & record the results
		/* Test Case 1:
			CSA at the SEA level - Student Count by Interim Removal Reason (IDEA) by Disability Category (IDEA)
		*/
		SELECT 
			IdeaInterimRemovalReasonEdFactsCode
			, PrimaryDisabilityType
		, COUNT(DISTINCT IncidentIdentifier) AS IncidentCount
		INTO #TC1
		FROM #staging 
		GROUP BY IdeaInterimRemovalReasonEdFactsCode
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
			,'CSA SEA Match All - IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
				+ '; Disability Type: ' + s.PrimaryDisabilityType
			,s.IncidentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC1 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAINTERIMREMOVALREASON
			AND s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'C007' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSA'
	
		DROP TABLE #TC1

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSA SEA Match All' 
		--AND t.TestScope = 'FS007'
		--AND Passed = 0

		-- Gather, evaluate & record the results
		/* Test Case 2:
			CSB at the SEA level - Student Count by Interim Removal Reason (IDEA) by Racial Ethnic
		*/
		SELECT 
			IdeaInterimRemovalReasonEdFactsCode
			, RaceEdFactsCode
			, COUNT(DISTINCT IncidentIdentifier) AS IncidentCount
		INTO #TC2
		FROM #staging 
		GROUP BY IdeaInterimRemovalReasonEdFactsCode
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
			,'CSB SEA Match All - IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
				+ '; Race: ' + s.RaceEdFactsCode
			,s.IncidentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC2 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
			AND s.RaceEdFactsCode = rreksd.Race
			AND rreksd.ReportCode = 'C007' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSB'
	
		DROP TABLE #TC2

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSB SEA Match All' 
		--AND t.TestScope = 'FS007'
		--AND Passed = 0

		
		/* Test Case 3:
			CSC at the SEA level - Student Count by Interim Removal Reason (IDEA) by Sex (Membership)
		*/
		SELECT 
			IdeaInterimRemovalReasonEdFactsCode
			, SexEdFactsCode
			, COUNT(DISTINCT IncidentIdentifier) AS IncidentCount
		INTO #TC3
		FROM #staging 
		GROUP BY IdeaInterimRemovalReasonEdFactsCode
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
			,'CSC SEA Match All - IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
				+ '; Sex: ' + s.SexEdFactsCode
			,s.IncidentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC3 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
			AND s.SexEdFactsCode = rreksd.Sex
			AND rreksd.ReportCode = 'C007' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSC'
	
		DROP TABLE #TC3

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSC SEA Match All' 
		--AND t.TestScope = 'FS007'
		--AND Passed = 0

		
		/* Test Case 4:
			CSD at the SEA level - Student Count by Interim Removal Reason (IDEA) by English Learner Status (Both)
		*/
		SELECT 
			IdeaInterimRemovalReasonEdFactsCode
			, EnglishLearnerStatusEdFactsCode
			, COUNT(DISTINCT IncidentIdentifier) AS IncidentCount
		INTO #TC4
		FROM #staging 
		GROUP BY IdeaInterimRemovalReasonEdFactsCode
			,  EnglishLearnerStatusEdFactsCode

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
			,'CSD SEA Match All - IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
				+ '; English Learner: ' + s.EnglishLearnerStatusEdFactsCode
			,s.IncidentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC4 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
			AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
			AND rreksd.ReportCode = 'C007' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSD'
	
		DROP TABLE #TC4

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSD SEA Match All' 
		--AND t.TestScope = 'FS007'
		--AND Passed = 0


		/* Test Case 5:
			ST1 at the SEA level - Student Count by Interim Removal Reason (IDEA)
		*/
		SELECT 
			IdeaInterimRemovalReasonEdFactsCode
			, COUNT(DISTINCT IncidentIdentifier) AS IncidentCount
		INTO #TC5
		FROM #staging 
		GROUP BY IdeaInterimRemovalReasonEdFactsCode

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
			,'ST1 SEA Match All - IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			,s.IncidentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC5 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
			AND rreksd.ReportCode = 'C007' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST1'
	
		DROP TABLE #TC5

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'ST1 SEA Match All' 
		--AND t.TestScope = 'FS007'
		--AND Passed = 0
		

		
		----------------------------------------
		--- LEA level tests					 ---
		----------------------------------------
		-- Gather, evaluate & record the results
		/* Test Case 7:
			CSA at the LEA level - Student Count by Interim Removal Reason (IDEA) by Disability Category (IDEA)
		*/
		SELECT 
			LEA_Identifier_State
			, IdeaInterimRemovalReasonEdFactsCode
			, PrimaryDisabilityType
			, COUNT(DISTINCT IncidentIdentifier) AS IncidentCount
		INTO #TC7
		FROM #staging 
		GROUP BY LEA_Identifier_State
			, IdeaInterimRemovalReasonEdFactsCode
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
				+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
				+ '; Disability Type: ' + s.PrimaryDisabilityType
			,s.IncidentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC7 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAINTERIMREMOVALREASON
			AND s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'C007' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSA'
	
		DROP TABLE #TC7

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSA LEA Match All' 
		--AND t.TestScope = 'FS007'
		--AND Passed = 0

				-- Gather, evaluate & record the results
		/* Test Case 8:
			CSB at the LEA level - Student Count by Interim Removal Reason (IDEA) by Racial Ethnic
		*/
		SELECT 
			LEA_Identifier_State
			, IdeaInterimRemovalReasonEdFactsCode
			, RaceEdFactsCode
			, COUNT(DISTINCT IncidentIdentifier) AS IncidentCount
		INTO #TC8
		FROM #staging 
		GROUP BY LEA_Identifier_State
			, IdeaInterimRemovalReasonEdFactsCode
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
				+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
				+ '; Race: ' + s.RaceEdFactsCode
			,s.IncidentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC8 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
			AND s.RaceEdFactsCode = rreksd.Race
			AND rreksd.ReportCode = 'C007' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSB'
	
		DROP TABLE #TC8

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSB LEA Match All' 
		--AND t.TestScope = 'FS007'
		--AND Passed = 0

		
		/* Test Case 9:
			CSC at the SEA level - Student Count by Interim Removal Reason (IDEA) by Sex (Membership)
		*/
		SELECT 
			LEA_Identifier_State
			, IdeaInterimRemovalReasonEdFactsCode
			, SexEdFactsCode
			, COUNT(DISTINCT IncidentIdentifier) AS IncidentCount
		INTO #TC9
		FROM #staging 
		GROUP BY LEA_Identifier_State
			, IdeaInterimRemovalReasonEdFactsCode
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
				+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
				+ '; Sex: ' + s.SexEdFactsCode
			,s.IncidentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC9 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
			AND s.SexEdFactsCode = rreksd.Sex
			AND rreksd.ReportCode = 'C007' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSC'
	
		DROP TABLE #TC9

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSC LEA Match All' 
		--AND t.TestScope = 'FS007'
		--AND Passed = 0

		
		/* Test Case 10:
			CSD at the LEA level - Student Count by Interim Removal Reason (IDEA) by English Learner Status (Both)
		*/
		SELECT 
			LEA_Identifier_State
			, IdeaInterimRemovalReasonEdFactsCode
			, EnglishLearnerStatusEdFactsCode
			, COUNT(DISTINCT IncidentIdentifier) AS IncidentCount
		INTO #TC10
		FROM #staging 
		GROUP BY LEA_Identifier_State
			, IdeaInterimRemovalReasonEdFactsCode
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
				+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
				+ '; English Learner: ' + s.EnglishLearnerStatusEdFactsCode
			,s.IncidentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC10 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
			AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
			AND rreksd.ReportCode = 'C007' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSD'
	
		DROP TABLE #TC10

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'CSD LEA Match All' 
		--AND t.TestScope = 'FS007'
		--AND Passed = 0


		/* Test Case 11:
			ST1 at the LEA level - Student Count by Interim Removal Reason (IDEA)
		*/
		SELECT 
			LEA_Identifier_State
			, IdeaInterimRemovalReasonEdFactsCode
			, COUNT(DISTINCT IncidentIdentifier) AS IncidentCount
		INTO #TC11
		FROM #staging 
		GROUP BY LEA_Identifier_State
			, IdeaInterimRemovalReasonEdFactsCode

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
				+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			,s.IncidentCount
			,rreksd.DisciplineCount
			,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #TC11 s
		LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
			AND rreksd.ReportCode = 'C007' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST1'
	
		DROP TABLE #TC11

		--select * 
		--from App.SqlUnitTestCaseResult r
		--	inner join App.SqlUnitTest t
		--		on r.SqlUnitTestId = t.SqlUnitTestId
		--WHERE TestCaseName = 'ST1 LEA Match All' 
		--AND t.TestScope = 'FS007'
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
