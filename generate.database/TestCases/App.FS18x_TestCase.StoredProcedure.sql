Create PROCEDURE [App].[FS18x_TestCase]	
	@SchoolYear SMALLINT = 2023,
	@FileSpec varchar(5) = 'FS185'
AS
BEGIN


	SET NOCOUNT ON


	if @FileSpec not in ('FS185', 'FS188', 'FS189')
		begin
			print 'Invalid File Spec!  Must be FS185, FS188, FS189'
			return
		end

	DECLARE @UnitTestName VARCHAR(100) = @FileSpec + '_UnitTestCase'
	DECLARE @AssessmentAcademicSubject VARCHAR(10) =
		case
			when @FileSpec = 'FS185' then '01166' 
			when @FileSpec = 'FS188' then '13373'
			when @FileSpec = 'FS189' then '00562'
		end

	DECLARE @StoredProcedureName VARCHAR(100) = @FileSpec + '_TestCase'
	DECLARE @TestScope VARCHAR(1000) = @FileSpec
	DECLARE @ReportCode VARCHAR(20) = 'C' + right(@FileSpec,3) 
	DECLARE @SubjectAbbrv VARCHAR(20) = 
		case
			when @FileSpec = 'FS185' then 'MATH' 
			when @FileSpec = 'FS188' then 'RLA'
			when @FileSpec = 'FS189' then 'SCIENCE'
		end

	DECLARE @TableTypeAbbrv VARCHAR(20) = 
		case
			when @FileSpec = 'FS185' then 'STUPARTMATH' 
			when @FileSpec = 'FS188' then 'STUPARTRLA'
			when @FileSpec = 'FS189' then 'STUPARTSCI'
		end

