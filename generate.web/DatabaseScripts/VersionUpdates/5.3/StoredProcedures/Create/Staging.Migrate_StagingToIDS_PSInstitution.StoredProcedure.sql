 Create PROCEDURE [Staging].[Migrate_StagingToIDS_PsInstitution]
	--@SchoolYear SMALLINT = NULL
AS

--    /*************************************************************************************************************
--    Date Created:  5/21/2018
--		Staging.Migrate_StagingToIDS_PsInstitution 2018
--    Purpose:
--        The purpose of this ETL is to manage the postsecondary institutions in the CEDS IDS.  This ETL is 
--		  run each time IDS is populated and retrieves data from the states source system that houses information
--        related to colleges and universities. It will update based on information found in the source data related 
--		  to postsecondary institutions. 

--    Assumptions:
--        This procedure assumes that the source tables are ready for consumption. 

--    Account executed under: LOGIN

--    Approximate run time:  ~ 10 seconds

--    Data Sources:  CEDS Staging Tables

--    Data Targets:  CEDS IDS

--    Return VALUES:
--    	 0	= Success
  
--    Example Usage: 
--      EXEC Staging.Migrate_StagingToIDS_PsInstitution 2018;
    
--    Modification Log:
--      #	  Date		  Issue#   Description
--      --  ----------  -------  --------------------------------------------------------------------
--      01  01/23/2020           Authored
--    *************************************************************************************************************/


BEGIN

--	SET NOCOUNT ON;
	
