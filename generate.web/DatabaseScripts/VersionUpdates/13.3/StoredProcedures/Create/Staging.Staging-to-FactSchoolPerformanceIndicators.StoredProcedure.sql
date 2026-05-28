/**********************************************************************
Author: AEM Corp
Date:	10/11/2025
Description: Migrates Organization Data from Staging to RDS.FactSchoolPerformanceIndicators

NOTE: This Stored Procedure processes files: 199, 200, 201, 202, 205

************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactSchoolPerformanceIndicators]
	@SchoolYear smallint 
AS   
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

		IF OBJECT_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces

		--Get the school year being migrated
		DECLARE @SchoolYearId int
		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

		DECLARE @factTypeId AS INT
		SELECT @factTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = 'schoolperformanceindicators'

		DECLARE @dimLeaId INT, @DimK12SchoolId INT
		
	--Create the temp tables (and any relevant indexes) needed for this domain
		SELECT *
		INTO #vwRaces
		FROM RDS.vwDimRaces
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwRaces 			
			ON #vwRaces (RaceMap);
			
	--Clear the Fact table of the data about to be migrated  
		DELETE FROM rds.FactSchoolPerformanceIndicators 
		WHERE SchoolYearId = @SchoolYearId

		IF OBJECT_ID('tempdb..#Facts') IS NOT NULL 
			DROP TABLE #Facts
		
	--Create and load #Facts temp table
		CREATE TABLE #Facts (
			FactTypeId											int null
			, SchoolYearId										int null
			, LeaId												int null
			, K12SchoolId										int null
			, RaceId											int null
			, IdeaStatusId										int null
			, K12DemographicId									int null
			, EconomicallyDisadvantagedStatusId					int null
			, EnglishLearnerStatusId							int null
			, SchoolPerformanceIndicatorCategoryId				int null
			, SchoolPerformanceIndicatorId						int null
			, SchoolPerformanceIndicatorStateDefinedStatusId	int null
			, SchoolQualityOrStudentSuccessIndicatorId			int null
			, IndicatorStatusId									int null
			, SubgroupId										int null
		)

		INSERT INTO #Facts
		SELECT DISTINCT 
			@factTypeId																	AS FactTypeId
			, @SchoolYearId																AS SchoolYearId
			, rdl.DimLeaID																AS LeaId
			, rdksch.DimK12SchoolId														AS K12SchoolId
			, ISNULL(rdr.DimRaceId, -1)													AS RaceId
			, ISNULL(rdis.DimIdeaStatusId, -1)											AS IdeaStatusId
			, -1																		AS K12DemographicId
			, ISNULL(rdeds.DimEconomicallyDisadvantagedStatusId, -1)					AS EconomicallyDisadvantagedStatusId
			, ISNULL(rdels.DimEnglishLearnerStatusId, -1)								AS EnglishLearnerStatusId
			, ISNULL(rdspic.DimSchoolPerformanceIndicatorCategoryId, -1)				AS SchoolPerformanceIndicatorCategoryId
			, ISNULL(rdspi.DimSchoolPerformanceIndicatorId, -1)							AS SchoolPerformanceIndicatorId
			, ISNULL(rdspisds.DimSchoolPerformanceIndicatorStateDefinedStatusId, -1)	AS SchoolPerformanceIndicatorStateDefinedStatusId
			, -1																		AS SchoolQualityOrStudentSuccessIndicatorId
			, ISNULL(rdins.DimIndicatorStatusId,-1)										AS IndicatorStatusId
			, ISNULL(rds.DimSubgroupId,-1)												AS SubgroupId

		FROM Staging.SchoolPerformanceIndicators sspi
	--schools (rds)
		JOIN RDS.DimK12Schools rdksch
			ON sspi.SchoolIdentifierSea = rdksch.SchoolIdentifierSea
			AND (
				(rdksch.RecordStartDateTime < staging.GetFiscalYearStartDate(@SchoolYear) 
					and ISNULL(rdksch.RecordEndDateTime, staging.GetFiscalYearEndDate(@SchoolYear)) >= staging.GetFiscalYearStartDate(@SchoolYear))
				OR 
				(rdksch.RecordStartDateTime >= staging.GetFiscalYearStartDate(@SchoolYear) 
					and ISNULL(rdksch.RecordEndDateTime, staging.GetFiscalYearEndDate(@SchoolYear)) <= staging.GetFiscalYearEndDate(@SchoolYear))
			)
	--leas (rds)
		LEFT JOIN RDS.DimLeas rdl
			ON sspi.LeaIdentifierSea = rdl.LeaIdentifierSea
			AND (
				(rdl.RecordStartDateTime < staging.GetFiscalYearStartDate(@SchoolYear) 
					and ISNULL(rdl.RecordEndDateTime, staging.GetFiscalYearEndDate(@SchoolYear)) >= staging.GetFiscalYearStartDate(@SchoolYear))
				OR 
				(rdl.RecordStartDateTime >= staging.GetFiscalYearStartDate(@SchoolYear) 
					and ISNULL(rdl.RecordEndDateTime, staging.GetFiscalYearEndDate(@SchoolYear)) <= staging.GetFiscalYearEndDate(@SchoolYear))
			)
	--race (RDS)
		LEFT JOIN #vwRaces rdr
			ON rdr.SchoolYear = @SchoolYear
			AND ISNULL(sspi.Race, 'MISSING') = ISNULL(rdr.RaceMap, rdr.RaceCode)
	--idea disability (RDS)
		LEFT JOIN RDS.vwDimIdeaStatuses rdis
			ON rdis.SchoolYear = @SchoolYear
			AND ISNULL(CAST(sspi.IDEAIndicator AS SMALLINT), -1) = ISNULL(rdis.IdeaIndicatorMap, -1)
			AND rdis.IdeaEducationalEnvironmentForSchoolAgeCode = 'MISSING'
			AND rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'MISSING'
			AND rdis.SpecialEducationExitReasonCode = 'MISSING'
	--english learner (RDS)
		LEFT JOIN RDS.vwDimEnglishLearnerStatuses rdels
			ON rdels.SchoolYear = @SchoolYear
			AND ISNULL(CAST(sspi.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
			AND PerkinsEnglishLearnerStatusCode = 'MISSING'
	--economically disadvantaged (RDS)
		LEFT JOIN RDS.vwDimEconomicallyDisadvantagedStatuses rdeds
			ON rdeds.SchoolYear = @SchoolYear
			AND ISNULL(CAST(sspi.EconomicDisadvantageStatus AS SMALLINT), -1) = ISNULL(rdeds.EconomicDisadvantageStatusMap, -1)
			AND EligibilityStatusForSchoolFoodServiceProgramsCode = 'MISSING'
			AND NationalSchoolLunchProgramDirectCertificationIndicatorCode = 'MISSING'
	--SchoolPerformanceIndicatorCategories (RDS)
		LEFT JOIN RDS.vwDimSchoolPerformanceIndicatorCategories rdspic
			ON rdspic.SchoolYear = @SchoolYear
			AND ISNULL(sspi.SchoolPerformanceIndicatorCategory, 'MISSING') = ISNULL(rdspic.SchoolPerformanceIndicatorCategoryMap, rdspic.SchoolPerformanceIndicatorCategoryCode)
	--SchoolPerformanceIndicators (RDS)
		LEFT JOIN RDS.vwDimSchoolPerformanceIndicators rdspi
			ON rdspi.SchoolYear = @SchoolYear
			AND ISNULL(sspi.SchoolPerformanceIndicatorType, 'MISSING') = ISNULL(rdspi.SchoolPerformanceIndicatorTypeMap, rdspi.SchoolPerformanceIndicatorTypeCode)
	--Subgroups (RDS)
		LEFT JOIN RDS.vwDimSubgroups rds
			ON rds.SchoolYear = @SchoolYear
			AND ISNULL(sspi.SubgroupCode, 'MISSING') = ISNULL(rds.SubgroupMap, rds.SubgroupCode)
	--IndicatorStatuses (RDS)
		LEFT JOIN RDS.vwDimIndicatorStatuses rdins
			ON rdins.SchoolYear = @SchoolYear
			AND ISNULL(sspi.SchoolPerformanceIndicatorStatus, 'MISSING') = ISNULL(rdins.IndicatorStatusMap, rdins.IndicatorStatusCode)
	--SchoolPerformanceIndicatorStateDefinedStatuses (RDS)
		LEFT JOIN RDS.DimSchoolPerformanceIndicatorStateDefinedStatuses rdspisds
			ON ISNULL(sspi.SchoolPerformanceIndicatorStateDefinedStatus, 'MISSING') = ISNULL(rdspisds.SchoolPerformanceIndicatorStateDefinedStatusCode, 'MISSING')

	--Final insert into RDS.FactSchoolPerformanceIndicators table
		INSERT INTO [RDS].[FactSchoolPerformanceIndicators] (
			FactTypeId
			, SchoolYearId
			, LeaId
			, K12SchoolId
			, RaceId
			, IdeaStatusId
			, K12DemographicId
			, EconomicallyDisadvantagedStatusId
			, EnglishLearnerStatusId
			, SchoolPerformanceIndicatorCategoryId
			, SchoolPerformanceIndicatorId
			, SchoolPerformanceIndicatorStateDefinedStatusId
			, SchoolQualityOrStudentSuccessIndicatorId
			, IndicatorStatusId
			, SubgroupId
		)
		SELECT DISTINCT 
			FactTypeId
			, SchoolYearId
			, LeaId
			, K12SchoolId
			, RaceId
			, IdeaStatusId
			, K12DemographicId
			, EconomicallyDisadvantagedStatusId
			, EnglishLearnerStatusId
			, SchoolPerformanceIndicatorCategoryId
			, SchoolPerformanceIndicatorId
			, SchoolPerformanceIndicatorStateDefinedStatusId
			, SchoolQualityOrStudentSuccessIndicatorId
			, IndicatorStatusId
			, SubgroupId
		FROM #Facts

		ALTER INDEX ALL ON RDS.FactSchoolPerformanceIndicators REBUILD

	END TRY
	BEGIN CATCH
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), 2, 'RDS.FactSchoolPerformanceIndicators - Error Occurred - ' + CAST(ERROR_MESSAGE() AS VARCHAR(900)))
	END CATCH

END