/*	
	DECLARE @UnitTestName VARCHAR(100) = 'FS175_UnitTestCase'
	DECLARE @AssessmentAcademicSubject VARCHAR(10) = '01166' 
	DECLARE @StoredProcedureName VARCHAR(100) = 'FS175_TestCase'
	DECLARE @TestScope VARCHAR(1000) = 'FS175'
	DECLARE @ReportCode VARCHAR(20) = 'C175' 
	DECLARE @SubjectAbbrv VARCHAR(20) = 'MATH'
*/
	--DECLARE @AssessmentPurpose VARCHAR(10) = '03458'
	DECLARE @AssessmentType VARCHAR(100) = 'PerformanceAssessment'

	---------------------------------------------------------------------
	DECLARE
		@SYStartDate DATE,
		@SYEndDate DATE,
		@Today Date = convert(date, getdate())

		SET @SYStartDate = staging.GetFiscalYearStartDate(@SchoolYear)
		SET @SYEndDate = staging.GetFiscalYearEndDate(@SchoolYear)
	----------------------------------------------------------------------


	-- Define the test
	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = @UnitTestName) 
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
				@UnitTestName
			, @StoredProcedureName				
			, @TestScope
			, 1
		)
		SET @SqlUnitTestId = SCOPE_IDENTITY()
	END 
	ELSE 
	BEGIN
		SELECT 
			@SqlUnitTestId = SqlUnitTestId
		--, @expectedResult = ExpectedResult 
		FROM App.SqlUnitTest 
		WHERE UnitTestName = @UnitTestName
	END


	-- Clear out last run
	DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId



		--DROP TEMP TABLES IF EXIST
		IF OBJECT_ID('tempdb..#LowerGrades') IS NOT NULL DROP TABLE #LowerGrades
		IF OBJECT_ID('tempdb..#HSGrades') IS NOT NULL DROP TABLE #HSGrades
		IF OBJECT_ID('tempdb..#staging') IS NOT NULL DROP TABLE #staging
		IF OBJECT_ID(N'tempdb..#StagingAssessmentResult') IS NOT NULL DROP TABLE #StagingAssessmentResult
		IF OBJECT_ID(N'tempdb..#StagingAssessment') IS NOT NULL DROP TABLE #StagingAssessment
		IF OBJECT_ID(N'tempdb..#StagingPersonStatus') IS NOT NULL DROP TABLE #StagingPersonStatus
		IF OBJECT_ID(N'tempdb..#StagingK12Enrollment') IS NOT NULL DROP TABLE #StagingK12Enrollment
		IF OBJECT_ID(N'tempdb..#StagingPersonRace') IS NOT NULL DROP TABLE #StagingPersonRace
		IF OBJECT_ID(N'tempdb..#DimRaces') IS NOT NULL DROP TABLE #DimRaces
		IF OBJECT_ID(N'tempdb..#DimAssessments') IS NOT NULL DROP TABLE #DimAssessments
		IF OBJECT_ID(N'tempdb..#ToggleAssessments') IS NOT NULL DROP TABLE #ToggleAssessments
		IF OBJECT_ID(N'tempdb..#DimSchoolYears') IS NOT NULL DROP TABLE #DimSchoolYears


		-- Temp tables for LOWER GRADES ------------------------------
		IF OBJECT_ID('tempdb..#CSA_LG') IS NOT NULL DROP TABLE #CSA_LG
		IF OBJECT_ID('tempdb..#CSB_LG') IS NOT NULL DROP TABLE #CSB_LG
		IF OBJECT_ID('tempdb..#CSC_LG') IS NOT NULL DROP TABLE #CSC_LG
		IF OBJECT_ID('tempdb..#CSD_LG') IS NOT NULL DROP TABLE #CSD_LG
		IF OBJECT_ID('tempdb..#CSE_LG') IS NOT NULL DROP TABLE #CSE_LG
		IF OBJECT_ID('tempdb..#CSF_LG') IS NOT NULL DROP TABLE #CSF_LG
		IF OBJECT_ID('tempdb..#CSG_LG') IS NOT NULL DROP TABLE #CSG_LG
		IF OBJECT_ID('tempdb..#CSH_LG') IS NOT NULL DROP TABLE #CSH_LG
		IF OBJECT_ID('tempdb..#CSI_LG') IS NOT NULL DROP TABLE #CSI_LG
		IF OBJECT_ID('tempdb..#CSJ_LG') IS NOT NULL DROP TABLE #CSJ_LG
		IF OBJECT_ID('tempdb..#ST1_LG') IS NOT NULL DROP TABLE #ST1_LG

		IF OBJECT_ID('tempdb..#CSA_LG_TESTCASE') IS NOT NULL DROP TABLE #CSA_LG_TESTCASE
		IF OBJECT_ID('tempdb..#CSB_LG_TESTCASE') IS NOT NULL DROP TABLE #CSB_LG_TESTCASE
		IF OBJECT_ID('tempdb..#CSC_LG_TESTCASE') IS NOT NULL DROP TABLE #CSC_LG_TESTCASE
		IF OBJECT_ID('tempdb..#CSD_LG_TESTCASE') IS NOT NULL DROP TABLE #CSD_LG_TESTCASE
		IF OBJECT_ID('tempdb..#CSE_LG_TESTCASE') IS NOT NULL DROP TABLE #CSE_LG_TESTCASE
		IF OBJECT_ID('tempdb..#CSF_LG_TESTCASE') IS NOT NULL DROP TABLE #CSF_LG_TESTCASE
		IF OBJECT_ID('tempdb..#CSG_LG_TESTCASE') IS NOT NULL DROP TABLE #CSG_LG_TESTCASE
		IF OBJECT_ID('tempdb..#CSH_LG_TESTCASE') IS NOT NULL DROP TABLE #CSH_LG_TESTCASE
		IF OBJECT_ID('tempdb..#CSI_LG_TESTCASE') IS NOT NULL DROP TABLE #CSI_LG_TESTCASE
		IF OBJECT_ID('tempdb..#CSJ_LG_TESTCASE') IS NOT NULL DROP TABLE #CSJ_LG_TESTCASE
		IF OBJECT_ID('tempdb..#ST1_LG_TESTCASE') IS NOT NULL DROP TABLE #ST1_LG_TESTCASE


		-- Temp tables for HIGH SCHOOL -------------------------------
		IF OBJECT_ID('tempdb..#CSA_HS') IS NOT NULL DROP TABLE #CSA_HS
		IF OBJECT_ID('tempdb..#CSB_HS') IS NOT NULL DROP TABLE #CSB_HS
		IF OBJECT_ID('tempdb..#CSC_HS') IS NOT NULL DROP TABLE #CSC_HS
		IF OBJECT_ID('tempdb..#CSD_HS') IS NOT NULL DROP TABLE #CSD_HS
		IF OBJECT_ID('tempdb..#CSE_HS') IS NOT NULL DROP TABLE #CSE_HS
		IF OBJECT_ID('tempdb..#CSF_HS') IS NOT NULL DROP TABLE #CSF_HS
		IF OBJECT_ID('tempdb..#CSG_HS') IS NOT NULL DROP TABLE #CSG_HS
		IF OBJECT_ID('tempdb..#CSH_HS') IS NOT NULL DROP TABLE #CSH_HS
		IF OBJECT_ID('tempdb..#CSI_HS') IS NOT NULL DROP TABLE #CSI_HS
		IF OBJECT_ID('tempdb..#CSJ_HS') IS NOT NULL DROP TABLE #CSJ_HS
		IF OBJECT_ID('tempdb..#ST1_HS') IS NOT NULL DROP TABLE #ST1_HS

		IF OBJECT_ID('tempdb..#CSA_HS_TESTCASE') IS NOT NULL DROP TABLE #CSA_HS_TESTCASE
		IF OBJECT_ID('tempdb..#CSB_HS_TESTCASE') IS NOT NULL DROP TABLE #CSB_HS_TESTCASE
		IF OBJECT_ID('tempdb..#CSC_HS_TESTCASE') IS NOT NULL DROP TABLE #CSC_HS_TESTCASE
		IF OBJECT_ID('tempdb..#CSD_HS_TESTCASE') IS NOT NULL DROP TABLE #CSD_HS_TESTCASE
		IF OBJECT_ID('tempdb..#CSE_HS_TESTCASE') IS NOT NULL DROP TABLE #CSE_HS_TESTCASE
		IF OBJECT_ID('tempdb..#CSF_HS_TESTCASE') IS NOT NULL DROP TABLE #CSF_HS_TESTCASE
		IF OBJECT_ID('tempdb..#CSG_HS_TESTCASE') IS NOT NULL DROP TABLE #CSG_HS_TESTCASE
		IF OBJECT_ID('tempdb..#CSH_HS_TESTCASE') IS NOT NULL DROP TABLE #CSH_HS_TESTCASE
		IF OBJECT_ID('tempdb..#CSI_HS_TESTCASE') IS NOT NULL DROP TABLE #CSI_HS_TESTCASE
		IF OBJECT_ID('tempdb..#CSJ_HS_TESTCASE') IS NOT NULL DROP TABLE #CSJ_HS_TESTCASE
		IF OBJECT_ID('tempdb..#ST1_HS_TESTCASE') IS NOT NULL DROP TABLE #ST1_HS_TESTCASE

		-- Populate Temp Table Grade Levels -----------------------------------
		create table #LowerGrades (GradeLevel char(2))
		create table #HSGrades (GradeLevel char(2))

		
	DECLARE @ChildCountDate DATETIME
	
	-- Get Custom Child Count Date
	SELECT @ChildCountDate = CAST('10/01/' + cast(@SchoolYear - 1 AS Varchar(4)) AS DATETIME)

	-- #StagingAssessment --------------------------------------------------------------------------------
		SELECT *
		INTO #StagingAssessment
		FROM Staging.Assessment
		WHERE [AssessmentAcademicSubject] = @AssessmentAcademicSubject
		--AND AssessmentType = @AssessmentType

				CREATE NONCLUSTERED INDEX IX_a ON #StagingAssessment (AssessmentTitle,AssessmentAcademicSubject,AssessmentPurpose,
				AssessmentPerformanceLevelIdentifier)

	-- #StagingAssessmentResult ----------------------------------------------------------------------------
		SELECT sar.*, rdg.GradeLevelCode, ssrd.OutputCode AssessmentAcademicSubjectCode--, ssrd1.OutputCode AssessmentPurposeCode
		INTO #StagingAssessmentResult 
		--select *
		FROM Staging.AssessmentResult sar
		LEFT JOIN RDS.vwDimGradeLevels rdg
			on sar.GradeLevelWhenAssessed = rdg.GradeLevelMap
			and sar.SchoolYear = rdg.SchoolYear
			and rdg.GradeLevelTypeCode = '000126'
		LEFT JOIN Staging.SourceSystemReferenceData ssrd
			on sar.AssessmentAcademicSubject = ssrd.InputCode
			and sar.SchoolYear = ssrd.SchoolYear
			and ssrd.TableName = 'RefAcademicSubject'
		--LEFT JOIN Staging.SourceSystemReferenceData ssrd1
		--	on sar.AssessmentPurpose = ssrd1.InputCode
		--	and sar.SchoolYear = ssrd1.SchoolYear
		--	and ssrd1.TableName = 'RefAssessmentPurpose'
		WHERE AssessmentRegistrationParticipationIndicator = 1
		AND AssessmentAcademicSubject = @AssessmentAcademicSubject
		AND sar.SchoolYear = @SchoolYear
		--AND AssessmentType = @AssessmentType
		--AND ssrd1.OutputCode = @AssessmentPurpose
