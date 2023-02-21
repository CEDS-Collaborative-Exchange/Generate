CREATE PROCEDURE [RDS].[Migrate_OrganizationCounts]
	@factTypeCode AS VARCHAR(50) = 'directory',
	@runAsTest AS BIT,
	@dataCollectionName AS VARCHAR(50) = NULL
AS   
BEGIN
-- migrate_OrganizationCounts
BEGIN TRY

	BEGIN
		
		--Get the school year being migrated
		declare @SchoolYear int
		select @SchoolYear = d.SchoolYear
		from rds.DimSchoolYears d
		inner join rds.DimSchoolYearDataMigrationTypes dd 
			on dd.DimSchoolYearId = d.DimSchoolYearId 
		inner join rds.DimDataMigrationTypes b 
			on b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
		where d.DimSchoolYearId <> -1 
		and dd.IsSelected = 1 
		and DataMigrationTypeCode = 'rds'

		DECLARE @dataCollectionId AS INT

		SELECT @dataCollectionId = DataCollectionId 
		FROM dbo.DataCollection
		WHERE DataCollectionName = @dataCollectionName

		DECLARE @migrationType AS VARCHAR(50)
		DECLARE @dataMigrationTypeId AS INT
	
		SELECT @dataMigrationTypeId = DimDataMigrationTypeId
		FROM rds.DimDataMigrationTypes WHERE DataMigrationTypeCode = 'rds'
		SET @migrationType='rds'

		DECLARE @factTypeId AS INT
		SELECT @factTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = @factTypeCode

		DECLARE @organizationElementTypeId AS INT
		SELECT @organizationElementTypeId = RefOrganizationElementTypeId
		FROM dbo.RefOrganizationElementType 
		WHERE [Code] = '001156'

		DECLARE @seaOrgTypeId AS INT
		SELECT @seaOrgTypeId = RefOrganizationTypeId
		FROM dbo.RefOrganizationType 
		WHERE [Code] = 'SEA' AND RefOrganizationElementTypeId = @organizationElementTypeId

		DECLARE @ieuOrgTypeId AS INT
		SELECT @ieuOrgTypeId = RefOrganizationTypeId
		FROM dbo.RefOrganizationType 
		WHERE ([Code] = 'IEU') AND RefOrganizationElementTypeId = @organizationElementTypeId

		DECLARE @leaOrgTypeId AS INT
		SELECT @leaOrgTypeId = RefOrganizationTypeId
		FROM dbo.RefOrganizationType 
		WHERE ([Code] = 'LEA') AND RefOrganizationElementTypeId = @organizationElementTypeId

		DECLARE @leaNotFederalOrgTypeId AS INT
		SELECT @leaNotFederalOrgTypeId = RefOrganizationTypeId
		FROM dbo.RefOrganizationType 
		WHERE ([Code] = 'LEANotFederal') AND RefOrganizationElementTypeId = @organizationElementTypeId

		DECLARE @charterSchoolAuthTypeId AS INT
		SELECT @charterSchoolAuthTypeId = RefOrganizationTypeId
		FROM dbo.RefOrganizationType 
		WHERE [Code] = 'CharterSchoolAuthorizingOrganization' AND RefOrganizationElementTypeId = @organizationElementTypeId

		DECLARE @charterSchoolMgrTypeId AS INT
		SELECT @charterSchoolMgrTypeId = RefOrganizationTypeId
		FROM dbo.RefOrganizationType 
		WHERE [Code] = 'CharterSchoolManagementOrganization' AND RefOrganizationElementTypeId = @organizationElementTypeId

		DECLARE @seaIdentifierTypeId AS INT	
		SELECT @seaIdentifierTypeId = RefOrganizationIdentifierTypeId			
		FROM dbo.RefOrganizationIdentifierType
		WHERE [Code] = '001491'

		DECLARE @seaFederalIdentificationSystemId AS INT
		SELECT @seaFederalIdentificationSystemId = RefOrganizationIdentificationSystemId			
		FROM dbo.RefOrganizationIdentificationSystem
		WHERE [Code] = 'Federal'
		AND RefOrganizationIdentifierTypeId = @seaIdentifierTypeId

		DECLARE @leaIdentifierTypeId AS INT
		SELECT @leaIdentifierTypeId = RefOrganizationIdentifierTypeId			
		FROM dbo.RefOrganizationIdentifierType
		WHERE [Code] = '001072'

		DECLARE @leaNCESIdentificationSystemId AS INT			
		SELECT @leaNCESIdentificationSystemId = RefOrganizationIdentificationSystemId		
		FROM dbo.RefOrganizationIdentificationSystem
		WHERE [Code] = 'NCES' AND RefOrganizationIdentifierTypeId = @leaIdentifierTypeId
		
		DECLARE @leaSEAIdentificationSystemId AS INT
		SELECT @leaSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
		FROM dbo.RefOrganizationIdentificationSystem
		WHERE [Code] = 'SEA'
		AND RefOrganizationIdentifierTypeId = @leaIdentifierTypeId

		DECLARE @ieuSEAIdentificationSystemId AS INT
		SELECT @ieuSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
		FROM dbo.RefOrganizationIdentificationSystem
		WHERE [Code] = 'IEU'

		DECLARE @gradeLevelTypeId AS INT = 0
		SELECT @gradeLevelTypeId = RefGradeLevelTypeId 
		FROM dbo.RefGradeLevelType WHERE code = '000131'

		DECLARE @K12StaffRole VARCHAR(50) = 'Chief State School Officer'

		-- SEA
		DECLARE @seaOrganizationId AS INT
		
		SELECT @seaOrganizationId = OrganizationId
		FROM dbo.OrganizationDetail
		WHERE RefOrganizationTypeId = @seaOrgTypeId

		DECLARE @seaName AS VARCHAR(100)

		SELECT @seaName = Name
		FROM dbo.OrganizationDetail
		WHERE RefOrganizationTypeId = @seaOrgTypeId
		AND RecordEndDateTime IS NULL
		-- State

		DECLARE @seaIdentifier AS VARCHAR(50)

		SELECT @seaIdentifier = Identifier
		FROM dbo.OrganizationIdentifier 
		WHERE OrganizationId = @seaOrganizationId
		AND RefOrganizationIdentificationSystemId = @seaFederalIdentificationSystemId
		AND RefOrganizationIdentifierTypeId = @seaIdentifierTypeId

		DECLARE @stateName AS VARCHAR(100)
		SELECT @stateName = [Description]
		FROM dbo.RefStateAnsicode
		WHERE [Code] = @seaIdentifier

		DECLARE @stateCode AS VARCHAR(5), @stateDescription AS VARCHAR(1000)
		SELECT @stateCode = [Code], @stateDescription = [Description]
		FROM dbo.RefState
		WHERE [Description] = @stateName

		DECLARE @CSSORoleId AS INT
		SELECT @CSSORoleId = RoleId
		FROM dbo.[Role] WHERE Name = 'Chief State School Officer'

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
	
		DELETE FROM rds.FactOrganizationCounts 
		WHERE SchoolYearId IN (
			SELECT d.DimSchoolYearId FROM rds.DimSchoolYears d
			JOIN rds.DimSchoolYearDataMigrationTypes dd ON dd.DimSchoolYearId = d.DimSchoolYearId
			JOIN rds.DimDataMigrationTypes b ON b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
		WHERE d.DimSchoolYearId <> -1 AND dd.IsSelected=1 AND DataMigrationTypeCode = 'rds')
			AND FactTypeId = @factTypeId

		SELECT @DimK12StaffId = MAX(p.DimK12StaffId) 
		FROM rds.DimK12Staff p
		JOIN dbo.[Role] r ON p.K12StaffRole = r.Name
		WHERE r.roleId = @CSSORoleId AND p.RecordEndDateTime IS NULL

		-------------------------------
		--SEA
		-------------------------------
		DECLARE SEA_Cursor cursor for 						
		SELECT DimSeaId FROM rds.DimSeas WHERE DimSeaId <> -1 AND RecordEndDateTime IS NULL

		open SEA_Cursor
		FETCH NEXT FROM SEA_Cursor INTO @dimSeaId							

		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			DECLARE @SeaDateQuery AS rds.SeaDateTableType
			
			INSERT INTO @SeaDateQuery (
				  DimSeaId
				, DimSchoolYearId
				, CountDate		
				, SchoolYear		
				, SessionBeginDate	
				, SessionEndDate	
			)
			exec rds.Migrate_DimSchoolYears_Seas @dimSeaId

			DECLARE @SeaFederalFundQuery AS table (
				DimCountDateId INT,
				DimSeaId INT,
				FederalProgramsFundingAllocation  [numeric](12, 2),
				FederalFundAllocationType VARCHAR(20),
				FederalProgramCode VARCHAR(20)					
			)

			INSERT INTO @SeaFederalFundQuery (
				DimCountDateId 
				, DimSeaId 
				, FederalProgramsFundingAllocation
				, FederalFundAllocationType 
				, FederalProgramCode 					
			)
			SELECT DimSchoolYearId,Seadate.dimSeaID, 
			FederalProgramsFundingAllocation AS 'FederalProgramsFundingAllocation',
			allocationType.Code AS 'FederalFundAllocationType',	federalProgramCode AS 'FederalProgramCode'
		    FROM dbo.OrganizationDetail o
			JOIN dbo.OrganizationIdentifier oi on o.OrganizationId = oi.OrganizationId
			JOIN dbo.OrganizationCalendar oc 
				ON o.OrganizationId = oc.OrganizationId 
				AND oi.Identifier =  @seaIdentifier
				AND o.RecordEndDateTime IS NULL
				AND (@dataCollectionId IS NULL OR oc.DataCollectionId = @dataCollectionId)	
			JOIN dbo.OrganizationCalendarSession s 
				ON s.OrganizationCalendarId = oc.OrganizationCalendarId
				AND (@dataCollectionId IS NULL OR s.DataCollectionId = @dataCollectionId)	
			JOIN [dbo].[K12FederalFundAllocation] k12fund 
				ON s.[OrganizationCalendarSessionId] = k12fund.[OrganizationCalendarSessionId]	
				AND (@dataCollectionId IS NULL OR k12fund.DataCollectionId = @dataCollectionId)	
			LEFT JOIN dbo.RefFederalProgramFundingAllocationType allocationType 
				ON allocationType.RefFederalProgramFundingAllocationTypeId = k12fund.RefFederalProgramFundingAllocationTypeId
			JOIN (
					SELECT 
						 l.*
						, @seaIdentifier AS organizationId 
					FROM  @SeaDateQuery l
				) AS SeaDate 
				ON SeaDate.organizationId = oi.Identifier 
				AND (s.BeginDate BETWEEN SeaDate.SessionBeginDate AND SeaDate.SessionEndDate)
			WHERE (@dataCollectionId IS NULL OR o.DataCollectionId = @dataCollectionId)	
			
			INSERT INTO [RDS].[FactOrganizationCounts](
				[SchoolYearId]
				, [OrganizationStatusId]
				, [FactTypeId]
				, [LeaId]
				, [K12StaffId]
				, [K12SchoolId]
				, [SchoolStatusId]
				, [SeaId]
				, [TitleIStatusId]
				, [OrganizationCount]
				, [CharterSchoolApproverAgencyId]
				, [CharterSchoolManagerOrganizationId]
				, [CharterSchoolSecondaryApproverAgencyId]
				, [CharterSchoolUpdatedManagerOrganizationId]
				, [SchoolStateStatusId]
				, [FederalFundAllocationType]
				, [FederalProgramCode]
				, [FederalFundAllocated]
			)
			SELECT s.DimSchoolYearId, -1,	@factTypeId, -1 AS 'DimLeaId', ISNULL( @DimK12StaffId, -1) AS 'DimK12StaffId',-1 AS 'DimK12SchoolId',
				-1 AS 'DimK12SchoolstatusId', @dimSeaId, -1 AS 'DimTitleIStatusId', 1 AS OrganizationCount, 
				-1 AS 'DimCharterSchoolAuthorizerId',
				-1 AS'DimCharterSchoolManagerOrganizationId', -1 AS'DimCharterSchoolSecondaryApproverAgencyId',	
				-1 AS'DimCharterSchoolUpdatedManagerOrganizationId',
				-1 AS 'DimK12SchoolstateStatusId'
				, ISNULL(fund.FederalFundAllocationType, 'MISSING') AS 'FederalFundAllocationType'
				, ISNULL(fund.FederalProgramCode, 'MISSING') AS 'FederalProgramCode'
				, ISNULL(fund.FederalProgramsFundingAllocation,0)
			From @SeaDateQuery s
			LEFT JOIN @SeaFederalFundQuery fund 
				ON s.DimSeaId = fund.DimSeaId 
				AND s.DimSchoolYearId = fund.DimCountDateId 

			FETCH NEXT FROM SEA_Cursor INTO @dimSeaId			
			END
		
		close SEA_Cursor
		DEALLOCATE SEA_Cursor

		-------------------------------
		--LEA
		-------------------------------
		DECLARE @leaIdentifier as varchar(50)
		DECLARE LEA_Cursor cursor for 						
		SELECT DimLeaId, LeaIdentifierState FROM rds.DimLeas 
		where DimLeaId <> -1 and ReportedFederally = 1
		AND (RecordEndDateTime is NULL or RecordEndDateTime > staging.GetFiscalYearStartDate(@SchoolYear))
		AND RecordStartDateTime <= staging.GetFiscalYearEndDate(@SchoolYear)

		open LEA_Cursor
		FETCH NEXT FROM LEA_Cursor INTO @dimLeaId, @leaIdentifier							

		WHILE @@FETCH_STATUS = 0
		BEGIN
		
			DECLARE @LeaDateQuery AS rds.LeaDateTableType
			
			INSERT INTO @LeaDateQuery (
				DimLeaId
				, DimSchoolYearId
				, CountDate		
				, SchoolYear		
				, SessionBeginDate	
				, SessionEndDate	
			)
			exec rds.Migrate_DimSchoolYears_Leas @dimLeaId
	
			--Migrate_DimOrganizationStatuses_LEA

			DECLARE @leaOrganizationStatusQuery AS table (
				DimSchoolYearId INT,
				DimLeaId INT,
				REAPAlternativeFundingStatusCode VARCHAR(50),
				GunFreeStatusCode VARCHAR(50),
				GraduationRateCode VARCHAR(50),
				McKinneyVentoSubgrantRecipient VARCHAR(50)
			)
			INSERT INTO @leaOrganizationStatusQuery (
				DimLeaId 
				, DimSchoolYearId 
				, REAPAlternativeFundingStatusCode
				, GunFreeStatusCode
				, GraduationRateCode
				, McKinneyVentoSubgrantRecipient
			)
			exec [RDS].[Migrate_DimOrganizationStatuses_Lea] @LeaDateQuery, @dataCollectionId

			------------------------------------------------------------------------------------------------
			-- MIGRATE LEA FEDERAL FUND ALLOCATIONS
			------------------------------------------------------------------------------------------------

			DECLARE @leaFederalFundQuery AS table (
				DimSchoolYearId INT,
				DimLeaId INT,
				ParentalInvolvementReservationFunds  [numeric](12, 2),
				FederalProgramsFundingAllocation  [numeric](12, 2),
				FederalFundAllocationType VARCHAR(20),
				FederalProgramCode VARCHAR(20)					
			)
			INSERT INTO @leaFederalFundQuery (
				DimSchoolYearId 
				, DimLeaId 
				, ParentalInvolvementReservationFunds 
				, FederalProgramsFundingAllocation
				, FederalFundAllocationType 
				, FederalProgramCode 					
			)
			SELECT 
				lea.DimSchoolYearId,
				lea.dimLeaID, 
				leaFund.ParentalInvolvementReservationFunds,
				FederalProgramsFundingAllocation AS 'FederalProgramsFundingAllocation',
				allocationType.Code AS 'FederalFundAllocationType',	
				federalProgramCode AS 'FederalProgramCode'
		    FROM dbo.OrganizationDetail o
			JOIN dbo.OrganizationIdentifier oi on o.OrganizationId = oi.OrganizationId 

			JOIN rds.DimLeas l
				on oi.identifier = l.LeaIdentifierState

			JOIN @LeaDateQuery lea
				on Lea.DimLeaid = l.DimLeaid
			
			LEFT JOIN dbo.OrganizationCalendar oc 
				ON oc.CalendarYear = @SchoolYear
				and o.organizationid = oc.OrganizationId 

				-- JW 7/12/2022 Recommended change from JC -----------------------------------------------------------------
				and (isnull(o.RecordEndDateTime, Staging.GetFiscalYearEndDate(@SchoolYear))
					between staging.GetFiscalYearStartDate(@SchoolYear) and staging.GetFiscalYearEndDate(@SchoolYear))
				-------------------------------------------------------------------------------------------------------------	
				AND (@dataCollectionId IS NULL OR oc.DataCollectionId = @dataCollectionId)	

			LEFT JOIN dbo.OrganizationCalendarSession s 
				ON s.OrganizationCalendarId = oc.OrganizationCalendarId
				AND (@dataCollectionId IS NULL OR s.DataCollectionId = @dataCollectionId)
			
			LEFT JOIN dbo.K12LeaFederalFunds leaFund 
				ON leaFund.[OrganizationCalendarSessionId] = s.OrganizationCalendarSessionId
				AND (@dataCollectionId IS NULL OR leaFund.DataCollectionId = @dataCollectionId)	

			LEFT JOIN [dbo].[K12FederalFundAllocation] k12fund 
				ON s.OrganizationCalendarSessionId = k12fund.OrganizationCalendarSessionId	
				AND (@dataCollectionId IS NULL OR k12fund.DataCollectionId = @dataCollectionId)	

			LEFT JOIN dbo.RefFederalProgramFundingAllocationType allocationType 
				ON allocationType.RefFederalProgramFundingAllocationTypeId = k12fund.RefFederalProgramFundingAllocationTypeId

					
			WHERE 
			(@dataCollectionId IS NULL OR o.DataCollectionId = @dataCollectionId)	

			-- Combine Dimension Data
			----------------------------

			create table #leaQueryOutput (
				QueryOutputId INT IDENTITY(1,1) NOT NULL,
				DimSchoolYearId INT,
				DimLeaId INT,
				OrgCount INT,
				[TitleiParentalInvolveRes] INT,
				[TitleiPartaAllocations] INT,
				McKinneyVentoSubgrantRecipient VARCHAR(50),
				REAPAlternativeFundingStatusCode VARCHAR(50),
				GunFreeStatusCode VARCHAR(50),
				GraduationRateCode VARCHAR(50),
				FederalFundAllocationType VARCHAR(20),
				FederalProgramCode VARCHAR(20),
				FederalFundAllocated INT
			)
			INSERT INTO #leaQueryOutput (
				DimSchoolYearId 
				, DimLeaId 
				, OrgCount
				, TitleiParentalInvolveRes
				, TitleiPartaAllocations
				, REAPAlternativeFundingStatusCode
				, GunFreeStatusCode 
				, GraduationRateCode
				, McKinneyVentoSubgrantRecipient
				, FederalFundAllocationType
				, FederalProgramCode 
				, FederalFundAllocated
			)
			SELECT 
				distinct -- JW 07/12/2022
				s.DimSchoolYearId,
				s.DimLeaId
				, 1
				, round(ParentalInvolvementReservationFunds,0)
				, CASE WHEN FederalProgramCode ='84.010' Then round(FederalProgramsFundingAllocation,0) ELSE 0 END AS 'TitleiPartaAllocations' 
				, ISNULL(dimOrganizationStatus.REAPAlternativeFundingStatusCode,'MISSING')
				, ISNULL(dimOrganizationStatus.GunFreeStatusCode,'MISSING')
				, ISNULL(dimOrganizationStatus.GraduationRateCode,'MISSING')
				, ISNULL(dimOrganizationStatus.McKinneyVentoSubgrantRecipient,'MISSING')
				, ISNULL(fund.FederalFundAllocationType,'MISSING')
				, ISNULL(fund.FederalProgramCode, 'MISSING')
				, ISNULL(FederalProgramsFundingAllocation,0)
			From @LeaDateQuery s
			LEFT JOIN @leaFederalFundQuery fund 
				ON s.DimLeaId = fund.DimLeaId 
				AND s.DimSchoolYearId = fund.DimSchoolYearId 
			LEFT JOIN @leaOrganizationStatusQuery dimOrganizationStatus 
				ON s.DimLeaId = dimOrganizationStatus.DimLeaId 
				AND s.DimSchoolYearId = dimOrganizationStatus.DimSchoolYearId 
				
		-- INSERT INTO FactOrganization 
						
			INSERT INTO [RDS].[FactOrganizationCounts] (
				[SchoolYearId]
				, [OrganizationStatusId]
				, [FactTypeId]
				, [LeaId]
				, [K12StaffId]
				, [K12SchoolId]
				, [SchoolStatusId]
				, [SeaId]
				, [TitleIStatusId]
				, [OrganizationCount]
				, [TitleiParentalInvolveRes]
				, [TitleiPartaAllocations]
				, [CharterSchoolApproverAgencyId]
				, [CharterSchoolManagerOrganizationId]
				, [CharterSchoolSecondaryApproverAgencyId]
				, [CharterSchoolUpdatedManagerOrganizationId]
				, [SchoolStateStatusId]
				, [FederalFundAllocationType]
				, [FederalProgramCode]
				, [FederalFundAllocated]
			)
			SELECT 
				q.DimSchoolYearId
				, ISNULL(dimOrganizationStatus.DimK12OrganizationStatusId,-1) AS 'DimK12OrganizationStatusId'
				, @factTypeId
				, @dimLeaId AS 'DimLeaId'
				, -1 AS 'DimK12StaffId'
				, -1 AS 'DimK12SchoolId'
				, -1 AS 'DimK12SchoolstatusId'
				, -1 AS  'DimSeaId'
				, -1 AS 'DimTitleIStatusId'
				, 1 AS OrganizationCount
				, ISNULL(q.TitleiParentalInvolveRes,0)
				, ISNULL(q.TitleiPartaAllocations,0)
				, -1 AS 'DimCharterSchoolAuthorizerId'
				, -1 AS'DimCharterSchoolManagerOrganizationId'
				, -1 AS'DimCharterSchoolSecondaryApproverAgencyId'
				, -1 AS'DimCharterSchoolUpdatedManagerOrganizationId'
				, -1 AS 'DimK12SchoolstateStatusId'
				, ISNULL(q.FederalFundAllocationType, 'MISSING') AS 'FederalFundAllocationType'
				, ISNULL(q.FederalProgramCode, 'MISSING') AS 'FederalProgramCode'
				, ISNULL(q.FederalFundAllocated,0)
			FROM #leaQueryOutput q
			LEFT JOIN rds.DimK12OrganizationStatuses dimOrganizationStatus 
				ON dimOrganizationStatus.REAPAlternativeFundingStatusCode = q.REAPAlternativeFundingStatusCode
				AND dimOrganizationStatus.GunFreeSchoolsActReportingStatusCode = q.GunFreeStatusCode 
				AND dimOrganizationStatus.HighSchoolGraduationRateIndicatorStatusCode = q.GraduationRateCode
				AND dimOrganizationStatus.McKinneyVentoSubgrantRecipientCode = q.McKinneyVentoSubgrantRecipient

			DELETE FROM @LeaDateQuery
			DELETE FROM @leaOrganizationStatusQuery
			DROP table #leaQueryOutput

		FETCH NEXT FROM LEA_Cursor INTO @dimLeaId, @leaIdentifier	
		END
		
		close LEA_Cursor
		DEALLOCATE LEA_Cursor

		-------------------------------
		--School
		-------------------------------
		DECLARE @schoolStateIdentifier VARCHAR(60)

		DECLARE SCH_Cursor cursor for 						
		SELECT DimK12SchoolId, SchoolIdentifierState FROM rds.DimK12Schools WHERE DimK12SchoolId <> -1 --AND RecordEndDateTime IS NULL
		AND RecordEndDateTime is NULL or RecordEndDateTime > staging.GetFiscalYearStartDate(@SchoolYear)

		open SCH_Cursor
		FETCH NEXT FROM SCH_Cursor INTO @DimK12SchoolId, @schoolStateIdentifier							

		WHILE @@FETCH_STATUS = 0
		BEGIN

			SET @dimCharterSchoolManagerId = -1
			SET @dimCharterSchoolSecondaryManagerId = -1
			SET @dimCharterSchoolAuthorizerId = -1
			SET @dimCharterSchoolSecondaryAuthorizerId = -1
			SET @count = 0
 
			DECLARE @SchoolDateQuery AS rds.SchoolDateTableType
			INSERT INTO @SchoolDateQuery (
				DimSchoolId					
				, DimSchoolYearId				
				, SubmissionYearDate					
				, [Year]			
				, SubmissionYearStartDate				
				, SubmissionYearEndDate
--				, SchoolOrganizationId				
			)
			exec rds.Migrate_DimSchoolYears_K12Schools @DimK12SchoolId
			
			IF @factTypeCode = 'directory'
			BEGIN
			    -- Migrate_DimOrganizationStatuses_School
			    DECLARE @organizationStatusSchoolQuery AS table (
				    DimCountDateId INT,
				    DimK12SchoolId INT,
				    REAPAlternativeFundingStatusCode VARCHAR(50),
				    GunFreeStatusCode VARCHAR(50),
				    GraduationRateCode VARCHAR(50),
				    McKinneyVentoSubgrantRecipient varchar(50)
			    )
			    INSERT INTO @organizationStatusSchoolQuery (
				    DimK12SchoolId 
				    , DimCountDateId 
				    , REAPAlternativeFundingStatusCode
				    , GunFreeStatusCode
				    , GraduationRateCode
				    , McKinneyVentoSubgrantRecipient
			    )
			    exec [RDS].[Migrate_DimOrganizationStatuses_School] @SchoolDateQuery, @dataCollectionId

			    DECLARE @schoolStatusQuery AS table (
				    DimCountDateId INT,
				    DimK12SchoolId INT,
				    schoolOrganizationId INT,
				    NSLPStatusCode VARCHAR(50),
				    MagnetStatusCode VARCHAR(50),
				    VirtualStatusCode VARCHAR(50),
				    SharedTimeStatusCode VARCHAR(50),
				    ImprovementStatusCode VARCHAR(50),
				    DangerousStatusCode VARCHAR(50),
				    StatePovertyDesignationCode VARCHAR(50),
				    ProgressAchievingEnglishLanguageCode VARCHAR(50),
				    SchoolStateStatusCode VARCHAR(50)
			    )
			    INSERT INTO @schoolStatusQuery (
				    DimCountDateId 
				    , DimK12SchoolId 
				    , schoolOrganizationId
				    , NSLPStatusCode 
				    , MagnetStatusCode 
				    , VirtualStatusCode 
				    , SharedTimeStatusCode
				    , ImprovementStatusCode
				    , DangerousStatusCode
				    , StatePovertyDesignationCode
				    , ProgressAchievingEnglishLanguageCode
				    , SchoolStateStatusCode
			    )
			    exec [RDS].[Migrate_DimK12Schoolstatuses_School] @SchoolDateQuery, @dataCollectionId

			    DECLARE @title1StatusQuery AS table (
				    DimCountDateId INT,
				    DimK12SchoolId INT,
				    TitleISchoolStatusCode VARCHAR(50),
				    TitleIinstructionalServiceCode VARCHAR(50),
				    Title1SupportServiceCode VARCHAR(50),
				    Title1ProgramTypeCode VARCHAR(50)
			    )
			    INSERT INTO @title1StatusQuery (
				    DimCountDateId 
				    , DimK12SchoolId 
				    , TitleISchoolStatusCode 
				    , TitleIinstructionalServiceCode 
				    , Title1SupportServiceCode 
				    , Title1ProgramTypeCode
			    )
			    exec [RDS].[Migrate_DimTitleIStatuses_School] @SchoolDateQuery, @dataCollectionId

			    -- migrate ComprehensiveAndTargetedSupport
			    --DECLARE @ComprehensiveAndTargetedSupport AS table (
				   -- DimCountDateId INT,
				   -- DimK12SchoolId INT,
				   -- ComprehensiveAndTargetedSupportCode VARCHAR(50),
				   -- ComprehensiveSupportCode VARCHAR(50),
				   -- TargetedSupportCode VARCHAR(50)
			    --)
			    --INSERT INTO @ComprehensiveAndTargetedSupport (
				   -- DimCountDateId
				   -- , DimK12SchoolId
				   -- , ComprehensiveAndTargetedSupportCode
				   -- , ComprehensiveSupportCode
				   -- , TargetedSupportCode
			    --)
			    --exec [RDS].[Migrate_DimComprehensiveAndTargetedSupport_School] @SchoolDateQuery, @dataCollectionId

			    Declare @SchImprovementFundQuery AS table (
				    DimCountDateId INT,
				    DimK12SchoolId INT,
				    SchImprovementFund  [numeric](12, 2)
			    )
			    INSERT INTO @SchImprovementFundQuery (
				    DimCountDateId
				    , DimK12SchoolId
				    , SchImprovementFund
			    )
			    SELECT DISTINCT sdq.DimSchoolYearId, schDate.DimSchoolId, schFund.SchoolImprovementAllocation
			    FROM @SchoolDateQuery sdq
			    JOIN rds.DimK12Schools ds
				    ON sdq.DimSchoolId = ds.DimK12SchoolId 	
			    JOIN dbo.OrganizationIdentifier oi
				    ON ds.SchoolIdentifierState = oi.Identifier
			    --JOIN dbo.OrganizationDetail o 
			    --	ON sdq.SchoolOrganizationId = o.OrganizationDetailId
			    JOIN dbo.OrganizationCalendar oc 
				    ON oi.OrganizationId = oc.OrganizationId 
				    AND oc.RecordEndDateTime IS NULL
				    AND (@dataCollectionId IS NULL OR oc.DataCollectionId = @dataCollectionId)	
			    JOIN dbo.OrganizationCalendarSession s 
				    ON s.OrganizationCalendarId = oc.OrganizationCalendarId
				    AND (@dataCollectionId IS NULL OR s.DataCollectionId = @dataCollectionId)	
			    JOIN dbo.K12FederalFundAllocation schFund 
				    ON schFund.[OrganizationCalendarSessionId] = s.OrganizationCalendarSessionId
				    AND (@dataCollectionId IS NULL OR schFund.DataCollectionId = @dataCollectionId)	
			    JOIN dbo.K12School sch 
				    ON sch.OrganizationId = oi.OrganizationId
				    AND (@dataCollectionId IS NULL OR sch.DataCollectionId = @dataCollectionId)	
			    JOIN dbo.K12SchoolImprovement schImprv 
				    ON sch.K12SchoolId = schImprv.K12SchoolId
				    AND (@dataCollectionId IS NULL OR schImprv.DataCollectionId = @dataCollectionId)	
			    JOIN dbo.RefSchoolImprovementFunds refSis 
				    ON schImprv.RefSchoolImprovementFundsId = refSis.RefSchoolImprovementFundsId 
				    AND refSis.Code = 'YES'
			    JOIN (
				    SELECT l.*, ds.SchoolIdentifierState 
				    FROM  @SchoolDateQuery l
				    JOIN rds.DimK12Schools ds
					    ON l.DimSchoolId = ds.DimK12SchoolId 	
			    ) AS schDate 
				    ON schDate.SchoolIdentifierState = oi.Identifier 
				    AND (s.BeginDate BETWEEN schDate.SubmissionYearStartDate AND schDate.SubmissionYearEndDate)
			    WHERE (@dataCollectionId IS NULL OR oi.DataCollectionId = @dataCollectionId)	
			
			END

			IF @factTypeCode = 'CompSupport'
			BEGIN
				-- migrate ComprehensiveSupportIdentificationType
				declare @ComprehensiveSupportIdentificationType as table(
					   DimSchoolYearID int,
					   DimK12SchoolId int,
					   ComprehensiveSupportCode varchar(50),
					   ComprehensiveSupportReasonApplicabilityCode varchar(50)
				    )
				insert into @ComprehensiveSupportIdentificationType (
				    DimSchoolYearID,
				    DimK12SchoolId,
				    ComprehensiveSupportCode,
				    ComprehensiveSupportReasonApplicabilityCode
				)
				exec [RDS].[Migrate_DimComprehensiveSupportIdentificationType_School] @SchoolDateQuery

				-- migrate TargetedSupportIdentificationType
				declare @TargetedSupportIdentificationType as table(
					   DimSchoolYearID int,
					   DimK12SchoolId int,
					   SubgroupCode varchar(50),
					   ComprehensiveSupportReasonApplicabilityCode varchar(50)
				    )
				insert into @TargetedSupportIdentificationType (
				    DimSchoolYearID,
				    DimK12SchoolId,
				    SubgroupCode,
				    ComprehensiveSupportReasonApplicabilityCode
				)
				exec [RDS].[Migrate_DimTargetedSupportIdentificationType_School] @SchoolDateQuery
			END


			SELECT @IsCharterSchool = CharterSchoolIndicator 
			FROM rds.DimK12Schools 
			WHERE SchoolIdentifierState = @schoolStateIdentifier

			if @IsCharterSchool = 1
			begin
				
				select @count = count(DimCharterSchoolAuthorizerId) 
				from rds.DimCharterSchoolAuthorizers
				where SchoolStateIdentifier = @schoolStateIdentifier 
				and IsApproverAgency = 'No'

				IF @count = 1
				BEGIN
					select @dimCharterSchoolAuthorizerId = DimCharterSchoolAuthorizerId 
					from rds.DimCharterSchoolAuthorizers
					where SchoolStateIdentifier = @schoolStateIdentifier 
					and IsApproverAgency = 'No'
				END
				ELSE
				BEGIN
					--Populate the Primary and Secondary Authorizer ID values
					select @dimCharterSchoolAuthorizerId = min(DimCharterSchoolAuthorizerId) 
                        ,@dimCharterSchoolSecondaryAuthorizerId = max(DimCharterSchoolAuthorizerId)
                    from rds.DimCharterSchoolAuthorizers rdcsa
                        inner join rds.dimK12Schools rdks
                            on rdcsa.SchoolStateIdentifier = rdks.SchoolIdentifierState
                        inner join @SchoolDateQuery sdq
                            on rdks.DimK12SchoolId = sdq.DimSchoolId
                    where rdcsa.SchoolStateIdentifier = @schoolStateIdentifier 
                    and rdcsa.IsApproverAgency = 'No'
                    and (rdcsa.RecordStartDateTime >= sdq.SubmissionYearStartDate
                        and ISNULL(rdcsa.RecordEndDateTime, GETDATE()) <= SubmissionYearEndDate)

                    select @dimCharterSchoolSecondaryAuthorizerId = 
                        CASE 
                            WHEN @dimCharterSchoolAuthorizerId = @dimCharterSchoolSecondaryAuthorizerId 
                            THEN NULL 
                            ELSE @dimCharterSchoolSecondaryAuthorizerId 
                        END

				END

				set @count = 0

				select @count = count(DimCharterSchoolAuthorizerId) 
				from rds.DimCharterSchoolAuthorizers
				where SchoolStateIdentifier = @schoolStateIdentifier 
				and IsApproverAgency = 'Yes'

				IF @count = 1
				BEGIN
					select @dimCharterSchoolManagerId = DimCharterSchoolAuthorizerId 
					from rds.DimCharterSchoolAuthorizers
					where SchoolStateIdentifier = @schoolStateIdentifier 
					and IsApproverAgency = 'Yes'
				END
				ELSE
				BEGIN
					select @dimCharterSchoolManagerId = min(DimCharterSchoolAuthorizerId) 
					from rds.DimCharterSchoolAuthorizers
					where SchoolStateIdentifier = @schoolStateIdentifier 
					and IsApproverAgency = 'Yes'

					select @dimCharterSchoolSecondaryManagerId = max(DimCharterSchoolAuthorizerId)
					from rds.DimCharterSchoolAuthorizers
					where SchoolStateIdentifier = @schoolStateIdentifier 
					and IsApproverAgency = 'Yes'
				END
			end
		
			-- =====================================================================================
			-- Combine Dimension Data
			create table #queryOutput (
				QueryOutputId INT IDENTITY(1,1) NOT NULL,
		
				DimSchoolYearId INT,
				DimK12SchoolId INT,

				NSLPStatusCode VARCHAR(50),
				MagnetStatusCode VARCHAR(50),
				VirtualStatusCode VARCHAR(50),
				SharedTimeStatusCode VARCHAR(50),
				PersistentlyDangerousStatusCode VARCHAR(50),
				ImprovementStatusCode VARCHAR(50),
				StatePovertyDesignationCode VARCHAR(50),
				ProgressAchievingEnglishLanguageCode VARCHAR(50),
				SchoolStateStatusCode VARCHAR(50),

				TitleISchoolStatusCode VARCHAR(50),
				TitleIinstructionalServiceCode VARCHAR(50),
				Title1SupportServiceCode VARCHAR(50),
				Title1ProgramTypeCode VARCHAR(50),

				REAPAlternativeFundingStatusCode VARCHAR(50),
				GunFreeStatusCode VARCHAR(50),
				GraduationRateCode VARCHAR(50),
				McKinneyVentoSubgrantRecipient VARCHAR(50),

				OrgCount INT,
				--SchImprovementAllocations INT,
				--ComprehensiveAndTargetedSupportCode VARCHAR(50),
				--ComprehensiveSupportCode VARCHAR(50),
				--TargetedSupportCode VARCHAR(50),
				--SubgroupCode varchar(50),
				--ComprehensiveSupportReasonApplicabilityCode varchar(50)
			)

			INSERT INTO #queryOutput (
				DimSchoolYearId 
				, DimK12SchoolId 
				, NSLPStatusCode 
				, MagnetStatusCode
				, VirtualStatusCode
				, SharedTimeStatusCode 
				, PersistentlyDangerousStatusCode 
				, ImprovementStatusCode 
				, StatePovertyDesignationCode
				, ProgressAchievingEnglishLanguageCode
				, SchoolStateStatusCode
				, TitleISchoolStatusCode 
				, TitleIinstructionalServiceCode 
				, Title1SupportServiceCode 
				, Title1ProgramTypeCode 
				, REAPAlternativeFundingStatusCode
				, GunFreeStatusCode
				, GraduationRateCode
				, McKinneyVentoSubgrantRecipient
				, OrgCount 
				--, SchImprovementAllocations
				--, ComprehensiveAndTargetedSupportCode
				--, ComprehensiveSupportCode
				--, TargetedSupportCode
				--, SubgroupCode
				--, ComprehensiveSupportReasonApplicabilityCode
			)
			SELECT 
				s.DimSchoolYearId
				, s.DimSchoolId
				, ISNULL(schStatus.NSLPStatusCode,'MISSING') 
				, ISNULL(schStatus.MagnetStatusCode,'MISSING')
				, ISNULL(schStatus.VirtualStatusCode,'MISSING')
				, ISNULL(schStatus.SharedTimeStatusCode ,'MISSING')
				, ISNULL(schStatus.DangerousStatusCode ,'MISSING')
				, ISNULL(schStatus.ImprovementStatusCode ,'MISSING')
				, ISNULL(schStatus.StatePovertyDesignationCode ,'MISSING')
				, ISNULL(schStatus.ProgressAchievingEnglishLanguagecode,'MISSING')
				, ISNULL(schStatus.SchoolStateStatusCode,'MISSING')
				, ISNULL(t.TitleISchoolStatusCode ,'MISSING')
				, ISNULL(t.TitleIinstructionalServiceCode ,'MISSING')
				, ISNULL(t.Title1SupportServiceCode ,'MISSING')
				, ISNULL(t.Title1ProgramTypeCode ,'MISSING')
				, ISNULL(organizationStatus.REAPAlternativeFundingStatusCode ,'MISSING')
				, ISNULL(organizationStatus.GunFreeStatusCode ,'MISSING')
				, ISNULL(organizationStatus.GraduationRateCode ,'MISSING')
				, ISNULL(organizationStatus.McKinneyVentoSubgrantRecipient ,'MISSING')
				, 1		
				--, round(SchImprovementFund,0)
				--, ISNULL(cts.ComprehensiveAndTargetedSupportCode ,'MISSING')
				--, ISNULL(cts.ComprehensiveSupportCode ,'MISSING')
				--, ISNULL(cts.TargetedSupportCode ,'MISSING')
				--, ISNULL(tsit.SubgroupCode,'MISSING')
				--, COALESCE(csit.ComprehensiveSupportReasonApplicabilityCode,tsit.ComprehensiveSupportReasonApplicabilityCode,'MISSING')
			From @SchoolDateQuery s
			LEFT JOIN @schoolStatusQuery schStatus 
				ON s.DimSchoolId = schStatus.DimK12SchoolId 
				AND s.DimSchoolYearId = schStatus.DimCountDateId
			LEFT JOIN @title1StatusQuery t 
				ON s.DimSchoolId = t.DimK12SchoolId 
				AND s.DimSchoolYearId = t.DimCountDateId
			LEFT JOIN @SchImprovementFundQuery schImprFund 
				ON s.DimSchoolId = schImprFund.DimK12SchoolId 
				AND s.DimSchoolYearId = schImprFund.DimCountDateId
			LEFT JOIN @organizationStatusSchoolQuery organizationStatus 
				ON s.DimSchoolId = organizationStatus.DimK12SchoolId 
				AND s.DimSchoolYearId = organizationStatus.DimCountDateId
			--LEFT JOIN @ComprehensiveAndTargetedSupport cts 
			--	ON s.DimSchoolId = cts.DimK12SchoolId 
			--	AND s.DimSchoolYearId = cts.DimCountDateId
		 --   LEFT JOIN @ComprehensiveSupportIdentificationType csit
			--    ON s.DimSchoolId = csit.DimK12SchoolId 
			--    AND s.DimSchoolYearId = csit.DimSchoolYearId
		 --   LEFT JOIN @TargetedSupportIdentificationType tsit
			--    ON s.DimSchoolId = tsit.DimK12SchoolId 
			--    AND s.DimSchoolYearId = tsit.DimSchoolYearId
			
			----INSERT INTO FactOrganizationCounts
			INSERT INTO [RDS].[FactOrganizationCounts] (
				[SchoolYearId]
				,[OrganizationStatusId]
				,[FactTypeId]
				,[LeaId]
				,[K12StaffId]
				,[K12SchoolId]
				,[SchoolStatusId]
				,[SchoolStateStatusId]
				,[SeaId]
				,[TitleIStatusId]
				,[OrganizationCount]
				,[CharterSchoolApproverAgencyId]
				,[CharterSchoolManagerOrganizationId]
				,[CharterSchoolSecondaryApproverAgencyId]
				,[CharterSchoolUpdatedManagerOrganizationId]
				--,[SCHOOLIMPROVEMENTFUNDS]
				--,[ComprehensiveAndTargetedSupportId]
				--,[FederalFundAllocated]
				--,[DimSubgroupId]
				--,[DimComprehensiveSupportReasonApplicabilityId]
			)
			SELECT DISTINCT 
				q.DimSchoolYearId
				, ISNULL(organizationStatus.DimK12OrganizationStatusId,-1) AS 'DimOrganizationStatusId'
				, @factTypeId
				, -1 AS 'DimLeaId'
				, -1 AS 'DimK12StaffId'
				, @DimK12SchoolId AS 'DimK12SchoolId'
				, ISNULL(s.DimK12SchoolstatusId,-1) AS 'DimK12SchoolstatusId'
				, ISNULL(dss.DimK12SchoolstateStatusId,-1) AS 'DimK12SchoolstateStatusId'
				, -1 AS  'DimSeaId'
				, ISNULL(t.DimTitleIStatusId,-1) AS 'DimTitleIStatusId'
				, 1 AS OrganizationCount
				, ISNULL(@dimCharterSchoolAuthorizerId, -1) AS 'DimCharterSchoolAuthorizerId'
				, ISNULL(@dimCharterSchoolManagerId, -1) AS 'DimCharterSchoolManagerOrganizationId'
				, ISNULL(@dimCharterSchoolSecondaryAuthorizerId, -1) AS 'DimCharterSchoolSecondaryApproverAgencyId'
				, ISNULL(@dimCharterSchoolSecondaryManagerId, -1) AS 'DimCharterSchoolUpdatedManagerOrganizationId'
				--, ISNULL(q.SchImprovementAllocations,0)
				--, ISNULL(cts.DimComprehensiveAndTargetedSupportId,-1) AS 'DimComprehensiveAndTargetedSupportId'
				--, ISNULL(q.SchImprovementAllocations,0)
				--, ISNULL(sg.DimSubgroupId,-1) as 'DimSubgroupId'
				--, ISNULL(csra.DimComprehensiveSupportReasonApplicabilityId,-1) as 'DimComprehensiveSupportReasonApplicabilityId'
			FROM #queryOutput q
			LEFT JOIN rds.DimK12Schoolstatuses s
				ON s.MagnetOrSpecialProgramEmphasisSchoolCode = q.MagnetStatusCode
				AND s.NSLPStatusCode = q.NSLPStatusCode
				AND s.SharedTimeIndicatorCode = q.SharedTimeStatusCode
				AND s.VirtualSchoolStatusCode = q.VirtualStatusCode
				AND s.SchoolImprovementStatusCode = q.ImprovementStatusCode
				AND s.PersistentlyDangerousStatusCode = q.PersistentlyDangerousStatusCode
				AND s.StatePovertyDesignationCode =q.StatePovertyDesignationCode
				AND s.ProgressAchievingEnglishLanguageCode =q.ProgressAchievingEnglishLanguageCode
			LEFT JOIN rds.DimK12SchoolstateStatuses dss 
				ON dss.SchoolStateStatusCode=q.SchoolStateStatusCode
			LEFT JOIN rds.DimTitleIStatuses t 
				ON t.TitleIInstructionalServicesCode = q.TitleIinstructionalServiceCode
				AND t.TitleIProgramTypeCode = q.Title1ProgramTypeCode
				AND t.TitleISchoolStatusCode = q.TitleISchoolStatusCode
				AND t.TitleISupportServicesCode = q.Title1SupportServiceCode
			LEFT JOIN rds.DimK12OrganizationStatuses organizationStatus 
				ON organizationStatus.GunFreeSchoolsActReportingStatusCode = q.GunFreeStatusCode
				AND organizationStatus.HighSchoolGraduationRateIndicatorStatusCode = q.GraduationRateCode
				AND organizationStatus.REAPAlternativeFundingStatusCode = q.REAPAlternativeFundingStatusCode
				AND organizationStatus.McKinneyVentoSubgrantRecipientCode = q.McKinneyVentoSubgrantRecipient
			--LEFT JOIN rds.DimComprehensiveAndTargetedSupports cts 
			--	ON cts.ComprehensiveAndTargetedSupportCode = q.ComprehensiveAndTargetedSupportCode
			--	AND cts.ComprehensiveSupportCode = q.ComprehensiveSupportCode
			--	AND cts.TargetedSupportCode = q.TargetedSupportCode
			-- LEFT JOIN rds.DimSubgroups sg
			--	ON q.SubgroupCode = sg.SubgroupCode
			-- LEFT JOIN rds.DimComprehensiveSupportReasonApplicabilities csra
			--	ON q.ComprehensiveSupportReasonApplicabilityCode = csra.ComprehensiveSupportReasonApplicabilityCode
	
			--Clear the temp tables
			DELETE FROM @SchoolDateQuery
			DELETE FROM @schoolStatusQuery
			DELETE FROM @title1StatusQuery
			DELETE FROM @organizationStatusSchoolQuery
			--DELETE FROM @ComprehensiveAndTargetedSupport
			DROP table #queryOutput

		FETCH NEXT FROM SCH_Cursor INTO @DimK12SchoolId, @schoolStateIdentifier			
		END
		
		close SCH_Cursor
		DEALLOCATE SCH_Cursor

	END


END TRY
BEGIN CATCH
	declare @msg as nvarchar(max)
	SET @msg = ' Error Number: ' + CAST(ERROR_NUMBER() as varchar) + ' : Line: ' + CAST(ERROR_LINE() as varchar) +    ' : Message: ' + CAST(error_message() as varchar(4000)) 
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
END CATCH

END