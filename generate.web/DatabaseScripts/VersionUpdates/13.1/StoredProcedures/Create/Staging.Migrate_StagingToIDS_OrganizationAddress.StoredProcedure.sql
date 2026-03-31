CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_OrganizationAddress]
	@SchoolYear SMALLINT = NULL
AS 

--    /*************************************************************************************************************
--    Date Created:  5/21/2018
--		[Staging].[Migrate_StagingToIDS_OrganizationAddress]

--    Modification Log:
--      #	  Date		  Issue#   Description
--      --  ----------  -------  --------------------------------------------------------------------
--      01  05/21/2018           First Release		  	 
--    *************************************************************************************************************/

BEGIN
	SET NOCOUNT ON;
    ---------------------------------------------------
    --- Declare Error Handling Variables           ----
    ---------------------------------------------------
	DECLARE @eStoredProc			varchar(100) = 'Migrate_StagingToIDS_OrganizationAddress'


	-------------------------------------------------------------------
	----Create Location, OrganizationLocation and LocationAddress -----
	-------------------------------------------------------------------
	-------Check for existing address first--------

	BEGIN TRY
		UPDATE Staging.OrganizationAddress
		SET OrganizationId = orgid.OrganizationId
		FROM Staging.OrganizationAddress tod
		JOIN dbo.OrganizationIdentifier orgid 
			ON tod.OrganizationIdentifier = orgid.Identifier
			AND (tod.DataCollectionId IS NULL
				OR ISNULL(tod.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, ''))
			AND tod.RecordStartDateTime <= ISNULL(orgid.RecordEndDateTime, GETDATE())
			AND ISNULL(tod.RecordEndDateTime, GETDATE()) >= orgid.RecordStartDateTime
		JOIN [Staging].[SourceSystemReferenceData] osss
			ON tod.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = tod.SchoolYear
		JOIN dbo.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
			AND ot.RefOrganizationTypeId = ot.RefOrganizationTypeId
		JOIN dbo.OrganizationDetail od
			ON orgid.OrganizationId = od.OrganizationId
			and od.RefOrganizationTypeId = ot.RefOrganizationTypeId
		JOIN dbo.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'OrganizationId', 'S01EC1920'
	END CATCH

	BEGIN TRY
		UPDATE Staging.OrganizationAddress
		SET RefStateId = se.RefStateId
		FROM Staging.OrganizationAddress tod
		LEFT JOIN dbo.RefState se
			ON se.Code = tod.StateAbbreviation
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'OrganizationId', 'S01EC1750'
	END CATCH
	

	BEGIN TRY
		---Update the location ID where the address is identical
		UPDATE Staging.OrganizationAddress
		SET LocationId = la.LocationId
		FROM Staging.OrganizationAddress tod
		JOIN [Staging].[SourceSystemReferenceData] oltss
			ON tod.AddressTypeForOrganization = oltss.InputCode
			AND oltss.TableName = 'RefOrganizationLocationType'
			AND oltss.SchoolYear = tod.SchoolYear
		JOIN dbo.OrganizationLocation orgl 
			ON tod.OrganizationId = orgl.OrganizationId
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgl.DataCollectionId, '')
		JOIN dbo.RefOrganizationLocationType rolt
			ON oltss.OutputCode = rolt.Code
			AND orgl.RefOrganizationLocationTypeId = rolt.RefOrganizationLocationTypeId
		JOIN dbo.LocationAddress la 
			ON orgl.LocationId = la.LocationId
			AND ISNULL(orgl.DataCollectionId, '') = ISNULL(la.DataCollectionId, '')
		JOIN dbo.RefState s
			ON tod.StateAbbreviation = s.Code
		WHERE tod.AddressStreetNumberAndName = la.StreetNumberAndName
			AND tod.AddressApartmentRoomOrSuite = la.ApartmentRoomOrSuiteNumber
			AND tod.AddressCity = la.City
			AND tod.AddressPostalCode = la.PostalCode
			AND tod.RefStateId = la.RefStateId
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'LocationId', 'S01EC1940'
	END CATCH

	--still need to address where the address exists but doesn't match and we have no way to end date it or start date it--
	--This cannot be done until the dbo is updated with the RecordStartDateTime and RecordEndDateTime on OrganizationLocation--
	--Until that is addressed, we will drop all non matching records with the same AddressTypeForOrganization that we are trying
	--to add new below--
	BEGIN TRY 

		If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#existing_organizationlocation'))
			Begin
				Drop Table #existing_organizationlocation
			End
			
		CREATE TABLE #existing_organizationlocation (
			 OrganizationId VARCHAR(100)
			,LocationId VARCHAR(100)
			,RefOrganizationLocationTypeId VARCHAR(100)
			,MarkForDeletion BIT
			,DataCollectionID INT)
		INSERT INTO #existing_organizationlocation
			(OrganizationId
			,LocationId
			,RefOrganizationLocationTypeId
			,MarkForDeletion
			,DataCollectionID)
		SELECT DISTINCT
			 orgl.OrganizationId OrganizationId
			,orgl.LocationId LocationId
			,orgl.RefOrganizationLocationTypeId RefOrganizationLocationTypeId
			,0 MarkForDeletion
			,orgl.DataCollectionID
		FROM dbo.OrganizationLocation orgl
		WHERE orgl.LocationId NOT IN (SELECT tod.LocationId FROM Staging.OrganizationAddress tod WHERE tod.LocationId IS NOT NULL)
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '#existing_organizationlocation', NULL, 'S01EC1950'
	END CATCH

	BEGIN TRY
		UPDATE #existing_organizationlocation
		SET MarkForDeletion = 1
		WHERE LocationId IN
		(SELECT orgl.LocationId
		FROM dbo.OrganizationLocation orgl
		JOIN Staging.OrganizationAddress tod
			ON orgl.OrganizationId = tod.OrganizationId
			AND ISNULL(orgl.DataCollectionId, '') = ISNULL(tod.DataCollectionId, '')
		JOIN [Staging].[SourceSystemReferenceData] oltss
			ON tod.AddressTypeForOrganization = oltss.InputCode
			AND oltss.TableName = 'RefOrganizationLocationType'
			AND oltss.SchoolYear = tod.SchoolYear
		JOIN dbo.RefOrganizationLocationType rolt
			ON oltss.OutputCode = rolt.Code
		WHERE orgl.RefOrganizationLocationTypeId = rolt.RefOrganizationLocationTypeId)
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '#existing_organizationlocation', 'MarkForDeletion', 'S01EC1960'
	END CATCH

	BEGIN TRY
		DELETE FROM dbo.LocationAddress WHERE LocationId IN (SELECT LocationId FROM #existing_organizationlocation WHERE MarkForDeletion = 1)
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.LocationAddress', NULL, 'S01EC1970'
	END CATCH

	BEGIN TRY
		DELETE FROM dbo.OrganizationLocation WHERE LocationId IN (SELECT LocationId FROM #existing_organizationlocation WHERE MarkForDeletion = 1)
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationLocation', NULL, 'S01EC1980'
	END CATCH

	BEGIN TRY
		DELETE FROM dbo.Location WHERE LocationId IN (SELECT LocationId FROM #existing_organizationlocation WHERE MarkForDeletion = 1)
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Location', NULL, 'S01EC1990'
	END CATCH

	
	--Insert new Address--
	--Get a distinct list of Location IDs that need to be inserted 
	--so that we can use a MERGE properly.		
	DECLARE @DistinctNewLocations TABLE (
		  OrganizationId INT NULL
		, OrganizationLocationType VARCHAR(100)
		, DataCollectionId INT NULL
	)

	BEGIN TRY 
		INSERT INTO @DistinctNewLocations
		SELECT DISTINCT 
			  a.OrganizationId
			, a.AddressTypeForOrganization
			, a.DataCollectionId		
		FROM Staging.OrganizationAddress a
		WHERE LocationId IS NULL AND OrganizationId IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewLocations', NULL, 'S01EC2000'
	END CATCH
	
	DECLARE @NewLocation TABLE (
		  OrganizationId INT
		, LocationId INT
		, OrganizationLocationType VARCHAR(100)
		, DataCollectionId INT NULL
	)
	
	BEGIN TRY 
		MERGE dbo.Location AS TARGET
		USING @DistinctNewLocations AS SOURCE 
			ON 1 = 0 -- always insert 
		WHEN NOT MATCHED THEN 
			INSERT (DataCollectionId) VALUES (Source.DataCollectionId) --Changed|TODO: Add DataCollectionId to this INSERT statement
		OUTPUT 
			  SOURCE.OrganizationId
			, INSERTED.LocationId
			, SOURCE.OrganizationLocationType
			, SOURCE.DataCollectionId
		INTO @NewLocation;
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '@NewLocation', NULL, 'S01EC2005'
	END CATCH
		
	BEGIN TRY	
		UPDATE Staging.OrganizationAddress 
		SET LocationId = nl.LocationId
		FROM Staging.OrganizationAddress orga 
		INNER JOIN @NewLocation nl 
			ON orga.OrganizationId = nl.OrganizationId 
			and ISNULL(orga.DataCollectionId, '') = ISNULL(nl.DataCollectionId, '') 
			and orga.AddressTypeForOrganization = nl.OrganizationLocationType
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '@NewLocation', NULL, 'S01EC2005'
	END CATCH	
	
	-- Add State Address
	BEGIN TRY
		INSERT INTO [dbo].[OrganizationLocation]
					([OrganizationId]
					,[LocationId]
					,[RefOrganizationLocationTypeId]
					,[DataCollectionId])
		SELECT DISTINCT
			 tod.OrganizationId
			,tod.LocationId [LocationId]
			,rolt.RefOrganizationLocationTypeId [RefOrganizationLocationTypeId]
			,tod.DataCollectionId
		FROM [Staging].[StateDetail] sd
		JOIN [Staging].[OrganizationAddress] tod
		ON tod.OrganizationIdentifier = sd.SeaStateIdentifier
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(sd.DataCollectionId, '')
		JOIN [Staging].[SourceSystemReferenceData] oltss
		ON tod.AddressTypeForOrganization = oltss.InputCode
			AND oltss.TableName = 'RefOrganizationLocationType'
			AND oltss.SchoolYear = Right(sd.SchoolYear,4)
		LEFT JOIN dbo.RefOrganizationLocationType rolt
			ON oltss.OutputCode = rolt.Code
		LEFT JOIN dbo.OrganizationLocation ol
			ON ol.OrganizationId = tod.OrganizationId
				AND ol.LocationId = tod.locationId
				and ISNULL(ol.DataCollectionId, '') = ISNULL(tod.DataCollectionId, '')
		WHERE tod.OrganizationId IS NOT NULL
			AND tod.LocationId IS NOT NULL
			AND ol.OrganizationId IS NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationLocation', NULL, 'S01EC2010'
	END CATCH

	BEGIN TRY
		INSERT INTO [dbo].[OrganizationLocation]
			([OrganizationId]
			,[LocationId]
			,[RefOrganizationLocationTypeId]
			,[DataCollectionId])
		SELECT DISTINCT
			 tod.OrganizationId [OrganizationId]
			,tod.LocationId [LocationId]
			,rolt.RefOrganizationLocationTypeId [RefOrganizationLocationTypeId]
			,tod.DataCollectionId
		FROM [Staging].[OrganizationAddress] tod
		JOIN [Staging].[SourceSystemReferenceData] oltss
			ON tod.AddressTypeForOrganization = oltss.InputCode
			AND oltss.TableName = 'RefOrganizationLocationType'
			AND oltss.SchoolYear = tod.SchoolYear
		LEFT JOIN dbo.RefOrganizationLocationType rolt
			ON oltss.OutputCode = rolt.Code
		LEFT JOIN dbo.OrganizationLocation ol
			ON ol.OrganizationId = tod.OrganizationId
			AND ol.LocationId = tod.locationId
			AND ISNULL(ol.DataCollectionId, '') = ISNULL(tod.DataCollectionId, '')
		WHERE tod.OrganizationId IS NOT NULL
			AND tod.LocationId IS NOT NULL
			AND ol.OrganizationId IS NULL			
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationLocation', NULL, 'S01EC2015'
	END CATCH
	
	BEGIN TRY
		INSERT INTO [dbo].[LocationAddress]
					([LocationId]
					,[StreetNumberAndName]
					,[ApartmentRoomOrSuiteNumber]
					,[BuildingSiteNumber]
					,[City]
					,[RefStateId]
					,[PostalCode]
					,[CountyName]
					,[RefCountyId]
					,[RefCountryId]
					,[Latitude]
					,[Longitude]
					,[RefERSRuralUrbanContinuumCodeId]
					,[RecordStartDateTime]
					,[RecordEndDateTime]
					,[DataCollectionId])
		SELECT DISTINCT
					tod.LocationId [LocationId]
					,tod.AddressStreetNumberAndName [StreetNumberAndName]
					,tod.AddressApartmentRoomOrSuite [ApartmentRoomOrSuiteNumber]
					,NULL [BuildingSiteNumber]
					,tod.AddressCity [City]
					,tod.RefStateId [RefStateId]
					,tod.AddressPostalCode [PostalCode]
					,cy.[Description] [CountyName]
					,cy.RefCountyId [RefCountyId]
					,NULL [RefCountryId]
					,tod.Latitude [Latitude]
					,tod.Longitude [Longitude]
					,NULL [RefERSRuralUrbanContinuumCodeId]
					,tod.RecordStartDateTime
					,tod.RecordEndDateTime
					,tod.DataCollectionId
		FROM Staging.OrganizationAddress tod
		LEFT JOIN [dbo].[LocationAddress] la
			ON tod.locationid = la.locationid 
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(la.DataCollectionId, '')
		LEFT JOIN dbo.RefState s
			ON tod.RefStateId = s.RefStateId
		LEFT JOIN dbo.RefStateAnsiCode sac
			ON s.Description = sac.Description
		LEFT JOIN dbo.RefCounty cy
			ON sac.Code + right(tod.AddressCountyAnsiCode,3) = cy.Code
		WHERE tod.LocationId IS NOT NULL --AND la.LocationId is null
	END TRY
	
	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.LocationAddress', NULL, 'S01EC2020'
	END CATCH


END