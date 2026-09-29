CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_CharterSchoolManagementOrganization]
	@SchoolYear SMALLINT = NULL
AS


--    /*************************************************************************************************************
--    Date Created:  1/22/2019

--    Purpose:
--      The purpose of this ETL IS to manage the Charter School Management organization information IN the Generate dbo.  
--		This ETL IS run each time the the ODS IS populated AND retrieves data FROM the states source system that houses information
--      related to the Charter School Management organization. It will UPDATE
--		based ON information found IN the source data related to Charter School Management organization.

--    Assumptions:
--        This procedure assumes that the source tables are ready for consumption. 

--    Account executed under: LOGIN

--    Approximate run time:  ~ 10 seconds

--    Data Sources:  Ed-Fi ODS

--    Data Targets:  Generate Database

--    Return VALUES:
--    	 0	= Success
  
--    Example Usage: 
--      EXEC Staging.[Migrate_StagingToIDS_CharterSchoolManagementOrganization] 2020;
    
--    Modification Log:
--      #	  Date		  Issue#   Description
--      --  ----------  -------  --------------------------------------------------------------------
--      01  01/22/2019           First Release		  	 
--    *************************************************************************************************************/


BEGIN

	---------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------
	-------------------------------------End State Specific Information Section------------------------------------------
	----All code below this point should NOT be adjusted. It IS created to use the staging tables to load the------------
	----the CEDS Operational Data Store.---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------
	--BEGIN TRANSACTION



		SET nocount ON;
		
		IF @SchoolYear IS NULL BEGIN
			SELECT @SchoolYear = d.SchoolYear
			FROM rds.DimSchoolYearDataMigrationTypes dd 
			JOIN rds.DimSchoolYears d 
				ON dd.DimSchoolYearId = d.DimSchoolYearId 
			JOIN rds.DimDataMigrationTypes b 
				ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
			WHERE dd.IsSelected = 1 
				AND DataMigrationTypeCode = 'ODS'
		END 

        ---------------------------------------------------
        --- Declare Error Handling Variables           ----
        ---------------------------------------------------
		DECLARE @eStoredProc			VARCHAR(100) = 'Migrate_StagingToIDS_CharterSchoolManagementOrganization'

		--------------------------------------------------------------
		--- Optimize indexes ON Staging tables --- 
		--------------------------------------------------------------
		ALTER INDEX ALL ON Staging.CharterSchoolManagementOrganization
		REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

		/* Define all local variables */
        -------------------------------
        DECLARE @CharterSchoolManagement_OrganizationId INT
			   ,@LocationId INT
               ,@CharterSchoolManagement_Identifier_EIN VARCHAR(100)
               ,@RecordStartDate DATETIME
			   ,@RecordEndDate DATETIME
			   ,@UpdateDateTime DATETIME
			   ,@ID INT

		SET @RecordStartDate = Staging.GetFiscalYearStartDate(@SchoolYear);
			
		SET @RecordEndDate = Staging.GetFiscalYearEndDate(@SchoolYear);

		SET @UpdateDateTime = GETDATE()

		-------------------------------------------------------------------
		----Create Charter School Management Organization Data -----------------------
		-------------------------------------------------------------------

		/* INSERT Charter School Management Organization INTO dbo.Organization
		------------------------------------------------------------------------
		In this section, the Charter School Management Organization IS created
		AS Organizations IN the dbo.
		*/

		BEGIN TRY
			--First check to see IF the CharterSchoolManagement Organization already EXISTS so that it IS NOT created a second time.
			UPDATE Staging.CharterSchoolManagementOrganization
			SET CharterSchoolManagementOrganizationId = orgd.OrganizationId
			FROM Staging.CharterSchoolManagementOrganization tod
			JOIN dbo.OrganizationIdentifier orgid ON tod.CharterSchoolManagementOrganization_Identifier_EIN = orgid.Identifier
			JOIN dbo.OrganizationDetail orgd ON orgid.OrganizationId = orgd.OrganizationID
			JOIN dbo.RefOrganizationType rot ON orgd.RefOrganizationTypeId = rot.RefOrganizationTypeId
			WHERE rot.Code = 'CharterSchoolManagementOrganization'
			AND orgid.RefOrganizationIdentifierTypeId = Staging.[GetOrganizationIdentifierTypeId]('001156')
			AND orgid.RefOrganizationIdentificationSystemId = Staging.[GetOrganizationIdentifierSystemId]('CharterSchoolManagementOrganization', '001156')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.CharterSchoolManagementOrganization', 'CharterSchoolManagementOrganizationId', 'S02EC100' 
		END CATCH

		--INSERT new CharterSchoolManagementOrganizations--
		--Get a DISTINCT list of CharterSchoolManagementOrganization IDs that need to be inserted 
		--so that we can use a MERGE properly.		
		DECLARE @DistinctNewCharterSchoolManagementOrganizations TABLE (
			  CharterSchoolManagementOrganization_Identifier_EIN VARCHAR(100)
			, CharterSchoolManagementOrganization_Name VARCHAR(100)
			, CharterSchoolManagementOrganization_Type VARCHAR(100)
			, CharterSchoolManagementOrganizationId INT NULL
		)

		BEGIN TRY
			INSERT INTO @DistinctNewCharterSchoolManagementOrganizations
			SELECT DISTINCT 
				  CharterSchoolManagementOrganization_Identifier_EIN
				, CharterSchoolManagementOrganization_Name
				, CharterSchoolManagementOrganization_Type
				, NULL CharterSchoolManagementOrganizationId
			FROM Staging.CharterSchoolManagementOrganization
			WHERE CharterSchoolManagementOrganizationId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewCharterSchoolManagementOrganizations', NULL, 'S02EC110' 
		END CATCH

		--This table captures the Staging.CharterSchoolManagementOrganization_Identifier_EIN 
		--AND the new OrganizationId FROM dbo.Organization 
		--so that we can create the child records.
		DECLARE @NewCharterSchoolManagementOrganization TABLE (
			  CharterSchoolManagementOrganizationId INT
			, CharterSchoolManagementOrganization_Identifier_EIN VARCHAR(100)
		)

		BEGIN TRY
			MERGE dbo.Organization AS TARGET
			USING @DistinctNewCharterSchoolManagementOrganizations AS SOURCE 
				ON 1 = 0 -- always INSERT 
			WHEN NOT MATCHED THEN 
				INSERT DEFAULT VALUES
			OUTPUT 
				  INSERTED.OrganizationId AS OrganizationId
				, SOURCE.CharterSchoolManagementOrganization_Identifier_EIN
			INTO @NewCharterSchoolManagementOrganization;
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Organization', NULL, 'S02EC120' 
		END CATCH

		BEGIN TRY
			UPDATE Staging.CharterSchoolManagementOrganization
			SET   CharterSchoolManagementOrganizationId = norg.CharterSchoolManagementOrganizationId
			FROM Staging.CharterSchoolManagementOrganization o
			JOIN @NewCharterSchoolManagementOrganization norg
				ON o.CharterSchoolManagementOrganization_Identifier_EIN = norg.CharterSchoolManagementOrganization_Identifier_EIN
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.CharterSchoolManagementOrganization', 'CharterSchoolManagementOrganizationId', 'S02EC130' 
		END CATCH

		BEGIN TRY
			UPDATE @DistinctNewCharterSchoolManagementOrganizations
			SET CharterSchoolManagementOrganizationId = o.CharterSchoolManagementOrganizationId
			FROM Staging.CharterSchoolManagementOrganization o
			JOIN @DistinctNewCharterSchoolManagementOrganizations norg
				ON o.CharterSchoolManagementOrganization_Identifier_EIN = norg.CharterSchoolManagementOrganization_Identifier_EIN
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewCharterSchoolManagementOrganizations', 'CharterSchoolManagementOrganizationId', 'S02EC140' 
		END CATCH

		----------------------------------------------------------------------
		--INSERT INTO dbo.OrganizationIdentifier---------
		----------------------------------------------------------------------

		BEGIN TRY
			INSERT INTO [dbo].[OrganizationIdentifier]
					   ([Identifier]
					   ,[RefOrganizationIdentificationSystemId]
					   ,[OrganizationId]
					   ,[RefOrganizationIdentifierTypeId])
					   --Here we will want to add the RecordStartDateTime AND make it the beginning of the fiscal year each time
					   --It will only add it IF it doesn't already exist, so it will be done yearly
			SELECT DISTINCT
						o.CharterSchoolManagementOrganization_Identifier_EIN [Identifier]
					   ,Staging.[GetOrganizationIdentifierSystemId]('Federal', '000827') AS [RefOrganizationIdentificationSystemId] 
					   ,o.CharterSchoolManagementOrganizationId [OrganizationId]
					   ,Staging.[GetOrganizationIdentifierTypeId]('001156') AS [RefOrganizationIdentifierTypeId] 
			FROM Staging.CharterSchoolManagementOrganization o
			JOIN @DistinctNewCharterSchoolManagementOrganizations norg
				ON o.CharterSchoolManagementOrganizationId = norg.CharterSchoolManagementOrganizationId
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationIdentifier', NULL, 'S02EC150' 
		END CATCH

		BEGIN TRY
			--UPDATE names by END dating the 
			--current OrganizationDetail record AND creating a new one
			UPDATE dbo.OrganizationDetail
			SET RecordEndDateTime = @UpdateDateTime
			FROM Staging.CharterSchoolManagementOrganization o
			JOIN dbo.OrganizationDetail od
				ON o.CharterSchoolManagementOrganizationId = od.OrganizationId
				AND o.CharterSchoolManagementOrganization_Name <> od.[Name]
				AND od.RecordEndDateTime IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', 'RecordEndDateTime', 'S02EC160' 
		END CATCH

		BEGIN TRY
		-- create new organization detail for new organizations
		DECLARE @charterSchoolMgtTypeId AS INT
		SELECT @charterSchoolMgtTypeId = RefOrganizationTypeId
		FROM dbo.RefOrganizationType 
		WHERE [Code] = 'CharterSchoolManagementOrganization'

		MERGE dbo.OrganizationDetail AS TARGET
		USING @DistinctNewCharterSchoolManagementOrganizations AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.CharterSchoolManagementOrganizationId
		--When no records are matched, INSERT
		--the incoming records FROM source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
					SOURCE.CharterSchoolManagementOrganizationId
				, LEFT(SOURCE.CharterSchoolManagementOrganization_Name, 60)
				, @charterSchoolMgtTypeId
				, @RecordStartDate);
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S02EC180' 
		END CATCH

		-------------------------------------------------------------------
		----Create K12CharterSchoolManagementOrganization -----
		-------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO [dbo].[K12CharterSchoolManagementOrganization]
					   ([OrganizationId]
					   ,[RefCharterSchoolManagementOrganizationTypeId]
					   )
			SELECT 
						o.CharterSchoolManagementOrganizationId [OrganizationId]
					   ,ref.RefCharterSchoolManagementOrganizationTypeId [RefCharterSchoolManagementOrganizationTypeId]
			FROM Staging.CharterSchoolManagementOrganization o
			--JOIN [Staging].[SourceSystemReferenceData] stss
			--	ON o.CharterSchoolManagementOrganization_Type = stss.InputCode
			--	AND stss.TableName = 'RefCharterSchoolManagementOrganizationType'
			--	AND stss.SchoolYear = @SchoolYear
			JOIN dbo.RefCharterSchoolManagementOrganizationType ref 
				ON ref.Code=o.CharterSchoolManagementOrganization_Type
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12CharterSchoolManagementOrganization', NULL, 'S02EC190' 
		END CATCH

		BEGIN TRY
			--Create relationship BETWEEN Charter School Approval Agency AND School--
			INSERT INTO [dbo].[OrganizationRelationship]
					   ([Parent_OrganizationId]
					   ,[OrganizationId]
					   ,[RefOrganizationRelationshipId])
			SELECT DISTINCT
						o.CharterSchoolManagementOrganizationId [Parent_OrganizationId]
					   ,schid.OrganizationId [OrganizationId]
					   ,NULL [RefOrganizationRelationshipId]
			FROM Staging.CharterSchoolManagementOrganization o
			JOIN dbo.OrganizationIdentifier schid ON schid.Identifier = o.[CharterSchoolId]
			JOIN dbo.RefCharterSchoolManagementOrganizationType ref ON ref.Code=o.CharterSchoolManagementOrganization_Type
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationRelationship', NULL, 'S01EC200'
		END CATCH

		--BEGIN TRY
		--	DECLARE @charterSchoolMgtTypeId AS INT
		--	SELECT @charterSchoolMgtTypeId = RefOrganizationTypeId
		--	FROM dbo.RefOrganizationType 
		--	WHERE [Code] = 'CharterSchoolManagementOrganization'

		--	UPDATE od
		--	SET RefOrganizationTypeId = @charterSchoolMgtTypeId
		--	FROM [dbo].[OrganizationDetail] od
		--	JOIN dbo.OrganizationIdentifier oid ON oid.[OrganizationId] = od.OrganizationId
		--	LEFT JOIN [Staging].CharterSchoolManagementOrganization o ON od.OrganizationId = o.CharterSchoolManagementOrganizationId
		--END TRY

		--BEGIN CATCH
		--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S01EC210'
		--END CATCH

		--BEGIN TRY
		--	DECLARE @charterSchoolManagerIdentifierTypeId AS INT
		--	SELECT @charterSchoolManagerIdentifierTypeId = RefOrganizationIdentifierTypeId			
		--	FROM dbo.RefOrganizationIdentifierType
		--	WHERE [Code] = '000827'

		--	DECLARE @charterSchoolManagerIdentificationSystemId AS INT
		--	SELECT @charterSchoolManagerIdentificationSystemId = RefOrganizationIdentificationSystemId
		--	FROM dbo.RefOrganizationIdentificationSystem
		--	WHERE [Code] = 'Federal'
		--	AND RefOrganizationIdentifierTypeId = @charterSchoolManagerIdentifierTypeId

		--	UPDATE oid
		--	SET RefOrganizationIdentificationSystemId = @charterSchoolManagerIdentificationSystemId
		--	FROM [dbo].OrganizationIdentifier oid
		--	JOIN [Staging].CharterSchoolManagementOrganization o ON oid.OrganizationId = o.CharterSchoolManagementOrganizationId
		--END TRY

		--BEGIN CATCH
		--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationIdentifier', NULL, 'S01EC220'
		--END CATCH


		-------------------------------------------------------------------
		----Create Location, OrganizationLocation AND LocationAddress -----
		-------------------------------------------------------------------


		-------Check for existing address first--------

		BEGIN TRY
			---UPDATE the OrganizationId ON the temporary table
			UPDATE Staging.OrganizationAddress
			SET OrganizationId = orgid.OrganizationId
			FROM Staging.OrganizationAddress tod
			JOIN dbo.OrganizationIdentifier orgid ON tod.OrganizationIdentifier = orgid.Identifier
			JOIN dbo.RefOrganizationType rot ON tod.OrganizationType = rot.Code
			WHERE rot.RefOrganizationTypeId = Staging.GetOrganizationTypeId('CharterSchoolManagementOrganization', '001156')
			AND orgid.RefOrganizationIdentifierTypeId = Staging.[GetOrganizationIdentifierTypeId]('001156')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'OrganizationId', 'S02EC200' 
		END CATCH

		BEGIN TRY
			---UPDATE the location ID WHERE the address IS identical
			UPDATE Staging.OrganizationAddress
			SET LocationId = la.LocationId
			FROM Staging.OrganizationAddress tod
			JOIN [Staging].[SourceSystemReferenceData] oltss
				ON tod.AddressTypeForOrganization = oltss.InputCode
				AND oltss.TableName = 'RefOrganizationLocationType'
				AND oltss.SchoolYear = @SchoolYear
			JOIN dbo.OrganizationLocation orgl ON tod.OrganizationId = orgl.OrganizationId
			JOIN dbo.RefOrganizationLocationType rolt
				ON oltss.OutputCode = rolt.Code
				AND orgl.RefOrganizationLocationTypeId = rolt.RefOrganizationLocationTypeId
			JOIN dbo.LocationAddress la ON orgl.LocationId = la.LocationId
			WHERE tod.AddressStreetNumberAndName = la.StreetNumberAndName
				AND tod.AddressApartmentRoomOrSuite = la.ApartmentRoomOrSuiteNumber
				AND tod.AddressCity = la.City
				AND tod.AddressPostalCode = la.PostalCode
				AND tod.RefStateId = la.RefStateId
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'LocationId', 'S02EC210' 
		END CATCH

		--still need to address WHERE the address EXISTS but doesn't match AND we have no way to END date it OR start date it--
		--This cannot be done until the ODS IS updated with the RecordStartDateTime AND RecordEndDateTime ON OrganizationLocation--
		--Until that IS addressed, we will DROP all non matching records with the same AddressTypeForOrganization that we are trying
		--to add new below--

		BEGIN TRY
			CREATE TABLE #existing_organizationlocation (
				 OrganizationId VARCHAR(100)
				,LocationId VARCHAR(100)
				,RefOrganizationLocationTypeId VARCHAR(100)
				,MarkForDeletion BIT)
			INSERT INTO #existing_organizationlocation
				(OrganizationId
				,LocationId
				,RefOrganizationLocationTypeId
				,MarkForDeletion)
			SELECT DISTINCT
				 orgl.OrganizationId OrganizationId
				,orgl.LocationId LocationId
				,orgl.RefOrganizationLocationTypeId RefOrganizationLocationTypeId
				,0 MarkForDeletion
			FROM dbo.OrganizationLocation orgl
			WHERE orgl.LocationId NOT IN (SELECT tod.LocationId FROM Staging.OrganizationAddress tod WHERE tod.LocationId IS NOT NULL)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '#existing_organizationlocation', NULL, 'S02EC220' 
		END CATCH

		BEGIN TRY
			UPDATE #existing_organizationlocation
			SET MarkForDeletion = 1
			WHERE LocationId IN
			(SELECT orgl.LocationId
			FROM dbo.OrganizationLocation orgl
			JOIN Staging.OrganizationAddress tod 
				ON orgl.OrganizationId = tod.OrganizationId
			JOIN [Staging].[SourceSystemReferenceData] oltss
				ON tod.AddressTypeForOrganization = oltss.InputCode
				AND oltss.TableName = 'RefOrganizationLocationType'
				AND oltss.SchoolYear = @SchoolYear
			JOIN dbo.RefOrganizationLocationType rolt
				ON oltss.OutputCode = rolt.Code
			WHERE orgl.RefOrganizationLocationTypeId = rolt.RefOrganizationLocationTypeId)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '#existing_organizationlocation', NULL, 'S02EC230' 
		END CATCH

		--Remove records marked for deletion FROM dbo.LocationAddress
		BEGIN TRY
			DELETE FROM dbo.LocationAddress WHERE LocationId IN (SELECT LocationId FROM #existing_organizationlocation WHERE MarkForDeletion = 1)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.LocationAddress', NULL, 'S02EC240' 
		END CATCH

		--Remove records marked for deletion FROM dbo.OrganizationLocation
		BEGIN TRY
			DELETE FROM dbo.OrganizationLocation WHERE LocationId IN (SELECT LocationId FROM #existing_organizationlocation WHERE MarkForDeletion = 1)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationLocation', NULL, 'S02EC250' 
		END CATCH

		--Remove records marked for deletion FROM dbo.Location
		BEGIN TRY
			DELETE FROM dbo.Location WHERE LocationId IN (SELECT LocationId FROM #existing_organizationlocation WHERE MarkForDeletion = 1)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Location', NULL, 'S02EC260' 
		END CATCH

		BEGIN TRY
			WHILE (SELECT COUNT(*) FROM Staging.OrganizationAddress WHERE LocationId IS NULL) > 0
				BEGIN

					SET @ID = (SELECT TOP 1 ID FROM Staging.OrganizationAddress WHERE LocationId IS NULL)
					
					INSERT INTO [dbo].[Location] DEFAULT VALUES
					SET @LocationId = SCOPE_IDENTITY();

					UPDATE Staging.OrganizationAddress SET LocationId = @LocationId WHERE ID = @ID

				END
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'LocationId', 'S02EC270' 
		END CATCH

		BEGIN TRY
			INSERT INTO [dbo].[OrganizationLocation]
						([OrganizationId]
						,[LocationId]
						,[RefOrganizationLocationTypeId])
			  SELECT DISTINCT
			  oi.OrganizationId [OrganizationId]
								,tod.LocationId [LocationId]
								,rolt.RefOrganizationLocationTypeId [RefOrganizationLocationTypeId]
			  FROM dbo.OrganizationIdentifier oi
			  JOIN [Staging].[OrganizationAddress] tod 
				On oi.Identifier = tod.OrganizationIdentifier
			  JOIN [Staging].[SourceSystemReferenceData] oltss
						ON tod.AddressTypeForOrganization = oltss.InputCode
						AND oltss.TableName = 'RefOrganizationLocationType'
						AND oltss.SchoolYear = @SchoolYear
				LEFT JOIN dbo.RefOrganizationLocationType rolt
					ON oltss.OutputCode = rolt.Code
				LEFT JOIN dbo.OrganizationLocation ol
				ON ol.OrganizationId = oi.OrganizationId
				AND ol.LocationId = tod.locationId
				WHERE tod.OrganizationId IS NOT NULL
					AND tod.LocationId IS NOT NULL
					AND ol.OrganizationId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationLocation', NULL, 'S02EC280' 
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
						,[RefERSRuralUrbanContinuumCodeId])
			SELECT DISTINCT
						tod.LocationId [LocationId]
						,tod.AddressStreetNumberAndName [StreetNumberAndName]
						,tod.AddressApartmentRoomOrSuite [ApartmentRoomOrSuiteNumber]
						,NULL [BuildingSiteNumber]
						,tod.AddressCity [City]
						,tod.RefStateId [RefStateId]
						,tod.AddressPostalCode [PostalCode]
						,NULL [CountyName]
						,NULL [RefCountyId]
						,NULL [RefCountryId]
						,NULL [Latitude]
						,NULL [Longitude]
						,NULL [RefERSRuralUrbanContinuumCodeId]
			FROM Staging.OrganizationAddress tod
			LEFT JOIN [dbo].[LocationAddress] la
				ON tod.locationid = la.locationid 
			WHERE la.LocationId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.LocationAddress', NULL, 'S02EC290' 
		END CATCH

		--Drop all temporary tables--
		DROP TABLE #existing_organizationlocation
		
		SET nocount off;

END
