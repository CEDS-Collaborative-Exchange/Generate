CREATE PROCEDURE [app].[FS002_TestCase] 
	@SchoolYear INT 
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C002Staging') IS NOT NULL
	DROP TABLE #C002Staging

	IF OBJECT_ID('tempdb..#TempRacesUpdate') IS NOT NULL
	DROP TABLE #TempRacesUpdate

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
		INSERT INTO App.SqlUnitTest (
			UnitTestName,
			StoredProcedureName,
			TestScope,
			IsActive
		) VALUES (
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
	INNER join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CHDCTDTE'

	select @cutOffMonth = SUBSTRING(@customFactTypeDate, 0, CHARINDEX('/', @customFactTypeDate))
	
	declare @cutOffDayVARCHAR varchar(5)
	select @cutOffDayVARCHAR = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)	
	select @cutOffDay = case when right(@cutOffDayVARCHAR,1) = '/' then left(@CutOffDayVARCHAR,1) else @CutOffDayVARCHAR end
	-- select @cutOffDay = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)
	
	select @ChildCountDate = convert(varchar, @CutoffMonth) + '/' + convert(varchar, @CutoffDay) + '/' + convert(varchar, @SchoolYear-1) -- < changed to "-1"


	--Get the LEAs that should not be reported against
	IF OBJECT_ID('tempdb..#excludedLeas') IS NOT NULL
	DROP TABLE #excludedLeas

	CREATE TABLE #excludedLeas (
		LeaIdentifierSeaAccountability		VARCHAR(20)
	)

	INSERT INTO #excludedLeas 
	SELECT DISTINCT LEAIdentifierSea
	FROM Staging.K12Organization
	WHERE LEA_IsReportedFederally = 0
		OR LEA_OperationalStatus in ('Closed', 'FutureAgency', 'Inactive', 'MISSING', 'Closed_1', 'FutureAgency_1', 'Inactive_1')


	--Get the Schools that should not be reported against
	IF OBJECT_ID('tempdb..#excludedSchools') IS NOT NULL
	DROP TABLE #excludedSchools

	CREATE TABLE #excludedSchools (
		SchoolIdentifierSea		VARCHAR(20)
	)

	INSERT INTO #excludedSchools 
	SELECT DISTINCT SchoolIdentifierSea
	FROM Staging.K12Organization
	WHERE School_IsReportedFederally = 0
		OR School_OperationalStatus in ('Closed', 'FutureSchool', 'Inactive', 'MISSING', 'Closed_1', 'FutureSchool_1', 'Inactive_1')

	--Get the data needed for the tests
	SELECT  
		ske.StudentIdentifierState,
		ske.LeaIdentifierSeaAccountability,
		ske.SchoolIdentifierSea,
		sppse.IDEAEducationalEnvironmentForSchoolAge,
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
            WHEN 'Autism_1' THEN 'AUT'
            WHEN 'Deafblindness_1' THEN 'DB'
            WHEN 'Deafness_1' THEN 'DB'
            WHEN 'Developmentaldelay_1' THEN 'DD'
            WHEN 'Emotionaldisturbance_1' THEN 'EMN'
            WHEN 'Hearingimpairment_1' THEN 'HI'
            WHEN 'Intellectualdisability_1' THEN 'ID'
            WHEN 'Multipledisabilities_1' THEN 'MD'
            WHEN 'Orthopedicimpairment_1' THEN 'OI'
            WHEN 'Otherhealthimpairment_1' THEN 'OHI'
            WHEN 'Specificlearningdisability_1' THEN 'SLD'
            WHEN 'Speechlanguageimpairment_1' THEN 'SLI'
            WHEN 'Traumaticbraininjury_1' THEN 'TBI'
            WHEN 'Visualimpairment_1' THEN 'VI'
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
			WHEN spr.RaceType = 'AmericanIndianorAlaskaNative_1' THEN 'AM7'
			WHEN spr.RaceType = 'Asian_1' THEN 'AS7'
			WHEN spr.RaceType = 'BlackorAfricanAmerican_1' THEN 'BL7'
			WHEN spr.RaceType = 'NativeHawaiianorOtherPacificIslander_1' THEN 'PI7'
			WHEN spr.RaceType = 'White_1' THEN 'WH7'
			WHEN spr.RaceType = 'TwoorMoreRaces_1' THEN 'MU7'
		END AS RaceEdFactsCode,
		CASE ske.Sex
				WHEN 'Male' THEN 'M'
				WHEN 'Female' THEN 'F'
				WHEN 'Male_1' THEN 'M'
				WHEN 'Female_1' THEN 'F'
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


		JOIN Staging.ProgramParticipationSpecialEducation sppse
			ON ske.StudentIdentifierState = sppse.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(sppse.LeaIdentifierSeaAccountability, '') 
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(sppse.SchoolIdentifierSea, '')
			AND @ChildCountDate BETWEEN sppse.ProgramParticipationBeginDate AND ISNULL(sppse.ProgramParticipationEndDate, GETDATE())
		
		LEFT JOIN Staging.IdeaDisabilityType idea
			ON ske.StudentIdentifierState = idea.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(idea.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(idea.SchoolIdentifierSea, '')
			AND @ChildCountDate BETWEEN idea.RecordStartDateTime AND ISNULL(idea.RecordEndDateTime, GETDATE())
			AND idea.IsPrimaryDisability = 1

		LEFT JOIN Staging.K12PersonRace spr
			ON ske.SchoolYear = spr.SchoolYear
			AND ske.StudentIdentifierState = spr.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(spr.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(spr.SchoolIdentifierSea, '')
			AND spr.RecordStartDateTime is not null
			AND @ChildCountDate BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, GETDATE())
			
		LEFT JOIN Staging.PersonStatus el 
			ON ske.StudentIdentifierState = el.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(el.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(el.SchoolIdentifierSea, '')
			AND @ChildCountDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())

		JOIN RDS.DimAges rda
			ON RDS.Get_Age(ske.Birthdate, @ChildCountDate) = rda.AgeValue

		WHERE @ChildCountDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())
		AND sppse.IDEAIndicator = 1
		AND (rda.AgeValue BETWEEN 6 and 21
			OR (rda.AgeValue = 5
				AND ske.GradeLevel IS NOT NULL 
				AND ske.GradeLevel NOT IN ('PK', 'PK_1')))
		
	
	--Handle the Race records to match the unduplicated code 
	IF OBJECT_ID('tempdb..#tempRacesUpdate') IS NOT NULL
	drop table #tempRacesUpdate

	--Update #c002Staging records for the same Lea/School to Multiple 
	SELECT 
		StudentIdentifierState
		, LeaIdentifierSeaAccountability
		, SchoolIdentifierSea
		, rdr.RaceCode
		, SchoolYear
	INTO #TempRacesUpdate
	FROM (
		SELECT 
			  StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, CASE 
				WHEN COUNT(OutputCode) > 1 THEN 'TwoOrMoreRaces'
				ELSE MAX(OutputCode)
			END as RaceCode
			, spr.SchoolYear
		FROM Staging.K12PersonRace spr
		JOIN Staging.SourceSystemReferenceData sssrd
			ON spr.RaceType = sssrd.InputCode
			AND spr.SchoolYear = sssrd.SchoolYear
			AND sssrd.TableName = 'RefRace'
		WHERE OutputCode <> 'TwoOrMoreRaces'	
		GROUP BY
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, spr.SchoolYear
	) AS stagingRaces
	JOIN RDS.DimRaces rdr
		ON stagingRaces.RaceCode = rdr.RaceCode
	WHERE stagingRaces.RaceCode = 'TwoOrMoreRaces'


	UPDATE stg 
	SET RaceEdFactsCode = 'MU7'
	FROM #c002Staging stg
		INNER JOIN #TempRacesUpdate tru
			ON stg.StudentIdentifierState = tru.StudentIdentifierState
			AND stg.LeaIdentifierSeaAccountability = tru.LeaIdentifierSeaAccountability
			AND stg.SchoolIdentifierSea = tru.SchoolIdentifierSea
	WHERE stg.RaceEdFactsCode <> 'HI7'

	-------------------------------------------------
	-- Gather, evaluate & record the results
	-------------------------------------------------

		/**********************************************************************
		Test Case 1:
		CSA at the SEA level
		Student Count by:
			RaceEdFactsCode
			SexEdFactsCode
			IdeaDisabilityTypeCode
		***********************************************************************/
		SELECT
			c.RaceEdFactsCode,
			SexEdFactsCode,
			IdeaDisabilityTypeCode,
			COUNT(DISTINCT c.StudentIdentifierState) AS StudentCount
		INTO #S_CSA
		FROM #c002staging c
		GROUP BY 
			c.RaceEdFactsCode,
			SexEdFactsCode,
			IdeaDisabilityTypeCode

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
			,'CSA SEA'
			,'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  ' 
				+ 'Sex: ' + s.SexEdFactsCode+ '  '
				+ 'Disability Type: ' + s.IdeaDisabilityTypeCode			
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSA s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.RaceEdFactsCode = rreksd.RACE			
			AND s.SexEdFactsCode = rreksd.SEX
			AND s.IdeaDisabilityTypeCode = rreksd.IDEADISABILITYTYPE
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
			IdeaDisabilityTypeCode
		***********************************************************************/
		SELECT
			c.LeaIdentifierSeaAccountability,
			RaceEdFactsCode, 
			SexEdFactsCode,
			IdeaDisabilityTypeCode,
			COUNT(DISTINCT c.StudentIdentifierState) AS StudentCount
		INTO #L_CSA
		FROM #c002staging c
		LEFT JOIN #excludedLeas elea
			ON c.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		GROUP BY 
			c.LeaIdentifierSeaAccountability,
			RaceEdFactsCode,
			SexEdFactsCode,
			IdeaDisabilityTypeCode

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
			,'CSA LEA'
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
				+ 'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  ' 
				+ 'Sex: ' + s.SexEdFactsCode + '  '
				+ 'Disability Type: ' + s.IdeaDisabilityTypeCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSA s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea			
			and S.RaceEdFactsCode = rreksd.RACE
			and S.SexEdFactsCode = rreksd.SEX
			and s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
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
			IdeaDisabilityTypeCode
		***********************************************************************/
		SELECT
			c.SchoolIdentifierSea,
			RaceEdFactsCode,
			SexEdFactsCode,
			IdeaDisabilityTypeCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSA
		FROM #c002staging c
		LEFT JOIN #excludedSchools esch
			ON c.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reported Schools
		AND IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS', 'HH_1', 'PPPS_1')
		GROUP BY 
			c.SchoolIdentifierSea,
			RaceEdFactsCode,
			SexEdFactsCode,
			IdeaDisabilityTypeCode

		
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
			,'CSA School'
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
				+ 'Race: ' + convert(varchar, s.RaceEdFactsCode) + '  ' 
				+ 'Sex: ' + s.SexEdFactsCode + '  '
				+ 'Disability Type: ' + s.IdeaDisabilityTypeCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSA s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON
			s.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea			
			and S.RaceEdFactsCode = rreksd.RACE
			and S.SexEdFactsCode = rreksd.SEX
			and s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
			AND rreksd.ReportCode = 'C002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'CSA'

		DROP TABLE #SCH_CSA


		/**********************************************************************
		Test Case 4:
		CSB at the SEA level
		Student Count by:
			IdeaDisabilityTypeCode
			AgeValue
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT
			IdeaDisabilityTypeCode,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_CSB
		FROM #c002staging 
		GROUP BY 
			IdeaDisabilityTypeCode,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge
		
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
			,'CSB SEA'
			,'Disability Type: ' + s.IdeaDisabilityTypeCode + '  ' 
			+'Age: ' + convert(varchar, s.AgeValue) + '  '
			+'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSB s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
			AND convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			and S.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
			AND rreksd.ReportCode = 'C002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'CSB'

		DROP TABLE #S_CSB

		/**********************************************************************
		Test Case 5:
		CSB at the LEA level
		Student Count by:
			IdeaDisabilityTypeCode
			AgeValue
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT
			c.LeaIdentifierSeaAccountability,
			IdeaDisabilityTypeCode,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_CSB
		FROM #c002staging c
		LEFT JOIN #excludedLeas elea
			ON c.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		GROUP BY 
			c.LeaIdentifierSeaAccountability,
			IdeaDisabilityTypeCode,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge

		
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
			,'CSB LEA'
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+'Disability Type: ' + s.IdeaDisabilityTypeCode + '  ' 
			+'Age: ' + convert(varchar, s.AgeValue) + '  '
			+'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSB s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
			AND convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			AND S.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
			AND rreksd.ReportCode = 'C002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'CSB'

		DROP TABLE #L_CSB


		/**********************************************************************
		Test Case 6:
		CSB at the School level
		Student Count by:
			IdeaDisabilityTypeCode
			AgeValue
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT
			c.SchoolIdentifierSea,
			IdeaDisabilityTypeCode,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSB
		FROM #c002staging c
		LEFT JOIN #excludedSchools esch
			ON c.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reported Schools
		AND IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS', 'HH_1', 'PPPS_1')
		GROUP BY 
			c.SchoolIdentifierSea,
			IdeaDisabilityTypeCode,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge

		
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
			,'CSB School'
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+'Disability Type: ' + s.IdeaDisabilityTypeCode + '  ' 
			+'Age: ' + convert(varchar, s.AgeValue) + '  '
			+'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSB s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea
			AND s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
			AND convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			AND S.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
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
			c.RaceEdFactsCode,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT c.StudentIdentifierState) AS StudentCount
		INTO #S_CSC
		FROM #c002staging c
		GROUP BY 
			c.RaceEdFactsCode,
			IDEAEducationalEnvironmentForSchoolAge


		INSERT INTO App.SqlUnitTestCaseResult (
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
			ON S.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
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
			c.LeaIdentifierSeaAccountability,
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_CSC
		FROM #c002staging c
		LEFT JOIN #excludedLeas elea
			ON c.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		GROUP BY 
			c.LeaIdentifierSeaAccountability,
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForSchoolAge
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			+ 'Race: ' + s.RaceEdFactsCode +  '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSC s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND S.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
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
			c.SchoolIdentifierSea,
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSC
		FROM #c002staging c
		LEFT JOIN #excludedSchools esch
			ON c.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reported Schools
		AND IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS', 'HH_1', 'PPPS_1')
		GROUP BY 
			c.SchoolIdentifierSea,
			RaceEdFactsCode,
			IDEAEducationalEnvironmentForSchoolAge
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'Race: ' + s.RaceEdFactsCode +  '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSC s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea
			AND S.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
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
			IdeaDisabilityTypeCode
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT 
			SexEdFactsCode,
			IdeaDisabilityTypeCode,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_CSD
		FROM #c002staging
		GROUP BY 
			SexEdFactsCode,
			IdeaDisabilityTypeCode,
			IDEAEducationalEnvironmentForSchoolAge
					
		INSERT INTO App.SqlUnitTestCaseResult (
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
			+ 'Primary Disability Type: ' + s.IdeaDisabilityTypeCode +  '  '
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSD s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
			AND s.SexEdFactsCode = rreksd.SEX
			AND s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
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
			IdeaDisabilityTypeCode
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT 
			c.LeaIdentifierSeaAccountability,
			SexEdFactsCode,
			IdeaDisabilityTypeCode,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_CSD
		FROM #c002staging c
		LEFT JOIN #excludedLeas elea
			ON c.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		GROUP BY 
			c.LeaIdentifierSeaAccountability,
			SexEdFactsCode,
			IdeaDisabilityTypeCode,
			IDEAEducationalEnvironmentForSchoolAge
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			+ 'Primary Disability Type: ' + CAST(s.IdeaDisabilityTypeCode AS VARCHAR(3)) + '  '
			+ 'Sex: ' + s.SexEdFactsCode + ' '
			+ 'Educational Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSD s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND s.SexEdFactsCode = rreksd.SEX
			AND s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
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
			IdeaDisabilityTypeCode
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT 
			c.SchoolIdentifierSea,
			SexEdFactsCode,
			IdeaDisabilityTypeCode,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSD
		FROM #c002staging c
		LEFT JOIN #excludedSchools esch
			ON c.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reported Schools
		AND IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS', 'HH_1', 'PPPS_1')
		GROUP BY 
			c.SchoolIdentifierSea,
			SexEdFactsCode,
			IdeaDisabilityTypeCode,
			IDEAEducationalEnvironmentForSchoolAge

		INSERT INTO App.SqlUnitTestCaseResult (
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
			,' SchoolIdentifierSea: ' + s.SchoolIdentifierSea + ''
			+ ' Primary Disability Type: ' + CAST(s.IdeaDisabilityTypeCode AS VARCHAR(3)) + ''
			+ ' Sex: ' + s.SexEdFactsCode + ''
			+ ' Educational Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSD s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
			AND s.SexEdFactsCode = rreksd.SEX
			AND s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
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
			IdeaDisabilityTypeCode
			IDEAEducationalEnvironmentForSchoolAge
			EnglishLearnerStatusEdFactsCode
		***********************************************************************/
		SELECT 
			SexEdFactsCode,
			IdeaDisabilityTypeCode, 
			IDEAEducationalEnvironmentForSchoolAge,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_CSE
		FROM #c002staging 
		WHERE EnglishLearnerStatusEdFactsCode in ('LEP','NLEP')
		GROUP BY SexEdFactsCode,
			IdeaDisabilityTypeCode, 
			IDEAEducationalEnvironmentForSchoolAge,
			EnglishLearnerStatusEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'Sex: ' + s.SexEdFactsCode + ' '
			+ 'Primary Disability Type: ' + s.IdeaDisabilityTypeCode + ' ' 
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge + ' ' 
			+ 'EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) + ' '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_CSE s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.SexEdFactsCode= rreksd.SEX
			AND s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
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
			IdeaDisabilityTypeCode
			IDEAEducationalEnvironmentForSchoolAge
			EnglishLearnerStatusEdFactsCode
		***********************************************************************/
		SELECT 
			c.LeaIdentifierSeaAccountability,
			SexEdFactsCode,
			IdeaDisabilityTypeCode, 
			IDEAEducationalEnvironmentForSchoolAge,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_CSE
		FROM #c002staging c
		LEFT JOIN #excludedLeas elea
			ON c.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		GROUP BY 
			c.LeaIdentifierSeaAccountability,
			SexEdFactsCode,
			IdeaDisabilityTypeCode, 
			IDEAEducationalEnvironmentForSchoolAge,
			EnglishLearnerStatusEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Sex: ' + s.SexEdFactsCode + '  '
			+ 'Primary Disability Type: ' + s.IdeaDisabilityTypeCode
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			+ 'EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_CSE s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND s.SexEdFactsCode= rreksd.SEX
			AND s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
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
			IdeaDisabilityTypeCode
			IDEAEducationalEnvironmentForSchoolAge
			EnglishLearnerStatusEdFactsCode
		***********************************************************************/
		SELECT 
			c.SchoolIdentifierSea,
			SexEdFactsCode,
			IdeaDisabilityTypeCode, 
			IDEAEducationalEnvironmentForSchoolAge,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_CSE
		FROM #c002staging c
		LEFT JOIN #excludedSchools esch
			ON c.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reported Schools
		AND IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS', 'HH_1', 'PPPS_1')
		GROUP BY 
			c.SchoolIdentifierSea,
			SexEdFactsCode,
			IdeaDisabilityTypeCode, 
			IDEAEducationalEnvironmentForSchoolAge,
			EnglishLearnerStatusEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'Sex: ' + s.SexEdFactsCode + '  '
			+ 'Primary Disability Type: ' + s.IdeaDisabilityTypeCode
			+ 'Education Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			+ 'EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_CSE s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea
			AND s.SexEdFactsCode= rreksd.SEX
			AND s.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
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
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_TOT1
		FROM #c002staging 
		GROUP BY SexEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
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
			c.LeaIdentifierSeaAccountability,
			SexEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT1
		FROM #c002staging c
		LEFT JOIN #excludedLeas elea
			ON c.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		GROUP BY 
			c.LeaIdentifierSeaAccountability,
			SexEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
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
			c.SchoolIdentifierSea,
			SexEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_TOT1
		FROM #c002staging c
		LEFT JOIN #excludedSchools esch
			ON c.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reported Schools
		AND IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS', 'HH_1', 'PPPS_1')
		GROUP BY 
			c.SchoolIdentifierSea,
			SexEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'Sex: ' + s.SexEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT1 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea
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
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_TOT2
		FROM #c002staging 
		GROUP BY AgeValue
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
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
			c.LeaIdentifierSeaAccountability,
			AgeValue,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT2
		FROM #c002staging c
		LEFT JOIN #excludedLeas elea
			ON c.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		GROUP BY 
			c.LeaIdentifierSeaAccountability,
			AgeValue
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			+ 'Age: ' + cast(S.AgeValue as varchar(2))
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT2 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
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
			c.SchoolIdentifierSea,
			AgeValue,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_TOT2
		FROM #c002staging c
		LEFT JOIN #excludedSchools esch
			ON c.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reported Schools
		AND IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS', 'HH_1', 'PPPS_1')
		GROUP BY 
			c.SchoolIdentifierSea,
			AgeValue
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'Age: ' + cast(S.AgeValue as varchar(2))
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT2 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea
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
			IdeaDisabilityTypeCode
		***********************************************************************/
		SELECT 
			IdeaDisabilityTypeCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_TOT3
		FROM #c002staging 
		GROUP BY IdeaDisabilityTypeCode
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'Primary Disability Type: ' + S.IdeaDisabilityTypeCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #S_TOT3 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SEA'
			AND rreksd.CategorySetCode = 'ST3'

		DROP TABLE #S_TOT3

		/**********************************************************************
		Test Case 23:
		Subtotal 3 at the LEA level
		Student Count by:
			IdeaDisabilityTypeCode
		***********************************************************************/
		SELECT 
			c.LeaIdentifierSeaAccountability,
			IdeaDisabilityTypeCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT3
		FROM #c002staging c
		LEFT JOIN #excludedLeas elea
			ON c.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		GROUP BY 
			c.LeaIdentifierSeaAccountability,
			IdeaDisabilityTypeCode
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'Primary Disability Type: ' + S.IdeaDisabilityTypeCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT3 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND S.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'LEA'
			AND rreksd.CategorySetCode = 'ST3'

		DROP TABLE #L_TOT3

		/**********************************************************************
		Test Case 24:
		Subtotal 3 at the School level
		Student Count by:
			IdeaDisabilityTypeCode
		***********************************************************************/
		SELECT 
			c.SchoolIdentifierSea,
			IdeaDisabilityTypeCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_TOT3
		FROM #c002staging c
		LEFT JOIN #excludedSchools esch
			ON c.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reported Schools
		AND IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS', 'HH_1', 'PPPS_1')
		GROUP BY 
			c.SchoolIdentifierSea,
			IdeaDisabilityTypeCode
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'Primary Disability Type: ' + S.IdeaDisabilityTypeCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT3 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON S.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea
			AND S.IdeaDisabilityTypeCode = rreksd.IdeaDisabilityType
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
			c.RaceEdFactsCode,
			COUNT(DISTINCT c.StudentIdentifierState) AS StudentCount
		INTO #S_TOT4
		FROM #c002staging c
		GROUP BY c.RaceEdFactsCode

		INSERT INTO App.SqlUnitTestCaseResult (
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
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
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
			c.LeaIdentifierSeaAccountability,
			RaceEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT4
		FROM #c002staging c
		LEFT JOIN #excludedLeas elea
			ON c.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		GROUP BY 
			c.LeaIdentifierSeaAccountability,
			RaceEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			+ 'Race: ' + S.RaceEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT4 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
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
			c.SchoolIdentifierSea,
			RaceEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_TOT4
		FROM #c002staging c
		LEFT JOIN #excludedSchools esch
			ON c.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reported Schools
		AND IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS', 'HH_1', 'PPPS_1')
		GROUP BY 
			c.SchoolIdentifierSea,
			RaceEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'Race: ' + S.RaceEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT4 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea
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
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_TOT5
		FROM #c002staging 
		GROUP BY EnglishLearnerStatusEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
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
			c.LeaIdentifierSeaAccountability,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT5
		FROM #c002staging c
		LEFT JOIN #excludedLeas elea
			ON c.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		GROUP BY 
			c.LeaIdentifierSeaAccountability,
			EnglishLearnerStatusEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
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
			c.SchoolIdentifierSea,
			EnglishLearnerStatusEdFactsCode,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_TOT5
		FROM #c002staging c
		LEFT JOIN #excludedSchools esch
			ON c.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reported Schools
		AND IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS', 'HH_1', 'PPPS_1')
		GROUP BY 
			c.SchoolIdentifierSea,
			EnglishLearnerStatusEdFactsCode
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'EL Status: ' + S.EnglishLearnerStatusEdFactsCode
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT5 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea
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
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_TOT6
		FROM #c002staging s
		GROUP BY IDEAEducationalEnvironmentForSchoolAge
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
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
			c.LeaIdentifierSeaAccountability,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT6
		FROM #c002staging c
		LEFT JOIN #excludedLeas elea
			ON c.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		GROUP BY 
			c.LeaIdentifierSeaAccountability,
			IDEAEducationalEnvironmentForSchoolAge
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			+ 'Educational Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT6 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
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
			c.SchoolIdentifierSea,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_TOT6
		FROM #c002staging c
		LEFT JOIN #excludedSchools esch
			ON c.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reported Schools
		AND IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS', 'HH_1', 'PPPS_1')
		GROUP BY 
			c.SchoolIdentifierSea,
			IDEAEducationalEnvironmentForSchoolAge
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'Educational Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT6 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'ST6'

		DROP TABLE #SCH_TOT6

		
		/**********************************************************************
		Test Case 34:
		Subtotal 7 at the SEA level
		Student Count by:
			Age
			IDEAEducationalEnvironmentForSchoolAge
		***********************************************************************/
		SELECT 
			s.AgeValue,
			s.IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_TOT7
		FROM #c002staging s
		GROUP BY 
			  AgeValue
			, IDEAEducationalEnvironmentForSchoolAge
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
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
			c.LeaIdentifierSeaAccountability,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT7
		FROM #c002staging c
		LEFT JOIN #excludedLeas elea
			ON c.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		GROUP BY 
			c.LeaIdentifierSeaAccountability,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			+ 'Age: ' + cast(s.AgeValue as varchar(2))
			+ 'Educational Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT7 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
			AND convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
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
			c.SchoolIdentifierSea,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_TOT7
		FROM #c002staging c
		LEFT JOIN #excludedSchools esch
			ON c.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reported Schools
		AND IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS', 'HH_1', 'PPPS_1')
		GROUP BY 
			c.SchoolIdentifierSea,
			AgeValue,
			IDEAEducationalEnvironmentForSchoolAge
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			+ 'Age: ' + cast(s.AgeValue as varchar(2))
			+ 'Educational Environment: ' + s.IDEAEducationalEnvironmentForSchoolAge
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT7 s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON 
			s.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea
			AND convert(varchar, S.AgeValue) = case when rreksd.AGE = 'AGE05K' then '5' else rreksd.AGE end
			AND s.IDEAEducationalEnvironmentForSchoolAge = rreksd.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE
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
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #S_TOT
		FROM #c002staging s
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
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
			c.LeaIdentifierSeaAccountability,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #L_TOT
		FROM #c002staging c
		LEFT JOIN #excludedLeas elea
			ON c.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
		WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
		GROUP BY 
			c.LeaIdentifierSeaAccountability
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #L_TOT s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
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
			c.SchoolIdentifierSea,
			COUNT(DISTINCT StudentIdentifierState) AS StudentCount
		INTO #SCH_TOT
		FROM #c002staging c
		LEFT JOIN #excludedSchools esch
			ON c.SchoolIdentifierSea = esch.SchoolIdentifierSea
		WHERE esch.SchoolIdentifierSea IS NULL -- exclude non reported Schools
		AND IDEAEducationalEnvironmentForSchoolAge NOT IN ('HH', 'PPPS', 'HH_1', 'PPPS_1')
		GROUP BY 
			c.SchoolIdentifierSea
		
		INSERT INTO App.SqlUnitTestCaseResult (
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
			,'SchoolIdentifierSea: ' + s.SchoolIdentifierSea + '  '
			,s.StudentCount
			,rreksd.StudentCount
			,CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #SCH_TOT s
		INNER JOIN RDS.ReportEDFactsK12StudentCounts rreksd 
			ON s.SchoolIdentifierSea = rreksd.OrganizationIdentifierSea
			AND rreksd.ReportCode = 'c002' 
			AND rreksd.ReportYear = @SchoolYear
			AND rreksd.ReportLevel = 'SCH'
			AND rreksd.CategorySetCode = 'TOT'

		DROP TABLE #SCH_TOT

	-- select *
	-- from App.SqlUnitTestCaseResult sr
	-- 	inner join App.SqlUnitTest s
	-- 		on s.SqlUnitTestId = sr.SqlUnitTestId
	-- where s.UnitTestName like '%002%'
	-- and passed = 0
	-- and convert(date, TestDateTime) = convert(date, GETDATE())

-- IF THE TEST PRODUCES NO RESULTS INSERT A RECORD TO INDICATE THIS -------------------------
if not exists(select top 1 * from app.sqlunittest t
	inner join app.SqlUnitTestCaseResult r
		on t.SqlUnitTestId = r.SqlUnitTestId
		and t.SqlUnitTestId = @SqlUnitTestId)
begin
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
				,'NO TEST RESULTS'
				,'NO TEST RESULTS'
				,-1
				,-1
				,-1
				,GETDATE()
end
----------------------------------------------------------------------------------

END