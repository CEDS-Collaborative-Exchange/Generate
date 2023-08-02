CREATE PROCEDURE [App].[FS007_TestCase]
	@SchoolYear SMALLINT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C007Staging') IS NOT NULL
	DROP TABLE #C007Staging

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
	IF OBJECT_ID('tempdb..#notReportedFederallyLeas') IS NOT NULL
	DROP TABLE #notReportedFederallyLeas

	CREATE TABLE #notReportedFederallyLeas (
		LeaIdentifierSeaAccountability		VARCHAR(20)
	)

	INSERT INTO #notReportedFederallyLeas 
	SELECT DISTINCT LeaIdentifierSea
	FROM Staging.K12Organization
	WHERE LEA_IsReportedFederally = 0

	IF OBJECT_ID('tempdb..#vwDisciplineStatuses') IS NOT NULL
	DROP TABLE #vwDisciplineStatuses

	SELECT * 
	INTO #vwDisciplineStatuses 
	FROM RDS.vwDimDisciplineStatuses 
	WHERE SchoolYear = @SchoolYear

	IF OBJECT_ID('tempdb..#vwIdeaStatuses') IS NOT NULL
	DROP TABLE #vwIdeaStatuses

	SELECT *
	INTO #vwIdeaStatuses
	FROM RDS.vwDimIdeaStatuses
	WHERE SchoolYear = @SchoolYear

	-- Gather, evaluate & record the results
	SELECT DISTINCT 
		ske.StudentIdentifierState
		, ske.LeaIdentifierSeaAccountability
		, ske.SchoolIdentifierSea
		, sppse.ProgramParticipationEndDate
		, ske.Birthdate
		--, [RDS].[Get_Age](ske.BirthDate, DATEADD(year, -1, cast(sd.DisciplinaryActionStartDate as varchar(10)))) Age
		, CASE idea.IdeaDisabilityTypeCode
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
           -- ELSE ISNULL(idea.IdeaDisabilityTypeCode, 'MISSING')
		END AS IDEADISABILITYTYPE
		, ske.HispanicLatinoEthnicity
		, spr.RaceType
		, CASE 
			WHEN ske.HispanicLatinoEthnicity = 1 THEN 'HI7' 
			WHEN spr.RaceType = 'AmericanIndianorAlaskaNative' THEN 'AM7'
			WHEN spr.RaceType = 'Asian' THEN 'AS7'
			WHEN spr.RaceType = 'BlackorAfricanAmerican' THEN 'BL7'
			WHEN spr.RaceType = 'NativeHawaiianorOtherPacificIslander' THEN 'PI7'
			WHEN spr.RaceType = 'White' THEN 'WH7'
			WHEN spr.RaceType = 'TwoorMoreRaces' THEN 'MU7'
		END AS RaceEdFactsCode
		, ske.Sex
		, CASE ske.Sex
			WHEN 'Male' THEN 'M'
			WHEN 'Female' THEN 'F'
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
	,DisciplinaryActionStartDate
	INTO #C007Staging
	FROM Staging.K12Enrollment ske
	JOIN Staging.Discipline sd
		ON sd.StudentIdentifierState = ske.StudentIdentifierState
		AND ISNULL(sd.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sd.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN ISNULL(ske.EnrollmentEntryDate, @SYStart) AND ISNULL (ske.EnrollmentExitDate, @SYEnd)
	LEFT JOIN Staging.PersonStatus sps
		ON sps.StudentIdentifierState = sd.StudentIdentifierState
		AND ISNULL(sps.LeaIdentifierSeaAccountability, '') = ISNULL(sd.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sps.SchoolIdentifierSea, '') = ISNULL(sd.SchoolIdentifierSea, '')
		--Discipline Date within IDEA range
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
		BETWEEN ISNULL(sps.EnglishLearner_StatusStartDate, @SYStart) AND ISNULL (sps.EnglishLearner_StatusEndDate, @SYEnd)
	LEFT JOIN Staging.ProgramParticipationSpecialEducation sppse
		ON sppse.StudentIdentifierState = ske.StudentIdentifierState
		AND ISNULL(sppse.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sppse.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
		--Discipline Date within Program Participation range
		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN ISNULL(sppse.ProgramParticipationBeginDate, @SYStart) AND ISNULL(sppse.ProgramParticipationEndDate, @SYEnd)
	LEFT JOIN Staging.K12PersonRace spr
		ON spr.StudentIdentifierState = ske.StudentIdentifierState
		AND spr.SchoolYear = ske.SchoolYear
		AND ISNULL(sppse.ProgramParticipationEndDate, spr.RecordStartDateTime) 
			BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, @SYEnd)
	LEFT JOIN Staging.IdeaDisabilityType idea
            ON ske.StudentIdentifierState = idea.StudentIdentifierState
            AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(idea.LeaIdentifierSeaAccountability, '')
            AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(idea.SchoolIdentifierSea, '')
            AND sd.DisciplinaryActionStartDate BETWEEN idea.RecordStartDateTime AND ISNULL(idea.RecordEndDateTime, GETDATE())
            AND idea.IsPrimaryDisability = 1
	LEFT JOIN RDS.DimRaces rdr
		ON (ske.HispanicLatinoEthnicity = 1 and rdr.RaceEdFactsCode = 'HI7')
			OR (ske.HispanicLatinoEthnicity = 0 AND spr.RaceType = rdr.RaceCode)
	LEFT JOIN #vwDisciplineStatuses rddisc
		ON rddisc.SchoolYear = @SchoolYear
		AND ISNULL(sd.DisciplinaryActionTaken, 'MISSING')						= ISNULL(rddisc.DisciplinaryActionTakenMap, rddisc.DisciplinaryActionTakenCode)
		AND ISNULL(sd.DisciplineMethodOfCwd, 'MISSING')                         = ISNULL(rddisc.DisciplineMethodOfChildrenWithDisabilitiesMap, rddisc.DisciplineMethodOfChildrenWithDisabilitiesCode)
		AND ISNULL(CAST(sd.EducationalServicesAfterRemoval AS SMALLINT), -1)   	= ISNULL(rddisc.EducationalServicesAfterRemovalMap, -1)
		AND ISNULL(sd.IdeaInterimRemoval, 'MISSING')                            = ISNULL(rddisc.IdeaInterimRemovalMap, rddisc.IdeaInterimRemovalCode)
		AND ISNULL(sd.IdeaInterimRemovalReason, 'MISSING')                      = ISNULL(rddisc.IdeaInterimRemovalReasonMap, rddisc.IdeaInterimRemovalReasonCode)
	LEFT JOIN RDS.DimDisciplineStatuses CAT_IDEAINTERIMREMOVAL on rddisc.DimDisciplineStatusId = CAT_IDEAINTERIMREMOVAL.DimDisciplineStatusId
	LEFT JOIN #vwIdeaStatuses rdis
				ON rdis.SchoolYear = @SchoolYear
				AND rdis.IdeaIndicatorCode = 'Yes'
				AND rdis.SpecialEducationExitReasonCode = 'MISSING'
				AND ISNULL(sppse.IDEAEducationalEnvironmentForEarlyChildhood,'MISSING') = ISNULL(rdis.IdeaEducationalEnvironmentForEarlyChildhoodMap, rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode)
				AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge,'MISSING') = ISNULL(rdis.IdeaEducationalEnvironmentForSchoolAgeMap, rdis.IdeaEducationalEnvironmentForSchoolAgeCode)

	LEFT JOIN rds.DimIdeaStatuses dis on rdis.DimIdeaStatusId = dis.DimIdeaStatusId
	WHERE ske.Schoolyear = CAST(@SchoolYear as varchar)
		--AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge, '') <> 'PPPS'
		AND CAST(ISNULL(ske.EnrollmentEntryDate, '1900-01-01') AS DATE) 
            BETWEEN @SYStart AND @SYEnd 
		and rdis.IdeaEducationalEnvironmentForSchoolAgeCode <> 'PPPS'
		--AND sd.IdeaInterimRemoval in ('REMDW')
		AND CAT_IDEAINTERIMREMOVAL.IdeaInterimRemovalEdFactsCode in ('REMDW')
