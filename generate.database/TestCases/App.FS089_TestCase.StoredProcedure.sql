CREATE PROCEDURE [app].[FS089_TestCase] 
	@SchoolYear INT
AS
BEGIN

	-- Create indexes as needed
	--create nonclustered index ix_K12Enrollment_SIS_LIS_SchIS ON Staging.K12Enrollment(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea) INCLUDE (EnrollmentEntryDate, EnrollmentExitDate, SchoolYear)
	--create nonclustered index ix_Discipline_SIS_LIS_SchIS ON Staging.Discipline(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea) INCLUDE (DisciplinaryActionStartDate)
	--create nonclustered index ix_PersonStatus_SIS_LIS_SchIS ON Staging.PersonStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea) INCLUDE (IDEA_StatusStartDate, IDEA_StatusEndDate)
	--create nonclustered index ix_ProgramParticipationSpecialEducation_SIS_LIS_SchIS ON Staging.ProgramParticipationSpecialEducation(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea) INCLUDE (ProgramParticipationBeginDate, ProgramParticipationEndDate, IDEAEducationalEnvironmentForSchoolAge)
	--create nonclustered index ix_PersonRace_SIS_LIS_SchIS ON Staging.PersonRace(StudentIdentifierState) INCLUDE (SchoolYear)
	--CREATE NONCLUSTERED INDEX ix_PersonStatus_IDEAIndicator ON [Staging].[PersonStatus] ([IDEAIndicator],[IdeaDisabilityTypeCode]) INCLUDE ([StudentIdentifierState],[LeaIdentifierSeaAccountability],[SchoolIdentifierSea],[EnglishLearnerStatus],[EnglishLearner_StatusStartDate],[EnglishLearner_StatusEndDate],[IDEA_StatusStartDate],[IDEA_StatusEndDate])

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

	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS089_UnitTestCase') 
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
		ske.StudentIdentifierState,
		ske.LeaIdentifierSeaAccountability,
		ske.SchoolIdentifierSea,
		sppse.IDEAEducationalEnvironmentForEarlyChildhood,
		rda.AgeValue,
		ske.GradeLevel,
		CASE idea.IdeaDisabilityTypeCode
            WHEN 'Autism' THEN 'AUT'
            WHEN 'Deafblindness' THEN 'DB'
            WHEN 'Deafness' THEN 'DB'
            WHEN 'Developmentaldelay' THEN 'DD'
            WHEN 'Emotionaldisturbance' THEN 'EMN'
            WHEN 'Hearingimpairment' THEN 'HI'
            WHEN 'Intellectualdisability' THEN 'ID'
            WHEN 'Multipledisabilities' THEN 'MD'
            WHEN 'Orthopedicimpairment' THEN 'OI'
            WHEN 'Otherhealthimpairment' THEN 'OHI'
            WHEN 'Specificlearningdisability' THEN 'SLD'
            WHEN 'Speechlanguageimpairment' THEN 'SLI'
            WHEN 'Traumaticbraininjury' THEN 'TBI'
            WHEN 'Visualimpairment' THEN 'VI'
            ELSE idea.IdeaDisabilityTypeCode
		END AS IdeaDisabilityTypeCode,
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

		INTO #c089Staging
		FROM Staging.K12Enrollment ske

		JOIN Staging.IdeaDisabilityType idea
			ON ske.StudentIdentifierState = idea.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(idea.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(idea.SchoolIdentifierSea, '')
			AND @ChildCountDate BETWEEN idea.RecordStartDateTime AND ISNULL(idea.RecordEndDateTime, GETDATE())
			AND idea.IsPrimaryDisability = 1

		JOIN Staging.ProgramParticipationSpecialEducation sppse
			ON ske.StudentIdentifierState = sppse.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(sppse.LeaIdentifierSeaAccountability, '') 
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(sppse.SchoolIdentifierSea, '')
			AND @ChildCountDate BETWEEN sppse.ProgramParticipationBeginDate AND ISNULL(sppse.ProgramParticipationEndDate, GETDATE())
		
		LEFT JOIN Staging.K12PersonRace spr
			ON ske.SchoolYear = spr.SchoolYear
			AND ske.StudentIdentifierState = spr.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(spr.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(spr.SchoolIdentifierSea, '')
			AND spr.RecordStartDateTime is not null
			AND @ChildCountDate BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, GETDATE())

		left JOIN Staging.PersonStatus el 
			ON ske.StudentIdentifierState = el.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(el.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(el.SchoolIdentifierSea, '')
			AND @ChildCountDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())

		JOIN RDS.DimAges rda
			ON RDS.Get_Age(ske.Birthdate, @ChildCountDate) = rda.AgeValue

		WHERE @ChildCountDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())
		and (rda.AgeValue in (3,4)
			OR (rda.AgeValue = 5
				AND (ske.GradeLevel IS NULL 
					OR ske.GradeLevel = 'PK')))

					
	-- select * 
	-- from #c089Staging c
	-- left join debug.c089_sea_CSC_2023_EDENVIDEAEC_SEX t
	-- 	on c.StudentIdentifierState = t.K12StudentStudentIdentifierState
	-- 	and c.SexEdFactsCode = t.SEX
	-- 	and c.IDEAEducationalEnvironmentForEarlyChildhood = t.IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD
	-- where t.K12StudentStudentIdentifierState is null
	-- 	and c.SexEdFactsCode = 'F'
	-- 	and c.IDEAEducationalEnvironmentForEarlyChildhood = 'REC10YOTHLOC'

	-- select * 
	-- from  #c089Staging c
	-- left join debug.c089_sea_ST5_2023_LEPBOTH t
	-- 	on c.StudentIdentifierState = t.K12StudentStudentIdentifierState
	-- 	and c.EnglishLearnerStatusEdFactsCode = t.ENGLISHLEARNERSTATUS
	-- where /* c.StudentIdentifierState is null
	-- 	and */
	-- 	t.K12StudentStudentIdentifierState is null
	-- 	and c.EnglishLearnerStatusEdFactsCode = 'nlep'
	-- 	--and t.ENGLISHLEARNERSTATUS = 'nlep'
	-- order by c.SexEdFactsCode

	-- select StudentIdentifierState from #c089Staging t group by StudentIdentifierState having count(1) > 1
	-- select t.K12StudentStudentIdentifierState from debug.c089_sea_ST5_2023_LEPBOTH t group by t.K12StudentStudentIdentifierState having count(1) > 1


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
			IdeaDisabilityTypeCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_CSA
		FROM #c089staging 
		GROUP BY 
			AgeValue,
			IDEAEducationalEnvironmentForEarlyChildhood,
			IdeaDisabilityTypeCode

		
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
				+ 'Disability Type: ' + s.IdeaDisabilityTypeCode			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSA s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON
			convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05NOTK' then '5' else rreksd.AGE end
			and S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD
			and s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
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
			LeaIdentifierSeaAccountability,
			AgeValue,
			IDEAEducationalEnvironmentForEarlyChildhood,
			IdeaDisabilityTypeCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_CSA
		FROM #c089staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			AgeValue,
			IDEAEducationalEnvironmentForEarlyChildhood,
			IdeaDisabilityTypeCode

		
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
				+ 'Age: ' + convert(varchar, s.AgeValue) + '  ' 
				+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForEarlyChildhood + '  '
				+ 'Disability Type: ' + s.IdeaDisabilityTypeCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSA s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea			
			and convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05NOTK' then '5' else rreksd.AGE end
			and S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD
			and s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
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
			IdeaDisabilityTypeCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_CSB
		FROM #c089staging 
		GROUP BY 
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForEarlyChildhood,
			IdeaDisabilityTypeCode

		
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
			+ 'Disability Type: ' + s.IdeaDisabilityTypeCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSB s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON
			s.RaceEdFactsCode = rreksd.RACE
			and S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD
			and s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
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
			LeaIdentifierSeaAccountability,
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForEarlyChildhood,
			IdeaDisabilityTypeCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_CSB
		FROM #c089staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForEarlyChildhood,
			IdeaDisabilityTypeCode

		
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForEarlyChildhood + '  '
			+ 'Disability Type: ' + s.IdeaDisabilityTypeCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSB s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON
			S.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			and s.RaceEdFactsCode = rreksd.RACE
			and S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD
			and s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
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
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
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
			ON S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD
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
			LeaIdentifierSeaAccountability,
			IDEAEducationalEnvironmentForEarlyChildhood,
			SexEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_CSC
		FROM #c089staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Sex: ' + s.SexEdFactsCode +  '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForEarlyChildhood
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSC s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD
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
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
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
			ON s.IDEAEducationalEnvironmentForEarlyChildhood= rreksd.IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD
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
			LeaIdentifierSeaAccountability,
			IDEAEducationalEnvironmentForEarlyChildhood,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_CSD
		FROM #c089staging
		WHERE EnglishLearnerStatusEdFactsCode in ('LEP','NLEP')
		GROUP BY 
			LeaIdentifierSeaAccountability,
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) + '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForEarlyChildhood
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSD s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND s.IDEAEducationalEnvironmentForEarlyChildhood= rreksd.IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD
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
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
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
			LeaIdentifierSeaAccountability,
			SexEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT1
		FROM #c089staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Sex: ' + s.SexEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT1 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
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
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
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
			LeaIdentifierSeaAccountability,
			AgeValue,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT2
		FROM #c089staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Age: ' + convert(varchar, s.AgeValue)
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT2 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
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
			IdeaDisabilityTypeCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_TOT3
		FROM #c089staging 
		GROUP BY IdeaDisabilityTypeCode
		
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
			,'Disability: ' + S.IdeaDisabilityTypeCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT3 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
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
			LeaIdentifierSeaAccountability,
			IdeaDisabilityTypeCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT3
		FROM #c089staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
			IdeaDisabilityTypeCode
		
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Disability: ' + S.IdeaDisabilityTypeCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT3 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND S.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
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
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
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
			LeaIdentifierSeaAccountability,
			RaceEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT4
		FROM #c089staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
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
			ON S.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
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
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
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
			LeaIdentifierSeaAccountability,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT5
		FROM #c089staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'EL Status: ' + S.EnglishLearnerStatusEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT5 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
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
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
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
			ON S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD
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
			LeaIdentifierSeaAccountability,
			IDEAEducationalEnvironmentForEarlyChildhood,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT6
		FROM #c089staging 
		GROUP BY 
			LeaIdentifierSeaAccountability,
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Education Environment: ' + S.IDEAEducationalEnvironmentForEarlyChildhood
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT6 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND S.IDEAEducationalEnvironmentForEarlyChildhood = rreksd.IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD
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
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
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
			LeaIdentifierSeaAccountability,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT7
		FROM #c089staging 
		GROUP BY 
			LeaIdentifierSeaAccountability
		
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Total Students'
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT7 s
		inner JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND rreksd.ReportCode = 'c089' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'TOT'

		DROP TABLE #L_TOT7


END
