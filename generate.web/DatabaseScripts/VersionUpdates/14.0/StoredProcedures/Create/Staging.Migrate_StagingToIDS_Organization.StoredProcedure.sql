CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_Organization]
	@SchoolYear SMALLINT = NULL
AS

--    /*************************************************************************************************************
--    Date Created:  5/21/2018
--		[Staging].[Migrate_StagingToIDS_Organization] 2018
--    Purpose:
--        The purpose of this ETL is to manage the State Education Agency (SEA), Local Education Agency (LEA),
--        and School organization information in the Generate dbo.  This ETL is run each time the
--        the ODS is populated and retrieves data from the states source system that houses information
--        related to the school's and LEA's operational status (e.g., Open, Closed, etc.). It will update
--		based on information found in the source data related to SEAs, LEAs and Schools.

--    Assumptions:
--        This procedure assumes that the source tables are ready for consumption. 

--    Account executed under: LOGIN

--    Approximate run time:  ~ 10 seconds

--    Data Sources:  Ed-Fi ODS

--    Data Targets:  Generate Database

--    Return Values:
--    	 0	= Success
  
--    Example Usage: 
--      EXEC Staging.[Migrate_StagingToIDS_Organization] 2018;
    
--    Modification Log:
--      #	  Date		  Issue#   Description
--      --  ----------  -------  --------------------------------------------------------------------
--      01  05/21/2018           First Release	
--		02	07/11/2022			 Tightened joins for performance and to produce fewer duplicate records to be less dependent on DISTINCT clause 
--    *************************************************************************************************************/

BEGIN

	SET NOCOUNT ON;
	---------------------------------------------------------------------------------------------------------------------
	-------------------------------------End State Specific Information Section------------------------------------------
	----All code below this point should not be adjusted. It is created to use the staging tables to load the------------
	----the CEDS Operational Data Store.---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------
	
	-- Roll the staging.SourceSystemReferenceData OptionSets into the next school year, if necessary
	IF (SELECT COUNT(*) FROM staging.SourceSystemReferenceData WHERE SchoolYear = @SchoolYear) = 0
	BEGIN

		INSERT INTO staging.SourceSystemReferenceData (
			SchoolYear
			,TableName
			,TableFilter
			,InputCode
			,OutputCode
		)
		SELECT DISTINCT
			@SchoolYear
			,TableName
			,TableFilter
			,InputCode
			,OutputCode
		FROM staging.SourceSystemReferenceData
		WHERE SchoolYear = @SchoolYear - 1

	END
	
    ---------------------------------------------------
    --- Declare Error Handling Variables           ----
    ---------------------------------------------------
	DECLARE @eStoredProc			varchar(100) = 'Migrate_StagingToIDS_Organization'

	--------------------------------------------------------------
	--- Optimize indexes on Staging tables --- 
	--------------------------------------------------------------
	ALTER INDEX ALL ON Staging.K12Organization
	REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

	ALTER INDEX ALL ON Staging.OrganizationAddress
	REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

	ALTER INDEX ALL ON Staging.OrganizationGradeOffered
	REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

	ALTER INDEX ALL ON Staging.OrganizationPhone
	REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);


	/* Define all local variables */
	-------------------------------
	DECLARE @IEU_OrganizationId INT
		   ,@LEA_OrganizationId INT
		   ,@SCHOOL_OrganizationId INT
		   ,@LocationId INT
		   ,@SpecialEducationProgram_OrganizationId INT
		   ,@LEA_Identifier_State VARCHAR(100)
		   ,@LEA_Identifier_NCES VARCHAR(100)
		   ,@ID INT
		   ,@FirstDayOfSchool DATETIME
		   ,@UpdateDateTime DATETIME = GETDATE()
		   ,@SeaOrgType INT
		   ,@SeaFederalIdSystem INT
		   ,@SeaIdSystem INT
		   ,@SeaIdType INT
		   ,@IeuOrgType INT
		   ,@IeuIdSystem INT
		   ,@IeuIdType INT
		   ,@LeaOrgType INT
		   ,@LEAOrgType_NotFederal INT
		   ,@LeaIdSystem INT
		   ,@LeaIdType INT
		   ,@LeaNcesIdSystem INT
		   ,@SchoolOrgType INT
		   ,@SchoolOrgType_NotFederal INT
		   ,@SchoolIdSystem INT
		   ,@SchoolIdType INT
		   ,@SchoolNcesIdSystem INT
		   ,@SchoolFeinIdSystem INT
		   ,@AuthorizingBodyRelationship INT
		   ,@CharterAuthOrgIdSystem INT

	SET @SeaOrgType = Staging.GetOrganizationTypeId('SEA', '001156')
	SET @SeaIdType = Staging.[GetOrganizationIdentifierTypeId]('001491')
	SET @SeaFederalIdSystem = Staging.[GetOrganizationIdentifierSystemId]('Federal', '001491')
	SET @IeuOrgType = Staging.GetOrganizationTypeId('IEU', '001156')
	SET @IeuIdSystem = Staging.[GetOrganizationIdentifierSystemId]('IEU', '001156')
	SET @IeuIdType = Staging.[GetOrganizationIdentifierTypeId]('001156')
	SET @LeaOrgType = Staging.GetOrganizationTypeId('LEA', '001156')
	SET @LEAOrgType_NotFederal = Staging.GetOrganizationTypeId('LEANotFederal', '001156')
	SET @LeaIdSystem = Staging.[GetOrganizationIdentifierSystemId]('SEA', '001072')
	SET @LeaIdType = Staging.[GetOrganizationIdentifierTypeId]('001072')
	SET @LeaNcesIdSystem = Staging.[GetOrganizationIdentifierSystemId]('NCES', '001072')
	SET @SchoolOrgType = Staging.GetOrganizationTypeId('K12School', '001156')
	SET @SchoolOrgType_NotFederal = Staging.GetOrganizationTypeId('K12SchoolNotFederal', '001156')
	SET @SchoolIdSystem = Staging.[GetOrganizationIdentifierSystemId]('SEA', '001073')
	SET @SchoolIdType = Staging.[GetOrganizationIdentifierTypeId]('001073')
	SET @SchoolNcesIdSystem = Staging.[GetOrganizationIdentifierSystemId]('NCES', '001073')
	SET @SchoolFeinIdSystem = Staging.[GetOrganizationIdentifierSystemId]('Federal', '001073')
	SET @AuthorizingBodyRelationship = Staging.[GetOrganizationRelationshipId] ('AuthorizingBody')
	SET @CharterAuthOrgIdSystem = Staging.[GetOrganizationIdentifierSystemId]('CharterSchoolAuthorizingOrganization', '001156')

	--Charter School Authorizer local variables
	DECLARE @CharterSchoolAuthorizerIdentificationSystemId INT
			,@charterSchoolAuthTypeId INT
			,@OrganizationIdentificationSystem INT
			,@PrimaryAuthorizingBodyOrganizationRelationship INT
			,@SecondaryAuthorizingBodyOrganizationRelationship INT

	SET @CharterSchoolAuthorizerIdentificationSystemId = Staging.GetOrganizationIdentifierSystemId('SEA', '000827')
	SET @charterSchoolAuthTypeId = Staging.GetOrganizationTypeId('CharterSchoolAuthorizingOrganization','001156')
	SET @OrganizationIdentificationSystem = Staging.GetOrganizationIdentifierTypeId('000827')

	SELECT	@PrimaryAuthorizingBodyOrganizationRelationship = RefOrganizationRelationshipId 
	FROM	dbo.RefOrganizationRelationship
	WHERE	Code = 'AuthorizingBody'

	SELECT	@SecondaryAuthorizingBodyOrganizationRelationship = RefOrganizationRelationshipId 
	FROM	dbo.RefOrganizationRelationship
	WHERE	Code = 'SecondaryAuthorizingBody'


	--DECLARE @OrgTypeId_SEA int = Staging.GetOrganizationTypeId('SEA', '001156')
	--DECLARE @OrgTypeId_Program int = Staging.GetOrganizationTypeId('Program', '001156')
	
	--DECLARE @OrgTypeId_LEA int = Staging.GetOrganizationTypeId('LEA', '001156')
	--DECLARE @OrgTypeId_LEANotFederal int = Staging.GetOrganizationTypeId('LEANotFederal', '001156')
	--DECLARE @OrgTypeId_K12School int = Staging.GetOrganizationTypeId('K12School', '001156')
	--DECLARE @OrgTypeId_K12SchoolNotFederal int = Staging.GetOrganizationTypeId('K12SchoolNotFederal', '001156')

	--DECLARE @OrgIdTypeId_LEA int = Staging.GetOrganizationIdentifierTypeId('001072')
	--DECLARE @OrgIdTypeId_School int = Staging.GetOrganizationIdentifierTypeId('001073')
	--DECLARE @OrgIdTypeId_State int = [App].[GetOrganizationIdentifierTypeId]('001491')

	--DECLARE @OrgIdSystemId_LEA_NCES int = [App].[GetOrganizationIdentifierSystemId]('NCES', '001072')
	--DECLARE @OrgIdSystemId_School_NCES int = [App].[GetOrganizationIdentifierSystemId]('NCES', '001073')
	--DECLARE @OrgIdSystemId_LEA_SEA int = [App].[GetOrganizationIdentifierSystemId]('SEA', '001072')
	--DECLARE @OrgIdSystemId_School_SEA int = [App].[GetOrganizationIdentifierSystemId]('SEA', '001073')
	--DECLARE @OrgIdSystemId_School_Fed int = [App].[GetOrganizationIdentifierSystemId]('Federal', '001073')
	--DECLARE @OrgIdSystemId_State_Fed int = [App].[GetOrganizationIdentifierSystemId]('Federal', '001491')
	--DECLARE @OrgIdSystemId_State_State int = [App].[GetOrganizationIdentifierSystemId]('State', '001491')

	--DECLARE @LEA_OrganizationId INT
	--	   ,@SCHOOL_OrganizationId INT
	--	   ,@LocationId INT
	--	   ,@LEA_Identifier_State VARCHAR(100)
	--	   ,@LEA_Identifier_NCES VARCHAR(100)
	--	   ,@RecordStartDate DATETIME
	--	   ,@RecordEndDate DATETIME
	--	   ,@UpdateDateTime DATETIME
	--	   ,@ID INT
	--	   ,@FirstDayOfSchool DATETIME
	--	   ,@OldRecordStartDate DATETIME		   
	--	   ,@OldRecordEndDate DATETIME

	--SET @RecordStartDate = Staging.GetFiscalYearStartDate(@SchoolYear);

	--SET @OldRecordStartDate = Staging.GetFiscalYearStartDate(@SchoolYear -1);
		
	--SET @RecordEndDate = Staging.GetFiscalYearEndDate(@SchoolYear);

	--SET @OldRecordEndDate = Staging.GetFiscalYearEndDate(@SchoolYear -1);

	--SET @UpdateDateTime = GETDATE()

	--Update the Bit value to indicate that an identifier has changed.
	BEGIN TRY
		UPDATE Staging.K12Organization SET IEU_Identifier_State_ChangedIdentifier = 1 WHERE IEU_Identifier_State_Identifier_Old IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'IEU_Identifier_State_ChangedIdentifier', 'STEC0120'
	END CATCH

	BEGIN TRY
		UPDATE Staging.K12Organization SET LEA_Identifier_State_ChangedIdentifier = 1 WHERE LEA_Identifier_State_Identifier_Old IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'LEA_Identifier_State_ChangedIdentifier', 'STEC0120'
	END CATCH

	BEGIN TRY
		UPDATE Staging.K12Organization SET School_Identifier_State_ChangedIdentifier = 1 WHERE School_Identifier_State_Identifier_Old IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'School_Identifier_State_ChangedIdentifier', 'STEC0130'
	END CATCH

	---Begin Housekeeping items on the staging table---

	--This section ensures that if state identifers change for the LEA or School and the source data does not contain the old identifier, the change is still
	--picked up by using the NCES ID as the crosswalk between the old and the new. This code is primarily only used when the source system is live and cannot
	--produce historical data for the Organization to show the change from one Identifier to another, but still can show consistency through the NCES ID.

	--This update statement looks for a new state LEA Identifier using the NCES Id as the crosswalk between the staging table Identifier and the Identifier
	--already stored in the dbo.OrganizationIdentifier table.  If they are different and the LEA_Identifier_State_Identifier_Old column in the staging table
	--is NULL, it will mark it with the Identifier stored in the ODS and will later end date that identifier and replace it with the new one.

	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	-----Data Section 1 - Update LEA_Identifier_State_Identifier_Old                         -----
	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	BEGIN TRY
		UPDATE Staging.K12Organization
		SET IEU_Identifier_State_Identifier_Old = orgid2.Identifier
		FROM dbo.OrganizationIdentifier orgid1
		JOIN dbo.OrganizationIdentifier orgid2 
			ON orgid1.OrganizationId = orgid2.OrganizationId
		JOIN Staging.K12Organization tod 
			ON orgid1.Identifier = tod.IEU_Identifier_State
		JOIN dbo.DataCollection dc 
			ON ISNULL(dc.DataCollectionId, '') = ISNULL(tod.DataCollectionId, '')
		WHERE orgid1.RefOrganizationIdentificationSystemId = @IeuIdSystem
		AND orgid2.RefOrganizationIdentificationSystemId = @IeuIdSystem
		AND orgid1.RefOrganizationIdentifierTypeId = @IeuIdType
		AND orgid2.RefOrganizationIdentifierTypeId = @IeuIdType
		AND orgid2.Identifier <> tod.IEU_Identifier_State
		AND tod.IEU_Identifier_State_Identifier_Old IS NOT NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'IEU_Identifier_State_Identifier_Old', 'STEC0100'
	END CATCH

	--This section ensures that if state identifers change for the LEA or School and the source data does not contain the old identifier, the change is still
	--picked up by using the NCES ID as the crosswalk between the old and the new.
	--IEUs are not prcessed in this section because they are not assigned NCES IDs.

	--This update statement looks for a new state LEA Identifier using the NCES Id as the crosswalk between the temporary table Identifier and the Identifier
	--already stored in the dbo.OrganizationIdentifier table.  If they are different and the LEA_Identifier_State_Identifier_Old column in the staging table
	--is NULL, it will mark it with the Identifier stored in the dbo and will later end date that identifier and replace it with the new one.
	BEGIN TRY
		UPDATE Staging.K12Organization
		SET LEA_Identifier_State_Identifier_Old = orgid2.Identifier
		FROM dbo.OrganizationIdentifier orgid1
		JOIN dbo.OrganizationIdentifier orgid2 
			ON orgid1.OrganizationId = orgid2.OrganizationId
		JOIN Staging.K12Organization tod 
			ON orgid1.Identifier = tod.LEA_Identifier_NCES
		JOIN dbo.DataCollection dc 
			ON ISNULL(dc.DataCollectionId, '') = ISNULL(tod.DataCollectionId, '')
		WHERE orgid1.RefOrganizationIdentificationSystemId = @LeaNcesIdSystem
		AND orgid2.RefOrganizationIdentificationSystemId = @LeaIdSystem
		AND orgid1.RefOrganizationIdentifierTypeId = @LeaIdType
		AND orgid2.RefOrganizationIdentifierTypeId = @LeaIdType
		AND orgid2.Identifier <> tod.LEA_Identifier_State
		AND tod.LEA_Identifier_State_Identifier_Old IS NOT NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'LEA_Identifier_State_Identifier_Old', 'STEC0100'
	END CATCH

	--This update statement looks for a new state School Identifier using the NCES Id as the crosswalk between the temporary table Identifier and the Identifier
	--already stored in the dbo.OrganizationIdentifier table.  If they are different and the School_Identifier_State_Identifier_Old column in the temp table
	--is NULL, it will mark it with the Identifier stored in the dbo and will later enddate that identifier and replace it with the new one.
	BEGIN TRY
		UPDATE Staging.K12Organization
		SET School_Identifier_State_Identifier_Old = orgid2.Identifier
		FROM dbo.OrganizationIdentifier orgid1
		JOIN dbo.OrganizationIdentifier orgid2 
			ON orgid1.OrganizationId = orgid2.OrganizationId
		JOIN Staging.K12Organization tod 
			ON orgid1.Identifier = tod.School_Identifier_NCES
		JOIN dbo.DataCollection dc 
			ON ISNULL(dc.DataCollectionId, '') = ISNULL(tod.DataCollectionId, '')
		WHERE orgid1.RefOrganizationIdentificationSystemId = @SchoolNcesIdSystem
		AND orgid2.RefOrganizationIdentificationSystemId = @SchoolIdSystem
		AND orgid1.RefOrganizationIdentifierTypeId = @SchoolIdType
		AND orgid2.RefOrganizationIdentifierTypeId = @SchoolIdType
		AND orgid2.Identifier <> tod.School_Identifier_State
		AND tod.School_Identifier_State_Identifier_Old IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'School_Identifier_State_Identifier_Old', 'STEC0110'
	END CATCH

	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	-----Data Section 2 - SEA Data									                         -----
	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------

	--No changes to the SEA data are being made at this time to introduce longitudinality because Generate will be
	--adjusting to accomodate this data in the Toggle section.  When the toggle section has been introduced in
	--Generate for the SEA data, the encapsulated code will be adjusted to look at that location only and the need
	--for the Staging.StateDetail data will go away.

	/* Load the Department of Education SEA Specific Information
	--------------------------------------------------------------
	This infomration is specific to the SEA only and normally does not
	change. It is set up to load once and then with an IF/THEN statement
	is ignored from thereon so long as the data exist in the ODS
	
	*/

	-------------------------------------------------------------------
	----Create SEA Organization Data ----------------------------------
	-------------------------------------------------------------------
	BEGIN TRY 
		UPDATE Staging.StateDetail
		SET DataCollectionId = dc.DataCollectionId
		FROM dbo.DataCollection dc
		JOIN Staging.StateDetail sd
			ON ISNULL(dc.DataCollectionName, '') = ISNULL(sd.DataCollectionName, '')
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StateDetail', 'DataCollectionId', 'S01EC0010'
	END CATCH	
	
	BEGIN TRY
		UPDATE Staging.StateDetail
		SET OrganizationId = orgd.OrganizationId
		FROM Staging.StateDetail tod
		JOIN dbo.OrganizationIdentifier orgid 
			ON tod.SeaStateIdentifier = orgid.Identifier
		JOIN dbo.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
		LEFT JOIN dbo.DataCollection dc 
			ON ISNULL(dc.DataCollectionId, '') = ISNULL(tod.DataCollectionId, '')
		WHERE orgd.RefOrganizationTypeId = @SeaOrgType
		AND orgid.RefOrganizationIdentifierTypeId = @SeaIdType
		AND orgid.RefOrganizationIdentificationSystemId = @SeaFederalIdSystem
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationId_IEU', 'STEC0070'
	END CATCH

	If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#NewSeas '))
	Begin
		Drop Table #NewSeas
	End

	CREATE TABLE #NewSeas (
		  SourceId INT
		, OrganizationId INT
	)

	BEGIN TRY
		MERGE dbo.Organization AS TARGET
		USING Staging.StateDetail AS SOURCE 
			ON ISNULL(SOURCE.OrganizationId, 0) > 0 -- Create a new record for SEA records that don't already exist. 
		WHEN NOT MATCHED THEN 
			INSERT (DataCollectionId) VALUES (Source.DataCollectionId) 
		OUTPUT 
			  SOURCE.Id
			, INSERTED.OrganizationId
		INTO #NewSeas;
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Organization',  NULL, 'S01EC0010'
	END CATCH


	BEGIN TRY
		UPDATE Staging.StateDetail
		SET OrganizationId = ns.OrganizationId
		FROM #NewSeas ns
		JOIN Staging.StateDetail sd
			ON ns.SourceId = sd.Id
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StateDetail', 'OrganizationId', 'S01EC0020'
	END CATCH


	BEGIN TRY
		MERGE dbo.OrganizationDetail AS TARGET
		USING Staging.StateDetail AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId 
			AND ISNULL(TARGET.DataCollectionId, '') = ISNULL(SOURCE.DataCollectionId, '')
			AND TARGET.RecordStartDateTime = SOURCE.RecordStartDateTime
		WHEN MATCHED AND (
			TARGET.Name <> SOURCE.SeaName
			OR TARGET.ShortName <> SOURCE.SeaShortName
			OR TARGET.RecordEndDateTime <> SOURCE.RecordEndDateTime) THEN
				UPDATE SET
				  TARGET.Name = SOURCE.SeaName
				, TARGET.ShortName = SOURCE.SeaShortName
				, TARGET.RecordEndDateTime = SOURCE.RecordEndDateTime
		
		--When no records are matched, insert
		--the incoming records from source
		--table to target table

		WHEN NOT MATCHED BY TARGET THEN   
			INSERT (
				  OrganizationId
				, [Name]
				, ShortName
				, RefOrganizationTypeId
				, DataCollectionId
				, RecordStartDateTime
				, RecordEndDateTime) 
			VALUES (
				  SOURCE.OrganizationId
				, SOURCE.SeaName
				, SOURCE.SeaShortName
				, @SeaOrgType
				, SOURCE.DataCollectionId
				, SOURCE.RecordStartDateTime
				, SOURCE.RecordEndDateTime);
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, NULL, NULL, 'S01EC0140'
	END CATCH

	BEGIN TRY
		MERGE dbo.OrganizationIdentifier AS TARGET
		USING Staging.StateDetail AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId 
			AND ISNULL(TARGET.DataCollectionId, '') = ISNULL(SOURCE.DataCollectionId, '')
			AND TARGET.RecordStartDateTime = SOURCE.RecordStartDateTime
			AND TARGET.RefOrganizationIdentificationSystemId = @SeaFederalIdSystem
			AND TARGET.RefOrganizationIdentifierTypeId = @SeaIdType
		WHEN MATCHED AND (
			TARGET.Identifier <> SOURCE.SeaStateIdentifier
			OR TARGET.RecordEndDateTime <> SOURCE.RecordEndDateTime) THEN
				UPDATE SET
				  TARGET.Identifier = SOURCE.SeaStateIdentifier
				, TARGET.RecordEndDateTime = SOURCE.RecordEndDateTime
		
		--When no records are matched, insert
		--the incoming records from source
		--table to target table

		WHEN NOT MATCHED BY TARGET THEN   
			INSERT (
				  [Identifier]
				, [RefOrganizationIdentificationSystemId]
				, [OrganizationId]
				, [RefOrganizationIdentifierTypeId]
				, [RecordStartDateTime]
				, [RecordEndDateTime]
				, [DataCollectionId]
				)
			VALUES (
				  SOURCE.SeaStateIdentifier --StateANSICode from RefStateANSICode table--
				, @SeaFederalIdSystem --Federal identification from the RefOrganizationIdentificationSystem table--
				, SOURCE.OrganizationId 
				, @SeaIdType --State Agency Identification System from the RefOrganizationIdentifierType table --
				, SOURCE.RecordStartDateTime
				, SOURCE.RecordEndDateTime
				, SOURCE.DataCollectionId 
				);
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, NULL, NULL, 'S01EC0140'
	END CATCH

	BEGIN TRY
		UPDATE Staging.K12Organization 
		SET OrganizationId_SEA = sd.OrganizationId 
		FROM Staging.StateDetail sd 
		JOIN Staging.K12Organization ko
			ON ISNULL(sd.DataCollectionId, '') = ISNULL(ko.DataCollectionId, '')
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationId_SEA', 'S01EC0150'
	END CATCH

	-------------------------------------------------------------------
	----Create IEU Organization Data ----------------------------------
	---------------------------------------------------------------------
	--/* Insert IEUs into dbo.Organization
	--------------------------------------------------------------------------
	--In this section, IEU are added as Organizations in the ODS 
	--and linked via OrgnaizationRelationship to their LEAs.
	--*/

	----First check to see if the IEU already exists so that it is not created a second time.
	--BEGIN TRY
	--	UPDATE Staging.K12Organization
	--	SET OrganizationId_IEU = orgd.OrganizationId
	--	FROM Staging.K12Organization tod
	--	JOIN dbo.OrganizationIdentifier orgid ON tod.IEU_Identifier_State = orgid.Identifier
	--	JOIN dbo.OrganizationDetail orgd ON orgid.OrganizationId = orgd.OrganizationID
	--	JOIN dbo.DataCollection dc ON dc.DataCollectionId = tod.DataCollectionId
	--	WHERE orgd.RefOrganizationTypeId = @IeuOrgType --CHANGED|TODO: switch to IEU values ('IEU', '001156')
	--	AND orgid.RefOrganizationIdentifierTypeId = @IeuIdType --CHANGED|TODO: switch to IEU values ('001156')
	--	AND orgid.RefOrganizationIdentificationSystemId = @IeuIdSystem --CHANGED|TODO: switch to IEU values ('IEU', '001156')
	--END TRY

	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationId_IEU', 'STEC0100'
	--END CATCH

	--Added|TODO: Copy & paste paste lines 304-504 below, insert here, and update to create IEU records.  

	-------------------------------------------------------------------
	----Create IEU Organization Data ------------------------
	-------------------------------------------------------------------

	--MERGE IEU data into dbo.Organization

	--First check to see if the IEU already exists so that it is not created a second time.
	BEGIN TRY
		UPDATE Staging.K12Organization
		SET OrganizationId_IEU = orgd.OrganizationId
		FROM Staging.K12Organization tod
		JOIN dbo.OrganizationIdentifier orgid 
			ON tod.IEU_Identifier_State = orgid.Identifier
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
		JOIN dbo.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
		WHERE orgd.RefOrganizationTypeId = @IeuOrgType 
		AND orgid.RefOrganizationIdentifierTypeId = @IeuIdType 
		AND orgid.RefOrganizationIdentificationSystemId = @IeuIdSystem
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationId_IEU', 'STEC0070'
	END CATCH

	--Insert new IEUs--
	--Get a distinct list of IEU IDs that need to be inserted 
	--so that we can use a MERGE properly.		
	If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#DistinctNewIeus '))
	Begin
		Drop Table #DistinctNewIeus 
	End
		

	CREATE TABLE #DistinctNewIeus  (
		  IEU_Identifier_State VARCHAR(100)
		, IEU_Name VARCHAR(100)
		, OrganizationId INT NULL
		, DataCollectionId INT NULL
		, RecordStartDateTIme DATETIME NULL
		, RecordEndDateTIme DATETIME NULL
		, SchoolYear INT NULL
	)

	BEGIN TRY
		INSERT INTO #DistinctNewIeus 
		SELECT DISTINCT 
			  IEU_Identifier_State
			, IEU_Name
			, NULL as OrganizationId
			, dc.DataCollectionId
			, a.IEU_RecordStartDateTime
			, a.IEU_RecordEndDateTime
			, a.SchoolYear			
		FROM Staging.K12Organization a
		JOIN dbo.DataCollection dc 
			ON ISNULL(dc.DataCollectionId, '') = ISNULL(a.DataCollectionId, '')
		WHERE IEU_Name IS NOT NULL 
		AND IEU_Identifier_State IS NOT NULL 
		AND OrganizationId_IEU is null
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewIeus', NULL, 'S01EC0090'
	END CATCH

	--This table captures the Staging.IEU_Identifier_State 
	--and the new OrganizationId from dbo.Organization 
	--so that we can create the child records.
	If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#NewIeuOrganization'))
	Begin
		Drop Table #NewIeuOrganization
	End
		
	CREATE TABLE #NewIeuOrganization (
		  OrganizationId INT
		, IEU_Identifier_State VARCHAR(100)
		, DataCollectionId INT NULL
		, SchoolYear VARCHAR(100)
	)

	BEGIN TRY
		MERGE dbo.Organization AS TARGET
		USING #DistinctNewIeus  AS SOURCE 
			ON 1 = 0 -- always insert 
		WHEN NOT MATCHED THEN 
			INSERT (DataCollectionId) VALUES (Source.DataCollectionId)
		OUTPUT 
			  INSERTED.OrganizationId
			, SOURCE.IEU_Identifier_State
			, SOURCE.DataCollectionId
			, SOURCE.SchoolYear
		INTO #NewIeuOrganization;
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Organization', NULL, 'S01EC0100'
	END CATCH

	BEGIN TRY
		UPDATE Staging.K12Organization
		SET   OrganizationId_IEU = norg.OrganizationId
			, NewIeu = 1
		FROM Staging.K12Organization o
		JOIN #NewIeuOrganization norg 
			ON o.IEU_Identifier_State = norg.IEU_Identifier_State 
			and ISNULL(o.DataCollectionId, '') = ISNULL(norg.DataCollectionId, '')
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationId_IEU', 'S01EC0110'
	END CATCH

	BEGIN TRY
		UPDATE #DistinctNewIeus 
		SET OrganizationId = o.OrganizationId_IEU
		FROM Staging.K12Organization o
		JOIN #DistinctNewIeus norg
			ON o.IEU_Identifier_State = norg.IEU_Identifier_State 
			and ISNULL(o.DataCollectionId, '') = ISNULL(norg.DataCollectionId, '')
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewIeus', 'OrganizationId', 'S01EC0120'
	END CATCH

	BEGIN TRY
		--Update IEU names by end dating the 
		--current OrganizationDetail record and creating a new one
		UPDATE dbo.OrganizationDetail
		SET RecordEndDateTime = o.IEU_RecordEndDateTime
		FROM Staging.K12Organization o
		JOIN dbo.OrganizationDetail od
			ON o.OrganizationId_IEU = od.OrganizationId
			AND o.IEU_Name <> od.[Name]
			AND od.RecordEndDateTime IS NULL
			AND ISNULL(o.DataCollectionId, '') = ISNULL(od.DataCollectionId, '')
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', 'RecordEndDateTime', 'S01EC0130'
	END CATCH

	BEGIN TRY

		MERGE dbo.OrganizationDetail AS TARGET
		USING #DistinctNewIeus  AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
			and ISNULL(TARGET.DataCollectionId, '') = ISNULL(SOURCE.DataCollectionId, '')
		--When no records are matched, insert
		--the incoming records from source
		--table to target table

		WHEN NOT MATCHED BY TARGET THEN   
			INSERT (
				  OrganizationId
				, [Name]
				, RefOrganizationTypeId
				, DataCollectionId
				, RecordStartDateTime
				, RecordEndDateTime) 
			VALUES (
				  SOURCE.OrganizationId
				, SOURCE.IEU_Name
				, @IeuOrgType
				, SOURCE.DataCollectionId
				, SOURCE.RecordStartDateTime
				, SOURCE.RecordEndDateTime);
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S01EC0150'
	END CATCH

	-------------------------------------------------------------------
	----Create LEA and School Organization Data -----------------------
	-------------------------------------------------------------------

	/* Insert LEA/K12 School/Special Education Program into dbo.Organization
	------------------------------------------------------------------------
	In this section, the LEA, School and Special Education Programs are created
	as Organizations in the dbo.  And the relationships betweeen the Organizations
	are also created.
	
	*/

	--MERGE LEA data into dbo.Organization

	--First check to see if the LEA already exists so that it is not created a second time.
	BEGIN TRY
		UPDATE Staging.K12Organization
		SET OrganizationId_LEA = orgd.OrganizationId
		FROM Staging.K12Organization tod
		JOIN dbo.OrganizationIdentifier orgid 
			ON tod.LEA_Identifier_State = orgid.Identifier
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgid.DataCollectionid, '')
		JOIN dbo.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
			AND ISNULL(orgd.DataCollectionId, '') = ISNULL(orgid.DataCollectionid, '')
		WHERE orgd.RefOrganizationTypeId in (@LeaOrgType, @LEAOrgType_NotFederal)
		AND orgid.RefOrganizationIdentifierTypeId = @LeaIdType
		AND orgid.RefOrganizationIdentificationSystemId = @LeaIdSystem
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationId_LEA', 'STEC0160'
	END CATCH

