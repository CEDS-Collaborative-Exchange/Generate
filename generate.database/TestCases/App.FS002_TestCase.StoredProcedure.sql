/***********************************************************************
February 17, 2022
End to End Test for FS002
************************************************************************/

CREATE PROCEDURE [app].[FS002_TestCase] 
	@SchoolYear INT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C002Staging') IS NOT NULL
	DROP TABLE #C002Staging

	IF OBJECT_ID('tempdb..#S_CSA') IS NOT NULL
	DROP TABLE #S_CSA
	IF OBJECT_ID('tempdb..#S_CSB') IS NOT NULL
	DROP TABLE #S_CSB
	IF OBJECT_ID('tempdb..#S_CSC') IS NOT NULL
	DROP TABLE #S_CSC
	IF OBJECT_ID('tempdb..#S_CSD') IS NOT NULL
	DROP TABLE #S_CSD
	IF OBJECT_ID('tempdb..#S_CSE') IS NOT NULL
	DROP TABLE #S_CSE

	IF OBJECT_ID('tempdb..#L_CSA') IS NOT NULL
	DROP TABLE #L_CSA
	IF OBJECT_ID('tempdb..#L_CSB') IS NOT NULL
	DROP TABLE #L_CSB
	IF OBJECT_ID('tempdb..#L_CSC') IS NOT NULL
	DROP TABLE #L_CSC
	IF OBJECT_ID('tempdb..#L_CSD') IS NOT NULL
	DROP TABLE #L_CSD
	IF OBJECT_ID('tempdb..#L_CSE') IS NOT NULL
	DROP TABLE #L_CSE

	IF OBJECT_ID('tempdb..#S_TOT1') IS NOT NULL
	DROP TABLE #S_TOT1
	IF OBJECT_ID('tempdb..#S_TOT2') IS NOT NULL
	DROP TABLE #S_TOT2
	IF OBJECT_ID('tempdb..#S_TOT3') IS NOT NULL
	DROP TABLE #S_TOT3
	IF OBJECT_ID('tempdb..#S_TOT4') IS NOT NULL
	DROP TABLE #S_TOT4
	IF OBJECT_ID('tempdb..#S_TOT5') IS NOT NULL
	DROP TABLE #S_TOT5
	IF OBJECT_ID('tempdb..#S_TOT6') IS NOT NULL
	DROP TABLE #S_TOT6
	IF OBJECT_ID('tempdb..#S_TOT7') IS NOT NULL
	DROP TABLE #S_TOT7
	IF OBJECT_ID('tempdb..#S_TOT') IS NOT NULL
	DROP TABLE #S_TOT

	IF OBJECT_ID('tempdb..#L_TOT1') IS NOT NULL
	DROP TABLE #L_TOT1
	IF OBJECT_ID('tempdb..#L_TOT2') IS NOT NULL
	DROP TABLE #L_TOT2
	IF OBJECT_ID('tempdb..#L_TOT3') IS NOT NULL
	DROP TABLE #L_TOT3
	IF OBJECT_ID('tempdb..#L_TOT4') IS NOT NULL
	DROP TABLE #L_TOT4
	IF OBJECT_ID('tempdb..#L_TOT5') IS NOT NULL
	DROP TABLE #L_TOT5
	IF OBJECT_ID('tempdb..#L_TOT6') IS NOT NULL
	DROP TABLE #L_TOT6
	IF OBJECT_ID('tempdb..#L_TOT7') IS NOT NULL
	DROP TABLE #L_TOT7
	IF OBJECT_ID('tempdb..#L_TOT') IS NOT NULL
	DROP TABLE #L_TOT

	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT

	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS002_UnitTestCase') 
		BEGIN
			SET @expectedResult = 1
			INSERT INTO App.SqlUnitTest 
			(
				UnitTestName,
				StoredProcedureName,
				TestScope,
				IsActive
			)
			VALUES 
			(
				'FS002_UnitTestCase',
				'FS002_TestCase',
				'FS002',
				1
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


	-- Create test data if needed & doesn't exist (should be rerunnable, but don't insert duplicate records
	-- Get Custom Child Count Date
	DECLARE @cutOffMonth INT, @cutOffDay INT, @customFactTypeDate VARCHAR(10), @ChildCountDate date
	set @cutOffMonth = 11
	set @cutOffDay = 1

	select @customFactTypeDate = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CHDCTDTE'

	select @cutOffMonth = SUBSTRING(@customFactTypeDate, 0, CHARINDEX('/', @customFactTypeDate))
	select @cutOffDay = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)
	select @ChildCountDate = convert(varchar, @CutoffMonth) + '/' + convert(varchar, @CutoffDay) + '/' + convert(varchar, @SchoolYear-1) -- < changed to "-1"


