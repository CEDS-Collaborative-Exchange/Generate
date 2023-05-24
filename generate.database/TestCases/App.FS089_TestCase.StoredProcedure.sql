CREATE PROCEDURE [app].[FS089_TestCase] 
	@SchoolYear INT
AS
BEGIN

	-- Create indexes as needed
	--create nonclustered index ix_K12Enrollment_SIS_LIS_SchIS ON Staging.K12Enrollment(Student_Identifier_State, LEA_Identifier_State, School_Identifier_State) INCLUDE (EnrollmentEntryDate, EnrollmentExitDate, SchoolYear)
	--create nonclustered index ix_Discipline_SIS_LIS_SchIS ON Staging.Discipline(Student_Identifier_State, LEA_Identifier_State, School_Identifier_State) INCLUDE (DisciplinaryActionStartDate)
	--create nonclustered index ix_PersonStatus_SIS_LIS_SchIS ON Staging.PersonStatus(Student_Identifier_State, LEA_Identifier_State, School_Identifier_State) INCLUDE (IDEA_StatusStartDate, IDEA_StatusEndDate)
	--create nonclustered index ix_ProgramParticipationSpecialEducation_SIS_LIS_SchIS ON Staging.ProgramParticipationSpecialEducation(Student_Identifier_State, LEA_Identifier_State, School_Identifier_State) INCLUDE (ProgramParticipationBeginDate, ProgramParticipationEndDate, IDEAEducationalEnvironmentForSchoolAge)
	--create nonclustered index ix_PersonRace_SIS_LIS_SchIS ON Staging.PersonRace(Student_Identifier_State) INCLUDE (SchoolYear)
	--CREATE NONCLUSTERED INDEX ix_PersonStatus_IDEAIndicator ON [Staging].[PersonStatus] ([IDEAIndicator],[PrimaryDisabilityType]) INCLUDE ([Student_Identifier_State],[LEA_Identifier_State],[School_Identifier_State],[EnglishLearnerStatus],[EnglishLearner_StatusStartDate],[EnglishLearner_StatusEndDate],[IDEA_StatusStartDate],[IDEA_StatusEndDate])

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C089Staging') IS NOT NULL
		DROP TABLE #C089Staging

	IF OBJECT_ID('tempdb..#S_CSA') IS NOT NULL
		DROP TABLE #S_CSA
	IF OBJECT_ID('tempdb..#S_CSB') IS NOT NULL
		DROP TABLE #S_CSB
	IF OBJECT_ID('tempdb..#S_CSC') IS NOT NULL
		DROP TABLE #S_CSC
	IF OBJECT_ID('tempdb..#S_CSD') IS NOT NULL
		DROP TABLE #S_CSD
	
	IF OBJECT_ID('tempdb..#L_CSA') IS NOT NULL
		DROP TABLE #L_CSA
	IF OBJECT_ID('tempdb..#L_CSB') IS NOT NULL
		DROP TABLE #L_CSB
	IF OBJECT_ID('tempdb..#L_CSC') IS NOT NULL
		DROP TABLE #L_CSC
	IF OBJECT_ID('tempdb..#L_CSD') IS NOT NULL
		DROP TABLE #L_CSD

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

	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT

	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS089_TestCase') 
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
				'FS089_UnitTestCase',
				'FS089_TestCase',
				'FS089',
				1
			)
			SET @SqlUnitTestId = @@IDENTITY
		END 
	ELSE 
		BEGIN
			SELECT 
				@SqlUnitTestId = SqlUnitTestId
			FROM App.SqlUnitTest 
			WHERE UnitTestName = 'FS089_UnitTestCase'
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
	
	declare @cutOffDayVARCHAR varchar(5)
	select @cutOffDayVARCHAR = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)	
	select @cutOffDay = case when right(@cutOffDayVARCHAR,1) = '/' then left(@CutOffDayVARCHAR,1) else @CutOffDayVARCHAR end
	-- select @cutOffDay = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)
	
	select @ChildCountDate = convert(varchar, @CutoffMonth) + '/' + convert(varchar, @CutoffDay) + '/' + convert(varchar, @SchoolYear-1) -- < changed to "-1"


	 SELECT  
		ske.Student_Identifier_State,
		ske.LEA_Identifier_State,
		ske.School_Identifier_State,
		sppse.IDEAEducationalEnvironmentForEarlyChildhood,
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
			WHEN @ChildCountDate
				BETWEEN ISNULL(EL.EnglishLearner_StatusStartDate, CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE))  
				AND ISNULL(EL.EnglishLearner_StatusEndDate, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)) 
			THEN ISNULL(EL.EnglishLearnerStatus, 0)
		ELSE 0
			  END AS EnglishLearnerStatus,
		CASE
			WHEN @ChildCountDate
				BETWEEN ISNULL(EL.EnglishLearner_StatusStartDate, CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE))  
				AND ISNULL(EL.EnglishLearner_StatusEndDate, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)) 
			THEN 
				CASE 
					WHEN EL.EnglishLearnerStatus = 1 THEN 'LEP'
				ELSE 'NLEP'
							END
				ELSE 'NLEP'
			  END AS EnglishLearnerStatusEdFactsCode

		INTO #c089Staging
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
		and (rda.AgeValue in (3,4)
			OR (rda.AgeValue = 5
				AND (ske.GradeLevel IS NULL 
					OR ske.GradeLevel = 'PK')))


	-- Gather, evaluate & record the results

		/**********************************************************************
		Test Case 1:
		CSA at the SEA level
		Student Count by:
			Educational Environment (IDEA) EC 
			Disability Category (IDEA) 
			Age (Early Childhood)
		***********************************************************************/
		SELECT
			AgeValue,
			IDEAEducationalEnvironmentForEarlyChildhood,
			PrimaryDisabilityType,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_CSA
		FROM #c089staging 
		GROUP BY 
			AgeValue,
			IDEAEducationalEnvironmentForEarlyChildhood,
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
			,'Age: ' + convert(varchar, s.AgeValue) + '  ' 
				+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForEarlyChildhood + '  '
				+ 'Disability Type: ' + s.PrimaryDisabilityType			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSA s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON
			convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05NOTK' then '5' else rreksd.AGE end
			and S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENT
			and s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'C089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSA'

		DROP TABLE #S_CSA


		/**********************************************************************
		Test Case 2:
		CSA at the LEA level
		Student Count by:
			Educational Environment (IDEA) EC 
			Disability Category (IDEA) 
			Age (Early Childhood)
		***********************************************************************/
		SELECT
			LEA_Identifier_State,
			AgeValue,
			IDEAEducationalEnvironmentForEarlyChildhood,
			PrimaryDisabilityType,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_CSA
		FROM #c089staging 
		GROUP BY 
			LEA_Identifier_State,
			AgeValue,
			IDEAEducationalEnvironmentForEarlyChildhood,
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
				+ 'Age: ' + convert(varchar, s.AgeValue) + '  ' 
				+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForEarlyChildhood + '  '
				+ 'Disability Type: ' + s.PrimaryDisabilityType
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSA s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON
			s.LEA_Identifier_State = rreksd.OrganizationStateId			
			and convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05NOTK' then '5' else rreksd.AGE end
			and S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENT
			and s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'C089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSA'

		DROP TABLE #L_CSA


		/**********************************************************************
		Test Case 3:
		CSB at the SEA level
		Student Count by:
			Educational Environment (IDEA) EC
			Disability Category (IDEA)
			Racial Ethnic
		***********************************************************************/
		SELECT
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForEarlyChildhood,
			PrimaryDisabilityType,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_CSB
		FROM #c089staging 
		GROUP BY 
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForEarlyChildhood,
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
			,'CSB SEA'
			,'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForEarlyChildhood + '  '
			+ 'Disability Type: ' + s.PrimaryDisabilityType
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSB s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON
			s.RaceEdFactsCode = rreksd.RACE
			and S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENT
			and s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'C089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSB'

		DROP TABLE #S_CSB

		/**********************************************************************
		Test Case 4:
		CSB at the LEA level
		Student Count by:
			Educational Environment (IDEA) EC
			Disability Category (IDEA)
			Racial Ethnic
		***********************************************************************/
		SELECT
			LEA_Identifier_State,
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForEarlyChildhood,
			PrimaryDisabilityType,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_CSB
		FROM #c089staging 
		GROUP BY 
			LEA_Identifier_State,
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForEarlyChildhood,
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
			,'CSB LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+ 'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForEarlyChildhood + '  '
			+ 'Disability Type: ' + s.PrimaryDisabilityType
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSB s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON
			S.LEA_Identifier_State = rreksd.OrganizationStateId
			and s.RaceEdFactsCode = rreksd.RACE
			and S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENT
			and s.PrimaryDisabilityType = rreksd.PrimaryDisabilityType
			AND rreksd.ReportCode = 'C089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSB'

		DROP TABLE #L_CSB


		/**********************************************************************
		Test Case 5:
		CSC at the SEA level
		Student Count by:
			Educational Environment (IDEA) EC
			Sex (Membership)
		***********************************************************************/
		SELECT 	
			IDEAEducationalEnvironmentForEarlyChildhood,
			SexEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_CSC
		FROM #c089staging 
		GROUP BY 
			IDEAEducationalEnvironmentForEarlyChildhood,
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
			,'CSC SEA'
			,'Sex: ' + s.SexEdFactsCode +  '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForEarlyChildhood
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSC s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'C089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSC'

		DROP TABLE #S_CSC


		/**********************************************************************
		Test Case 6:
		CSC at the LEA level
		Student Count by:
			Educational Environment (IDEA) EC
			Sex (Membership)
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			IDEAEducationalEnvironmentForEarlyChildhood,
			SexEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_CSC
		FROM #c089staging 
		GROUP BY 
			LEA_Identifier_State,
			IDEAEducationalEnvironmentForEarlyChildhood,
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
			,'CSC LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+ 'Sex: ' + s.SexEdFactsCode +  '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForEarlyChildhood
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSC s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.LEA_Identifier_State = rreksd.OrganizationStateId
			AND S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND s.SexEdFactsCode = rreksd.SEX
			AND rreksd.ReportCode = 'C089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSC'

		DROP TABLE #L_CSC



		/**********************************************************************
		Test Case 7:
		CSD at the SEA level
		Student Count by:
			Educational Environment (IDEA) EC
			English Learner Status (Both)
		***********************************************************************/
		SELECT 
			IDEAEducationalEnvironmentForEarlyChildhood,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_CSD
		FROM #c089staging
		WHERE EnglishLearnerStatusEdFactsCode in ('LEP','NLEP')
		GROUP BY 
			IDEAEducationalEnvironmentForEarlyChildhood,
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
			,'CSD SEA'
			,'EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) + '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForEarlyChildhood
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSD s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.IDEAEducationalEnvironmentForEarlyChildhood= rreksd.IDEAEDUCATIONALENVIRONMENT
			AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSD'
	
		DROP TABLE #S_CSD


		/**********************************************************************
		Test Case 8:
		CSD at the LEA level
		Student Count by:
			Educational Environment (IDEA) EC
			English Learner Status (Both)
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			IDEAEducationalEnvironmentForEarlyChildhood,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_CSD
		FROM #c089staging
		WHERE EnglishLearnerStatusEdFactsCode in ('LEP','NLEP')
		GROUP BY 
			LEA_Identifier_State,
			IDEAEducationalEnvironmentForEarlyChildhood,
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
			,'CSD LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+ 'EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) + '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForEarlyChildhood
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSD s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.IDEAEducationalEnvironmentForEarlyChildhood= rreksd.IDEAEDUCATIONALENVIRONMENT
			AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSD'
	
		DROP TABLE #L_CSD



		/**********************************************************************
		Test Case 9:
		Subtotal 1 at the SEA level
		Student Count by:
			Sex (Membership)
		***********************************************************************/
		SELECT 
			SexEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT1
		FROM #c089staging 
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
			ON s.SexEdFactsCode= rreksd.SEX
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST1'

		DROP TABLE #S_TOT1

		/**********************************************************************
		Test Case 10:
		Subtotal 1 at the LEA level
		Student Count by:
			Sex (Membership)
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			SexEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT1
		FROM #c089staging 
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
			ON S.LEA_Identifier_State = rreksd.OrganizationStateId
			AND s.SexEdFactsCode= rreksd.SEX
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST1'

		DROP TABLE #L_TOT1


		/**********************************************************************
		Test Case 11:
		Subtotal 2 at the SEA level
		Student Count by:
			Age (Early Childhood)
		***********************************************************************/
		SELECT 
			AgeValue,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT2
		FROM #c089staging 
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
			,'Age: ' + convert(varchar, s.AgeValue)
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT2 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05NOTK' then '5' else rreksd.AGE end
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST2'

		DROP TABLE #S_TOT2


		/**********************************************************************
		Test Case 12:
		Subtotal 2 at the LEA level
		Student Count by:
			Age (Early Childhood)
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			AgeValue,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT2
		FROM #c089staging 
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
			+ 'Age: ' + convert(varchar, s.AgeValue)
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT2 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05NOTK' then '5' else rreksd.AGE end
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST2'

		DROP TABLE #L_TOT2


		/**********************************************************************
		Test Case 13:
		Subtotal 3 at the SEA level
		Student Count by:
			Disability Category (Early Childhood)
		***********************************************************************/
		SELECT 
			PrimaryDisabilityType,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT3
		FROM #c089staging 
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
			,'Disability: ' + S.PrimaryDisabilityType
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT3 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.PrimaryDisabilityType = rreksd.PRIMARYDISABILITYTYPE
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST3'

		DROP TABLE #S_TOT3


		/**********************************************************************
		Test Case 14:
		Subtotal 3 at the LEA level
		Student Count by:
			Disability Category (Early Childhood)
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			PrimaryDisabilityType,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT3
		FROM #c089staging 
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
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+ 'Disability: ' + S.PrimaryDisabilityType
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT3 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND S.PrimaryDisabilityType = rreksd.PRIMARYDISABILITYTYPE
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST3'

		DROP TABLE #L_TOT3

		/**********************************************************************
		Test Case 15:
		Subtotal 4 at the SEA level
		Student Count by:
			Racial Ethnic
		***********************************************************************/
		SELECT 
			RaceEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT4
		FROM #c089staging 
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
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST4'

		DROP TABLE #S_TOT4

		/**********************************************************************
		Test Case 16:
		Subtotal 4 at the LEA level
		Student Count by:
			Racial Ethnic
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			RaceEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT4
		FROM #c089staging 
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
			,'Race: ' + S.RaceEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT4 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.LEA_Identifier_State = rreksd.OrganizationStateId
			AND S.RaceEdFactsCode = rreksd.RACE
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST4'

		DROP TABLE #L_TOT4




		/**********************************************************************
		Test Case 17:
		Subtotal 5 at the SEA level
		Student Count by:
			English Learner Status
		***********************************************************************/
		SELECT 
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT5
		FROM #c089staging 
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
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST5'

		DROP TABLE #S_TOT5



		/**********************************************************************
		Test Case 18:
		Subtotal 5 at the LEA level
		Student Count by:
			English Learner Status
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT5
		FROM #c089staging 
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
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST5'

		DROP TABLE #L_TOT5


		/**********************************************************************
		Test Case 19:
		Subtotal 6 at the SEA level
		Student Count by:
			Education Environment (IDEA) EC
		***********************************************************************/
		SELECT 
			IDEAEducationalEnvironmentForEarlyChildhood,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT6
		FROM #c089staging 
		GROUP BY IDEAEducationalEnvironmentForEarlyChildhood
		
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
			,'Education Environment: ' + S.IDEAEducationalEnvironmentForEarlyChildhood
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT6 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST6'

		DROP TABLE #S_TOT6



		/**********************************************************************
		Test Case 20:
		Subtotal 6 at the LEA level
		Student Count by:
			Education Environment (IDEA) EC
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			IDEAEducationalEnvironmentForEarlyChildhood,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT6
		FROM #c089staging 
		GROUP BY 
			LEA_Identifier_State,
			IDEAEducationalEnvironmentForEarlyChildhood
		
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
			+ 'Education Environment: ' + S.IDEAEducationalEnvironmentForEarlyChildhood
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT6 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENT
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST6'

		DROP TABLE #L_TOT6


		/**********************************************************************
		Test Case 21:
		Subtotal 7 at the SEA level
		Student Count by:
			Education Unit Total Student Count
		***********************************************************************/
		SELECT 
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #S_TOT7
		FROM #c089staging 
		
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
			,'Total Students'
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT7 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'TOT'

		DROP TABLE #S_TOT7



		/**********************************************************************
		Test Case 20:
		Subtotal 6 at the LEA level
		Student Count by:
			Education Unit Total Student Count
		***********************************************************************/
		SELECT 
			LEA_Identifier_State,
			COUNT(DISTINCT Student_Identifier_State) AS StudentCount
		INTO #L_TOT7
		FROM #c089staging 
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
			,'ST7 LEA'
			,'LEA_Identifier_State: ' + s.LEA_Identifier_State + '  '
			+ 'Total Students'
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT7 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LEA_Identifier_State = rreksd.OrganizationStateId
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'TOT'

		DROP TABLE #L_TOT7

END