--and sar.studentidentifierstate = '0000388798'
--return


				CREATE NONCLUSTERED INDEX IX_asr ON #StagingAssessmentResult (StudentIdentifierState,LeaIdentifierSeaAccountability,SchoolIdentifierSea,
				SchoolYear,GradeLevelWhenAssessed,AssessmentTitle,AssessmentAcademicSubject,--AssessmentPurpose,
				AssessmentPerformanceLevelIdentifier)


	-- #DimAssessments ---------------------------------------------------------------------------------------
		SELECT DISTINCT
			AssessmentIdentifierState, 
			AssessmentAcademicSubjectCode, AssessmentAcademicSubjectMap, 
			AssessmentTypeAdministeredCode,AssessmentTypeAdministeredMap,
			AssessmentPerformanceLevelIdentifier, ssrd.InputCode 'AssessmentPerformanceLevelMap'
		INTO #DimAssessments
		FROM rds.vwDimAssessments rda
		cross join rds.DimAssessmentPerformanceLevels rdapl
		inner join staging.SourceSystemReferenceData ssrd
			on ssrd.SchoolYear = @SchoolYear
			and ssrd.InputCode = rdapl.AssessmentPerformanceLevelIdentifier
			and ssrd.TableName = 'AssessmentPerformanceLevel_Identifier'

			CREATE NONCLUSTERED INDEX IX_ds ON #DimAssessments (AssessmentAcademicSubjectCode,AssessmentTypeAdministeredCode,AssessmentPerformanceLevelIdentifier)

	-- #ToggleAssessments ---------------------------------------------------------------------------------------
		SELECT 
		*
		INTO #ToggleAssessments
		FROM App.ToggleAssessments
		WHERE [Subject] = @SubjectAbbrv

			CREATE NONCLUSTERED INDEX IX_ta ON #ToggleAssessments (AssessmentTypeCode,Grade,[Subject])


	-- #StagingPersonStatus ---------------------------------------------------------------------------------------
		SELECT 
			case when sdt.StudentIdentifierState is NULL then 0 else 1 end as IDEAIndicator
			,sdt.RecordStartDateTime [IDEA_StatusStartDate]
			,sdt.RecordEndDateTime [IDEA_StatusEndDate] 
			,EnglishLearnerStatus
			,[EnglishLearner_StatusStartDate]
			,[EnglishLearner_StatusEndDate]
			,EconomicDisadvantageStatus
			,[EconomicDisadvantage_StatusStartDate]
			,[EconomicDisadvantage_StatusEndDate]
			,MigrantStatus
			,[Migrant_StatusStartDate]
			,[Migrant_StatusEndDate]
			,HomelessnessStatus
			,[Homelessness_StatusStartDate]
			,[Homelessness_StatusEndDate]
			,ProgramType_FosterCare
			,[FosterCare_ProgramParticipationStartDate]
			,[FosterCare_ProgramParticipationEndDate]
			,MilitaryConnectedStudentIndicator
			,[MilitaryConnected_StatusStartDate]
			,[MilitaryConnected_StatusEndDate]
			,sps.StudentIdentifierState
			,sps.LeaIdentifierSeaAccountability
			,sps.SchoolIdentifierSea		
		INTO #StagingPersonStatus
		FROM Staging.PersonStatus sps
		left join Staging.IdeaDisabilityType sdt
			on sps.StudentIdentifierState = sdt.StudentIdentifierState
			and sps.LeaIdentifierSeaAccountability = sdt.LeaIdentifierSeaAccountability
			and sps.SchoolIdentifierSea = sdt.SchoolIdentifierSea

			CREATE NONCLUSTERED INDEX IX_sps ON #StagingPersonStatus (StudentIdentifierState,LeaIdentifierSeaAccountability,SchoolIdentifierSea)

	-- #StagingK12Enrollment --------------------------------------------------------------------------------------
		SELECT [Sex]
			,StudentIdentifierState
			,LeaIdentifierSeaAccountability
			,SchoolIdentifierSea
			,HispanicLatinoEthnicity
		INTO #StagingK12Enrollment
		FROM Staging.K12Enrollment
    
			CREATE NONCLUSTERED INDEX IX_ske ON #StagingK12Enrollment (StudentIdentifierState,LeaIdentifierSeaAccountability,SchoolIdentifierSea,HispanicLatinoEthnicity)

	-- #StagingPersonRace ---------------------------------------------------------------------------------------
		SELECT StudentIdentifierState
			,SchoolYear
			,RaceType
			,RecordStartDateTime
			,RecordEndDateTime
		INTO #StagingPersonRace
		FROM Staging.K12PersonRace
		WHERE SchoolYear = @SchoolYear

			CREATE NONCLUSTERED INDEX IX_spr ON #StagingPersonRace (StudentIdentifierState,SchoolYear,RaceType,RecordStartDateTime,RecordEndDateTime)

	-- #DimRaces ---------------------------------------------------------------------------------------
		SELECT v.*, d.RaceEdFactsCode
		INTO #DimRaces
		FROM RDS.vwDimRaces v
		inner join RDS.DimRaces d
			on v.DimRaceId = d.DimRaceId
		where SchoolYear = @SchoolYear


	-- #DimSchoolYears ---------------------------------------------------------------------------------------
		SELECT 
			SchoolYear
				,SessionBeginDate
				,SessionEndDate
		INTO #DimSchoolYears
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

	-- #Staging ----------------------------------------------------------------------------------------------
	SELECT 
		asr.[StudentIdentifierState],
		asr.[LeaIdentifierSeaAccountability],
		asr.[SchoolIdentifierSea],
		a.[AssessmentTitle],
		a.[AssessmentAcademicSubject],
		a.[AssessmentPurpose],
		a.[AssessmentPerformanceLevelIdentifier],
		asr.[GradeLevelWhenAssessed],
		ds.AssessmentTypeAdministeredCode,
		case 
				WHEN asr.AssessmentTypeAdministered ='REGASSWOACC' THEN 'REGPARTWOACC'	
				WHEN asr.AssessmentTypeAdministered ='REGASSWACC' THEN 'REGPARTWACC'
				WHEN asr.AssessmentTypeAdministered ='ALTASSALTACH' THEN 'ALTPARTALTACH'
				WHEN asr.AssessmentTypeAdministered ='ADVASMTWOACC' THEN 'PADVASMWOACC'
				WHEN asr.AssessmentTypeAdministered ='ADVASMTWACC' THEN 'PADVASMWACC'
				WHEN asr.AssessmentTypeAdministered ='IADAPLASMTWOACC' THEN 'PIADAPLASMWOACC'
				WHEN asr.AssessmentTypeAdministered ='IADAPLASMTWACC' THEN 'PIADAPLASMWACC'
				WHEN asr.AssessmentRegistrationParticipationIndicator = 0 THEN 'NPART'
				WHEN asr.AssessmentRegistrationReasonNotTested = '03454' THEN 'MEDEXEMPT'
				ELSE 'MISSING'
		end as ParticipationStatus,
		[RaceEdFactsCode] = CASE rdr.RaceEdFactsCode
							WHEN 'AM7' THEN 'MAN'
							WHEN 'AS7' THEN 'MA'
							WHEN 'BL7' THEN 'MB'
							WHEN 'HI7' THEN 'MHL'
							WHEN 'MU7' THEN 'MM'
							WHEN 'PI7' THEN 'MNP'
							WHEN 'WH7' THEN 'MW'
							END,
		ske.[Sex],
		[DisabilityStatusEdFactsCode] = CASE WHEN idea.IDEAIndicator = 1 THEN 'WDIS' ELSE 'MISSING' END,
		[EnglishLearnerStatusEdFactsCode] = CASE WHEN el.EnglishLearnerStatus = 1 THEN 'LEP' ELSE 'MISSING' END,
		[EconomicDisadvantageStatusEdFactsCode] = CASE WHEN eco.EconomicDisadvantageStatus = 1 THEN 'ECODIS' ELSE 'MISSING' END,
		[MigrantStatusEdFactsCode] = CASE WHEN ms.MigrantStatus = 1 THEN 'MS' ELSE 'MISSING' END,
		[HomelessnessStatusEdFactsCode] = CASE WHEN hs.HomelessnessStatus = 1 THEN 'HOMELSENRL' ELSE 'MISSING' END,
		[ProgramType_FosterCareEdFactsCode] = CASE WHEN fc.ProgramType_FosterCare = 1 THEN 'FCS' ELSE 'MISSING' END,
		[MilitaryConnectedStudentIndicatorEdFactsCode] = CASE WHEN  mcs.MilitaryConnectedStudentIndicator is not null 
															  AND mcs.MilitaryConnectedStudentIndicator NOT IN ('Unknown', 'NotMilitaryConnected')
														 THEN 'MILCNCTD' ELSE 'MISSING' END 
		,ppse.IDEAEducationalEnvironmentForSchoolAge 
		,asr.AssessmentAdministrationStartDate
		, idea.IDEA_StatusStartDate
		, idea.IDEA_StatusEndDate
		,spr.RecordStartDateTime
		,spr.RecordEndDateTime
		,sy.SessionBeginDate
		,sy.SessionEndDate
	INTO #staging

	FROM #StagingAssessment a		
	INNER JOIN #StagingAssessmentResult asr 
		ON a.AssessmentIdentifier = asr.AssessmentIdentifier
			AND a.AssessmentPerformanceLevelIdentifier = asr.AssessmentPerformanceLevelIdentifier
			AND a.AssessmentTypeAdministered = asr.AssessmentTypeAdministered
	INNER JOIN #StagingK12Enrollment ske
		ON asr.StudentIdentifierState = ske.StudentIdentifierState
			AND asr.LeaIdentifierSeaAccountability = ske.LeaIdentifierSeaAccountability
			AND asr.SchoolIdentifierSea = ske.SchoolIdentifierSea
	INNER JOIN #DimSchoolYears sy
		ON sy.SessionBeginDate <= a.AssessmentAdministrationStartDate
			AND sy.SessionBeginDate <= asr.AssessmentAdministrationStartDate
			AND sy.SessionEndDate >= asr.AssessmentAdministrationFinishDate
			AND sy.SessionEndDate >= a.AssessmentAdministrationFinishDate
	INNER JOIN #DimAssessments ds
		ON a.AssessmentIdentifier = ds.AssessmentIdentifierState 
			AND a.AssessmentTypeAdministered = ds.AssessmentTypeAdministeredMap
			AND a.AssessmentPerformanceLevelIdentifier = ds.AssessmentPerformanceLevelIdentifier
	INNER JOIN #ToggleAssessments ta
		ON ds.AssessmentTypeAdministeredCode = ta.AssessmentTypeCode
			AND asr.GradeLevelCode = ta.Grade
			AND asr.AssessmentAcademicSubject = CASE ta.[Subject] WHEN @SubjectAbbrv THEN @AssessmentAcademicSubject ELSE 'NOMATCH' END
	LEFT JOIN #StagingPersonStatus idea
		ON idea.StudentIdentifierState = asr.StudentIdentifierState
			AND idea.LeaIdentifierSeaAccountability = asr.LeaIdentifierSeaAccountability
			AND idea.SchoolIdentifierSea = asr.SchoolIdentifierSea
			--AND a.AssessmentAdministrationStartDate BETWEEN idea.IDEA_StatusStartDate AND ISNULL(idea.IDEA_StatusEndDate,GETDATE()) --
			AND idea.IDEAIndicator = 1
			AND ISNULL(ske.SchoolIdentifierSea,'') = ISNULL(idea.SchoolIdentifierSea,'')
				AND ((idea.IDEA_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND idea.IDEA_StatusStartDate <=  asr.AssessmentAdministrationStartDate) 
					AND ISNULL(idea.IDEA_StatusEndDate, @Today) >= asr.AssessmentAdministrationStartDate)
	LEFT JOIN #StagingPersonStatus el
		ON el.StudentIdentifierState = asr.StudentIdentifierState
			AND el.LeaIdentifierSeaAccountability = asr.LeaIdentifierSeaAccountability
			AND el.SchoolIdentifierSea = asr.SchoolIdentifierSea
			--AND a.AssessmentAdministrationStartDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate,GETDATE()) --
			AND el.EnglishLearnerStatus = 1
			AND ((el.EnglishLearner_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND el.EnglishLearner_StatusStartDate <= asr.AssessmentAdministrationStartDate) 
					AND ISNULL(el.EnglishLearner_StatusEndDate, @Today) >= asr.AssessmentAdministrationStartDate)
	LEFT JOIN #StagingPersonStatus eco
		ON eco.StudentIdentifierState = asr.StudentIdentifierState
			AND eco.LeaIdentifierSeaAccountability = asr.LeaIdentifierSeaAccountability
			AND eco.SchoolIdentifierSea = asr.SchoolIdentifierSea
			--AND a.AssessmentAdministrationStartDate BETWEEN eco.EconomicDisadvantage_StatusStartDate AND ISNULL(eco.EconomicDisadvantage_StatusEndDate,GETDATE())
			and eco.EconomicDisadvantageStatus = 1
			AND ((eco.EconomicDisadvantage_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND eco.EconomicDisadvantage_StatusStartDate <= asr.AssessmentAdministrationStartDate) 
					AND ISNULL(eco.EconomicDisadvantage_StatusEndDate, @Today) >= asr.AssessmentAdministrationStartDate)
	LEFT JOIN #StagingPersonStatus ms
		ON ms.StudentIdentifierState = asr.StudentIdentifierState
			AND ms.LeaIdentifierSeaAccountability = asr.LeaIdentifierSeaAccountability
			AND ms.SchoolIdentifierSea = asr.SchoolIdentifierSea
			--AND a.AssessmentAdministrationStartDate BETWEEN ms.Migrant_StatusStartDate AND ISNULL(ms.Migrant_StatusEndDate,GETDATE())
			AND ms.MigrantStatus = 1
			AND ((ms.Migrant_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND ms.Migrant_StatusStartDate <= asr.AssessmentAdministrationStartDate) 
					AND ISNULL(ms.Migrant_StatusEndDate, @Today) >= asr.AssessmentAdministrationStartDate)
	LEFT JOIN #StagingPersonStatus hs
		ON hs.StudentIdentifierState = asr.StudentIdentifierState
			AND hs.LeaIdentifierSeaAccountability = asr.LeaIdentifierSeaAccountability
			AND hs.SchoolIdentifierSea = asr.SchoolIdentifierSea
			--AND a.AssessmentAdministrationStartDate BETWEEN hs.Homelessness_StatusStartDate AND ISNULL(hs.Homelessness_StatusEndDate,GETDATE())
			AND hs.HomelessnessStatus = 1
			AND ((hs.Homelessness_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND hs.Homelessness_StatusStartDate <= asr.AssessmentAdministrationStartDate) 
					AND ISNULL(hs.Homelessness_StatusEndDate, @Today) >= asr.AssessmentAdministrationStartDate)
	LEFT JOIN #StagingPersonStatus fc
		ON fc.StudentIdentifierState = asr.StudentIdentifierState
			AND fc.LeaIdentifierSeaAccountability = asr.LeaIdentifierSeaAccountability
			AND fc.SchoolIdentifierSea = asr.SchoolIdentifierSea
			--AND a.AssessmentAdministrationStartDate BETWEEN fc.FosterCare_ProgramParticipationStartDate AND ISNULL(fc.FosterCare_ProgramParticipationEndDate,GETDATE()) --
			AND fc.ProgramType_FosterCare = 1
			AND ((fc.FosterCare_ProgramParticipationStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND fc.FosterCare_ProgramParticipationStartDate <= asr.AssessmentAdministrationStartDate) 
					AND ISNULL(fc.FosterCare_ProgramParticipationEndDate, @Today) >= asr.AssessmentAdministrationStartDate)
	LEFT JOIN #StagingPersonStatus mcs
		ON mcs.StudentIdentifierState = asr.StudentIdentifierState
			AND mcs.LeaIdentifierSeaAccountability = asr.LeaIdentifierSeaAccountability
			AND mcs.SchoolIdentifierSea = asr.SchoolIdentifierSea
			--AND a.AssessmentAdministrationStartDate BETWEEN mcs.MilitaryConnected_StatusStartDate AND ISNULL(mcs.MilitaryConnected_StatusEndDate,GETDATE()) --
			AND case when mcs.MilitaryConnectedStudentIndicator IS NULL then 0 else 1 end = 1
			AND ((mcs.MilitaryConnected_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND mcs.MilitaryConnected_StatusStartDate <= asr.AssessmentAdministrationStartDate) 
					AND ISNULL(mcs.MilitaryConnected_StatusEndDate, @Today) >= asr.AssessmentAdministrationStartDate)
	LEFT JOIN #StagingPersonRace spr
		ON spr.StudentIdentifierState = ske.StudentIdentifierState
			AND spr.SchoolYear = sy.SchoolYear
			AND ISNULL(asr.AssessmentAdministrationStartDate, spr.RecordStartDateTime)
			BETWEEN spr.RecordStartDateTime
				AND ISNULL(spr.RecordEndDateTime, CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE))
			AND (sy.SessionBeginDate <= ISNULL(spr.RecordEndDateTime,CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE))
			AND sy.SessionEndDate >= ISNULL(spr.RecordEndDateTime,CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)))	
	LEFT JOIN #DimRaces rdr
		ON (ske.HispanicLatinoEthnicity = 1 and rdr.RaceCode = 'HI7')
				OR (ske.HispanicLatinoEthnicity = 0 AND spr.RaceType = rdr.RaceMap)
	LEFT JOIN staging.ProgramParticipationSpecialEducation ppse
		ON ppse.StudentIdentifierState = asr.StudentIdentifierState
			AND ppse.LeaIdentifierSeaAccountability = asr.LeaIdentifierSeaAccountability
			AND ppse.SchoolIdentifierSea = asr.SchoolIdentifierSea
	WHERE asr.SchoolYear = @SchoolYear
	AND ta.[Subject] = @SubjectAbbrv
	--AND ISNULL(ppse.IDEAEducationalEnvironmentForSchoolAge, '') not in ('PPPS') 


