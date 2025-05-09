CREATE PROCEDURE [App].[FS007_TestCase]
	@SchoolYear SMALLINT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C007Staging') IS NOT NULL
	DROP TABLE #C007Staging
	IF OBJECT_ID('tempdb..#C007staging_LEA') IS NOT NULL
	DROP TABLE #C007staging_LEA

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

	IF OBJECT_ID('tempdb..#vwIdeaStatuses') IS NOT NULL
	DROP TABLE #vwIdeaStatuses

	--'#C007Staging'
	IF OBJECT_ID('tempdb..#C007Staging') IS NOT NULL
	DROP TABLE #C007Staging

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
	
	--Create SY Start / SY End variables
	declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
	declare @SYEnd varchar(10) = CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)

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

	--Get the LEAs that should not be reported against
	IF OBJECT_ID('tempdb..#excludedLeas') IS NOT NULL
	DROP TABLE #excludedLeas

	CREATE TABLE #excludedLeas (
		LeaIdentifierSeaAccountability		VARCHAR(20)
	)

	INSERT INTO #excludedLeas 
	SELECT DISTINCT LEAIdentifierSea
	FROM Staging.K12Organization sko
	LEFT JOIN Staging.OrganizationPhone sop
			ON sko.LEAIdentifierSea = sop.OrganizationIdentifier
			AND sop.OrganizationType in (	SELECT InputCode
										FROM Staging.SourceSystemReferenceData 
										WHERE TableName = 'RefOrganizationType' 
											AND TableFilter = '001156'
											AND OutputCode = 'LEA' AND SchoolYear = @SchoolYear)
	WHERE LEA_IsReportedFederally = 0
		OR LEA_OperationalStatus in ('Closed', 'FutureAgency', 'Inactive', 'Closed_1', 'FutureAgency_1', 'Inactive_1', 'MISSING')
		OR sop.OrganizationIdentifier IS NULL

	IF OBJECT_ID('tempdb..#sppse') IS NOT NULL
	DROP TABLE #sppse

	SELECT 
		  StudentIdentifierState
		, LeaIdentifierSeaAccountability
		, SchoolIdentifierSea
		, ProgramParticipationBeginDate
		, ProgramParticipationEndDate
		, IDEAEducationalEnvironmentForEarlyChildhood
		, IDEAEducationalEnvironmentForSchoolAge
	INTO #sppse
	FROM Staging.ProgramParticipationSpecialEducation
	WHERE IDEAIndicator = 1

	CREATE INDEX IX_sppse ON #sppse(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea) INCLUDE (ProgramParticipationBeginDate, ProgramParticipationEndDate)

	--create the race view to handle the conversion to Multiple Races
	IF OBJECT_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces

	SELECT * 
	INTO #vwRaces 
	FROM RDS.vwDimRaces
	WHERE SchoolYear = @SchoolYear

	CREATE CLUSTERED INDEX ix_tempvwRaces ON #vwRaces (RaceMap);

	-- Gather, evaluate & record the results
	SELECT DISTINCT 
		ske.StudentIdentifierState
		, ske.LeaIdentifierSeaAccountability
		, ske.SchoolIdentifierSea
		, sppse.ProgramParticipationEndDate
		, ske.Birthdate
		--, [RDS].[Get_Age](ske.BirthDate, DATEADD(year, -1, cast(sd.DisciplinaryActionStartDate as varchar(10)))) Age
		, CASE sidt.IdeaDisabilityTypeCode
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
			ELSE sidt.IdeaDisabilityTypeCode
           -- ELSE ISNULL(idea.IdeaDisabilityTypeCode, 'MISSING')
		END AS IDEADISABILITYTYPE
		, ske.HispanicLatinoEthnicity
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
		, ske.Sex
		, CASE ske.Sex
			WHEN 'Male' THEN 'M'
			WHEN 'Female' THEN 'F'
			WHEN 'Male_1' THEN 'M'
			WHEN 'Female_1' THEN 'F'
			ELSE 'MISSING'
			END AS SexEdFactsCode
		, CASE
					WHEN sd.DisciplinaryActionStartDate BETWEEN sps.EnglishLearner_StatusStartDate AND ISNULL(sps.EnglishLearner_StatusEndDate, GETDATE()) THEN EnglishLearnerStatus
					ELSE 0
					END AS EnglishLearnerStatus
		, CASE
			WHEN ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
				BETWEEN ISNULL(sps.EnglishLearner_StatusStartDate, @SYStart)  
					AND ISNULL(sps.EnglishLearner_StatusEndDate, @SYEnd) 
				THEN 
				CASE 
					WHEN EnglishLearnerStatus = 1 THEN 'LEP'
					WHEN ISNULL(EnglishLearnerStatus, 0) = 0 THEN 'NLEP'
					ELSE 'NLEP'
				END
			ELSE 'MISSING'
			END AS EnglishLearnerStatusEdFactsCode
		, sd.IncidentIdentifier
		, sd.DisciplinaryActionTaken
		, sd.IdeaInterimRemoval
		, CASE sd.IdeaInterimRemoval
			WHEN 'REMDW' THEN 'REMDW'
			WHEN 'REMHO' THEN 'REMHO'
			WHEN 'REMDW_1' THEN 'REMDW'
			WHEN 'REMHO_1' THEN 'REMHO'
			ELSE 'MISSING'
		END AS IdeaInterimRemovalEdFactsCode
		, sd.IdeaInterimRemovalReason
		, CASE sd.IdeaInterimRemovalReason
			WHEN 'Drugs' THEN 'D'
			WHEN 'Weapons' THEN 'W'
			WHEN 'SeriousBodilyInjury' THEN 'SBI'
			WHEN 'Drugs_1' THEN 'D'
			WHEN 'Weapons_1' THEN 'W'
			WHEN 'SeriousBodilyInjury_1' THEN 'SBI'
			ELSE 'MISSING'
		END as IdeaInterimRemovalReasonEdFactsCode
		, convert(int, round(cast(sd.DurationOfDisciplinaryAction as decimal(5,2)),0,0)) DurationOfDisciplinaryAction
		,DisciplinaryActionStartDate
	INTO #C007Staging
	FROM Staging.K12Enrollment ske
	JOIN Staging.Discipline sd
		ON sd.StudentIdentifierState = ske.StudentIdentifierState
		AND ISNULL(sd.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sd.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(ske.EnrollmentEntryDate, @SYStart) and ISNULL (ske.EnrollmentExitDate, @SYEnd)
	JOIN #sppse sppse
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
		--Discipline Date within IDEA range
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(sps.EnglishLearner_StatusStartDate, @SYStart) AND ISNULL (sps.EnglishLearner_StatusEndDate, @SYEnd)
	LEFT JOIN Staging.IdeaDisabilityType sidt
        ON sppse.StudentIdentifierState = sidt.StudentIdentifierState
        AND ISNULL(sppse.LeaIdentifierSeaAccountability, '') = ISNULL(sidt.LeaIdentifierSeaAccountability, '')
        AND ISNULL(sppse.SchoolIdentifierSea, '') = ISNULL(sidt.SchoolIdentifierSea, '')
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
	WHERE ske.Schoolyear = CAST(@SchoolYear as varchar)
		AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge, '') NOT IN ('PPPS', 'PPPS_1')
		AND sd.IdeaInterimRemoval in ('REMDW', 'REMDW_1')
