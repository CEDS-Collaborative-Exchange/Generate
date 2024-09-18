CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP02_CharterSchoolManagementOrganization_EncapsulatedCode]
	@SchoolYear SMALLINT = NULL
AS


--    /*************************************************************************************************************
--    Date Created:  1/22/2019

--    Purpose:
--      The purpose of this ETL is to manage the Charter School Management organization information in the Generate ODS.  
--		This ETL is run each time the the ODS is populated and retrieves data from the states source system that houses information
--      related to the Charter School Management organization. It will update
--		based on information found in the source data related to Charter School Management organization.

--    Assumptions:
--        This procedure assumes that the source tables are ready for consumption. 

--    Account executed under: LOGIN

--    Approximate run time:  ~ 10 seconds

--    Data Sources:  Ed-Fi ODS

--    Data Targets:  Generate Database

--    Return Values:
--    	 0	= Success
  
--    Example Usage: 
--      EXEC App.[Migrate_Data_ETL_IMPLEMENTATION_STEP01_Organization];
--	  Note that this script is called by Migrate_Data_ETL_IMPLEMENTATION_STEP01_Organization and is meant to hide
--	  all non-changing, backend code from the person managing Generate.  
    
--    Modification Log:
--      #	  Date		  Issue#   Description
--      --  ----------  -------  --------------------------------------------------------------------
--      01  01/22/2019           First Release		  	 
--    *************************************************************************************************************/


