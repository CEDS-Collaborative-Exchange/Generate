create PROCEDURE Staging.[Staging-to-FactOrganizationCounts]

	@SchoolYear smallint 

AS   
BEGIN

-- 9/27/2022 --

	BEGIN TRY

-- SET McKinneyVento to 0 for all LEAs (due to suspected issue with Hydrate.  Remove this once that issue is fixed)
--update staging.K12Organization set LEA_McKinneyVentoSubgrantRecipient = 0

		--drop table if exists ##Fact

		--Get the school year being migrated
		declare @SchoolYearId int
		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

		IF OBJECT_ID(N'tempdb..#seaOrganizationTypes') IS NOT NULL DROP TABLE #seaOrganizationTypes
		IF OBJECT_ID(N'tempdb..#leaOrganizationTypes') IS NOT NULL DROP TABLE #leaOrganizationTypes
		IF OBJECT_ID(N'tempdb..#schoolOrganizationTypes') IS NOT NULL DROP TABLE #schoolOrganizationTypes

		--Get the organization types via SourceSystemReferenceData
		CREATE TABLE #seaOrganizationTypes (
			SeaOrganizationType					VARCHAR(20)
		)
		
		CREATE TABLE #leaOrganizationTypes (
			LeaOrganizationType					VARCHAR(20)
		)

		CREATE TABLE #schoolOrganizationTypes (
			K12SchoolOrganizationType				VARCHAR(20)
		)


		INSERT INTO #seaOrganizationTypes
		SELECT 
			InputCode
		FROM Staging.SourceSystemReferenceData 
		WHERE TableName = 'RefOrganizationType' 
			AND TableFilter = '001156' 
			AND OutputCode = 'SEA'
			AND SchoolYear = @SchoolYear
		
		INSERT INTO #leaOrganizationTypes
		SELECT 
			InputCode
		FROM Staging.SourceSystemReferenceData 
		WHERE TableName = 'RefOrganizationType' 
			AND TableFilter = '001156' 
			AND OutputCode = 'LEA'
			AND SchoolYear = @SchoolYear

		INSERT INTO #schoolOrganizationTypes
		SELECT 
			InputCode
		FROM Staging.SourceSystemReferenceData 
		WHERE TableName = 'RefOrganizationType' 
			AND TableFilter = '001156' 
			AND OutputCode = 'K12School'
			AND SchoolYear = @SchoolYear

		DECLARE @factTypeId AS INT
		SELECT @factTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = 'directory'

		DECLARE @CSSORoleId AS INT
		SELECT @CSSORoleId = RoleId
		FROM dbo.[Role] WHERE Name = 'Chief State School Officer'
		--select @CSSORoleId = 3


		DECLARE @dimSeaId AS INT, @DimK12StaffId INT, @DimIeuId INT, @dimLeaId INT, @DimK12SchoolId INT, @IsCharterSchool AS BIT, 
			@leaOrganizationId AS INT, 
			@schoolOrganizationId AS INT
		
		DECLARE @count AS INT
		DECLARE @dimCharterSchoolManagerId AS INT
		DECLARE @dimCharterSchoolSecondaryManagerId AS INT
		DECLARE @dimCharterSchoolAuthorizerId AS INT
		DECLARE @dimCharterSchoolSecondaryAuthorizerId AS INT

		DECLARE @leaOperationalStatustypeId AS INT, @schOperationalStatustypeId AS INT, @charterLeaCount AS INT
		SELECT @leaOperationalStatustypeId = RefOperationalStatusTypeId FROM dbo.RefOperationalStatusType WHERE Code = '000174'
		SELECT @schOperationalStatustypeId = RefOperationalStatusTypeId FROM dbo.RefOperationalStatusType WHERE Code = '000533'
		
		SELECT @charterLeaCount = count(OrganizationId) FROM dbo.K12Lea WHERE CharterSchoolIndicator = 1
	
