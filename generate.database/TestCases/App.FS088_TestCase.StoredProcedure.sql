CREATE PROCEDURE [App].[FS088_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

	--clear the temp tables for the next run
	IF OBJECT_ID('tempdb..#C088Staging') IS NOT NULL
	DROP TABLE #C088Staging

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
	IF OBJECT_ID('tempdb..#S_TOT') IS NOT NULL
	DROP TABLE #S_TOT

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
	IF OBJECT_ID('tempdb..#L_TOT') IS NOT NULL
	DROP TABLE #L_TOT

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
	
	--Create SY Start / SY End variables
	declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
	declare @SYEnd varchar(10) = CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)

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
		OR LEA_OperationalStatus in ('Closed', 'FutureAgency', 'Inactive', 'MISSING','Closed_1', 'FutureAgency_1', 'Inactive_1', 'MISSING_1')

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

	IF OBJECT_ID('tempdb..#C088staging_LEA') IS NOT NULL
	DROP TABLE #C088staging_LEA
		IF OBJECT_ID('tempdb..#C088staging') IS NOT NULL
	DROP TABLE #C088staging

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

	SELECT  
		ske.StudentIdentifierState
		, ske.LeaIdentifierSeaAccountability
		, ske.SchoolIdentifierSea
		, sppse.ProgramParticipationEndDate
		, ske.Birthdate
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
			WHEN spr.RaceType = 'AmericanIndianorAlaskaNative_1' THEN 'AM7'
			WHEN spr.RaceType = 'Asian_1' THEN 'AS7'
			WHEN spr.RaceType = 'BlackorAfricanAmerican_1' THEN 'BL7'
			WHEN spr.RaceType = 'NativeHawaiianorOtherPacificIslander_1' THEN 'PI7'
			WHEN spr.RaceType = 'White_1' THEN 'WH7'
			WHEN spr.RaceType = 'TwoorMoreRaces_1' THEN 'MU7'
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
					WHEN CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE)  BETWEEN sps.EnglishLearner_StatusStartDate AND ISNULL(sps.EnglishLearner_StatusEndDate, GETDATE()) THEN EnglishLearnerStatus
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
		, sd.IdeaInterimRemoval
		, CASE sd.IdeaInterimRemoval
			WHEN 'REMDW' THEN 'REMDW'
			WHEN 'REMHO' THEN 'REMHO'
			WHEN 'REMDW_1' THEN 'REMDW'
			WHEN 'REMHO_1' THEN 'REMHO'
			ELSE 'MISSING'
		  END AS IdeaInterimRemovalEdFactsCode
		, sd.DisciplineMethodOfCwd AS DisciplineMethod
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
		, DurationOfDisciplinaryAction
		, '         ' as RemovalLength
		, '         ' as LEPRemovalLength
	,DisciplinaryActionStartDate
	INTO #C088Staging
	FROM Staging.K12Enrollment ske
	JOIN Staging.Discipline sd
		ON sd.StudentIdentifierState = ske.StudentIdentifierState
		AND ISNULL(sd.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sd.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(ske.EnrollmentEntryDate, @SYStart) AND ISNULL (ske.EnrollmentExitDate, @SYEnd)

	LEFT JOIN Staging.PersonStatus sps
		ON sps.StudentIdentifierState = sd.StudentIdentifierState
		AND ISNULL(sps.LeaIdentifierSeaAccountability, '') = ISNULL(sd.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sps.SchoolIdentifierSea, '') = ISNULL(sd.SchoolIdentifierSea, '')
		--Discipline Date within IDEA range
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(sps.EnglishLearner_StatusStartDate, @SYStart) AND ISNULL (sps.EnglishLearner_StatusEndDate, @SYEnd)

	JOIN #sppse sppse
		ON sppse.StudentIdentifierState = ske.StudentIdentifierState
		AND ISNULL(sppse.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sppse.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
		--Discipline Date within Program Participation range
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(sppse.ProgramParticipationBeginDate, @SYStart) AND ISNULL(sppse.ProgramParticipationEndDate, @SYEnd)

	LEFT JOIN Staging.K12PersonRace spr
		ON spr.StudentIdentifierState = ske.StudentIdentifierState
		AND spr.SchoolYear = ske.SchoolYear
		AND ISNULL(sppse.ProgramParticipationEndDate, spr.RecordStartDateTime) 
			BETWEEN spr.RecordStartDateTime AND ISNULL(spr.RecordEndDateTime, @SYEnd)

	LEFT JOIN Staging.IdeaDisabilityType idea
        ON sppse.StudentIdentifierState = idea.StudentIdentifierState
        AND ISNULL(sppse.LeaIdentifierSeaAccountability, '') = ISNULL(idea.LeaIdentifierSeaAccountability, '')
        AND ISNULL(sppse.SchoolIdentifierSea, '') = ISNULL(idea.SchoolIdentifierSea, '')
        AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE)  
			BETWEEN idea.RecordStartDateTime AND ISNULL(idea.RecordEndDateTime, GETDATE())
        AND idea.IsPrimaryDisability = 1

	LEFT JOIN RDS.DimRaces rdr
		ON (ske.HispanicLatinoEthnicity = 1 and rdr.RaceEdFactsCode = 'HI7')
			OR (ske.HispanicLatinoEthnicity = 0 AND spr.RaceType = rdr.RaceCode)

	JOIN #vwDisciplineStatuses rddisc
		ON rddisc.SchoolYear = @SchoolYear
		AND ISNULL(sd.DisciplinaryActionTaken, 'MISSING')						= ISNULL(rddisc.DisciplinaryActionTakenMap, rddisc.DisciplinaryActionTakenCode)
		AND ISNULL(sd.DisciplineMethodOfCwd, 'MISSING')                         = ISNULL(rddisc.DisciplineMethodOfChildrenWithDisabilitiesMap, rddisc.DisciplineMethodOfChildrenWithDisabilitiesCode)
		AND ISNULL(CAST(sd.EducationalServicesAfterRemoval AS SMALLINT), -1)   	= ISNULL(rddisc.EducationalServicesAfterRemovalMap, -1)
		AND ISNULL(sd.IdeaInterimRemoval, 'MISSING')                            = ISNULL(rddisc.IdeaInterimRemovalMap, rddisc.IdeaInterimRemovalCode)
		AND ISNULL(sd.IdeaInterimRemovalReason, 'MISSING')                      = ISNULL(rddisc.IdeaInterimRemovalReasonMap, rddisc.IdeaInterimRemovalReasonCode)
	JOIN RDS.DimDisciplineStatuses CAT_IDEAINTERIMREMOVAL on rddisc.DimDisciplineStatusId = CAT_IDEAINTERIMREMOVAL.DimDisciplineStatusId
	JOIN #vwIdeaStatuses rdis
				ON rdis.SchoolYear = @SchoolYear
				AND rdis.IdeaIndicatorCode = 'Yes'
				AND rdis.SpecialEducationExitReasonCode = 'MISSING'
				AND ISNULL(sppse.IDEAEducationalEnvironmentForEarlyChildhood,'MISSING') = ISNULL(rdis.IdeaEducationalEnvironmentForEarlyChildhoodMap, rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode)
				AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge,'MISSING') = ISNULL(rdis.IdeaEducationalEnvironmentForSchoolAgeMap, rdis.IdeaEducationalEnvironmentForSchoolAgeCode)

	LEFT JOIN rds.DimIdeaStatuses dis on rdis.DimIdeaStatusId = dis.DimIdeaStatusId
	WHERE  ske.Schoolyear = CAST(@SchoolYear AS VARCHAR)
		--and sd.SchoolYear = ske.SchoolYear
		AND CAST(ISNULL(ske.EnrollmentEntryDate, '1900-01-01') AS DATE) 
            BETWEEN @SYStart AND @SYEnd 
		--AND sppse.IDEAIndicator = 1
		and rdis.IdeaEducationalEnvironmentForSchoolAgeCode <> 'PPPS'
		AND (
			ISNULL(sd.DisciplineMethodOfCwd, '') in ('InSchool','OutOfSchool','InSchool_1','OutOfSchool_1')
			OR CAT_IDEAINTERIMREMOVAL.DisciplinaryActionTakenCode in ('03086', '03087','03086_1', '03087_1')
	--		OR CAT_IDEAINTERIMREMOVAL.DisciplineMethodOfChildrenWithDisabilitiesCode <> 'MISSING'
			)
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

	--Set the EDFacts value for removal length
	UPDATE s
	SET s.RemovalLength = tmp.RemovalLength
	FROM #C088Staging s
		INNER JOIN (
			SELECT StudentIdentifierState
				,CASE 
					WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) >= 0.5 
						and sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) < 1.5 THEN 'LTOREQ1'
					WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) >= 1.5 
						and sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) <= 10 THEN '2TO10'
					WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) > 10 THEN 'GREATER10'
					ELSE 'MISSING'
				END AS RemovalLength
			FROM #C088Staging 
			where IDEADISABILITYTYPE IS NOT NULL
			GROUP BY StudentIdentifierState--, IDEADISABILITYTYPE
		) tmp
			ON s.StudentIdentifierState =  tmp.StudentIdentifierState

	--Set the EDFacts value for removal length for the LEP status
	UPDATE s
	SET s.LEPRemovalLength = tmp.LEPRemovalLength
	FROM #C088Staging s
		INNER JOIN (
			SELECT StudentIdentifierState, EnglishLearnerStatusEdFactsCode
				,CASE 
					WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) >= 0.5 
						and sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) < 1.5 THEN 'LTOREQ1'
					WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) >= 1.5 
						and sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) <= 10 THEN '2TO10'
					WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) > 10 THEN 'GREATER10'
					ELSE 'MISSING'
				END AS LEPRemovalLength
			FROM #C088Staging 
			GROUP BY StudentIdentifierState, EnglishLearnerStatusEdFactsCode
		) tmp
			ON s.StudentIdentifierState = tmp.StudentIdentifierState
			AND s.EnglishLearnerStatusEdFactsCode = tmp.EnglishLearnerStatusEdFactsCode


	/**********************************************************************
		Test Case 1:
		CSA at the SEA level - Student Count by Removal Length (IDEA) by Disability Category (IDEA)
	***********************************************************************/
	SELECT 
		RemovalLength
		, IDEADISABILITYTYPE
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSA
	FROM #C088Staging 
	WHERE RemovalLength <> 'MISSING'
	GROUP BY RemovalLength
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
		,'CSA SEA Match All'
		,'CSA SEA Match All - RemovalLength: ' + ISNULL(s.RemovalLength,'RemovalLength') 
			+ '; Disability Type: ' + ISNULL(s.IDEADISABILITYTYPE, 'IDEADISABILITYTYPE')
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #S_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON s.RemovalLength = rreksd.RemovalLength
		AND s.IDEADISABILITYTYPE = rreksd.IDEADISABILITYTYPE
		AND rreksd.ReportCode = 'C088' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSA'
	WHERE s.IDEADISABILITYTYPE IS NOT NULL
	DROP TABLE #S_CSA


	/**********************************************************************
		Test Case 2:
		CSB at the SEA level - Student Count by Removal Length (IDEA) by Racial Ethnic
	***********************************************************************/
		UPDATE s
	SET s.RemovalLength = tmp.RemovalLength
	FROM #C088Staging s
		INNER JOIN (
				SELECT StudentIdentifierState
					,CASE 
						WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) >= 0.5 
							and sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) < 1.5 THEN 'LTOREQ1'
						WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) >= 1.5 
							and sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) <= 10 THEN '2TO10'
						WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) > 10 THEN 'GREATER10'
						ELSE 'MISSING'
					END AS RemovalLength
				FROM #C088Staging 
				--where IDEADISABILITYTYPE IS NOT NULL
				GROUP BY StudentIdentifierState--, IDEADISABILITYTYPE
		) tmp
			ON s.StudentIdentifierState =  tmp.StudentIdentifierState

	SELECT 
		RemovalLength
		, RaceEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSB
	FROM #C088Staging 
	WHERE RemovalLength <> 'MISSING'
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
	FROM #S_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.RemovalLength = rreksd.RemovalLength
		AND s.RaceEdFactsCode = rreksd.Race
		AND rreksd.ReportCode = 'C088' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSB'
	
	DROP TABLE #S_CSB


	/**********************************************************************
		Test Case 3:
		CSC at the SEA level - Student Count by Removal Length (IDEA) by Sex (Membership)
	***********************************************************************/
	SELECT 
		RemovalLength
		, SexEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSC
	FROM #C088Staging 
	WHERE RemovalLength <> 'MISSING'
	AND SexEdFactsCode <> 'MISSING'
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
	FROM #S_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.RemovalLength = rreksd.RemovalLength
		AND s.SexEdFactsCode = rreksd.Sex
		AND rreksd.ReportCode = 'C088' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSC'
	
	DROP TABLE #S_CSC


		
	/**********************************************************************
		Test Case 4:
		CSD at the SEA level - Student Count by Removal Length (IDEA) by English Learner Status (Both)
	***********************************************************************/
	SELECT 
		LEPRemovalLength
		, EnglishLearnerStatusEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSD
	FROM #C088Staging 
	WHERE LEPRemovalLength <> 'MISSING'
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
	FROM #S_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LEPRemovalLength = rreksd.RemovalLength
		AND s.EnglishLearnerStatusEdFactsCode = rreksd.EnglishLearnerStatus
		AND rreksd.ReportCode = 'C088' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSD'
	
	DROP TABLE #S_CSD


	/**********************************************************************
		Test Case 5:
		ST1 at the SEA level - Student Count by Removal Length (IDEA)
	***********************************************************************/
	SELECT 
		RemovalLength
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_ST1
	FROM #C088Staging 
	WHERE RemovalLength <> 'MISSING'
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
	FROM #S_ST1 s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.RemovalLength = rreksd.RemovalLength
		AND rreksd.ReportCode = 'C088' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'ST1'
	
	DROP TABLE #S_ST1


	/**********************************************************************
		Test Case 6:
		TOT at the SEA level
	*/
	SELECT 
		COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_TOT
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
	FROM #S_TOT s
	LEFT  JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON rreksd.ReportCode = 'C088' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'TOT'
			
	DROP TABLE #S_TOT


	----------------------------------------
	--- LEA level tests					 ---
	----------------------------------------
	--Using a separate Staging table for LEA to only include the OPEN LEAs
	Select * 
	INTO #C088staging_LEA
	FROM #C088staging  s
	JOIN RDS.DimLeas o
	ON LeaIdentifierSeaAccountability = o.LeaIdentifierSea
	AND DisciplinaryActionStartDate BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, @SYEnd)
		and o.ReportedFederally = 1 
		and o.DimLeaId <> -1 
		and o.LEAOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING') AND CONVERT(date, o.OperationalStatusEffectiveDate, 101) between CONVERT(date, '07/01/2022', 101) AND CONVERT(date, '06/30/2023', 101)

	UPDATE s
	SET s.RemovalLength = tmp.RemovalLength
	FROM #C088staging_LEA s
		INNER JOIN (
			SELECT StudentIdentifierState
				,CASE 
					WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) >= 0.5 
						and sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) < 1.5 THEN 'LTOREQ1'
					WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) >= 1.5 
						and sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) <= 10 THEN '2TO10'
					WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) > 10 THEN 'GREATER10'
					ELSE 'MISSING'
				END AS RemovalLength
			FROM #C088Staging_LEA 
			where ISNULL(IDEADISABILITYTYPE, 'MISSING') <> 'MISSING' -- For CSA only because the studentcount is group by StudentIdentifierState-, IDEADISABILITYTYPE
			GROUP BY StudentIdentifierState--, IDEADISABILITYTYPE
		) tmp
			ON s.StudentIdentifierState =  tmp.StudentIdentifierState

	/**********************************************************************
		Test Case 7:
		CSA at the LEA level - Student Count by Removal Length (IDEA) by Disability Category (IDEA)
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, RemovalLength
		, IDEADISABILITYTYPE
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSA
	FROM #C088staging_LEA  s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
	AND RemovalLength <> 'MISSING'
	AND IDEADISABILITYTYPE <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
		, RemovalLength
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
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Disability Type: ' + s.IDEADISABILITYTYPE
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND s.RemovalLength = rreksd.RemovalLength
		AND s.IDEADISABILITYTYPE = rreksd.IDEADISABILITYTYPE
		AND rreksd.ReportCode = 'C088' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSA'
	
	DROP TABLE #L_CSA


	/**********************************************************************
		Test Case 8:
		CSB at the LEA level - Student Count by Removal Length (IDEA) by Racial Ethnic
	***********************************************************************/

	UPDATE s
	SET s.RemovalLength = tmp.RemovalLength
	FROM #C088staging_LEA s
		INNER JOIN (
			SELECT StudentIdentifierState
				,CASE 
					WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) >= 0.5 
						and sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) < 1.5 THEN 'LTOREQ1'
					WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) >= 1.5 
						and sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) <= 10 THEN '2TO10'
					WHEN sum(cast(DurationOfDisciplinaryAction as decimal(5,2))) > 10 THEN 'GREATER10'
					ELSE 'MISSING'
				END AS RemovalLength
			FROM #C088Staging_LEA 
			--where ISNULL(IDEADISABILITYTYPE, 'MISSING') <> 'MISSING' -- For CSA only
			GROUP BY StudentIdentifierState--, IDEADISABILITYTYPE
		) tmp
			ON s.StudentIdentifierState =  tmp.StudentIdentifierState

	SELECT 
		s.LeaIdentifierSeaAccountability
		, RemovalLength
		, RaceEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSB
	FROM #C088staging_LEA  s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
	AND RemovalLength <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
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
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Race: ' + s.RaceEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND s.RemovalLength = rreksd.RemovalLength
		AND s.RaceEdFactsCode = rreksd.Race
		AND rreksd.ReportCode = 'C088' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSB'
	
	DROP TABLE #L_CSB

		
	/**********************************************************************
		Test Case 9:
		CSC at the LEA level - Student Count by Removal Length (IDEA) by Sex (Membership)
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, RemovalLength
		, SexEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSC
	FROM #C088staging_LEA  s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
	AND RemovalLength <> 'MISSING'
	AND SexEdFactsCode <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
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
			+ '; RemovalLength: ' + s.RemovalLength 
			+ '; Sex: ' + s.SexEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND s.RemovalLength = rreksd.RemovalLength
		AND s.SexEdFactsCode = rreksd.Sex
		AND rreksd.ReportCode = 'C088' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSC'
	
	DROP TABLE #L_CSC

		
	/**********************************************************************
		Test Case 10:
		CSD at the LEA level - Student Count by Removal Length (IDEA) by English Learner Status (Both)
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, LEPRemovalLength
		, EnglishLearnerStatusEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSD
	FROM #C088staging_LEA  s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
	AND LEPRemovalLength <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
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
			+ '; RemovalLength: ' + s.LEPRemovalLength 
			+ '; English Learner: ' + s.EnglishLearnerStatusEdFactsCode
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND s.LEPRemovalLength = rreksd.RemovalLength
		AND s.EnglishLearnerStatusEdFactsCode = rreksd.EnglishLearnerStatus
		AND rreksd.ReportCode = 'C088' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSD'
	
	DROP TABLE #L_CSD


	/**********************************************************************
		Test Case 11:
		ST1 at the LEA level - Student Count by Removal Length (IDEA)
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, RemovalLength
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_ST1
	FROM #C088staging_LEA  s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
	AND RemovalLength <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
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
			+ '; RemovalLength: ' + s.RemovalLength 
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_ST1 s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND s.RemovalLength = rreksd.RemovalLength
		AND rreksd.ReportCode = 'C088' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'ST1'
	
	DROP TABLE #L_ST1


	/**********************************************************************
		Test Case 12:
		TOT at the LEA level
	***********************************************************************/
	SELECT 
		s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_TOT
	FROM #C088staging_LEA  s
	LEFT JOIN #excludedLeas elea
		ON s.LeaIdentifierSeaAccountability = elea.LeaIdentifierSeaAccountability
	WHERE elea.LeaIdentifierSeaAccountability IS NULL -- exclude non reported LEAs
	AND RemovalLength <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability

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
		,'TOT LEA Match All - LEA Identifier - ' + s.LeaIdentifierSeaAccountability
		,s.StudentCount
		,rreksd.DisciplineCount
		,CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		,GETDATE()
	FROM #L_TOT s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND rreksd.ReportCode = 'C088' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'TOT'
			
	DROP TABLE #L_TOT

	--select *
	--from App.SqlUnitTestCaseResult sr
	--	inner join App.SqlUnitTest s
	--		on s.SqlUnitTestId = sr.SqlUnitTestId
	--where s.UnitTestName like '%088%'
	--and passed = 0

END
