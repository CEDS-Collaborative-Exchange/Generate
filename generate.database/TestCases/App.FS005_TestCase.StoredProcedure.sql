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
		INSERT INTO App.SqlUnitTest (
			[UnitTestName]
			, [StoredProcedureName]
			, [TestScope]
			, [IsActive]
		)
		VALUES (
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

	--create the race view to handle the conversion to Multiple Races
	IF OBJECT_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces

	SELECT * 
	INTO #vwRaces 
	FROM RDS.vwDimRaces
	WHERE SchoolYear = @SchoolYear

	CREATE CLUSTERED INDEX ix_tempvwRaces ON #vwRaces (RaceMap);

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
	LEFT JOIN Staging.IdeaDisabilityType idea
        ON sppse.StudentIdentifierState = idea.StudentIdentifierState
        AND ISNULL(sppse.LeaIdentifierSeaAccountability, '') = ISNULL(idea.LeaIdentifierSeaAccountability, '')
        AND ISNULL(sppse.SchoolIdentifierSea, '') = ISNULL(idea.SchoolIdentifierSea, '')
        AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE)  
			BETWEEN idea.RecordStartDateTime AND ISNULL(idea.RecordEndDateTime, GETDATE())
        AND idea.IsPrimaryDisability = 1
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
	AND idea.IdeaDisabilityTypeCode IS NOT NULL
	AND sd.IdeaInterimRemoval in ('REMDW_1', 'REMHO_1') 
	AND ske.Schoolyear = CAST(@SchoolYear AS VARCHAR)
	AND CAST(ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01') AS DATE) 
            BETWEEN @SYStart AND @SYEnd 
	and ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge, '') NOT IN ('PPPS', 'PPPS_1')
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

--temp fix to address bad test records
--	AND ske.StudentIdentifierState not like 'CIID%'
	
			
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
		ON replace(s.IdeaInterimRemoval, '_1', '') = rreksd.IDEAINTERIMREMOVAL
		AND s.IDEADISABILITYTYPE = rreksd.[IDEADISABILITYTYPE]
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'SEA'
		AND rreksd.CategorySetCode = 'CSA'
	
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
		ON replace(s.IdeaInterimRemoval, '_1', '')  = rreksd.IDEAINTERIMREMOVAL
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
		ON replace(s.IdeaInterimRemoval, '_1', '') = rreksd.IDEAINTERIMREMOVAL
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
		ON replace(s.IdeaInterimRemoval, '_1', '') = rreksd.IDEAINTERIMREMOVAL
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
		ON replace(s.IdeaInterimRemoval, '_1', '') = rreksd.IDEAINTERIMREMOVAL
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
		ON replace(s.IdeaInterimRemoval, '_1', '') = rreksd.IDEAINTERIMREMOVAL
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
		ON replace(s.IdeaInterimRemoval, '_1', '')  = rreksd.IdeaInterimRemoval
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
		ON replace(s.IdeaInterimRemoval, '_1', '')  = rreksd.IdeaInterimRemoval
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
		ON replace(s.IdeaInterimRemoval, '_1', '')  = rreksd.IdeaInterimRemoval
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
		ON replace(s.IdeaInterimRemoval, '_1', '')  = rreksd.IdeaInterimRemoval
		AND s.LeaIdentifierSeaAccountability = rreksd.[OrganizationIdentifierSea]
		AND rreksd.ReportCode = 'C005' 
		AND rreksd.ReportYear = @SchoolYear
		AND rreksd.ReportLevel = 'LEA'
		AND rreksd.CategorySetCode = 'ST1'
			
	DROP TABLE #L_ST1

	--check the results

	-- select *
	-- from App.SqlUnitTestCaseResult sr
	-- 	inner join App.SqlUnitTest s
	-- 		on s.SqlUnitTestId = sr.SqlUnitTestId
	-- where s.UnitTestName like '%005%'
	-- and passed = 0

END