--/****************************************************************
		-- DELETE RECORDS FOR SCHOOL YEAR FROM FACT TABLE
		DELETE FROM rds.FactOrganizationCounts 
		WHERE SchoolYearId = @SchoolYearId
--*****************************************************************/

		SELECT @DimK12StaffId = MAX(p.DimK12StaffId) 
		FROM rds.DimK12Staff p
		JOIN dbo.[Role] r ON p.K12StaffRole = r.Name
		WHERE r.roleId = @CSSORoleId AND p.RecordEndDateTime IS NULL -- = 2


		-------------------------------
		--SEA
		-------------------------------

			INSERT INTO [RDS].[FactOrganizationCounts]
			(
				[SchoolYearId]
				, [FactTypeId]
				, [LeaId]
				, [K12StaffId]
				, [K12SchoolId]
				, [SchoolStatusId]
				, [SeaId]
				, [TitleIStatusId]
				, [OrganizationCount]
				, [TitleIParentalInvolveRes]
				, [TitleIPartAAllocations]
				, [CharterSchoolApproverAgencyId]
				, [CharterSchoolManagerOrganizationId]
				, [CharterSchoolSecondaryApproverAgencyId]
				, [CharterSchoolUpdatedManagerOrganizationId]
				, [SchoolImprovementFunds]
				, [OrganizationStatusId]
				, [SchoolStateStatusId]
				, [FederalFundAllocationType]
				, [FederalProgramCode]
				, [FederalFundAllocated]
				, [ComprehensiveAndTargetedSupportId]
				, [CharterSchoolStatusId]
				, [DimSubgroupId]
				, [DimComprehensiveSupportReasonApplicabilityId]
			)
			SELECT 
				@SchoolYearId 'SchoolYearId'
				, @factTypeId 'FactTypeId'
				, -1 AS 'LeaId'
				, ISNULL( @DimK12StaffId, -1) AS 'K12StaffId'
				, -1 AS 'K12SchoolId'
				, -1 AS 'SchoolstatusId'
				, Sea.DimSeaId 'SeaId'
				, -1 AS 'TitleIStatusId'
				, 1 AS 'OrganizationCount'
				, -1 as 'TitleIParentalInvolveRes'
				, -1 as 'TitleIPartAAllocations'
				, -1 as 'CharterSchoolApproverAgencyId'
				, -1 AS'CharterSchoolManagerOrganizationId'
				, -1 AS'CharterSchoolSecondaryApproverAgencyId'
				, -1 AS'CharterSchoolUpdatedManagerOrganizationId'
				, NULL AS 'SchoolImprovementFunds'
				, -1 AS 'OrganizationStatusId'
				, -1 AS 'SchoolstateStatusId'
				, ISNULL(soff.FederalProgramFundingAllocationType, 'MISSING') AS 'FederalFundAllocationType'
				, ISNULL(soff.FederalProgramCode, 'MISSING') AS 'FederalProgramCode'
				, convert(int, ISNULL(soff.FederalProgramsFundingAllocation,0))				AS FederalFundAllocated
				, -1 AS 'ComprehensiveAndTargetedSupportId'
				, -1 AS 'CharterSchoolStatusId'
				, -1 AS 'DimSubgroupId'
				, -1 AS 'DimComprehensiveSupportReasonApplicabilityId'

	--into ##Fact
			From Staging.StateDetail ssd

			inner join RDS.DimSeas Sea
				on ssd.SeaStateIdentifier = Sea.SeaIdentifierState
				and isnull(Sea.RecordEndDateTime, '6/30/' + convert(varchar, @SchoolYear)) >= '6/30/' + convert(varchar, @SchoolYear)
			LEFT JOIN Staging.OrganizationFederalFunding soff 
				ON ssd.SeaStateIdentifier = soff.OrganizationIdentifier
				AND ssd.SchoolYear = soff.SchoolYear
				and soff.OrganizationType in (select SeaOrganizationType from #seaOrganizationTypes)
				--AND soff.REAPAlternativeFundingStatusCode IS NOT NULL -- Not sure if we need this



		-------------------------------
		--LEA
		-------------------------------
		-- Get distinct list of LEAs from Staging along with latest start date (in cases where more than one status/startdate exists for an LEA
		IF OBJECT_ID(N'tempdb..#SortLEAs') IS NOT NULL DROP TABLE #SortLEAs
		IF OBJECT_ID(N'tempdb..#DistinctLEAs') IS NOT NULL DROP TABLE #DistinctLEAs

		SELECT DISTINCT
			DimLeaId, LEAIdentifierState, RecordStartDateTime, 
			ROW_NUMBER() OVER (
				PARTITION BY LEAIdentifierState
				ORDER BY RecordStartDateTime desc) row_num
		into #SortLEAs
		FROM 
			RDS.DimLeas

		SELECT * 
		into #DistinctLEAs
		From #SortLEAs
		WHERE LEAIdentifierState is not null 
		and row_num = 1
	

			INSERT INTO
	--##Fact
			[RDS].[FactOrganizationCounts] 
			(
				[SchoolYearId]
				, [FactTypeId]
				, [LeaId]
				, [K12StaffId]
				, [K12SchoolId]
				, [SchoolStatusId]
				, [SeaId]
				, [TitleIStatusId]
				, [OrganizationCount]
				, [TitleIParentalInvolveRes]
				, [TitleIPartAAllocations]
				, [CharterSchoolApproverAgencyId]
				, [CharterSchoolManagerOrganizationId]
				, [CharterSchoolSecondaryApproverAgencyId]
				, [CharterSchoolUpdatedManagerOrganizationId]
				, [SchoolImprovementFunds]
				, [OrganizationStatusId]
				, [SchoolStateStatusId]
				, [FederalFundAllocationType]
				, [FederalProgramCode]
				, [FederalFundAllocated]
				, [ComprehensiveAndTargetedSupportId]
				, [CharterSchoolStatusId]
				, [DimSubgroupId]
				, [DimComprehensiveSupportReasonApplicabilityId]
			)
			SELECT DISTINCT
				@SchoolYearId													AS 'SchoolYearId'
				, @factTypeId													AS FactTypeId
				, rdl.DimLeaID													AS LeaId
				, -1															AS K12StaffId
				, -1															AS K12SchoolId
				, -1															AS SchoolstatusId
				, -1															AS SeaId
				, -1															AS TitleIStatusId
				, 1																AS OrganizationCount
				, isnull(round(soff.ParentalInvolvementReservationFunds,0),0)	AS TitleIParentalInvolveRes
				, CASE WHEN soff.FederalProgramCode ='84.010' Then round(soff.FederalProgramsFundingAllocation,0) ELSE 0 END AS TitleIPartAAllocations
				, -1															AS CharterSchoolApproverAgencyId
				, -1															AS CharterSchoolManagerOrganizationId
				, -1															AS CharterSchoolSecondaryApproverAgencyId
				, -1															AS CharterSchoolUpdatedManagerOrganizationId
				, NULL															AS SchoolImprovementFunds
				,ISNULL(organizationStatus.DimK12OrganizationStatusId,-1)		AS OrganizationStatusId
				, -1															AS SchoolstateStatusId
				, ISNULL(soff.FederalProgramFundingAllocationType, 'MISSING')	AS FederalFundAllocationType
				, ISNULL(soff.FederalProgramCode, 'MISSING')					AS FederalProgramCode
				, convert(int, ISNULL(soff.FederalProgramsFundingAllocation,0))				AS FederalFundAllocated
				, -1															AS ComprehensiveAndTargetedSupportId
				, -1															AS CharterSchoolStatusId
				, -1															AS DimSubgroupId
				, -1															AS DimComprehensiveSupportReasonApplicabilityId

			FROM Staging.K12Organization sko
			JOIN #DistinctLEAs dleas
				on sko.LEA_Identifier_State = dleas.LEAIdentifierState
				and sko.LEA_RecordStartDateTime = dleas.RecordStartDateTime
			JOIN RDS.DimLeas rdl
				ON sko.Lea_Identifier_State = rdl.LeaIdentifierState
				and dleas.DimLeaID = rdl.DimLeaID
				and rdl.DimLeaId <> -1 and ReportedFederally = 1
				AND (
					(rdl.RecordStartDateTime < staging.GetFiscalYearStartDate(@SchoolYear) and rdl.RecordEndDateTime IS NULL)
					OR 
					(rdl.RecordStartDateTime >= staging.GetFiscalYearStartDate(@SchoolYear) and rdl.RecordStartDateTime <= staging.GetFiscalYearEndDate(@SchoolYear))
				)
			LEFT JOIN Staging.OrganizationFederalFunding soff
				ON sko.Lea_Identifier_State = soff.OrganizationIdentifier
				AND sko.SchoolYear = soff.SchoolYear
				and soff.OrganizationType in (select LEAOrganizationType from #leaOrganizationTypes)
				--AND soff.REAPAlternativeFundingStatusCode IS NOT NULL

			left JOIN RDS.vwDimK12OrganizationStatuses organizationStatus
				ON organizationStatus.SchoolYear = sko.SchoolYear
				and organizationStatus.GunFreeSchoolsActReportingStatusCode = 'Missing'
				AND organizationStatus.HighSchoolGraduationRateIndicatorStatusCode = 'Missing'
				AND organizationStatus.REAPAlternativeFundingStatusCode = 'Missing'
				AND ISNULL(CAST(sko.LEA_McKinneyVentoSubgrantRecipient AS SMALLINT), -1) = isnull(organizationStatus.McKinneyVentoSubgrantRecipientMap, -1)
			

		-------------------------------
		--School
		-------------------------------
		DECLARE @schoolStateIdentifier VARCHAR(60)

		-- Get distinct list of Schools from Staging along with latest start date (in cases where more than one status/startdate exists for a school
		IF OBJECT_ID(N'tempdb..#SortSchools') IS NOT NULL DROP TABLE #SortSchools
		IF OBJECT_ID(N'tempdb..#DistinctSchools') IS NOT NULL DROP TABLE #DistinctSchools
		IF OBJECT_ID(N'tempdb..#DimCharterSchoolAuthorizers_Primary') IS NOT NULL DROP TABLE #DimCharterSchoolAuthorizers_Primary
		IF OBJECT_ID(N'tempdb..#DimCharterSchoolAuthorizers_Secondary') IS NOT NULL DROP TABLE #DimCharterSchoolAuthorizers_Secondary

		SELECT DISTINCT
			DimK12SchoolId, SchoolIdentifierState, RecordStartDateTime, 
			ROW_NUMBER() OVER (
				PARTITION BY SchoolIdentifierState
				ORDER BY RecordStartDateTime desc) row_num
		into #SortSchools
		from RDS.DimK12Schools


		SELECT * 
		into #DistinctSchools
		From #SortSchools
		WHERE SchoolIdentifierState is not null 
		and row_num = 1

		-- Get Charter School Authorizer data
		-- Primary
		select StateIdentifier, CharterSchoolAuthorizerTypeCode, sko.School_Identifier_State, IsApproverAgency, 
		min(dimCharterSchoolAuthorizerId) 'MinId', max(dimCharterSchoolAuthorizerId) 'MaxId'
		into #DimCharterSchoolAuthorizers_Primary
		from rds.DimCharterSchoolAuthorizers rcsa
		inner join Staging.K12Organization sko
			on sko.School_CharterSchoolIndicator = 1
			and rcsa.StateIdentifier = sko.School_CharterPrimaryAuthorizer
		where rcsa.RecordStartDateTime >= '7/1/' + convert(varchar, @SchoolYear-1) and 
		isnull(rcsa.RecordEndDateTime, '6/30/' + convert(varchar, @SchoolYear)) <= '6/30/' + convert(varchar, @SchoolYear)
		group by rcsa.StateIdentifier, CharterSchoolAuthorizerTypeCode, sko.School_Identifier_State, IsApproverAgency
		order by sko.School_Identifier_State

		-- Secondary
		select StateIdentifier, CharterSchoolAuthorizerTypeCode, sko.School_Identifier_State, IsApproverAgency, 
		min(dimCharterSchoolAuthorizerId) 'MinId', max(dimCharterSchoolAuthorizerId) 'MaxId'
		into #DimCharterSchoolAuthorizers_Secondary
		from rds.DimCharterSchoolAuthorizers rcsa
		inner join Staging.K12Organization sko
			on sko.School_CharterSchoolIndicator = 1
			and rcsa.StateIdentifier = sko.School_CharterSecondaryAuthorizer
		where rcsa.RecordStartDateTime >= '7/1/' + convert(varchar, @SchoolYear-1) and 
		isnull(rcsa.RecordEndDateTime, '6/30/' + convert(varchar, @SchoolYear)) <= '6/30/' + convert(varchar, @SchoolYear)
		group by rcsa.StateIdentifier, CharterSchoolAuthorizerTypeCode, sko.School_Identifier_State, IsApproverAgency
		order by sko.School_Identifier_State


			----INSERT INTO FactOrganizationCounts

			INSERT INTO 
	--##Fact
			[RDS].[FactOrganizationCounts] 
			(
				[SchoolYearId]
				, [FactTypeId]
				, [LeaId]
				, [K12StaffId]
				, [K12SchoolId]
				, [SchoolStatusId]
				, [SeaId]
				, [TitleIStatusId]
				, [OrganizationCount]
				, [TitleIParentalInvolveRes]
				, [TitleIPartAAllocations]
				, [CharterSchoolApproverAgencyId]
				, [CharterSchoolManagerOrganizationId]
				, [CharterSchoolSecondaryApproverAgencyId]
				, [CharterSchoolUpdatedManagerOrganizationId]
				, [SchoolImprovementFunds]
				, [OrganizationStatusId]
				, [SchoolStateStatusId]
				, [FederalFundAllocationType]
				, [FederalProgramCode]
				, [FederalFundAllocated]
				, [ComprehensiveAndTargetedSupportId]
				, [CharterSchoolStatusId]
				, [DimSubgroupId]
				, [DimComprehensiveSupportReasonApplicabilityId]
			)

	SELECT DISTINCT 
				@SchoolYearId AS 'SchoolYearId'
				, @factTypeId AS 'FactTypeId'
				, -1 AS 'LeaId'
				, -1 AS 'K12StaffId'
				, rk12s.DimK12SchoolId AS 'K12SchoolId'
				, ISNULL(s.DimK12SchoolstatusId,-1) AS 'SchoolstatusId'
				, -1 AS  'SeaId'
				, ISNULL(t.DimTitleIStatusId,-1) AS 'TitleIStatusId'
				, 1 AS 'OrganizationCount'
				, -1 AS 'TitleIParentalInvolveRes'
				, -1 AS 'TitleIPartAAllocations' 
				, case when CSAP.IsApproverAgency = 'No' then CSAP.MinId else -1 end 'CharterSchoolApproverAgencyId'
				, case when CSAP.IsApproverAgency = 'Yes' then CSAP.MinId else -1 end 'CharterSchoolManagerOrganizationId'
				, case when CSAS.IsApproverAgency = 'No' then CSAS.MinId else -1 end 'CharterSchoolSecondaryApproverAgencyId'
				, case when CSAS.IsApproverAgency = 'Yes' then CSAS.MinId else -1 end 'CharterSchoolUpdatedManagerOrganizationId'
				--, ISNULL(@dimCharterSchoolAuthorizerId, -1) AS 'CharterSchoolApproverAgencyId'
				--, ISNULL(@dimCharterSchoolManagerId, -1) AS 'CharterSchoolManagerOrganizationId'
				--, ISNULL(@dimCharterSchoolSecondaryAuthorizerId, -1) AS 'CharterSchoolSecondaryApproverAgencyId'
				--, ISNULL(@dimCharterSchoolSecondaryManagerId, -1) AS 'CharterSchoolUpdatedManagerOrganizationId'
				, NULL AS 'SchoolImprovementFunds'
				, ISNULL(organizationStatus.DimK12OrganizationStatusId,-1) AS 'OrganizationStatusId'
				, -1 AS 'SchoolstateStatusId'
				, -1 AS 'FederalFundAllocationType'
				, -1 AS 'FederalProgramCode'
				, -1 AS 'FederalFundAllocated'
				, -1 AS 'ComprehensiveAndTargetedSupportId'
				, -1 AS 'CharterSchoolStatusId'
				, -1 AS 'DimSubgroupId'
				, -1 AS 'DimComprehensiveSupportReasonApplicabilityId'


			FROM Staging.K12Organization sk12o
			JOIN #DistinctSchools dschools
				on sk12o.School_Identifier_State = dschools.SchoolIdentifierState
				and sk12o.School_RecordStartDateTime = dschools.RecordStartDateTime

			JOIN RDS.DimK12Schools rk12s 
				ON sk12o.School_Identifier_State = rk12s.SchoolIdentifierState
				and dschools.DimK12SchoolID = rk12s.DimK12SchoolId
				and rk12s.DimK12SchoolId <> -1 and ReportedFederally = 1
				AND (
					(rk12s.RecordStartDateTime < staging.GetFiscalYearStartDate(@SchoolYear) and rk12s.RecordEndDateTime IS NULL)
					OR 
					(rk12s.RecordStartDateTime >= staging.GetFiscalYearStartDate(@SchoolYear) and rk12s.RecordStartDateTime <= staging.GetFiscalYearEndDate(@SchoolYear))
				)

			LEFT JOIN rds.vwDimK12Schoolstatuses s
				ON isnull(s.MagnetOrSpecialProgramEmphasisSchoolMap, s.MagnetOrSpecialProgramEmphasisSchoolCode) = isnull(sk12o.School_MagnetOrSpecialProgramEmphasisSchool, 'MISSING')
				AND isnull(s.NslpStatusMap, s.NslpStatusCode) = isnull(sk12o.School_NationalSchoolLunchProgramStatus, 'MISSING')
				AND isnull(s.SharedTimeIndicatorMap, s.SharedTimeIndicatorCode) = isnull(sk12o.School_SharedTimeIndicator, 'MISSING')
				AND isnull(s.VirtualSchoolStatusMap, s.VirtualSchoolStatusCode) = isnull(sk12o.School_VirtualSchoolStatus, 'MISSING')
				--AND s.SchoolImprovementStatusCode = sk12o.ImprovementStatusCode -- JW Can't find this in sk12o
				AND isnull(s.PersistentlyDangerousStatusMap, s.PersistentlyDangerousStatusCode) = isnull(sk12o.School_SchoolDangerousStatus, 'MISSING')
				AND isnull(s.StatePovertyDesignationMap, s.StatePovertyDesignationCode) = isnull(sk12o.School_StatePovertyDesignation, 'MISSING')
				AND isnull(s.ProgressAchievingEnglishLanguageMap, s.ProgressAchievingEnglishLanguageCode) = isnull(sk12o.School_ProgressAchievingEnglishLanguageProficiencyIndicatorStatus, 'MISSING')
			--LEFT JOIN rds.DimK12SchoolstateStatuses dss 
			--	ON dss.SchoolStateStatusCode=sk12o.School_IndicatorStatusType -- This isn't used, and if it was, we should include it in vwDimK12SchoolStatuses 
			LEFT JOIN rds.DimTitleIStatuses t 
				ON t.TitleIInstructionalServicesCode = NULL-- sk12o.TitleIinstructionalServiceCode
				AND t.TitleIProgramTypeCode = NULL --sk12o.Title1ProgramTypeCode
				AND t.TitleISchoolStatusCode = NULL --sk12o.TitleISchoolStatusCode
				AND t.TitleISupportServicesCode = NULL --sk12o.Title1SupportServiceCode
			LEFT JOIN rds.vwDimK12OrganizationStatuses organizationStatus 
				ON 
				organizationStatus.SchoolYear = sk12o.SchoolYear
				and isnull(sk12o.School_GunFreeSchoolsActReportingStatus, 'MISSING') = isnull(organizationStatus.GunFreeSchoolsActReportingStatusMap, organizationStatus.GunFreeSchoolsActReportingStatusCode)
				AND organizationStatus.HighSchoolGraduationRateIndicatorStatusCode = 'Missing' --sk12o.GraduationRateCode
				AND organizationStatus.REAPAlternativeFundingStatusCode = 'Missing' -- sk12o.REAPAlternativeFundingStatusCode
				AND organizationStatus.McKinneyVentoSubgrantRecipientCode = 'Missing' -- sk12o.McKinneyVentoSubgrantRecipient
			LEFT JOIN #DimCharterSchoolAuthorizers_Primary CSAP
				on CSAP.School_Identifier_State = sk12o.School_Identifier_State
			LEFT JOIN #DimCharterSchoolAuthorizers_Secondary CSAS
				on CSAS.School_Identifier_State = sk12o.School_Identifier_State

END TRY
BEGIN CATCH
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), 2, 'RDS.FactOrganizationCounts - Error Occurred - ' + CAST(ERROR_MESSAGE() AS VARCHAR(900)))
END CATCH

END