--			AND ske.GradeLevel in ('KG', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
		--Discipline Date with SY range 

		AND ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') 
			BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEnd)
		AND rds.Get_Age(ske.Birthdate, DATEFROMPARTS(CASE WHEN @cutOffMonth >= 7 THEN @SchoolYear - 1 
														ELSE @SchoolYear 
													END, @cutOffMonth, @cutOffDay)
						) BETWEEN 3 AND 21	
		--Discipline Date within Enrollment range
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEnd)
		--Discipline Date with SY range 
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN @SYStart AND @SYEnd
	--Get the students that have more than 45 days removal time
	SELECT ske.StudentIdentifierState 
	INTO #tempDurationLengthExceeded
	FROM Staging.Discipline d 
	JOIN staging.K12Enrollment ske 
		ON d.StudentIdentifierState = ske.StudentIdentifierState
		AND ISNULL(d.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
		AND ISNULL(d.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
		AND CAST(ISNULL(d.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(ske.EnrollmentEntryDate, @SYStart) and ISNULL (ske.EnrollmentExitDate, @SYEnd) 
	JOIN Staging.ProgramParticipationSpecialEducation sppse
		ON ske.StudentIdentifierState 						= sppse.StudentIdentifierState
		AND ISNULL(ske.LEAIdentifierSeaAccountability,'') 	= ISNULL(sppse.LeaIdentifierSeaAccountability,'')
		AND ISNULL(ske.SchoolIdentifierSea,'') 				= ISNULL(sppse.SchoolIdentifierSea,'')
		AND d.DisciplinaryActionStartDate 
			BETWEEN sppse.ProgramParticipationBeginDate AND ISNULL(sppse.ProgramParticipationEndDate, @SYEnd)
			
		--idea disability type
	JOIN Staging.IdeaDisabilityType sidt         
		ON ske.SchoolYear = sidt.SchoolYear
		AND sidt.StudentIdentifierState 					= sppse.StudentIdentifierState
		AND ISNULL(sidt.LeaIdentifierSeaAccountability, '') = ISNULL(sppse.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sidt.SchoolIdentifierSea, '') 			= ISNULL(sppse.SchoolIdentifierSea, '')
		AND sidt.IsPrimaryDisability = 1
		AND d.DisciplinaryActionStartDate BETWEEN sidt.RecordStartDateTime AND ISNULL(sidt.RecordEndDateTime, GETDATE())

	WHERE d.IdeaInterimRemoval in ('REMDW')
	GROUP BY ske.StudentIdentifierState 
	HAVING SUM(CAST(DurationOfDisciplinaryAction AS DECIMAL(5, 2))) > 45

	--Remove the +45 day students from the staging data used for the test
	DELETE s
	FROM #C007Staging s
	LEFT JOIN #tempDurationLengthExceeded t
		ON s.StudentIdentifierState = t.StudentIdentifierState
	WHERE t.StudentIdentifierState is not null


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
		--Using a separate Staging table for LEA to only include the OPEN LEAs
	Select * 
	INTO #C007staging_LEA
	FROM #C007staging  s
	JOIN RDS.DimLeas o
	ON LeaIdentifierSeaAccountability = o.LeaIdentifierSea
	AND DisciplinaryActionStartDate BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, @SYEnd)
		and o.ReportedFederally = 1 
		and o.DimLeaId <> -1 
		and o.LEAOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING') AND CONVERT(date, o.OperationalStatusEffectiveDate, 101) between CONVERT(date, '07/01/2022', 101) AND CONVERT(date, '06/30/2023', 101)


	/**********************************************************************
		Test Case 7:
		CSA at the LEA level - Student Count by Interim Removal Reason (IDEA) by Disability Category (IDEA)
	*/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, IdeaInterimRemovalReasonEdFactsCode
		, IDEADISABILITYTYPE
		, COUNT(IncidentIdentifier) AS IncidentCount
	INTO #L_CSA
	FROM #C007staging_LEA s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
	WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
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
	FROM #C007staging_LEA s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
	WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
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
	FROM #C007staging_LEA s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
	WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
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
	FROM #C007staging_LEA s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
	WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
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
	FROM #C007staging_LEA s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
	WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
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

END