--		IF @SchoolYear IS NULL BEGIN
--			SELECT @SchoolYear = d.Year + 1
--			FROM rds.DimDateDataMigrationTypes dd 
--			JOIN rds.DimDates d 
--				ON dd.DimDateId = d.DimDateId 
--			JOIN rds.DimDataMigrationTypes b 
--				ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
--			WHERE dd.IsSelected = 1 
--				AND DataMigrationTypeCode = 'dbo'
--		END 

        ---------------------------------------------------
        --- Declare Error Handling Variables           ----
        ---------------------------------------------------
		DECLARE @eStoredProc			VARCHAR(100) = 'Migrate_StagingToIDS_PSInstitution'
		
		---------------------------------------------------
        --- Update DataCollectionId in Staging.PsInstitution  ----Added
        ---------------------------------------------------
		BEGIN TRY 
		
		UPDATE ps
		SET DataCollectionId = dc.DataCollectionId
		FROM Staging.PsInstitution ps
		JOIN dbo.DataCollection dc
			ON ps.DataCollectionName = dc.DataCollectionName
		
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PsInstitution', 'DataCollectionId', 'S03EC090'
		END CATCH
        ------------------------------------------
        --- Declare Needed Variables          ----
        ------------------------------------------
		DECLARE @PsInstitutionOrganizationTypeId INT, @IpedsCodeIdentifierTypeId INT,@RefOrganizationIdentificationSystem INT
		SELECT @PsInstitutionOrganizationTypeId = RefOrganizationTypeId FROM dbo.RefOrganizationType WHERE Code = 'PostsecondaryInstitution'
		SELECT @IpedsCodeIdentifierTypeId = RefOrganizationIdentifierTypeId FROM dbo.RefOrganizationIdentifierType WHERE Code = '000166'
		Select @RefOrganizationIdentificationSystem = RefOrganizationIdentificationSystemId FROM dbo.RefOrganizationIdentificationSystem where Code = 'PostsecondaryInstitution'

		-----------------------------------------------
		--- Get the OrganizationOperationalStatusId ---
		-----------------------------------------------
		--UPDATE Staging.PsInstitution
		--SET OperationalStatusId = os.RefOperationalStatusId
		--FROM Staging.PsInstitution psi
		--JOIN Staging.SourceSystemReferenceData ssrd
		--	ON psi.OrganizationOperationalStatus = ssrd.InputCode
		--	AND ssrd.SchoolYear = psi.SchoolYear
		--	AND ssrd.TableName = 'RefOperationalStatus'
		--	AND ssrd.TableFilter = '001418'
		--JOIN dbo.RefOperationalStatus os
		--	ON ssrd.OutputCode = os.Code

		-------------------------------------------------
		--- Get the MostPrevalentLevelOfInstitutionId ---
		-------------------------------------------------
		UPDATE Staging.PsInstitution
		SET MostPrevalentLevelOfInstitutionId = mp.RefMostPrevalentLevelOfInstitutionId
		FROM Staging.PsInstitution psi
		JOIN Staging.SourceSystemReferenceData ssrd
			ON psi.MostPrevalentLevelOfInstitutionCode = ssrd.InputCode
			AND ssrd.SchoolYear = psi.SchoolYear
			AND ssrd.TableName = 'RefMostPrevalentLevelOfInstitution'
		JOIN dbo.RefMostPrevalentLevelOfInstitution mp
			ON ssrd.OutputCode = mp.Code

		-----------------------------------------------
		--- Get the PredominantCalendarSystemId ---
		-----------------------------------------------
		--UPDATE Staging.PsInstitution
		--SET PredominantCalendarSystemId = pcs.RefPredominantCalendarSystemId
		--FROM Staging.PsInstitution psi
		--JOIN Staging.SourceSystemReferenceData ssrd
		--	ON psi.PredominantCalendarSystem = ssrd.InputCode
		--	AND ssrd.SchoolYear = psi.SchoolYear
		--	AND ssrd.TableName = 'RefPredominantCalendarSystem'
		--JOIN dbo.RefPredominantCalendarSystem pcs
		--	ON ssrd.OutputCode = pcs.Code

		-----------------------------------------------------------------------
		--- Check for existing PS Institutions and grab their OrganzationID ---
		-----------------------------------------------------------------------
		UPDATE Staging.PsInstitution
		SET OrganizationId = oi.OrganizationId
		FROM Staging.PsInstitution psi
		JOIN dbo.OrganizationIdentifier oi
			ON psi.InstitutionIpedsUnitId = oi.Identifier
		JOIN dbo.RefOrganizationIdentifierType oit
			ON oi.RefOrganizationIdentifierTypeId = oit.RefOrganizationIdentifierTypeId
			AND oit.Code = '000166' -- Institution IPEDS UnitID

		-------------------------------------------------------------------
		--- Create new dbo.Organization records for new PS Institutions ---
		-------------------------------------------------------------------
		-- This table captures the Staging.PsInstitution.IpedsCode 
		-- and the new OrganizationId FROM dbo.Organization 
		-- so that we can create the child records.
		DECLARE @NewPsInstitutions TABLE (
			  OrganizationId INT
			, IpedsCode VARCHAR(50)
			,DataCollectionId int
		)

		BEGIN TRY
			SELECT * 
			INTO #distinct_Id
			FROM (Select distinct InstitutionIpedsUnitId,DataCollectionId,OrganizationId From Staging.PsInstitution) AS psinst --Added
 
		MERGE dbo.Organization AS TARGET
		USING #distinct_Id AS SOURCE --Changed source table from @NewPsInstitutions
		ON SOURCE.OrganizationID = TARGET.OrganizationID
		WHEN NOT MATCHED THEN 
				INSERT VALUES ( SOURCE.DataCollectionId )
		OUTPUT 
				INSERTED.OrganizationId AS OrganizationId
				,SOURCE.InstitutionIpedsUnitId
				,SOURCE.DataCollectionId
		INTO @NewPsInstitutions;

		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Organization', NULL, 'S01EC0190'
		END CATCH

		BEGIN TRY
			UPDATE Staging.PsInstitution
			SET OrganizationId = npi.OrganizationId
			FROM Staging.PsInstitution psi
			JOIN @NewPsInstitutions npi
				ON psi.InstitutionIpedsUnitId = npi.IpedsCode
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Organization', NULL, 'S01EC0190'
		END CATCH

		-----------------------------------------------------------------------------------------
		--- Create new dbo.OrganizationIdentifier records for new and updated PS Institutions ---
		-----------------------------------------------------------------------------------------
		BEGIN TRY
			MERGE dbo.OrganizationIdentifier AS TARGET
			USING Staging.PsInstitution AS SOURCE
				ON TARGET.OrganizationId = SOURCE.OrganizationId
				AND ISNULL(TARGET.RecordStartDateTime, '') = ISNULL(SOURCE.RecordStartDateTime, '')
				AND ISNULL(TARGET.DataCollectionId, -1) = ISNULL(SOURCE.DataCollectionId, -1)
			WHEN MATCHED THEN -- Update existing OrganizationIdentifier records that are now inaccurate
				UPDATE SET 
					  TARGET.Identifier = SOURCE.InstitutionIpedsUnitId
					, TARGET.RecordEndDateTime = SOURCE.RecordEndDateTime
					, TARGET.DataCollectionId = SOURCE.DataCollectionId
			WHEN NOT MATCHED THEN -- Insert new OrganizationIdentifier records
				INSERT VALUES (
					  SOURCE.InstitutionIpedsUnitId
					, NULL -- RefOrganizationIdentificationSystem
					, SOURCE.OrganizationId
					, @IpedsCodeIdentifierTypeId
					, SOURCE.RecordStartDateTime
					, SOURCE.RecordEndDateTime
					, SOURCE.DataCollectionId
				);
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationIdentifier', NULL, 'S01EC0190'
		END CATCH

		--BEGIN TRY
		--	UPDATE od
		--	SET od.RecordEndDateTime = psi.RecordStartDateTime - 1
		--	FROM dbo.OrganizationIdentifier od
		--	JOIN   (SELECT OrganizationId, MAX(OrganizationIdentifierId) AS OrganizationIdentifierId, MAX(RecordStartDateTime) AS RecordStartDateTime
		--			FROM dbo.OrganizationIdentifier
		--			WHERE RecordEndDateTime IS NULL
		--			GROUP BY OrganizationId
		--			) psi
		--		ON od.OrganizationId = psi.OrganizationId
		--		AND od.OrganizationIdentifierId <> psi.OrganizationIdentifierId
		--		AND od.RecordEndDateTime IS NULL
		--END TRY

		--BEGIN CATCH
		--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S01EC0190'
		--END CATCH

		-------------------------------------------------------------------------------------
		--- Create new dbo.OrganizationDetial records for new and updated PS Institutions ---
		-------------------------------------------------------------------------------------
		BEGIN TRY
			MERGE dbo.OrganizationDetail AS TARGET
			USING Staging.PsInstitution AS SOURCE
				ON TARGET.OrganizationId = SOURCE.OrganizationId
				AND ISNULL(TARGET.RecordStartDateTime, '') = ISNULL(SOURCE.RecordStartDateTime, '')
				AND ISNULL(TARGET.DataCollectionId, -1) = ISNULL(SOURCE.DataCollectionId, -1)
			WHEN MATCHED THEN -- Update existing OrganizationDetail records that are now inaccurate
				UPDATE SET 
					  TARGET.Name = SOURCE.OrganizationName
					, TARGET.RecordEndDateTime = SOURCE.RecordEndDateTime
					, TARGET.DataCollectionId = SOURCE.DataCollectionId
			WHEN NOT MATCHED THEN -- Insert new OrganizationDetail records
				INSERT(OrganizationId,Name,RefOrganizationTypeId, 
				ShortName, RecordStartDateTime, RecordEndDateTime, DataCollectionId) 
				VALUES (
					  SOURCE.OrganizationId
					, SOURCE.OrganizationName
					, @PsInstitutionOrganizationTypeId
					, NULL -- ShortName
					, SOURCE.RecordStartDateTime
					, SOURCE.RecordEndDateTime
					, SOURCE.DataCollectionId
				);
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S01EC0190'
		END CATCH

		--BEGIN TRY
		--	UPDATE od
		--	SET od.RecordEndDateTime = psi.RecordStartDateTime - 1
		--	FROM dbo.OrganizationDetail od
		--	JOIN   (SELECT OrganizationId, MAX(OrganizationDetailId) AS OrganizationDetailId, MAX(RecordStartDateTime) AS RecordStartDateTime
		--			FROM dbo.OrganizationDetail
		--			WHERE RecordEndDateTime IS NULL
		--			GROUP BY OrganizationId
		--			) psi
		--		ON od.OrganizationId = psi.OrganizationId
		--		AND od.OrganizationDetailId <> psi.OrganizationDetailId
		--		AND od.RecordEndDateTime IS NULL
		--END TRY

		--BEGIN CATCH
		--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S01EC0190'
		--END CATCH

		------------------------------------------------------------------------------------------------
		--- Create new dbo.OrganizationOperationalStatus records for new and updated PS Institutions ---
		------------------------------------------------------------------------------------------------
		--BEGIN TRY
		--	MERGE dbo.OrganizationOperationalStatus AS TARGET
		--	USING Staging.PsInstitution AS SOURCE
		--		ON TARGET.OrganizationId = SOURCE.OrganizationId
		--		AND ISNULL(TARGET.OperationalStatusEffectiveDate, '') = ISNULL(SOURCE.OperationalStatusEffectiveDate, '')
		--		AND ISNULL(TARGET.DataCollectionId, -1) = ISNULL(SOURCE.DataCollectionId, -1)
		--	WHEN MATCHED THEN -- Update existing OrganizationOperationalStatus records that are now inaccurate
		--		UPDATE SET TARGET.RefOperationalStatusId = SOURCE.OperationalStatusId, TARGET.DataCollectionId = SOURCE.DataCollectionId
		--	WHEN NOT MATCHED THEN -- Insert new OrganizationOperationalStatus records
		--		INSERT VALUES (
		--			  SOURCE.OrganizationId
		--			, SOURCE.OperationalStatusId
		--			, SOURCE.OperationalStatusEffectiveDate
		--			, SOURCE.RecordStartDateTime
		--			, SOURCE.RecordEndDateTime
		--			, SOURCE.DataCollectionId
		--		);
		--END TRY

		--BEGIN CATCH
		--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationOperationalStatus', NULL, 'S01EC0190'
		--END CATCH

		-------------------------------------------------------------------------------------
		--- Create new dbo.PsInstitution records for new and updated PS Institutions ---
		-------------------------------------------------------------------------------------
		BEGIN TRY
			MERGE dbo.PsInstitution AS TARGET
			USING Staging.PsInstitution AS SOURCE
				ON TARGET.OrganizationId = SOURCE.OrganizationId
				AND ISNULL(TARGET.RecordStartDateTime, '') = ISNULL(SOURCE.RecordStartDateTime, '')
				AND ISNULL(TARGET.DataCollectionId, -1) = ISNULL(SOURCE.DataCollectionId, -1)
			WHEN MATCHED THEN -- Update existing PsInstitution records that are now inaccurate
				UPDATE SET 
					  --TARGET.RefMostPrevalentLevelOfInstitutionId = SOURCE.MostPrevalentLevelOfInstitutionId
					 TARGET.RecordEndDateTime = SOURCE.RecordEndDateTime
			WHEN NOT MATCHED THEN -- Insert new PsInstitution records
				INSERT (
					  OrganizationId
					--, RefMostPrevalentLevelOfInstitutionId
					, RefPredominantCalendarSystemId
					, RecordStartDateTime
					, RecordEndDateTime
					, DataCollectionId
					)
					VALUES (
					  SOURCE.OrganizationId
					--, SOURCE.MostPrevalentLevelOfInstitutionId
					, SOURCE.PredominantCalendarSystemId
					, SOURCE.RecordStartDateTime
					, SOURCE.RecordEndDateTime
					, SOURCE.DataCollectionId
				);
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PsInstitution', NULL, 'S01EC0190'
		END CATCH

		BEGIN TRY
			UPDATE psi
			SET psi.RecordEndDateTime = spi.RecordStartDateTime - 1
			FROM dbo.PsInstitution psi
			JOIN   (SELECT OrganizationId, MAX(PsInstitutionId) AS PsInstitutionId, MAX(RecordStartDateTime) AS RecordStartDateTime
					FROM dbo.PsInstitution
					WHERE RecordEndDateTime IS NULL
					GROUP BY OrganizationId
					) spi
				ON psi.OrganizationId = spi.OrganizationId
				AND psi.PsInstitutionId <> spi.PsInstitutionId
				AND psi.RecordEndDateTime IS NULL
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PsInstitution', NULL, 'S01EC0190'
		END CATCH

		--------------------------------------------------------------------------------------
		--- Create new dbo.OrganizationWebsite records for new and updated PS Institutions ---
		--------------------------------------------------------------------------------------
		BEGIN TRY
			MERGE dbo.OrganizationWebsite AS TARGET
			USING Staging.PsInstitution AS SOURCE
				ON TARGET.OrganizationId = SOURCE.OrganizationId
				AND ISNULL(TARGET.RecordStartDateTime, '') = ISNULL(SOURCE.RecordStartDateTime, '')
				AND ISNULL(TARGET.DataCollectionId, -1) = ISNULL(SOURCE.DataCollectionId, -1)
			WHEN MATCHED THEN -- Update existing PsInstitution records that are now inaccurate
				UPDATE SET 
					  TARGET.Website = SOURCE.Website
					, TARGET.RecordEndDateTime = SOURCE.RecordEndDateTime
			WHEN NOT MATCHED THEN -- Insert new PsInstitution records
				INSERT (
					  OrganizationId
					, Website
					, RecordStartDateTime
					, RecordEndDateTime
					, DataCollectionId 
					)
					VALUES (
					  SOURCE.OrganizationId
					, SOURCE.Website
					, SOURCE.RecordStartDateTime
					, SOURCE.RecordEndDateTime
					, SOURCE.DataCollectionId
				);
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationWebsite', NULL, 'S01EC0190'
		END CATCH

		--BEGIN TRY
		--	UPDATE ow
		--	SET ow.RecordEndDateTime = spi.RecordStartDateTime - 1
		--	FROM dbo.OrganizationWebsite ow
		--	JOIN   (SELECT OrganizationId, MAX(OrganizationWebsiteId) AS OrganizationWebsiteId, MAX(RecordStartDateTime) AS RecordStartDateTime
		--			FROM dbo.OrganizationWebsite
		--			WHERE RecordEndDateTime IS NULL
		--			GROUP BY OrganizationId
		--			) spi
		--		ON ow.OrganizationId = spi.OrganizationId
		--		AND ow.OrganizationWebsiteId <> spi.OrganizationWebsiteId
		--		AND ow.RecordEndDateTime IS NULL
		--END TRY

		--BEGIN CATCH
		--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationWebsite', NULL, 'S01EC0190'
		--END CATCH

	SET NOCOUNT OFF;

END
