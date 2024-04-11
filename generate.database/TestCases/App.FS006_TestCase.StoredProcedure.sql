CREATE PROCEDURE [App].[FS006_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C006Staging') IS NOT NULL
	DROP TABLE #C006Staging

	IF OBJECT_ID('tempdb..#S_CSA') IS NOT NULL
	DROP TABLE #S_CSA
	IF OBJECT_ID('tempdb..#S_CSB') IS NOT NULL
	DROP TABLE #S_CSB
	IF OBJECT_ID('tempdb..#S_CSC') IS NOT NULL
	DROP TABLE #S_CSC
	IF OBJECT_ID('tempdb..#S_CSD') IS NOT NULL
	DROP TABLE #S_CSD
	IF OBJECT_ID('tempdb..#S_ST1') IS NOT NULL
	DROP TABLE #S_ST1

	IF OBJECT_ID('tempdb..#L_CSA') IS NOT NULL
	DROP TABLE #L_CSA
	IF OBJECT_ID('tempdb..#L_CSB') IS NOT NULL
	DROP TABLE #L_CSB
	IF OBJECT_ID('tempdb..#L_CSC') IS NOT NULL
	DROP TABLE #L_CSC
	IF OBJECT_ID('tempdb..#L_CSD') IS NOT NULL
	DROP TABLE #L_CSD
	IF OBJECT_ID('tempdb..#L_ST1') IS NOT NULL
	DROP TABLE #L_ST1

	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT

	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS006_UnitTestCase') 
	BEGIN
		SET @expectedResult = 1
		INSERT INTO App.SqlUnitTest (
			[UnitTestName]
			, [StoredProcedureName]
			, [TestScope]
			, [IsActive]
		)
		VALUES (
			'FS006_UnitTestCase'
			, 'FS006_TestCase'				
			, 'FS006'
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
		WHERE UnitTestName = 'FS006_UnitTestCase'
	END

	-- Clear out last run
	DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
	
	--Create SY Start / SY End variables
	declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
	declare @SYEnd varchar(10) = CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)

	-- Get Custom Child Count Date
	DECLARE @cutOffMonth INT, @cutOffDay INT, @customFactTypeDate VARCHAR(10), @childCountDate date
	set @cutOffMonth = 11
	set @cutOffDay = 1

	select @customFactTypeDate = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CHDCTDTE'

	select @cutOffMonth = SUBSTRING(@customFactTypeDate, 0, CHARINDEX('/', @customFactTypeDate))
	select @cutOffDay = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)

    select @ChildCountDate = convert(varchar, @CutoffMonth) + '/' + convert(varchar, @CutoffDay) + '/' + convert(varchar, @SchoolYear -1)

	--create the race view to handle the conversion to Multiple Races
	IF OBJECT_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces

	SELECT * 
	INTO #vwRaces 
	FROM RDS.vwDimRaces
	WHERE SchoolYear = @SchoolYear

	CREATE CLUSTERED INDEX ix_tempvwRaces ON #vwRaces (RaceMap);

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

	-- Gather, evaluate & record the results
	SELECT  
		ske.StudentIdentifierState
		, ske.LeaIdentifierSeaAccountability
		, ske.SchoolIdentifierSea
		, ske.Birthdate
		, ske.HispanicLatinoEthnicity
		, ske.Sex
		, CASE ske.Sex
			WHEN 'Male'		THEN 'M'
			WHEN 'Female'	THEN 'F'
			WHEN 'Male_1'		THEN 'M'
			WHEN 'Female_1'	THEN 'F'
			ELSE 'MISSING'
			END AS SexEdFactsCode
		, sppse.ProgramParticipationEndDate
		, CASE sidt.IdeaDisabilityTypeCode
			WHEN 'Autism'						THEN 'AUT'
            WHEN 'Deafblindness'				THEN 'DB'
            WHEN 'Deafness'						THEN 'DB'
            WHEN 'Developmentaldelay'			THEN 'DD'
            WHEN 'Emotionaldisturbance'			THEN 'EMN'
            WHEN 'Hearingimpairment'			THEN 'HI'
            WHEN 'Intellectualdisability'		THEN 'ID'
            WHEN 'Multipledisabilities'			THEN 'MD'
            WHEN 'Orthopedicimpairment'			THEN 'OI'
            WHEN 'Otherhealthimpairment'		THEN 'OHI'
            WHEN 'Specificlearningdisability'	THEN 'SLD'
            WHEN 'Speechlanguageimpairment'		THEN 'SLI'
            WHEN 'Traumaticbraininjury'			THEN 'TBI'
            WHEN 'Visualimpairment'				THEN 'VI'
            WHEN 'Autism_1'						THEN 'AUT'
            WHEN 'Deafblindness_1'				THEN 'DB'
            WHEN 'Deafness_1'					THEN 'DB'
            WHEN 'Developmentaldelay_1'			THEN 'DD'
            WHEN 'Emotionaldisturbance_1'		THEN 'EMN'
            WHEN 'Hearingimpairment_1'			THEN 'HI'
            WHEN 'Intellectualdisability_1'		THEN 'ID'
            WHEN 'Multipledisabilities_1'		THEN 'MD'
            WHEN 'Orthopedicimpairment_1'		THEN 'OI'
            WHEN 'Otherhealthimpairment_1'		THEN 'OHI'
            WHEN 'Specificlearningdisability_1' THEN 'SLD'
            WHEN 'Speechlanguageimpairment_1'	THEN 'SLI'
            WHEN 'Traumaticbraininjury_1'		THEN 'TBI'
            WHEN 'Visualimpairment_1'			THEN 'VI'
            ELSE sidt.IdeaDisabilityTypeCode
		END AS IdeaDisabilityType
		, spr.RaceMap
		, CASE 
			WHEN ske.HispanicLatinoEthnicity = 1 THEN 'HI7' 
			WHEN spr.RaceMap = 'AmericanIndianorAlaskaNative' THEN 'AM7'
			WHEN spr.RaceMap = 'Asian' THEN 'AS7'
			WHEN spr.RaceMap = 'BlackorAfricanAmerican' THEN 'BL7'
			WHEN spr.RaceMap = 'NativeHawaiianorOtherPacificIslander' THEN 'PI7'
			WHEN spr.RaceMap = 'White' THEN 'WH7'
			WHEN spr.RaceMap = 'TwoorMoreRaces' THEN 'MU7'
			WHEN spr.RaceMap = 'AmericanIndianorAlaskaNative_1' THEN 'AM7'
			WHEN spr.RaceMap = 'Asian_1' THEN 'AS7'
			WHEN spr.RaceMap = 'BlackorAfricanAmerican_1' THEN 'BL7'
			WHEN spr.RaceMap = 'NativeHawaiianorOtherPacificIslander_1' THEN 'PI7'
			WHEN spr.RaceMap = 'White_1' THEN 'WH7'
			WHEN spr.RaceMap = 'TwoorMoreRaces_1' THEN 'MU7'
		END AS RaceEdFactsCode
		, CASE
			WHEN ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
				BETWEEN ISNULL(sps.EnglishLearner_StatusStartDate, @SYStart) AND ISNULL(sps.EnglishLearner_StatusEndDate, @SYEnd) 
					THEN ISNULL(EnglishLearnerStatus, 0)
			ELSE 0
			END AS EnglishLearnerStatus
		, CASE
			WHEN ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
				BETWEEN ISNULL(sps.EnglishLearner_StatusStartDate, @SYStart) AND ISNULL(sps.EnglishLearner_StatusEndDate, @SYEnd) 
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
	INTO #C006Staging
	FROM Staging.K12Enrollment ske
	JOIN Staging.Discipline sd
		ON sd.StudentIdentifierState = ske.StudentIdentifierState
		AND ISNULL(sd.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sd.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(ske.EnrollmentEntryDate, @SYStart) and ISNULL (ske.EnrollmentExitDate, @SYEnd)
	JOIN Staging.ProgramParticipationSpecialEducation sppse
		ON sppse.StudentIdentifierState = ske.StudentIdentifierState
		AND ISNULL(sppse.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sppse.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
		--Discipline Date within Program Participation range
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(sppse.ProgramParticipationBeginDate, @SYStart) AND ISNULL(sppse.ProgramParticipationEndDate, @SYEnd)
	LEFT JOIN Staging.PersonStatus sps
		ON sps.StudentIdentifierState = sd.StudentIdentifierState
		AND ISNULL(sps.LeaIdentifierSeaAccountability, '') = ISNULL(sd.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sps.SchoolIdentifierSea, '') = ISNULL(sd.SchoolIdentifierSea, '')
		--Discipline Date within English Learner range
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(sps.EnglishLearner_StatusStartDate, @SYStart) and ISNULL (sps.EnglishLearner_StatusEndDate, @SYEnd)
	LEFT JOIN Staging.IdeaDisabilityType sidt
        ON ske.StudentIdentifierState = sidt.StudentIdentifierState
        AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(sidt.LeaIdentifierSeaAccountability, '')
        AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(sidt.SchoolIdentifierSea, '')
        AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE)  
			BETWEEN sidt.RecordStartDateTime AND ISNULL(sidt.RecordEndDateTime, @SYEnd)
        AND sidt.IsPrimaryDisability = 1
	LEFT JOIN RDS.vwUnduplicatedRaceMap spr --  Using a view that resolves multiple race records by returning the value TwoOrMoreRaces
		ON spr.SchoolYear = @SchoolYear
		AND ske.StudentIdentifierState = spr.StudentIdentifierState
		AND ISNULL(ske.LEAIdentifierSeaAccountability,'')	= ISNULL(spr.LeaIdentifierSeaAccountability,'')
		AND ISNULL(ske.SchoolIdentifierSea,'') 				= ISNULL(spr.SchoolIdentifierSea,'')
	LEFT JOIN #vwRaces rdr
		ON rdr.SchoolYear = @SchoolYear
		AND ISNULL(rdr.RaceMap, rdr.RaceCode) =
			CASE
				WHEN ske.HispanicLatinoEthnicity = 1 THEN 'HispanicorLatinoEthnicity'
				WHEN spr.RaceMap IS NOT NULL THEN spr.RaceMap
				ELSE 'Missing'
			END
	WHERE sppse.IDEAIndicator = 1
		AND ske.Schoolyear = CAST(@SchoolYear AS VARCHAR)
		AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge, '') NOT IN ('PPPS', 'PPPS_1')
		AND ISNULL(sd.DisciplineMethodOfCwd, '') in ('InSchool','OutOfSchool', 'InSchool_1','OutOfSchool_1')
		AND ISNULL(sd.IdeaInterimRemoval, '') NOT IN ('REMDW', 'REMHO', 'REMDW_1', 'REMHO_1')
		AND rds.Get_Age(ske.Birthdate, @ChildCountDate) BETWEEN 3 AND 21	
		--Discipline Date with SY range 
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN @SYStart AND @SYEnd