--			AND ske.GradeLevel in ('KG', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
		AND rds.Get_Age(ske.Birthdate, DATEFROMPARTS
			(CASE WHEN @cutOffMonth >= 7 THEN @SchoolYear - 1 
					ELSE @SchoolYear 
				END, @cutOffMonth, @cutOffDay
			)
		) BETWEEN 3 AND 21	
		--Enrollment Date with SY range 
		AND CAST(ISNULL(ske.EnrollmentEntryDate, '1900-01-01') AS DATE) 
            BETWEEN @SYStart AND @SYEnd 
		--Discipline Date within Enrollment range
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEnd)


	/**********************************************************************
		Test Case 1:
		CSA at the SEA level - Student Count by Interim Removal Reason (IDEA) by Disability Category (IDEA)
	***********************************************************************/
	SELECT 
		IdeaInterimRemovalReasonEdFactsCode
		, IDEADISABILITYTYPE
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #S_CSA
	FROM #C007Staging 
	WHERE IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	and IdeaInterimRemovalReasonEdFactsCode IS NOT NULL
	GROUP BY IdeaInterimRemovalReasonEdFactsCode
		, IDEADISABILITYTYPE

	INSERT INTO App.SqlUnitTestCaseResult (
		[SqlUnitTestId]
		, [TestCaseName]
		, [TestCaseDetails]
		, [ExpectedResult]
		, [ActualResult]
		, [Passed]
		, [TestDateTime]
	)
	SELECT 
		@SqlUnitTestId
		, 'CSA SEA Match All'
		, 'CSA SEA Match All - IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			+ '; Disability Type: ' + s.IDEADISABILITYTYPE
		, s.IncidentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAINTERIMREMOVALREASON
		AND s.IDEADISABILITYTYPE = rreksd.IDEADISABILITYTYPE
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSA'
	where s.IDEADISABILITYTYPE IS NOT NULL

	DROP TABLE #S_CSA

	/**********************************************************************
		Test Case 2:
		CSB at the SEA level - Student Count by Interim Removal Reason (IDEA) by Racial Ethnic
	***********************************************************************/
	SELECT 
		IdeaInterimRemovalReasonEdFactsCode
		, RaceEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #S_CSB
	FROM #C007Staging 
	WHERE IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
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
	FROM #S_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND s.RaceEdFactsCode = rreksd.Race
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSB'
	
	DROP TABLE #S_CSB

	/**********************************************************************
		Test Case 3:
		CSC at the SEA level - Student Count by Interim Removal Reason (IDEA) by Sex (Membership)
	***********************************************************************/
	SELECT 
		IdeaInterimRemovalReasonEdFactsCode
		, SexEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #S_CSC
	FROM #C007Staging 
	WHERE IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	AND SexEdFactsCode <> 'MISSING'
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
	FROM #S_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND s.SexEdFactsCode = rreksd.Sex
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSC'
	
	DROP TABLE #S_CSC

		
	/**********************************************************************
		Test Case 4:
		CSD at the SEA level - Student Count by Interim Removal Reason (IDEA) by English Learner Status (Both)
	***********************************************************************/
	SELECT 
		IdeaInterimRemovalReasonEdFactsCode
		, EnglishLearnerStatusEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #S_CSD
	FROM #C007Staging 
	WHERE IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	and EnglishLearnerStatusEdFactsCode <> 'MISSING'
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
	FROM #S_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSD'
	
	DROP TABLE #S_CSD


	/**********************************************************************
		Test Case 5:
		ST1 at the SEA level - Student Count by Interim Removal Reason (IDEA)
	***********************************************************************/
	SELECT 
		IdeaInterimRemovalReasonEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #S_ST1
	FROM #C007Staging 
	WHERE IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
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
	FROM #S_ST1 s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'ST1'
	
	DROP TABLE #S_ST1

		
	----------------------------------------
	--- LEA level tests					 ---
	----------------------------------------
	/**********************************************************************
		Test Case 7:
		CSA at the LEA level - Student Count by Interim Removal Reason (IDEA) by Disability Category (IDEA)
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, IdeaInterimRemovalReasonEdFactsCode
		, IDEADISABILITYTYPE
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #L_CSA
	FROM #C007staging s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	AND IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	AND IDEADISABILITYTYPE <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
		, IdeaInterimRemovalReasonEdFactsCode
		, IDEADISABILITYTYPE

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
			+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			+ '; Disability Type: ' + s.IDEADISABILITYTYPE
		,s.IncidentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAINTERIMREMOVALREASON
		AND s.IDEADISABILITYTYPE = rreksd.IDEADISABILITYTYPE
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSA'
	
	DROP TABLE #L_CSA


	/**********************************************************************
		Test Case 8:
		CSB at the LEA level - Student Count by Interim Removal Reason (IDEA) by Racial Ethnic
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, IdeaInterimRemovalReasonEdFactsCode
		, RaceEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #L_CSB
	FROM #C007staging s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	AND IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
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
		,'CSB LEA Match All - LEA Identifier - ' + s.LeaIdentifierSeaAccountability
			+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			+ '; Race: ' + s.RaceEdFactsCode
		,s.IncidentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND s.RaceEdFactsCode = rreksd.Race
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSB'
	
	DROP TABLE #L_CSB

		
	/**********************************************************************
		Test Case 9:
		CSC at the SEA level - Student Count by Interim Removal Reason (IDEA) by Sex (Membership)
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, IdeaInterimRemovalReasonEdFactsCode
		, SexEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #L_CSC
	FROM #C007staging s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	AND SexEdFactsCode <> 'MISSING'
	AND IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
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
		,'CSC LEA Match All - LEA Identifier - ' + s.LeaIdentifierSeaAccountability
			+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			+ '; Sex: ' + s.SexEdFactsCode
		,s.IncidentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND s.SexEdFactsCode = rreksd.Sex
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSC'
	
	DROP TABLE #L_CSC


	/**********************************************************************
		Test Case 10:
		CSD at the LEA level - Student Count by Interim Removal Reason (IDEA) by English Learner Status (Both)
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, IdeaInterimRemovalReasonEdFactsCode
		, EnglishLearnerStatusEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #L_CSD
	FROM #C007staging s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	AND IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	and EnglishLearnerStatusEdFactsCode <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
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
		,'CSD LEA Match All - LEA Identifier - ' + s.LeaIdentifierSeaAccountability
			+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
			+ '; English Learner: ' + s.EnglishLearnerStatusEdFactsCode
		,s.IncidentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
		AND rreksd.ReportCode = 'C007' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSD'
	
	DROP TABLE #L_CSD

	/**********************************************************************
		Test Case 11:
		ST1 at the LEA level - Student Count by Interim Removal Reason (IDEA)
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, IdeaInterimRemovalReasonEdFactsCode
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #L_ST1
	FROM #C007staging s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	AND IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
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
		,'ST1 LEA Match All - LEA Identifier - ' + s.LeaIdentifierSeaAccountability
			+ '; IDEA Removal Reason: ' + s.IdeaInterimRemovalReasonEdFactsCode
		,s.IncidentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_ST1 s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND s.IdeaInterimRemovalReasonEdFactsCode  = rreksd.IDEAInterimRemovalReason
		AND rreksd.ReportCode = 'C007' 
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
		INSERT INTO App.SqlUnitTestCaseResult (
			[SqlUnitTestId]
			, [TestCaseName]
			, [TestCaseDetails]
			, [ExpectedResult]
			, [ActualResult]
			, [Passed]
			, [TestDateTime]
		)
		SELECT DISTINCT
			@SqlUnitTestId
			, 'NO TEST RESULTS'
			, 'NO TEST RESULTS'
			, -1
			, -1
			, 0
			, GETDATE()
	end

	--check test records	
	--  select *
	--  from App.SqlUnitTestCaseResult sr
	--  	inner join App.SqlUnitTest s
	--  		on s.SqlUnitTestId = sr.SqlUnitTestId
	--  where s.UnitTestName like '%007%'
	--  and passed = 0
	--  and convert(date, TestDateTime) = convert(date, GETDATE())

END
