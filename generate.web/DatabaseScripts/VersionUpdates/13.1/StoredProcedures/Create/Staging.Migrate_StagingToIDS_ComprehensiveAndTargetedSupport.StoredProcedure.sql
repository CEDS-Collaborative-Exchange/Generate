CREATE procedure [Staging].[Migrate_StagingToIDS_ComprehensiveandTargetedSupport]
	@SchoolYear SMALLINT = NULL
AS
	/*************************************************************************************************************
	Date Created:  4/20/2021

	Purpose:
		The purpose of this ETL is to load comprehensive and targeted support reasons for EDFacts reports.

	Assumptions:
        
	Account executed under: 

	Approximate run time:  

	Data Sources: 

	Data Targets:  Generate Database:   Generate

	Return Values:
    		0	= Success
  
	Example Usage: 
		EXEC App.[Migrate_StagingToIDS_ComprehensiveandTargetedSupport] 2018;
    
	Modification Log:
		#	  Date		  Issue#   Description
		--  ----------  -------  --------------------------------------------------------------------
		01		  	 
	*************************************************************************************************************/
BEGIN

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

	/* Variable for error handling */
	DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP22_ComprehensiveandTargetedSupport'

	/* Update staging tables with OrganizationId from IDS */
	BEGIN TRY

		UPDATE Staging.K12SchoolComprehensiveSupportIdentificationType
		SET OrganizationID = orgid.OrganizationId
		FROM Staging.K12SchoolComprehensiveSupportIdentificationType mcc
		JOIN dbo.OrganizationIdentifier orgid 
			ON mcc.School_Identifier_State = orgid.Identifier
		WHERE orgid.RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('001073')
			AND orgid.RefOrganizationIdentificationSystemId = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001073')

	END TRY
	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12SchoolComprehensiveSupportIdentificationType', 'OrganizationId', 'S09EC100' 
	END CATCH
		
	BEGIN TRY

		UPDATE Staging.K12SchoolTargetedSupportIdentificationType
		SET OrganizationID = orgid.OrganizationId
		FROM Staging.K12SchoolTargetedSupportIdentificationType mcc
		JOIN dbo.OrganizationIdentifier orgid 
			ON mcc.School_Identifier_State = orgid.Identifier
		WHERE orgid.RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('001073')
			AND orgid.RefOrganizationIdentificationSystemId = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001073');

	END TRY
	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12SchoolTargetedSupportIdentificationType', 'OrganizationId', 'S22EC110' 
	END CATCH;

	/* Update staging tables with K12SchoolId from IDS */
	BEGIN TRY

		UPDATE Staging.K12SchoolComprehensiveSupportIdentificationType
		SET K12SchoolId = k.K12SchoolId
		FROM Staging.K12SchoolComprehensiveSupportIdentificationType mcc
		JOIN dbo.K12School k 
			ON mcc.OrganizationId = k.OrganizationId

	END TRY
	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12SchoolComprehensiveSupportIdentificationType', 'K12SchoolId', 'S22EC120' 
	END CATCH
		
	BEGIN TRY

		UPDATE Staging.K12SchoolTargetedSupportIdentificationType
		SET K12SchoolId = k.K12SchoolId
		FROM Staging.K12SchoolTargetedSupportIdentificationType mcc
		JOIN dbo.K12School k 
			ON mcc.OrganizationId = k.OrganizationId;

	END TRY
	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12SchoolTargetedSupportIdentificationType', 'K12SchoolId', 'S22EC130' 
	END CATCH;

	/* Merge data into IDS tables */
	DECLARE @ComprehensiveSupportIdentificationType TABLE (
		RecordId INT
		,SourceId INT
	)
		  
	DECLARE @TargetedSupportIdentificationType TABLE (
		RecordId INT
		,SourceId INT
	)

	/* dbo.K12SchoolComprehensiveSupportIdentificationType */
	BEGIN TRY

		MERGE dbo.K12SchoolComprehensiveSupportIdentificationType AS TARGET
		USING (
			SELECT sk.Id
				,sk.K12SchoolId
				,rcs.RefComprehensiveSupportId
				,rcsra.RefComprehensiveSupportReasonApplicabilityId
				,sk.RecordStartDateTime
				,sk.RecordEndDateTime
			FROM Staging.K12SchoolComprehensiveSupportIdentificationType sk
			INNER JOIN dbo.RefComprehensiveSupport rcs 
				ON sk.ComprehensiveSupport = rcs.Code
			INNER JOIN dbo.RefComprehensiveSupportReasonApplicability rcsra 
				ON sk.ComprehensiveSupportReasonApplicability = rcsra.Code
			WHERE sk.K12SchoolId IS NOT NULL
		) AS SOURCE
			ON SOURCE.K12SchoolId = TARGET.K12SchoolId
			AND SOURCE.RefComprehensiveSupportId = TARGET.RefComprehensiveSupportId
		WHEN NOT MATCHED THEN
			INSERT (
				K12SchoolId
				,RefComprehensiveSupportId
				,RefComprehensiveSupportReasonApplicabilityId
				,RecordStartDateTime
				,RecordEndDateTime
			)
			VALUES (
				K12SchoolId
				,RefComprehensiveSupportId
				,RefComprehensiveSupportReasonApplicabilityId
				,[Staging].[GetFiscalYearStartDate](@SchoolYear) 
				,[Staging].[GetFiscalYearEndDate](@SchoolYear) 
			)
		OUTPUT
			INSERTED.K12SchoolComprehensiveSupportIdentificationTypeId
			, SOURCE.ID
		INTO @ComprehensiveSupportIdentificationType;
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12SchoolComprehensiveSupportIdentificationType', NULL, 'S22EC200' 
	END CATCH

	/* dbo.K12SchoolTargetedSupportIdentificationType */
	BEGIN TRY

		MERGE dbo.K12SchoolTargetedSupportIdentificationType AS TARGET
		USING (
			SELECT sk.Id
				,sk.K12SchoolId
				,rcs.RefSubgroupId
				,rcsra.RefComprehensiveSupportReasonApplicabilityId
				,sk.RecordStartDateTime
				,sk.RecordEndDateTime
			FROM Staging.K12SchoolTargetedSupportIdentificationType sk
			INNER JOIN dbo.RefSubgroup rcs	
				ON sk.Subgroup = rcs.Code
			INNER JOIN dbo.RefComprehensiveSupportReasonApplicability rcsra 
				ON sk.ComprehensiveSupportReasonApplicability = rcsra.Code
			where sk.K12SchoolId IS NOT NULL
		) AS SOURCE
			ON SOURCE.K12SchoolId = TARGET.K12SchoolId
			AND SOURCE.RefSubgroupId = TARGET.RefSubgroupId
		WHEN NOT MATCHED THEN
			INSERT (
				K12SchoolId
				,RefSubgroupId
				,RefComprehensiveSupportReasonApplicabilityId
				,RecordStartDateTime
				,RecordEndDateTime
			)
			VALUES (
				K12SchoolId
				,RefSubgroupId
				,RefComprehensiveSupportReasonApplicabilityId
				,[Staging].[GetFiscalYearStartDate](@SchoolYear) 
				,[Staging].[GetFiscalYearEndDate](@SchoolYear) 
			)
		OUTPUT
			INSERTED.K12SchoolTargetedSupportIdentificationTypeId
			, SOURCE.ID
		INTO @TargetedSupportIdentificationType;
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12SchoolTargetedSupportIdentificationType', NULL, 'S22EC210' 
	END CATCH

	--/* Update staging tables with new RecordId */
	--BEGIN TRY
	--	UPDATE Staging.K12SchoolComprehensiveSupportIdentificationType
	--	SET K12SchoolComprehensiveSupportIdentificationTypeId = csi.RecordId
	--	FROM Staging.K12SchoolComprehensiveSupportIdentificationType kcsi
	--	INNER JOIN @ComprehensiveSupportIdentificationType csi
	--		ON kcsi.K12SchoolComprehensiveSupportIdentificationTypeId = csi.SourceId
	--END TRY

	--BEGIN CATCH 
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12SchoolComprehensiveSupportIdentificationType', NULL, 'S22EC220' 
	--END CATCH
		
	--BEGIN TRY
	--	UPDATE Staging.K12SchoolTargetedSupportIdentificationType
	--	SET K12SchoolTargetedSupportIdentificationTypeId = csi.RecordId
	--	FROM Staging.K12SchoolTargetedSupportIdentificationType kcsi
	--	INNER JOIN @TargetedSupportIdentificationType csi
	--		ON kcsi.Id = csi.SourceId
	--END TRY

	--BEGIN CATCH 
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12SchoolTargetedSupportIdentificationType', NULL, 'S22EC230' 
	--END CATCH;

END