BEGIN

	---------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------
	-------------------------------------End State Specific Information Section------------------------------------------
	----All code below this point should not be adjusted. It is created to use the staging tables to load the------------
	----the CEDS Operational Data Store.---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------
	--begin transaction



		set nocount on;
		
		IF @SchoolYear IS NULL BEGIN
			SELECT @SchoolYear = d.Year + 1
			FROM rds.DimDateDataMigrationTypes dd 
			JOIN rds.DimDates d 
				ON dd.DimDateId = d.DimDateId 
			JOIN rds.DimDataMigrationTypes b 
				ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
			WHERE dd.IsSelected = 1 
				AND DataMigrationTypeCode = 'ODS'
		END 

        ---------------------------------------------------
        --- Declare Error Handling Variables           ----
        ---------------------------------------------------
		DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP02_CharterSchoolManagementOrganization_EncapsulatedCode'

		--------------------------------------------------------------
		--- Optimize indexes on Staging tables --- 
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

		SET @RecordStartDate = App.GetFiscalYearStartDate(@SchoolYear);
			
		SET @RecordEndDate = App.GetFiscalYearEndDate(@SchoolYear);

		SET @UpdateDateTime = GETDATE()

		-------------------------------------------------------------------
		----Create Charter School Management Organization Data -----------------------
		-------------------------------------------------------------------

		/* Insert Charter School Management Organization into ODS.Organization
		------------------------------------------------------------------------
		In this section, the Charter School Management Organization is created
		as Organizations in the ODS.
		*/

		BEGIN TRY
			--First check to see if the CharterSchoolManagement Organization already exists so that it is not created a second time.
			UPDATE Staging.CharterSchoolManagementOrganization
			SET CharterSchoolManagementOrganizationId = orgd.OrganizationId
			FROM Staging.CharterSchoolManagementOrganization tod
			JOIN ODS.OrganizationIdentifier orgid ON tod.CharterSchoolManagementOrganization_Identifier_EIN = orgid.Identifier
			JOIN ODS.OrganizationDetail orgd ON orgid.OrganizationId = orgd.OrganizationID
			JOIN ODS.RefOrganizationType rot ON orgd.RefOrganizationTypeId = rot.RefOrganizationTypeId
			WHERE rot.Code = 'CharterSchoolManagementOrganization'
			AND orgid.RefOrganizationIdentifierTypeId = [App].[GetOrganizationIdentifierTypeId]('001156')
			AND orgid.RefOrganizationIdentificationSystemId = [App].[GetOrganizationIdentifierSystemId]('CharterSchoolManagementOrganization', '001156')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.CharterSchoolManagementOrganization', 'CharterSchoolManagementOrganizationId', 'S02EC100' 
		END CATCH

		--Insert new CharterSchoolManagementOrganizations--
		--Get a distinct list of CharterSchoolManagementOrganization IDs that need to be inserted 
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
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewCharterSchoolManagementOrganizations', NULL, 'S02EC110' 
		END CATCH

		--This table captures the Staging.CharterSchoolManagementOrganization_Identifier_EIN 
		--and the new OrganizationId from ODS.Organization 
		--so that we can create the child records.
		DECLARE @NewCharterSchoolManagementOrganization TABLE (
			  CharterSchoolManagementOrganizationId INT
			, CharterSchoolManagementOrganization_Identifier_EIN VARCHAR(100)
		)

		BEGIN TRY
			MERGE ODS.Organization AS TARGET
			USING @DistinctNewCharterSchoolManagementOrganizations AS SOURCE 
				ON 1 = 0 -- always insert 
			WHEN NOT MATCHED THEN 
				INSERT DEFAULT VALUES
			OUTPUT 
				  INSERTED.OrganizationId AS OrganizationId
				, SOURCE.CharterSchoolManagementOrganization_Identifier_EIN
			INTO @NewCharterSchoolManagementOrganization;
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S02EC120' 
		END CATCH

		BEGIN TRY
			UPDATE Staging.CharterSchoolManagementOrganization
			SET   CharterSchoolManagementOrganizationId = norg.CharterSchoolManagementOrganizationId
			FROM Staging.CharterSchoolManagementOrganization o
			JOIN @NewCharterSchoolManagementOrganization norg
				ON o.CharterSchoolManagementOrganization_Identifier_EIN = norg.CharterSchoolManagementOrganization_Identifier_EIN
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.CharterSchoolManagementOrganization', 'CharterSchoolManagementOrganizationId', 'S02EC130' 
		END CATCH

		BEGIN TRY
			UPDATE @DistinctNewCharterSchoolManagementOrganizations
			SET CharterSchoolManagementOrganizationId = o.CharterSchoolManagementOrganizationId
			FROM Staging.CharterSchoolManagementOrganization o
			JOIN @DistinctNewCharterSchoolManagementOrganizations norg
				ON o.CharterSchoolManagementOrganization_Identifier_EIN = norg.CharterSchoolManagementOrganization_Identifier_EIN
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewCharterSchoolManagementOrganizations', 'CharterSchoolManagementOrganizationId', 'S02EC140' 
		END CATCH

		----------------------------------------------------------------------
		--INSERT into ODS.OrganizationIdentifier---------
		----------------------------------------------------------------------

		BEGIN TRY
			INSERT INTO [ODS].[OrganizationIdentifier]
					   ([Identifier]
					   ,[RefOrganizationIdentificationSystemId]
					   ,[OrganizationId]
					   ,[RefOrganizationIdentifierTypeId])
					   --Here we will want to add the RecordStartDateTime and make it the beginning of the fiscal year each time
					   --It will only add it if it doesn't already exist, so it will be done yearly
			SELECT DISTINCT
						o.CharterSchoolManagementOrganization_Identifier_EIN [Identifier]
					   ,[App].[GetOrganizationIdentifierSystemId]('Federal', '000827') AS [RefOrganizationIdentificationSystemId] 
					   ,o.CharterSchoolManagementOrganizationId [OrganizationId]
					   ,[App].[GetOrganizationIdentifierTypeId]('001156') AS [RefOrganizationIdentifierTypeId] 
			FROM Staging.CharterSchoolManagementOrganization o
			JOIN @DistinctNewCharterSchoolManagementOrganizations norg
				ON o.CharterSchoolManagementOrganizationId = norg.CharterSchoolManagementOrganizationId
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationIdentifier', NULL, 'S02EC150' 
		END CATCH

		BEGIN TRY
			--Update names by end dating the 
			--current OrganizationDetail record and creating a new one
			UPDATE ods.OrganizationDetail
			SET RecordEndDateTime = @UpdateDateTime
			FROM Staging.CharterSchoolManagementOrganization o
			JOIN ods.OrganizationDetail od
				ON o.CharterSchoolManagementOrganizationId = od.OrganizationId
				AND o.CharterSchoolManagementOrganization_Name <> od.[Name]
				AND od.RecordEndDateTime IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ods.OrganizationDetail', 'RecordEndDateTime', 'S02EC160' 
		END CATCH

		BEGIN TRY
		-- create new organization detail for new organizations
		declare @charterSchoolMgtTypeId as int
		select @charterSchoolMgtTypeId = RefOrganizationTypeId
		from ods.RefOrganizationType 
		where [Code] = 'CharterSchoolManagementOrganization'

		MERGE ODS.OrganizationDetail AS TARGET
		USING @DistinctNewCharterSchoolManagementOrganizations AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.CharterSchoolManagementOrganizationId
		--When no records are matched, insert
		--the incoming records from source
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
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S02EC180' 
		END CATCH

		-------------------------------------------------------------------
		----Create K12CharterSchoolManagementOrganization -----
		-------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO [ODS].[K12CharterSchoolManagementOrganization]
					   ([OrganizationId]
					   ,[RefCharterSchoolManagementOrganizationTypeId]
					   )
			SELECT 
						o.CharterSchoolManagementOrganizationId [OrganizationId]
					   ,ref.RefCharterSchoolManagementOrganizationTypeId [RefCharterSchoolManagementOrganizationTypeId]
			FROM Staging.CharterSchoolManagementOrganization o
			--JOIN ODS.SourceSystemReferenceData stss
			--	ON o.CharterSchoolManagementOrganization_Type = stss.InputCode
			--	AND stss.TableName = 'RefCharterSchoolManagementOrganizationType'
			--	AND stss.SchoolYear = @SchoolYear
			JOIN ods.RefCharterSchoolManagementOrganizationType ref 
				ON ref.Code=o.CharterSchoolManagementOrganization_Type
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12CharterSchoolManagementOrganization', NULL, 'S02EC190' 
		END CATCH

		BEGIN TRY
			--Create relationship between Charter School Approval Agency and School--
			INSERT INTO [ODS].[OrganizationRelationship]
					   ([Parent_OrganizationId]
					   ,[OrganizationId]
					   ,[RefOrganizationRelationshipId])
			SELECT DISTINCT
						o.CharterSchoolManagementOrganizationId [Parent_OrganizationId]
					   ,schid.OrganizationId [OrganizationId]
					   ,NULL [RefOrganizationRelationshipId]
			FROM Staging.CharterSchoolManagementOrganization o
			JOIN ODS.OrganizationIdentifier schid ON schid.Identifier = o.[CharterSchoolId]
			JOIN ods.RefCharterSchoolManagementOrganizationType ref ON ref.Code=o.CharterSchoolManagementOrganization_Type
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC200'
		END CATCH

		--BEGIN TRY
		--	declare @charterSchoolMgtTypeId as int
		--	select @charterSchoolMgtTypeId = RefOrganizationTypeId
		--	from ods.RefOrganizationType 
		--	where [Code] = 'CharterSchoolManagementOrganization'

		--	UPDATE od
		--	SET RefOrganizationTypeId = @charterSchoolMgtTypeId
		--	FROM [ODS].[OrganizationDetail] od
		--	JOIN ODS.OrganizationIdentifier oid ON oid.[OrganizationId] = od.OrganizationId
		--	left JOIN [Staging].CharterSchoolManagementOrganization o ON od.OrganizationId = o.CharterSchoolManagementOrganizationId
		--END TRY

		--BEGIN CATCH
		--	EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC210'
		--END CATCH

		--BEGIN TRY
		--	declare @charterSchoolManagerIdentifierTypeId as int
		--	select @charterSchoolManagerIdentifierTypeId = RefOrganizationIdentifierTypeId			
		--	from ods.RefOrganizationIdentifierType
		--	where [Code] = '000827'

		--	declare @charterSchoolManagerIdentificationSystemId as int
		--	select @charterSchoolManagerIdentificationSystemId = RefOrganizationIdentificationSystemId
		--	from ods.RefOrganizationIdentificationSystem
		--	where [Code] = 'Federal'
		--	and RefOrganizationIdentifierTypeId = @charterSchoolManagerIdentifierTypeId

		--	UPDATE oid
		--	SET RefOrganizationIdentificationSystemId = @charterSchoolManagerIdentificationSystemId
		--	FROM [ODS].OrganizationIdentifier oid
		--	JOIN [Staging].CharterSchoolManagementOrganization o ON oid.OrganizationId = o.CharterSchoolManagementOrganizationId
		--END TRY

		--BEGIN CATCH
		--	EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationIdentifier', NULL, 'S01EC220'
		--END CATCH


		-------------------------------------------------------------------
		----Create Location, OrganizationLocation and LocationAddress -----
		-------------------------------------------------------------------


		-------Check for existing address first--------

		BEGIN TRY
			---Update the OrganizationId on the temporary table
			UPDATE Staging.OrganizationAddress
			SET OrganizationId = orgid.OrganizationId
			FROM Staging.OrganizationAddress tod
			JOIN ODS.OrganizationIdentifier orgid ON tod.OrganizationIdentifier = orgid.Identifier
			JOIN ODS.RefOrganizationType rot ON tod.OrganizationType = rot.Code
			WHERE rot.RefOrganizationTypeId = App.GetOrganizationTypeId('CharterSchoolManagementOrganization', '001156')
			AND orgid.RefOrganizationIdentifierTypeId = [App].[GetOrganizationIdentifierTypeId]('001156')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'OrganizationId', 'S02EC200' 
		END CATCH

		BEGIN TRY
			---Update the location ID where the address is identical
			UPDATE Staging.OrganizationAddress
			SET LocationId = la.LocationId
			FROM Staging.OrganizationAddress tod
			JOIN ODS.SourceSystemReferenceData oltss
				ON tod.AddressTypeForOrganization = oltss.InputCode
				AND oltss.TableName = 'RefOrganizationLocationType'
				AND oltss.SchoolYear = @SchoolYear
			JOIN ODS.OrganizationLocation orgl ON tod.OrganizationId = orgl.OrganizationId
			JOIN ODS.RefOrganizationLocationType rolt
				ON oltss.OutputCode = rolt.Code
				AND orgl.RefOrganizationLocationTypeId = rolt.RefOrganizationLocationTypeId
			JOIN ODS.LocationAddress la ON orgl.LocationId = la.LocationId
			WHERE tod.AddressStreetNumberAndName = la.StreetNumberAndName
				AND tod.AddressApartmentRoomOrSuite = la.ApartmentRoomOrSuiteNumber
				AND tod.AddressCity = la.City
				AND tod.AddressPostalCode = la.PostalCode
				AND tod.RefStateId = la.RefStateId
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'LocationId', 'S02EC210' 
		END CATCH

		--still need to address where the address exists but doesn't match and we have no way to end date it or start date it--
		--This cannot be done until the ODS is updated with the RecordStartDateTime and RecordEndDateTime on OrganizationLocation--
		--Until that is addressed, we will drop all non matching records with the same AddressTypeForOrganization that we are trying
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
			FROM ODS.OrganizationLocation orgl
			WHERE orgl.LocationId NOT IN (SELECT tod.LocationId FROM Staging.OrganizationAddress tod WHERE tod.LocationId IS NOT NULL)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '#existing_organizationlocation', NULL, 'S02EC220' 
		END CATCH

		BEGIN TRY
			UPDATE #existing_organizationlocation
			SET MarkForDeletion = 1
			WHERE LocationId IN
			(SELECT orgl.LocationId
			FROM ODS.OrganizationLocation orgl
			JOIN Staging.OrganizationAddress tod 
				ON orgl.OrganizationId = tod.OrganizationId
			JOIN ODS.SourceSystemReferenceData oltss
				ON tod.AddressTypeForOrganization = oltss.InputCode
				AND oltss.TableName = 'RefOrganizationLocationType'
				AND oltss.SchoolYear = @SchoolYear
			JOIN ODS.RefOrganizationLocationType rolt
				ON oltss.OutputCode = rolt.Code
			WHERE orgl.RefOrganizationLocationTypeId = rolt.RefOrganizationLocationTypeId)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '#existing_organizationlocation', NULL, 'S02EC230' 
		END CATCH

		--Remove records marked for deletion from ODS.LocationAddress
		BEGIN TRY
			DELETE FROM ODS.LocationAddress WHERE LocationId IN (SELECT LocationId FROM #existing_organizationlocation WHERE MarkForDeletion = 1)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.LocationAddress', NULL, 'S02EC240' 
		END CATCH

		--Remove records marked for deletion from ODS.OrganizationLocation
		BEGIN TRY
			DELETE FROM ODS.OrganizationLocation WHERE LocationId IN (SELECT LocationId FROM #existing_organizationlocation WHERE MarkForDeletion = 1)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationLocation', NULL, 'S02EC250' 
		END CATCH

		--Remove records marked for deletion from ODS.Location
		BEGIN TRY
			DELETE FROM ODS.Location WHERE LocationId IN (SELECT LocationId FROM #existing_organizationlocation WHERE MarkForDeletion = 1)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Location', NULL, 'S02EC260' 
		END CATCH

		BEGIN TRY
			WHILE (SELECT COUNT(*) FROM Staging.OrganizationAddress WHERE LocationId IS NULL) > 0
				BEGIN

					SET @ID = (SELECT TOP 1 ID FROM Staging.OrganizationAddress WHERE LocationId IS NULL)
					
					INSERT INTO [ODS].[Location] DEFAULT VALUES
					SET @LocationId = SCOPE_IDENTITY();

					UPDATE Staging.OrganizationAddress SET LocationId = @LocationId WHERE ID = @ID

				END
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'LocationId', 'S02EC270' 
		END CATCH

		BEGIN TRY
			INSERT INTO [ODS].[OrganizationLocation]
						([OrganizationId]
						,[LocationId]
						,[RefOrganizationLocationTypeId])
			  SELECT DISTINCT
			  oi.OrganizationId [OrganizationId]
								,tod.LocationId [LocationId]
								,rolt.RefOrganizationLocationTypeId [RefOrganizationLocationTypeId]
			  FROM ODS.OrganizationIdentifier oi
			  JOIN [Staging].[OrganizationAddress] tod 
				On oi.Identifier = tod.OrganizationIdentifier
			  JOIN ODS.SourceSystemReferenceData oltss
						ON tod.AddressTypeForOrganization = oltss.InputCode
						AND oltss.TableName = 'RefOrganizationLocationType'
						AND oltss.SchoolYear = @SchoolYear
				left JOIN ODS.RefOrganizationLocationType rolt
					ON oltss.OutputCode = rolt.Code
				LEFT JOIN ods.OrganizationLocation ol
				ON ol.OrganizationId = oi.OrganizationId
				AND ol.LocationId = tod.locationId
				WHERE tod.OrganizationId IS NOT NULL
					AND tod.LocationId IS NOT NULL
					AND ol.OrganizationId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationLocation', NULL, 'S02EC280' 
		END CATCH


		BEGIN TRY
			INSERT INTO [ODS].[LocationAddress]
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
			LEFT JOIN [ODS].[LocationAddress] la
				on tod.locationid = la.locationid 
			WHERE la.LocationId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.LocationAddress', NULL, 'S02EC290' 
		END CATCH

		--Drop all temporary tables--
		DROP TABLE #existing_organizationlocation
		
		set nocount off;

END




