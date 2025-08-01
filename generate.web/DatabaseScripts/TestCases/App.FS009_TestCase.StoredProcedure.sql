CREATE PROCEDURE [App].[FS009_TestCase] 
	@SchoolYear SMALLINT
AS
BEGIN

set NOCOUNT ON

BEGIN TRY
--	BEGIN TRANSACTION

		if cursor_status('global','db_cursor') >= -1
			begin
				deallocate db_cursor
			end

	--Create SY Start / SY End variables
	declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
	declare @SYEnd varchar(10) = CAST('06/30/' + CAST(@SchoolYear AS VARCHAR(4)) AS DATE)
	
		-- Define the test
		DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT
		IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS009_UnitTestCase') 
		BEGIN
			SET @expectedResult = 1
			INSERT INTO App.SqlUnitTest (
				  [UnitTestName]
				, [StoredProcedureName]
				, [TestScope]
				, [IsActive]
			)
			VALUES 
			(
				  'FS009_UnitTestCase'
				, 'FS009_TestCase'				
				, 'FS009'
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
			WHERE UnitTestName = 'FS009_UnitTestCase'
		END

		-- Clear out last run
		DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId

		-- Create base data set
		-- Get Custom Child Count Date
		UPDATE rds.DimSchoolYearDataMigrationTypes
		SET IsSelected = 0

		UPDATE rds.DimSchoolYearDataMigrationTypes
		SET IsSelected = 1
		FROM rds.DimSchoolYearDataMigrationTypes sydmt
		JOIN rds.DimSchoolYears sy 
			ON sydmt.DimSchoolYearId = sy.DimSchoolYearId
		WHERE sy.SchoolYear = @SchoolYear

		--DROP TABLE #staging 
		IF OBJECT_ID('tempdb..#staging') IS NOT NULL
		DROP TABLE #staging

		DECLARE @ChildCountDate DATETIME

 		select @ChildCountDate = CAST('10/01/' + cast(@SchoolYear - 1 AS Varchar(4)) AS DATETIME)

		-- Get/Set the reference Start/End dates from toggle 
		DECLARE @ExitingSpedStartDate DATETIME 
		DECLARE @UsesDefaultReferenceDates VARCHAR(10)
		DECLARE @ToggleStartDate DATE

		SELECT @ExitingSpedStartDate = CAST('7/1/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)

		SELECT @UsesDefaultReferenceDates = tr.ResponseValue
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		WHERE tq.EmapsQuestionAbbrv = 'DEFEXREFPER'

		IF (@UsesDefaultReferenceDates = 'false') 
		BEGIN
			SELECT @ToggleStartDate = tr.ResponseValue
			FROM App.ToggleQuestions tq
			JOIN App.ToggleResponses tr
				ON tq.ToggleQuestionId = tr.ToggleQuestionId
			WHERE tq.EmapsQuestionAbbrv = 'DEFEXREFDTESTART'

			SELECT @ExitingSpedStartDate = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-' + CAST(MONTH(@ToggleStartDate) AS VARCHAR(2)) + '-' + CAST(DAY(@ToggleStartDate) AS VARCHAR(2)) AS DATE)
		END 

		IF OBJECT_ID('tempdb..#disabilityCodes') IS NOT NULL
		DROP TABLE #disabilityCodes

		CREATE TABLE #disabilityCodes (
			CategoryOptionCode VARCHAR(60)
		)

		INSERT INTO #disabilityCodes
		SELECT distinct o.CategoryOptionCode
		from app.CategoryOptions o
		inner join app.Categories c on o.CategoryId = c.CategoryId
		and c.CategoryCode = 'DISABCATIDEAEXIT'
		inner join app.CategorySets cs
			on o.CategorySetId = cs.CategorySetId
		inner join app.ToggleResponses r on o.CategoryOptionName = 
				case
					when o.CategoryOptionCode = 'MISSING' then o.CategoryOptionName
					else r.ResponseValue
				end
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId 
		where q.EmapsQuestionAbbrv = 'CHDCTDISCAT'
			AND SubmissionYear = @SchoolYear

		--Get the toggle responses for Certificate and Alternate Diploma validity
		DECLARE @RCValid BIT
		DECLARE @GRADALTDPLValid BIT

		SELECT @RCValid = case tr.ResponseValue
							when 'true' then 1
							else 0
							end
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		WHERE tq.EmapsQuestionAbbrv = 'DEFEXCERT'

		SELECT @GRADALTDPLValid = case tr.ResponseValue
									when 'true' then 1
									else 0
									end
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		WHERE tq.EmapsQuestionAbbrv = 'DEFEXDLPDIS'

		--Handle the catchment areas		
		IF OBJECT_ID('tempdb..#catchmentType') IS NOT NULL
		DROP TABLE #catchmentType

		CREATE TABLE #catchmentType ( CatchmentArea varchar(100) )
		INSERT INTO #catchmentType VALUES ( 'Districtwide (students moving out of district)' )
		INSERT INTO #catchmentType VALUES ( 'Entire state (students moving out of state)' )
		
		DECLARE @catchmentArea VARCHAR(50)

		DECLARE db_cursor CURSOR FOR 
		SELECT CatchmentArea 
		FROM #catchmentType

		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @catchmentArea

		WHILE @@FETCH_STATUS = 0  
		BEGIN  

			DELETE FROM RDS.ReportEDFactsK12StudentCounts WHERE ReportCode = '009' and ReportYear = @schoolYear
			IF OBJECT_ID('tempdb..#stuLeaTemp') IS NOT NULL	DROP TABLE #stuLeaTemp
			IF OBJECT_ID('tempdb..#stuLea') IS NOT NULL	DROP TABLE #stuLea

			IF OBJECT_ID('tempdb..#TC1') IS NOT NULL DROP TABLE #TC1
			IF OBJECT_ID('tempdb..#TC2') IS NOT NULL DROP TABLE #TC2
			IF OBJECT_ID('tempdb..#TC3') IS NOT NULL DROP TABLE #TC3
			IF OBJECT_ID('tempdb..#TC4') IS NOT NULL DROP TABLE #TC4
			IF OBJECT_ID('tempdb..#TC5') IS NOT NULL DROP TABLE #TC5
			IF OBJECT_ID('tempdb..#TC6') IS NOT NULL DROP TABLE #TC6
			IF OBJECT_ID('tempdb..#TC7') IS NOT NULL DROP TABLE #TC7
			IF OBJECT_ID('tempdb..#TC8') IS NOT NULL DROP TABLE #TC8
			IF OBJECT_ID('tempdb..#TC9') IS NOT NULL DROP TABLE #TC9
			IF OBJECT_ID('tempdb..#TC10') IS NOT NULL DROP TABLE #TC10
			IF OBJECT_ID('tempdb..#TC11') IS NOT NULL DROP TABLE #TC11
			IF OBJECT_ID('tempdb..#TC12') IS NOT NULL DROP TABLE #TC12
			IF OBJECT_ID('tempdb..#TC13') IS NOT NULL DROP TABLE #TC13
			IF OBJECT_ID('tempdb..#TC14') IS NOT NULL DROP TABLE #TC14
			IF OBJECT_ID('tempdb..#TC15') IS NOT NULL DROP TABLE #TC15
			IF OBJECT_ID('tempdb..#TC16') IS NOT NULL DROP TABLE #TC16
			IF OBJECT_ID('tempdb..#TC17') IS NOT NULL DROP TABLE #TC17
			IF OBJECT_ID('tempdb..#TC18') IS NOT NULL DROP TABLE #TC18
			IF OBJECT_ID('tempdb..#TC19') IS NOT NULL DROP TABLE #TC19
			IF OBJECT_ID('tempdb..#TC20') IS NOT NULL DROP TABLE #TC20
			IF OBJECT_ID('tempdb..#TC21') IS NOT NULL DROP TABLE #TC21
			IF OBJECT_ID('tempdb..#TC22') IS NOT NULL DROP TABLE #TC22


			UPDATE atr
			SET atr.ToggleQuestionOptionId = atqo.ToggleQuestionOptionId
			FROM app.ToggleQuestions atq
			JOIN app.ToggleResponses atr
				ON atr.ToggleQuestionId = atq.ToggleQuestionId
			JOIN app.ToggleQuestionOptions atqo
				ON atr.ToggleQuestionOptionId = atqo.ToggleQuestionOptionId
			WHERE atq.EmapsQuestionAbbrv IN ('DEFEXMOVCONSEA', 'DEFEXMOVCONLEA')
				AND atqo.OptionText = @catchmentArea

			UPDATE app.GenerateReports SET IsLocked = 1 WHERE ReportCode = '009'
			EXEC RDS.Create_ReportData '009', 'exiting', 0
	
			IF OBJECT_ID('tempdb..#staging') IS NOT NULL DROP TABLE #staging

			IF OBJECT_ID('tempdb..#stuLeaTemp') IS NOT NULL	DROP TABLE #stuLeaTemp

			IF OBJECT_ID('tempdb..#stuLea') IS NOT NULL	DROP TABLE #stuLea

			IF OBJECT_ID('tempdb..#CAT_Organizations') IS NOT NULL	DROP TABLE #CAT_Organizations

			IF OBJECT_ID('tempdb..#notReportedFederallyLeas') IS NOT NULL DROP TABLE #notReportedFederallyLeas

			CREATE TABLE #notReportedFederallyLeas (
				LeaIdentifierSeaAccountability		VARCHAR(20)
			)

			INSERT INTO #notReportedFederallyLeas 
			SELECT DISTINCT LeaIdentifierSea
			FROM Staging.K12Organization
			WHERE LEA_IsReportedFederally = 0

			CREATE TABLE #stuLeaTemp (
				  StudentIdentifierState	VARCHAR(20)
				, LeaIdentifierSeaAccountability		VARCHAR(20)
			)

			create table #CAT_Organizations
			(
				LeaIdentifierState varchar(60)
			)
			CREATE INDEX IDX_CAT_Organizations ON #CAT_Organizations (LeaIdentifierState)
 
			truncate table #CAT_Organizations
 
			-- temp Category schools table							
			insert into #CAT_Organizations
 
			select distinct o.LeaIdentifierSea  
			from rds.FactK12StudentCounts fact
			join rds.DimLeas o  
				on fact.LeaId = o.DimLeaId 
			join rds.DimSchoolYears rdsy
				on fact.SchoolYearId = rdsy.DimSchoolYearId
			where rdsy.SchoolYear = @SchoolYear
			and o.ReportedFederally = 1 
			and o.DimLeaId <> -1 
			and o.LEAOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING') AND CONVERT(date, o.OperationalStatusEffectiveDate, 101) between CONVERT(date, '07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)), 101) AND CONVERT(date, '06/30/' + CAST(@SchoolYear AS VARCHAR(4)), 101)


			IF @catchmentArea = 'Districtwide (students moving out of district)' 
				BEGIN	
					INSERT INTO #stuLeaTemp
					SELECT DISTINCT
						  sppse.StudentIdentifierState
						, sppse.LeaIdentifierSeaAccountability
					FROM Staging.ProgramParticipationSpecialEducation sppse
					WHERE ProgramParticipationEndDate IS NOT NULL
					GROUP BY StudentIdentifierState	
						, sppse.LeaIdentifierSeaAccountability
						, ProgramParticipationEndDate
					HAVING ProgramParticipationEndDate  = MIN(ProgramParticipationEndDate)
			
				END 
			ELSE 
				BEGIN			
					INSERT INTO #stuLeaTemp
					SELECT DISTINCT
						  sppse.StudentIdentifierState
						, sppse.LeaIdentifierSeaAccountability
					FROM Staging.ProgramParticipationSpecialEducation sppse
					GROUP BY StudentIdentifierState
						, sppse.LeaIdentifierSeaAccountability
						, ProgramParticipationEndDate
					HAVING ProgramParticipationEndDate  = MAX(ProgramParticipationEndDate)
				END
			
			CREATE NONCLUSTERED INDEX [IX_stuLeaTemp] ON #stuLeaTemp(LeaIdentifierSeaAccountability, StudentIdentifierState)
			
			CREATE TABLE #stuLea (
				  StudentIdentifierState					VARCHAR(20)
				, LeaIdentifierSeaAccountability			VARCHAR(20)
				, SpecialEducationServicesExitDate			DATETIME
			)

			INSERT INTO #stuLea
			SELECT
				  sppse.StudentIdentifierState
				, sppse.LeaIdentifierSeaAccountability
				, MAX(sppse.ProgramParticipationEndDate)
			FROM Staging.ProgramParticipationSpecialEducation sppse
			JOIN #stuLeaTemp temp	
				ON sppse.StudentIdentifierState = temp.StudentIdentifierState
				AND sppse.LeaIdentifierSeaAccountability = temp.LeaIdentifierSeaAccountability
			GROUP BY sppse.StudentIdentifierState
				, sppse.LeaIdentifierSeaAccountability

			CREATE NONCLUSTERED INDEX [IX_stuLea] ON #stuLea(LeaIdentifierSeaAccountability, StudentIdentifierState)

			CREATE TABLE #staging (
				  StudentIdentifierState					VARCHAR(100)
				, LeaIdentifierSeaAccountability			VARCHAR(100)
				, SchoolIdentifierSea						VARCHAR(100)
				, Birthdate									DATETIME
				, Age										VARCHAR(100)
				, SpecialEducationExitReason				VARCHAR(100)
				, SpecialEducationExitReasonEdFactsCode		VARCHAR(100)
				, IdeaDisabilityTypeCode					VARCHAR(100)
				, IdeaDisabilityTypeEdFactsCode				VARCHAR(100)
				, HispanicLatinoEthnicity					VARCHAR(100)
				, RaceType									VARCHAR(100)
				, RaceEdFactsCode							VARCHAR(100)
				, Sex										VARCHAR(100)
				, SexEdFactsCode							VARCHAR(100)
				, EnglishLearnerStatus						VARCHAR(100)
				, EnglishLearnerStatusEdFactsCode			VARCHAR(100)

			)

			INSERT INTO #staging
			SELECT DISTINCT 
				  ske.StudentIdentifierState
				, ske.LeaIdentifierSeaAccountability
				, ske.SchoolIdentifierSea
				, ske.Birthdate
				, CASE
					WHEN @ChildCountDate <= sppse.ProgramParticipationEndDate THEN [RDS].[Get_Age](ske.Birthdate, @ChildCountDate)
					ELSE [RDS].[Get_Age](ske.BirthDate, DATEADD(year, -1, @ChildCountDate))
				END AS Age
				, sppse.SpecialEducationExitReason
				, CASE sppse.SpecialEducationExitReason
					WHEN 'PartCNoLongerEligible' THEN 'PartCNoLongerEligible'
					WHEN 'PartBEligibleContinuingPartC' THEN 'PartBEligibleContinuingPartC'
					WHEN 'WithdrawalByParent' THEN 'TRAN'
					WHEN 'PartBEligibilityNotDeterminedExitingPartC' THEN 'PartBEligibilityNotDeterminedExitingPartC'
					WHEN 'Unreachable' THEN 'DROPOUT'
					WHEN 'Died' THEN 'D'
					WHEN 'ReceivedCertificate' THEN 'RC'
					WHEN 'MISSING' THEN 'MISSING'
					WHEN 'MovedAndContinuing' THEN 'MKC'
					WHEN 'PartBEligibleExitingPartC' THEN 'PartBEligibleExitingPartC'
					WHEN 'MovedOutOfState' THEN 'MKC'
					WHEN 'ReachedMaximumAge' THEN 'RMA'
					WHEN 'NotPartBEligibleExitingPartCWithoutReferrrals' THEN 'MISSING'
					WHEN 'GraduatedAlternateDiploma' THEN 'GRADALTDPL'
					WHEN 'NotPartBEligibleExitingPartCWithReferrrals' THEN 'MISSING'
					WHEN 'DroppedOut' THEN 'DROPOUT'
					WHEN 'HighSchoolDiploma' THEN 'GHS'
					WHEN 'Transferred' THEN 'TRAN'
					WHEN 'PartCNoLongerEligible_1' THEN 'PartCNoLongerEligible'
					WHEN 'PartBEligibleContinuingPartC_1' THEN 'PartBEligibleContinuingPartC'
					WHEN 'WithdrawalByParent_1' THEN 'TRAN'
					WHEN 'PartBEligibilityNotDeterminedExitingPartC_1' THEN 'PartBEligibilityNotDeterminedExitingPartC'
					WHEN 'Unreachable_1' THEN 'DROPOUT'
					WHEN 'Died_1' THEN 'D'
					WHEN 'ReceivedCertificate_1' THEN 'RC'
					WHEN 'MISSING_1' THEN 'MISSING'
					WHEN 'MovedAndContinuing_1' THEN 'MKC'
					WHEN 'PartBEligibleExitingPartC_1' THEN 'PartBEligibleExitingPartC'
					WHEN 'MovedOutOfState_1' THEN 'MKC'
					WHEN 'ReachedMaximumAge_1' THEN 'RMA'
					WHEN 'NotPartBEligibleExitingPartCWithoutReferrrals_1' THEN 'MISSING'
					WHEN 'GraduatedAlternateDiploma_1' THEN 'GRADALTDPL'
					WHEN 'NotPartBEligibleExitingPartCWithReferrrals_1' THEN 'MISSING'
					WHEN 'DroppedOut_1' THEN 'DROPOUT'
					WHEN 'HighSchoolDiploma_1' THEN 'GHS'
					WHEN 'Transferred_1' THEN 'TRAN'
				END
				, sidt.IdeaDisabilityTypeCode
				, CASE sidt.IdeaDisabilityTypeCode 
					WHEN 'MISSING' THEN 'MISSING'
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
					WHEN 'MISSING_1' THEN 'MISSING'
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
				END
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
					WHEN spr.RaceType = 'HispanicorLatinoEthnicity' THEN 'HI7'
					WHEN spr.RaceType = 'DemographicRaceTwoOrMoreRaces' THEN 'MISSING'
					WHEN spr.RaceType = 'RaceAndEthnicityUnknown' THEN 'MISSING'
					WHEN spr.RaceType = 'MISSING' THEN 'MISSING'
					WHEN spr.RaceType = 'AmericanIndianorAlaskaNative_1' THEN 'AM7'
					WHEN spr.RaceType = 'Asian_1' THEN 'AS7'
					WHEN spr.RaceType = 'BlackorAfricanAmerican_1' THEN 'BL7'
					WHEN spr.RaceType = 'NativeHawaiianorOtherPacificIslander_1' THEN 'PI7'
					WHEN spr.RaceType = 'White_1' THEN 'WH7'
					WHEN spr.RaceType = 'TwoorMoreRaces_1' THEN 'MU7'
					WHEN spr.RaceType = 'HispanicorLatinoEthnicity_1' THEN 'HI7'
					WHEN spr.RaceType = 'DemographicRaceTwoOrMoreRaces_1' THEN 'MISSING'
					WHEN spr.RaceType = 'RaceAndEthnicityUnknown_1' THEN 'MISSING'
					WHEN spr.RaceType = 'MISSING_1' THEN 'MISSING'
				END
				, ske.Sex
				, CASE ske.Sex
					WHEN 'Male' THEN 'M'
					WHEN 'Female' THEN 'F'
					WHEN 'Male_1' THEN 'M'
					WHEN 'Female_1' THEN 'F'
					ELSE 'MISSING'
				END AS SexEdFactsCode
				, CASE
					WHEN sppse.ProgramParticipationEndDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, @SYEnd) THEN EnglishLearnerStatus
					ELSE 0
				END AS EnglishLearnerStatus
				, CASE
					WHEN sppse.ProgramParticipationEndDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, @SYEnd) THEN 
						CASE 
							WHEN EnglishLearnerStatus = 1 THEN 'LEP'
							WHEN EnglishLearnerStatus = 0 THEN 'NLEP'
							ELSE 'MISSING'
						END
					ELSE 'MISSING'
				END AS EnglishLearnerStatusEdFactsCode
			FROM Staging.K12Enrollment ske
			LEFT JOIN #stuLea latest
				ON ske.StudentIdentifierState = latest.StudentIdentifierState
				AND ske.LeaIdentifierSeaAccountability = latest.LeaIdentifierSeaAccountability
				and latest.SpecialEducationServicesExitDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEnd) -- JW 4/4/2024
			JOIN Staging.ProgramParticipationSpecialEducation sppse
				ON sppse.StudentIdentifierState = latest.StudentIdentifierState
				AND sppse.LeaIdentifierSeaAccountability = latest.LeaIdentifierSeaAccountability
				AND sppse.ProgramParticipationEndDate = latest.SpecialEducationServicesExitDate
				AND sppse.ProgramParticipationEndDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEnd) -- JW 4/4/2024
			JOIN RDS.DimSeas rds
				ON sppse.ProgramParticipationEndDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, @SYEnd)
			JOIN Staging.IdeaDisabilityType sidt
				ON sidt.StudentIdentifierState = ske.StudentIdentifierState
				AND sidt.LeaIdentifierSeaAccountability = ske.LeaIdentifierSeaAccountability
				AND ISNULL(sidt.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
				AND sppse.ProgramParticipationEndDate BETWEEN sidt.RecordStartDateTime AND ISNULL(sidt.RecordEndDateTime, @SYEnd)
				and sidt.IsPrimaryDisability = 1
			LEFT JOIN Staging.K12PersonRace spr
				ON ske.StudentIdentifierState = spr.StudentIdentifierState
				AND ske.LeaIdentifierSeaAccountability = spr.LeaIdentifierSeaAccountability
				AND (ske.SchoolIdentifierSea = spr.SchoolIdentifierSea or spr.SchoolYear = ske.SchoolYear) -- JW 4/4/2024
			LEFT JOIN RDS.DimRaces rdr
				ON (ske.HispanicLatinoEthnicity = 1 and rdr.RaceEdFactsCode = 'HI7')
					OR (ske.HispanicLatinoEthnicity = 0 AND spr.RaceType = rdr.RaceCode)
			LEFT JOIN Staging.PersonStatus el 
				ON ske.StudentIdentifierState = el.StudentIdentifierState
				AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(el.LeaIdentifierSeaAccountability, '')
				AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(el.SchoolIdentifierSea, '')
				AND sppse.ProgramParticipationEndDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, @SYEnd)
			WHERE sppse.ProgramParticipationEndDate is not null
				AND sppse.IDEAEducationalEnvironmentForSchoolAge <> 'PPPS' -- JW 4/4/2024 This was commented out, but exists in the actual report migration code
				AND sppse.SpecialEducationExitReason IS NOT NULL
				AND ske.SchoolYear = @SchoolYear
				--and sppse.ProgramParticipationEndDate BETWEEN ske.EnrollmentEntryDate and ISNULL(ske.EnrollmentExitDate, @SYEnd)