--temp fix to address bad test records
	AND ske.StudentIdentifierState not like 'CIID%'

	--Set the EDFacts value for removal length
	UPDATE s
	SET s.RemovalLength = tmp.RemovalLength
	FROM #C006Staging s
		INNER JOIN (
				SELECT StudentIdentifierState, DisciplineMethod
					,CASE 
						WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) >= 0.5 
							and sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) <= 10 THEN 'LTOREQ10'
						WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) > 10 THEN 'GREATER10'
						ELSE 'MISSING'
					END AS RemovalLength
				FROM #C006Staging 
				GROUP BY StudentIdentifierState, DisciplineMethod
		) tmp
			ON s.StudentIdentifierState =  tmp.StudentIdentifierState
			AND s.DisciplineMethod = tmp.DisciplineMethod

	--Set the EDFacts value for removal length for the LEP status
	UPDATE s
	SET s.LEPRemovalLength = tmp.LEPRemovalLength
	FROM #C006Staging s
		INNER JOIN (
				SELECT StudentIdentifierState, DisciplineMethod, EnglishLearnerStatusEdFactsCode
					,CASE 
						WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) >= 0.5 
							and sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) <= 10 THEN 'LTOREQ10'
						WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) > 10 THEN 'GREATER10'
						ELSE 'MISSING'
					END AS LEPRemovalLength
				FROM #C006Staging 
				GROUP BY StudentIdentifierState, DisciplineMethod, EnglishLearnerStatusEdFactsCode
		) tmp
			ON s.StudentIdentifierState = tmp.StudentIdentifierState
			AND s.DisciplineMethod = tmp.DisciplineMethod
			AND s.EnglishLearnerStatusEdFactsCode = tmp.EnglishLearnerStatusEdFactsCode

	/**********************************************************************
		Test Case 1:
		CSA at the SEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by Disability Category (IDEA)
	***********************************************************************/
	SELECT 
		DisciplineMethod
		, RemovalLength
		, IdeaDisabilityType
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSA
	FROM #C006Staging 
	WHERE RemovalLength <> 'MISSING'
	GROUP BY DisciplineMethod
		, RemovalLength
		, IdeaDisabilityType

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
		,'CSA SEA Match All - Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Disability Type: ' + s.IdeaDisabilityType
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON replace(s.DisciplineMethod, '_1', '')  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND s.IdeaDisabilityType = rreksd.IdeaDisabilityType
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSA'

	DROP TABLE #S_CSA

	/**********************************************************************
		Test Case 2:
		CSB at the SEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by Racial Ethnic
	***********************************************************************/
	SELECT 
		DisciplineMethod
		, RemovalLength
		, RaceEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSB
	FROM #C006Staging 
	WHERE RemovalLength <> 'MISSING'
	GROUP BY DisciplineMethod
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
		,'CSB SEA Match All'
		,'CSB SEA Match All - Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Race: ' + s.RaceEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON replace(s.DisciplineMethod, '_1', '')  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND s.RaceEdFactsCode = rreksd.Race
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSB'
	
	DROP TABLE #S_CSB

		
	/**********************************************************************
		Test Case 3:
		CSC at the SEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by Sex (Membership)
	***********************************************************************/
	SELECT 
		DisciplineMethod
		, RemovalLength
		, SexEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSC
	FROM #C006Staging 
	WHERE RemovalLength <> 'MISSING'
	AND SexEdFactsCode <> 'MISSING'
	GROUP BY DisciplineMethod
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
		,'CSC SEA Match All'
		,'CSC SEA Match All - Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Sex: ' + s.SexEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON replace(s.DisciplineMethod, '_1', '')  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND s.SexEdFactsCode = rreksd.Sex
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSC'
	
	DROP TABLE #S_CSC

		
	/**********************************************************************
		Test Case 4:
		CSD at the SEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by English Learner Status (Both)
	***********************************************************************/
	SELECT 
		DisciplineMethod
		, LEPRemovalLength
		, EnglishLearnerStatusEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSD
	FROM #C006Staging 
	WHERE LEPRemovalLength <> 'MISSING'
	GROUP BY DisciplineMethod
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
		,'CSD SEA Match All'
		,'CSD SEA Match All - Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.LEPRemovalLength 
			+ '; English Learner: ' + s.EnglishLearnerStatusEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON replace(s.DisciplineMethod, '_1', '') = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.LEPRemovalLength = rreksd.RemovalLength
		AND s.EnglishLearnerStatusEdFactsCode = rreksd.EnglishLearnerStatus
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSD'
	
	DROP TABLE #S_CSD


	/**********************************************************************
		Test Case 5:
		ST1 at the SEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions)
	***********************************************************************/
	SELECT 
		DisciplineMethod
		, RemovalLength
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_ST1
	FROM #C006Staging 
	WHERE RemovalLength <> 'MISSING'
	GROUP BY DisciplineMethod
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
		,'ST1 SEA Match All'
		,'ST1 SEA Match All - Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_ST1 s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON replace(s.DisciplineMethod, '_1', '') = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'ST1'
	
	DROP TABLE #S_ST1


	----------------------------------------
	--- LEA level tests					 ---
	----------------------------------------
	/**********************************************************************
		Test Case 6:
		CSA at the LEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by Disability Category (IDEA)
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, DisciplineMethod
		, RemovalLength
		, IdeaDisabilityType
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSA
	FROM #C006Staging s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude invalid Op Status and Not Reported Federally
 	AND RemovalLength <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
		, DisciplineMethod
		, RemovalLength
		, IdeaDisabilityType

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
		,'CSA LEA Match All - LEA Identifier - ' + s.LeaIdentifierSeaAccountability
			+ '; Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Disability Type: ' + s.IdeaDisabilityType
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
		AND replace(s.DisciplineMethod, '_1', '')  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND s.IdeaDisabilityType = rreksd.IdeaDisabilityType
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSA'
	
	DROP TABLE #L_CSA


	/**********************************************************************
		Test Case 7:
		CSB at the LEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by Racial Ethnic
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, DisciplineMethod
		, RemovalLength
		, RaceEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSB
	FROM #C006Staging s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude invalid Op Status and Not Reported Federally
	AND RemovalLength <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
		, DisciplineMethod
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
		,'CSB LEA Match All - LEA Identifier - ' + s.LeaIdentifierSeaAccountability
			+ '; Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Race: ' + s.RaceEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
		AND replace(s.DisciplineMethod, '_1', '')  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND s.RaceEdFactsCode = rreksd.Race
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSB'
	
	DROP TABLE #L_CSB

		
	/**********************************************************************
		Test Case 8:
		CSC at the LEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by Sex (Membership)
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, DisciplineMethod
		, RemovalLength
		, SexEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSC
	FROM #C006Staging s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude invalid Op Status and Not Reported Federally
	AND RemovalLength <> 'MISSING'
	AND SexEdFactsCode <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
		, DisciplineMethod
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
		,'CSC LEA Match All - LEA Identifier - ' + s.LeaIdentifierSeaAccountability
			+ '; Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Sex: ' + s.SexEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
		AND replace(s.DisciplineMethod, '_1', '') = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND replace(s.SexEdFactsCode, '_1', '') = rreksd.Sex
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSC'
	
	DROP TABLE #L_CSC

		
	/**********************************************************************
		Test Case 9:
		CSD at the LEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions) by English Learner Status (Both)
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, DisciplineMethod
		, LEPRemovalLength
		, EnglishLearnerStatusEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSD
	FROM #C006Staging s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude invalid Op Status and Not Reported Federally
	AND LEPRemovalLength <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
		, DisciplineMethod
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
		,'CSD LEA Match All - LEA Identifier - ' + s.LeaIdentifierSeaAccountability
			+ '; Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.LEPRemovalLength 
			+ '; English Learner: ' + s.EnglishLearnerStatusEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
		AND replace(s.DisciplineMethod, '_1', '')  = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.LEPRemovalLength = rreksd.RemovalLength
		AND s.EnglishLearnerStatusEdFactsCode = rreksd.EnglishLearnerStatus
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSD'
	
	DROP TABLE #L_CSD


	/**********************************************************************
		Test Case 10:
		ST1 at the LEA level - Student Count by Discipline Method (Suspension/Expulsion) by Removal Length (Suspensions/Expulsions)
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, DisciplineMethod
		, RemovalLength
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_ST1
	FROM #C006Staging s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude invalid Op Status and Not Reported Federally
	AND RemovalLength <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
		, DisciplineMethod
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
		,'ST1 LEA Match All - LEA Identifier - ' + s.LeaIdentifierSeaAccountability
			+ '; Discipline Method: ' + s.DisciplineMethod
			+ '; RemovalLength: ' + s.RemovalLength 
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_ST1 s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.OrganizationIdentifierSea
		AND replace(s.DisciplineMethod, '_1', '') = rreksd.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES
		AND s.RemovalLength = rreksd.RemovalLength
		AND rreksd.ReportCode = 'C006' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'ST1'
	
	DROP TABLE #L_ST1
	
	-- IF THE TEST PRODUCES NO RESULTS INSERT A RECORD TO INDICATE THIS
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
			,NULL
			,GETDATE()
	end

	--check the results

	--select *
	--from App.SqlUnitTestCaseResult sr
	--	inner join App.SqlUnitTest s
	--		on s.SqlUnitTestId = sr.SqlUnitTestId
	--where s.UnitTestName like '%006%'
	--and passed = 0
	--and convert(date, TestDateTime) = convert(date, GETDATE())

END