-----------------------------------------------------------------------------------------------------------------
-- BUILD CSA TEMPT TABLES FROM REPORT TABLE ---------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
			-- CSA LG ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,RACE
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSA_LG
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSA'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'LG'
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,RACE
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode


--select gradelevel, reportcode, ASSESSMENTACADEMICSUBJECT, CAtegorysetcode, count(*) 
--select * from rds.ReportEDFactsK12StudentAssessments
--where reportcode = 'C179'
--group by gradelevel, reportcode, ASSESSMENTACADEMICSUBJECT, CategorySetCode
--order by reportcode, ASSESSMENTACADEMICSUBJECT, CategorySetCode

--select reportlevel, categorysetcode, gradelevel, count(*) 'Records', sum(AssessmentCount) 'AssessmentCount'
--from rds.ReportEDFactsK12StudentAssessments
--where reportcode = 'c179' and reportyear = '2023'
--group by reportlevel, categorysetcode, gradelevel
--order by categorysetcode, reportlevel



--select * from staging.AssessmentResult where AssessmentAcademicSubject = '00562'



			-- CSB LG ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,[SEX] = CASE SEX WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSB_LG
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSB'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'LG'
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,SEX
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			-- CSC LG ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,IDEAINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSC_LG
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSC'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'LG'
			 AND IDEAINDICATOR IN ('WDIS','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,IDEAINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode


			-- CSD LG ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,ENGLISHLEARNERSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSD_LG
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSD'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'LG'
			 AND ENGLISHLEARNERSTATUS IN ('LEP','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,ENGLISHLEARNERSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			-- CSE LG ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,ECONOMICDISADVANTAGESTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSE_LG
			 FROM RDS.ReportEDFactsK12StudentAssessments 
			 WHERE CategorySetCode = 'CSE'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'LG'
			 AND ECONOMICDISADVANTAGESTATUS IN ('ECODIS','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,ECONOMICDISADVANTAGESTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			-- CSF LG ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,MIGRANTSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSF_LG
			 FROM RDS.ReportEDFactsK12StudentAssessments 
			 WHERE CategorySetCode = 'CSF'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'LG'
			 AND MIGRANTSTATUS IN ('MS','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,MIGRANTSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			-- CSG LG ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,HOMElESSNESSSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSG_LG
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSG'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'LG'
			 AND HOMElESSNESSSTATUS IN ('HOMELSENRL','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,HOMElESSNESSSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			-- CSH LG ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,PROGRAMPARTICIPATIONFOSTERCARE
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSH_LG
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSH'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'LG'
			 AND PROGRAMPARTICIPATIONFOSTERCARE IN ('FCS','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,PROGRAMPARTICIPATIONFOSTERCARE
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			-- CSI LG ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,MILITARYCONNECTEDSTUDENTINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSI_LG
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSI'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'LG'
			 AND MILITARYCONNECTEDSTUDENTINDICATOR IN ('MILCNCTD','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,MILITARYCONNECTEDSTUDENTINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			-- CSJ LG ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,RACE
				,IDEAINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSJ_LG
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSJ'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'LG'
			 AND IDEAINDICATOR IN ('WDIS','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,RACE
				,IDEAINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode


			-- ST1 LG ------------------------------
			 SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #ST1_LG
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'ST1'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'LG'
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode




-- HIGH SCHOOL -------------------------
			-- CSA HS ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,RACE
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSA_HS
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSA'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'HS'
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,RACE
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
			 

			-- CSB HS ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,[SEX] = CASE SEX WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSB_HS
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSB'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'HS'
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,SEX
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			-- CSC HS ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,IDEAINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSC_HS
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSC'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'HS'
			 AND IDEAINDICATOR IN ('WDIS','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,IDEAINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode


			-- CSD HS ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,ENGLISHLEARNERSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSD_HS
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSD'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'HS'
			 AND ENGLISHLEARNERSTATUS IN ('LEP','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,ENGLISHLEARNERSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode


			-- CSE HS ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,ECONOMICDISADVANTAGESTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSE_HS
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSE'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'HS'
			 AND ECONOMICDISADVANTAGESTATUS IN ('ECODIS','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,ECONOMICDISADVANTAGESTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			-- CSF HS ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,MIGRANTSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSF_HS
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSF'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'HS'
			 AND MIGRANTSTATUS IN ('MS','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,MIGRANTSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			-- CSG HS ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,HOMElESSNESSSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSG_HS
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSG'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'HS'
			 AND HOMElESSNESSSTATUS IN ('HOMELSENRL','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,HOMElESSNESSSTATUS
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			-- CSH HS ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,PROGRAMPARTICIPATIONFOSTERCARE
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSH_HS
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSH'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'HS'
			 AND PROGRAMPARTICIPATIONFOSTERCARE IN ('FCS','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,PROGRAMPARTICIPATIONFOSTERCARE
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			-- CSI HS ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,MILITARYCONNECTEDSTUDENTINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSI_HS
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSI'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'HS'
			 AND MILITARYCONNECTEDSTUDENTINDICATOR IN ('MILCNCTD','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,MILITARYCONNECTEDSTUDENTINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode

			-- CSJ HS ------------------------------
			SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,RACE
				,IDEAINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #CSJ_HS
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'CSJ'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'HS'
			 AND IDEAINDICATOR IN ('WDIS','MISSING')
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,RACE
				,IDEAINDICATOR
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode


			-- ST1 HS ------------------------------
			 SELECT AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode
				,AssessmentCount = SUM(AssessmentCount)
			 INTO #ST1_HS
			 FROM RDS.ReportEDFactsK12StudentAssessments
			 WHERE CategorySetCode = 'ST1'
			 AND TableTypeAbbrv = @TableTypeAbbrv + 'HS'
			 AND ReportYear = @SchoolYear
				AND ReportCode = @ReportCode 
				AND ReportLevel = 'SEA'
			 GROUP BY AssessmentRegistrationParticipationIndicator
				,GRADELEVEL
				,ReportCode
				,ReportYear
				,ReportLevel
				,CategorySetCode





----------------------------------------------------------------------------------------------------
-- BEGIN WRITING TEST CASES 
----------------------------------------------------------------------------------------------------

	-- TEST CASE CSA LG ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSA_LG_TESTCASE') IS NOT NULL DROP TABLE #CSA_LG_TESTCASE


		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSA_LG_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode


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
				,'CSA LG ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSA LG ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus +  '; '
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed  
									  + '; Race Ethnicity: ' + s.RaceEdFactsCode  
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSA_LG_TESTCASE s
			JOIN #CSA_LG sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.RaceEdFactsCode = sar.RACE
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSA'


	-- TEST CASE CSB LG ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSB_LG_TESTCASE') IS NOT NULL DROP TABLE #CSB_LG_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,Sex
			, COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSB_LG_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
			,GradeLevelWhenAssessed
			,Sex
		
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
				,'CSB LG ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSB LG ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed  
									  + '; Sex Membership: ' + s.Sex 
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSB_LG_TESTCASE s
			JOIN #CSB_LG sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.Sex = sar.SEX
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSB'
	

	-- TEST CASE CSC LG ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSC_LG_TESTCASE') IS NOT NULL DROP TABLE #CSC_LG_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,DisabilityStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSC_LG_TESTCASE
		FROM #staging 
		where ISNULL(IDEAEducationalEnvironmentForSchoolAge, '') not in ('PPPS')  -- PPPS should only be excluded from the Disability Category Set
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed
				,DisabilityStatusEdFactsCode

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
				,'CSC LG ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSC LG ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed 
									  + '; Disability Status ' + S.DisabilityStatusEdFactsCode
								  
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSC_LG_TESTCASE s
			JOIN #CSC_LG sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.DisabilityStatusEdFactsCode = sar.IDEAINDICATOR
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSC'
	

	-- TEST CASE CSD LG ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSD_LG_TESTCASE') IS NOT NULL DROP TABLE #CSD_LG_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,EnglishLearnerStatusEdFactsCode
			, COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSD_LG_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed
				,EnglishLearnerStatusEdFactsCode



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
				,'CSD LG ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSD LG ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed 
									  + '; EnglishLearner Status: ' + s.EnglishLearnerStatusEdFactsCode 
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSD_LG_TESTCASE s
			JOIN #CSD_LG sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.EnglishLearnerStatusEdFactsCode = sar.ENGLISHLEARNERSTATUS
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSD'
	

	-- TEST CASE CSE LG ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSE_LG_TESTCASE') IS NOT NULL DROP TABLE #CSE_LG_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,EconomicDisadvantageStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSE_LG_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed
				,EconomicDisadvantageStatusEdFactsCode

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
				,'CSE LG ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSE LG ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed 
									  + '; Economic Disadvantage Status: ' + s.EconomicDisadvantageStatusEdFactsCode
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSE_LG_TESTCASE s
			JOIN #CSE_LG sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.EconomicDisadvantageStatusEdFactsCode = sar.ECONOMICDISADVANTAGESTATUS
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSE'
	
	-- TEST CASE CSF LG ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSF_LG_TESTCASE') IS NOT NULL DROP TABLE #CSF_LG_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,MigrantStatusEdFactsCode
			, COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSF_LG_TESTCASE	
		FROM #staging 
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed
				,MigrantStatusEdFactsCode

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
				,'CSF LG ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSF LG ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed
									  + '; Migrant Status: ' + s.MigrantStatusEdFactsCode
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSF_LG_TESTCASE s
			JOIN #CSF_LG sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.MigrantStatusEdFactsCode = sar.MIGRANTSTATUS
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSF'


	-- TEST CASE CSG LG ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSG_LG_TESTCASE') IS NOT NULL DROP TABLE #CSG_LG_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,HomelessnessStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSG_LG_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed
				,HomelessnessStatusEdFactsCode		

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
				,'CSG LG ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSG LG ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed
									  + '; Homelessness Status: ' + s.HomelessnessStatusEdFactsCode
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSG_LG_TESTCASE s
			JOIN #CSG_LG sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.HomelessnessStatusEdFactsCode = sar.HOMElESSNESSSTATUS
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSG'

		
	-- TEST CASE CSH LG ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSH_LG_TESTCASE') IS NOT NULL DROP TABLE #CSH_LG_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,ProgramType_FosterCareEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSH_LG_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed
				,ProgramType_FosterCareEdFactsCode
		
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
				,'CSH LG ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSH LG ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed
									  + '; Foster Care: ' + s.ProgramType_FosterCareEdFactsCode
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSH_LG_TESTCASE s
			JOIN #CSH_LG sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.ProgramType_FosterCareEdFactsCode = sar.PROGRAMPARTICIPATIONFOSTERCARE
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSH'
	

	-- TEST CASE CSI LG ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSI_LG_TESTCASE') IS NOT NULL DROP TABLE #CSI_LG_TESTCASE


		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,MilitaryConnectedStudentIndicatorEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSI_LG_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed
				,MilitaryConnectedStudentIndicatorEdFactsCode

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
				,'CSI LG ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSI LG ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed
									  + '; Military Connected Student: ' + s.MilitaryConnectedStudentIndicatorEdFactsCode
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSI_LG_TESTCASE s
			JOIN #CSI_LG sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.MilitaryConnectedStudentIndicatorEdFactsCode = sar.MILITARYCONNECTEDSTUDENTINDICATOR
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSI'

	-- TEST CASE CSJ LG ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSJ_LG_TESTCASE') IS NOT NULL DROP TABLE #CSJ_LG_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode
			,DisabilityStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSJ_LG_TESTCASE
		FROM #staging 
		where ISNULL(IDEAEducationalEnvironmentForSchoolAge, '') not in ('PPPS')  -- PPPS should only be excluded from the Disability Category Set
		GROUP BY ParticipationStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode
			,DisabilityStatusEdFactsCode

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
				,'CSJ LG ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSJ LG' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus +  '; '
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed  
									  + '; Race Ethnicity: ' + s.RaceEdFactsCode  
									  + '; Disability Status: ' + s.DisabilityStatusEdFactsCode
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSJ_LG_TESTCASE s
			JOIN #CSJ_LG sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.RaceEdFactsCode = sar.RACE
				AND s.DisabilityStatusEdFactsCode = sar.IDEAINDICATOR
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSJ'
	

	-- TEST CASE ST1 LG ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#ST1_LG_TESTCASE') IS NOT NULL DROP TABLE #ST1_LG_TESTCASE


		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #ST1_LG_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed

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
			,'ST1 LG ' + UPPER(sar.ReportLevel) + ' Match All'
			,'ST1 LG ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
								   + '; Grade Level: ' + s.GradeLevelWhenAssessed
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #ST1_LG_TESTCASE s
		JOIN #ST1_LG sar 
			ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
			And s.GradeLevelWhenAssessed = sar.GRADELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.CategorySetCode = 'ST1'
	


-- HIGH SCHOOL ------------------------------------------------------------------------------------------
	-- TEST CASE CSA HS ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSA_HS_TESTCASE') IS NOT NULL DROP TABLE #CSA_HS_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSA_HS_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode

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
				,'CSA HS ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSA HS ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus +  '; '
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed  
									  + '; Race Ethnicity: ' + s.RaceEdFactsCode  
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSA_HS_TESTCASE s
			JOIN #CSA_HS sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.RaceEdFactsCode = sar.RACE
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSA'


	-- TEST CASE CSB HS ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSB_HS_TESTCASE') IS NOT NULL DROP TABLE #CSB_HS_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,Sex
			, COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSB_HS_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
			,GradeLevelWhenAssessed
			,Sex
		
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
				,'CSB HS ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSB HS ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed  
									  + '; Sex Membership: ' + s.Sex 
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSB_HS_TESTCASE s
			JOIN #CSB_HS sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.Sex = sar.SEX
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSB'
	

	-- TEST CASE CSC HS ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSC_HS_TESTCASE') IS NOT NULL DROP TABLE #CSC_HS_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,DisabilityStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSC_HS_TESTCASE
		FROM #staging 
		where ISNULL(IDEAEducationalEnvironmentForSchoolAge, '') not in ('PPPS')  -- PPPS should only be excluded from the Disability Category Set
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed
				,DisabilityStatusEdFactsCode

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
				,'CSC HS ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSC HS ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed 
									  + '; Disability Status ' + S.DisabilityStatusEdFactsCode
								  
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSC_HS_TESTCASE s
			JOIN #CSC_HS sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.DisabilityStatusEdFactsCode = sar.IDEAINDICATOR
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSC'
	

	-- TEST CASE CSD HS ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSD_HS_TESTCASE') IS NOT NULL DROP TABLE #CSD_HS_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,EnglishLearnerStatusEdFactsCode
			, COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSD_HS_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed
				,EnglishLearnerStatusEdFactsCode

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
				,'CSD HS ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSD HS ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed 
									  + '; EnglishLearner Status: ' + s.EnglishLearnerStatusEdFactsCode 
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSD_HS_TESTCASE s
			JOIN #CSD_HS sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.EnglishLearnerStatusEdFactsCode = sar.ENGLISHLEARNERSTATUS
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSD'
	

	-- TEST CASE CSE HS ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSE_HS_TESTCASE') IS NOT NULL DROP TABLE #CSE_HS_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,EconomicDisadvantageStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSE_HS_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed
				,EconomicDisadvantageStatusEdFactsCode

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
				,'CSE HS ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSE HS ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed 
									  + '; Economic Disadvantage Status: ' + s.EconomicDisadvantageStatusEdFactsCode
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSE_HS_TESTCASE s
			JOIN #CSE_HS sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.EconomicDisadvantageStatusEdFactsCode = sar.ECONOMICDISADVANTAGESTATUS
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSE'
	
	-- TEST CASE CSF HS ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSF_HS_TESTCASE') IS NOT NULL DROP TABLE #CSF_HS_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,MigrantStatusEdFactsCode
			, COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSF_HS_TESTCASE	
		FROM #staging 
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed
				,MigrantStatusEdFactsCode

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
				,'CSF HS ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSF HS ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed
									  + '; Migrant Status: ' + s.MigrantStatusEdFactsCode
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSF_HS_TESTCASE s
			JOIN #CSF_HS sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.MigrantStatusEdFactsCode = sar.MIGRANTSTATUS
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSF'


	-- TEST CASE CSG HS ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSG_HS_TESTCASE') IS NOT NULL DROP TABLE #CSG_HS_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,HomelessnessStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSG_HS_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed
				,HomelessnessStatusEdFactsCode		

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
				,'CSG HS ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSG HS ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed
									  + '; Homelessness Status: ' + s.HomelessnessStatusEdFactsCode
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSG_HS_TESTCASE s
			JOIN #CSG_HS sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.HomelessnessStatusEdFactsCode = sar.HOMElESSNESSSTATUS
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSG'

		
	-- TEST CASE CSH HS ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSH_HS_TESTCASE') IS NOT NULL DROP TABLE #CSH_HS_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,ProgramType_FosterCareEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSH_HS_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed
				,ProgramType_FosterCareEdFactsCode
		
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
				,'CSH HS ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSH HS ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed
									  + '; Foster Care: ' + s.ProgramType_FosterCareEdFactsCode
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSH_HS_TESTCASE s
			JOIN #CSH_HS sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.ProgramType_FosterCareEdFactsCode = sar.PROGRAMPARTICIPATIONFOSTERCARE
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSH'
	

	-- TEST CASE CSI HS ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSI_HS_TESTCASE') IS NOT NULL DROP TABLE #CSI_HS_TESTCASE


		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,MilitaryConnectedStudentIndicatorEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSI_HS_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed
				,MilitaryConnectedStudentIndicatorEdFactsCode

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
				,'CSI HS ' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSI HS ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed
									  + '; Military Connected Student: ' + s.MilitaryConnectedStudentIndicatorEdFactsCode
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSI_HS_TESTCASE s
			JOIN #CSI_HS sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.MilitaryConnectedStudentIndicatorEdFactsCode = sar.MILITARYCONNECTEDSTUDENTINDICATOR
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSI'

	-- TEST CASE CSJ HS ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CSJ_HS_TESTCASE') IS NOT NULL DROP TABLE #CSJ_HS_TESTCASE

		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode
			,DisabilityStatusEdFactsCode
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #CSJ_HS_TESTCASE
		FROM #staging 
		where ISNULL(IDEAEducationalEnvironmentForSchoolAge, '') not in ('PPPS')  -- PPPS should only be excluded from the Disability Category Set
		GROUP BY ParticipationStatus
			,GradeLevelWhenAssessed
			,RaceEdFactsCode
			,DisabilityStatusEdFactsCode

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
				,'CSJ HS' + UPPER(sar.ReportLevel) + ' Match All'
				,'CSJ HS' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus +  '; '
									  + '; Grade Level: ' + s.GradeLevelWhenAssessed  
									  + '; Race Ethnicity: ' + s.RaceEdFactsCode  
									  + '; Disability Status: ' + s.DisabilityStatusEdFactsCode
				,s.AssessmentCount
				,sar.AssessmentCount
				,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #CSJ_HS_TESTCASE s
			JOIN #CSJ_HS sar 
				ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
				AND s.GradeLevelWhenAssessed = sar.GRADELEVEL
				AND s.RaceEdFactsCode = sar.RACE
				AND s.DisabilityStatusEdFactsCode = sar.IDEAINDICATOR
				AND sar.ReportCode = @ReportCode 
				AND sar.ReportYear = @SchoolYear
				AND sar.CategorySetCode = 'CSJ'
	

	-- TEST CASE ST1 HS ------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#ST1_HS_TESTCASE') IS NOT NULL DROP TABLE #ST1_HS_TESTCASE


		SELECT 
			 ParticipationStatus
			,GradeLevelWhenAssessed
			,COUNT(DISTINCT StudentIdentifierState) AS AssessmentCount
		INTO #ST1_HS_TESTCASE
		FROM #staging 
		GROUP BY ParticipationStatus
				,GradeLevelWhenAssessed

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
			,'ST1 HS ' + UPPER(sar.ReportLevel) + ' Match All'
			,'ST1 HS ' + UPPER(sar.ReportLevel) + ' Match All - Assessment: ' + s.ParticipationStatus 
								   + '; Grade Level: ' + s.GradeLevelWhenAssessed
			,s.AssessmentCount
			,sar.AssessmentCount
			,CASE WHEN s.AssessmentCount = ISNULL(sar.AssessmentCount, -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM #ST1_HS_TESTCASE s
		JOIN #ST1_HS sar 
			ON s.ParticipationStatus = sar.AssessmentRegistrationParticipationIndicator
			And s.GradeLevelWhenAssessed = sar.GRADELEVEL
			AND sar.ReportCode = @ReportCode 
			AND sar.ReportYear = @SchoolYear
			AND sar.CategorySetCode = 'ST1'
	
	   	 
END