--/////////////////////////////////////////////////////
--
--    Date: 07/20/2023
-- Changes per [Staging].[Staging-to-FactK12StudentDisciplines]--			
--			1) to only include the OPEN LEAs
--		    2) to get IdeaInterimRemovalEdFactsCode in ('REMDW', 'REMHO')
--			3) to get IdeaEducationalEnvironmentForSchoolAgeCode <> 'PPPS'
--
--//////////////////////////////////////////////////////

CREATE PROCEDURE [App].[FS005_TestCase]	
	@SchoolYear SMALLINT
AS
BEGIN

	--clear the tables for the next run
	IF OBJECT_ID('tempdb..#C005Staging') IS NOT NULL
	DROP TABLE #C005Staging

	IF OBJECT_ID('tempdb..#C005Staging_LEA') IS NOT NULL
	DROP TABLE #C005Staging_LEA


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
	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS005_UnitTestCase') 

	BEGIN
		SET @expectedResult = 1
		INSERT INTO App.SqlUnitTest 
		(
			[UnitTestName]
			, [StoredProcedureName]
			, [TestScope]
			, [IsActive]
		)
		VALUES 
		(
			'FS005_UnitTestCase'
			, 'FS005_TestCase'				
			, 'FS005'
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
		WHERE UnitTestName = 'FS005_UnitTestCase'
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
	SELECT  
		ske.StudentIdentifierState
		, ske.LeaIdentifierSeaAccountability
		, ske.SchoolIdentifierSea
		, sppse.ProgramParticipationEndDate
		, ske.Birthdate
		--, idea.IdeaDisabilityTypeCode AS IDEADISABILITYTYPE--update with CASE statement
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
			ELSE 'NLEP'
			END AS EnglishLearnerStatusEdFactsCode
		, sd.IdeaInterimRemoval
		, convert(int, round(cast(sd.DurationOfDisciplinaryAction as decimal(5,2)),0,0)) DurationOfDisciplinaryAction
		,DisciplinaryActionStartDate
	INTO #C005Staging
	FROM Staging.K12Enrollment ske
	JOIN Staging.Discipline sd
		ON sd.StudentIdentifierState = ske.StudentIdentifierState
		AND ISNULL(sd.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sd.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(ske.EnrollmentEntryDate, @SYStart) and ISNULL (ske.EnrollmentExitDate, @SYEnd)
	left JOIN Staging.PersonStatus sps
		ON sps.StudentIdentifierState = sd.StudentIdentifierState
		AND ISNULL(sps.LeaIdentifierSeaAccountability, '') = ISNULL(sd.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sps.SchoolIdentifierSea, '') = ISNULL(sd.SchoolIdentifierSea, '')
		--Discipline Date within IDEA range
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(sps.[EnrollmentEntryDate], @SYStart) and ISNULL (sps.[EnrollmentExitDate], @SYEnd)
	JOIN Staging.ProgramParticipationSpecialEducation sppse
		ON sppse.StudentIdentifierState = sps.StudentIdentifierState
		AND ISNULL(sppse.LeaIdentifierSeaAccountability, '') = ISNULL(sps.LeaIdentifierSeaAccountability, '')
		AND ISNULL(sppse.SchoolIdentifierSea, '') = ISNULL(sps.SchoolIdentifierSea, '')
		--Discipline Date within Program Participation range
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
			BETWEEN ISNULL(sppse.ProgramParticipationBeginDate, @SYStart) AND ISNULL(sppse.ProgramParticipationEndDate, @SYEnd)
	LEFT JOIN Staging.K12PersonRace spr
		ON spr.StudentIdentifierState = ske.StudentIdentifierState
		AND spr.SchoolYear = ske.SchoolYear
		AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
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
			OR (ISNULL(ske.HispanicLatinoEthnicity, 0) = 0 AND spr.RaceType = rdr.RaceCode)
	LEFT JOIN #vwDisciplineStatuses rddisc
		ON rddisc.SchoolYear = @SchoolYear
		AND ISNULL(sd.DisciplinaryActionTaken, 'MISSING')						= ISNULL(rddisc.DisciplinaryActionTakenMap, rddisc.DisciplinaryActionTakenCode)
		AND ISNULL(sd.DisciplineMethodOfCwd, 'MISSING')                         = ISNULL(rddisc.DisciplineMethodOfChildrenWithDisabilitiesMap, rddisc.DisciplineMethodOfChildrenWithDisabilitiesCode)
		AND ISNULL(CAST(sd.EducationalServicesAfterRemoval AS SMALLINT), -1)   	= ISNULL(rddisc.EducationalServicesAfterRemovalMap, -1)
		AND ISNULL(sd.IdeaInterimRemoval, 'MISSING')                            = ISNULL(rddisc.IdeaInterimRemovalMap, rddisc.IdeaInterimRemovalCode)
		AND ISNULL(sd.IdeaInterimRemovalReason, 'MISSING')                      = ISNULL(rddisc.IdeaInterimRemovalReasonMap, rddisc.IdeaInterimRemovalReasonCode)
	INNER JOIN RDS.DimDisciplineStatuses CAT_IDEAINTERIMREMOVAL on rddisc.DimDisciplineStatusId = CAT_IDEAINTERIMREMOVAL.DimDisciplineStatusId
	JOIN #vwIdeaStatuses rdis
				ON rdis.SchoolYear = @SchoolYear
				AND rdis.IdeaIndicatorCode = 'Yes'
				AND rdis.SpecialEducationExitReasonCode = 'MISSING'
				AND ISNULL(sppse.IDEAEducationalEnvironmentForEarlyChildhood,'MISSING') = ISNULL(rdis.IdeaEducationalEnvironmentForEarlyChildhoodMap, rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode)
				AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge,'MISSING') = ISNULL(rdis.IdeaEducationalEnvironmentForSchoolAgeMap, rdis.IdeaEducationalEnvironmentForSchoolAgeCode)

	LEFT JOIN rds.DimIdeaStatuses dis on rdis.DimIdeaStatusId = dis.DimIdeaStatusId
	WHERE sppse.IDEAIndicator = 1
	AND idea.IdeaDisabilityTypeCode IS NOT NULL
	AND CAT_IDEAINTERIMREMOVAL.IdeaInterimRemovalEdFactsCode in ('REMDW', 'REMHO')
	AND ske.Schoolyear = CAST(@SchoolYear AS VARCHAR)
	AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
            BETWEEN @SYStart AND @SYEnd 
	and rdis.IdeaEducationalEnvironmentForSchoolAgeCode <> 'PPPS'
	--AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge, '') <> 'PPPS'
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

	
			
	/**********************************************************************
		Test Case 1:
		CSA at the SEA level
	***********************************************************************/
	SELECT 
		IdeaInterimRemoval
		, IDEADISABILITYTYPE
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSA
	FROM #C005staging 
	GROUP BY IdeaInterimRemoval
		, IDEADISABILITYTYPE
		
	INSERT INTO App.SqlUnitTestCaseResult 
	(
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
		, 'CSA SEA Match All - IdeaInterimRemoval: ' +  s.IdeaInterimRemoval 
							+ ' Disability Type: ' + s.IDEADISABILITYTYPE
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemoval= rreksd.IDEAINTERIMREMOVAL
		AND s.IDEADISABILITYTYPE = rreksd.[IDEADISABILITYTYPE]
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSA'
	
	select sum(studentcount) from #S_CSA

	DROP TABLE #S_CSA


	/**********************************************************************
		Test Case 2:
		CSB at the SEA level
	***********************************************************************/
	SELECT 
		IdeaInterimRemoval
		, RaceEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSB
	FROM #C005staging 
	GROUP BY IdeaInterimRemoval
		, RaceEdFactsCode
		

	INSERT INTO App.SqlUnitTestCaseResult 
	(
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
		, 'CSB SEA Match All'
		, 'CSB SEA Match All - Race: ' + CAST(s.RaceEdFactsCode AS VARCHAR(3)) 
			+  '; s.IdeaInterimRemoval: ' + s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSB s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemoval= rreksd.IDEAINTERIMREMOVAL
		AND s.RaceEdFactsCode = rreksd.RACE
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSB'

	DROP TABLE #S_CSB



	/**********************************************************************
		Test Case 3:
		CSC at the SEA level
	***********************************************************************/
	SELECT 
		IdeaInterimRemoval
		, SexEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSC
	FROM #C005staging 
	WHERE SexEdFactsCode <> 'MISSING'
	GROUP BY IdeaInterimRemoval
		, SexEdFactsCode
		
	INSERT INTO App.SqlUnitTestCaseResult 
	(
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
		, 'CSC SEA Match All'
		, 'CSC SEA Match All - Sex: ' + s.SexEdFactsCode
			+  '; s.IdeaInterimRemoval: '+ s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSC s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemoval= rreksd.IDEAINTERIMREMOVAL
		AND s.SexEdFactsCode = rreksd.SEX
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSC'

	DROP TABLE #S_CSC

	
	/**********************************************************************
		Test Case 4:
		CSD at the SEA level
	***********************************************************************/
	SELECT 
		IdeaInterimRemoval
		, EnglishLearnerStatusEdFactsCode
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_CSD
	FROM #C005staging
	WHERE EnglishLearnerStatusEdFactsCode in ('LEP','NLEP')
	GROUP BY IdeaInterimRemoval
		, EnglishLearnerStatusEdFactsCode
		
	INSERT INTO App.SqlUnitTestCaseResult 
	(
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
		, 'CSD SEA Match All'
		, 'CSD SEA Match All - EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) 
			+  '; s.IdeaInterimRemoval: ' + s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_CSD s
	LEFT  JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemoval= rreksd.IDEAINTERIMREMOVAL
		AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSD'
			
	DROP TABLE #S_CSD


	/**********************************************************************
		Test Case 5:
		ST1 at the SEA level
	***********************************************************************/
	SELECT 
		IdeaInterimRemoval
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #S_ST1
	FROM #C005staging 
	GROUP BY IdeaInterimRemoval
		
	INSERT INTO App.SqlUnitTestCaseResult 
	(
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
		, 'ST1 SEA Match All'
		, 'ST1 SEA Match All - Interim Removal (IDEA): ' + s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #S_ST1 s
	LEFT  JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemoval= rreksd.IDEAINTERIMREMOVAL
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'ST1'
			
	DROP TABLE #S_ST1



	----------------------------------------
	--- LEA level tests					 ---
	----------------------------------------

	--Using a separate Staging table for LEA to only include the OPEN LEAs
	Select * 
	INTO #C005staging_LEA
	FROM #C005staging  s
	JOIN RDS.DimLeas o
	ON LeaIdentifierSeaAccountability = o.LeaIdentifierSea
	AND DisciplinaryActionStartDate BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, @SYEnd)
		and o.ReportedFederally = 1 
		and o.DimLeaId <> -1 
		and o.LEAOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING') AND CONVERT(date, o.OperationalStatusEffectiveDate, 101) between CONVERT(date, '07/01/2022', 101) AND CONVERT(date, '06/30/2023', 101)

	/**********************************************************************
		Test Case 1:
		CSA at the LEA level
	***********************************************************************/
	SELECT 
		IdeaInterimRemoval
		, IDEADISABILITYTYPE
		, s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSA
	FROM #C005staging_LEA  s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
	WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	GROUP BY s.LeaIdentifierSeaAccountability
		, IdeaInterimRemoval
		, IDEADISABILITYTYPE
		

	INSERT INTO App.SqlUnitTestCaseResult 
	(
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
		, 'CSA LEA Match All'
		, 'CSA LEA Match All - LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability 
			+ '; IdeaInterimRemoval: ' + s.IdeaInterimRemoval 
			+ '; Disability Type: ' + s.IDEADISABILITYTYPE
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSA s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd 
		ON s.IdeaInterimRemoval= rreksd.IDEAINTERIMREMOVAL
		AND s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND s.IDEADISABILITYTYPE = rreksd.IDEADISABILITYTYPE
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSA'

	DROP TABLE #L_CSA


	/**********************************************************************
		Test Case 2:
		CSB at the LEA level
	***********************************************************************/
	SELECT 
			IdeaInterimRemoval
		, RaceEdFactsCode
		, s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSB
	FROM #C005staging_LEA  s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
	WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	GROUP BY s.LeaIdentifierSeaAccountability
		, IdeaInterimRemoval
		, RaceEdFactsCode
		

	INSERT INTO App.SqlUnitTestCaseResult 
	(
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
		, 'CSB LEA Match All'
		, 'CSB LEA Match All - LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability 
			+ '; Race: ' + CAST(s.RaceEdFactsCode AS VARCHAR(3))  
			+ '; IdeaInterimRemoval: ' +s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSB s
	JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON s.IdeaInterimRemoval = rreksd.IdeaInterimRemoval
		AND s.RaceEdFactsCode = rreksd.RACE
		AND s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSB'

	DROP TABLE #L_CSB


	/**********************************************************************
		Test Case 3:
		CSC at the LEA level
	***********************************************************************/
	SELECT 
		IdeaInterimRemoval
		, SexEdFactsCode
		, s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSC
	FROM #C005staging_LEA  s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
	WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	AND SexEdFactsCode <> 'MISSING'
	GROUP BY s.LeaIdentifierSeaAccountability
		, IdeaInterimRemoval
		, SexEdFactsCode
		
	INSERT INTO App.SqlUnitTestCaseResult 
	(
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
		, 'CSC LEA Match All'
		, 'CSC LEA Match All - LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability 
							+ '; Sex: ' + s.SexEdFactsCode
							+ '; IdeaInterimRemoval: ' + s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSC s
	JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON s.IdeaInterimRemoval = rreksd.IdeaInterimRemoval
		AND s.SexEdFactsCode = rreksd.SEX
		AND s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSC'

	DROP TABLE #L_CSC

	/**********************************************************************
		Test Case 4:
		CSD at the LEA level
	***********************************************************************/
	SELECT 
		IdeaInterimRemoval
		, EnglishLearnerStatusEdFactsCode
		, s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_CSD
	FROM #C005staging_LEA s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
	WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	AND EnglishLearnerStatusEdFactsCode in ('LEP','NLEP')
	GROUP BY s.LeaIdentifierSeaAccountability
		, IdeaInterimRemoval
		, EnglishLearnerStatusEdFactsCode
		
	INSERT INTO App.SqlUnitTestCaseResult 
	(
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
		, 'CSD LEA Match All'
		, 'CSD LEA Match All - LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability 
							+ '; EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) 
							+  '; IdeaInterimRemoval: ' + s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_CSD s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON s.IdeaInterimRemoval = rreksd.IdeaInterimRemoval
		AND s.EnglishLearnerStatusEdFactsCode = rreksd.ENGLISHLEARNERSTATUS
		AND s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'CSD'
			
	DROP TABLE #L_CSD


	/**********************************************************************
		Test Case 5:
		ST1 at the LEA level
	***********************************************************************/
	SELECT 
		IdeaInterimRemoval
		, s.LeaIdentifierSeaAccountability
		, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
	INTO #L_ST1
	FROM #C005staging_LEA s
	LEFT JOIN #notReportedFederallyLeas nrflea
		ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
	WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
	GROUP BY s.LeaIdentifierSeaAccountability
		, IdeaInterimRemoval
		
	INSERT INTO App.SqlUnitTestCaseResult 
	(
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
		, 'ST1 LEA Match All'
		, 'ST1 LEA Match All - LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability 
							+ '; IdeaInterimRemoval: ' + s.IdeaInterimRemoval
		, s.StudentCount
		, rreksd.DisciplineCount
		, CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END
		, GETDATE()
	FROM #L_ST1 s
	LEFT JOIN RDS.ReportEDFactsK12StudentDisciplines rreksd
		ON s.IdeaInterimRemoval = rreksd.IdeaInterimRemoval
		AND s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'ST1'
			
	DROP TABLE #L_ST1

END