--/***********************************************************

	 SELECT  
		ske.Student_Identifier_State,
		ske.LEA_Identifier_State,
		ske.School_Identifier_State,
		sppse.IDEAEducationalEnvironmentForSchoolAge,
		rda.AgeValue,
		ske.GradeLevel,
		idea.PrimaryDisabilityType,
		CASE 
			WHEN ske.HispanicLatinoEthnicity = 1 THEN 'HI7' 
			WHEN spr.RaceType = 'AmericanIndianorAlaskaNative' THEN 'AM7'
			WHEN spr.RaceType = 'Asian' THEN 'AS7'
			WHEN spr.RaceType = 'BlackorAfricanAmerican' THEN 'BL7'
			WHEN spr.RaceType = 'NativeHawaiianorOtherPacificIslander' THEN 'PI7'
			WHEN spr.RaceType = 'White' THEN 'WH7'
			WHEN spr.RaceType = 'TwoorMoreRaces' THEN 'MU7'
		END AS RaceEdFactsCode,
		CASE ske.Sex
				WHEN 'Male' THEN 'M'
				WHEN 'Female' THEN 'F'
				ELSE 'MISSING'
			  END AS SexEdFactsCode,
		CASE 
			WHEN ISNULL(el.EnglishLearnerStatus, '') <> '' 
				AND @ChildCountDate
					BETWEEN ISNULL(EL.EnglishLearner_StatusStartDate, CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE))  
					AND ISNULL(EL.EnglishLearner_StatusEndDate, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)) 
			THEN EL.EnglishLearnerStatus
			ELSE -1
		END AS EnglishLearnerStatus,
		CASE
			WHEN ISNULL(el.EnglishLearnerStatus, '') <> '' 
				AND @ChildCountDate
					BETWEEN ISNULL(EL.EnglishLearner_StatusStartDate, CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE))  
					AND ISNULL(EL.EnglishLearner_StatusEndDate, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)) 
			THEN 
				CASE 
					WHEN EL.EnglishLearnerStatus = 1 THEN 'LEP'
					ELSE 'NLEP'
				END
			ELSE 'MISSING'
		END AS EnglishLearnerStatusEdFactsCode

		INTO #c002Staging
		FROM Staging.K12Enrollment ske

		JOIN Staging.PersonStatus idea
			ON ske.Student_Identifier_State = idea.Student_Identifier_State
			AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(idea.Lea_Identifier_State, '')
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(idea.School_Identifier_State, '')
			AND @ChildCountDate BETWEEN idea.IDEA_StatusStartDate AND ISNULL(idea.IDEA_StatusEndDate, GETDATE())

		JOIN Staging.ProgramParticipationSpecialEducation sppse
			ON ske.Student_Identifier_State = sppse.Student_Identifier_State
			AND ISNULL(ske.LEA_Identifier_State, '') = ISNULL(sppse.LEA_Identifier_State, '') 
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(sppse.School_Identifier_State, '')
			AND @ChildCountDate BETWEEN sppse.ProgramParticipationBeginDate AND ISNULL(sppse.ProgramParticipationEndDate, GETDATE())
		
		LEFT JOIN Staging.PersonRace spr
			ON ske.SchoolYear = spr.SchoolYear
			AND ske.Student_Identifier_State = spr.Student_Identifier_State
			AND (spr.OrganizationType = 'SEA'
				OR (ske.LEA_Identifier_State = spr.OrganizationIdentifier
					AND spr.OrganizationType = 'LEA')
				OR (ske.School_Identifier_State = spr.OrganizationIdentifier
					AND spr.OrganizationType = 'K12School'))

		left JOIN Staging.PersonStatus el 
			ON ske.Student_Identifier_State = el.Student_Identifier_State
			AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(el.Lea_Identifier_State, '')
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(el.School_Identifier_State, '')
			AND @ChildCountDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())

		JOIN RDS.DimAges rda
			ON RDS.Get_Age(ske.Birthdate, @ChildCountDate) = rda.AgeValue

		WHERE @ChildCountDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())
		AND idea.IDEAIndicator  = 1
		and (rda.AgeValue BETWEEN 6 and 21
			OR (rda.AgeValue = 5
				AND ske.GradeLevel IS NOT NULL 
				AND ske.GradeLevel NOT IN ('PK')))

	-- Gather, evaluate & record the results

		/**********************************************************************
		Test Case 1:
		CSA at the SEA level
		Student Count by:
			RaceEdFactsCode
			SexEdFactsCode
			PrimaryDisabilityType
		***********************************************************************/
		SELECT
			RaceEdFactsCode,
			SexEdFactsCode,
			PrimaryDisabilityType,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_CSA
		FROM #c002staging 
		GROUP BY 
			RaceEdFactsCode,
			SexEdFactsCode,
			PrimaryDisabilityType

		
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
			,'CSA SEA'
			,'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  ' 
				+ 'Sex: ' + s.SexEdFactsCode+ '  '
				+ 'Disability Type: ' + s.PrimaryDisabilityType			
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSA s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.RaceEdFactsCode = rreksd.RACE			
			AND s.SexEdFactsCode = rreksd.SEX
			AND s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'C002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSA'

		DROP TABLE #S_CSA


		/**********************************************************************
		Test Case 2:
		CSA at the LEA level
		Student Count by:
			RaceEdFactsCode
			SexEdFactsCode
			PrimaryDisabilityType
		***********************************************************************/
		SELECT
			LEA_Identifier_State,
			RaceEdFactsCode,
			SexEdFactsCode,
			PrimaryDisabilityType,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_CSA
		FROM #c002staging
		GROUP BY 
			LEA_Identifier_State,
			RaceEdFactsCode,
			SexEdFactsCode,
			PrimaryDisabilityType

		
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
			,'CSA LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
				+ 'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  ' 
				+ 'Sex: ' + s.SexEdFactsCode + '  '
				+ 'Disability Type: ' + s.PrimaryDisabilityType
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSA s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON
			s.LEA_Identifier_State = rreksd.OrganizationStateId			
			and S.RaceEdFactsCode = rreksd.RACE
			and S.SexEdFactsCode = rreksd.SEX
			and s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'C002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSA'

		DROP TABLE #L_CSA

		
		/**********************************************************************
		Test Case 3:
		CSA at the School level
		Student Count by:
			RaceEdFactsCode
			SexEdFactsCode
			PrimaryDisabilityType
		***********************************************************************/
		SELECT
			School_Identifier_State,
			RaceEdFactsCode,
			SexEdFactsCode,
			PrimaryDisabilityType,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_CSA
		FROM #c002staging
		WHERE IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS')
		GROUP BY 
			School_Identifier_State,
			RaceEdFactsCode,
			SexEdFactsCode,
			PrimaryDisabilityType

		
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
			,'CSA School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
				+ 'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  ' 
				+ 'Sex: ' + s.SexEdFactsCode + '  '
				+ 'Disability Type: ' + s.PrimaryDisabilityType
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSA s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON
			s.School_Identifier_State = rreksd.OrganizationStateId			
			and S.RaceEdFactsCode = rreksd.RACE
			and S.SexEdFactsCode = rreksd.SEX
			and s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'C002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'CSA'

		DROP TABLE #SCH_CSA


		/**********************************************************************
		Test Case 4:
		CSB at the SEA level
		Student Count by:
			PrimaryDisabilityType
			AgeValue
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT
			PrimaryDisabilityType,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge,

			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_CSB
		FROM #c002staging 
		GROUP BY 
			PrimaryDisabilityType,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge
		
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
			,'CSB SEA'
			,'Disability Type: ' + s.PrimaryDisabilityType + '  ' 
			+'Age: ' + convert(varchar, s.AgeValue) + '  '
			+'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSB s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.PrimaryDisabilityType = rreksd.PRIMARYDISABILITYTYPE
			AND convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			and S.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND rreksd.ReportCode = 'C002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSB'

		DROP TABLE #S_CSB

		/**********************************************************************
		Test Case 5:
		CSB at the LEA level
		Student Count by:
			PrimaryDisabilityType
			AgeValue
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT
			LEA_Identifier_State,
			PrimaryDisabilityType,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_CSB
		FROM #c002staging 
		GROUP BY 
			LEA_Identifier_State,
			PrimaryDisabilityType,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge

		
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
			,'CSB LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+'Disability Type: ' + s.PrimaryDisabilityType + '  ' 
			+'Age: ' + convert(varchar, s.AgeValue) + '  '
			+'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSB s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.PrimaryDisabilityType = rreksd.PRIMARYDISABILITYTYPE
			AND convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			AND S.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND rreksd.ReportCode = 'C002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSB'

		DROP TABLE #L_CSB


		/**********************************************************************
		Test Case 6:
		CSB at the School level
		Student Count by:
			PrimaryDisabilityType
			AgeValue
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT
			School_Identifier_State,
			PrimaryDisabilityType,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_CSB
		FROM #c002staging 
		WHERE IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS')
		GROUP BY 
			School_Identifier_State,
			PrimaryDisabilityType,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge

		
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
			,'CSB School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
			+'Disability Type: ' + s.PrimaryDisabilityType + '  ' 
			+'Age: ' + convert(varchar, s.AgeValue) + '  '
			+'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSB s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.School_Identifier_State = rreksd.OrganizationStateId
			AND s.PrimaryDisabilityType = rreksd.PRIMARYDISABILITYTYPE
			AND convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			AND S.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND rreksd.ReportCode = 'C002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'CSB'

		DROP TABLE #SCH_CSB


		/**********************************************************************
		Test Case 7:
		CSC at the SEA level
		Student Count by:
			RaceEdFactsCode
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT 	
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_CSC
		FROM #c002staging 
		GROUP BY 
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForSchoolAge
		
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
			,'CSC SEA'
			,'Race: ' + s.RaceEdFactsCode +  '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSC s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND s.RaceEdFactsCode = rreksd.RACE
			AND rreksd.ReportCode = 'C002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSC'

		DROP TABLE #S_CSC


		/**********************************************************************
		Test Case 8:
		CSC at the LEA level
		Student Count by:
			RaceEdFactsCode
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_CSC
		FROM #c002staging 
		GROUP BY 
			LEA_Identifier_State,
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForSchoolAge
		
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
			,'CSC LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+ 'Race: ' + s.RaceEdFactsCode +  '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSC s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.LEA_Identifier_State = rreksd.OrganizationStateId
			AND S.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND s.RaceEdFactsCode = rreksd.RACE
			AND rreksd.ReportCode = 'C002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSC'

		DROP TABLE #L_CSC

		/**********************************************************************
		Test Case 9:
		CSC at the School level
		Student Count by:
			RaceEdFactsCode
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT 
			School_Identifier_State,
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_CSC
		FROM #c002staging 
		WHERE IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS')
		GROUP BY 
			School_Identifier_State,
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForSchoolAge
		
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
			,'CSC School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
			+ 'Race: ' + s.RaceEdFactsCode +  '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSC s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.School_Identifier_State = rreksd.OrganizationStateId
			AND S.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND s.RaceEdFactsCode = rreksd.RACE
			AND rreksd.ReportCode = 'C002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'CSC'

		DROP TABLE #SCH_CSC



		/**********************************************************************
		Test Case 10:
		CSD at the SEA level
		Student Count by:
			SexEdFactsCode
			PrimaryDisabilityType
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT 
			SexEdFactsCode,
			PrimaryDisabilityType,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_CSD
		FROM #c002staging
		GROUP BY 
			SexEdFactsCode,
			PrimaryDisabilityType,
			IDEAEducationalEnvironmentForSchoolAge

		
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
			,'CSD SEA'
			,'Sex: ' + s.SexEdFactsCode + '  '
			+ 'Primary Disability Type: ' + s.PrimaryDisabilityType +  '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSD s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND s.SexEdFactsCode = rreksd.SEX
			AND s.PrimaryDisabilityType = rreksd.PRIMARYDISABILITYTYPE
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSD'
	
		DROP TABLE #S_CSD


		/**********************************************************************
		Test Case 11:
		CSD at the LEA level
		Student Count by:
			SexEdFactsCode
			PrimaryDisabilityType
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			SexEdFactsCode,
			PrimaryDisabilityType,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_CSD
		FROM #c002staging
		GROUP BY 
			LEA_Identifier_State,
			SexEdFactsCode,
			PrimaryDisabilityType,
			IDEAEducationalEnvironmentForSchoolAge
		
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
			,'CSD LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+ 'Primary Disability Type: ' + CAST(s.PrimaryDisabilityType AS VARCHAR(3)) + '  '
			+ 'Sex: ' + s.SexEdFactsCode + ' '
			+ 'Educational Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSD s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.SexEdFactsCode = rreksd.SEX
			AND s.PrimaryDisabilityType = rreksd.PRIMARYDISABILITYTYPE
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSD'
	
		DROP TABLE #L_CSD

		/**********************************************************************
		Test Case 12:
		CSD at the School level
		Student Count by:
			SexEdFactsCode
			PrimaryDisabilityType
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT 
			School_Identifier_State,
			SexEdFactsCode,
			PrimaryDisabilityType,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_CSD
		FROM #c002staging
		WHERE IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS')
		GROUP BY 
			School_Identifier_State,
			SexEdFactsCode,
			PrimaryDisabilityType,
			IDEAEducationalEnvironmentForSchoolAge

		
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
			,'CSD School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
			+ 'Primary Disability Type: ' + CAST(s.PrimaryDisabilityType AS VARCHAR(3)) + '  '
			+ 'Sex: ' + s.SexEdFactsCode + ' '
			+ 'Educational Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSD s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.School_Identifier_State = rreksd.OrganizationStateId
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND s.SexEdFactsCode = rreksd.SEX
			AND s.PrimaryDisabilityType = rreksd.PRIMARYDISABILITYTYPE
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'CSD'
	
		DROP TABLE #SCH_CSD



		/**********************************************************************
		Test Case 13:
		CSE at the SEA level
		Student Count by:
			SexEdFactsCode
			PrimaryDisabilityType
			IDEAEducationalEnvironmentForSchoolAge
			EnglishLearnerStatusEdFactsCode
		***********************************************************************/
		SELECT 
			SexEdFactsCode,
			PrimaryDisabilityType, 
			IDEAEducationalEnvironmentForSchoolAge,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_CSE
		FROM #c002staging 
		WHERE EnglishLearnerStatusEdFactsCode in ('LEP','NLEP')
		GROUP BY SexEdFactsCode,
			PrimaryDisabilityType, 
			IDEAEducationalEnvironmentForSchoolAge,
			EnglishLearnerStatusEdFactsCode

		
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
			,'CSE SEA'
			,'Sex: ' + s.SexEdFactsCode + '  '
			+ 'Primary Disability Type: ' + s.PrimaryDisabilityType
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			+ 'EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSE s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.SexEdFactsCode= rreksd.SEX
			AND s.PrimaryDisabilityType = rreksd.PRIMARYDISABILITYTYPE
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSE'

		DROP TABLE #S_CSE

		/**********************************************************************
		Test Case 14:
		CSE at the LEA level
		Student Count by:
			SexEdFactsCode
			PrimaryDisabilityType
			IDEAEducationalEnvironmentForSchoolAge
			EnglishLearnerStatusEdFactsCode
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			SexEdFactsCode,
			PrimaryDisabilityType, 
			IDEAEducationalEnvironmentForSchoolAge,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_CSE
		FROM #c002staging 
		GROUP BY 
			LEA_Identifier_State,
			SexEdFactsCode,
			PrimaryDisabilityType, 
			IDEAEducationalEnvironmentForSchoolAge,
			EnglishLearnerStatusEdFactsCode
		
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
			,'CSE LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+ 'Sex: ' + s.SexEdFactsCode + '  '
			+ 'Primary Disability Type: ' + s.PrimaryDisabilityType
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			+ 'EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSE s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.SexEdFactsCode= rreksd.SEX
			AND s.PrimaryDisabilityType = rreksd.PRIMARYDISABILITYTYPE
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSE'

		DROP TABLE #L_CSE

		/**********************************************************************
		Test Case 15:
		CSE at the School level
		Student Count by:
			SexEdFactsCode
			PrimaryDisabilityType
			IDEAEducationalEnvironmentForSchoolAge
			EnglishLearnerStatusEdFactsCode
		***********************************************************************/
		SELECT 
			School_Identifier_State,
			SexEdFactsCode,
			PrimaryDisabilityType, 
			IDEAEducationalEnvironmentForSchoolAge,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_CSE
		FROM #c002staging 
		WHERE IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS')
		GROUP BY 
			School_Identifier_State,
			SexEdFactsCode,
			PrimaryDisabilityType, 
			IDEAEducationalEnvironmentForSchoolAge,
			EnglishLearnerStatusEdFactsCode
		
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
			,'CSE School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
			+ 'Sex: ' + s.SexEdFactsCode + '  '
			+ 'Primary Disability Type: ' + s.PrimaryDisabilityType
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			+ 'EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSE s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.School_Identifier_State = rreksd.OrganizationStateId
			AND s.SexEdFactsCode= rreksd.SEX
			AND s.PrimaryDisabilityType = rreksd.PRIMARYDISABILITYTYPE
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'CSE'

		DROP TABLE #SCH_CSE


		/**********************************************************************
		Test Case 16:
		Subtotal 1 at the SEA level
		Student Count by:
			Sex 
		***********************************************************************/
		SELECT 
			SexEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT1
		FROM #c002staging 
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
			,'ST1 SEA'
			,'Sex: ' + s.SexEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT1 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST1'

		DROP TABLE #S_TOT1


		/**********************************************************************
		Test Case 17:
		Subtotal 1 at the LEA level
		Student Count by:
			Sex 
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			SexEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT1
		FROM #c002staging 
		GROUP BY 
			LEA_Identifier_State,
			SexEdFactsCode
		
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
			,'ST1 LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+ 'Sex: ' + s.SexEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT1 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST1'

		DROP TABLE #L_TOT1

		/**********************************************************************
		Test Case 18:
		Subtotal 1 at the School level
		Student Count by:
			Sex 
		***********************************************************************/
		SELECT 
			School_Identifier_State,
			SexEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_TOT1
		FROM #c002staging 
		WHERE IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS')
		GROUP BY 
			School_Identifier_State,
			SexEdFactsCode
		
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
			,'ST1 School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
			+ 'Sex: ' + s.SexEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT1 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.School_Identifier_State = rreksd.OrganizationStateId
			AND s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'ST1'

		DROP TABLE #SCH_TOT1


		/**********************************************************************
		Test Case 19:
		Subtotal 2 at the SEA level
		Student Count by:
			AgeValue
		***********************************************************************/
		SELECT 
			AgeValue,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT2
		FROM #c002staging 
		GROUP BY AgeValue
		
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
			,'ST2 SEA'
			,'Age: ' + cast(S.AgeValue as varchar(2))
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT2 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST2'

		DROP TABLE #S_TOT2


		/**********************************************************************
		Test Case 20:
		Subtotal 2 at the LEA level
		Student Count by:
			AgeValue
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			AgeValue,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT2
		FROM #c002staging 
		GROUP BY 
			LEA_Identifier_State,
			AgeValue
		
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
			,'ST2 LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+ 'Age: ' + cast(S.AgeValue as varchar(2))
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT2 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST2'

		DROP TABLE #L_TOT2

		/**********************************************************************
		Test Case 21:
		Subtotal 2 at the School level
		Student Count by:
			AgeValue
		***********************************************************************/
		SELECT 
			School_Identifier_State,
			AgeValue,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_TOT2
		FROM #c002staging 
		WHERE IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS')
		GROUP BY 
			School_Identifier_State,
			AgeValue
		
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
			,'ST2 School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
			+ 'Age: ' + cast(S.AgeValue as varchar(2))
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT2 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.School_Identifier_State = rreksd.OrganizationStateId
			AND convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'ST2'

		DROP TABLE #SCH_TOT2

		/**********************************************************************
		Test Case 22:
		Subtotal 3 at the SEA level
		Student Count by:
			PrimaryDisabilityType
		***********************************************************************/
		SELECT 
			PrimaryDisabilityType,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT3
		FROM #c002staging 
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
		SELECT DISTINCT
			 @SqlUnitTestId
			,'ST3 SEA'
			,'Primary Disability Type: ' + S.PrimaryDisabilityType
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT3 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST3'

		DROP TABLE #S_TOT3

		/**********************************************************************
		Test Case 23:
		Subtotal 3 at the LEA level
		Student Count by:
			PrimaryDisabilityType
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			PrimaryDisabilityType,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT3
		FROM #c002staging 
		GROUP BY 
			LEA_Identifier_State,
			PrimaryDisabilityType
		
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
			,'ST3 LEA'
			,'Primary Disability Type: ' + S.PrimaryDisabilityType
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT3 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.LEA_Identifier_State = rreksd.OrganizationStateId
			AND S.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST3'

		DROP TABLE #L_TOT3

		/**********************************************************************
		Test Case 24:
		Subtotal 3 at the School level
		Student Count by:
			PrimaryDisabilityType
		***********************************************************************/
		SELECT 
			School_Identifier_State,
			PrimaryDisabilityType,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_TOT3
		FROM #c002staging 
		WHERE IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS')
		GROUP BY 
			School_Identifier_State,
			PrimaryDisabilityType
		
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
			,'ST3 School'
			,'Primary Disability Type: ' + S.PrimaryDisabilityType
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT3 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.School_Identifier_State = rreksd.OrganizationStateId
			AND S.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'ST3'

		DROP TABLE #SCH_TOT3




		/**********************************************************************
		Test Case 25:
		Subtotal 4 at the SEA level
		Student Count by:
			RaceEdFactsCode
		***********************************************************************/
		SELECT 
			RaceEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT4
		FROM #c002staging 
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
			,'ST4 SEA'
			,'Race: ' + S.RaceEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT4 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.RaceEdFactsCode = rreksd.RACE
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST4'

		DROP TABLE #S_TOT4



		/**********************************************************************
		Test Case 26:
		Subtotal 4 at the LEA level
		Student Count by:
			RaceEdFactsCode
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			RaceEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT4
		FROM #c002staging 
		GROUP BY 
			LEA_Identifier_State,
			RaceEdFactsCode
		
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
			,'ST4 LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+ 'Race: ' + S.RaceEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT4 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND S.RaceEdFactsCode = rreksd.RACE
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST4'

		DROP TABLE #L_TOT4


		/**********************************************************************
		Test Case 27:
		Subtotal 4 at the School level
		Student Count by:
			RaceEdFactsCode
		***********************************************************************/
		SELECT 
			School_Identifier_State,
			RaceEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_TOT4
		FROM #c002staging 
		WHERE IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS')
		GROUP BY 
			School_Identifier_State,
			RaceEdFactsCode
		
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
			,'ST4 School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
			+ 'Race: ' + S.RaceEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT4 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.School_Identifier_State = rreksd.OrganizationStateId
			AND S.RaceEdFactsCode = rreksd.RACE
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'ST4'

		DROP TABLE #SCH_TOT4


		/**********************************************************************
		Test Case 28:
		Subtotal 5 at the SEA level
		Student Count by:
			EnglishLearnerStatusEdFactsCode
		***********************************************************************/
		SELECT 
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT5
		FROM #c002staging 
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
			,'ST5 SEA'
			,'EL Status: ' + S.EnglishLearnerStatusEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT5 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST5'

		DROP TABLE #S_TOT5



		/**********************************************************************
		Test Case 29:
		Subtotal 5 at the LEA level
		Student Count by:
			EnglishLearnerStatusEdFactsCode
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT5
		FROM #c002staging 
		GROUP BY 
			LEA_Identifier_State,
			EnglishLearnerStatusEdFactsCode
		
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
			,'ST5 LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+ 'EL Status: ' + S.EnglishLearnerStatusEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT5 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND S.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST5'

		DROP TABLE #L_TOT5

		/**********************************************************************
		Test Case 30:
		Subtotal 5 at the School level
		Student Count by:
			EnglishLearnerStatusEdFactsCode
		***********************************************************************/
		SELECT 
			School_Identifier_State,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_TOT5
		FROM #c002staging 
		WHERE IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS')
		GROUP BY 
			School_Identifier_State,
			EnglishLearnerStatusEdFactsCode
		
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
			,'ST5 School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
			+ 'EL Status: ' + S.EnglishLearnerStatusEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT5 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.School_Identifier_State = rreksd.OrganizationStateId
			AND S.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'ST5'

		DROP TABLE #SCH_TOT5


		/**********************************************************************
		Test Case 31:
		Subtotal 6 at the SEA level
		Student Count by:
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT 
			s.IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT6
		FROM #c002staging s
		GROUP BY IDEAEducationalEnvironmentForSchoolAge
		
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
			,'ST6 SEA'
			,'Educational Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT6 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST6'

		DROP TABLE #S_TOT6



		/**********************************************************************
		Test Case 32:
		Subtotal 6 at the LEA level
		Student Count by:
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT6
		FROM #c002staging 
		GROUP BY 
			LEA_Identifier_State,
			IDEAEducationalEnvironmentForSchoolAge
		
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
			,'ST6 LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+ 'Educational Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT6 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST6'

		DROP TABLE #L_TOT6


		/**********************************************************************
		Test Case 33:
		Subtotal 6 at the School level
		Student Count by:
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT 
			School_Identifier_State,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_TOT6
		FROM #c002staging 
		WHERE IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS')
		GROUP BY 
			School_Identifier_State,
			IDEAEducationalEnvironmentForSchoolAge
		
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
			,'ST6 School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
			+ 'Educational Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT6 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.School_Identifier_State = rreksd.OrganizationStateId
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'ST6'

		DROP TABLE #SCH_TOT6

		

		/**********************************************************************
		Test Case 34:
		Subtotal 7 at the SEA level
		Student Count by:
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT 
			s.AgeValue,
			s.IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT7
		FROM #c002staging s
		GROUP BY 
			  AgeValue
			, IDEAEducationalEnvironmentForSchoolAge
		
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
			,'ST7 SEA'
			,'Age: ' + cast(s.AgeValue as varchar(2)) + '  ' 
			+ 'Educational Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT7 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST7'

		DROP TABLE #S_TOT7



		/**********************************************************************
		Test Case 35:
		Subtotal 7 at the LEA level
		Student Count by:
			AgeValue
			Education Unit Total Student Count
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT7
		FROM #c002staging 
		GROUP BY 
			LEA_Identifier_State,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge
		
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
			,'ST7 LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+ 'Age: ' + cast(s.AgeValue as varchar(2))
			+ 'Educational Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT7 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST7'

		DROP TABLE #L_TOT7

		/**********************************************************************
		Test Case 36:
		Subtotal 7 at the School level
		Student Count by:
			AgeValue
			Education Unit Total Student Count
		***********************************************************************/
		SELECT 
			School_Identifier_State,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_TOT7
		FROM #c002staging 
		WHERE IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS')
		GROUP BY 
			School_Identifier_State,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge
		
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
			,'ST7 School'
			,'School_Identifier_State: ' + s.School_Identifier_State + '  '
			+ 'Age: ' + cast(s.AgeValue as varchar(2))
			+ 'Educational Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT7 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.School_Identifier_State = rreksd.OrganizationStateId
			AND convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'ST7'

		DROP TABLE #SCH_TOT7

		/**********************************************************************
		Test Case 37:
		Total at the SEA level
		***********************************************************************/
		SELECT 
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT
		FROM #c002staging s
		
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
			,'TOT SEA'
			,'Total Student'
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'TOT'

		DROP TABLE #S_TOT



		/**********************************************************************
		Test Case 38:
		Total at the LEA level
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT
		FROM #c002staging 
		GROUP BY 
			LEA_Identifier_State
		
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
			,'TOT LEA'
			,'Total Student'
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'TOT'

		DROP TABLE #L_TOT


		/**********************************************************************
		Test Case 39:
		Total at the School level
		***********************************************************************/
		SELECT 
			School_Identifier_State,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #SCH_TOT
		FROM #c002staging 
		WHERE IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS')
		GROUP BY 
			School_Identifier_State
		
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
			,'TOT School'
			,'Total Student'
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.School_Identifier_State = rreksd.OrganizationStateId
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'TOT'

		DROP TABLE #SCH_TOT


END