---Everything correct above this line - no additional changes.

	--Insert new LEAs--
	--Get a distinct list of LEA IDs that need to be inserted 
	--so that we can use a MERGE properly.		
	
	If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#DistinctNewLeas'))
	Begin
		Drop Table #DistinctNewLeas
	End
		

	CREATE TABLE #DistinctNewLeas(
		  LEA_Identifier_State VARCHAR(100)
		, LEA_Identifier_NCES VARCHAR(100)
		, LEA_Name VARCHAR(100)
		, OrganizationId INT NULL
		, DataCollectionId INT NULL
		, RecordStartDateTIme DATETIME NULL
		, RecordEndDateTime DATETIME NULL
		, SchoolYear VARCHAR(100)
	)

	BEGIN TRY
		INSERT INTO #DistinctNewLeas
		SELECT DISTINCT 
			  LEA_Identifier_State
			, LEA_Identifier_NCES
			, LEA_Name
			, NULL as OrganizationId
			, a.DataCollectionId
			, a.Lea_RecordStartDateTime 
			, a.Lea_RecordEndDateTime
			, a.SchoolYear		
		FROM Staging.K12Organization a
		WHERE OrganizationId_LEA IS NULL 
		AND LEA_Identifier_State IS NOT NULL 
		AND LEA_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '#DistinctNewLeas', NULL, 'S01EC0180'
	END CATCH

	--This table captures the Staging.LEA_Identifier_State 
	--and the new OrganizationId from dbo.K12Organization 
	--so that we can create the child records.

	If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#NewLeaOrganization '))
	Begin
		Drop Table #NewLeaOrganization
	End

	CREATE TABLE #NewLeaOrganization (
		  OrganizationId INT
		, LEA_Identifier_State VARCHAR(100)
		, DataCollectionId INT NULL
		, SchoolYear VARCHAR(100)
	)
	CREATE UNIQUE CLUSTERED INDEX Tmp_NewLeaOrganization ON #NewLeaOrganization(OrganizationId,DataCollectionId)

	BEGIN TRY
		MERGE dbo.Organization AS TARGET
		USING #DistinctNewLeas AS SOURCE 
			ON 1 = 0 -- always insert 
		WHEN NOT MATCHED THEN 
			INSERT (DataCollectionId) VALUES (Source.DataCollectionId)
		OUTPUT 
			  INSERTED.OrganizationId
			, SOURCE.LEA_Identifier_State
			, SOURCE.DataCollectionId
			, SOURCE.SchoolYear
		INTO #NewLeaOrganization;
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Organization', NULL, 'S01EC0190'
	END CATCH

	BEGIN TRY
		UPDATE Staging.K12Organization
		SET   OrganizationId_LEA = norg.OrganizationId
			, NewLea = 1
			--, DataCollectionId = norg.DataCollectionId --Changed|TODO: This is already set, no need to set it again.
		FROM Staging.K12Organization o
		JOIN #NewLeaOrganization norg 
			ON o.LEA_Identifier_State = norg.LEA_Identifier_State 
			and ISNULL(o.DataCollectionId, '') = ISNULL(norg.DataCollectionId, '')
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationId_LEA', 'S01EC0200'
	END CATCH

	BEGIN TRY
		UPDATE #DistinctNewLeas
		SET OrganizationId = o.OrganizationId_LEA
		FROM Staging.K12Organization o
		JOIN #DistinctNewLeas norg
			ON o.Lea_Identifier_State = norg.Lea_Identifier_State 
			and ISNULL(o.DataCollectionId, '') = ISNULL(norg.DataCollectionId, '')
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '#DistinctNewLeas', 'OrganizationId', 'S01EC0210'
	END CATCH

	BEGIN TRY
		--Update LEA names by end dating the 
		--current OrganizationDetail record and creating a new one
		UPDATE dbo.OrganizationDetail
		SET 
			  RecordEndDateTime = o.LEA_RecordEndDateTime
			, [Name] = o.Lea_Name
		FROM Staging.K12Organization o
		JOIN dbo.OrganizationDetail od
			ON o.OrganizationId_LEA = od.OrganizationId
			AND o.Lea_Name <> od.[Name]
			AND od.RecordEndDateTime IS NULL
			AND CONVERT(DATE, od.RecordStartDateTime) = CONVERT(DATE, o.LEA_RecordStartDateTime)
			AND ISNULL(o.DataCollectionId, '') = ISNULL(od.DataCollectionId, '')
		WHERE o.LEA_Identifier_State IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', 'RecordEndDateTime', 'S01EC0220'
	END CATCH

	
	---Insert the new LEA OrganizationDetail records where there was no existing previous record in the IDS

		--Get a distinct list of LEA Organization Detail records that need to be inserted for the first time
		--so that we can use MERGE properly. This temporary table will exclude records in staging that have the
		--same Organization Detail data as the records that already exist in the ODS, but that have a NULL RecordEndDateTime
		--indicating they are the current record. There is no need to update the current record if the data did not change. 

	DECLARE @DistinctLEAOrganizationDetail TABLE (
		  Organization_Name VARCHAR(100)
		, OrganizationId INT NULL
		, IsReportedFederally BIT
		, RecordStartDateTime DATETIME
		, RecordEndDateTime DATETIME
		, DataCollectionId INT
	)

	BEGIN TRY

		INSERT INTO @DistinctLEAOrganizationDetail
		SELECT DISTINCT
			  org.LEA_Name
			, org.OrganizationId_LEA
			, org.LEA_IsReportedFederally
			, org.LEA_RecordStartDateTime
			, org.LEA_RecordEndDateTime
			, org.DataCollectionId
		FROM Staging.K12Organization org
		WHERE org.LEA_Name IS NOT NULL
			AND org.LEA_RecordStartDateTime IS NOT NULL
			AND org.OrganizationId_LEA IS NOT NULL
			AND NOT EXISTS (SELECT 'x'
							FROM dbo.OrganizationDetail orgd
							WHERE org.LEA_Name = orgd.Name
								AND org.OrganizationId_LEA = orgd.OrganizationId
								AND orgd.RefOrganizationTypeId in (@LEAOrgType, @LEAOrgType_NotFederal)
								AND orgd.RecordEndDateTime IS NULL)
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctLEAOrganizationDetail', NULL, 'S01EC0230'
	END CATCH

	BEGIN TRY

		MERGE dbo.OrganizationDetail AS TARGET
		USING @DistinctLEAOrganizationDetail AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
				AND TARGET.[Name] = SOURCE.Organization_Name
				AND TARGET.RecordStartDateTime = SOURCE.RecordStartDateTime
				AND ISNULL(TARGET.DataCollectionId, '') = ISNULL(SOURCE.DataCollectionId, '')
		--When no records are matched, insert
		--the incoming records from source
		--table to target table

		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (
				  OrganizationId
				, [Name]
				, RefOrganizationTypeId
				, RecordStartDateTime
				, RecordEndDateTime
				, DataCollectionId) 
			VALUES (
				  SOURCE.OrganizationId
				, SOURCE.Organization_Name
				, IIF(SOURCE.IsReportedFederally = 0, @LeaOrgType_NotFederal, @LeaOrgType)
				, SOURCE.RecordStartDateTime
				, SOURCE.RecordEndDateTime
				, SOURCE.DataCollectionId);
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S01EC0240'
	END CATCH

	BEGIN TRY
        UPDATE r SET r.RecordEndDateTime = s.RecordStartDateTime - 1
        FROM dbo.OrganizationDetail r
        JOIN (
                SELECT 
                    OrganizationId
					, MAX(OrganizationDetailId) AS OrganizationDetailId
                    , MAX(RecordStartDateTime) AS RecordStartDateTime
					, DataCollectionId
                FROM dbo.OrganizationDetail
                WHERE RecordEndDateTime IS NULL
					AND RecordStartDateTime IS NOT NULL
					AND RefOrganizationTypeId in (@LeaOrgType, @LeaOrgType_NotFederal)
                GROUP BY OrganizationId, OrganizationDetailId, RecordStartDateTime, DataCollectionId
        ) s ON r.OrganizationId = s.OrganizationId
                AND r.OrganizationDetailId <> s.OrganizationDetailId 
                AND r.RecordEndDateTime IS NULL
				AND r.RecordStartDateTime IS NOT NULL
				AND r.RecordStartDateTime < s.RecordStartDateTime
				AND ISNULL(r.DataCollectionId, '') = ISNULL(s.DataCollectionId, '')
		WHERE r.RefOrganizationTypeId in (@LeaOrgType, @LeaOrgType_NotFederal)
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', 'RecordEndDateTime', 'S01EC0250'
	END CATCH

	BEGIN TRY
		INSERT INTO [dbo].[OrganizationIdentifier]
						([Identifier]
						,[RefOrganizationIdentificationSystemId]
						,[OrganizationId]
						,[DataCollectionId]
						,[RefOrganizationIdentifierTypeId]
						,[RecordStartDateTime]
						,[RecordEndDateTime])
		SELECT DISTINCT
					tod.LEA_Identifier_State_Identifier_Old [Identifier]
					,@LeaIdSystem AS [RefOrganizationIdentificationSystemId]
					,orgd.OrganizationId [OrganizationId]
					,tod.DataCollectionId
					,@LeaIdType as [RefOrganizationIdentifierTypeId]
					,tod.LEA_RecordStartDateTime
					,tod.LEA_RecordEndDateTime
		FROM dbo.OrganizationDetail orgd
		JOIN Staging.K12Organization tod 
			ON orgd.OrganizationId = tod.OrganizationId_LEA 
			and ISNULL(orgd.DataCollectionId, '') = ISNULL(tod.DataCollectionId, '')
		WHERE tod.LEA_Identifier_State_ChangedIdentifier = 1
		AND LEA_Identifier_State_Identifier_Old IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', 'RecordEndDateTime', 'S01EC0250'
	END CATCH


	--Insert K12 Schools into dbo.Organization--

	If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#NewOrganization '))
	Begin
		Drop Table #NewOrganization 
	End
	
	CREATE TABLE #NewOrganization (
		  OrganizationId INT
		, SourceId INT
		, DataCollectionId INT
		, SchoolYear VARCHAR(50)
	)
	CREATE UNIQUE CLUSTERED INDEX Tmp_NewOrganization ON #NewOrganization(OrganizationId,DataCollectionId)

	BEGIN TRY
		MERGE dbo.Organization AS TARGET  --Changed|TODO: Add DataCollectionId into this MERGE statement
		USING Staging.K12Organization AS SOURCE 
			ON SOURCE.OrganizationId_School = TARGET.OrganizationId
			AND ISNULL(SOURCE.DataCollectionId, '') = ISNULL(TARGET.DataCollectionId, '')
		--AND SOURCE.SchoolYear = @SchoolYear --Changed|TODO: Need to test if this works?!?!  -Nathan: It should, but we should add these checks to ALL statements if we're going to use it.
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED AND SOURCE.School_Name IS NOT NULL THEN 
			INSERT (DataCollectionId) VALUES (Source.DataCollectionId)
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.Id AS SourceId
			, SOURCE.DataCollectionId
			, SOURCE.SchoolYear
		INTO #NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Organization', NULL, 'S01EC0250'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.K12Organization 
		SET OrganizationId_School = norg.OrganizationId
		FROM Staging.K12Organization o
		JOIN #NewOrganization norg  
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationId_School', 'STEC0260'
	END CATCH
	
	BEGIN TRY
		--Update School names by end dating the 
		--current OrganizationDetail record and creating a new one
		UPDATE dbo.OrganizationDetail
		SET RecordEndDateTime = o.School_RecordEndDateTime
		FROM Staging.K12Organization o
		JOIN dbo.OrganizationDetail od  
			ON o.OrganizationId_School = od.OrganizationId
			AND ISNULL(o.DataCollectionId, '') = ISNULL(od.DataCollectionId, '')
			AND o.School_Name <> od.[Name]
			AND od.RecordEndDateTime IS NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', 'RecordEndDateTime', 'S01EC0270'
	END CATCH

	BEGIN TRY
		INSERT INTO dbo.OrganizationDetail ([OrganizationId], [Name], [RefOrganizationTypeId]
		,[RecordStartDateTime], [RecordEndDateTime])
		--Changed|TODO: Add DataCollectionId into this INSERT statement
		SELECT 
			  o.OrganizationId_School
			, o.School_Name
			, IIF(o.School_IsReportedFederally = 0, @SchoolOrgType_NotFederal, @SchoolOrgType)
			, o.School_RecordStartDateTime
			, o.School_RecordEndDateTime
		FROM Staging.K12Organization o
		JOIN dbo.OrganizationDetail od
			ON o.OrganizationId_School = od.OrganizationId
			AND ISNULL(o.DataCollectionId, '') = ISNULL(od.DataCollectionId, '')
			AND o.School_Name <> od.[Name]
			AND od.RecordEndDateTime = @UpdateDateTime
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S01EC0280'
	END CATCH

	BEGIN TRY
		MERGE dbo.OrganizationDetail AS TARGET
		USING Staging.K12Organization AS SOURCE 
			ON SOURCE.OrganizationId_School = TARGET.OrganizationId
			AND ISNULL(SOURCE.DataCollectionId, '') = ISNULL(TARGET.DataCollectionId, '')
		--AND SOURCE.SchoolYear = @SchoolYear --Changed|TODO: Need to test if this works?!?! May not need it (Nathan: It doesn't add anything other than allow us to run 1 year at a time), OrganizationId should take care of correct join
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED AND Source.OrganizationId_School IS NOT NULL THEN --Changed|TODO: Add DataCollectionId into this MERGE statement
			INSERT (
				  OrganizationId
				, [Name]
				, RefOrganizationTypeId
				, RecordStartDateTime
				, RecordEndDateTime
				, DataCollectionId) 
			VALUES (
				  SOURCE.OrganizationId_School
				, SOURCE.School_Name
				, IIF(SOURCE.School_IsReportedFederally = 0, @SchoolOrgType_NotFederal, @SchoolOrgType)
				, SOURCE.School_RecordStartDateTime
				, SOURCE.School_RecordEndDateTime
				,SOURCE.DataCollectionId);
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S01EC0290'
	END CATCH

	----------------------------------------------------------------------
	--INSERT State/IEU/LEA/K12 School into dbo.OrganizationIdentifier---------
	----------------------------------------------------------------------

	BEGIN TRY 
		--Insert IEU State ID into dbo.OrganizationIdentifier--
		INSERT INTO [dbo].[OrganizationIdentifier]
				   ([Identifier]
				   ,[RefOrganizationIdentificationSystemId]
				   ,[OrganizationId]
				   ,[RefOrganizationIdentifierTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime]
				   ,[DataCollectionId])
				   --Here we will want to add the RecordStartDateTime and make it the beginning of the fiscal year each time
				   --It will only add it if it doesn't already exist, so it will be done yearly
		SELECT DISTINCT
					tod.IEU_Identifier_State [Identifier]
				   ,@IeuIdSystem AS [RefOrganizationIdentificationSystemId] 
				   ,tod.OrganizationId_IEU [OrganizationId]
				   ,@IeuIdType AS [RefOrganizationIdentifierTypeId]
				   ,tod.IEU_RecordStartDateTime
				   ,tod.IEU_RecordEndDateTime
				   ,tod.DataCollectionId 
		FROM Staging.K12Organization tod
		LEFT JOIN dbo.OrganizationIdentifier orgid
			ON tod.IEU_Identifier_State = orgid.Identifier
			AND orgid.RefOrganizationIdentificationSystemId = @IeuIdSystem
			AND orgid.RefOrganizationIdentifierTypeId = @IeuIdType 
			AND orgid.OrganizationId = tod.OrganizationId_IEU
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
		WHERE tod.IEU_Identifier_State <> ''
			AND tod.IEU_Identifier_State IS NOT NULL
			AND orgid.OrganizationId IS NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationIdentifier', NULL, 'S01EC1270'
	END CATCH


	BEGIN TRY 
		--Insert LEA NCES ID into dbo.OrganizationIdentifier--
		INSERT INTO [dbo].[OrganizationIdentifier]
				   ([Identifier]
				   ,[RefOrganizationIdentificationSystemId]
				   ,[OrganizationId]
				   ,[RefOrganizationIdentifierTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime]
				   ,[DataCollectionId])
				   --Here we will want to add the RecordStartDateTime and make it the beginning of the fiscal year each time
				   --It will only add it if it doesn't already exist, so it will be done yearly
		SELECT DISTINCT
					tod.LEA_Identifier_NCES [Identifier]
				   ,@LeaNcesIdSystem AS [RefOrganizationIdentificationSystemId] 
				   ,tod.OrganizationId_LEA [OrganizationId]
				   ,@LeaIdType AS [RefOrganizationIdentifierTypeId]
				   ,tod.LEA_RecordStartDateTime
				   ,tod.LEA_RecordEndDateTime
				   ,tod.DataCollectionId 
		FROM Staging.K12Organization tod
		LEFT JOIN dbo.OrganizationIdentifier orgid
			ON tod.LEA_Identifier_NCES = orgid.Identifier
			AND orgid.RefOrganizationIdentificationSystemId = @LeaNcesIdSystem
			AND orgid.RefOrganizationIdentifierTypeId = @LeaIdType
			AND orgid.OrganizationId = tod.OrganizationId_LEA
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
		WHERE tod.LEA_Identifier_NCES <> ''
			AND tod.LEA_Identifier_NCES IS NOT NULL
			AND orgid.OrganizationId IS NULL
			
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationIdentifier', NULL, 'S01EC1270'
	END CATCH

	BEGIN TRY
		--Insert K12 School NCES ID into dbo.OrganizationIdentifier--
		INSERT INTO [dbo].[OrganizationIdentifier] 
				   ([Identifier]
				   ,[RefOrganizationIdentificationSystemId]
				   ,[OrganizationId]
				   ,[RefOrganizationIdentifierTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime]
				   ,[DataCollectionId])
		SELECT DISTINCT
					tod.School_Identifier_NCES [Identifier]
				   ,@SchoolNcesIdSystem AS [RefOrganizationIdentificationSystemId]
				   ,tod.OrganizationId_School [OrganizationId]
				   ,@SchoolIdType AS [RefOrganizationIdentifierTypeId]
				   ,tod.School_RecordStartDateTime
				   ,tod.School_RecordEndDateTime
				   ,tod.DataCollectionId
		FROM Staging.K12Organization tod
		LEFT JOIN dbo.OrganizationIdentifier orgid
			ON tod.School_Identifier_NCES = orgid.Identifier
			AND orgid.RefOrganizationIdentificationSystemId = @SchoolNcesIdSystem
			AND orgid.RefOrganizationIdentifierTypeId = @SchoolIdType
			AND orgid.OrganizationId = tod.OrganizationId_School
		WHERE tod.School_Identifier_NCES <> ''
			AND tod.School_Identifier_NCES IS NOT NULL
			AND orgid.OrganizationId IS NULL
			
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationIdentifier', NULL, 'S01EC1280'
	END CATCH

	BEGIN TRY
		--Insert LEA State ID into dbo.OrganizationIdentifier--
		INSERT INTO [dbo].[OrganizationIdentifier]
				   ([Identifier]
				   ,[RefOrganizationIdentificationSystemId]
				   ,[OrganizationId]
				   ,[RefOrganizationIdentifierTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime]
				   ,[DataCollectionId])
		SELECT DISTINCT
					tod.LEA_Identifier_State [Identifier]
				   ,@LeaIdSystem AS [RefOrganizationIdentificationSystemId]
				   ,tod.OrganizationId_LEA [OrganizationId]
				   ,@LeaIdType AS [RefOrganizationIdentifierTypeId]
				   ,tod.LEA_RecordStartDateTime
				   ,tod.LEA_RecordEndDateTime
				   ,tod.DataCollectionId
		FROM Staging.K12Organization tod
		LEFT JOIN dbo.OrganizationIdentifier orgid
			ON tod.LEA_Identifier_State = orgid.Identifier
			AND orgid.RefOrganizationIdentificationSystemId = @LeaIdSystem
			AND orgid.RefOrganizationIdentifierTypeId = @LeaIdType
			AND orgid.OrganizationId = tod.OrganizationId_LEA
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
		WHERE tod.LEA_Identifier_State IS NOT NULL
		AND tod.LEA_Identifier_State <> ''
		AND orgid.OrganizationId IS NULL
		
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationIdentifier', NULL, 'S01EC1290'
	END CATCH

	BEGIN TRY
		--Insert K12 School State ID into dbo.OrganizationIdentifier--
		INSERT INTO [dbo].[OrganizationIdentifier]
				   ([Identifier]
				   ,[RefOrganizationIdentificationSystemId]
				   ,[OrganizationId]
				   ,[RefOrganizationIdentifierTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime]
				   ,[DataCollectionId])
		SELECT DISTINCT
					tod.School_Identifier_State [Identifier]
				   ,@SchoolIdSystem AS [RefOrganizationIdentificationSystemId]
				   ,tod.OrganizationId_School [OrganizationId]
				   ,@SchoolIdType AS [RefOrganizationIdentifierTypeId]
				   ,tod.School_RecordStartDateTime
				   ,tod.School_RecordEndDateTime
				   ,tod.DataCollectionId
		FROM Staging.K12Organization tod
		LEFT JOIN dbo.OrganizationIdentifier orgid
			ON tod.School_Identifier_State = orgid.Identifier
			AND orgid.RefOrganizationIdentificationSystemId = @SchoolIdSystem
			AND orgid.RefOrganizationIdentifierTypeId = @SchoolIdType
			AND orgid.OrganizationId = tod.OrganizationId_School
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
		WHERE tod.School_Identifier_State IS NOT NULL
		AND tod.School_Identifier_State <> ''
		AND tod.OrganizationId_School IS NOT NULL
		AND orgid.OrganizationId IS NULL
		
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationIdentifier', NULL, 'S01EC1300'
	END CATCH

	BEGIN TRY
		--Insert K12 School Federal (Tax) ID into dbo.OrganizationIdentifier--
		INSERT INTO [dbo].[OrganizationIdentifier]
				   ([Identifier]
				   ,[RefOrganizationIdentificationSystemId]
				   ,[OrganizationId]
				   ,[RefOrganizationIdentifierTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime]
				   ,[DataCollectionId])
		SELECT DISTINCT
					tod.School_CharterSchoolFEIN [Identifier]
				   ,@SchoolFeinIdSystem AS [RefOrganizationIdentificationSystemId]
				   ,tod.OrganizationId_School [OrganizationId]
				   ,@SchoolIdType AS [RefOrganizationIdentifierTypeId]
				   ,tod.School_RecordStartDateTime
				   ,tod.School_RecordEndDateTime
				   ,tod.DataCollectionId
		FROM Staging.K12Organization tod
		LEFT JOIN dbo.OrganizationIdentifier orgid
			ON tod.School_Identifier_State = orgid.Identifier
			AND orgid.RefOrganizationIdentificationSystemId = @SchoolFeinIdSystem
			AND orgid.RefOrganizationIdentifierTypeId = @SchoolIdType
			AND orgid.OrganizationId = tod.OrganizationId_School
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
		WHERE tod.School_CharterSchoolFEIN IS NOT NULL
		AND tod.School_CharterSchoolFEIN <> ''
		AND orgid.OrganizationId IS NULL
		
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationIdentifier', NULL, 'S01EC1310'
	END CATCH

	
		
	--Insert LEA/K12/SEA relationships into dbo.OrganizationRelationiship---------

	BEGIN TRY
	--Setting OrganizationRelationshipId_IEUToLEA
		UPDATE Staging.K12Organization
		SET OrganizationRelationshipId_IEUToLEA = orgr.OrganizationRelationshipId
		FROM Staging.K12Organization tod
		JOIN dbo.OrganizationRelationship orgr 
			ON tod.OrganizationId_IEU = orgr.Parent_OrganizationId
				and ISNULL(tod.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
		WHERE tod.OrganizationId_LEA = orgr.OrganizationId 
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationRelationshipId_IEUToLEA', 'S01EC-IEU2LEARel'
	END CATCH

	BEGIN TRY
	--Setting SEAToIEU_OrganizationRelationshipId
		UPDATE Staging.K12Organization
		SET OrganizationRelationshipId_SEAToIEU = orgr.OrganizationRelationshipId
		FROM Staging.K12Organization tod
		JOIN dbo.OrganizationRelationship orgr 
			ON tod.OrganizationId_SEA = orgr.Parent_OrganizationId
				and ISNULL(tod.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
		WHERE tod.OrganizationId_IEU = orgr.OrganizationId 
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'SEAToIEU_OrganizationRelationshipId', 'S01EC-SEA2IEURel'
	END CATCH


	BEGIN TRY
		--First check to see if the relationship already exists and put the OrganizationRelationshipId back into the temp table
		UPDATE Staging.K12Organization
		SET OrganizationRelationshipId_SEAToLEA = orgr.OrganizationRelationshipId
		FROM Staging.K12Organization tod
		JOIN dbo.OrganizationRelationship orgr 
			ON tod.OrganizationId_SEA = orgr.Parent_OrganizationId
				and ISNULL(tod.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
		WHERE tod.OrganizationId_LEA = orgr.OrganizationId 
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationRelationshipId_SEAToLEA', 'S01EC1320'
	END CATCH

	BEGIN TRY
		UPDATE Staging.K12Organization
		SET OrganizationRelationshipId_LEAToSchool = orgr.OrganizationRelationshipId
		FROM Staging.K12Organization tod
		JOIN dbo.OrganizationRelationship orgr 
			ON tod.OrganizationId_LEA = orgr.Parent_OrganizationId
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
		WHERE tod.OrganizationId_School = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationRelationshipId_LEAToSchool', 'S01EC1330'
	END CATCH

	--Added|TODO: Copy & paste the INSERT INTO dbo.OrganizationRelationship code below to create the link between an SEA & IEU

	BEGIN TRY
		--Create relationship SEA and IEU--
		INSERT INTO [dbo].[OrganizationRelationship]
					([Parent_OrganizationId]
					,[OrganizationId]
					,[RefOrganizationRelationshipId]
					,[DataCollectionId])
		SELECT DISTINCT
					sd.OrganizationId [Parent_OrganizationId]
					,tod.OrganizationId_IEU [OrganizationId]
					,NULL [RefOrganizationRelationshipId]
					,tod.DataCollectionId
		FROM Staging.K12Organization tod
		CROSS JOIN Staging.StateDetail sd
		WHERE tod.OrganizationRelationshipId_SEAToIEU IS NULL
		AND ISNULL(tod.DataCollectionId, '') = ISNULL(sd.DataCollectionId, '')
		AND OrganizationId_IEU IS NOT NULL
	 
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationRelationship', NULL, 'S01EC-SEA2IEUIns'
	END CATCH

	BEGIN TRY
		UPDATE Staging.K12Organization
		SET OrganizationRelationshipId_SEAToIEU = orgr.OrganizationRelationshipId
		FROM Staging.K12Organization tod
		JOIN dbo.OrganizationRelationship orgr ON tod.OrganizationId_SEA = orgr.Parent_OrganizationId
			and ISNULL(tod.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
		WHERE tod.OrganizationId_IEU = orgr.OrganizationId
		AND tod.OrganizationRelationshipId_SEAToIEU IS NULL
		
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'SEAToIEU_OrganizationRelationshipId', 'S01EC-SEA2IEUUpd'
	END CATCH

	
	BEGIN TRY
		--Create relationship IEU and LEA--
		INSERT INTO [dbo].[OrganizationRelationship]
					([Parent_OrganizationId]
					,[OrganizationId]
					,[RefOrganizationRelationshipId]
					,[DataCollectionId])
		SELECT DISTINCT
					tod.OrganizationId_IEU [Parent_OrganizationId]
					,tod.OrganizationId_LEA [OrganizationId]
					,NULL [RefOrganizationRelationshipId]
					,tod.DataCollectionId
		FROM Staging.K12Organization tod
		WHERE tod.OrganizationRelationshipId_IEUToLEA IS NULL
		AND tod.OrganizationId_IEU IS NOT NULL
		AND tod.OrganizationId_LEA IS NOT NULL
	 
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationRelationship', NULL, 'S01EC-IEU2LEAIns'
	END CATCH

	BEGIN TRY
		UPDATE Staging.K12Organization
		SET OrganizationRelationshipId_IEUToLEA = orgr.OrganizationRelationshipId
		FROM Staging.K12Organization tod
		JOIN dbo.OrganizationRelationship orgr ON tod.OrganizationId_IEU = orgr.Parent_OrganizationId
			and ISNULL(tod.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
		WHERE tod.OrganizationId_LEA = orgr.OrganizationId
		AND tod.OrganizationRelationshipId_IEUToLEA IS NULL
		
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'SEAToIEU_OrganizationRelationshipId', 'S01EC-IEU2LEAUpd'
	END CATCH

	
	
	BEGIN TRY
		--Create relationship between SEA and LEA--
		INSERT INTO [dbo].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId]
				   ,[DataCollectionId])
		SELECT DISTINCT
					sd.OrganizationId [Parent_OrganizationId]
				   ,tod.OrganizationId_LEA [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
				   ,tod.DataCollectionId
		FROM Staging.K12Organization tod
		CROSS JOIN Staging.StateDetail sd
		WHERE tod.OrganizationRelationshipId_SEAToLEA IS NULL
		AND ISNULL(tod.DataCollectionId, '') = ISNULL(sd.DataCollectionId, '')
		AND tod.OrganizationId_LEA IS NOT NULL
		 
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationRelationship', NULL, 'S01EC1440'
	END CATCH

	BEGIN TRY
		UPDATE Staging.K12Organization
		SET OrganizationRelationshipId_SEAToLEA = orgr.OrganizationRelationshipId
		FROM Staging.K12Organization tod
		JOIN dbo.OrganizationRelationship orgr ON tod.OrganizationId_SEA = orgr.Parent_OrganizationId
			and ISNULL(tod.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
		WHERE tod.OrganizationId_LEA = orgr.OrganizationId
		AND tod.OrganizationRelationshipId_SEAToLEA IS NULL
		
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationRelationshipId_SEAToLEA', 'S01EC1450'
	END CATCH

	BEGIN TRY
		--Create relationship between SEA and LEA--
		INSERT INTO [dbo].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId]
				   ,[DataCollectionId])
		SELECT DISTINCT
					sd.OrganizationId [Parent_OrganizationId]
				   ,tod.OrganizationId_LEA [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
				   ,sd.DataCollectionId
		FROM Staging.K12Organization tod
		CROSS JOIN Staging.StateDetail sd
		WHERE tod.OrganizationRelationshipId_SEAToLEA IS NULL
		AND ISNULL(tod.DataCollectionId, '') = ISNULL(sd.DataCollectionId, '')
		AND tod.OrganizationId_LEA IS NOT NULL
		 
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationRelationship', NULL, 'S01EC1440'
	END CATCH

	BEGIN TRY
		UPDATE Staging.K12Organization
		SET OrganizationRelationshipId_SEAToLEA = orgr.OrganizationRelationshipId
		FROM Staging.K12Organization tod
		JOIN dbo.OrganizationRelationship orgr ON tod.OrganizationId_SEA = orgr.Parent_OrganizationId
			and ISNULL(tod.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
		WHERE tod.OrganizationId_LEA = orgr.OrganizationId
		AND tod.OrganizationRelationshipId_SEAToLEA IS NULL
		
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationRelationshipId_SEAToLEA', 'S01EC1450'
	END CATCH


	--Create relationship between LEA and K12 School--

	BEGIN TRY
		INSERT INTO [dbo].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId],
				   [DataCollectionId])
		SELECT DISTINCT
					tod.OrganizationId_LEA [Parent_OrganizationId]
				   ,tod.OrganizationId_School [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
				   ,tod.DataCollectionId
		FROM Staging.K12Organization tod
		WHERE tod.OrganizationRelationshipId_LEAToSchool IS NULL
		AND tod.School_Name IS NOT NULL
		AND tod.OrganizationId_LEA IS NOT NULL
		AND tod.OrganizationId_School IS NOT NULL

		
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationRelationship', NULL, 'S01EC1460'
	END CATCH

	BEGIN TRY
		UPDATE Staging.K12Organization
		SET OrganizationRelationshipId_LEAToSchool = orgr.OrganizationRelationshipId
		FROM Staging.K12Organization tod
		JOIN dbo.OrganizationRelationship orgr ON tod.OrganizationId_LEA = orgr.Parent_OrganizationId
			and ISNULL(tod.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
		WHERE tod.OrganizationId_School = orgr.OrganizationId
		AND tod.OrganizationRelationshipId_LEAToSchool IS NULL
		
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationRelationshipId_LEAToSchool', 'S01EC1470'
	END CATCH

	--Create relationship between LEA and K12 School--

	BEGIN TRY

		INSERT INTO [dbo].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId],
				   [DataCollectionId])
		SELECT DISTINCT
					tod.OrganizationId_IEU [Parent_OrganizationId]
				   ,tod.OrganizationId_School [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
				   ,tod.DataCollectionId
		FROM Staging.K12Organization tod
		WHERE 
		--tod.IEUToSchool_OrganizationRelationshipId IS NULL AND 
		tod.School_Name IS NOT NULL
		AND tod.OrganizationId_IEU IS NOT NULL
		AND tod.OrganizationId_LEA IS NULL
		AND tod.OrganizationId_School IS NOT NULL
		
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationRelationship', NULL, 'S01EC1460'
	END CATCH

	--BEGIN TRY
	--	UPDATE Staging.K12Organization
	--	SET IEUToSchool_OrganizationRelationshipId = orgr.OrganizationRelationshipId
	--	FROM Staging.K12Organization tod
	--	JOIN dbo.OrganizationRelationship orgr 
	--	ON tod.OrganizationId_IEU = orgr.Parent_OrganizationId
	--		and tod.DataCollectionId = orgr.DataCollectionId
	--	WHERE tod.OrganizationId_School = orgr.OrganizationId
	--	AND tod.OrganizationRelationshipId_LEAToSchool IS NULL
		
	--END TRY

	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationRelationshipId_LEAToSchool', 'S01EC1470'
	--END CATCH
	

	BEGIN TRY
		--Update the smaller temporary tables to contain the OrganizationId
		--Need to move this down below where we add the school or they won't have IDs yet.
		UPDATE Staging.OrganizationAddress --Changed|TODO: Add DataCollectionId to JOIN and WHERE clauses
		SET OrganizationId = oi.OrganizationId
		FROM Staging.StateDetail oi
		JOIN Staging.OrganizationAddress toda 
			ON oi.SeaStateIdentifier = toda.OrganizationIdentifier
		JOIN [Staging].[SourceSystemReferenceData] osss
			ON toda.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = oi.SchoolYear
		JOIN dbo.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN dbo.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId = @SeaOrgType
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'OrganizationId', 'S01EC1730'
	END CATCH

	BEGIN TRY
		UPDATE Staging.OrganizationAddress
		SET OrganizationId = tod.OrganizationId_LEA
		FROM Staging.K12Organization tod
		JOIN Staging.OrganizationAddress toda 
			ON tod.LEA_Identifier_State = toda.OrganizationIdentifier
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(toda.DataCollectionId, '')
		JOIN [Staging].[SourceSystemReferenceData] osss
			ON toda.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = toda.SchoolYear
		JOIN dbo.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN dbo.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId = @LeaOrgType
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'OrganizationId', 'S01EC1740'
	END CATCH

	BEGIN TRY
		UPDATE Staging.OrganizationAddress
		SET OrganizationId = tod.OrganizationId_School
		FROM Staging.K12Organization tod
		JOIN Staging.OrganizationAddress toda 
			ON tod.School_Identifier_State = toda.OrganizationIdentifier
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(toda.DataCollectionId, '')
		JOIN [Staging].[SourceSystemReferenceData] osss
			ON toda.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = toda.SchoolYear
		JOIN dbo.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN dbo.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId = @SchoolOrgType
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'OrganizationId', 'S01EC1750'
	END CATCH

	
	-------------------------------------------------
	----Telephone Information -----------------------
	-------------------------------------------------

	--SEA Level
	BEGIN TRY
		UPDATE Staging.OrganizationPhone --Defer|TODO: Add DataCollectionId
		SET OrganizationId = sd.OrganizationId
		FROM Staging.StateDetail sd
		JOIN Staging.OrganizationPhone todp  --Changed|TODO: Add DataCollectionId
			ON sd.SeaStateIdentifier = todp.OrganizationIdentifier
		JOIN [Staging].[SourceSystemReferenceData] osss
			ON todp.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = todp.SchoolYear
		JOIN dbo.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN dbo.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId = @SeaOrgType
	END TRY


	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationPhone', 'OrganizationId', 'S01EC1760'
	END CATCH

	BEGIN TRY
		UPDATE Staging.OrganizationPhone
		SET OrganizationId = tod.OrganizationId_IEU
		FROM Staging.K12Organization tod
		JOIN Staging.OrganizationPhone todp
			ON tod.IEU_Identifier_State = todp.OrganizationIdentifier
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(todp.DataCollectionId, '')
		JOIN [Staging].[SourceSystemReferenceData] osss
			ON todp.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = todp.SchoolYear
		JOIN dbo.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN dbo.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId = @IeuOrgType
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationPhone', 'OrganizationId', 'S01EC1770'
	END CATCH

	--LEA Level
	BEGIN TRY
		UPDATE Staging.OrganizationPhone
		SET OrganizationId = tod.OrganizationId_LEA
		FROM Staging.K12Organization tod
		JOIN Staging.OrganizationPhone todp
			ON tod.LEA_Identifier_State = todp.OrganizationIdentifier
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(todp.DataCollectionId, '')
		JOIN [Staging].[SourceSystemReferenceData] osss
			ON todp.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = todp.SchoolYear
		JOIN dbo.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN dbo.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId = @LeaOrgType
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationPhone', 'OrganizationId', 'S01EC1780'
	END CATCH

	BEGIN TRY
		UPDATE Staging.OrganizationPhone
		SET OrganizationId = tod.OrganizationId_School
		FROM Staging.K12Organization tod
		JOIN Staging.OrganizationPhone todp
			ON tod.School_Identifier_State = todp.OrganizationIdentifier
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(todp.DataCollectionId, '')
		JOIN [Staging].[SourceSystemReferenceData] osss
			ON todp.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = todp.SchoolYear
		JOIN dbo.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN dbo.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId = @SchoolOrgType
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationPhone', 'OrganizationId', 'S01EC1790'
	END CATCH

	-------------------------------------------------------------------
	----Create OrganizationTelephone ----------------------------------
	-------------------------------------------------------------------

	--Update the OrganizationPhone records that need to be corrected.

	BEGIN TRY

		UPDATE dbo.OrganizationTelephone
		SET TelephoneNumber = orgp.TelephoneNumber, RefInstitutionTelephoneTypeId = ritt.RefInstitutionTelephoneTypeId, RecordEndDateTime = orgp.RecordEndDateTime
		FROM dbo.OrganizationTelephone orgt
		JOIN Staging.OrganizationPhone orgp
			ON orgt.OrganizationId = orgp.OrganizationId
			AND orgt.RecordStartDateTime = orgp.RecordStartDateTime
		JOIN Staging.SourceSystemReferenceData ssrd
			ON orgp.InstitutionTelephoneNumberType = ssrd.InputCode
			AND ssrd.TableName = 'RefInstitutionTelephoneType'
			AND ssrd.SchoolYear = @SchoolYear
		JOIN dbo.RefInstitutionTelephoneType ritt
			ON ssrd.OutputCode = ritt.Code
		WHERE orgp.OrganizationId IS NOT NULL
			AND orgp.TelephoneNumber IS NOT NULL
			AND orgp.InstitutionTelephoneNumberType IS NOT NULL

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationTelephone', 'TelephoneNumber', 'S01EC1800'
	END CATCH

	-------------------------------------------------------------------
	----Create OrganizationTelephone ----------------------------------
	-------------------------------------------------------------------
	BEGIN TRY
		INSERT INTO [dbo].[OrganizationTelephone]
					([OrganizationId]
					,[TelephoneNumber]
					,[PrimaryTelephoneNumberIndicator]
					,[RefInstitutionTelephoneTypeId]
					,[DataCollectionId])
		SELECT DISTINCT 
					 tod.OrganizationId [OrganizationId]
					,tod.TelephoneNumber [TelephoneNumber]
					,0 [PrimaryTelephoneNumberIndicator]
					,ritt.RefInstitutionTelephoneTypeId [RefInstitutionTelephoneTypeId]
					,tod.DataCollectionId
		FROM Staging.OrganizationPhone tod
		JOIN [Staging].[SourceSystemReferenceData] ittss
			ON tod.InstitutionTelephoneNumberType = ittss.InputCode
			AND ittss.TableName = 'RefInstitutionTelephoneType'
			AND ittss.SchoolYear = tod.SchoolYear
		JOIN dbo.RefInstitutionTelephoneType ritt
			ON ittss.OutputCode = ritt.Code
		LEFT JOIN dbo.OrganizationTelephone orgt
			ON tod.OrganizationId = orgt.organizationId
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgt.DataCollectionId, '')
			AND ritt.RefInstitutionTelephoneTypeId = orgt.RefInstitutionTelephoneTypeId
		WHERE orgt.RefInstitutionTelephoneTypeId IS NULL
			AND tod.TelephoneNumber IS NOT NULL
			AND tod.TelephoneNumber <> ''
			AND tod.OrganizationId IS NOT NULL
			--
		--End Date and out of date phone numbers once the RecordStartDateTime and RecordEndDateTime has been added to CEDS
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationTelephone', NULL, 'S01EC1810'
	END CATCH

	--Write the IDS ID values back to the staging tables
	BEGIN TRY
		UPDATE Staging.OrganizationPhone
		SET OrganizationId = sk12o.OrganizationId_LEA
		FROM Staging.K12Organization sk12o
		JOIN Staging.OrganizationPhone sop 
			ON sk12o.LEA_Identifier_State = sop.OrganizationIdentifier
			AND ISNULL(sk12o.DataCollectionId, '') = ISNULL(sop.DataCollectionId, '')
		JOIN Staging.SourceSystemReferenceData osss
			ON sop.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = sop.SchoolYear
		JOIN dbo.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN dbo.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId = @LeaOrgType
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationPhone', 'OrganizationId', 'S01EC1820'
	END CATCH

	BEGIN TRY
		UPDATE Staging.OrganizationPhone
		SET OrganizationId = sk12o.OrganizationId_School
		FROM Staging.K12Organization sk12o
		JOIN Staging.OrganizationPhone sop 
			ON sk12o.LEA_Identifier_State = sop.OrganizationIdentifier
			AND ISNULL(sk12o.DataCollectionId, '') = ISNULL(sop.DataCollectionId, '')
		JOIN Staging.SourceSystemReferenceData osss
			ON sop.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = sop.SchoolYear
		JOIN dbo.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN dbo.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId = @SchoolOrgType
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'OrganizationId', 'S01EC1830'
	END CATCH


	-------------------------------------------------------------------
	----Create OrganizationWebsite ------------------------------------
	-------------------------------------------------------------------

	--Organizaton Website needs its own Primary Key and RecordStartDateTime and RecordEndDateTime

	BEGIN TRY
		--SEA Website
		INSERT INTO [dbo].[OrganizationWebsite]
					([OrganizationId]
					,[Website])
		SELECT DISTINCT
					sd.OrganizationId [OrganizationId]
					,sd.Sea_WebSiteAddress [Website]
		FROM Staging.StateDetail sd
		LEFT JOIN dbo.OrganizationWebsite orgw 
			ON sd.OrganizationId = orgw.OrganizationId
			AND sd.Sea_WebSiteAddress = orgw.Website
		WHERE sd.Sea_WebSiteAddress IS NOT NULL
			AND sd.Sea_WebSiteAddress <> ''
			AND orgw.OrganizationId IS NULL
			AND sd.OrganizationId is not null
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationWebsite', NULL, 'S01EC1900'
	END CATCH

	BEGIN TRY
		--IEU Website
		INSERT INTO [dbo].[OrganizationWebsite] (
			[OrganizationId]
			, [Website]
			, [DataCollectionId]
		)
		SELECT DISTINCT
			tod.OrganizationId_IEU		[OrganizationId]
			, tod.IEU_WebSiteAddress	[Website]
			, tod.DataCollectionId		[DataCollectionId]
		FROM Staging.K12Organization tod
		LEFT JOIN dbo.OrganizationWebsite orgw 
			ON tod.OrganizationId_IEU = orgw.OrganizationId
			AND tod.IEU_WebSiteAddress = orgw.Website
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgw.DataCollectionId, '')
		WHERE tod.IEU_WebSiteAddress IS NOT NULL
			AND tod.IEU_WebSiteAddress <> ''
			AND orgw.OrganizationId IS NULL
			AND tod.OrganizationId_IEU is not null
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationWebsite', NULL, 'S01EC1910'
	END CATCH

	BEGIN TRY
		--LEA Website
		INSERT INTO [dbo].[OrganizationWebsite] (
			[OrganizationId]
			,[Website]
			,[DataCollectionId]
		)
		SELECT DISTINCT
			tod.OrganizationId_LEA		[OrganizationId]
			,tod.LEA_WebSiteAddress		[Website]
			,tod.DataCollectionId		[DataCollectionId]
		FROM Staging.K12Organization tod
		LEFT JOIN dbo.OrganizationWebsite orgw 
			ON tod.OrganizationId_LEA = orgw.OrganizationId
			AND tod.LEA_WebSiteAddress = orgw.Website
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgw.DataCollectionId, '')
		WHERE tod.LEA_WebSiteAddress IS NOT NULL
			AND tod.LEA_WebSiteAddress <> ''
			AND orgw.OrganizationId IS NULL
			AND tod.OrganizationId_LEA is not null
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationWebsite', NULL, 'S01EC1920'
	END CATCH


/* -- Need the OrganizationWebsiteId and RecordStart/EndDateTime
	UPDATE Staging.K12Organization
	SET OrganizationWebsiteId_LEA = orgw.OrganizationWebsiteId
	FROM Staging.K12Organization tod
	WHERE tod.LEA_WebSiteAddress IS NOT NULL
	AND tod.LEA_WebSiteAddress <> ''
	JOIN dbo.OrganizationWebsite orgw ON tod.OrganizationId_LEA = orgw.OrganizationId
	WHERE tod.LEA_WebSiteAddress = orgw.Website

	UPDATE dbo.OrganizationWebsite
	SET RecordEndDateTime = @RecordStartDate
	FROM dbo.OrganizationWebsite orgw
	JOIN dbo.OrganizationDetail orgd ON orgw.OrganizationId = orgd.OrganizationId
	WHERE orgd.RefOrganizationTypeId = @RefOrganizationTypeId_LEA
	AND RecordEndDateTime IS NOT NULL
	AND NOT EXISTS (SELECT 'x' FROM Staging.K12Organization tod 
						WHERE orgw.OrganizationWebsiteId = tod.OrganizationWebsiteId_LEA)
*/						

	BEGIN TRY
		--School Website
		INSERT INTO [dbo].[OrganizationWebsite] (
			[OrganizationId]
			,[Website]
			,[DataCollectionId]
		)
		SELECT DISTINCT
			tod.OrganizationId_School		[OrganizationId]
			,tod.School_WebSiteAddress		[Website]
			,tod.DataCollectionId			[DataCollectionId]
		FROM Staging.K12Organization tod
		LEFT JOIN dbo.OrganizationWebsite orgw 
			ON tod.OrganizationId_School = orgw.OrganizationId
			AND tod.School_WebSiteAddress = orgw.Website
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgw.DataCollectionId, '')
		WHERE tod.School_WebSiteAddress IS NOT NULL
			AND tod.School_WebSiteAddress <> ''
			AND orgw.OrganizationId IS NULL
			AND tod.OrganizationId_School is not null
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationWebsite', NULL, 'S01EC1930'
	END CATCH

/* -- Need the OrganizationWebsiteId and RecordStart/EndDateTime
	UPDATE Staging.K12Organization
	SET OrganizationWebsiteId_School = orgw.OrganizationWebsiteId
	FROM Staging.K12Organization tod
	WHERE tod.School_WebSiteAddress IS NOT NULL
	AND tod.School_WebSiteAddress <> ''
	JOIN dbo.OrganizationWebsite orgw ON tod.OrganizationId_School = orgw.OrganizationId
	WHERE tod.School_WebSiteAddress = orgw.Website

	UPDATE dbo.OrganizationWebsite
	SET RecordEndDateTime = @RecordStartDate
	FROM dbo.OrganizationWebsite orgw
	JOIN dbo.OrganizationDetail orgd ON orgw.OrganizationId = orgd.OrganizationId
	WHERE orgd.RefOrganizationTypeId = @GetOrganizationTypeId('K12School', '001156')
	AND RecordEndDateTime IS NOT NULL
	AND NOT EXISTS (SELECT 'x' FROM Staging.K12Organization tod 
						WHERE orgw.OrganizationWebsiteId = tod.OrganizationWebsiteId_School)
*/	


	--End Date any out of date website addresses once the RecordStartDateTime and RecordEndDateTime has been added to CEDS



	-------------------------------------------------------------------
	----Create OrganizationOperationalStatus --------------------------
	-------------------------------------------------------------------
	BEGIN TRY
		INSERT INTO [dbo].[OrganizationOperationalStatus]
					([OrganizationId]
					,[RefOperationalStatusId]
					,[OperationalStatusEffectiveDate]
					,[DataCollectionId]
					,[RecordStartDateTime])
		SELECT DISTINCT
					 tod.OrganizationId_LEA [OrganizationId]
					,ros.RefOperationalStatusId [RefOperationalStatusId]
					,tod.LEA_OperationalStatusEffectiveDate --@RecordStartDate [OperationalStatusEffectiveDate]
					,tod.DataCollectionId
					,tod.LEA_OperationalStatusEffectiveDate
		FROM Staging.K12Organization tod
		JOIN [Staging].[SourceSystemReferenceData] osss
			ON tod.LEA_OperationalStatus = osss.InputCode
			AND osss.TableName = 'RefOperationalStatus'
			AND osss.TableFilter = '000174'
			AND osss.SchoolYear = tod.SchoolYear
		JOIN dbo.RefOperationalStatus ros
			ON osss.OutputCode = ros.Code
		JOIN dbo.RefOperationalStatusType rost 
			ON osss.TableFilter = rost.Code
			AND ros.RefOperationalStatusTypeId = rost.RefOperationalStatusTypeId
		LEFT JOIN dbo.OrganizationOperationalStatus orgs
			ON tod.OrganizationId_LEA = orgs.OrganizationId
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgs.DataCollectionId, '')
			AND ros.RefOperationalStatusId = orgs.RefOperationalStatusId
			AND Staging.GetFiscalYearStartDate(tod.SchoolYear) = orgs.OperationalStatusEffectiveDate
		WHERE ISNULL(tod.LEA_OperationalStatus, '') <> ''
			AND orgs.OrganizationId IS NULL
			AND tod.LEA_Identifier_State IS NOT NULL
			
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationOperationalStatus', NULL, 'S01EC1940'
	END CATCH

	BEGIN TRY
		INSERT INTO [dbo].[OrganizationOperationalStatus]
					([OrganizationId]
					,[RefOperationalStatusId]
					,[OperationalStatusEffectiveDate]
					,[DataCollectionId]
					,[RecordStartDateTime])
		SELECT DISTINCT
					 tod.OrganizationId_School [OrganizationId]
					,ros.RefOperationalStatusId [RefOperationalStatusId]
					,tod.School_OperationalStatusEffectiveDate [OperationalStatusEffectiveDate]
					,tod.DataCollectionId
					,tod.School_OperationalStatusEffectiveDate
		FROM Staging.K12Organization tod
		JOIN [Staging].[SourceSystemReferenceData] osss --Defer|TODO: Add DataCollectionId
			ON tod.School_OperationalStatus = osss.InputCode
			AND osss.TableName = 'RefOperationalStatus'
			AND osss.TableFilter = '000533'
			AND osss.SchoolYear = tod.SchoolYear
		JOIN dbo.RefOperationalStatus ros
			ON osss.OutputCode = ros.Code
		JOIN dbo.RefOperationalStatusType rost 
			ON osss.TableFilter = rost.Code
			AND ros.RefOperationalStatusTypeId = rost.RefOperationalStatusTypeId
		LEFT JOIN dbo.OrganizationOperationalStatus orgs
			ON tod.OrganizationId_School = orgs.OrganizationId
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(orgs.DataCollectionId, '')
			AND ros.RefOperationalStatusId = orgs.RefOperationalStatusId
			AND tod.School_OperationalStatusEffectiveDate = orgs.OperationalStatusEffectiveDate
		WHERE ISNULL(tod.School_OperationalStatus, '') <> ''
			AND orgs.OrganizationId IS NULL
			AND tod.School_Identifier_State IS NOT NULL
			
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationOperationalStatus', NULL, 'S01EC1950'
	END CATCH

	-------------------------------------------------------------------
	----Create CharterSchoolAuthorizer -----
	-------------------------------------------------------------------

	-- Update Organization Records for Charter Authorizers
	BEGIN TRY
		--Grab the existing OrganizationId for Charter Authorizer organizations that already exist in the ODS.
		UPDATE Staging.CharterSchoolAuthorizer
		SET CharterSchoolAuthorizerOrganizationId = ooi.OrganizationId
		FROM Staging.CharterSchoolAuthorizer AS scsa
		JOIN dbo.OrganizationIdentifier AS ooi
			ON ooi.Identifier = scsa.CharterSchoolAuthorizer_Identifier_State
			AND scsa.CharterSchoolAuthorizerOrganizationId IS NULL
			AND ooi.RefOrganizationIdentificationSystemId = @CharterSchoolAuthorizerIdentificationSystemId
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.CharterSchoolAuthorizer', 'CharterSchoolAuthorizerOrganizationId', 'S01EC1952'
	END CATCH

	DECLARE	@charter_authorizer_xwalk TABLE (
		OrganizationId INT
		, SourceId INT
	);

	BEGIN TRY
		-- Determine if Charter Authorizers are already in the dbo.Organization table. 
		-- If not, add them to the dbo.Organization table and capture the new IDs we created for these records in the IDS.
		MERGE INTO dbo.Organization TARGET
		USING Staging.CharterSchoolAuthorizer AS SOURCE
			ON TARGET.OrganizationId = SOURCE.CharterSchoolAuthorizerOrganizationId
		WHEN NOT MATCHED THEN 
			INSERT DEFAULT VALUES
		OUTPUT INSERTED.OrganizationId
			  ,SOURCE.Id AS SourceId
		INTO @charter_authorizer_xwalk (OrganizationId, SourceId);

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Organization', 'OrganizationId', 'S01EC1954'
	END CATCH

	BEGIN TRY

		-- Update organization IDs in the staging table
		UPDATE Staging.CharterSchoolAuthorizer 
		SET CharterSchoolAuthorizerOrganizationId = xwalk.OrganizationId
		FROM Staging.CharterSchoolAuthorizer AS scsa
		JOIN @charter_authorizer_xwalk AS xwalk
			ON scsa.Id = xwalk.SourceId

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.CharterSchoolAuthorizer', 'CharterSchoolAuthorizerOrganizationId', 'S01EC1956'
	END CATCH

	BEGIN TRY

		;WITH CharterSchoolAuthorizerCTE AS 
		(
			SELECT 
				 scsa.CharterSchoolAuthorizerOrganizationId AS OrganizationId
				,scsa.CharterSchoolAuthorizer_Name AS Name
				,@charterSchoolAuthTypeId AS RefOrganizationTypeId
				,scsa.RecordStartDateTime AS RecordStartDateTime
				,scsa.RecordEndDateTime AS RecordEndDateTime
			FROM Staging.CharterSchoolAuthorizer AS scsa
		)

		MERGE INTO dbo.OrganizationDetail TARGET
		USING CharterSchoolAuthorizerCTE AS SOURCE
			ON TARGET.OrganizationId = SOURCE.OrganizationId
			AND TARGET.RecordStartDateTime  = SOURCE.RecordStartDateTime

		--This is the check to see if any of the fields changed, requiring an update.  It is dependent on the RecordStartDate for the incoming record being
		--     equal to the record that already exists in the IDS.  
		WHEN MATCHED AND (
			ISNULL(TARGET.Name, '') <> ISNULL(SOURCE.Name, '')
			OR ISNULL(TARGET.RecordEndDateTime, '1/1/1900') <> ISNULL(SOURCE.RecordEndDateTime, '1/1/1900') 
			)
			THEN 
				UPDATE SET	TARGET.Name = SOURCE.Name
							,TARGET.RecordEndDateTime = SOURCE.RecordEndDateTime

		--By coding the USING condition on OrganizationId and RecordStartDate we will do an insert if either is true – OrganizationId doesn’t exist (New org) 
		--     or incoming org record already exists in the ODS with a different RecordStartDate (new longitudinal record for an existing org).
		WHEN NOT MATCHED THEN 
		INSERT (
			OrganizationId
			,Name
			,RefOrganizationTypeId
			,RecordStartDateTime
			,RecordEndDateTime
		)
		VALUES (
			SOURCE.OrganizationId
			,SOURCE.Name
			,SOURCE.RefOrganizationTypeId
			,SOURCE.RecordStartDateTime
			,SOURCE.RecordEndDateTime
		);
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S01EC1958'
	END CATCH


	--Find the old dbo.OrganizationDetail record associated with the newly inserted active record and end date the old dbo.OrganizationDetail record.
	--Filter to "Charter School Authorizing Organization" type so we don't modify any records that aren't handled by this Charter Authorizer code.
	BEGIN TRY

		;WITH upd AS
		(
			SELECT ood.OrganizationDetailId, ooi.Identifier, ood.RecordStartDateTime,   
				LEAD (ood.RecordStartDateTime, 1, 0) OVER (PARTITION BY ooi.Identifier ORDER BY ood.RecordStartDateTime ASC) AS OldRecordStartDateTime
			FROM dbo.OrganizationDetail AS ood
			INNER JOIN dbo.OrganizationIdentifier AS ooi
				ON ood.OrganizationId = ooi.OrganizationId
			WHERE ood.RecordEndDateTime IS NULL
			AND RefOrganizationTypeId = @charterSchoolAuthTypeId
		)
		UPDATE ood
		SET RecordEndDateTime = upd.OldRecordStartDateTime -1
		FROM dbo.OrganizationDetail AS ood
		INNER JOIN upd
			ON ood.OrganizationDetailId = upd.OrganizationDetailId
		WHERE upd.OldRecordStartDateTime <> '1900-01-01 00:00:00.000'

	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', 'RecordEndDateTime', 'S01EC1960' 
	END CATCH

	BEGIN TRY

		--Insert Source Identifier into dbo.OrganizationIdentifier
		--Join to the dbo.OrganizationIdentifier table to ensure we're not inserting records that already exist. 
		INSERT INTO dbo.OrganizationIdentifier (
			Identifier
			,RefOrganizationIdentificationSystemId
			,OrganizationId
			,RefOrganizationIdentifierTypeId
			,RecordStartDateTime
			,RecordEndDateTime
		)
		SELECT DISTINCT
			scsa.CharterSchoolAuthorizer_Identifier_State AS Identifier
			,@CharterSchoolAuthorizerIdentificationSystemId AS RefOrganizationIdentificationSystemId
			,scsa.CharterSchoolAuthorizerOrganizationId AS OrganizationId
			,@OrganizationIdentificationSystem AS RefOrganizationIdentifierTypeId
			,scsa.RecordStartDateTime AS RecordStartDateTime
			,scsa.RecordEndDateTime AS RecordEndDateTime
		FROM Staging.CharterSchoolAuthorizer AS scsa
		LEFT JOIN dbo.OrganizationIdentifier AS ooi
			ON ooi.Identifier = scsa.CharterSchoolAuthorizer_Identifier_State
			AND ooi.RefOrganizationIdentificationSystemId = @CharterSchoolAuthorizerIdentificationSystemId
		WHERE ooi.Identifier IS NULL

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationIdentifier', NULL, 'S01EC1962'
	END CATCH

	DECLARE @charter_authorizer_relationship_xwalk TABLE (
		OrganizationId INT
		, SourceId INT
		, RefOrganizationRelationshipId INT
	);

	BEGIN TRY
		--Create relationship between Charter Authorizer and School--
		;WITH SchoolToCharterSchoolAuthorizerCTE AS 
		(
			SELECT	 COALESCE(so_pri.Id, so_sec.Id) AS Id
					,ooi.OrganizationId AS Parent_OrganizationId
					,COALESCE(so_pri.OrganizationId_School, so_sec.OrganizationId_School) AS OrganizationId
					,CASE WHEN so_pri.Id IS NOT NULL THEN @PrimaryAuthorizingBodyOrganizationRelationship 
						  WHEN so_sec.Id IS NOT NULL THEN @SecondaryAuthorizingBodyOrganizationRelationship
					 END AS RefOrganizationRelationshipId
					,COALESCE( so_pri.OrganizationRelationshipId_SchoolToPrimaryCharterSchoolAuthorizer, 
							   so_sec.OrganizationRelationshipId_SchoolToSecondaryCharterSchoolAuthorizer
							  ) AS SchoolToCharterSchoolAuthorizer_OrganizationRelationshipId
			FROM dbo.OrganizationIdentifier AS ooi
			LEFT JOIN Staging.K12Organization AS so_pri 
				ON ooi.Identifier = so_pri.School_CharterPrimaryAuthorizer
			LEFT JOIN Staging.K12Organization AS so_sec 
				ON ooi.Identifier = so_sec.School_CharterSecondaryAuthorizer
			WHERE ooi.RefOrganizationIdentificationSystemId = @CharterSchoolAuthorizerIdentificationSystemId
			AND (so_pri.School_CharterPrimaryAuthorizer IS NOT NULL OR so_sec.School_CharterSecondaryAuthorizer IS NOT NULL)
		)
		
		MERGE INTO dbo.OrganizationRelationship TARGET
		USING SchoolToCharterSchoolAuthorizerCTE AS SOURCE
			ON TARGET.OrganizationRelationshipId = SOURCE.SchoolToCharterSchoolAuthorizer_OrganizationRelationshipId
		WHEN NOT MATCHED AND ISNULL(SOURCE.Parent_OrganizationId, '') <> '' AND ISNULL(SOURCE.OrganizationId,'') <> '' THEN
			INSERT (
				Parent_OrganizationId
				,OrganizationId
				,RefOrganizationRelationshipId
			)
			VALUES (
					SOURCE.Parent_OrganizationId
				,SOURCE.OrganizationId
				,SOURCE.RefOrganizationRelationshipId
			)
		OUTPUT INSERTED.OrganizationRelationshipId
			,SOURCE.Id AS SourceId
			,SOURCE.RefOrganizationRelationshipId
		INTO @charter_authorizer_relationship_xwalk (OrganizationId, SourceId, RefOrganizationRelationshipId);
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationRelationship', NULL, 'S01EC1964'
	END CATCH

	BEGIN TRY
		-- Update relationship IDs in the staging table for the Primary Authorizer
		UPDATE Staging.K12Organization 
		SET OrganizationRelationshipId_SchoolToPrimaryCharterSchoolAuthorizer = xwalk.OrganizationId
		FROM Staging.K12Organization AS so
		JOIN @charter_authorizer_relationship_xwalk AS xwalk
			ON so.Id = xwalk.SourceId
		WHERE xwalk.RefOrganizationRelationshipId = @PrimaryAuthorizingBodyOrganizationRelationship 

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationRelationshipId_SchoolToPrimaryCharterSchoolAuthorizer', 'S01EC1968'
	END CATCH

	BEGIN TRY
		-- Update relationship IDs in the staging table for the Secondary Authorizer
		UPDATE Staging.K12Organization 
		SET OrganizationRelationshipId_SchoolToSecondaryCharterSchoolAuthorizer = xwalk.OrganizationId
		FROM Staging.K12Organization AS so
		JOIN @charter_authorizer_relationship_xwalk AS xwalk
			ON so.Id = xwalk.SourceId
		WHERE xwalk.RefOrganizationRelationshipId = @SecondaryAuthorizingBodyOrganizationRelationship 

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Organization', 'OrganizationRelationshipIdSchoolToSecondaryCharterSchoolAuthorizer', 'S01EC1970'
	END CATCH
	
	BEGIN TRY
	
		WITH CharterSchoolAuthorizerCTE AS 
		(
			SELECT 
				ooi.OrganizationId AS OrganizationId
				,orcsat.RefCharterSchoolAuthorizerTypeId AS RefCharterSchoolAuthorizerTypeId
			FROM Staging.CharterSchoolAuthorizer AS scsa
			JOIN dbo.OrganizationIdentifier AS ooi 
				ON ooi.Identifier = scsa.CharterSchoolAuthorizer_Identifier_State
			JOIN Staging.SourceSystemReferenceData AS ossrd
				ON scsa.CharterSchoolAuthorizerType = ossrd.InputCode
				AND ossrd.TableName = 'RefCharterSchoolAuthorizerType'
				AND ossrd.SchoolYear = @SchoolYear
			JOIN dbo.RefCharterSchoolAuthorizerType AS orcsat 
				ON ossrd.OutputCode = orcsat.Code

		)
		MERGE INTO dbo.K12CharterSchoolAuthorizer TARGET
		USING CharterSchoolAuthorizerCTE AS SOURCE
			ON TARGET.OrganizationId = SOURCE.OrganizationId
		WHEN NOT MATCHED THEN 
		INSERT (
			OrganizationId
			,RefCharterSchoolAuthorizerTypeId
		)
		VALUES (
			SOURCE.OrganizationId
			,SOURCE.RefCharterSchoolAuthorizerTypeId
		);

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12CharterSchoolAuthorizer', NULL, 'S01EC1972'
	END CATCH

	-------------------------------------------------------------------
	----Create K12LEA and K12School -----------------------------------
	-------------------------------------------------------------------
	
	BEGIN TRY
		INSERT INTO [dbo].[K12Lea] (
			[OrganizationId]
			,[RefLeaTypeId]
			,[SupervisoryUnionIdentificationNumber]
			,[RefLEAImprovementStatusId]
			,[RefPublicSchoolChoiceStatusId]
			,[CharterSchoolIndicator]
			,[RefCharterLeaStatusId]
			,[DataCollectionId]
		)
		SELECT DISTINCT
			tod.OrganizationId_LEA							[OrganizationId]
			,rlt.RefLeaTypeId								[RefLeaTypeId]
			,tod.LEA_SupervisoryUnionIdentificationNumber	[SupervisoryUnionIdentificationNumber]
			,NULL											[RefLEAImprovementStatusId]
			,NULL											[RefPublicSchoolChoiceStatusId]
			,tod.LEA_CharterSchoolIndicator					[CharterSchoolIndicator]
			,rlcs.RefCharterLeaStatusId						[RefCharterLeaStatusId]
			,tod.DataCollectionId							[DataCollectionId]
		FROM Staging.K12Organization tod
		LEFT JOIN [Staging].[SourceSystemReferenceData] ssrd_leatype
			ON tod.LEA_Type = ssrd_leatype.InputCode
			AND ssrd_leatype.TableName = 'RefLeaType'
			AND ssrd_leatype.SchoolYear = tod.SchoolYear
		LEFT JOIN dbo.RefLeaType rlt
			ON ssrd_leatype.OutputCode = rlt.Code
		LEFT JOIN [Staging].[SourceSystemReferenceData] ssrd_charterstatus
			ON tod.LEA_CharterLeaStatus = ssrd_charterstatus.InputCode
			AND ssrd_charterstatus.TableName = 'RefCharterLeaStatus'
			AND ssrd_charterstatus.SchoolYear = tod.SchoolYear
		LEFT JOIN dbo.RefCharterLeaStatus rlcs
			ON ssrd_charterstatus.OutputCode = rlcs.Code
		LEFT JOIN dbo.K12Lea kl
			ON tod.OrganizationId_LEA = kl.OrganizationId
			and ISNULL(tod.DataCollectionId, '') = ISNULL(kl.DataCollectionId, '')
		WHERE tod.LEA_Type IS NOT NULL
			AND kl.OrganizationId IS NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12Lea', NULL, 'S01EC1980'
	END CATCH

	BEGIN TRY
		UPDATE Staging.K12Organization
		SET LEA_K12LeaTitleISupportService = k12lea.K12LeaTitleISupportServiceId
		FROM dbo.K12LeaTitleISupportService k12lea
		JOIN Staging.K12Organization org 
			ON org.OrganizationId_LEA = k12lea.OrganizationId
			AND ISNULL(org.DataCollectionId, '') = ISNULL(K12lea.DataCollectionId, '')
	END TRY
	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12LeaTitleISupportService', NULL, 'S01EC1990'
	END CATCH
			
	
	BEGIN TRY
		INSERT dbo.K12LeaTitleISupportService (
			OrganizationId
			,RefK12LeaTitleISupportServiceId
			,RecordStartDateTime
			,RecordEndDateTime
			,DataCollectionId
		)
		SELECT DISTINCT
			org.OrganizationId_LEA
			,ot.RefK12LEATitleISupportServiceId
			,Staging.GetFiscalYearStartDate(org.SchoolYear) as RecordStartDate
			,Staging.GetFiscalYearEndDate(org.SchoolYear) as RecordEndDate
			,org.DataCollectionId
		FROM Staging.K12Organization org
		LEFT JOIN dbo.K12LeaTitleISupportService k12lea 
			ON k12lea.OrganizationId = org.OrganizationId_LEA
			AND ISNULL(k12lea.DataCollectionId, '') = ISNULL(org.DataCollectionId, '')
		LEFT JOIN [Staging].[SourceSystemReferenceData] osss
				ON org.LEA_K12LeaTitleISupportService = osss.InputCode
				AND osss.TableName = 'RefK12LeaTitleISupportService'
				AND osss.SchoolYear = org.SchoolYear
		LEFT JOIN dbo.RefK12LeaTitleISupportService ot 
				ON osss.OutputCode = ot.Code
		WHERE k12lea.OrganizationId IS NULL
			AND ot.RefK12LEATitleISupportServiceId IS NOT NULL
	END TRY
	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12LeaTitleISupportService', NULL, 'S01EC2000'
	END CATCH

	-- K12ProgramOrService LEA level
	-- 1
	BEGIN TRY
		UPDATE Staging.K12Organization
		SET K12ProgramOrServiceId_LEA = k12ps.K12ProgramOrServiceId
		FROM dbo.K12ProgramOrService k12ps
		JOIN Staging.K12Organization org 
			ON org.OrganizationId_LEA = k12ps.OrganizationId
			AND ISNULL(org.DataCollectionId, '') = ISNULL(k12ps.DataCollectionId, '')
	END TRY
	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12ProgramOrService', NULL, 'S01EC2010'
	END CATCH

	-- 2
	BEGIN TRY
		INSERT dbo.K12ProgramOrService (
			OrganizationId
			,RefMepProjectTypeId
			,RefTitleIInstructionalServicesId
			,RefTitleIProgramTypeId
			,RecordStartDateTime
			,RecordEndDateTime
			,DataCollectionId
		)
		SELECT DISTINCT
			org.OrganizationId_LEA
			,remMep.RefMepProjectTypeId
			,ot1.RefTitleIInstructionalServicesId
			,ot2.RefTitleIProgramTypeId
			,Staging.GetFiscalYearStartDate(org.SchoolYear) as RecordStartDate
			,Staging.GetFiscalYearEndDate(org.SchoolYear) as RecordEndDate
			,org.DataCollectionId
		FROM Staging.K12Organization org
		LEFT JOIN dbo.K12ProgramOrService k12lea ON k12lea.OrganizationId = org.OrganizationId_LEA
			AND ISNULL(org.DataCollectionId, '') = ISNULL(k12lea.DataCollectionId, '')
		LEFT JOIN [Staging].[SourceSystemReferenceData] ss1
				ON org.LEA_TitleIinstructionalService = ss1.InputCode
				AND ss1.TableName = 'RefTitleIInstructionalServices'
				AND ss1.SchoolYear = org.SchoolYear
		LEFT JOIN dbo.RefTitleIInstructionalServices ot1 
				ON ss1.OutputCode = ot1.Code
		LEFT JOIN [Staging].[SourceSystemReferenceData] ss2
				ON org.LEA_TitleIProgramType = ss2.InputCode
				AND ss2.TableName = 'RefTitleIProgramType'
				AND ss2.SchoolYear = org.SchoolYear
		LEFT JOIN dbo.RefTitleIProgramType ot2
				ON ss2.OutputCode = ot2.Code
		-- MepProjectType
		LEFT JOIN [Staging].[SourceSystemReferenceData] ssmep
				ON ssmep.InputCode = org.LEA_MepProjectType
				AND ssmep.TableName = 'RefMepProjectType'
				AND ssmep.SchoolYear = org.SchoolYear
		LEFT JOIN dbo.RefMepProjectType remMep
				ON remMep.Code = ssmep.OutputCode 
		WHERE k12lea.OrganizationId IS NOT NULL

	END TRY
	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12ProgramOrService', NULL, 'S01EC2020'
	END CATCH

	-- K12ProgramOrService School level
	-- 1
	BEGIN TRY
		UPDATE Staging.K12Organization
		SET K12ProgramOrServiceId_School = k12ps.K12ProgramOrServiceId
		FROM dbo.K12ProgramOrService k12ps
		JOIN Staging.K12Organization org 
			ON org.OrganizationId_School = k12ps.OrganizationId 
			and ISNULL(K12ps.DataCollectionId, '') = ISNULL(org.DataCollectionId, '')
	END TRY
	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12ProgramOrService', NULL, 'S01EC2030'
	END CATCH

	-- 2
	BEGIN TRY
		INSERT dbo.K12ProgramOrService (
			OrganizationId
			,RefMepProjectTypeId
			,RecordStartDateTime
			,RecordEndDateTime
			,DataCollectionId
		)
		SELECT DISTINCT
			org.OrganizationId_School
			,remMep.RefMepProjectTypeId
			,Staging.GetFiscalYearStartDate(org.SchoolYear) as RecordStartDate
			,Staging.GetFiscalYearEndDate(org.SchoolYear) as RecordEndDate
			,org.DataCollectionId
		FROM Staging.K12Organization org
		LEFT JOIN dbo.K12ProgramOrService k12lea 
			ON k12lea.OrganizationId = org.OrganizationId_School 
			and ISNULL(org.DataCollectionId, '') = ISNULL(k12lea.DataCollectionId, '')
		-- MepProjectType
		LEFT JOIN [Staging].[SourceSystemReferenceData] ssmep
				ON ssmep.InputCode = org.School_MepProjectType
				AND ssmep.TableName = 'RefMepProjectType'
				AND ssmep.SchoolYear = org.SchoolYear
		LEFT JOIN dbo.RefMepProjectType remMep
				ON remMep.Code = ssmep.OutputCode 
		WHERE org.OrganizationId_School IS NOT NULL 
		AND org.School_MepProjectType is NOT NULL

	END TRY
	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12ProgramOrService', NULL, 'S01EC2040'
	END CATCH


	--Need to Add RecordStartDate and RecordEndDateTime to the K12Lea table--
	--AND NOT EXISTS (SELECT 'X' FROM dbo.K12Lea kl WHERE tod.OrganizationId_LEA = kl.OrganizationId
	--												AND kl.RecordStartDateTime = @RecordStartDate
	--												AND kl.RecordEndDateTime = @RecordEndDate)	 
	BEGIN TRY
		INSERT INTO [dbo].[K12School](
			[OrganizationId]
			,[RefSchoolTypeId]
			,[RefSchoolLevelId]
			,[RefAdministrativeFundingControlId]
			,[CharterSchoolIndicator]
			,[RefCharterSchoolTypeId]
			,[RefIncreasedLearningTimeTypeId]
			,[RefStatePovertyDesignationId]
			,[CharterSchoolApprovalYear]
			,[K12CharterSchoolAuthorizerAgencyId]
			,[AccreditationAgencyName]
			,[CharterSchoolOpenEnrollmentIndicator]
			,[CharterSchoolContractApprovalDate]
			,[CharterSchoolContractIdNumber]
			,[CharterSchoolContractRenewalDate]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
			,[DataCollectionId]
		)
		SELECT DISTINCT
			tod.OrganizationId_School [OrganizationId]
			,rst.RefSchoolTypeId [RefSchoolTypeId]
			,NULL [RefSchoolLevelId] --Do we need this?
			,afc.RefAdministrativeFundingControlId [RefAdministrativeFundingControlId]
			,tod.School_CharterSchoolIndicator [CharterSchoolIndicator]
			,NULL [RefCharterSchoolTypeId]
			,NULL [RefIncreasedLearningTimeTypeId]
			,rstpov.RefStatePovertyDesignationId [RefStatePovertyDesignationId]
			,NULL [CharterSchoolApprovalYear]
			,aa.K12CharterSchoolAuthorizerId [K12CharterSchoolAuthorizerId]
			,NULL [AccreditationAgencyName]
			,tod.School_CharterSchoolOpenEnrollmentIndicator	[CharterSchoolOpenEnrollmentIndicator]
			,tod.School_CharterContractApprovalDate [CharterSchoolContractApprovalDate]
			,tod.School_CharterContractIDNumber [CharterSchoolContractIdNumber]
			,tod.School_CharterContractRenewalDate [CharterSchoolContractRenewalDate]
			,Staging.GetFiscalYearStartDate(tod.SchoolYear)
			,Staging.GetFiscalYearEndDate(tod.SchoolYear)
			,tod.DataCollectionId
		FROM Staging.K12Organization tod
		LEFT JOIN [Staging].[SourceSystemReferenceData] stss
			ON tod.School_Type = stss.InputCode
			AND stss.TableName = 'RefSchoolType'
			AND stss.SchoolYear = tod.SchoolYear
		LEFT JOIN dbo.RefSchoolType rst
			ON stss.OutputCode = rst.Code
		-- administrative funding control
		LEFT JOIN [Staging].[SourceSystemReferenceData] stss2
			ON tod.AdministrativeFundingControl = stss2.InputCode
			AND stss2.TableName = 'RefAdministrativeFundingControl'
			AND stss2.SchoolYear = tod.SchoolYear
		LEFT JOIN dbo.RefAdministrativeFundingControl afc
			ON stss2.OutputCode = afc.Code
		LEFT JOIN dbo.K12School ks
			ON tod.OrganizationId_School = ks.OrganizationId
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(ks.DataCollectionId, '')
			AND ks.RecordStartDateTime = Staging.GetFiscalYearStartDate(tod.SchoolYear)
			AND ks.RecordEndDateTime = Staging.GetFiscalYearEndDate(tod.SchoolYear)
		LEFT JOIN dbo.K12CharterSchoolAuthorizer aa
			ON aa.OrganizationId=tod.OrganizationId_School
			AND ISNULL(aa.DataCollectionId, '') = ISNULL(tod.DataCollectionId, '')
		LEFT JOIN dbo.K12CharterSchoolManagementOrganization mo
			ON mo.OrganizationId=tod.OrganizationId_School
			AND ISNULL(mo.DataCollectionId, '') = ISNULL(tod.DataCollectionId, '')
		-- state poverty designation
		LEFT JOIN [Staging].[SourceSystemReferenceData] stsspov
			ON tod.School_StatePovertyDesignation = stsspov.InputCode
			AND stsspov.TableName = 'RefStatePovertyDesignation'
			AND stsspov.SchoolYear = tod.SchoolYear
		LEFT JOIN dbo.RefStatePovertyDesignation rstpov
			ON stsspov.OutputCode = rstpov.Code
		WHERE ks.K12SchoolId IS NULL
			AND tod.School_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12School', NULL, 'S01EC2050'
	END CATCH

	-------------------------------------------------------------------
	----Create Grades Offered - K12School -----
	-------------------------------------------------------------------

	BEGIN TRY
		UPDATE [Staging].[OrganizationGradeOffered]
		SET OrganizationId = oi.OrganizationId
		FROM Staging.OrganizationGradeOffered ogo
		JOIN dbo.OrganizationIdentifier oi
			ON ogo.OrganizationIdentifier = oi.Identifier
			AND ISNULL(ogo.DataCollectionId, '') = ISNULL(oi.DataCollectionId, '')
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationGradeOffered', 'OrganizationId', 'S01EC2060'
	END CATCH

	BEGIN TRY
		INSERT INTO dbo.K12SchoolGradeOffered (
			  K12SchoolId
			, RefGradeLevelId
			, tod.RecordStartDateTime
			, tod.RecordEndDateTime
			, tod.DataCollectionId
			)
		SELECT 
			  sch.K12SchoolId
			, rgl.RefGradeLevelId
			, NULL
			, NULL
			, tod.DataCollectionId
		FROM Staging.OrganizationGradeOffered tod
		JOIN dbo.K12School sch
			ON tod.OrganizationId = sch.OrganizationId
			AND ISNULL(tod.DataCollectionId, '') = ISNULL(sch.DataCollectionId, '')
		JOIN dbo.OrganizationDetail od 
			ON sch.OrganizationId = od.OrganizationId
			AND od.RefOrganizationTypeId = @SchoolOrgType
		JOIN [Staging].[SourceSystemReferenceData] grd
			ON tod.GradeOffered = grd.InputCode
			AND grd.TableName = 'RefGradeLevel'
			AND grd.SchoolYear = tod.SchoolYear
		JOIN dbo.RefGradeLevel rgl 
			ON grd.OutputCode = rgl.Code
		JOIN dbo.RefGradeLevelType rglt 
			ON rgl.RefGradeLevelTypeId = rglt.RefGradeLevelTypeId 
			AND rglt.Code = '000131'
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12SchoolGradeOffered', NULL, 'S01EC2070'
	END CATCH



	---------------------------------------------------------------------
	------Create Location, OrganizationLocation and LocationAddress -----
	---------------------------------------------------------------------

	-----------------------------------------------------------------
	------ Organization Address Information -------------------------
	-----------------------------------------------------------------

	-----Update the OrganizationId on the staging table

	----SEA Level
	--BEGIN TRY
	--	UPDATE Staging.OrganizationAddress
	--	SET OrganizationId = orgid.OrganizationId
	--	FROM Staging.OrganizationAddress soa
	--	JOIN dbo.OrganizationIdentifier orgid
	--		ON soa.OrganizationIdentifier = orgid.Identifier
	--	JOIN dbo.OrganizationDetail orgd
	--		ON orgid.OrganizationId = orgd.OrganizationId
	--	JOIN Staging.SourceSystemReferenceData osss
	--		ON soa.OrganizationType = osss.InputCode
	--		AND osss.TableName = 'RefOrganizationType'
	--		AND osss.TableFilter = '001156'
	--		AND osss.SchoolYear = @SchoolYear
	--	JOIN dbo.RefOrganizationType ot 
	--		ON osss.OutputCode = ot.Code
	--	JOIN dbo.RefOrganizationElementType oet
	--		ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
	--		AND oet.Code = osss.TableFilter
	--	WHERE ot.RefOrganizationTypeId = @OrgTypeId_SEA
	--		AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_State_Fed
	--		AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_State
	--		AND orgd.RefOrganizationTypeId = ot.RefOrganizationTypeId
	--END TRY

	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'OrganizationId', 'S01EC3160'
	--END CATCH

	----LEA Level
	--BEGIN TRY
	--	UPDATE Staging.OrganizationAddress
	--	SET OrganizationId = orgid.OrganizationId
	--	FROM Staging.OrganizationAddress soa
	--	JOIN dbo.OrganizationIdentifier orgid 
	--		ON soa.OrganizationIdentifier = orgid.Identifier
	--	JOIN dbo.OrganizationDetail orgd
	--		ON orgid.OrganizationId = orgd.OrganizationId
	--	JOIN Staging.SourceSystemReferenceData osss
	--		ON soa.OrganizationType = osss.InputCode
	--		AND osss.TableName = 'RefOrganizationType'
	--		AND osss.TableFilter = '001156'
	--		AND osss.SchoolYear = @SchoolYear
	--	JOIN dbo.RefOrganizationType ot 
	--		ON osss.OutputCode = ot.Code
	--	JOIN dbo.RefOrganizationElementType oet
	--		ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
	--		AND oet.Code = osss.TableFilter
	--	WHERE ot.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
	--		AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
	--		AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
	--		AND orgd.RefOrganizationTypeId = ot.RefOrganizationTypeId
	--END TRY

	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'OrganizationId', 'S01EC3170'
	--END CATCH

	----School Level
	--BEGIN TRY
	--	UPDATE Staging.OrganizationAddress
	--	SET OrganizationId = orgid.OrganizationId
	--	FROM Staging.OrganizationAddress soa
	--	JOIN dbo.OrganizationIdentifier orgid 
	--		ON soa.OrganizationIdentifier = orgid.Identifier
	--	JOIN dbo.OrganizationDetail orgd
	--		ON orgid.OrganizationId = orgd.OrganizationId
	--	JOIN Staging.SourceSystemReferenceData osss
	--		ON soa.OrganizationType = osss.InputCode
	--		AND osss.TableName = 'RefOrganizationType'
	--		AND osss.TableFilter = '001156'
	--		AND osss.SchoolYear = @SchoolYear
	--	JOIN dbo.RefOrganizationType ot 
	--		ON osss.OutputCode = ot.Code
	--	JOIN dbo.RefOrganizationElementType oet
	--		ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
	--		AND oet.Code = osss.TableFilter
	--	WHERE ot.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
	--		AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
	--		AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
	--		AND orgd.RefOrganizationTypeId = ot.RefOrganizationTypeId
	--END TRY

	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'OrganizationId', 'S01EC3180'
	--END CATCH

	-----First update the Location Id

	--BEGIN TRY

	--	UPDATE Staging.OrganizationAddress
	--	SET LocationId = orgl.LocationId
	--	FROM Staging.OrganizationAddress soa
	--	JOIN dbo.OrganizationLocation orgl
	--		ON soa.OrganizationId = orgl.OrganizationId
	--		AND soa.RecordStartDateTime = orgl.RecordStartDateTime
	--	JOIN dbo.LocationAddress la
	--		ON orgl.LocationId = la.LocationId
	--	JOIN dbo.RefOrganizationLocationType rolt
	--		ON orgl.RefOrganizationLocationTypeId = rolt.RefOrganizationLocationTypeId
	--	JOIN Staging.SourceSystemReferenceData ossr
	--		ON soa.AddressTypeForOrganization = ossr.InputCode
	--		AND ossr.TableName = 'RefOrganizationLocationType'
	--		AND ossr.SchoolYear = @SchoolYear
	--	WHERE ossr.OutputCode = rolt.Code

	--END TRY

	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'LocationId', 'S01EC3190'
	--END CATCH


	-----Update the LocationAddress where corrections need to be made

	--BEGIN TRY 

	--	UPDATE dbo.LocationAddress
	--	SET   StreetNumberAndName = soa.AddressStreetNumberAndName
	--		, ApartmentRoomOrSuiteNumber = soa.AddressApartmentRoomOrSuite
	--		, City = soa.AddressCity
	--		, RefStateId = ors.RefStateId
	--		, PostalCode = soa.AddressPostalCode
	--	FROM dbo.LocationAddress la
	--	JOIN Staging.OrganizationAddress soa
	--		ON la.LocationId = soa.LocationId
	--	JOIN Staging.SourceSystemReferenceData ossr
	--		ON soa.AddressStateAbbreviation = ossr.InputCode
	--		AND ossr.TableName = 'RefState'
	--		AND ossr.SchoolYear = @SchoolYear
	--	JOIN dbo.RefState ors
	--		ON ossr.OutputCode = ors.Code
	--	WHERE (ISNULL(la.StreetNumberAndName, '') <> ISNULL(soa.AddressStreetNumberAndName, '')
	--			OR ISNULL(la.ApartmentRoomOrSuiteNumber, '') <> ISNULL(soa.AddressApartmentRoomOrSuite, '')
	--			OR ISNULL(la.City, '') <> ISNULL(soa.AddressCity, '')
	--			OR ISNULL(la.RefStateId, '99') <> ISNULL([App].[GetRefStateId](soa.AddressStateAbbreviation), '99') 
	--			OR ISNULL(la.PostalCode, '') <> ISNULL(soa.AddressPostalCode, ''))

	--END TRY

	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.LocationAddress', NULL, 'S01EC3200'
	--END CATCH

	---- Update the OrganizationLocation where updates/corrections need to be made

	--BEGIN TRY

	--	UPDATE dbo.OrganizationLocation
	--	SET RecordEndDateTime = soa.RecordEndDateTime
	--	FROM dbo.OrganizationLocation ool
	--	JOIN Staging.OrganizationAddress soa
	--		ON ool.LocationId = soa.LocationId
	--	WHERE soa.RecordEndDateTime IS NOT NULL
	--	AND ISNULL(ool.RecordEndDateTime, '1/1/1900') <> ISNULL(soa.RecordEndDateTime, '1/1/1900')

	--END TRY

	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationLocation', 'RecordEndDateTime', 'S01EC3210'
	--END CATCH

	---- Create the New Location records (dbo.Location, dbo.LocationAddress, dbo.OrganizationLocation)

	--BEGIN TRY

	--	DECLARE @DistinctNewLocations TABLE (
	--		  LocationId INT NULL
	--		, OrganizationLocationTypeId INT
	--		, AddressTypeForOrganization VARCHAR(50)
	--		, OrganizationId INT
	--		, AddressStreetNumberAndName VARCHAR(50)
	--		, AddressApartmentRoomOrSuite VARCHAR(50)
	--		, AddressCity VARCHAR(30)
	--		, RefStateId INT
	--		, AddressPostalCode VARCHAR(17)
	--		, RecordStartDateTime DATETIME
	--		, RecordEndDateTime DATETIME
	--	)

	--END TRY

	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewLocations', NULL, 'S01EC3220'
	--END CATCH

	--BEGIN TRY 

	--	INSERT INTO @DistinctNewLocations
	--	SELECT DISTINCT
	--		  NULL
	--		, roglt.RefOrganizationLocationTypeId
	--		, soa.AddressTypeForOrganization
	--		, soa.OrganizationId
	--		, soa.AddressStreetNumberAndName
	--		, soa.AddressApartmentRoomOrSuite
	--		, soa.AddressCity
	--		, ors.RefStateId
	--		, soa.AddressPostalCode
	--		, soa.RecordStartDateTime
	--		, soa.RecordEndDateTime
	--	FROM Staging.OrganizationAddress soa
	--	JOIN Staging.SourceSystemReferenceData ossr
	--		ON soa.AddressTypeForOrganization = ossr.InputCode
	--		AND ossr.TableName = 'RefOrganizationLocationType'
	--		AND ossr.SchoolYear = @SchoolYear
	--	JOIN dbo.RefOrganizationLocationType roglt
	--		ON ossr.OutputCode = roglt.Code
	--	JOIN Staging.SourceSystemReferenceData ossrState
	--		ON soa.AddressStateAbbreviation = ossrState.InputCode
	--		AND ossrState.TableName = 'RefState'
	--		AND ossrState.SchoolYear = @SchoolYear
	--	JOIN dbo.RefState ors
	--		ON ossrState.OutputCode = ors.Code
	--	WHERE soa.LocationId IS NULL
	--		AND soa.OrganizationId IS NOT NULL

	--END TRY
		
	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewLocations', NULL, 'S01EC3230'
	--END CATCH

	--BEGIN TRY

	--	DECLARE @NewLocations TABLE (
	--		  LocationId INT NULL
	--		, OrganizationLocationTypeId INT
	--		, AddressTypeForOrganization VARCHAR(50)
	--		, OrganizationId INT
	--		, AddressStreetNumberAndName VARCHAR(50)
	--		, AddressApartmentRoomOrSuite VARCHAR(50)
	--		, AddressCity VARCHAR(30)
	--		, RefStateId INT
	--		, AddressPostalCode VARCHAR(17)
	--		, RecordStartDateTime DATETIME
	--		, RecordEndDateTime DATETIME
	--	)

	--	MERGE dbo.Location AS TARGET
	--	USING @DistinctNewLocations AS SOURCE
	--		ON 1 = 0 ---always insert
	--	WHEN NOT MATCHED THEN
	--		INSERT DEFAULT VALUES
	--	OUTPUT
	--		  INSERTED.LocationId AS LocationId
	--		, SOURCE.OrganizationLocationTypeId
	--		, SOURCE.AddressTypeForOrganization
	--		, SOURCE.OrganizationId
	--		, SOURCE.AddressStreetNumberAndName
	--		, SOURCE.AddressApartmentRoomOrSuite
	--		, SOURCE.AddressCity
	--		, SOURCE.RefStateId
	--		, SOURCE.AddressPostalCode
	--		, SOURCE.RecordStartDateTime
	--		, SOURCE.RecordEndDateTime
	--	INTO @NewLocations;

	--END TRY

	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Location', NULL, 'S01EC3240'
	--END CATCH

	--BEGIN TRY

	--	INSERT INTO dbo.LocationAddress(LocationId, [StreetNumberAndName], [ApartmentRoomOrSuiteNumber], [City], [RefStateId],
	--									[PostalCode])
	--	SELECT    nl.LocationId
	--			, nl.AddressStreetNumberAndName
	--			, nl.AddressApartmentRoomOrSuite
	--			, nl.AddressCity
	--			, nl.RefStateId
	--			, nl.AddressPostalCode
	--	FROM @NewLocations nl

	--END TRY

	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.LocationAddress', NULL, 'S01EC3250'
	--END CATCH

	--BEGIN TRY

	--	INSERT INTO dbo.OrganizationLocation(OrganizationId
	--			, LocationId
	--			,RefOrganizationLocationTypeId
	--			,RecordStartDateTime
	--			,RecordEndDateTime)
	--	SELECT    nl.OrganizationId
	--			, nl.LocationId
	--			, nl.OrganizationLocationTypeId
	--			, nl.RecordStartDateTime
	--			, nl.RecordEndDateTime
	--	FROM @NewLocations nl

	--END TRY

	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationLocation', NULL, 'S01EC3260'
	--END CATCH

	--	-- Update the LocationId on the Staging.OrganizationAddress table for troubleshooting purposes
	
	--BEGIN TRY

	--	UPDATE Staging.OrganizationAddress
	--	SET LocationId = ool.LocationId
	--	FROM Staging.OrganizationAddress soa
	--	JOIN @NewLocations nl
	--		ON soa.OrganizationId = nl.OrganizationId
	--		AND soa.AddressTypeForOrganization = nl.AddressTypeForOrganization
	--	JOIN dbo.OrganizationLocation ool
	--		ON nl.LocationId = ool.LocationId
	--	WHERE soa.LocationID IS NULL
	--		AND ool.LocationId IS NOT NULL

	--END TRY

	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'LocationId', 'S01EC3270'
	--END CATCH

	--	--End Date any historical record where a new record was provided, but the older record was not end dated

	--BEGIN TRY

 --       UPDATE r SET r.RecordEndDateTime = s.RecordStartDateTime - 1
 --       FROM dbo.OrganizationLocation r
 --       JOIN (
 --               SELECT 
 --                   OrganizationId
	--				, RefOrganizationLocationTypeId
	--				, MAX(OrganizationLocationId) AS OrganizationLocationId
 --                   , MAX(RecordStartDateTime) AS RecordStartDateTime
 --               FROM dbo.OrganizationLocation
 --               WHERE RecordEndDateTime IS NULL
	--				AND RecordStartDateTime IS NOT NULL
 --               GROUP BY OrganizationId, RefOrganizationLocationTypeId, OrganizationLocationId, RecordStartDateTime
 --       ) s ON r.OrganizationId = s.OrganizationId
	--			AND r.RefOrganizationLocationTypeId = s.RefOrganizationLocationTypeId
 --               AND r.OrganizationLocationId <> s.OrganizationLocationId 
 --               AND r.RecordEndDateTime IS NULL
	--			AND r.RecordStartDateTime IS NOT NULL
	--			AND r.RecordStartDateTime < s.RecordStartDateTime

	--END TRY

	--BEGIN CATCH
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationLocation', 'RecordEndDateTime', 'S01EC3280'
	--END CATCH


	-------------------------------------------------------------------
	----Create OrganizationCalendar and OrganizationCalendarSession----
	-------------------------------------------------------------------
	--      EXEC Staging.[Migrate_Data_ETL_IMPLEMENTATION_STEP01_Organization_EncapsulatedCode] 2018;

	BEGIN TRY
		INSERT INTO [dbo].[OrganizationCalendar]
				   ([OrganizationId]
				   ,[CalendarCode]
				   ,[CalendarDescription]
				   ,[CalendarYear]
				   ,[DataCollectionId])
		SELECT DISTINCT
					orgd.OrganizationId [OrganizationId]
				   ,orgid.Identifier [CalendarCode]
				   ,orgid.Identifier [CalendarDescription]
				   --,dc.DataCollectionAcademicSchoolYear AS [CalendarYear]
				   ,@SchoolYear AS [CalendarYear]
				   ,orgd.DataCollectionId
			FROM dbo.OrganizationDetail orgd
		JOIN dbo.OrganizationIdentifier orgid
			ON orgd.OrganizationId = orgid.OrganizationId
				and ISNULL(orgd.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
		left JOIN dbo.DataCollection dc
			ON Isnull(orgd.DataCollectionId, '') = isnull(dc.DataCollectionId, '')
		left JOIN dbo.RefDataCollectionStatus rdcs
			on dc.RefDataCollectionStatusId = rdcs.RefDataCollectionStatusId 
				and rdcs.Code = 'Published'
		JOIN dbo.RefOrganizationType rot 
			ON orgd.RefOrganizationTypeId = rot.RefOrganizationTypeId
		JOIN dbo.RefOrganizationIdentificationSystem rois 
			ON orgid.RefOrganizationIdentificationSystemId = rois.RefOrganizationIdentificationSystemId
		LEFT JOIN dbo.OrganizationCalendar orgc
			ON orgd.OrganizationId = orgc.OrganizationId
				AND ISNULL(orgd.DataCollectionId, '') = ISNULL(orgc.DataCollectionId, '')
				AND orgc.CalendarYear = dc.DataCollectionSchoolYear
		WHERE rot.Code IN ('SEA')
		AND rois.Code = 'Federal'
		AND orgc.OrganizationCalendarId IS NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationCalendar', NULL, 'S01EC2080'
	END CATCH


	BEGIN TRY
		INSERT INTO [dbo].[OrganizationCalendar]
				   ([OrganizationId]
				   ,[CalendarCode]
				   ,[CalendarDescription]
				   ,[CalendarYear]
				   ,[DataCollectionId])
			SELECT DISTINCT
					orgd.OrganizationId [OrganizationId]
				   ,orgid.Identifier [CalendarCode]
				   ,orgid.Identifier [CalendarDescription]
				   --,dc.DataCollectionAcademicSchoolYear AS [CalendarYear]
				   ,@SchoolYear AS [CalendarYear]
				   ,orgd.DataCollectionId
			FROM dbo.OrganizationDetail orgd
		JOIN dbo.OrganizationIdentifier orgid
			ON orgd.OrganizationId = orgid.OrganizationId
				and ISNULL(orgd.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
		left JOIN dbo.DataCollection dc
			ON Isnull(orgd.DataCollectionId, '') = isnull(dc.DataCollectionId, '')
		left JOIN dbo.RefDataCollectionStatus rdcs
			on dc.RefDataCollectionStatusId = rdcs.RefDataCollectionStatusId 
				and rdcs.Code = 'Published'
		JOIN dbo.RefOrganizationType rot 
			ON orgd.RefOrganizationTypeId = rot.RefOrganizationTypeId
		JOIN dbo.RefOrganizationIdentificationSystem rois 
			ON orgid.RefOrganizationIdentificationSystemId = rois.RefOrganizationIdentificationSystemId
		LEFT JOIN dbo.OrganizationCalendar orgc
			ON orgd.OrganizationId = orgc.OrganizationId
				AND ISNULL(orgd.DataCollectionId, '') = ISNULL(orgc.DataCollectionId, '')
				AND orgc.CalendarYear = dc.DataCollectionSchoolYear
		WHERE rot.Code IN ('LEA', 'K12School')
		AND rois.Code = 'SEA'
		AND orgc.OrganizationCalendarId IS NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationCalendar', NULL, 'S01EC2080'
	END CATCH

	--select * from dbo.OrganizationCalendar

	BEGIN TRY
		INSERT INTO [dbo].[OrganizationCalendarSession]
				   ([Designator]
				   ,[BeginDate]
				   ,[EndDate]
				   ,[RefSessionTypeId]
				   ,[InstructionalMinutes]
				   ,[Code]
				   ,[Description]
				   ,[MarkingTermIndicator]
				   ,[SchedulingTermIndicator]
				   ,[AttendanceTermIndicator]
				   ,[OrganizationCalendarId]
				   ,[DaysInSession]
				   ,[FirstInstructionDate]
				   ,[LastInstructionDate]
				   ,[MinutesPerDay]
				   ,[SessionStartTime]
				   ,[SessionEndTime]
				   ,[DataCollectionId])
		SELECT DISTINCT 
					NULL [Designator]
				   ,Staging.GetFiscalYearStartDate(orgc.CalendarYear) [BeginDate]
				   ,Staging.GetFiscalYearEndDate(orgc.CalendarYear) [EndDate]
				   ,(SELECT  [RefSessionTypeId] FROM [dbo].[RefSessionType] WHERE Code = 'FullSchoolYear') [RefSessionTypeId] 
				   ,NULL [InstructionalMinutes]
				   ,NULL [Code]
				   ,NULL [Description]
				   ,NULL [MarkingTermIndicator]
				   ,NULL [SchedulingTermIndicator]
				   ,NULL [AttendanceTermIndicator]
				   ,orgc.OrganizationCalendarId [OrganizationCalendarId]
				   ,NULL [DaysInSession]
				   ,NULL [FirstInstructionDate]
				   ,NULL [LastInstructionDate]
				   ,NULL [MinutesPerDay]
				   ,NULL [SessionStartTime]
				   ,NULL [SessionEndTime]
				   ,orgc.DataCollectionId
		FROM dbo.OrganizationCalendar orgc
		LEFT JOIN dbo.OrganizationCalendarSession orgcs
			ON orgc.OrganizationCalendarId = orgcs.OrganizationCalendarId 
				AND ISNULL(orgc.DataCollectionId, '') = ISNULL(orgcs.DataCollectionId, '')
		WHERE orgcs.OrganizationCalendarId IS NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationCalendarSession', NULL, 'S01EC2090'
	END CATCH

	-------------------------------------------------------------------
	----Move Organization Financial Data Into Appropriate Tables ------
	-------------------------------------------------------------------
	BEGIN TRY
		INSERT INTO [dbo].[K12LeaFederalFunds]
		   ([OrganizationCalendarSessionId]
		   ,[InnovativeProgramsFundsReceived]
		   ,[InnovativeDollarsSpent]
		   ,[InnovativeDollarsSpentOnStrategicPriorities]
		   ,[PublicSchoolChoiceFundsSpent]
		   ,[SesFundsSpent]
		   ,[SesSchoolChoice20PercentObligation]
		   ,[RefRlisProgramUseId]
		   ,[ParentalInvolvementReservationFunds]
		   ,[RecordStartDateTime]
		   ,[RecordEndDateTime]
		   ,[DataCollectionId])
		SELECT DISTINCT
		   orgcs.OrganizationCalendarSessionId					[OrganizationCalendarSessionId] 
		   ,NULL												[InnovativeProgramsFundsReceived]
		   ,NULL												[InnovativeDollarsSpent]
		   ,NULL												[InnovativeDollarsSpentOnStrategicPriorities]
		   ,NULL												[PublicSchoolChoiceFundsSpent]
		   ,NULL												[SesFundsSpent]
		   ,NULL												[SesSchoolChoice20PercentObligation]
		   ,NULL												[RefRlisProgramUseId]
		   ,orgff.ParentalInvolvementReservationFunds			[ParentalInvolvementReservationFunds]
		   ,Staging.GetFiscalYearStartDate(orgc.CalendarYear)	[RecordStartDateTime] --ADDED|TODO:
		   ,Staging.GetFiscalYearEndDate(orgc.CalendarYear)		[RecordEndDateTime] --ADDED|TODO:
		   ,orgid.DataCollectionId
		FROM Staging.OrganizationFederalFunding orgff
		JOIN dbo.OrganizationIdentifier orgid
			ON orgff.OrganizationIdentifier = orgid.Identifier
				AND ISNULL(orgff.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
		LEFT JOIN dbo.OrganizationCalendar orgc  --Changed|TODO: Add DataCollectionId
			ON orgid.OrganizationId = orgc.OrganizationId
		LEFT JOIN dbo.OrganizationCalendarSession orgcs 
			ON orgc.OrganizationCalendarId = orgcs.OrganizationCalendarId
		JOIN [Staging].[SourceSystemReferenceData] osss
			ON orgff.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = orgff.SchoolYear
		JOIN dbo.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN dbo.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		JOIN dbo.RefOrganizationIdentificationSystem rois 
			ON orgid.RefOrganizationIdentificationSystemId = rois.RefOrganizationIdentificationSystemId
		WHERE ot.Code = 'LEA'
		AND rois.Code = 'SEA'
		AND ISNULL(orgcs.OrganizationCalendarSessionId, '') <> ''
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12LeaFederalFunds', NULL, 'S01EC3000'
	END CATCH



		BEGIN TRY
		INSERT INTO [dbo].[K12FederalFundAllocation]
				   ([OrganizationCalendarSessionId]
				   ,[FederalProgramCode]
				   ,[RefFederalProgramFundingAllocationTypeId]
				   ,[FederalProgramsFundingAllocation]
				   ,[FundsTransferAmount]
				   ,[SchoolImprovementAllocation]
				   ,[LeaTransferabilityOfFunds]
				   ,[RefLeaFundsTransferTypeId]
				   ,[SchoolImprovementReservedPercent]
				   ,[SesPerPupilExpenditure]
				   ,[NumberOfImmigrantProgramSubgrants]
				   ,[RefReapAlternativeFundingStatusId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime]
				   ,[DataCollectionId])
		SELECT DISTINCT
					orgcs.OrganizationCalendarSessionId					[OrganizationCalendarSessionId]
				   ,orgff.FederalProgramCode							[FederalProgramCode]
				   ,ffad.RefFederalProgramFundingAllocationTypeId		[RefFederalProgramFundingAllocationTypeId]
				   ,orgff.FederalProgramsFundingAllocation				[FederalProgramsFundingAllocation]
				   ,NULL												[FundsTransferAmount]
				   ,NULL												[SchoolImprovementAllocation]
				   ,NULL												[LeaTransferabilityOfFunds]
				   ,NULL												[RefLeaFundsTransferTypeId]
				   ,NULL												[SchoolImprovementReservedPercent]
				   ,NULL												[SesPerPupilExpenditure]
				   ,NULL												[NumberOfImmigrantProgramSubgrants]
				   ,REAPot.RefReapAlternativeFundingStatusId			[RefReapAlternativeFundingStatusId]
				   ,Staging.GetFiscalYearStartDate(orgc.CalendarYear)	[RecordStartDateTime] --ADDED|TODO:
				   ,Staging.GetFiscalYearEndDate(orgc.CalendarYear)		[RecordEndDateTime] --ADDED|TODO:
				   ,orgid.DataCollectionId
		FROM Staging.OrganizationFederalFunding orgff
		JOIN dbo.OrganizationIdentifier orgid
			ON orgff.OrganizationIdentifier = orgid.Identifier
				AND ISNULL(orgff.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
		LEFT JOIN dbo.OrganizationCalendar orgc
			ON orgid.OrganizationId = orgc.OrganizationId
				AND ISNULL(orgid.DataCollectionId, '') = ISNULL(orgc.DataCollectionId, '')
		LEFT JOIN dbo.OrganizationCalendarSession orgcs
			ON orgc.OrganizationCalendarId = orgcs.OrganizationCalendarId
				AND ISNULL(orgc.DataCollectionId, '') = ISNULL(orgcs.DataCollectionId, '')
		JOIN [Staging].[SourceSystemReferenceData] osss
			ON orgff.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = orgff.SchoolYear
		JOIN dbo.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		left JOIN [Staging].[SourceSystemReferenceData] ffa 
			ON orgff.FederalProgramFundingAllocationType = ffa.InputCode
			AND ffa.TableName = 'RefFederalProgramFundingAllocationType'
			AND ffa.SchoolYear = orgff.SchoolYear
		left JOIN dbo.RefFederalProgramFundingAllocationType ffad
			ON ffa.OutputCode = ffad.Code

		JOIN dbo.RefOrganizationIdentificationSystem rois 
			ON orgid.RefOrganizationIdentificationSystemId = rois.RefOrganizationIdentificationSystemId
		LEFT JOIN dbo.RefReapAlternativeFundingStatus REAPot 
			ON orgff.REAPAlternativeFundingStatusCode = REAPot.Code
		LEFT JOIN [dbo].[K12FederalFundAllocation] k12fs 
			ON k12fs.OrganizationCalendarSessionId = orgcs.OrganizationCalendarSessionId
			AND ISNULL(k12fs.DataCollectionId, '') = ISNULL(orgc.DataCollectionId, '')
			and k12fs.FederalProgramCode = orgff.FederalProgramCode -- JW 7/11/2022

		WHERE ot.Code = 'SEA'
		AND rois.Code = 'Federal'	
		AND (
			orgff.FederalProgramCode IS NOT NULL
			OR orgff.FederalProgramsFundingAllocation IS NOT NULL
		)		
		AND k12fs.K12FederalFundAllocationId IS NULL
		AND ISNULL(orgcs.OrganizationCalendarSessionId, '') <> ''
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12FederalFundAllocation', NULL, 'S01EC3010'
	END CATCH



	BEGIN TRY
		INSERT INTO [dbo].[K12FederalFundAllocation]
				   ([OrganizationCalendarSessionId]
				   ,[FederalProgramCode]
				   ,[RefFederalProgramFundingAllocationTypeId]
				   ,[FederalProgramsFundingAllocation]
				   ,[FundsTransferAmount]
				   ,[SchoolImprovementAllocation]
				   ,[LeaTransferabilityOfFunds]
				   ,[RefLeaFundsTransferTypeId]
				   ,[SchoolImprovementReservedPercent]
				   ,[SesPerPupilExpenditure]
				   ,[NumberOfImmigrantProgramSubgrants]
				   ,[RefReapAlternativeFundingStatusId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime]
				   ,[DataCollectionId])
		SELECT 
		DISTINCT
					orgcs.OrganizationCalendarSessionId					[OrganizationCalendarSessionId]
				   ,orgff.FederalProgramCode							[FederalProgramCode]
				   ,ffad.RefFederalProgramFundingAllocationTypeId		[RefFederalProgramFundingAllocationTypeId]
				   ,orgff.FederalProgramsFundingAllocation				[FederalProgramsFundingAllocation]
				   ,NULL												[FundsTransferAmount]
				   ,NULL												[SchoolImprovementAllocation]
				   ,NULL												[LeaTransferabilityOfFunds]
				   ,NULL												[RefLeaFundsTransferTypeId]
				   ,NULL												[SchoolImprovementReservedPercent]
				   ,NULL												[SesPerPupilExpenditure]
				   ,NULL												[NumberOfImmigrantProgramSubgrants]
				   ,REAPot.RefReapAlternativeFundingStatusId			[RefReapAlternativeFundingStatusId]
				   ,Staging.GetFiscalYearStartDate(orgc.CalendarYear)	[RecordStartDateTime] --ADDED|TODO:
				   ,Staging.GetFiscalYearEndDate(orgc.CalendarYear)		[RecordEndDateTime] --ADDED|TODO:
				   ,orgid.DataCollectionId
		FROM Staging.OrganizationFederalFunding orgff
		JOIN dbo.OrganizationIdentifier orgid
			ON orgff.OrganizationIdentifier = orgid.Identifier
				AND ISNULL(orgff.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
		LEFT JOIN dbo.OrganizationCalendar orgc
			ON orgid.OrganizationId = orgc.OrganizationId
				AND ISNULL(orgid.DataCollectionId, '') = ISNULL(orgc.DataCollectionId, '')
		LEFT JOIN dbo.OrganizationCalendarSession orgcs
			ON orgc.OrganizationCalendarId = orgcs.OrganizationCalendarId
				AND ISNULL(orgc.DataCollectionId, '') = ISNULL(orgcs.DataCollectionId, '')
		JOIN [Staging].[SourceSystemReferenceData] osss
			ON orgff.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = orgff.SchoolYear
		JOIN dbo.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		
		-- JW 7/11/2022 -------------------------------------------------------------------------
		join dbo.RefOrganizationElementType oet
			on oet.RefOrganizationElementTypeId = ot.RefOrganizationElementTypeId
			and oet.Code = '001156'
		-------------------------------------------------------------------------------

		left JOIN [Staging].[SourceSystemReferenceData] ffa 
			ON orgff.FederalProgramFundingAllocationType = ffa.InputCode
			AND ffa.TableName = 'RefFederalProgramFundingAllocationType'
			AND ffa.SchoolYear = orgff.SchoolYear
		left JOIN dbo.RefFederalProgramFundingAllocationType ffad
			ON ffa.OutputCode = ffad.Code

		JOIN dbo.RefOrganizationIdentificationSystem rois 
			ON orgid.RefOrganizationIdentificationSystemId = rois.RefOrganizationIdentificationSystemId
		LEFT JOIN dbo.RefReapAlternativeFundingStatus REAPot 
			ON orgff.REAPAlternativeFundingStatusCode = REAPot.Code
		LEFT JOIN [dbo].[K12FederalFundAllocation] k12fs 
			ON k12fs.OrganizationCalendarSessionId = orgcs.OrganizationCalendarSessionId
		and orgff.FederalProgramCode = k12fs.FederalProgramCode -- JW 7/11/2022
		and orgff.FederalProgramsFundingAllocation = k12fs.FederalProgramsFundingAllocation -- JW 7/11/2022
			AND ISNULL(k12fs.DataCollectionId, '') = ISNULL(orgc.DataCollectionId, '')
		WHERE ot.Code = 'LEA'
		AND rois.Code = 'SEA'	
		AND (
			orgff.FederalProgramCode IS NOT NULL
			OR orgff.FederalProgramsFundingAllocation IS NOT NULL
									--OR orgff.ParentalInvolvementReservationFunds IS NOT NULL	
									--OR orgff.REAPAlternativeFundingStatusCode IS NOT NULL
		)		
		AND k12fs.K12FederalFundAllocationId IS NULL
		AND ISNULL(orgcs.OrganizationCalendarSessionId, '') <> ''	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12FederalFundAllocation', NULL, 'S01EC3010'
	END CATCH

	BEGIN TRY
		--==================
		INSERT INTO [dbo].[K12FederalFundAllocation]
				   ([OrganizationCalendarSessionId]
				   ,[FederalProgramCode]
				   ,[RefFederalProgramFundingAllocationTypeId]
				   ,[FederalProgramsFundingAllocation]
				   ,[FundsTransferAmount]
				   ,[SchoolImprovementAllocation]
				   ,[LeaTransferabilityOfFunds]
				   ,[RefLeaFundsTransferTypeId]
				   ,[SchoolImprovementReservedPercent]
				   ,[SesPerPupilExpenditure]
				   ,[NumberOfImmigrantProgramSubgrants]
				   ,[RefReapAlternativeFundingStatusId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime]
				   ,[DataCollectionId])
		SELECT DISTINCT
					orgcs.OrganizationCalendarSessionId [OrganizationCalendarSessionId]
				   ,'84.010' [FederalProgramCode]
				   ,NULL [RefFederalProgramFundingAllocationTypeId]
				   ,NULL [FederalProgramsFundingAllocation]
				   ,NULL [FundsTransferAmount]
				   ,orgff.SchoolImprovementAllocation [SchoolImprovementAllocation]
				   ,NULL [LeaTransferabilityOfFunds]
				   ,NULL [RefLeaFundsTransferTypeId]
				   ,NULL [SchoolImprovementReservedPercent]
				   ,NULL [SesPerPupilExpenditure]
				   ,NULL [NumberOfImmigrantProgramSubgrants]
				   ,NULL [RefReapAlternativeFundingStatusId]
				   ,Staging.GetFiscalYearStartDate(orgc.CalendarYear) [RecordStartDateTime] --ADDED|TODO:
				   ,Staging.GetFiscalYearEndDate(orgc.CalendarYear) [RecordEndDateTime] --ADDED|TODO:
				   ,orgff.DataCollectionId
		FROM Staging.K12Organization orgff
		left JOIN dbo.OrganizationCalendar orgc 
			ON orgc.OrganizationId = orgff.OrganizationId_School
				and ISNULL(orgc.DataCollectionId, '') = ISNULL(orgff.DataCollectionId, '')
		left JOIN dbo.OrganizationCalendarSession orgcs
			ON orgcs.OrganizationCalendarId = orgc.OrganizationCalendarId
				and ISNULL(orgcs.DataCollectionId, '') = ISNULL(orgc.DataCollectionId, '')
		WHERE orgff.OrganizationId_School IS NOT NULL 
		AND ISNULL(orgcs.OrganizationCalendarSessionId, '') <> ''
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12FederalFundAllocation', NULL, 'S01EC3020'
	END CATCH

	BEGIN TRY
		INSERT INTO [dbo].[K12SchoolImprovement]
			([K12SchoolId]
			 ,[RefSchoolImprovementStatusId]
			 ,[RefSchoolImprovementFundsId]
			 ,[RefSigInterventionTypeId]
			 ,[SchoolImprovementExitDate]
			 ,[DataCollectionId]
			 )
		SELECT DISTINCT
			k12.K12SchoolId	[K12SchoolId]
			,NULL [RefSchoolImprovementStatusId]
			,(SELECT dbo.RefSchoolImprovementFunds.RefSchoolImprovementFundsId FROM dbo.RefSchoolImprovementFunds WHERE dbo.RefSchoolImprovementFunds.Code = 'Yes')
			,NULL [RefSigInterventionTypeId]
			,NULL [SchoolImprovementExitDate]
			,orgff.DataCollectionId
		FROM Staging.K12Organization orgff
		JOIN dbo.K12School k12 
			ON k12.OrganizationId = orgff.OrganizationId_School
				AND ISNULL(K12.DataCollectionId, '') = ISNULL(orgff.DataCollectionId, '')
		JOIN dbo.OrganizationCalendar orgc
			ON orgc.OrganizationId = orgff.OrganizationId_School
				AND ISNULL(orgc.DataCollectionId, '') = ISNULL(orgff.DataCollectionId, '')
		JOIN dbo.OrganizationCalendarSession orgcs
			ON orgcs.OrganizationCalendarId = orgc.OrganizationCalendarId
				AND ISNULL(orgcs.DataCollectionId, '') = ISNULL(orgc.DataCollectionId, '')
		WHERE orgff.OrganizationId_School IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12SchoolImprovement', NULL, 'S01EC3030'
	END CATCH
	--==================

	--------------------------------------
	-- Add 'McKinney-Vento subgrant'
	--------------------------------------

	-- [dbo].[FinancialAccount] is LEA specific
	BEGIN TRY
		INSERT INTO [dbo].[FinancialAccount] (
			[Name]
			,[Description]
			,[FederalProgramCode]
			,[DataCollectionId]
		)
		SELECT DISTINCT o.LEA_Name + ' McKinney-Vento subgrant' 
			 , o.LEA_Name + ' McKinney-Vento subgrant' 
			 , '84.196'
			 ,o.DataCollectionId
		FROM Staging.K12Organization o
		INNER JOIN 	dbo.OrganizationIdentifier orgid
			ON o.LEA_Identifier_State = orgid.Identifier
				AND ISNULL(o.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
		INNER JOIN 	dbo.OrganizationCalendar orgc
			ON orgid.OrganizationId = orgc.OrganizationId
				AND ISNULL(orgid.DataCollectionId, '') = ISNULL(orgc.DataCollectionId, '')
		INNER JOIN dbo.OrganizationCalendarSession orgcs
			ON orgc.OrganizationCalendarId = orgcs.OrganizationCalendarId
				AND ISNULL(orgc.DataCollectionId, '') = ISNULL(orgcs.DataCollectionId, '')
		LEFT JOIN [dbo].[FinancialAccount] fa --Defer|TODO: Add DataCollectionId
			ON CHARINDEX(o.LEA_Name, fa.Name) > 0
		WHERE o.LEA_McKinneyVentoSubgrantRecipient = 1
			AND fa.FinancialAccountId  IS NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.FinancialAccount', NULL, 'S01EC3040'
	END CATCH

	BEGIN TRY
		INSERT INTO [dbo].[OrganizationFinancial]
		(
			[FinancialAccountId]
			,[OrganizationCalendarSessionId]
			,[DataCollectionId]
		)
		SELECT DISTINCT fa.FinancialAccountId
		 , orgcs.OrganizationCalendarSessionId
		 ,o.DataCollectionId
		FROM Staging.K12Organization o
		INNER JOIN 	dbo.OrganizationIdentifier orgid
			ON o.LEA_Identifier_State = orgid.Identifier
				AND ISNULL(o.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
		INNER JOIN 	dbo.OrganizationCalendar orgc
			ON orgid.OrganizationId = orgc.OrganizationId
				AND ISNULL(orgid.DataCollectionId, '') = ISNULL(orgc.DataCollectionId, '')
		INNER JOIN dbo.OrganizationCalendarSession orgcs
			ON orgc.OrganizationCalendarId = orgcs.OrganizationCalendarId
				AND ISNULL(orgc.DataCollectionId, '') = ISNULL(orgcs.DataCollectionId, '')
		INNER JOIN [dbo].[FinancialAccount] fa --Defer|TODO: Add DataCollectionId
			ON CHARINDEX(o.LEA_Name, fa.Name) > 0
		LEFT JOIN [dbo].[OrganizationFinancial] orgf
			ON orgf.OrganizationCalendarSessionId = orgcs.OrganizationCalendarSessionId
			AND ISNULL(orgf.DataCollectionId, '') = ISNULL(orgcs.DataCollectionId, '')
			AND orgf.FinancialAccountId = fa.FinancialAccountId
		WHERE o.LEA_McKinneyVentoSubgrantRecipient = 1
			AND orgf.OrganizationFinancialId  IS NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationFinancial', NULL, 'S01EC3050'
	END CATCH

		--------------------------------------
		--Insert LEA Gun Free Schools Act Reporting Status --
		--------------------------------------

		INSERT INTO [dbo].[OrganizationFederalAccountability]
        (
			[OrganizationId]
			,[RefGunFreeSchoolsActReportingStatusId]
			,[DataCollectionId]
		)
		SELECT DISTINCT 
			orgst.OrganizationId_LEA
			,gunfreeType.RefGunFreeSchoolsActReportingStatusId
			,orgst.DataCollectionId
		FROM Staging.K12Organization orgst
		LEFT JOIN [Staging].[SourceSystemReferenceData] srcRef 
			ON srcRef.InputCode = orgst.LEA_GunFreeSchoolsActReportingStatus
			AND srcRef.TableName='RefGunFreeSchoolsActReportingStatus' 
			AND srcRef.SchoolYear = orgst.SchoolYear
		LEFT JOIN [dbo].[RefGunFreeSchoolsActReportingStatus] gunfreeType 
			ON gunfreeType.Code = srcRef.OutputCode
		WHERE orgst.OrganizationId_LEA IS NOT NULL

		--------------------------------------
		--Insert School Gun Free Schools Act Reporting Status --
		--------------------------------------

		INSERT INTO [dbo].[OrganizationFederalAccountability] (
			[OrganizationId]
			,[RefGunFreeSchoolsActReportingStatusId]
			,[RefReconstitutedStatusId]
			,[DataCollectionId]
		)
		SELECT DISTINCT 
			orgst.OrganizationId_School
			,gunfreeType.RefGunFreeSchoolsActReportingStatusId
			,recon.RefReconstitutedStatusId
			,orgst.DataCollectionId
		FROM Staging.K12Organization orgst
		LEFT JOIN [Staging].[SourceSystemReferenceData] sssrd_gunfree 
			ON sssrd_gunfree.InputCode = orgst.School_GunFreeSchoolsActReportingStatus
			AND sssrd_gunfree.TableName='RefGunFreeSchoolsActReportingStatus' 
			AND sssrd_gunfree.SchoolYear = orgst.SchoolYear
		LEFT JOIN [dbo].[RefGunFreeSchoolsActReportingStatus] gunfreeType 
			ON gunfreeType.Code = sssrd_gunfree.OutputCode
		LEFT JOIN [Staging].[SourceSystemReferenceData] sssrd_recon 
			ON sssrd_recon.InputCode = orgst.School_ReconstitutedStatus
			AND sssrd_recon.TableName='RefReconstitutedStatus' 
			AND sssrd_recon.SchoolYear = orgst.SchoolYear
		LEFT JOIN [dbo].[RefReconstitutedStatus] recon 
			ON recon.Code = sssrd_recon.OutputCode
		WHERE orgst.OrganizationId_School IS NOT NULL

		--------------------------------------
		--Insert RefReconstituted Status --
		--------------------------------------

		--INSERT INTO [dbo].[OrganizationFederalAccountability]
  --      (
		--	[OrganizationId]
		--	,[RefReconstitutedStatusId]
		--)
		--SELECT DISTINCT 
		--	orgst.OrganizationId_LEA
		--	,recon.RefReconstitutedStatusId
		--FROM Staging.K12Organization orgst
		--JOIN [dbo].[RefReconstitutedStatus] recon 
		--	ON recon.Code = orgst.School_ReconstitutedStatus

	--------------------------------------
	--Insert Cheif State School Officer --
	--------------------------------------
	If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#PersonIdtoPersonIdentifier'))
		Begin
			Drop Table #PersonIdtoPersonIdentifier
		End
		
	CREATE TABLE #PersonIdtoPersonIdentifier 
		(PersonID INT
		,Identifier VARCHAR(50)
		,DataCollectionId INT)

	BEGIN TRY
		MERGE INTO [dbo].[Person] as tgt
		USING Staging.StateDetail as nisl
		ON 1 = 2  --guarantees no matches
		WHEN NOT MATCHED BY TARGET THEN
		INSERT (PersonMasterId,DataCollectionId)
		  VALUES(NULL,nisl.DataCollectionId)
		OUTPUT INSERTED.PersonID, nisl.SeaContact_Identifier,nisl.DataCollectionId INTO #PersonIdtoPersonIdentifier;
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Person', NULL, 'S01EC3060'
	END CATCH

	BEGIN TRY
		UPDATE Staging.StateDetail
		SET PersonId = pt.PersonID
		FROM Staging.StateDetail nisl
		JOIN #PersonIdtoPersonIdentifier pt ON nisl.SeaContact_Identifier = pt.Identifier
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StateDetail', 'PersonId', 'S01EC3070'
	END CATCH

	BEGIN TRY
		INSERT INTO [dbo].[PersonDetail]
				   ([PersonId]
				   ,[FirstName]
				   ,[MiddleName]
				   ,[LastName]
				   ,[GenerationCode]
				   ,[Prefix]
				   ,[Birthdate]
				   ,[RefSexId]
				   ,[HispanicLatinoEthnicity]
				   ,[RefUSCitizenshipStatusId]
				   ,[RefVisaTypeId]
				   ,[RefStateOfResidenceId]
				   ,[RefProofOfResidencyTypeId]
				   ,[RefHighestEducationLevelCompletedId]
				   ,[RefPersonalInformationVerificationId]
				   ,[BirthdateVerification]
				   ,[RefTribalAffiliationId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime]
				   ,[DataCollectionId])
		SELECT DISTINCT
					PersonId									[PersonId]
				   ,SeaContact_FirstName						[FirstName]
				   ,NULL										[MiddleName]
				   ,SeaContact_LastOrSurname					[LastName]
				   ,NULL										[GenerationCode]
				   ,NULL										[Prefix]
				   ,NULL										[Birthdate]
				   ,NULL										[RefSexId]
				   ,NULL										[HispanicLatinoEthnicity]
				   ,NULL										[RefUSCitizenshipStatusId]
				   ,NULL										[RefVisaTypeId]
				   ,NULL										[RefStateOfResidenceId]
				   ,NULL										[RefProofOfResidencyTypeId]
				   ,NULL										[RefHighestEducationLevelCompletedId]
				   ,NULL										[RefPersonalInformationVerificationId]
				   ,NULL										[BirthdateVerification]
				   ,NULL										[RefTribalAffiliationId]
				   ,Staging.GetFiscalYearStartDate(SchoolYear)	[RecordStartDateTime]
				   ,Staging.GetFiscalYearEndDate(SchoolYear)	[RecordEndDateTime]
				   ,DataCollectionId
		FROM Staging.StateDetail
		WHERE SeaContact_FirstName IS NOT NULL
		AND SeaContact_FirstName <> ''
		AND SeaContact_LastOrSurname IS NOT NULL
		AND SeaContact_LastOrSurname <> ''
		AND PersonId IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonDetail', NULL, 'S01EC3080'
	END CATCH

	BEGIN TRY
		INSERT INTO [dbo].[PersonEmailAddress]
				   ([PersonId]
				   ,[EmailAddress]
				   ,[RefEmailTypeId]
				   ,[DataCollectionId])
		SELECT DISTINCT
					PersonId [PersonId]
				   ,SeaContact_ElectronicMailAddress [EmailAddress]
				   ,(SELECT RefEmailTypeId FROM dbo.RefEmailType WHERE Code = 'Work') [RefEmailTypeId]
				   ,DataCollectionId
		FROM Staging.StateDetail
		WHERE SeaContact_ElectronicMailAddress IS NOT NULL
		AND SeaContact_ElectronicMailAddress <> ''
		AND PersonId IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonEmailAddress', NULL, 'S01EC3090'
	END CATCH

	BEGIN TRY
		INSERT INTO [dbo].[PersonTelephone]
				   ([PersonId]
				   ,[TelephoneNumber]
				   ,[PrimaryTelephoneNumberIndicator]
				   ,[RefPersonTelephoneNumberTypeId]
				   ,[DataCollectionId])
		SELECT DISTINCT
					PersonId [PersonId]
				   ,SeaContact_PhoneNumber [TelephoneNumber]
				   ,1 [PrimaryTelephoneNumberIndicator]
				   ,(SELECT RefTelephoneNumberTypeId FROM dbo.RefTelephoneNumberType WHERE Code = 'Main') [RefPersonTelephoneNumberTypeId]
				   ,[DataCollectionId]
		FROM Staging.StateDetail
		WHERE SeaContact_PhoneNumber IS NOT NULL
		AND SeaContact_PhoneNumber <> ''
		AND PersonId IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonTelephone', NULL, 'S01EC3110'
	END CATCH

	BEGIN TRY
		INSERT INTO [dbo].[OrganizationPersonRole]
				   ([OrganizationId]
				   ,[PersonId]
				   ,[RoleId]
				   ,[EntryDate]
				   ,[ExitDate]
				   ,[DataCollectionId])
		SELECT DISTINCT
					orgd.OrganizationId [OrganizationId]
				   ,sd.PersonId [PersonId]
				   ,(SELECT RoleId FROM dbo.Role WHERE Name = 'Chief State School Officer') [RoleId]
				   ,Staging.GetFiscalYearStartDate(sd.SchoolYear) [EntryDate]
				   ,Staging.GetFiscalYearEndDate(sd.SchoolYear) [ExitDate]
				   ,sd.DataCollectionId
		FROM Staging.StateDetail sd
		JOIN dbo.OrganizationDetail orgd 
			ON sd.SeaName = orgd.Name
			AND ISNULL(sd.DataCollectionId, '') = ISNULL(orgd.DataCollectionId, '')
		JOIN dbo.RefOrganizationType rot 
			ON orgd.RefOrganizationTypeId = rot.RefOrganizationTypeId
		WHERE Code = 'SEA'
		AND sd.PersonId IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S01EC3120'
	END CATCH

	BEGIN TRY
		INSERT INTO [dbo].[PersonIdentifier]
				   ([PersonId]
				   ,[Identifier]
				   ,[RefPersonIdentificationSystemId]
				   ,[RefPersonalInformationVerificationId]
				   ,[DataCollectionId])
		SELECT DISTINCT
					PersonId [PersonId]
				   ,SeaContact_Identifier [Identifier]
				   ,(SELECT ris.RefPersonIdentificationSystemId 
					 FROM dbo.RefPersonIdentificationSystem ris JOIN dbo.RefPersonIdentifierType rit 
						ON ris.RefPersonIdentifierTypeId = rit.RefPersonIdentifierTypeId 
					 WHERE ris.Code = 'State' 
						AND rit.Code = '001074') [RefPersonIdentificationSystemId]
				   ,(SELECT RefPersonalInformationVerificationId FROM dbo.RefPersonalInformationVerification WHERE Code = '01011') [RefPersonalInformationVerificationId]
				   ,DataCollectionId
		FROM Staging.StateDetail
		WHERE PersonId IS NOT NULL
		AND SeaContact_Identifier IS NOT NULL
		AND SeaContact_Identifier <> ''
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonIdentifier', NULL, 'S01EC3130'
	END CATCH

	--Add the Staff Employment record
	BEGIN TRY
		INSERT INTO [dbo].[StaffEmployment] (
			OrganizationPersonRoleId
			,PositionTitle
		)
		SELECT DISTINCT
			OrganizationPersonRoleId			[OrganizationPersonRoleId]
			,SeaContact_PositionTitle			[PositionTitle]
		FROM Staging.StateDetail ssd
		JOIN dbo.OrganizationPersonRole oopr 
			ON ssd.OrganizationId = oopr.OrganizationId
		WHERE oopr.RoleId = (SELECT RoleId FROM dbo.[Role] WHERE [Name] = 'Chief State School Officer')
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.StaffEmployment', NULL, 'S01EC3135'
	END CATCH

	--------------------------------------
	--Insert School Indicator Status. For now, it's only the Graduation Rate --
	-- include other Statuses - AcademicAchievementIndicatorStatus and OtherAcademicIndicatorStatus
	--------------------------------------
	BEGIN TRY
		INSERT INTO [dbo].[K12SchoolIndicatorStatus] ( 
			[K12SchoolId]
			,[RefIndicatorStatusTypeId]
			,[RefIndicatorStateDefinedStatusId]
			,[RefIndicatorStatusSubgroupTypeId]
			,[IndicatorStatusSubgroup]
			,[IndicatorStatus]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
			,[DataCollectionId])
		SELECT    
			k12.K12SchoolId
			, ist.RefIndicatorStatusTypeId
			, ds.RefIndicatorStateDefinedStatusId
			, st.RefIndicatorStatusSubgroupTypeId
			, s.IndicatorStatusSubgroup
			, s.IndicatorStatus
			, s.[RecordStartDateTime]
			, s.[RecordEndDateTime]
			, orgff.DataCollectionId
		FROM [Staging].[OrganizationSchoolIndicatorStatus] s
		JOIN Staging.K12Organization orgff 
			ON s.School_Identifier_State = orgff.School_Identifier_State 
			AND ISNULL(s.DataCollectionId, '') = ISNULL(orgff.DataCollectionId, '')
		JOIN dbo.K12School k12 
			ON k12.OrganizationId = orgff.OrganizationId_School 
			AND ISNULL(K12.DataCollectionId, '') = ISNULL(orgff.DataCollectionId, '')
		JOIN [dbo].[RefIndicatorStatusType] ist		
			ON ist.Code = s.IndicatorStatusType
		JOIN [dbo].[RefIndicatorStateDefinedStatus] ds 
			ON ds.Code = s.StatedDefinedIndicatorStatus
		JOIN [dbo].[RefIndicatorStatusSubgroupType] st 
			ON st.Code = s.IndicatorStatusSubgroupType
		LEFT JOIN [dbo].[K12SchoolIndicatorStatus] ks  
			ON  ks.[K12SchoolId] = k12.K12SchoolId
			AND ISNULL(ks.DataCollectionId, '') = ISNULL(k12.DataCollectionId, '')
			AND ks.[RefIndicatorStatusTypeId] = ist.RefIndicatorStatusTypeId
			AND ks.[RefIndicatorStateDefinedStatusId] = ds.RefIndicatorStateDefinedStatusId
			AND ks.[RefIndicatorStatusSubgroupTypeId] = st.RefIndicatorStatusSubgroupTypeId
			AND ks.[IndicatorStatusSubgroup] = s.IndicatorStatusSubgroup
		WHERE ks.K12SchoolIndicatorStatusId IS NULL 
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12SchoolIndicatorStatus', NULL, 'S01EC3140'
	END CATCH

	-----------------------------------------------------------------------------------------
	--Insert School Custom Indicator Status - SchoolQualityOrStudentSuccessIndicatorStatus --
	-----------------------------------------------------------------------------------------
	BEGIN TRY
		INSERT INTO [dbo].[K12SchoolIndicatorStatus] (
			[K12SchoolId]
			,[RefIndicatorStatusTypeId]
			,[RefIndicatorStateDefinedStatusId]
			,[RefIndicatorStatusSubgroupTypeId]
			,[IndicatorStatusSubgroup]
			,[IndicatorStatus]
			,[RefIndicatorStatusCustomTypeId]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
			,[DataCollectionId]
		)
		SELECT    
			k12.K12SchoolId
			, ist.RefIndicatorStatusTypeId
			, ds.RefIndicatorStateDefinedStatusId
			, st.RefIndicatorStatusSubgroupTypeId
			, s.IndicatorStatusSubgroup
			, CASE 
				WHEN ds.Code = 'STTDEF' THEN s.IndicatorStatus 
				ELSE NULL 
			END
			, cust.RefIndicatorStatusCustomTypeId
			, s.[RecordStartDateTime]
			, s.[RecordEndDateTime]
			, s.DataCollectionId
		FROM [Staging].[OrganizationCustomSchoolIndicatorStatusType] s
		JOIN Staging.K12Organization orgff 
			ON s.School_Identifier_State = orgff.School_Identifier_State 
			AND ISNULL(s.DataCollectionId, '') = ISNULL(orgff.DataCollectionId, '')
		JOIN dbo.K12School k12 
			ON k12.OrganizationId = orgff.OrganizationId_School 
			AND ISNULL(K12.DataCollectionId, '') = ISNULL(orgff.DataCollectionId, '')
		JOIN [dbo].[RefIndicatorStatusType] ist 
			ON ist.Code = s.IndicatorStatusType
		JOIN [dbo].[RefIndicatorStateDefinedStatus] ds 
			ON ds.Code = s.StatedDefinedIndicatorStatus
		JOIN [dbo].[RefIndicatorStatusSubgroupType] st 
			ON st.Code = s.IndicatorStatusSubgroupType
		JOIN [dbo].[RefIndicatorStatusCustomType] cust 
			ON cust.Code = s.StatedDefinedCustomIndicatorStatusType
			--AND cust.RefJurisdictionId = k12.OrganizationId
		LEFT JOIN [dbo].[K12SchoolIndicatorStatus] ks  
			ON  ks.[K12SchoolId] = k12.K12SchoolId
			AND ISNULL(ks.DataCollectionId, '') = ISNULL(k12.DataCollectionId, '')
			AND ks.[RefIndicatorStatusTypeId] = ist.RefIndicatorStatusTypeId
			AND ks.[RefIndicatorStateDefinedStatusId] = ds.RefIndicatorStateDefinedStatusId
			AND ks.[RefIndicatorStatusSubgroupTypeId] = st.RefIndicatorStatusSubgroupTypeId
			AND ks.[IndicatorStatusSubgroup] = s.IndicatorStatusSubgroup
			AND ks.[RefIndicatorStatusCustomTypeId] = cust.RefIndicatorStatusCustomTypeId 
				--AND cust.RefJurisdictionId=k12.OrganizationId
		WHERE ks.K12SchoolIndicatorStatusId IS NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12SchoolIndicatorStatus', NULL, 'S01EC3150'
	END CATCH
	/*
		[Staging].[Migrate_Data_ETL_IMPLEMENTATION_STEP01_Organization_EncapsulatedCode] 2018
	*/

	----------------------------------------------------------------
	-- K12SchoolStatus
	----------------------------------------------------------------
	BEGIN TRY
		----------------------------------------------------------------
		--Insert Progress Achiving English Proficency Indicator Status. 
		----------------------------------------------------------------
		INSERT INTO [dbo].[K12SchoolStatus] (
			[K12SchoolId]
			,[RefMagnetSpecialProgramId]
			,[RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId]
			,[ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatus]
			,[RefTitleISchoolStatusId]
			,[ConsolidatedMepFundsStatus]
			,[RefComprehensiveAndTargetedSupportId]
			,[RefComprehensiveSupportId]
			,[RefTargetedSupportId]
			,[RefSchoolDangerousStatusId]
			,[RefVirtualSchoolStatusId]
			,[RefNSLPStatusId]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
			,[DataCollectionId]
		)
		SELECT    
			k12.K12SchoolId
			,ssmagout.RefMagnetSpecialProgramId	
			,ist.[RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId]
			,CASE
				WHEN ist.Code = 'STTDEF' THEN s.School_ProgressAchievingEnglishLanguageProficiencyStateDefinedStatus
				ELSE NULL
			END
			,sst1.RefTitleISchoolStatusId
			,s.ConsolidatedMepFundsStatus
			,cts.RefComprehensiveAndTargetedSupportId
			,cs.RefComprehensiveSupportId
			,ts.RefTargetedSupportId
			,sd.RefSchoolDangerousStatusId
			,vir.RefVirtualSchoolStatusId
			,nslp.RefNSLPStatusId
			,Staging.GetFiscalYearStartDate(s.SchoolYear) [RecordStartDateTime]
			,Staging.GetFiscalYearEndDate(s.SchoolYear) [RecordEndDateTime]
			,s.DataCollectionId		
		FROM [Staging].[K12Organization] s
		JOIN Staging.K12Organization orgff
			ON s.School_Identifier_State = orgff.School_Identifier_State
				AND ISNULL(s.DataCollectionId, '') = ISNULL(orgff.DataCollectionId, '')
		JOIN dbo.K12School k12
			ON k12.OrganizationId = orgff.OrganizationId_School
				AND ISNULL(k12.DataCollectionId, '') = ISNULL(orgff.DataCollectionId, '')
		LEFT JOIN [dbo].[RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus] ist 
			ON ist.Code = s.School_ProgressAchievingEnglishLanguageProficiencyIndicatorStatus
		LEFT JOIN [Staging].[SourceSystemReferenceData] ssrd
			ON ssrd.InputCode = s.TitleIPartASchoolDesignation 
			AND ssrd.TableName = 'RefTitleISchoolStatus'
			AND ssrd.SchoolYear = s.SchoolYear
		LEFT JOIN [dbo].[RefTitleISchoolStatus] sst1 
			ON sst1.Code = ssrd.OutputCode
		LEFT JOIN [dbo].[RefComprehensiveAndTargetedSupport] cts 
			ON cts.Code = s.School_ComprehensiveAndTargetedSupport
		LEFT JOIN [dbo].[RefComprehensiveSupport] cs 
			ON cs.Code = s.School_ComprehensiveSupport
		LEFT JOIN [dbo].[RefTargetedSupport] ts 
			ON ts.Code = s.School_TargetedSupport
		LEFT JOIN [dbo].[RefSchoolDangerousStatus] sd 
			ON sd.Code = orgff.School_SchoolDangerousStatus
		-- MAGNET SCHOOL
		LEFT JOIN [Staging].[SourceSystemReferenceData] ssmagnet
			ON ssmagnet.InputCode = s.School_MagnetOrSpecialProgramEmphasisSchool 
			AND ssmagnet.TableName = 'RefMagnetSpecialProgram'
			AND ssmagnet.SchoolYear = s.SchoolYear
		LEFT JOIN [dbo].RefMagnetSpecialProgram ssmagout 
			ON ssmagout.Code = ssmagnet.OutputCode
		LEFT JOIN dbo.RefVirtualSchoolStatus vir 
			ON vir.Code = s.School_VirtualSchoolStatus
		LEFT JOIN dbo.RefNSLPStatus nslp 
			ON nslp.Code = s.School_NationalSchoolLunchProgramStatus
		LEFT JOIN [dbo].[K12SchoolStatus] ks 
			ON  ks.[K12SchoolId] = k12.K12SchoolId
		WHERE ks.K12SchoolStatusId IS NULL

		UPDATE ks
		SET 
			[RefTitleISchoolStatusId] = sst1.RefTitleISchoolStatusId
			,[RefComprehensiveAndTargetedSupportId] = cts.RefComprehensiveAndTargetedSupportId
			,[RefComprehensiveSupportId] = cs.RefComprehensiveSupportId
			,[RefTargetedSupportId] = ts.RefTargetedSupportId
			,[RefSchoolDangerousStatusId] = sd.RefSchoolDangerousStatusId
		FROM [Staging].[OrganizationSchoolComprehensiveAndTargetedSupport] s
		JOIN Staging.K12Organization orgff
			ON s.School_Identifier_State = orgff.School_Identifier_State
				AND ISNULL(orgff.DataCollectionId,'') = ISNULL(s.DataCollectionId, '')
		JOIN dbo.K12School k12
			ON k12.OrganizationId = orgff.OrganizationId_School
				AND ISNULL(k12.DataCollectionId, '') = ISNULL(orgff.DataCollectionId, '')
		JOIN [dbo].[K12SchoolStatus] ks
			ON  ks.[K12SchoolId] = k12.K12SchoolId
				AND ISNULL(ks.DataCollectionId, '') = ISNULL(k12.DataCollectionId, '')
		LEFT JOIN [Staging].[SourceSystemReferenceData] ssrd
			ON ssrd.InputCode = orgff.TitleIPartASchoolDesignation 
			AND ssrd.TableName = 'RefTitleISchoolStatus'
			AND ssrd.SchoolYear = orgff.SchoolYear
		LEFT JOIN [dbo].[RefTitleISchoolStatus] sst1 
			ON sst1.Code = ssrd.OutputCode
		LEFT JOIN [dbo].[RefComprehensiveAndTargetedSupport] cts 
			ON cts.Code = s.School_ComprehensiveAndTargetedSupport
		LEFT JOIN [dbo].[RefComprehensiveSupport] cs 
			ON cs.Code = s.School_ComprehensiveSupport
		LEFT JOIN [dbo].[RefTargetedSupport] ts 
			ON ts.Code = s.School_TargetedSupport
		LEFT JOIN [dbo].[RefSchoolDangerousStatus] sd 
			ON sd.Code = orgff.School_SchoolDangerousStatus
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12SchoolStatus', NULL, 'S01EC3160'
	END CATCH

	SET nocount OFF;

	--rollback
END