--NOTE: The application of this rule is being discussed and will be addressed in a future release.  For now, the rule is being commented out. CIID-4693
--				AND sppse.ProgramParticipationBeginDate <= @ExitingSpedStartDate

			--Remove invalid Ages
			DELETE FROM #staging
			WHERE Age NOT BETWEEN 14 AND 21

			--Remove exit reasons that are invalid based on Toggle
			DELETE FROM #Staging
			WHERE SpecialEducationExitReasonEdFactsCode = 'RC'
			AND @RCValid = 0
		
			DELETE FROM #Staging
			WHERE SpecialEducationExitReasonEdFactsCode = 'GRADALTDPL'
			AND @GRADALTDPLValid = 0

/**************************************************************************************************************************
BEGIN CREATING TEST RESULTS
***************************************************************************************************************************/
	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 1:
				CSA at the SEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, Age
				, IdeaDisabilityTypeEdFactsCode
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC1
			FROM #staging s
			JOIN #disabilityCodes d
				ON s.IdeaDisabilityTypeEdFactsCode = d.CategoryOptionCode
			GROUP BY SpecialEducationExitReasonEdFactsCode
				, Age
				, IdeaDisabilityTypeEdFactsCode
				
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
				,'CSA SEA Match All'
				,'CSA SEA Match All = Catchment Area: ' + @catchmentArea + ';  Age: ' + CAST(s.Age AS VARCHAR(2)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode + '; Disability Type: ' + s.IdeaDisabilityTypeEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC1 s
			LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.Age = rreksc.Age
				AND s.IdeaDisabilityTypeEdFactsCode = rreksc.IDEADISABILITYTYPE
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'CSA'

	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 2:
				CSB at the SEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, RaceEdFactsCode
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC2
			FROM #staging 
			GROUP BY SpecialEducationExitReasonEdFactsCode
				, RaceEdFactsCode
				
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
				,'CSB SEA Match All'
				,'CSB SEA Match All = Catchment Area: ' + @catchmentArea + ';  Race: ' + CAST(s.RaceEdFactsCode AS VARCHAR(3)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC2 s
			LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.RaceEdFactsCode = rreksc.RACE
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'CSB'

	-- Gather, evaluate & record the results ----------------------------------------------------------	
			/* Test Case 3:
				CSC at the SEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, SexEdFactsCode
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC3
			FROM #staging 
			WHERE SexEdFactsCode <> 'MISSING'
			GROUP BY SpecialEducationExitReasonEdFactsCode
				, SexEdFactsCode
				
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
				,'CSC SEA Match All'
				,'CSC SEA Match All = Catchment Area: ' + @catchmentArea + ';  Sex: ' + CAST(s.SexEdFactsCode AS VARCHAR(2)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC3 s
			LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.SexEdFactsCode = rreksc.SEX
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'CSC'

	-- Gather, evaluate & record the results ----------------------------------------------------------		
			/* Test Case 4:
				CSD at the SEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, EnglishLearnerStatusEdFactsCode
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC4
			FROM #staging 
			WHERE EnglishLearnerStatusEdFactsCode <> 'MISSING'
			GROUP BY SpecialEducationExitReasonEdFactsCode
				, EnglishLearnerStatusEdFactsCode
				
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
				,'CSD SEA Match All'
				,'CSD SEA Match All = Catchment Area: ' + @catchmentArea + ';  EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(4)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC4 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.EnglishLearnerStatusEdFactsCode = rreksc.ENGLISHLEARNERSTATUS
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'CSD'
			
	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 5:
				ST1 at the SEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC5
			FROM #staging 
			GROUP BY SpecialEducationExitReasonEdFactsCode
			
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
				,'ST1 SEA Match All'
				,'ST1 SEA Match All = Catchment Area: ' + @catchmentArea + ';  Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC5 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'ST1'
			
	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 6:
				ST2 at the SEA level
			*/
			SELECT 
				  Age
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC6
			FROM #staging 
			GROUP BY Age
				
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
				,'ST2 SEA Match All'
				,'ST2 SEA Match All = Catchment Area: ' + @catchmentArea + ';  Age: ' + CAST(s.Age as VARCHAR(2))
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC6 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.Age = rreksc.AGE
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'ST2'
			
		-- Gather, evaluate & record the results ----------------------------------------------------------
		/* Test Case 7:
				ST3 at the SEA level
			*/
			SELECT 
				  RaceEdFactsCode
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC7
			FROM #staging 
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
				,'ST3 SEA Match All'
				,'ST3 SEA Match All = Catchment Area: ' + @catchmentArea + ';  Race: ' + s.RaceEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC7 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.RaceEdFactsCode = rreksc.Race
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'ST3'
			
	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 8:
				ST4 at the SEA level
			*/
			SELECT 
				  SexEdFactsCode
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC8
			FROM #staging 
			WHERE SexEdFactsCode <> 'MISSING'
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
				,'ST4 SEA Match All'
				,'ST4 SEA Match All = Catchment Area: ' + @catchmentArea + ';  Sex: ' + s.SexEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC8 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SexEdFactsCode = rreksc.Sex
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'ST4'

	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 9:
				ST5 at the SEA level
			*/
			SELECT 
				  EnglishLearnerStatusEdFactsCode
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC9
			FROM #staging 
			WHERE EnglishLearnerStatusEdFactsCode <> 'MISSING'
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
				,'ST5 SEA Match All'
				,'ST5 SEA Match All = Catchment Area: ' + @catchmentArea + ';  EL Status: ' + s.EnglishLearnerStatusEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC9 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.EnglishLearnerStatusEdFactsCode = rreksc.ENGLISHLEARNERSTATUS
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'ST5'

	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 10:
				ST6 at the SEA level
			*/
			SELECT 
				  IdeaDisabilityTypeEdFactsCode
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC10
			FROM #staging s
			JOIN #disabilityCodes d
				ON s.IdeaDisabilityTypeEdFactsCode = d.CategoryOptionCode
			GROUP BY IdeaDisabilityTypeEdFactsCode
				
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
				,'ST6 SEA Match All'
				,'ST6 SEA Match All = Catchment Area: ' + @catchmentArea + ';  Primary Disability Type: ' + s.IdeaDisabilityTypeEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC10 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.IdeaDisabilityTypeEdFactsCode = rreksc.IDEADISABILITYTYPE
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'ST6'
			
	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 11:
				TOT at the SEA level
			*/
			SELECT 
				COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC11
			FROM #staging 

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
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC11 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'SEA'
				AND rreksc.CategorySetCode = 'TOT'
			
	----------------------------------------
	--- LEA level tests					 ---
	----------------------------------------
	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 1:
				CSA at the LEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, Age
				, IdeaDisabilityTypeEdFactsCode
				, s.LeaIdentifierSeaAccountability
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC12
			FROM #staging s
			JOIN #disabilityCodes d
				ON s.IdeaDisabilityTypeEdFactsCode = d.CategoryOptionCode
			LEFT JOIN #notReportedFederallyLeas nrflea
				ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
			LEFT JOIN #CAT_Organizations org
				ON s.LeaIdentifierSeaAccountability = org.LeaIdentifierState
			WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
				AND org.LeaIdentifierState IS NOT NULL -- exclude closed LEAs
			GROUP BY s.LeaIdentifierSeaAccountability
				, SpecialEducationExitReasonEdFactsCode
				, Age
				, IdeaDisabilityTypeEdFactsCode
				
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
				,'CSA LEA Match All'
				,'CSA LEA Match All = Catchment Area: ' + @catchmentArea + ';  LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '; Age: ' + CAST(s.Age AS VARCHAR(2)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode + '; Disability Type: ' + s.IdeaDisabilityTypeEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC12 s
			LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc 
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.Age = rreksc.Age
				AND s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
				AND s.IdeaDisabilityTypeEdFactsCode = rreksc.IDEADISABILITYTYPE
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'CSA'

	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 2:
				CSB at the LEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, RaceEdFactsCode
				, s.LeaIdentifierSeaAccountability
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC13
			FROM #staging s
			LEFT JOIN #notReportedFederallyLeas nrflea
				ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
			LEFT JOIN #CAT_Organizations org
				ON s.LeaIdentifierSeaAccountability = org.LeaIdentifierState
			WHERE s.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
				AND org.LeaIdentifierState IS NOT NULL -- exclude closed LEAs
			GROUP BY s.LeaIdentifierSeaAccountability
				, SpecialEducationExitReasonEdFactsCode
				, RaceEdFactsCode
				
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
				,'CSB LEA Match All'
				,'CSB LEA Match All = Catchment Area: ' + @catchmentArea + ';  LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '; Race: ' + CAST(s.RaceEdFactsCode AS VARCHAR(3)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC13 s
			LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.RaceEdFactsCode = rreksc.RACE
				AND s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'CSB'

	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 3:
				CSC at the LEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, SexEdFactsCode
				, s.LeaIdentifierSeaAccountability
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC14
			FROM #staging s
			LEFT JOIN #notReportedFederallyLeas nrflea
				ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
			LEFT JOIN #CAT_Organizations org
				ON s.LeaIdentifierSeaAccountability = org.LeaIdentifierState
			WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
				AND org.LeaIdentifierState IS NOT NULL -- exclude closed LEAs
				AND SexEdFactsCode <> 'MISSING'
			GROUP BY s.LeaIdentifierSeaAccountability
				, SpecialEducationExitReasonEdFactsCode
				, SexEdFactsCode
				
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
				,'CSC LEA Match All'
				,'CSC LEA Match All = Catchment Area: ' + @catchmentArea + ';  LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '; Sex: ' + CAST(s.SexEdFactsCode AS VARCHAR(2)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC14 s
			LEFT JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.SexEdFactsCode = rreksc.SEX
				AND s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'CSC'

	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 4:
				CSD at the LEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, EnglishLearnerStatusEdFactsCode
				, s.LeaIdentifierSeaAccountability
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC15
			FROM #staging s
			LEFT JOIN #notReportedFederallyLeas nrflea
				ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
			LEFT JOIN #CAT_Organizations org
				ON s.LeaIdentifierSeaAccountability = org.LeaIdentifierState
			WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
				AND org.LeaIdentifierState IS NOT NULL -- exclude closed LEAs
				AND s.EnglishLearnerStatusEdFactsCode <> 'MISSING'
			GROUP BY s.LeaIdentifierSeaAccountability
				, SpecialEducationExitReasonEdFactsCode
				, EnglishLearnerStatusEdFactsCode
				
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
				,'CSD LEA Match All'
				,'CSD LEA Match All = Catchment Area: ' + @catchmentArea + ';  LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '; EL Status: ' + CAST(s.EnglishLearnerStatusEdFactsCode AS VARCHAR(3)) +  '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC15 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.EnglishLearnerStatusEdFactsCode = rreksc.ENGLISHLEARNERSTATUS
				AND s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'CSD'

	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 5:
				ST1 at the LEA level
			*/
			SELECT 
				  SpecialEducationExitReasonEdFactsCode
				, s.LeaIdentifierSeaAccountability
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC16
			FROM #staging s
			LEFT JOIN #notReportedFederallyLeas nrflea
				ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
			LEFT JOIN #CAT_Organizations org
				ON s.LeaIdentifierSeaAccountability = org.LeaIdentifierState
			WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
				AND org.LeaIdentifierState IS NOT NULL -- exclude closed LEAs
			GROUP BY s.LeaIdentifierSeaAccountability
				, SpecialEducationExitReasonEdFactsCode
				
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
				,'ST1 LEA Match All'
				,'ST1 LEA Match All = Catchment Area: ' + @catchmentArea + ';  LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '; Special Ed Exit Reason: ' + s.SpecialEducationExitReasonEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC16 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SpecialEducationExitReasonEdFactsCode = rreksc.SpecialEducationExitReason
				AND s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'ST1'
			
	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 6:
				ST2 at the LEA level
			*/
			SELECT 
				  Age
				, s.LeaIdentifierSeaAccountability
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC17
			FROM #staging s
			LEFT JOIN #notReportedFederallyLeas nrflea
				ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
			LEFT JOIN #CAT_Organizations org
				ON s.LeaIdentifierSeaAccountability = org.LeaIdentifierState
			WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
				AND org.LeaIdentifierState IS NOT NULL -- exclude closed LEAs
			GROUP BY s.LeaIdentifierSeaAccountability
				, Age
				
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
				,'ST2 LEA Match All'
				,'ST2 LEA Match All = Catchment Area: ' + @catchmentArea + ';  LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '; Age: ' + CAST(s.Age as VARCHAR(2))
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC17 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.Age = rreksc.AGE
				AND s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'ST2'
		
	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 7:
				ST3 at the LEA level
			*/
			SELECT 
				  RaceEdFactsCode
				, s.LeaIdentifierSeaAccountability
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC18
			FROM #staging s
			LEFT JOIN #notReportedFederallyLeas nrflea
				ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
			LEFT JOIN #CAT_Organizations org
				ON s.LeaIdentifierSeaAccountability = org.LeaIdentifierState
			WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
				AND org.LeaIdentifierState IS NOT NULL -- exclude closed LEAs
			GROUP BY s.LeaIdentifierSeaAccountability
				, RaceEdFactsCode
				
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
				,'ST3 LEA Match All'
				,'ST3 LEA Match All = Catchment Area: ' + @catchmentArea + ';  LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '; Race: ' + s.RaceEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC18 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.RaceEdFactsCode = rreksc.Race
				AND s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'ST3'
			
	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 8:
				ST4 at the LEA level
			*/
			SELECT 
				  SexEdFactsCode
				, s.LeaIdentifierSeaAccountability
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC19
			FROM #staging s
			LEFT JOIN #notReportedFederallyLeas nrflea
				ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
			LEFT JOIN #CAT_Organizations org
				ON s.LeaIdentifierSeaAccountability = org.LeaIdentifierState
			WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
				AND org.LeaIdentifierState IS NOT NULL -- exclude closed LEAs
				AND SexEdFactsCode <> 'MISSING'
			GROUP BY s.LeaIdentifierSeaAccountability
				, SexEdFactsCode
				
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
				,'ST4 LEA Match All'
				,'ST4 LEA Match All = Catchment Area: ' + @catchmentArea + ';  LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '; Sex: ' + s.SexEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC19 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.SexEdFactsCode = rreksc.Sex
				AND s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'ST4'
			
	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 9:
				ST5 at the LEA level
			*/
			SELECT 
				  EnglishLearnerStatusEdFactsCode
				, s.LeaIdentifierSeaAccountability
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC20
			FROM #staging s
			LEFT JOIN #notReportedFederallyLeas nrflea
				ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
			LEFT JOIN #CAT_Organizations org
				ON s.LeaIdentifierSeaAccountability = org.LeaIdentifierState
			WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
				AND org.LeaIdentifierState IS NOT NULL -- exclude closed LEAs
				AND s.EnglishLearnerStatusEdFactsCode <> 'MISSING'
			GROUP BY s.LeaIdentifierSeaAccountability
				, EnglishLearnerStatusEdFactsCode
				
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
				,'ST5 LEA Match All'
				,'ST5 LEA Match All = Catchment Area: ' + @catchmentArea + ';  LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '; EL Status: ' + s.EnglishLearnerStatusEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC20 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.EnglishLearnerStatusEdFactsCode = rreksc.ENGLISHLEARNERSTATUS
				AND s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'ST5'

	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 10:
				ST6 at the LEA level
			*/
			SELECT 
				  IdeaDisabilityTypeEdFactsCode
				, s.LeaIdentifierSeaAccountability
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC21
			FROM #staging s
			JOIN #disabilityCodes d
				ON s.IdeaDisabilityTypeEdFactsCode = d.CategoryOptionCode
			LEFT JOIN #notReportedFederallyLeas nrflea
				ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
			LEFT JOIN #CAT_Organizations org
				ON s.LeaIdentifierSeaAccountability = org.LeaIdentifierState
			WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
				AND org.LeaIdentifierState IS NOT NULL -- exclude closed LEAs
			GROUP BY s.LeaIdentifierSeaAccountability
				, IdeaDisabilityTypeEdFactsCode
				
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
				,'ST6 LEA Match All'
				,'ST6 LEA Match All = Catchment Area: ' + @catchmentArea + ';  LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability + '; Primary Disability Type: ' + s.IdeaDisabilityTypeEdFactsCode
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC21 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.IdeaDisabilityTypeEdFactsCode = rreksc.IDEADISABILITYTYPE
				AND s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'ST6'
			
	-- Gather, evaluate & record the results ----------------------------------------------------------
			/* Test Case 11:
				TOT at the LEA level
			*/
			SELECT 
				  s.LeaIdentifierSeaAccountability
				, COUNT(DISTINCT StudentIdentifierState) AS StudentCount
			INTO #TC22
			FROM #staging s
			LEFT JOIN #notReportedFederallyLeas nrflea
				ON s.LeaIdentifierSeaAccountability = nrflea.LeaIdentifierSeaAccountability
			LEFT JOIN #CAT_Organizations org
				ON s.LeaIdentifierSeaAccountability = org.LeaIdentifierState
			WHERE nrflea.LeaIdentifierSeaAccountability IS NULL -- exclude non-federally reported LEAs
				AND org.LeaIdentifierState IS NOT NULL -- exclude closed LEAs
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
				,'TOT LEA Match All = Catchment Area: ' + @catchmentArea + ';  LeaIdentifierSeaAccountability: ' + s.LeaIdentifierSeaAccountability
				,s.StudentCount
				,rreksc.StudentCount
				,CASE WHEN s.StudentCount = ISNULL(rreksc.StudentCount, -1) THEN 1 ELSE 0 END
				,GETDATE()
			FROM #TC22 s
			LEFT  JOIN RDS.ReportEDFactsK12StudentCounts rreksc
				ON s.LeaIdentifierSeaAccountability = rreksc.OrganizationIdentifierSea
				AND rreksc.ReportCode = '009' 
				AND rreksc.ReportYear = @SchoolYear
				AND rreksc.ReportLevel = 'LEA'
				AND rreksc.CategorySetCode = 'TOT'
			
		FETCH NEXT FROM db_cursor INTO @catchmentArea 
	END 

	CLOSE db_cursor  
	DEALLOCATE db_cursor

	 --select *
	 --from App.SqlUnitTestCaseResult sr
	 --	inner join App.SqlUnitTest s
	 --		on s.SqlUnitTestId = sr.SqlUnitTestId
	 --where s.UnitTestName like '%009%'
	 --and passed = 0
	 --and convert(date, TestDateTime) = convert(date, GETDATE())

	--COMMIT TRANSACTION

	END TRY
	BEGIN CATCH

	--IF @@TRANCOUNT > 0
	--BEGIN
	--	ROLLBACK TRANSACTION
	--END

	DECLARE @msg AS NVARCHAR(MAX)
	SET @msg = ERROR_MESSAGE()

	DECLARE @sev AS INT
	SET @sev = ERROR_SEVERITY()

	RAISERROR(@msg, @sev, 1)

	END CATCH; 

	-- IF THE TEST PRODUCES NO RESULTS INSERT A RECORD TO INDICATE THIS
	if not exists	(select top 1 * 
					from app.sqlunittest t
					inner join app.SqlUnitTestCaseResult r
						on t.SqlUnitTestId = r.SqlUnitTestId
						and t.SqlUnitTestId = @SqlUnitTestId
					)
	begin
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
			,'NO TEST RESULTS'
			,'NO TEST RESULTS'
			,-1
			,-1
			,NULL
			,GETDATE()
	end

END