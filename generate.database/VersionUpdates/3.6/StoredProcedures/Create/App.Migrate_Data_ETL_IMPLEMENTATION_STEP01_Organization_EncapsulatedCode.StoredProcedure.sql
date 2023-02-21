CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP01_Organization_EncapsulatedCode]
	@SchoolYear SMALLINT = NULL
AS

--    /*************************************************************************************************************
--    Date Created:  5/21/2018
--		[App].[Migrate_Data_ETL_IMPLEMENTATION_STEP01_Organization_EncapsulatedCode] 2018
--    Purpose:
--        The purpose of this ETL is to manage the State Education Agency (SEA), Local Education Agency (LEA),
--        and School organization information in the Generate ODS.  This ETL is run each time the
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
--      EXEC App.[Migrate_Data_ETL_IMPLEMENTATION_STEP01_Organization_EncapsulatedCode] 2018;
--	  Note that this script is called by Migrate_Data_ETL_IMPLEMENTATION_STEP01_Organization and is meant to hide
--	  all non-changing, backend code from the person managing Generate.  
    
--    Modification Log:
--      #	  Date		  Issue#   Description
--      --  ----------  -------  --------------------------------------------------------------------
--      01  05/21/2018           First Release		  	 
--    *************************************************************************************************************/

BEGIN
	SET NOCOUNT ON;
	---------------------------------------------------------------------------------------------------------------------
	-------------------------------------End State Specific Information Section------------------------------------------
	----All code below this point should not be adjusted. It is created to use the staging tables to load the------------
	----the CEDS Operational Data Store.---------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------
	--Set the school year variable if it wasn't passed in
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

	-- Roll the ODS.SourceSystemReferenceData OptionSets into the next school year
	IF (SELECT COUNT(*) FROM ODS.SourceSystemReferenceData WHERE SchoolYear = @SchoolYear) = 0
	BEGIN

		INSERT INTO ODS.SourceSystemReferenceData
		SELECT DISTINCT
		@SchoolYear
		,TableName
		,TableFilter
		,InputCode
		,OutputCode
		FROM ODS.SourceSystemReferenceData
		WHERE SchoolYear = @SchoolYear - 1

	END

    ---------------------------------------------------
    --- Declare Error Handling Variables           ----
    ---------------------------------------------------
	DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP01_Organization_EncapsulatedCode'

	--------------------------------------------------------------
	--- Optimize indexes on Staging tables --- 
	--------------------------------------------------------------
	ALTER INDEX ALL ON Staging.Organization
	REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

	ALTER INDEX ALL ON Staging.OrganizationAddress
	REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

	ALTER INDEX ALL ON Staging.OrganizationGradeOffered
	REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

	ALTER INDEX ALL ON Staging.OrganizationPhone
	REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);


	/* Define all local variables */
	-------------------------------
	DECLARE @OrgTypeId_SEA int = App.GetOrganizationTypeId('SEA', '001156')
	DECLARE @OrgTypeId_Program int = App.GetOrganizationTypeId('Program', '001156')
	
	DECLARE @OrgTypeId_LEA int = App.GetOrganizationTypeId('LEA', '001156')
	DECLARE @OrgTypeId_LEANotFederal int = App.GetOrganizationTypeId('LEANotFederal', '001156')
	DECLARE @OrgTypeId_K12School int = App.GetOrganizationTypeId('K12School', '001156')
	DECLARE @OrgTypeId_K12SchoolNotFederal int = App.GetOrganizationTypeId('K12SchoolNotFederal', '001156')

	DECLARE @OrgIdTypeId_LEA int = App.GetOrganizationIdentifierTypeId('001072')
	DECLARE @OrgIdTypeId_School int = App.GetOrganizationIdentifierTypeId('001073')
	DECLARE @OrgIdTypeId_State int = [App].[GetOrganizationIdentifierTypeId]('001491')

	DECLARE @OrgIdSystemId_LEA_NCES int = [App].[GetOrganizationIdentifierSystemId]('NCES', '001072')
	DECLARE @OrgIdSystemId_School_NCES int = [App].[GetOrganizationIdentifierSystemId]('NCES', '001073')
	DECLARE @OrgIdSystemId_LEA_SEA int = [App].[GetOrganizationIdentifierSystemId]('SEA', '001072')
	DECLARE @OrgIdSystemId_School_SEA int = [App].[GetOrganizationIdentifierSystemId]('SEA', '001073')
	DECLARE @OrgIdSystemId_School_Fed int = [App].[GetOrganizationIdentifierSystemId]('Federal', '001073')
	DECLARE @OrgIdSystemId_State_Fed int = [App].[GetOrganizationIdentifierSystemId]('Federal', '001491')
	DECLARE @OrgIdSystemId_State_State int = [App].[GetOrganizationIdentifierSystemId]('State', '001491')

	DECLARE @LEA_OrganizationId INT
		   ,@SCHOOL_OrganizationId INT
		   ,@LocationId INT
		   ,@SpecialEducationProgram_OrganizationId INT
		   ,@LEA_Identifier_State VARCHAR(100)
		   ,@LEA_Identifier_NCES VARCHAR(100)
		   ,@RecordStartDate DATETIME
		   ,@RecordEndDate DATETIME
		   ,@UpdateDateTime DATETIME
		   ,@ID INT
		   ,@FirstDayOfSchool DATETIME
		   ,@OldRecordStartDate DATETIME		   
		   ,@OldRecordEndDate DATETIME

	SET @RecordStartDate = App.GetFiscalYearStartDate(@SchoolYear);

	SET @OldRecordStartDate = App.GetFiscalYearStartDate(@SchoolYear -1);
		
	SET @RecordEndDate = App.GetFiscalYearEndDate(@SchoolYear);

	SET @OldRecordEndDate = App.GetFiscalYearEndDate(@SchoolYear -1);

	SET @UpdateDateTime = GETDATE()


	--Charter School Authorizer local variables
	DECLARE @CharterSchoolAuthorizerIdentificationSystemId INT
			,@charterSchoolAuthTypeId INT
			,@OrganizationIdentificationSystem INT
			,@PrimaryAuthorizingBodyOrganizationRelationship INT
			,@SecondaryAuthorizingBodyOrganizationRelationship INT

	SET @CharterSchoolAuthorizerIdentificationSystemId = App.GetOrganizationIdentifierSystemId('SEA', '000827')

	SET @charterSchoolAuthTypeId = App.GetOrganizationTypeId('CharterSchoolAuthorizingOrganization','001156')

	SET @OrganizationIdentificationSystem = App.GetOrganizationIdentifierTypeId('000827')

	SELECT	@PrimaryAuthorizingBodyOrganizationRelationship = RefOrganizationRelationshipId 
	FROM	ODS.RefOrganizationRelationship
	WHERE	Code = 'AuthorizingBody'

	SELECT	@SecondaryAuthorizingBodyOrganizationRelationship = RefOrganizationRelationshipId 
	FROM	ODS.RefOrganizationRelationship
	WHERE	Code = 'SecondaryAuthorizingBody'

	---Begin Housekeeping items on the staging table---

	--This section ensures that if state identifers change for the LEA or School and the source data does not contain the old identifier, the change is still
	--picked up by using the NCES ID as the crosswalk between the old and the new. This code is primarily only used when the source system is live and cannot
	--produce historical data for the Organization to show the change from one Identifier to another, but still can show consistency through the NCES ID.

	--This update statement looks for a new state LEA Identifier using the NCES Id as the crosswalk between the staging table Identifier and the Identifier
	--already stored in the ODS.OrganizationIdentifier table.  If they are different and the LEA_Identifier_State_Identifier_Old column in the staging table
	--is NULL, it will mark it with the Identifier stored in the ODS and will later end date that identifier and replace it with the new one.

	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	-----Data Section 1 - Update LEA_Identifier_State_Identifier_Old                         -----
	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	BEGIN TRY

		UPDATE Staging.Organization
		SET LEA_Identifier_State_Identifier_Old = orgid2.Identifier
		FROM ODS.OrganizationIdentifier orgid1
			JOIN ODS.OrganizationIdentifier orgid2 
				ON orgid1.OrganizationId = orgid2.OrganizationId
			JOIN Staging.Organization tod 
				ON orgid1.Identifier = tod.LEA_Identifier_NCES
		WHERE orgid1.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_NCES -- Local Education Agency Identification System'
		AND orgid2.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
		AND orgid1.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
		AND orgid2.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
		AND orgid2.Identifier <> tod.LEA_Identifier_State
		AND tod.LEA_Identifier_NCES IS NOT NULL
		AND tod.LEA_Identifier_State_Identifier_Old IS NULL
		AND tod.LEA_RecordStartDateTime > orgid2.RecordStartDateTime

	END TRY

	BEGIN CATCH 
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEA_Identifier_State_Identifier_Old', 'S01EC0100'
	END CATCH

	--This update statement looks for a new state School Identifier using the NCES Id as the crosswalk between the temporary table Identifier and the Identifier
	--already stored in the ODS.OrganizationIdentifier table.  If they are different and the School_Identifier_State_Identifier_Old column in the temp table
	--is NULL, it will mark it with the Identifier stored in the ODS and will later enddate that identifier and replace it with the new one.
	BEGIN TRY

		UPDATE Staging.Organization
		SET School_Identifier_State_Identifier_Old = orgid2.Identifier
		FROM ODS.OrganizationIdentifier orgid1
			JOIN ODS.OrganizationIdentifier orgid2 
				ON orgid1.OrganizationId = orgid2.OrganizationId
			JOIN Staging.Organization tod 
				ON orgid1.Identifier = tod.School_Identifier_NCES
		WHERE orgid1.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_NCES
		AND orgid2.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
		AND orgid1.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
		AND orgid2.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
		AND orgid2.Identifier <> tod.School_Identifier_State
		AND tod.School_Identifier_NCES IS NOT NULL
		AND tod.School_Identifier_State_Identifier_Old IS NULL
		AND tod.School_RecordStartDateTime > orgid2.RecordStartDateTime

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'School_Identifier_State_Identifier_Old', 'S01EC0110'
	END CATCH

	--Update the Bit value to indicate that an identifier has changed.

	BEGIN TRY
		UPDATE Staging.Organization SET LEA_Identifier_State_ChangedIdentifier = 1 WHERE LEA_Identifier_State_Identifier_Old IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEA_Identifier_State_ChangedIdentifier', 'S01EC0120'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization SET School_Identifier_State_ChangedIdentifier = 1 WHERE School_Identifier_State_Identifier_Old IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'School_Identifier_State_ChangedIdentifier', 'S01EC0130'
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
		IF (SELECT COUNT(*) FROM ODS.OrganizationDetail od join Staging.StateDetail sd on od.Name = sd.SeaName) < 1 BEGIN

			INSERT INTO [ODS].[Organization] DEFAULT VALUES
			UPDATE Staging.StateDetail SET OrganizationId = SCOPE_IDENTITY();

			INSERT INTO [ODS].[OrganizationDetail]
						([OrganizationId]
						,[Name]
						,[RefOrganizationTypeId]
						,[ShortName]
						,[RecordStartDateTime]
						,[RecordEndDateTime])
			SELECT TOP 1
						OrganizationId [OrganizationId]
						,SeaName [Name]
						,@OrgTypeId_SEA [RefOrganizationTypeId] --CEDS code that represents "State Education Agency (SEA)"--
						,SeaShortName [ShortName]
						,RecordStartDateTime [RecordStartDateTime]
						,RecordEndDateTime [RecordEndDateTime]
			FROM Staging.StateDetail

			--Insert StateANSICode into ODS.OrganizationIdentifier-
			INSERT INTO [ODS].[OrganizationIdentifier]
						([Identifier]
						,[RefOrganizationIdentificationSystemId]
						,[OrganizationId]
						,[RefOrganizationIdentifierTypeId]
						,[RecordStartDateTime]
						,[RecordEndDateTime])
			SELECT DISTINCT
						rsa.Code [Identifier] --StateANSICode from RefStateANSICode table--
						,@OrgIdSystemId_State_Fed [RefOrganizationIdentificationSystemId] --Federal identification from the RefOrganizationIdentificationSystem table--
						,sd.OrganizationId [OrganizationId]
						,@OrgIdTypeId_State [RefOrganizationIdentifierTypeId] --State Agency Identification System from the RefOrganizationIdentifierType table --
						,sd.RecordStartDateTime
						,sd.RecordEndDateTime
			FROM Staging.StateDetail sd
			JOIN [ODS].[RefState] rs ON rs.Code = sd.StateCode
			JOIN ODS.RefStateANSICode rsa ON rsa.StateName = rs.[Description]

			--Insert the SEA Identifier provided by the SEA in Staging.Organization into ODS.OrganizationIdentifier-
			INSERT INTO [ODS].[OrganizationIdentifier]
						([Identifier]
						,[RefOrganizationIdentificationSystemId]
						,[OrganizationId]
						,[RefOrganizationIdentifierTypeId]
						,[RecordStartDateTime]
						,[RecordEndDateTime])
			SELECT DISTINCT
						sd.SeaStateIdentifier [Identifier] --StateANSICode from RefStateANSICode table--
						,@OrgIdSystemId_State_State [RefOrganizationIdentificationSystemId] --Federal identification from the RefOrganizationIdentificationSystem table--
						,sd.OrganizationId [OrganizationId]
						,@OrgIdTypeId_State [RefOrganizationIdentifierTypeId] --State Agency Identification System from the RefOrganizationIdentifierType table --
						,sd.RecordStartDateTime
						,sd.RecordEndDateTime
			FROM Staging.StateDetail sd


		-- The SEA Organization already exists,
		-- so grab the org ID.
		END ELSE BEGIN 

		UPDATE Staging.StateDetail 
		SET OrganizationId = od.OrganizationId
		FROM ODS.OrganizationDetail od 
		JOIN Staging.StateDetail sd 
			ON od.[Name] = sd.SeaName
		END
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, NULL, NULL, 'S01EC0140'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization 
		SET SEAOrganizationId = sd.OrganizationId 
		FROM Staging.StateDetail sd
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SEAOrganizationId', 'S01EC0150'
	END CATCH

	-------------------------------------------------------------------
	----Create LEA and School Organization Data -----------------------
	-------------------------------------------------------------------

	/* Insert LEA/K12 School/Special Education Program into ODS.Organization
	------------------------------------------------------------------------
	In this section, the LEA, School and Special Education Programs are created
	as Organizations in the ODS.  And the relationships betweeen the Organizations
	are also created.
	
	*/

	--MERGE LEA data into ODS.Organization

	--First check to see if the LEA already exists so that it is not created a second time.
	BEGIN TRY

		UPDATE Staging.Organization
		SET LEAOrganizationId = ood.OrganizationId
		FROM Staging.Organization so
			JOIN ODS.OrganizationIdentifier ooi 
				ON so.LEA_Identifier_State = ooi.Identifier
			JOIN ODS.OrganizationDetail ood 
				ON ooi.OrganizationId = ood.OrganizationID
		WHERE ood.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
		AND ooi.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
		AND ooi.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAOrganizationId', 'S01EC0160'
	END CATCH

---Everything correct above this line - no additional changes.

	--Insert new LEAs--
	--Get a distinct list of LEA IDs that need to be inserted 
	--so that we can use a MERGE properly.		
	DECLARE @DistinctNewLeas TABLE (
		  LEA_Identifier_State VARCHAR(100)
		, OrganizationId INT NULL
	)

--	BEGIN TRY
		INSERT INTO @DistinctNewLeas
		SELECT DISTINCT 
			  LEA_Identifier_State
			, NULL
		FROM Staging.Organization
		WHERE LeaOrganizationId IS NULL
			AND LEA_Identifier_State IS NOT NULL
--	END TRY

--	BEGIN CATCH
--		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewLeas', NULL, 'S01EC0180'
--	END CATCH


	--This table captures the Staging.LEA_Identifier_State 
	--and the new OrganizationId from ODS.Organization 
	--so that we can create the child records.
	DECLARE @NewLeaOrganization TABLE (
		  OrganizationId INT
		, LEA_Identifier_State VARCHAR(100)
	)

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING @DistinctNewLeas AS SOURCE 
			ON 1 = 0 -- always insert 
		WHEN NOT MATCHED THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.LEA_Identifier_State
		INTO @NewLeaOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC0190'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   LeaOrganizationId = norg.OrganizationId
			, NewLea = 1
		FROM Staging.Organization o
		JOIN @NewLeaOrganization norg
			ON o.LEA_Identifier_State = norg.LEA_Identifier_State
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LeaOrganizationId', 'S01EC0200'
	END CATCH

	BEGIN TRY
		UPDATE @DistinctNewLeas
		SET OrganizationId = o.LeaOrganizationId
		FROM Staging.Organization o
		JOIN @DistinctNewLeas norg
			ON o.Lea_Identifier_State = norg.Lea_Identifier_State
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewLeas', 'OrganizationId', 'S01EC0210'
	END CATCH

---Everything correct above this line - no additional changes.

	BEGIN TRY
		
	--Update LEA Organization Detail Names that need to be corrected. 

		--This will look for any record that has the same OrganizationId and the same
		--RecordStartDateTime and will update it. This is done for the purpose of making corrections to existing data, not for adding
		--new records that change the name. For OrganizationDetail, the only information that is controlled by the SEA is the Name. We
		--do not presently bring in ShortName in the process and the RefOrganizationTypeId is preset based on LEA or School
		UPDATE ods.OrganizationDetail
		SET [Name] = o.Lea_Name
		FROM ods.OrganizationDetail od
		JOIN Staging.Organization o
			ON od.OrganizationId = o.LEAOrganizationId
			AND od.[Name] <> o.LEA_Name
			AND CONVERT(DATE, od.RecordStartDateTime) = CONVERT(DATE, o.LEA_RecordStartDateTime)
		WHERE o.LEA_Identifier_State IS NOT NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ods.OrganizationDetail', 'RecordEndDateTime', 'S01EC0220'
	END CATCH

	
	---Insert the new LEA OrganizationDetail records where there was no existing previous record in the IDS

		--Get a distinct list of LEA Organization Detail records that need to be inserted for the first time
		--so that we can use MERGE properly. This temporary table will exclude records in staging that have the
		--same Organization Detail data as the records that already exist in the ODS, but that have a NULL RecordEndDateTime
		--indicating they are the current record. There is no need to update the current record if the data did not change. 

	DECLARE @DistinctLEAOrganizationDetail TABLE (
		  Organization_Name VARCHAR(100)
		, OrganizationId INT NULL
		, IsReportedFederally BIT NULL
		, RecordStartDateTime DATETIME
		, RecordEndDateTime DATETIME
	)

	BEGIN TRY

		INSERT INTO @DistinctLEAOrganizationDetail
		SELECT DISTINCT
			  so.LEA_Name
			, so.LEAOrganizationId
			, so.LEA_IsReportedFederally
			, so.LEA_RecordStartDateTime
			, so.LEA_RecordEndDateTime
		FROM Staging.Organization so
		WHERE so.LEA_Name IS NOT NULL
			AND so.LEA_RecordStartDateTime IS NOT NULL
			AND so.LEAOrganizationId IS NOT NULL
			AND NOT EXISTS (SELECT 'x'
							FROM ODS.OrganizationDetail ood
							WHERE so.LEA_Name = ood.Name
								AND so.LEAOrganizationId = ood.OrganizationId
								AND ood.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
								AND ood.RecordEndDateTime IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctLEAOrganizationDetail', NULL, 'S01EC0230'
	END CATCH

	BEGIN TRY

		MERGE ODS.OrganizationDetail AS TARGET
		USING @DistinctLEAOrganizationDetail AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
				AND TARGET.[Name] = SOURCE.Organization_Name
				AND TARGET.RecordStartDateTime = SOURCE.RecordStartDateTime
		--When no records are matched, insert
		--the incoming records from source
		--table to target table

		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId, RecordStartDateTime, RecordEndDateTime) 
			VALUES (
				SOURCE.OrganizationId
				, SOURCE.Organization_Name
				, IIF(SOURCE.IsReportedFederally = 0, @OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
				, SOURCE.RecordStartDateTime
				, SOURCE.RecordEndDateTime
				);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC0240'
	END CATCH

	BEGIN TRY
        UPDATE r SET r.RecordEndDateTime = s.RecordStartDateTime - 1
        FROM ODS.OrganizationDetail r
        JOIN (
                SELECT 
                    OrganizationId
					, MAX(OrganizationDetailId) AS OrganizationDetailId
                    , MAX(RecordStartDateTime) AS RecordStartDateTime
                FROM ODS.OrganizationDetail
                WHERE RecordEndDateTime IS NULL
					AND RecordStartDateTime IS NOT NULL
					AND RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
                GROUP BY OrganizationId, OrganizationDetailId, RecordStartDateTime
        ) s ON r.OrganizationId = s.OrganizationId
                AND r.OrganizationDetailId <> s.OrganizationDetailId 
                AND r.RecordEndDateTime IS NULL
				AND r.RecordStartDateTime IS NOT NULL
				AND r.RecordStartDateTime < s.RecordStartDateTime
		WHERE r.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', 'RecordEndDateTime', 'S01EC0250'
	END CATCH


	--Insert K12 Schools into ODS.Organization--

	--First check to see if the School already exists so that it is not created a second time.
	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolOrganizationId = orgd.OrganizationId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationIdentifier orgid 
				ON tod.School_Identifier_State = orgid.Identifier
			JOIN ODS.OrganizationDetail orgd 
				ON orgid.OrganizationId = orgd.OrganizationID
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
		AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
		AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolOrganizationId', 'S01EC0260'
	END CATCH


	--Insert new K12Schools--
	--Get a distinct list of K12School IDs that need to be inserted 
	--so that we can use a MERGE properly.		
	DECLARE @DistinctNewK12Schools TABLE (
		  School_Identifier_State VARCHAR(100)
		, OrganizationId INT NULL
	)

	BEGIN TRY
		INSERT INTO @DistinctNewK12Schools
		SELECT DISTINCT 
			  School_Identifier_State
			, NULL
		FROM Staging.Organization
		WHERE SchoolOrganizationId IS NULL
			AND School_Identifier_State IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewSchools', NULL, 'S01EC0270'
	END CATCH

	DECLARE @NewOrganization TABLE (
		  OrganizationId INT
		, SourceId VARCHAR(100)
	)

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING @DistinctNewK12Schools AS SOURCE 
			ON 1 = 0 -- always insert 
		WHEN NOT MATCHED THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.School_Identifier_State AS SourceId
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC0280'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   SchoolOrganizationId = norg.OrganizationId
			, NewSchool = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.School_Identifier_State = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolOrganizationId', 'S01EC0290'
	END CATCH

	BEGIN TRY
		UPDATE @DistinctNewK12Schools
		SET OrganizationId = o.SchoolOrganizationId
		FROM Staging.Organization o
		JOIN @DistinctNewK12Schools norg
			ON o.School_Identifier_State = norg.School_Identifier_State
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewK12Schools', 'OrganizationId', 'S01EC0300'
	END CATCH


	BEGIN TRY
		
		--Update School names that need to be corrected. This will look for any record that has the same OrganizationId and the same
		--RecordStartDateTime and will update it. This is done for the purpose of making corrections to existing data, not for adding
		--new records that change the name. For OrganizationDetail, the only information that is controlled by the SEA is the Name. We
		--do not presently bring in ShortName in the process and the RefOrganizationTypeId is preset based on LEA or School
		UPDATE ods.OrganizationDetail
		SET [Name] = o.School_Name
		FROM ods.OrganizationDetail od
		JOIN Staging.Organization o
			ON od.OrganizationId = o.SchoolOrganizationId
			AND od.[Name] <> o.School_Name
			AND CONVERT(DATE, od.RecordStartDateTime) = CONVERT(DATE, o.School_RecordStartDateTime)
		WHERE o.School_Identifier_State IS NOT NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ods.OrganizationDetail', 'RecordEndDateTime', 'S01EC0310'
	END CATCH


	---Insert the new School OrganizationDetail records where there was no existing previous record in the IDS

		--Get a distinct list of School Organization Detail records that need to be inserted for the first time
		--so that we can use MERGE properly. This temporary table will exclude records in staging that have the
		--same Organization Detail data as the records that already exist in the ODS, but that have a NULL RecordEndDateTime
		--indicating they are the current record. There is no need to update the current record if the data did not change. 

	DECLARE @DistinctSchoolOrganizationDetail TABLE (
		  Organization_Name VARCHAR(100)
		, OrganizationId INT NULL
		, IsReportedFederally BIT NULL
		, RecordStartDateTime DATETIME
		, RecordEndDateTime DATETIME
	)

	BEGIN TRY

		INSERT INTO @DistinctSchoolOrganizationDetail
		SELECT DISTINCT
			  org.School_Name
			, org.SchoolOrganizationId
			, org.School_IsReportedFederally
			, org.School_RecordStartDateTime
			, org.School_RecordEndDateTime
		FROM Staging.Organization org
		WHERE org.School_Name IS NOT NULL
			AND org.School_RecordStartDateTime IS NOT NULL
			AND org.SchoolOrganizationId IS NOT NULL
			AND NOT EXISTS (SELECT 'x'
							FROM ODS.OrganizationDetail orgd
							WHERE org.School_Name = orgd.Name
								AND org.SchoolOrganizationId = orgd.OrganizationId
								AND orgd.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
								AND orgd.RecordEndDateTime IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctSchoolOrganizationDetail', NULL, 'S01EC0320'
	END CATCH

	BEGIN TRY

		MERGE ODS.OrganizationDetail AS TARGET
		USING @DistinctSchoolOrganizationDetail AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
				AND TARGET.[Name] = SOURCE.Organization_Name
				AND TARGET.[RecordStartDateTime] = SOURCE.RecordStartDateTime
		--When no records are matched, insert
		--the incoming records from source
		--table to target table

		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId, RecordStartDateTime, RecordEndDateTime) 
			VALUES (
				  SOURCE.OrganizationId
				, SOURCE.Organization_Name
				, IIF(SOURCE.IsReportedFederally = 0, @OrgTypeId_K12SchoolNotFederal, @OrgTypeId_K12School)
				, SOURCE.RecordStartDateTime
				, SOURCE.RecordEndDateTime);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC0330'
	END CATCH


	BEGIN TRY
        UPDATE r SET r.RecordEndDateTime = s.RecordStartDateTime - 1
        FROM ODS.OrganizationDetail r
        JOIN (
                SELECT 
                        OrganizationId
						, MAX(OrganizationDetailId) AS OrganizationDetailId
                        , MAX(RecordStartDateTime) AS RecordStartDateTime
                FROM ODS.OrganizationDetail
                WHERE RecordEndDateTime IS NULL
					AND RecordStartDateTime IS NOT NULL
					AND RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
                GROUP BY OrganizationId, OrganizationDetailId, RecordStartDateTime
        ) s ON r.OrganizationId = s.OrganizationId
                AND r.OrganizationDetailId <> s.OrganizationDetailId 
                AND r.RecordEndDateTime IS NULL
				AND r.RecordStartDateTime IS NOT NULL
				AND r.RecordStartDateTime < s.RecordStartDateTime
		WHERE r.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', 'RecordEndDateTime', 'S01EC0335'
	END CATCH

---------------------------------

	----Update the LEA State Identifier's that need to be corrected

	BEGIN TRY

		UPDATE ODS.OrganizationIdentifier
		SET Identifier = org.LEA_Identifier_State, RecordEndDateTime = org.LEA_RecordEndDateTime
		FROM ODS.OrganizationIdentifier orgid
		JOIN Staging.Organization org
			ON orgid.OrganizationId = org.LEAOrganizationId
			AND orgid.RecordStartDateTime = org.LEA_RecordStartDateTime
			AND orgid.Identifier <> org.LEA_Identifier_State
		WHERE orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
			AND org.LEA_RecordStartDateTime IS NOT NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationIdentifier', 'Identifier', 'S01EC0340'
	END CATCH

	----Update the LEA NCES Identifier's that need to be corrected

	BEGIN TRY

		UPDATE ODS.OrganizationIdentifier
		SET Identifier = org.LEA_Identifier_NCES, RecordEndDateTime = org.LEA_RecordEndDateTime
		FROM ODS.OrganizationIdentifier orgid
		JOIN Staging.Organization org
			ON orgid.OrganizationId = org.LEAOrganizationId
			AND orgid.RecordStartDateTime = org.LEA_RecordStartDateTime
			AND orgid.Identifier <> org.LEA_Identifier_NCES
		WHERE orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_NCES
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
			AND org.LEA_RecordStartDateTime IS NOT NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationIdentifier', 'Identifier', 'S01EC0350'
	END CATCH

	----Insert any new LEA State Identifier records using Merge

	--Insert LEA State Identifier--
	--Get a distinct list of LEA State Identifiers that need to be inserted 
	--so that we can use a MERGE properly.	This temporary table will exclude records in staging that have the same
	--Identifier as the record in the ODS, but that have a NULL RecordEndDateTime in the ODS indicating they are
	--the current record. There is no need to update the current record if the data did not change.	
	DECLARE @DistinctNewLeaIdentifierState TABLE (
		  LEA_Identifier_State VARCHAR(100)
		, OrganizationId INT NULL
		, RefOrganizationIdentificationSystemId INT
		, RecordStartDateTime DATETIME
		, RecordEndDateTime DATETIME
	)

	BEGIN TRY
		INSERT INTO @DistinctNewLeaIdentifierState
		SELECT DISTINCT 
			  org.LEA_Identifier_State
			, org.LEAOrganizationId
			, @OrgIdSystemId_LEA_SEA
			, org.LEA_RecordStartDateTime
			, org.LEA_RecordEndDateTime
		FROM Staging.Organization org
		WHERE org.LEA_Identifier_State IS NOT NULL
			AND org.LEA_RecordStartDateTime IS NOT NULL
			AND org.LEAOrganizationId IS NOT NULL
			AND NOT EXISTS (SELECT 'x'
							FROM ODS.OrganizationIdentifier orgid
							WHERE org.LEA_Identifier_State = orgid.Identifier
								AND org.LEAOrganizationId = orgid.OrganizationId
								AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
								AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
								AND orgid.RecordEndDateTime IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewLeaIdentifierState', NULL, 'S01EC0360'
	END CATCH

	BEGIN TRY

		MERGE ODS.OrganizationIdentifier AS TARGET
		USING @DistinctNewLeaIdentifierState AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
				AND TARGET.Identifier = SOURCE.LEA_Identifier_State
				AND TARGET.RefOrganizationIdentificationSystemId = SOURCE.RefOrganizationIdentificationSystemId
				AND TARGET.RecordStartDateTime = SOURCE.RecordStartDateTime
		--When no records are matched, insert
		--the incoming records from source
		--table to target table

		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (Identifier, RefOrganizationIdentificationSystemId, OrganizationId, RefOrganizationIdentifierTypeId, RecordStartDateTime, RecordEndDateTime) 
			VALUES (
				  SOURCE.LEA_Identifier_State
				, @OrgIdSystemId_LEA_SEA
				, SOURCE.OrganizationId
				, @OrgIdTypeId_LEA
				, SOURCE.RecordStartDateTime
				, SOURCE.RecordEndDateTime);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationIdentifier', NULL, 'S01EC0370'
	END CATCH


	----Insert any new LEA NCES Identifier records using Merge

	--Insert LEA NCES Identifier--
	--Get a distinct list of LEA NCES Identifiers that need to be inserted 
	--so that we can use a MERGE properly.	This temporary table will exclude records in staging that have the same
	--Identifier as the record in the ODS, but that have a NULL RecordEndDateTime in the ODS indicating they are
	--the current record. There is no need to update the current record if the data did not change.	
	DECLARE @DistinctNewLeaIdentifierNCES TABLE (
		  LEA_Identifier_NCES VARCHAR(100)
		, OrganizationId INT NULL
		, RefOrganizationIdentificationSystemId INT
		, RecordStartDateTime DATETIME
		, RecordEndDateTime DATETIME
	)

	BEGIN TRY
		INSERT INTO @DistinctNewLeaIdentifierNCES
		SELECT DISTINCT 
			  org.LEA_Identifier_NCES
			, org.LEAOrganizationId
			, @OrgIdSystemId_LEA_NCES
			, org.LEA_RecordStartDateTime
			, org.LEA_RecordEndDateTime
		FROM Staging.Organization org
		WHERE org.LEA_Identifier_NCES IS NOT NULL
			AND org.LEA_RecordStartDateTime IS NOT NULL
			AND org.LEAOrganizationId IS NOT NULL
			AND NOT EXISTS (SELECT 'x'
							FROM ODS.OrganizationIdentifier orgid
							WHERE org.LEA_Identifier_NCES = orgid.Identifier
								AND org.LEAOrganizationId = orgid.OrganizationId
								AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_NCES
								AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
								AND orgid.RecordEndDateTime IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewLeaIdentifierNCES', NULL, 'S01EC0380'
	END CATCH

	BEGIN TRY

		MERGE ODS.OrganizationIdentifier AS TARGET
		USING @DistinctNewLeaIdentifierNCES AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
				AND TARGET.Identifier = SOURCE.LEA_Identifier_NCES
				AND TARGET.RefOrganizationIdentificationSystemId = SOURCE.RefOrganizationIdentificationSystemId
				AND TARGET.RecordStartDateTime = SOURCE.RecordStartDateTime
		--When no records are matched, insert
		--the incoming records from source
		--table to target table

		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (Identifier, RefOrganizationIdentificationSystemId, OrganizationId, RefOrganizationIdentifierTypeId, RecordStartDateTime, RecordEndDateTime) 
			VALUES (
				  SOURCE.LEA_Identifier_NCES
				, @OrgIdSystemId_LEA_NCES
				, SOURCE.OrganizationId
				, @OrgIdTypeId_LEA
				, SOURCE.RecordStartDateTime
				, SOURCE.RecordEndDateTime);

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationIdentifier', NULL, 'S01EC0390'
	END CATCH


	----Update the K12 School State Identifier's that need to be corrected

	BEGIN TRY

		UPDATE ODS.OrganizationIdentifier
		SET Identifier = org.School_Identifier_State, RecordEndDateTime = org.School_RecordEndDateTime
		FROM ODS.OrganizationIdentifier orgid
			JOIN Staging.Organization org
				ON orgid.OrganizationId = org.SchoolOrganizationId
				AND orgid.RecordStartDateTime = org.School_RecordStartDateTime
				AND orgid.Identifier <> org.School_Identifier_State
		WHERE orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
			AND org.School_RecordStartDateTime IS NOT NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationIdentifier', 'Identifier', 'S01EC0400'
	END CATCH


	----Update the K12 School NCES Identifier's that need to be corrected

	BEGIN TRY

		UPDATE ODS.OrganizationIdentifier
		SET Identifier = org.School_Identifier_NCES, RecordEndDateTime = org.School_RecordEndDateTime
		FROM ODS.OrganizationIdentifier orgid
		JOIN Staging.Organization org
			ON orgid.OrganizationId = org.SchoolOrganizationId
			AND orgid.RecordStartDateTime = org.School_RecordStartDateTime
			AND orgid.Identifier <> org.School_Identifier_NCES
		WHERE orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_NCES
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
			AND org.School_RecordStartDateTime IS NOT NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationIdentifier', 'Identifier', 'S01EC0410'
	END CATCH

	----Update the K12 School Federal (Tax) ID's that need to be corrected

	BEGIN TRY

		UPDATE ODS.OrganizationIdentifier
		SET Identifier = org.School_CharterSchoolFEIN, RecordEndDateTime = org.School_RecordEndDateTime
		FROM ODS.OrganizationIdentifier orgid
		JOIN Staging.Organization org
			ON orgid.OrganizationId = org.SchoolOrganizationId
			AND orgid.RecordStartDateTime = org.School_RecordStartDateTime
			AND orgid.Identifier <> org.School_CharterSchoolFEIN
		WHERE orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_Fed
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
			AND org.School_RecordStartDateTime IS NOT NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationIdentifier', 'Identifier', 'S01EC0420'
	END CATCH


	----Insert any new K12 School State Identifier records using Merge

	--Insert School State Identifier--
	--Get a distinct list of School State Identifiers that need to be inserted 
	--so that we can use a MERGE properly.	This temporary table will exclude records in staging that have the same
	--Identifier as the record in the ODS, but that have a NULL RecordEndDateTime in the ODS indicating they are
	--the current record. There is no need to update the current record if the data did not change.		
	DECLARE @DistinctNewSchoolIdentifierState TABLE (
		  School_Identifier_State VARCHAR(100)
		, OrganizationId INT NULL
		, RefOrganizationIdentificationSystemId INT
		, RecordStartDateTime DATETIME
		, RecordEndDateTime DATETIME
	)

	BEGIN TRY
		INSERT INTO @DistinctNewSchoolIdentifierState
		SELECT DISTINCT 
			  org.School_Identifier_State
			, org.SchoolOrganizationId
			, @OrgIdSystemId_School_SEA
			, org.School_RecordStartDateTime
			, org.School_RecordEndDateTime
		FROM Staging.Organization org
		WHERE org.School_Identifier_State IS NOT NULL
			AND org.School_RecordStartDateTime IS NOT NULL
			AND org.SchoolOrganizationId IS NOT NULL
			AND NOT EXISTS (SELECT 'x'
							FROM ODS.OrganizationIdentifier orgid
							WHERE org.School_Identifier_State = orgid.Identifier
								AND org.SchoolOrganizationId = orgid.OrganizationId
								AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
								AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
								AND orgid.RecordEndDateTime IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewSchoolIdentifierState', NULL, 'S01EC0430'
	END CATCH

	BEGIN TRY

		MERGE ODS.OrganizationIdentifier AS TARGET
		USING @DistinctNewSchoolIdentifierState AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
				AND TARGET.Identifier = SOURCE.School_Identifier_State
				AND TARGET.RefOrganizationIdentificationSystemId = SOURCE.RefOrganizationIdentificationSystemId
				AND TARGET.RecordStartDateTime = SOURCE.RecordStartDateTime
		--When no records are matched, insert
		--the incoming records from source
		--table to target table

		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (Identifier, RefOrganizationIdentificationSystemId, OrganizationId, RefOrganizationIdentifierTypeId, RecordStartDateTime, RecordEndDateTime) 
			VALUES (
				  SOURCE.School_Identifier_State
				, @OrgIdSystemId_School_SEA
				, SOURCE.OrganizationId
				, @OrgIdTypeId_School
				, SOURCE.RecordStartDateTime
				, SOURCE.RecordEndDateTime);

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationIdentifier', NULL, 'S01EC0440'
	END CATCH


	----Insert any new K12 NCES Identifier records using Merge

	--Insert School NCES Identifier--
	--Get a distinct list of School NCES Identifiers that need to be inserted 
	--so that we can use a MERGE properly.	This temporary table will exclude records in staging that have the same
	--Identifier as the record in the ODS, but that have a NULL RecordEndDateTime in the ODS indicating they are
	--the current record. There is no need to update the current record if the data did not change.	
	DECLARE @DistinctNewSchoolIdentifierNCES TABLE (
		  School_Identifier_NCES VARCHAR(100)
		, OrganizationId INT NULL
		, RefOrganizationIdentificationSystemId INT
		, RecordStartDateTime DATETIME
		, RecordEndDateTime DATETIME
	)

	BEGIN TRY
		INSERT INTO @DistinctNewSchoolIdentifierNCES
		SELECT DISTINCT 
			  org.School_Identifier_NCES
			, org.SchoolOrganizationId
			, @OrgIdSystemId_School_NCES
			, org.School_RecordStartDateTime
			, org.School_RecordEndDateTime
		FROM Staging.Organization org
		WHERE org.School_Identifier_NCES IS NOT NULL
			AND org.School_RecordStartDateTime IS NOT NULL
			AND org.SchoolOrganizationId IS NOT NULL
			AND NOT EXISTS (SELECT 'x'
							FROM ODS.OrganizationIdentifier orgid
							WHERE org.School_Identifier_NCES = orgid.Identifier
								AND org.SchoolOrganizationId = orgid.OrganizationId
								AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_NCES
								AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
								AND orgid.RecordEndDateTime IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewSchoolIdentifierNCES', NULL, 'S01EC0450'
	END CATCH

	BEGIN TRY

		MERGE ODS.OrganizationIdentifier AS TARGET
		USING @DistinctNewSchoolIdentifierNCES AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
				AND TARGET.Identifier = SOURCE.School_Identifier_NCES
				AND TARGET.RefOrganizationIdentificationSystemId = SOURCE.RefOrganizationIdentificationSystemId
				AND TARGET.RecordStartDateTime = SOURCE.RecordStartDateTime
		--When no records are matched, insert
		--the incoming records from source
		--table to target table

		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (Identifier, RefOrganizationIdentificationSystemId, OrganizationId, RefOrganizationIdentifierTypeId, RecordStartDateTime, RecordEndDateTime) 
			VALUES (
				  SOURCE.School_Identifier_NCES
				, @OrgIdSystemId_School_NCES
				, SOURCE.OrganizationId
				, @OrgIdTypeId_School
				, SOURCE.RecordStartDateTime
				, SOURCE.RecordEndDateTime);

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationIdentifier', NULL, 'S01EC0460'
	END CATCH


	----Insert any new K12 School Federal (Tax) Identifier records using Merge

	--Insert School Federal (Tax) Identifier--
	--Get a distinct list of School Federal (Tax) Identifiers that need to be inserted 
	--so that we can use a MERGE properly.	This temporary table will exclude records in staging that have the same
	--Identifier as the record in the ODS, but that have a NULL RecordEndDateTime in the ODS indicating they are
	--the current record. There is no need to update the current record if the data did not change.		
	DECLARE @DistinctNewSchoolIdentifierFEIN TABLE (
		  School_CharterSchoolFEIN VARCHAR(100)
		, OrganizationId INT NULL
		, RefOrganizationIdentificationSystemId INT
		, RecordStartDateTime DATETIME
		, RecordEndDateTime DATETIME
	)

	BEGIN TRY
		INSERT INTO @DistinctNewSchoolIdentifierFEIN
		SELECT DISTINCT 
			  org.School_CharterSchoolFEIN
			, org.SchoolOrganizationId
			, @OrgIdSystemId_School_Fed
			, org.School_RecordStartDateTime
			, org.School_RecordEndDateTime
		FROM Staging.Organization org
		WHERE org.School_CharterSchoolFEIN IS NOT NULL
			AND org.School_RecordStartDateTime IS NOT NULL
			AND org.SchoolOrganizationId IS NOT NULL
			AND NOT EXISTS (SELECT 'x'
							FROM ODS.OrganizationIdentifier orgid
							WHERE org.School_CharterSchoolFEIN = orgid.Identifier
								AND org.SchoolOrganizationId = orgid.OrganizationId
								AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_Fed
								AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
								AND orgid.RecordEndDateTime IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewSchoolIdentifierState', NULL, 'S01EC0470'
	END CATCH

	BEGIN TRY

		MERGE ODS.OrganizationIdentifier AS TARGET
		USING @DistinctNewSchoolIdentifierFEIN AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
				AND TARGET.Identifier = SOURCE.School_CharterSchoolFEIN
				AND TARGET.RefOrganizationIdentificationSystemId = SOURCE.RefOrganizationIdentificationSystemId
				AND TARGET.RecordStartDateTime = SOURCE.RecordStartDateTime
		--When no records are matched, insert
		--the incoming records from source
		--table to target table

		WHEN NOT MATCHED BY TARGET THEN 
			INSERT (Identifier, RefOrganizationIdentificationSystemId, OrganizationId, RefOrganizationIdentifierTypeId, RecordStartDateTime, RecordEndDateTime) 
			VALUES (
				  SOURCE.School_CharterSchoolFEIN
				, @OrgIdSystemId_School_Fed
				, SOURCE.OrganizationId
				, @OrgIdTypeId_School
				, SOURCE.RecordStartDateTime
				, SOURCE.RecordEndDateTime);

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationIdentifier', NULL, 'S01EC0480'
	END CATCH


	-- End Date any records prior to the current record for OrganizationIdentifier that do not have a date. This will end date both LEA and School
	-- Identifiers for all types of Identifiers

	BEGIN TRY
        UPDATE r SET r.RecordEndDateTime = s.RecordStartDateTime - 1
        FROM ODS.OrganizationIdentifier r
        JOIN (
                SELECT 
                        OrganizationId
						, RefOrganizationIdentificationSystemId
						, RefOrganizationIdentifierTypeId
						, MAX(OrganizationIdentifierId) AS OrganizationIdentifierId
                        , MAX(RecordStartDateTime) AS RecordStartDateTime
                FROM ODS.OrganizationIdentifier
                WHERE RecordEndDateTime IS NULL
					AND RecordStartDateTime IS NOT NULL
                GROUP BY OrganizationId, RefOrganizationIdentificationSystemId, RefOrganizationIdentifierTypeId, OrganizationIdentifierId, RecordStartDateTime
        ) s ON r.OrganizationId = s.OrganizationId
				AND r.RefOrganizationIdentificationSystemId = s.RefOrganizationIdentificationSystemId
				AND r.RefOrganizationIdentifierTypeId = s.RefOrganizationIdentifierTypeId
                AND r.OrganizationIdentifierId <> s.OrganizationIdentifierId 
                AND r.RecordEndDateTime IS NULL
				AND r.RecordStartDateTime IS NOT NULL
				AND r.RecordStartDateTime < s.RecordStartDateTime
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationIdentifier', 'RecordEndDateTime', 'S01EC0485'
	END CATCH


	----------------------------------------------------------------------------------------
	--Create a Special Education Program for each ODS.Organization (LEA and School)---------
	----------------------------------------------------------------------------------------

	--LEA
	--First check to see if Special Education Program already exists so that it is not created a second time--
	BEGIN TRY
		UPDATE Staging.Organization
		SET LEA_SpecialEducationProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationIdentifier orgid 
			ON tod.LEA_Identifier_State = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
		JOIN ODS.OrganizationRelationship orgr 
			ON orgd.OrganizationId = orgr.Parent_OrganizationId
		JOIN ODS.OrganizationDetail orgd2 
			ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
			AND orgd2.Name = 'Special Education Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SpecialEducationProgramOrganizationId', 'S01EC0490'
	END CATCH

	--Insert new Special Education Programs--

	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC0500'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING @DistinctNewLeas AS SOURCE 
			ON 1 = 0
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.OrganizationId
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC0510'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET LEA_SpecialEducationProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.LEAOrganizationId = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SpecialEducationProgramOrganizationId', 'S01EC0520'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING @NewOrganization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.OrganizationId
				, 'Special Education Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC0530'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   LEA_SpecialEducationProgramOrganizationId = norg.OrganizationId
			, NewSpecialEducationProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.LEAOrganizationId = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SpecialEducationProgramOrganizationId', 'S01EC0540'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT LEA_SpecialEducationProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC0550'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT LEA_SpecialEducationProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC0560'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT LEA_SpecialEducationProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC0570'
	END CATCH

	BEGIN TRY
		--School
		--First check to see if Special Education Program already exists so that it is not created a second time--
		UPDATE Staging.Organization
		SET School_SpecialEducationProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationIdentifier orgid 
				ON tod.School_Identifier_State = orgid.Identifier
			JOIN ODS.OrganizationDetail orgd 
				ON orgid.OrganizationId = orgd.OrganizationID
			JOIN ODS.OrganizationRelationship orgr 
				ON orgd.OrganizationId = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd2 
				ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
			AND orgd2.Name = 'Special Education Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SpecialEducationProgramOrganizationId', 'S01EC0580'
	END CATCH

	--Insert new Special Education Programs--

	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC0590'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_SpecialEducationProgramOrganizationId
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.Id
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC0600'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET School_SpecialEducationProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SpecialEducationProgramOrganizationId', 'S01EC0610'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_SpecialEducationProgramOrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.School_SpecialEducationProgramOrganizationId
				, 'Special Education Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC0620'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   School_SpecialEducationProgramOrganizationId = norg.OrganizationId
			, NewSpecialEducationProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SpecialEducationProgramOrganizationId', 'S01EC0630'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT School_SpecialEducationProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC0640'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT School_SpecialEducationProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC06050'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT School_SpecialEducationProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC0660'
	END CATCH

	--------------------------------------------
	---End Special Education Program Creation---
	--------------------------------------------

	----------------------------------------------------------------------------------------
	--Create a Neglected or Delinquent Program for each ODS.Organization (LEA and School)---------
	----------------------------------------------------------------------------------------

	--LEA
	--First check to see if Neglected or Delinquent Program already exists so that it is not created a second time--
	BEGIN TRY
		UPDATE Staging.Organization
		SET LEA_NorDProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationIdentifier orgid 
			ON tod.LEA_Identifier_State = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
		JOIN ODS.OrganizationRelationship orgr 
			ON orgd.OrganizationId = orgr.Parent_OrganizationId
		JOIN ODS.OrganizationDetail orgd2 
			ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
			AND orgd2.Name = 'N or D Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEA_NorProgramOrganizationId', 'S01EC0670'
	END CATCH

	--Insert new N or D Programs--

	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC0680'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING @DistinctNewLeas AS SOURCE 
			ON 1 = 0
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.OrganizationId
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC0690'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET LEA_NorDProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.LEAOrganizationId = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEA_NorDProgramOrganizationId', 'S01EC0700'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING @NewOrganization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.OrganizationId
				, 'N or D Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC0710'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   LEA_NorDProgramOrganizationId = norg.OrganizationId
			, NewNorDProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.LEAOrganizationId = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEA_NorDProgramOrganizationId', 'S01EC0720'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT LEA_NorDProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC0730'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT LEA_NorDProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC0740'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT LEA_NorDProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC0750'
	END CATCH

	BEGIN TRY
		--School
		--First check to see if a Neglected or Delinquent Program already exists so that it is not created a second time--
		UPDATE Staging.Organization
		SET School_NorDProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationIdentifier orgid 
				ON tod.School_Identifier_State = orgid.Identifier
			JOIN ODS.OrganizationDetail orgd 
				ON orgid.OrganizationId = orgd.OrganizationID
			JOIN ODS.OrganizationRelationship orgr 
				ON orgd.OrganizationId = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd2 
				ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
			AND orgd2.Name = 'N or D Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'School_NorProgramOrganizationId', 'S01EC0760'
	END CATCH

	--Insert new N or D Programs--
	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC0770'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_NorDProgramOrganizationId
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.Id
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC0780'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET School_NorDProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'School_NorProgramOrganizationId', 'S01EC0790'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_NorDProgramOrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.School_NorDProgramOrganizationId --
				, 'N or D Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC0800'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   School_NorDProgramOrganizationId = norg.OrganizationId
			, NewNorDProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'School_NorProgramOrganizationId', 'S01EC0810'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT School_NorDProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC0820'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT School_NorDProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC0830'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT School_NorDProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC0840'
	END CATCH


	-----------------------------------------------
	---End Neglected Delinquent Program Creation---
	-----------------------------------------------

	----------------------------------------------------------------------------------------
	--Create a Title III Program for each ODS.Organization (LEA and School)---------
	----------------------------------------------------------------------------------------

	BEGIN TRY
		--First check to see if an LEA Title III Program already exists so that it is not created a second time--
		-- LEA
		UPDATE Staging.Organization
		SET LEA_TitleIIIProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationIdentifier orgid 
			ON tod.School_Identifier_State = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
		JOIN ODS.OrganizationRelationship orgr 
			ON orgd.OrganizationId = orgr.Parent_OrganizationId
		JOIN ODS.OrganizationDetail orgd2 
			ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
			AND orgd2.Name = 'Title III Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'TitleIIIProgramOrganizationId', 'S01EC0850'
	END CATCH


	--Insert new TitleIII Programs--

	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC0860'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.LEA_TitleIIIProgramOrganizationId
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.Id
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC0870'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET LEA_TitleIIIProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.LeaOrganizationid = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', NULL, 'S01EC0880'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING @NewOrganization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.OrganizationId
				, 'Title III Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC0890'
	END CATCH

	--BEGIN TRY
	--	INSERT INTO ODS.OrganizationProgramType
	--		(OrganizationId
	--		 , RefProgramTypeId
	--		 , RecordStartDateTime, RecordEndDateTime)
	--	SELECT norg.OrganizationId, App.GetProgramTypeId('04906'), @RecordStartDate, @RecordEndDate 
	--	FROM @NewOrganization norg
	--END TRY

	--BEGIN CATCH
	--	EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationProgramType', NULL, 'S01EC0900'
	--END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   LEA_TitleIIIProgramOrganizationId = norg.OrganizationId
			, NewTitleIIIProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'TitleIIIProgramOrganizationId', 'S01EC0910'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT LEA_TitleIIIProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC0920'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT LEA_TitleIIIProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC0930'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT LEA_TitleIIIProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC0940'
	END CATCH

	BEGIN TRY
		--First check to see if a School Title III Program already exists so that it is not created a second time--
		-- School
		UPDATE Staging.Organization
		SET School_TitleIIIProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationIdentifier orgid 
				ON tod.School_Identifier_State = orgid.Identifier
			JOIN ODS.OrganizationDetail orgd 
				ON orgid.OrganizationId = orgd.OrganizationID
			JOIN ODS.OrganizationRelationship orgr 
				ON orgd.OrganizationId = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd2 
				ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
			AND orgd2.Name = 'Title III Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'TitleIIIProgramOrganizationId', 'S01EC0950'
	END CATCH

	--Insert new TitleIII Programs--

	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC0960'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_TitleIIIProgramOrganizationId
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.Id
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC0970'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET School_TitleIIIProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'TitleIIIProgramOrganizationId', 'S01EC0980'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_TitleIIIProgramOrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.School_TitleIIIProgramOrganizationId
				, 'Title III Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC0990'
	END CATCH

	--BEGIN TRY
	--	INSERT INTO ODS.OrganizationProgramType
	--		(OrganizationId
	--		 , RefProgramTypeId
	--		 , RecordStartDateTime, RecordEndDateTime)
	--	SELECT norg.OrganizationId, App.GetProgramTypeId('04906'), @RecordStartDate, @RecordEndDate 
	--	FROM @NewOrganization norg
	--END TRY

	--BEGIN CATCH
	--	EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationProgramType', NULL, 'S01EC1000'
	--END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   School_TitleIIIProgramOrganizationId = norg.OrganizationId
			, NewTitleIIIProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'TitleIIIProgramOrganizationId', 'S01EC1010'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT School_TitleIIIProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1020'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT School_TitleIIIProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1030'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT School_TitleIIIProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1040'
	END CATCH

	-----------------------------------------------
	---End Title III Program Creation--------------
	-----------------------------------------------

	----------------------------------------------------------------------------------------
	--Create a CTE Program for each ODS.Organization (LEA and School)---------
	----------------------------------------------------------------------------------------

	BEGIN TRY
		-- First check to see if an LEA CTE Program already exists so that it is not created a second time--
		-- LEA
		UPDATE Staging.Organization
		SET LEA_CTEProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationIdentifier orgid 
			ON tod.School_Identifier_State = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
		JOIN ODS.OrganizationRelationship orgr 
			ON orgd.OrganizationId = orgr.Parent_OrganizationId
		JOIN ODS.OrganizationDetail orgd2 
			ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
			AND orgd2.Name = 'CTE Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'CTEProgramOrganizationId', 'S01EC1050'
	END CATCH


	--Insert new CTE Programs--

	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1060'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.LEA_CTEProgramOrganizationId
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.Id
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1070'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET LEA_CTEProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.LeaOrganizationid = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', NULL, 'S01EC1080'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING @NewOrganization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.OrganizationId
				, 'CTE Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1090'
	END CATCH

	--BEGIN TRY
	--	INSERT INTO ODS.OrganizationProgramType
	--		(OrganizationId
	--		 , RefProgramTypeId
	--		 , RecordStartDateTime, RecordEndDateTime)
	--	SELECT norg.OrganizationId, App.GetProgramTypeId('04906'), @RecordStartDate, @RecordEndDate 
	--	FROM @NewOrganization norg
	--END TRY

	--BEGIN CATCH
	--	EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationProgramType', NULL, 'S01EC1100'
	--END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   LEA_CTEProgramOrganizationId = norg.OrganizationId
			, NewCTEProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'CTEProgramOrganizationId', 'S01EC1110'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT LEA_CTEProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1120'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT LEA_CTEProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1130'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT LEA_CTEProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1140'
	END CATCH

	BEGIN TRY
		-- First check to see if a School CTE Program already exists so that it is not created a second time--
		-- School
		UPDATE Staging.Organization
		SET School_CTEProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationIdentifier orgid 
				ON tod.School_Identifier_State = orgid.Identifier
			JOIN ODS.OrganizationDetail orgd 
				ON orgid.OrganizationId = orgd.OrganizationID
			JOIN ODS.OrganizationRelationship orgr 
				ON orgd.OrganizationId = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd2 
				ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
			AND orgd2.Name = 'CTE Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'CTEProgramOrganizationId', 'S01EC1150'
	END CATCH

	--Insert new CTE Programs--

	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1160'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_CTEProgramOrganizationId
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.Id
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1170'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET School_CTEProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'CTEProgramOrganizationId', 'S01EC1180'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_CTEProgramOrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.School_CTEProgramOrganizationId
				, 'CTE Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1190'
	END CATCH

	--BEGIN TRY
	--	INSERT INTO ODS.OrganizationProgramType
	--		(OrganizationId
	--		 , RefProgramTypeId
	--		 , RecordStartDateTime, RecordEndDateTime)
	--	SELECT norg.OrganizationId, App.GetProgramTypeId('04906'), @RecordStartDate, @RecordEndDate 
	--	FROM @NewOrganization norg
	--END TRY

	--BEGIN CATCH
	--	EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationProgramType', NULL, 'S01EC1200'
	--END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   School_CTEProgramOrganizationId = norg.OrganizationId
			, NewCTEProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'CTEProgramOrganizationId', 'S01EC1210'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT School_CTEProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1220'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT School_CTEProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1230'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT School_CTEProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1240'
	END CATCH

	-----------------------------------------------
	---End CTE Program Creation--------------------
	-----------------------------------------------


	----------------------------------------------------------------------------------------
	--Create a Title I Program for each ODS.Organization (LEA and School)-------------------
	----------------------------------------------------------------------------------------

	BEGIN TRY
		--First check to see if an LEA Title I Program already exists so that it is not created a second time--
		-- LEA
		UPDATE Staging.Organization
		SET LEA_TitleIProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationIdentifier orgid 
			ON tod.LEA_Identifier_State = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
		JOIN ODS.OrganizationRelationship orgr 
			ON orgd.OrganizationId = orgr.Parent_OrganizationId
		JOIN ODS.OrganizationDetail orgd2 
			ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
			AND orgd2.Name = 'Title I Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'TitleIProgramOrganizationId', 'S01EC1250'
	END CATCH

	BEGIN TRY
		--Insert new Title I Programs--
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1260'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.LEA_TitleIProgramOrganizationId
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.Id
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1270'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET LEA_TitleIProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.LeaOrganizationid = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'TitleIProgramOrganizationId', 'S01EC1280'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING @NewOrganization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.OrganizationId
				, 'Title I Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1290'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   LEA_TitleIProgramOrganizationId = norg.OrganizationId
			, NewTitleIProgram= 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'TitleIProgramOrganizationId', 'S01EC1300'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT LEA_TitleIProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1310'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT LEA_TitleIProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1320'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT LEA_TitleIProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1330'
	END CATCH


	BEGIN TRY
		--First check to see if Title I Program already exists so that it is not created a second time--
		-- School
		UPDATE Staging.Organization
		SET School_TitleIProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationIdentifier orgid 
			ON tod.School_Identifier_State = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
		JOIN ODS.OrganizationRelationship orgr 
			ON orgd.OrganizationId = orgr.Parent_OrganizationId
		JOIN ODS.OrganizationDetail orgd2 
			ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
			AND orgd2.Name = 'Title I Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'TitleIProgramOrganizationId', 'S01EC1340'
	END CATCH

	--Insert new Title I Programs--

	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1350'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_TitleIProgramOrganizationId
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.Id
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1360'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET School_TitleIProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'TitleIProgramOrganizationId', 'S01EC1370'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_TitleIProgramOrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.School_TitleIProgramOrganizationId
				, 'Title I Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1380'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   School_TitleIProgramOrganizationId = norg.OrganizationId
			, NewTitleIProgram= 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'TitleIProgramOrganizationId', 'S01EC1390'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT School_TitleIProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1400'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT School_TitleIProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1410'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT School_TitleIProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1420'
	END CATCH

	--------------------------------------
	---End Title I Program Creation ------
	--------------------------------------

	----------------------------------------------------------------------------------------
	--Create a Migrant Program for each ODS.Organization (LEA and School)---------
	----------------------------------------------------------------------------------------

	BEGIN TRY 
		-- First check to see if an LEA Migrant Program already exists so that it is not created a second time--
		-- LEA
		UPDATE Staging.Organization
		SET LEA_MigrantProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationIdentifier orgid 
			ON tod.LEA_Identifier_State = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
		JOIN ODS.OrganizationRelationship orgr 
			ON orgd.OrganizationId = orgr.Parent_OrganizationId
		JOIN ODS.OrganizationDetail orgd2 
			ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
			AND orgd2.Name = 'Migrant Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'MigrantProgramOrganizationId', 'S01EC1430'
	END CATCH

	--Insert new Migrant Programs--

	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1440'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING @DistinctNewLeas AS SOURCE 
			ON 1 = 0
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.OrganizationId
		INTO @NewOrganization;
	END TRY
	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1450'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET LEA_MigrantProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'MigrantProgramOrganizationId', 'S01EC1460'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING @NewOrganization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.OrganizationId
				, 'Migrant Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1470'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET  LEA_MigrantProgramOrganizationId = norg.OrganizationId
			, NewMigrantProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.LeaOrganizationid = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'MigrantProgramOrganizationId', 'S01EC1480'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT LEA_MigrantProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1490'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT LEA_MigrantProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1500'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT LEA_MigrantProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1510'
	END CATCH


	BEGIN TRY
		-- First check to see if a School Migrant Program already exists so that it is not created a second time--
		-- School
		UPDATE Staging.Organization
		SET School_MigrantProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationIdentifier orgid 
			ON tod.School_Identifier_State = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
		JOIN ODS.OrganizationRelationship orgr 
			ON orgd.OrganizationId = orgr.Parent_OrganizationId
		JOIN ODS.OrganizationDetail orgd2 
			ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
			AND orgd2.[Name] = 'Migrant Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'MigrantProgramOrganizationId', 'S01EC1520'
	END CATCH

	--Insert new Migrant Programs--
	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1530'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_MigrantProgramOrganizationId
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.Id
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1540'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET School_MigrantProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'MigrantProgramOrganizationId', 'S01EC1550'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_MigrantProgramOrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.School_MigrantProgramOrganizationId
				, 'Migrant Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1560'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   School_MigrantProgramOrganizationId = norg.OrganizationId
			, NewMigrantProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'MigrantProgramOrganizationId', 'S01EC1570'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT School_MigrantProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1580'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT School_MigrantProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1590'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT School_MigrantProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1600'
	END CATCH

	-----------------------------------
	---End Migrant Program Creation ---
	-----------------------------------

	----------------------------------------------------------------------------------------
	--Create a Foster Program for each ODS.Organization (LEA and School)---------
	----------------------------------------------------------------------------------------

	BEGIN TRY
		-- First check to see if an LEA Foster Program already exists so that it is not created a second time--
		-- LEA
		UPDATE Staging.Organization
		SET LEA_FosterProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationIdentifier orgid 
			ON tod.LEA_Identifier_State = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
		JOIN ODS.OrganizationRelationship orgr 
			ON orgd.OrganizationId = orgr.Parent_OrganizationId
		JOIN ODS.OrganizationDetail orgd2 
			ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
			AND orgd2.Name = 'Foster Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'FosterProgramOrganizationId', 'S01EC1610'
	END CATCH

	--Insert new Foster Programs--
	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1620'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING @DistinctNewLeas AS SOURCE 
			ON 1 = 0
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.OrganizationId
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1630'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET LEA_FosterProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'FosterProgramOrganizationId', 'S01EC1640'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING @NewOrganization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.OrganizationId
				, 'Foster Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1650'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   LEA_FosterProgramOrganizationId = norg.OrganizationId
			, NewFosterProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.LeaOrganizationid = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'FosterProgramOrganizationId', 'S01EC1660'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT LEA_FosterProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1670'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT LEA_FosterProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1680'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT LEA_FosterProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1690'
	END CATCH
 


	BEGIN TRY
		-- First check to see if a School Foster Program already exists so that it is not created a second time--
		-- School
		UPDATE Staging.Organization
		SET School_FosterProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationIdentifier orgid 
				ON tod.School_Identifier_State = orgid.Identifier
			JOIN ODS.OrganizationDetail orgd 
				ON orgid.OrganizationId = orgd.OrganizationID
			JOIN ODS.OrganizationRelationship orgr 
				ON orgd.OrganizationId = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd2 
				ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
			AND orgd2.Name = 'Foster Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'FosterProgramOrganizationId', 'S01EC1700'
	END CATCH


	--Insert new Foster Programs--
	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1710'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_FosterProgramOrganizationId
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.Id
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1720'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET School_FosterProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'FosterProgramOrganizationId', 'S01EC1730'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_FosterProgramOrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.School_FosterProgramOrganizationId
				, 'Foster Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1740'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   School_FosterProgramOrganizationId = norg.OrganizationId
			, NewFosterProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'FosterProgramOrganizationId', 'S01EC1750'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT School_FosterProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1760'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT School_FosterProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1770'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT School_FosterProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1780'
	END CATCH

	--------------------------------------
	--- End Foster Program Creation ------
	--------------------------------------

	----------------------------------------------------------------------------------------
	--Create a Section 504 Program for each ODS.Organization (LEA and School)---------
	----------------------------------------------------------------------------------------
	-- LEA

	BEGIN TRY
		--First check to see if an LEA Section 504 Program already exists so that it is not created a second time--
		UPDATE Staging.Organization
		SET LEA_Section504ProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationIdentifier orgid 
			ON tod.LEA_Identifier_State = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
		JOIN ODS.OrganizationRelationship orgr 
			ON orgd.OrganizationId = orgr.Parent_OrganizationId
		JOIN ODS.OrganizationDetail orgd2 
			ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
			AND orgd2.Name = 'Section 504 Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'Section504ProgramOrganizationId', 'S01EC1790'
	END CATCH

	--Insert new Section 504 Programs--
	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1800'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING @DistinctNewLeas AS SOURCE 
			ON 1 = 0
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.OrganizationId
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1810'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET LEA_Section504ProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'Section504ProgramOrganizationId', 'S01EC1820'
	END CATCH
	
	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING @NewOrganization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.OrganizationId
				, 'Section 504 Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1830'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   LEA_Section504ProgramOrganizationId = norg.OrganizationId
			, NewSection504Program = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.LeaOrganizationid = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'Section504ProgramOrganizationId', 'S01EC1840'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT LEA_Section504ProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1850'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT LEA_Section504ProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1860'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT LEA_Section504ProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1870'
	END CATCH
 
	-- School

	--First check to see if a School Section 504 Program already exists so that it is not created a second time--
	BEGIN TRY
		UPDATE Staging.Organization
		SET School_Section504ProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationIdentifier orgid 
				ON tod.School_Identifier_State = orgid.Identifier
			JOIN ODS.OrganizationDetail orgd 
				ON orgid.OrganizationId = orgd.OrganizationID
			JOIN ODS.OrganizationRelationship orgr 
				ON orgd.OrganizationId = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd2 
				ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
			AND orgd2.Name = 'Section 504 Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'Section504ProgramOrganizationId', 'S01EC1880'
	END CATCH


	--Insert new Section 504 Programs--
	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1890'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_Section504ProgramOrganizationId
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.Id
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1900'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET School_Section504ProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'Section504ProgramOrganizationId', 'S01EC1910'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_Section504ProgramOrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.School_Section504ProgramOrganizationId
				, 'Section 504 Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1920'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   School_Section504ProgramOrganizationId = norg.OrganizationId
			, NewSection504Program = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'Section504ProgramOrganizationId', 'S01EC1930'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT School_Section504ProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1940'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT School_Section504ProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1950'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT School_Section504ProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1960'
	END CATCH

	--------------------------------------
	---- End Section 504 Creation --------
	--------------------------------------

	----------------------------------------------------------------------------------------
	--Create an Immigrant Program for each ODS.Organization (LEA and School)---------
	----------------------------------------------------------------------------------------
	-- LEA

	BEGIN TRY
		--First check to see if an LEA Immigrant Program already exists so that it is not created a second time--
		UPDATE Staging.Organization
		SET LEA_ImmigrantProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationIdentifier orgid 
			ON tod.LEA_Identifier_State = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
		JOIN ODS.OrganizationRelationship orgr 
			ON orgd.OrganizationId = orgr.Parent_OrganizationId
		JOIN ODS.OrganizationDetail orgd2 
			ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
			AND orgd2.Name = 'Immigrant Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'ImmigrantProgramOrganizationId', 'S01EC1962'
	END CATCH

	--Insert new Immigrant Programs--
	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1964'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING @DistinctNewLeas AS SOURCE 
			ON 1 = 0
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.OrganizationId
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1966'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET LEA_ImmigrantProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'ImmigrantProgramOrganizationId', 'S01EC1968'
	END CATCH
	
	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING @NewOrganization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.OrganizationId
				, 'Immigrant Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1970'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   LEA_ImmigrantProgramOrganizationId = norg.OrganizationId
			, NewImmigrantProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.LeaOrganizationid = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'ImmigrantProgramOrganizationId', 'S01EC1972'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT LEA_ImmigrantProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1974'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT LEA_ImmigrantProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1976'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT LEA_ImmigrantProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1978'
	END CATCH
 
	-- School

	--First check to see if a School Immigrant Program already exists so that it is not created a second time--
	BEGIN TRY
		UPDATE Staging.Organization
		SET School_ImmigrantProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationIdentifier orgid 
				ON tod.School_Identifier_State = orgid.Identifier
			JOIN ODS.OrganizationDetail orgd 
				ON orgid.OrganizationId = orgd.OrganizationID
			JOIN ODS.OrganizationRelationship orgr 
				ON orgd.OrganizationId = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd2 
				ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
			AND orgd2.Name = 'Immigrant Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'ImmigrantProgramOrganizationId', 'S01EC1980'
	END CATCH


	--Insert new Immigrant Programs--
	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1982'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_ImmigrantProgramOrganizationId
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.Id
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1984'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET School_ImmigrantProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'ImmigrantProgramOrganizationId', 'S01EC1986'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_ImmigrantProgramOrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.School_ImmigrantProgramOrganizationId
				, 'Immigrant Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1988'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   School_ImmigrantProgramOrganizationId = norg.OrganizationId
			, NewImmigrantProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'ImmigrantProgramOrganizationId', 'S01EC1990'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT School_ImmigrantProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC1992'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT School_ImmigrantProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC1994'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT School_ImmigrantProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC1996'
	END CATCH

	--------------------------------------
	---- End Immigrant Creation --------
	--------------------------------------

	----------------------------------------------------------------------------------------
	--Create a Homeless Program for each ODS.Organization (LEA and School)---------
	----------------------------------------------------------------------------------------
	-- LEA

	BEGIN TRY
		--First check to see if an LEA Homeless Program already exists so that it is not created a second time--
		UPDATE Staging.Organization
		SET LEA_HomelessProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationIdentifier orgid 
			ON tod.LEA_Identifier_State = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd 
			ON orgid.OrganizationId = orgd.OrganizationID
		JOIN ODS.OrganizationRelationship orgr 
			ON orgd.OrganizationId = orgr.Parent_OrganizationId
		JOIN ODS.OrganizationDetail orgd2 
			ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
			AND orgd2.Name = 'Homeless Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'HomelessProgramOrganizationId', 'S01EC1998'
	END CATCH

	--Insert new Homeless Programs--
	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC2000'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING @DistinctNewLeas AS SOURCE 
			ON 1 = 0
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.OrganizationId
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC2002'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET LEA_HomelessProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'HomelessProgramOrganizationId', 'S01EC2004'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING @NewOrganization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.OrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.OrganizationId
				, 'Homeless Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC2010'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   LEA_HomelessProgramOrganizationId = norg.OrganizationId
			, NewHomelessProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.LeaOrganizationid = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'HomelessProgramOrganizationId', 'S01EC2020'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT LEA_HomelessProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC2030'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT LEA_HomelessProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC2040'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT LEA_HomelessProgramOrganizationId
				FROM Staging.Organization
				WHERE LEA_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC2050'
	END CATCH
 
	-- School

	--First check to see if a School Homeless Program already exists so that it is not created a second time--
	BEGIN TRY
		UPDATE Staging.Organization
		SET School_HomelessProgramOrganizationId = orgd2.OrganizationId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationIdentifier orgid 
				ON tod.School_Identifier_State = orgid.Identifier
			JOIN ODS.OrganizationDetail orgd 
				ON orgid.OrganizationId = orgd.OrganizationID
			JOIN ODS.OrganizationRelationship orgr 
				ON orgd.OrganizationId = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd2 
				ON orgr.OrganizationId = orgd2.OrganizationId
		WHERE orgd.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
			AND orgd2.Name = 'Homeless Program'
			AND orgd2.RefOrganizationTypeId = @OrgTypeId_Program
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'HomelessProgramOrganizationId', 'S01EC2060'
	END CATCH


	--Insert new Homeless Programs--
	BEGIN TRY
		DELETE FROM @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC2070'
	END CATCH

	BEGIN TRY
		MERGE ODS.Organization AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_HomelessProgramOrganizationId
		--When no records are matched, insert
		--the incoming records from source
		--table to target table
		WHEN NOT MATCHED BY TARGET THEN 
			INSERT DEFAULT VALUES
		OUTPUT 
			  INSERTED.OrganizationId AS OrganizationId
			, SOURCE.Id
		INTO @NewOrganization;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC2080'
	END CATCH

	BEGIN TRY
		-- Update organization IDs in the staging table
		UPDATE Staging.Organization 
		SET School_HomelessProgramOrganizationId = norg.OrganizationId
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'HomelessProgramOrganizationId', 'S01EC2090'
	END CATCH

	BEGIN TRY
		MERGE ODS.OrganizationDetail AS TARGET
		USING Staging.Organization AS SOURCE 
			ON TARGET.OrganizationId = SOURCE.School_HomelessProgramOrganizationId
		WHEN NOT MATCHED THEN 
			INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
			VALUES (
				  Source.School_HomelessProgramOrganizationId
				, 'Homeless Program'
				, @OrgTypeId_Program
				, @RecordStartDate);
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC2100'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET   School_HomelessProgramOrganizationId = norg.OrganizationId
			, NewHomelessProgram = 1
		FROM Staging.Organization o
		JOIN @NewOrganization norg
			ON o.Id = norg.SourceId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'HomelessProgramOrganizationId', 'S01EC2110'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.OrganizationDetail
		WHERE OrganizationId IN (
				SELECT School_HomelessProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC2120'
	END CATCH

	BEGIN TRY
		DELETE FROM ODS.Organization
		WHERE OrganizationId IN (
				SELECT School_HomelessProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S01EC2130'
	END CATCH

	BEGIN TRY
		DELETE FROM @NewOrganization 
		where OrganizationId in (
				SELECT School_HomelessProgramOrganizationId
				FROM Staging.Organization
				WHERE School_Name IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganization', NULL, 'S01EC2140'
	END CATCH

	-------------------------------------
	--- End Homeless Program Creation ---
	-------------------------------------

	--===============================================================================================================================

	--Insert LEA/K12/SEA relationships into ODS.OrganizationRelationiship---------

	BEGIN TRY
		--First check to see if the relationship already exists and put the OrganizationRelationshipId back into the temp table
		UPDATE Staging.Organization
		SET SEAToLEA_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.SEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEAOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SEAToLEA_OrganizationRelationshipId', 'S01EC2150'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToSchool_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.SchoolOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToSchool_OrganizationRelationshipId', 'S01EC2160'
	END CATCH

	BEGIN TRY
		--LEA to Program relationships
		UPDATE Staging.Organization
		SET LEAToSpecialEducationProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_SpecialEducationProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToSpecialEducationProgram_OrganizationRelationshipId', 'S01EC2170'
	END CATCH

	BEGIN TRY
		--LEA to N or D Program relationships
		UPDATE Staging.Organization
		SET LEAToNorDProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_NorDProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToNorDProgram_OrganizationRelationshipId', 'S01EC2175'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToCTEProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_CTEProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToCTEProgram_OrganizationRelationshipId', 'S01EC2180'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToTitleIIIProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_TitleIIIProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToTitleIIIProgram_OrganizationRelationshipId', 'S01EC2190'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToTitleIProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_TitleIProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToTitleIProgram_OrganizationRelationshipId', 'S01EC2200'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToMigrantProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_MigrantProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToMigrantProgram_OrganizationRelationshipId', 'S01EC2210'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToFosterProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_FosterProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToFosterProgram_OrganizationRelationshipId', 'S01EC2220'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToSection504Program_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_Section504ProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToSection504Program_OrganizationRelationshipId', 'S01EC2230'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToImmigrantProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_ImmigrantProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToSection504Program_OrganizationRelationshipId', 'S01EC2230'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToHomelessProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_HomelessProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToHomelessProgram_OrganizationRelationshipId', 'S01EC2240'
	END CATCH


	BEGIN TRY
		--School to Program relationships
		UPDATE Staging.Organization
		SET SchoolToSpecialEducationProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_SpecialEducationProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToSpecialEducationProgram_OrganizationRelationshipId', 'S01EC2250'
	END CATCH

	BEGIN TRY
		--School to N or D Program relationships
		UPDATE Staging.Organization
		SET SchoolToNorDProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_NorDProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToSpecialEducationProgram_OrganizationRelationshipId', 'S01EC2255'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToCTEProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_CTEProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToCTEProgram_OrganizationRelationshipId', 'S01EC2260'
	END CATCH

		BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToTitleIIIProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_TitleIIIProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToTitleIIIProgram_OrganizationRelationshipId', 'S01EC2270'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToTitleIProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_TitleIProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToTitleIProgram_OrganizationRelationshipId', 'S01EC2280'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToMigrantProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_MigrantProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToMigrantProgram_OrganizationRelationshipId', 'S01EC2290'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToFosterProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_FosterProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToFosterProgram_OrganizationRelationshipId', 'S01EC2300'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToSection504Program_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_Section504ProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToSection504Program_OrganizationRelationshipId', 'S01EC2310'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToImmigrantProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_ImmigrantProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToSection504Program_OrganizationRelationshipId', 'S01EC2310'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToHomelessProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_HomelessProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToHomelessProgram_OrganizationRelationshipId', 'S01EC2320'
	END CATCH


	BEGIN TRY
		--Create relationship between SEA and LEA--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					sd.OrganizationId [Parent_OrganizationId]
				   ,tod.LEAOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		CROSS JOIN Staging.StateDetail sd
		WHERE tod.SEAToLEA_OrganizationRelationshipId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2330'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SEAToLEA_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationRelationship orgr
				ON tod.SEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEAOrganizationId = orgr.OrganizationId
		AND tod.SEAToLEA_OrganizationRelationshipId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SEAToLEA_OrganizationRelationshipId', 'S01EC2340'
	END CATCH


	--Create relationship between LEA and K12 School--

	BEGIN TRY
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.LEAOrganizationId [Parent_OrganizationId]
				   ,tod.SchoolOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.LEAToSchool_OrganizationRelationshipId IS NULL
			AND tod.School_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2350'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToSchool_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationRelationship orgr	
				ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.SchoolOrganizationId = orgr.OrganizationId
		AND tod.LEAToSchool_OrganizationRelationshipId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToSchool_OrganizationRelationshipId', 'S01EC2360'
	END CATCH


	---------------
	--LEA
	---------------
	BEGIN TRY
		--Create relationship between LEA and Special Education Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.LEAOrganizationId [Parent_OrganizationId]
				   ,tod.LEA_SpecialEducationProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.LEAToSpecialEducationProgram_OrganizationRelationshipId IS NULL
			AND tod.LEA_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2370'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToSpecialEducationProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_SpecialEducationProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToSpecialEducationProgram_OrganizationRelationshipId', 'S01EC2380'
	END CATCH

	BEGIN TRY
		--Create relationship between LEA and N or D Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.LEAOrganizationId [Parent_OrganizationId]
				   ,tod.LEA_NorDProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.LEAToNorDProgram_OrganizationRelationshipId IS NULL
			AND tod.LEA_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2384'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToNorDProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_NorDProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToNorDProgram_OrganizationRelationshipId', 'S01EC2386'
	END CATCH

	BEGIN TRY
		--Create relationship between LEA and CTE Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.LEAOrganizationId [Parent_OrganizationId]
				   ,tod.LEA_CTEProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.LEAToCTEProgram_OrganizationRelationshipId IS NULL
			AND tod.LEA_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2390'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToCTEProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_CTEProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToCTEProgram_OrganizationRelationshipId', 'S01EC2400'
	END CATCH

		BEGIN TRY
		--Create relationship between LEA and Title III Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.LEAOrganizationId [Parent_OrganizationId]
				   ,tod.LEA_TitleIIIProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.LEAToTitleIIIProgram_OrganizationRelationshipId IS NULL
			AND tod.LEA_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2410'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToTitleIIIProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_TitleIIIProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToTitleIIIProgram_OrganizationRelationshipId', 'S01EC2420'
	END CATCH

	BEGIN TRY
		--Create relationship between LEA and Title I Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.LEAOrganizationId [Parent_OrganizationId]
				   ,tod.LEA_TitleIProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.LEAToTitleIProgram_OrganizationRelationshipId IS NULL
			AND tod.LEA_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2430'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToTitleIProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_TitleIProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToTitleIProgram_OrganizationRelationshipId', 'S01EC2440'
	END CATCH

	BEGIN TRY
		--Create relationship between LEA and Migrant Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.LEAOrganizationId [Parent_OrganizationId]
				   ,tod.LEA_MigrantProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.LEAToMigrantProgram_OrganizationRelationshipId IS NULL
			AND tod.LEA_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2450'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToMigrantProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_MigrantProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToMigrantProgram_OrganizationRelationshipId', 'S01EC2460'
	END CATCH

	BEGIN TRY
		--Create relationship between LEA and Foster Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.LEAOrganizationId [Parent_OrganizationId]
				   ,tod.LEA_FosterProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.LEAToFosterProgram_OrganizationRelationshipId IS NULL
			AND tod.LEA_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2470'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToFosterProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_FosterProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToFosterProgram_OrganizationRelationshipId', 'S01EC2480'
	END CATCH

	BEGIN TRY
		--Create relationship between LEA and Section 504 Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.LEAOrganizationId [Parent_OrganizationId]
				   ,tod.LEA_Section504ProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.LEAToSection504Program_OrganizationRelationshipId IS NULL
			AND tod.LEA_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2490'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToSection504Program_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_Section504ProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToSection504Program_OrganizationRelationshipId', 'S01EC2500'
	END CATCH

	BEGIN TRY
		--Create relationship between LEA and Immigrant Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.LEAOrganizationId [Parent_OrganizationId]
				   ,tod.LEA_ImmigrantProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.LEAToImmigrantProgram_OrganizationRelationshipId IS NULL
			AND tod.LEA_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2504'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToImmigrantProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_ImmigrantProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToSection504Program_OrganizationRelationshipId', 'S01EC2506'
	END CATCH

	BEGIN TRY
		--Create relationship between LEA and Homeless Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.LEAOrganizationId							[Parent_OrganizationId]
				   ,tod.LEA_HomelessProgramOrganizationId			[OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.LEAToHomelessProgram_OrganizationRelationshipId IS NULL
			AND tod.LEA_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2510'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET LEAToHomelessProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.LEAOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.LEA_HomelessProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEAToHomelessProgram_OrganizationRelationshipId', 'S01EC2520'
	END CATCH

	---------------
	--Schools
	---------------
	BEGIN TRY
		--Create relationship between K12 School and Special Education Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.SchoolOrganizationId [Parent_OrganizationId]
				   ,tod.School_SpecialEducationProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.SchoolToSpecialEducationProgram_OrganizationRelationshipId IS NULL
			AND tod.School_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2530'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToSpecialEducationProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationRelationship orgr 
				ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_SpecialEducationProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToSpecialEducationProgram_OrganizationRelationshipId', 'S01EC2540'
	END CATCH

	BEGIN TRY
		--Create relationship between K12 School and N or D Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.SchoolOrganizationId [Parent_OrganizationId]
				   ,tod.School_NorDProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.SchoolToNorDProgram_OrganizationRelationshipId IS NULL
			AND tod.School_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2544'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToNorDProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationRelationship orgr 
				ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_NorDProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToNorDProgram_OrganizationRelationshipId', 'S01EC2546'
	END CATCH

	BEGIN TRY
		--Create relationship between K12 School and CTE Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.SchoolOrganizationId [Parent_OrganizationId]
				   ,tod.School_CTEProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.SchoolToCTEProgram_OrganizationRelationshipId IS NULL
			AND tod.School_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2550'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToCTEProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationRelationship orgr 
				ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_CTEProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToCTEProgram_OrganizationRelationshipId', 'S01EC2560'
	END CATCH

	BEGIN TRY
		--Create relationship between K12 School and Title III Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.SchoolOrganizationId [Parent_OrganizationId]
				   ,tod.School_TitleIIIProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.SchoolToTitleIIIProgram_OrganizationRelationshipId IS NULL
			AND tod.School_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2570'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToTitleIIIProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationRelationship orgr 
				ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_TitleIIIProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToTitleIIIProgram_OrganizationRelationshipId', 'S01EC2580'
	END CATCH

	BEGIN TRY
		--Create relationship between K12 School and Title I Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.SchoolOrganizationId [Parent_OrganizationId]
				   ,tod.School_TitleIProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.SchoolToTitleIProgram_OrganizationRelationshipId IS NULL
			AND tod.School_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2590'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToTitleIProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationRelationship orgr 
				ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_TitleIProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', NULL, 'S01EC2600'
	END CATCH

	BEGIN TRY
		--Create relationship between K12 School and Migrant Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.SchoolOrganizationId [Parent_OrganizationId]
				   ,tod.School_MigrantProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.SchoolToMigrantProgram_OrganizationRelationshipId IS NULL
			AND tod.School_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2610'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToMigrantProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationRelationship orgr 
				ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_MigrantProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToMigrantProgram_OrganizationRelationshipId', 'S01EC2620'
	END CATCH

	BEGIN TRY
		--Create relationship between K12 School and Foster Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.SchoolOrganizationId [Parent_OrganizationId]
				   ,tod.School_FosterProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.SchoolToFosterProgram_OrganizationRelationshipId IS NULL
			AND tod.School_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2630'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToFosterProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationRelationship orgr 
				ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_FosterProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToFosterProgram_OrganizationRelationshipId', 'S01EC2640'
	END CATCH

	BEGIN TRY
		--Create relationship between K12 School and Section 504 Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.SchoolOrganizationId [Parent_OrganizationId]
				   ,tod.School_Section504ProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.SchoolToSection504Program_OrganizationRelationshipId IS NULL
			AND tod.School_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2645'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToSection504Program_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationRelationship orgr 
				ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_Section504ProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToSection504Program_OrganizationRelationshipId', 'S01EC2650'
	END CATCH

	BEGIN TRY
		--Create relationship between K12 School and Immigrant Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.SchoolOrganizationId [Parent_OrganizationId]
				   ,tod.School_ImmigrantProgramOrganizationId [OrganizationId]
				   ,NULL [RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.SchoolToImmigrantProgram_OrganizationRelationshipId IS NULL
			AND tod.School_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2655'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToImmigrantProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationRelationship orgr 
				ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_ImmigrantProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToSection504Program_OrganizationRelationshipId', 'S01EC2660'
	END CATCH

	BEGIN TRY
		--Create relationship between K12 School and Homeless Program--
		INSERT INTO [ODS].[OrganizationRelationship]
				   ([Parent_OrganizationId]
				   ,[OrganizationId]
				   ,[RefOrganizationRelationshipId])
		SELECT DISTINCT
					tod.SchoolOrganizationId									[Parent_OrganizationId]
				   ,tod.School_HomelessProgramOrganizationId					[OrganizationId]
				   ,NULL														[RefOrganizationRelationshipId]
		FROM Staging.Organization tod
		WHERE tod.SchoolToHomelessProgram_OrganizationRelationshipId IS NULL
			AND tod.School_Name IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC2670'
	END CATCH

	BEGIN TRY
		UPDATE Staging.Organization
		SET SchoolToHomelessProgram_OrganizationRelationshipId = orgr.OrganizationRelationshipId
		FROM Staging.Organization tod
		JOIN ODS.OrganizationRelationship orgr 
			ON tod.SchoolOrganizationId = orgr.Parent_OrganizationId
		WHERE tod.School_HomelessProgramOrganizationId = orgr.OrganizationId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToHomelessProgram_OrganizationRelationshipId', 'S01EC2680'
	END CATCH

	-----------------------------------------------------------------------------------
	----Create SpecialEducationOrganizationProgramType --------------------------------
	-----------------------------------------------------------------------------------
	declare @SPEDProgram int = App.GetProgramTypeId('04888')

	BEGIN TRY
		INSERT INTO [ODS].[OrganizationProgramType]
				   ([OrganizationId]
				   ,[RefProgramTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime])
		SELECT DISTINCT
					orgd.OrganizationId		[OrganizationId]
				   ,@SPEDProgram			[RefProgramTypeId]
				   ,@RecordStartDate		[RecordStartDateTime]
				   ,NULL					[RecordEndDateTime]
		FROM ODS.OrganizationDetail orgd
		LEFT JOIN ODS.OrganizationProgramType orgp 
			ON orgd.OrganizationId = orgp.OrganizationId
			AND orgp.RefProgramTypeId = @SPEDProgram
		WHERE orgd.Name = 'Special Education Program'
		AND orgd.RefOrganizationTypeId = @OrgTypeId_Program
		AND orgp.OrganizationId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationProgramType', NULL, 'S01EC2690'
	END CATCH

	-----------------------------------------------------------------------------------
	----Create N or D OrganizationProgramType --------------------------------
	-----------------------------------------------------------------------------------
	declare @NorDProgram int = App.GetProgramTypeId('09999')

	BEGIN TRY
		INSERT INTO [ODS].[OrganizationProgramType]
				   ([OrganizationId]
				   ,[RefProgramTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime])
		SELECT DISTINCT
					orgd.OrganizationId		[OrganizationId]
				   ,@NorDProgram			[RefProgramTypeId]
				   ,@RecordStartDate		[RecordStartDateTime]
				   ,NULL					[RecordEndDateTime]
		FROM ODS.OrganizationDetail orgd
		LEFT JOIN ODS.OrganizationProgramType orgp 
			ON orgd.OrganizationId = orgp.OrganizationId
			AND orgp.RefProgramTypeId = @NorDProgram
		WHERE orgd.Name = 'N or D Program'
		AND orgd.RefOrganizationTypeId = @OrgTypeId_Program
		AND orgp.OrganizationId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationProgramType', NULL, 'S01EC2695'
	END CATCH

	-----------------------------------------------------------------------------------
	----Create CTEOrganizationProgramType --------------------------------
	-----------------------------------------------------------------------------------
	declare @CTEProgram int = App.GetProgramTypeId('04906')

	BEGIN TRY
		INSERT INTO [ODS].[OrganizationProgramType]
				   ([OrganizationId]
				   ,[RefProgramTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime])
		SELECT DISTINCT
					orgd.OrganizationId		[OrganizationId]
				   ,@CTEProgram			[RefProgramTypeId]
				   ,@RecordStartDate		[RecordStartDateTime]
				   ,NULL					[RecordEndDateTime]
		FROM ODS.OrganizationDetail orgd
		LEFT JOIN ODS.OrganizationProgramType orgp 
			ON orgd.OrganizationId = orgp.OrganizationId
			AND orgp.RefProgramTypeId = @CTEProgram
		WHERE orgd.Name = 'CTE Program'
		AND orgd.RefOrganizationTypeId = @OrgTypeId_Program
		AND orgp.OrganizationId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationProgramType', NULL, 'S01EC2700'
	END CATCH

	-----------------------------------------------------------------------------------
	----Create Title III OrganizationProgramType --------------------------------
	-----------------------------------------------------------------------------------
	declare @TitleIIIProgram int = App.GetProgramTypeId('77000')

	BEGIN TRY
		INSERT INTO [ODS].[OrganizationProgramType]
				   ([OrganizationId]
				   ,[RefProgramTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime])
		SELECT DISTINCT
					orgd.OrganizationId		[OrganizationId]
				   ,@TitleIIIProgram		[RefProgramTypeId]
				   ,@RecordStartDate		[RecordStartDateTime]
				   ,NULL					[RecordEndDateTime]
		FROM ODS.OrganizationDetail orgd
		LEFT JOIN ODS.OrganizationProgramType orgp 
			ON orgd.OrganizationId = orgp.OrganizationId
			AND orgp.RefProgramTypeId = @TitleIIIProgram
		WHERE orgd.Name = 'Title III Program'
		AND orgd.RefOrganizationTypeId = @OrgTypeId_Program
		AND orgp.OrganizationId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationProgramType', NULL, 'S01EC2710'
	END CATCH

	-----------------------------------------------------------------------------------
	----Create TitleIOrganizationProgramType ------------------------------------------
	-----------------------------------------------------------------------------------

	----Need to modify the 09999 code to match the Title I Program code when the Title I
	----program code is added to the RefProgramType table.
	declare @TitleIProgram int = App.GetProgramTypeId('09999')

	BEGIN TRY
		INSERT INTO [ODS].[OrganizationProgramType]
				   ([OrganizationId]
				   ,[RefProgramTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime])
		SELECT DISTINCT
					orgd.OrganizationId		[OrganizationId]
				   ,@TitleIProgram			[RefProgramTypeId]
				   ,@RecordStartDate		[RecordStartDateTime]
				   ,NULL					[RecordEndDateTime]
		FROM ODS.OrganizationDetail orgd
		LEFT JOIN ODS.OrganizationProgramType orgp 
			ON orgd.OrganizationId = orgp.OrganizationId
			AND orgp.RefProgramTypeId = @TitleIProgram
		WHERE orgd.Name = 'Title I Program'
		AND orgd.RefOrganizationTypeId = @OrgTypeId_Program
		AND orgp.OrganizationId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationProgramType', NULL, 'S01EC2720'
	END CATCH

	-----------------------------------------------------------------------------------
	----Create MigrantOrganizationProgramType -----------------------------------------
	-----------------------------------------------------------------------------------

	declare @MigrantProgram int = App.GetProgramTypeId('04920')

	BEGIN TRY
		INSERT INTO [ODS].[OrganizationProgramType]
				   ([OrganizationId]
				   ,[RefProgramTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime])
		SELECT DISTINCT
					orgd.OrganizationId		[OrganizationId]
				   ,@MigrantProgram			[RefProgramTypeId]
				   ,@RecordStartDate		[RecordStartDateTime]
				   ,NULL					[RecordEndDateTime]
		FROM ODS.OrganizationDetail orgd
		LEFT JOIN ODS.OrganizationProgramType orgp 
			ON orgd.OrganizationId = orgp.OrganizationId
			AND orgp.RefProgramTypeId = @MigrantProgram
		WHERE orgd.Name = 'Migrant Program'
		AND orgd.RefOrganizationTypeId = @OrgTypeId_Program
		AND orgp.OrganizationId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationProgramType', NULL, 'S01EC2730'
	END CATCH


	-----------------------------------------------------------------------------------
	----Create FosterOrganizationProgramType -----------------------------------------
	-----------------------------------------------------------------------------------

	declare @FosterProgram int = App.GetProgramTypeId('75000')

	BEGIN TRY
		INSERT INTO [ODS].[OrganizationProgramType]
				   ([OrganizationId]
				   ,[RefProgramTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime])
		SELECT DISTINCT
					orgd.OrganizationId		[OrganizationId]
				   ,@FosterProgram			[RefProgramTypeId]
				   ,@RecordStartDate		[RecordStartDateTime]
				   ,NULL					[RecordEndDateTime]
		FROM ODS.OrganizationDetail orgd
		LEFT JOIN ODS.OrganizationProgramType orgp 
			ON orgd.OrganizationId = orgp.OrganizationId
			AND orgp.RefProgramTypeId = @FosterProgram
		WHERE orgd.Name = 'Foster Program'
		AND orgd.RefOrganizationTypeId = @OrgTypeId_Program
		AND orgp.OrganizationId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationProgramType', NULL, 'S01EC2740'
	END CATCH

	-----------------------------------------------------------------------------------
	----Create Section 504 OrganizationProgramType ------------------------------------
	-----------------------------------------------------------------------------------

	declare @504Program int = App.GetProgramTypeId('04967')

	BEGIN TRY
		INSERT INTO [ODS].[OrganizationProgramType]
				   ([OrganizationId]
				   ,[RefProgramTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime])
		SELECT DISTINCT
					orgd.OrganizationId		[OrganizationId]
				   ,@504Program			[RefProgramTypeId]
				   ,@RecordStartDate		[RecordStartDateTime]
				   ,NULL					[RecordEndDateTime]
		FROM ODS.OrganizationDetail orgd
		LEFT JOIN ODS.OrganizationProgramType orgp 
			ON orgd.OrganizationId = orgp.OrganizationId
			AND orgp.RefProgramTypeId = @504Program
		WHERE orgd.Name = 'Section 504 Program'
		AND orgd.RefOrganizationTypeId = @OrgTypeId_Program
		AND orgp.OrganizationId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationProgramType', NULL, 'S01EC2750'
	END CATCH

	-----------------------------------------------------------------------------------
	----Create Immigrant OrganizationProgramType ------------------------------------
	-----------------------------------------------------------------------------------

	declare @ImmigrantProgram int = App.GetProgramTypeId('04957')

	BEGIN TRY
		INSERT INTO [ODS].[OrganizationProgramType]
				   ([OrganizationId]
				   ,[RefProgramTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime])
		SELECT DISTINCT
					orgd.OrganizationId		[OrganizationId]
				   ,@ImmigrantProgram			[RefProgramTypeId]
				   ,@RecordStartDate		[RecordStartDateTime]
				   ,NULL					[RecordEndDateTime]
		FROM ODS.OrganizationDetail orgd
		LEFT JOIN ODS.OrganizationProgramType orgp 
			ON orgd.OrganizationId = orgp.OrganizationId
			AND orgp.RefProgramTypeId = @ImmigrantProgram
		WHERE orgd.Name = 'Immigrant Program'
		AND orgd.RefOrganizationTypeId = @OrgTypeId_Program
		AND orgp.OrganizationId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationProgramType', NULL, 'S01EC2755'
	END CATCH

	-----------------------------------------------------------------------------------
	----Create HomelessProgramType ------------------------------------------
	-----------------------------------------------------------------------------------

	declare @HomelessProgram int = App.GetProgramTypeId('76000')

	BEGIN TRY
		INSERT INTO [ODS].[OrganizationProgramType]
				   ([OrganizationId]
				   ,[RefProgramTypeId]
				   ,[RecordStartDateTime]
				   ,[RecordEndDateTime])
		SELECT DISTINCT
					orgd.OrganizationId		[OrganizationId]
				   ,@HomelessProgram		[RefProgramTypeId]
				   ,@RecordStartDate		[RecordStartDateTime]
				   ,NULL					[RecordEndDateTime]
		FROM ODS.OrganizationDetail orgd
		LEFT JOIN ODS.OrganizationProgramType orgp 
			ON orgd.OrganizationId = orgp.OrganizationId
			AND orgp.RefProgramTypeId = @HomelessProgram
		WHERE orgd.Name = 'Homeless Program'
		AND orgd.RefOrganizationTypeId = @OrgTypeId_Program
		AND orgp.OrganizationId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationProgramType', NULL, 'S01EC2760'
	END CATCH

	-------------------------------------------------
	----Telephone Information -----------------------
	-------------------------------------------------

	--SEA Level
	BEGIN TRY
		UPDATE Staging.OrganizationPhone
		SET OrganizationId = orgid.OrganizationId
		FROM Staging.OrganizationPhone soa
		JOIN ODS.OrganizationIdentifier orgid
			ON soa.OrganizationIdentifier = orgid.Identifier
		JOIN ODS.SourceSystemReferenceData osss
			ON soa.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = @SchoolYear
		JOIN ODS.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN ODS.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId = @OrgTypeId_SEA
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_State_Fed
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_State
	END TRY


	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationPhone', 'OrganizationId', 'S01EC2770'
	END CATCH

	--LEA Level
	BEGIN TRY
		UPDATE Staging.OrganizationPhone
		SET OrganizationId = orgid.OrganizationId
		FROM Staging.OrganizationPhone soa
		JOIN ODS.OrganizationIdentifier orgid 
			ON soa.OrganizationIdentifier = orgid.Identifier
		JOIN ODS.SourceSystemReferenceData osss
			ON soa.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = @SchoolYear
		JOIN ODS.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN ODS.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
	END TRY


	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationPhone', 'OrganizationId', 'S01EC2780'
	END CATCH

	--School Level
	BEGIN TRY
		UPDATE Staging.OrganizationPhone
		SET OrganizationId = orgid.OrganizationId
		FROM Staging.OrganizationPhone soa
		JOIN ODS.OrganizationIdentifier orgid 
			ON soa.OrganizationIdentifier = orgid.Identifier
		JOIN ODS.SourceSystemReferenceData osss
			ON soa.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = @SchoolYear
		JOIN ODS.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN ODS.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationPhone', 'OrganizationId', 'S01EC2790'
	END CATCH

	-------------------------------------------------------------------
	----Create OrganizationTelephone ----------------------------------
	-------------------------------------------------------------------

	--Update the OrganizationPhone records that need to be corrected.

	BEGIN TRY

		UPDATE ODS.OrganizationTelephone
		SET TelephoneNumber = orgp.TelephoneNumber, RefInstitutionTelephoneTypeId = ritt.RefInstitutionTelephoneTypeId, RecordEndDateTime = orgp.RecordEndDateTime
		FROM ODS.OrganizationTelephone orgt
		JOIN Staging.OrganizationPhone orgp
			ON orgt.OrganizationId = orgp.OrganizationId
			AND orgt.RecordStartDateTime = orgp.RecordStartDateTime
		JOIN ODS.SourceSystemReferenceData ssrd
			ON orgp.InstitutionTelephoneNumberType = ssrd.InputCode
			AND ssrd.TableName = 'RefInstitutionTelephoneType'
			AND ssrd.SchoolYear = @SchoolYear
		JOIN ODS.RefInstitutionTelephoneType ritt
			ON ssrd.OutputCode = ritt.Code
		WHERE orgp.OrganizationId IS NOT NULL
			AND orgp.TelephoneNumber IS NOT NULL
			AND orgp.InstitutionTelephoneNumberType IS NOT NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationTelephone', 'TelephoneNumber', 'S01EC2800'
	END CATCH

	--Insert the new OrganizationPhone records.

	BEGIN TRY
		INSERT INTO [ODS].[OrganizationTelephone]
					([OrganizationId]
					,[TelephoneNumber]
					,[PrimaryTelephoneNumberIndicator]
					,[RefInstitutionTelephoneTypeId]
					,[RecordStartDateTime]
					,[RecordEndDateTime])
		SELECT DISTINCT 
					 tod.OrganizationId [OrganizationId]
					,tod.TelephoneNumber [TelephoneNumber]
					,0 [PrimaryTelephoneNumberIndicator]
					,ritt.RefInstitutionTelephoneTypeId [RefInstitutionTelephoneTypeId]
					,tod.RecordStartDateTime [RecordStartDateTime]
					,tod.RecordEndDateTime [RecordEndDateTime]
		FROM Staging.OrganizationPhone tod
		JOIN ODS.SourceSystemReferenceData ittss
			ON tod.InstitutionTelephoneNumberType = ittss.InputCode
			AND ittss.TableName = 'RefInstitutionTelephoneType'
			AND ittss.SchoolYear = @SchoolYear
		JOIN ODS.RefInstitutionTelephoneType ritt
			ON ittss.OutputCode = ritt.Code
		LEFT JOIN ODS.OrganizationTelephone orgt 
			ON tod.OrganizationId = orgt.organizationId
			AND tod.RecordStartDateTime = orgt.RecordStartDateTime
			AND ritt.RefInstitutionTelephoneTypeId = orgt.RefInstitutionTelephoneTypeId
		WHERE orgt.RefInstitutionTelephoneTypeId IS NULL
			AND tod.TelephoneNumber IS NOT NULL
			AND tod.TelephoneNumber <> ''
			AND tod.OrganizationId IS NOT NULL
		--End Date and out of date phone numbers once the RecordStartDateTime and RecordEndDateTime has been added to Generate
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationTelephone', NULL, 'S01EC2810'
	END CATCH


	--Update the staging table with the OrganizationTelephoneId of the newly inserted records for troubleshooting purposes

	BEGIN TRY

		UPDATE Staging.OrganizationPhone
		SET OrganizationTelephoneId = orgt.OrganizationTelephoneId
		FROM Staging.OrganizationPhone sop
		JOIN ODS.OrganizationTelephone orgt
			ON sop.OrganizationId = orgt.OrganizationId
			AND sop.TelephoneNumber = orgt.TelephoneNumber
			AND sop.RecordStartDateTime = orgt.RecordStartDateTime

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationPhone', 'OrganizationTelephoneId', 'S01EC2820'
	END CATCH

	-- End date any previous OrganizationTelephone record for which a RecordEndDateTime was not supplied

	BEGIN TRY

        UPDATE r SET r.RecordEndDateTime = s.RecordStartDateTime - 1
        FROM ODS.OrganizationTelephone r
        JOIN (
				SELECT 
							OrganizationId
						, RefInstitutionTelephoneTypeId
						, MAX(OrganizationTelephoneId) AS OrganizationTelephoneId
						, MAX(RecordStartDateTime) AS RecordStartDateTime
				FROM ODS.OrganizationTelephone
				WHERE RecordEndDateTime IS NULL
					AND RecordStartDateTime IS NOT NULL
				GROUP BY OrganizationId, RefInstitutionTelephoneTypeId, OrganizationTelephoneId, RecordStartDateTime
        ) s ON r.OrganizationId = s.OrganizationId
				AND r.RefInstitutionTelephoneTypeId = s.RefInstitutionTelephoneTypeId
                AND r.OrganizationTelephoneId <> s.OrganizationTelephoneId 
                AND r.RecordEndDateTime IS NULL
				AND r.RecordStartDateTime IS NOT NULL
				AND r.RecordStartDateTime < s.RecordStartDateTime

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationTelephone', 'RecordEndDateTime', 'S01EC2830'
	END CATCH



	-------------------------------------------------------------------
	----Create OrganizationWebsite ------------------------------------
	-------------------------------------------------------------------

	--Update the OrganizationWebsite records that need to be corrected.

	BEGIN TRY
	----SEA Level
		UPDATE ODS.OrganizationWebsite
		SET Website = org.Sea_WebSiteAddress, RecordEndDateTime = org.RecordEndDateTime
		FROM ODS.OrganizationWebsite orgw
		JOIN Staging.StateDetail org
			ON orgw.OrganizationId = org.OrganizationId
			AND orgw.RecordStartDateTime = org.RecordStartDateTime
		WHERE org.Sea_WebSiteAddress IS NOT NULL
			AND org.OrganizationId IS NOT NULL
			AND org.Sea_WebSiteAddress <> orgw.Website

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationWebsite', 'Website', 'S01EC2840'
	END CATCH

	BEGIN TRY
	----LEA Level
		UPDATE ODS.OrganizationWebsite
		SET Website = org.LEA_WebSiteAddress, RecordEndDateTime = org.LEA_RecordEndDateTime
		FROM ODS.OrganizationWebsite orgw
		JOIN Staging.Organization org
			ON orgw.OrganizationId = org.LEAOrganizationId
			AND orgw.RecordStartDateTime = org.LEA_RecordStartDateTime
		WHERE org.LEA_WebSiteAddress IS NOT NULL
			AND org.LEAOrganizationId IS NOT NULL
			AND org.LEA_WebSiteAddress <> orgw.Website
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationWebsite', 'Website', 'S01EC2850'
	END CATCH

	BEGIN TRY
	----School Level
		UPDATE ODS.OrganizationWebsite
		SET Website = org.School_WebSiteAddress, RecordEndDateTime = org.School_RecordEndDateTime
		FROM ODS.OrganizationWebsite orgw
		JOIN Staging.Organization org
			ON orgw.OrganizationId = org.SchoolOrganizationId
			AND orgw.RecordStartDateTime = org.School_RecordStartDateTime
		WHERE org.School_WebSiteAddress IS NOT NULL
			AND org.SchoolOrganizationId IS NOT NULL
			AND org.School_WebSiteAddress <> orgw.Website
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationWebsite', 'Website', 'S01EC2860'
	END CATCH


	BEGIN TRY
		--SEA Website
		INSERT INTO [ODS].[OrganizationWebsite]
					([OrganizationId]
					,[Website]
					,[RecordStartDateTime]
					,[RecordEndDateTime])
		SELECT DISTINCT
					sd.OrganizationId [OrganizationId]
					,sd.Sea_WebSiteAddress [Website]
					,sd.RecordStartDateTime [RecordStartDateTime]
					,sd.RecordEndDateTime [RecordEndDateTime]
		FROM Staging.StateDetail sd
		LEFT JOIN ODS.OrganizationWebsite orgw 
			ON sd.OrganizationId = orgw.OrganizationId
			AND sd.Sea_WebSiteAddress = orgw.Website
			--AND sd.RecordStartDateTime = orgw.RecordStartDateTime
		WHERE sd.Sea_WebSiteAddress IS NOT NULL
			AND sd.Sea_WebSiteAddress <> ''
			AND orgw.OrganizationId IS NULL
			AND NOT EXISTS (SELECT 'x'
							FROM ODS.OrganizationWebsite orgw2
							WHERE orgw.OrganizationId = orgw2.OrganizationId
								AND orgw.Website = orgw2.Website
								AND orgw2.RecordEndDateTime IS NULL)
							
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationWebsite', NULL, 'S01EC2870'
	END CATCH

	BEGIN TRY
		--LEA Website
		INSERT INTO [ODS].[OrganizationWebsite]
					([OrganizationId]
					,[Website]
					,[RecordStartDateTime]
					,[RecordEndDateTime])
		SELECT DISTINCT
					tod.LEAOrganizationId [OrganizationId]
					,tod.LEA_WebSiteAddress [Website]
					,tod.LEA_RecordStartDateTime [RecordStartDateTime]
					,tod.LEA_RecordEndDateTime [RecordEndDateTime]
		FROM Staging.Organization tod
		LEFT JOIN ODS.OrganizationWebsite orgw 
			ON tod.LEAOrganizationId = orgw.OrganizationId
			AND tod.LEA_WebSiteAddress = orgw.Website
			--AND tod.LEA_RecordStartDateTime = orgw.RecordStartDateTime
		WHERE tod.LEA_WebSiteAddress IS NOT NULL
			AND tod.LEA_WebSiteAddress <> ''
			AND orgw.OrganizationId IS NULL
			AND NOT EXISTS (SELECT 'x'
							FROM ODS.OrganizationWebsite orgw2
							WHERE orgw.OrganizationId = orgw2.OrganizationId
								AND orgw.Website = orgw2.Website
								AND orgw2.RecordEndDateTime IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationWebsite', NULL, 'S01EC2880'
	END CATCH


	 -- Update the Staging.Organization table with the LEA_OrganizationWebsiteId for troubleshooting purposes

	 BEGIN TRY

		UPDATE Staging.Organization
		SET LEA_OrganizationWebsiteId = orgw.OrganizationWebsiteId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationWebsite orgw 
				ON tod.LEAOrganizationId = orgw.OrganizationId
		WHERE tod.LEA_WebSiteAddress = orgw.Website
			AND tod.LEA_RecordStartDateTime = orgw.RecordStartDateTime

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEA_OrganizationWebsiteId', 'S01EC2890'
	END CATCH

	BEGIN TRY
		--School Website
		INSERT INTO [ODS].[OrganizationWebsite]
					([OrganizationId]
					,[Website]
					,[RecordStartDateTime]
					,[RecordEndDateTime])
		SELECT DISTINCT
					tod.SchoolOrganizationId [OrganizationId]
					,tod.School_WebSiteAddress [Website]
					,tod.School_RecordStartDateTime [RecordStartDateTime]
					,tod.School_RecordEndDateTime [RecordEndDateTime]
		FROM Staging.Organization tod
		LEFT JOIN ODS.OrganizationWebsite orgw 
			ON tod.SchoolOrganizationId = orgw.OrganizationId
			AND tod.School_WebSiteAddress = orgw.Website
			--AND tod.School_RecordStartDateTime = orgw.RecordStartDateTime
		WHERE tod.School_WebSiteAddress IS NOT NULL
			AND tod.School_WebSiteAddress <> ''
			AND orgw.OrganizationId IS NULL
			AND NOT EXISTS (SELECT 'x'
							FROM ODS.OrganizationWebsite orgw2
							WHERE orgw.OrganizationId = orgw2.OrganizationId
								AND orgw.Website = orgw2.Website
								AND orgw2.RecordEndDateTime IS NULL)
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationWebsite', NULL, 'S01EC2900'
	END CATCH


	 -- Update the Staging.Organization table with the School_OrganizationWebsiteId for troubleshooting purposes
	 BEGIN TRY

		UPDATE Staging.Organization
		SET School_OrganizationWebsiteId = orgw.OrganizationWebsiteId
		FROM Staging.Organization tod
			JOIN ODS.OrganizationWebsite orgw 
				ON tod.SchoolOrganizationId = orgw.OrganizationId
		WHERE tod.School_WebSiteAddress = orgw.Website
			AND tod.School_RecordStartDateTime = orgw.RecordStartDateTime

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'School_OrganizationWebsiteId', 'S01EC2910'	
	END CATCH


	-- End date any previous OrganizationWebsite record for which a RecordEndDateTime was not supplied

	BEGIN TRY

        UPDATE r SET r.RecordEndDateTime = s.RecordStartDateTime - 1
        FROM ODS.OrganizationWebsite r
        JOIN (
            SELECT 
				OrganizationId
				, MAX(OrganizationWebsiteId) AS OrganizationWebsiteId
                , MAX(RecordStartDateTime) AS RecordStartDateTime
            FROM ODS.OrganizationWebsite
            WHERE RecordEndDateTime IS NULL
				AND RecordStartDateTime IS NOT NULL
            GROUP BY OrganizationId, OrganizationWebsiteId, RecordStartDateTime
        ) s ON r.OrganizationId = s.OrganizationId
                AND r.OrganizationWebsiteId <> s.OrganizationWebsiteId 
                AND r.RecordEndDateTime IS NULL
				AND r.RecordStartDateTime IS NOT NULL
				AND r.RecordStartDateTime < s.RecordStartDateTime

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationWebsite', 'RecordEndDateTime', 'S01EC2920'	
	END CATCH


	-------------------------------------------------------------------
	----Create OrganizationOperationalStatus --------------------------
	-------------------------------------------------------------------

	-- LEA Level

	-- Update records that need to be corrected and Insert New Records into the OrganizationOperationalStatus

	BEGIN TRY

		;WITH CTE AS
		(
			SELECT DISTINCT 
				so.LEAOrganizationId
				, so.LEA_OrganizationOperationalStatusId
				, oros.RefOperationalStatusId
				, so.LEA_OperationalStatusEffectiveDate
				, so.LEA_RecordEndDateTime
			FROM Staging.Organization so
			JOIN ODS.SourceSystemReferenceData ossrd
				ON so.LEA_OperationalStatus = ossrd.InputCode
				AND ossrd.TableName = 'RefOperationalStatus'
				AND ossrd.SchoolYear = @SchoolYear
				AND ossrd.TableFilter = '000174'
			JOIN ODS.RefOperationalStatus oros
				ON ossrd.OutputCode = oros.Code
			JOIN ODS.RefOperationalStatusType orost
				ON ossrd.TableFilter = orost.Code
			WHERE oros.RefOperationalStatusTypeId = orost.RefOperationalStatusTypeId
				AND ISNULL(so.LEA_OperationalStatusEffectiveDate,'') <> ''
				AND NOT EXISTS (SELECT 'x'
								FROM ODS.OrganizationOperationalStatus ooos
								WHERE so.LEAOrganizationId = ooos.OrganizationId
									AND oros.RefOperationalStatusId = ooos.RefOperationalStatusId
									AND ooos.RecordEndDateTime IS NULL)
		)
		MERGE ODS.OrganizationOperationalStatus AS trgt
		USING CTE as src
				ON trgt.OrganizationId = src.LEAOrganizationId
				AND trgt.RecordStartDateTime = src.LEA_OperationalStatusEffectiveDate
		WHEN MATCHED AND (
				trgt.RefOperationalStatusId <> src.RefOperationalStatusId
				OR ISNULL(trgt.RecordEndDateTime, '1/1/1900') <> ISNULL(src.LEA_RecordEndDateTime, '1/1/1900')
				)
				THEN
			UPDATE SET 
				trgt.RefOperationalStatusId = src.RefOperationalStatusId
				, trgt.OperationalStatusEffectiveDate = src.LEA_OperationalStatusEffectiveDate
				, trgt.RecordEndDateTime = src.LEA_RecordEndDateTime
		WHEN NOT MATCHED BY TARGET THEN  ----Record Exists in Source But NOT IN Target
		INSERT (
				  OrganizationId
				, RefOperationalStatusId
				, OperationalStatusEffectiveDate
				, RecordStartDateTime
				, RecordEndDateTime
				)
		VALUES (
				  src.LEAOrganizationId
				, src.RefOperationalStatusId
				, src.LEA_OperationalStatusEffectiveDate
				, src.LEA_OperationalStatusEffectiveDate
				, src.LEA_RecordEndDateTime
				);

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationOperationalStatus', NULL, 'S01EC2930'	
	END CATCH

	-- Update the Staging.Organization table with the OrganizationOperationalStatusId for troubleshooting purposes
	BEGIN TRY

		UPDATE Staging.Organization
		SET LEA_OrganizationOperationalStatusId = ooos.OrganizationOperationalStatusId
		FROM Staging.Organization so
		JOIN ODS.OrganizationOperationalStatus ooos
			ON so.LEAOrganizationId = ooos.OrganizationId
			AND so.LEA_RecordStartDateTime = ooos.RecordStartDateTime

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'LEA_OrganizationOperationalStatusId', 'S01EC2940'	
	END CATCH

	-- End date any previous OrganizationOperationalStatus record for which a RecordEndDateTime was not supplied
	BEGIN TRY

		;WITH upd AS
		(
			SELECT DISTINCT 
				oos.OrganizationOperationalStatusId
				, ooi.Identifier
				, oos.RecordStartDateTime
				, LEAD (oos.RecordStartDateTime, 1, 0) OVER (PARTITION BY ooi.Identifier ORDER BY oos.RecordStartDateTime ASC) AS OldRecordStartDateTime
			FROM ODS.OrganizationOperationalStatus AS oos
				INNER JOIN ODS.OrganizationIdentifier AS ooi
					ON oos.OrganizationId = ooi.OrganizationId
					AND ooi.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
					AND ooi.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
				INNER JOIN ODS.OrganizationDetail AS ood
					ON oos.OrganizationId = ood.OrganizationId
					AND oos.RecordStartDateTime = ood.RecordStartDateTime
			WHERE oos.RecordEndDateTime IS NULL
			AND ood.RefOrganizationTypeId = 11
		)
		UPDATE oos
		SET RecordEndDateTime = upd.OldRecordStartDateTime -1
		FROM ODS.OrganizationOperationalStatus AS oos
			INNER JOIN upd
				ON oos.OrganizationOperationalStatusId = upd.OrganizationOperationalStatusId
		WHERE upd.OldRecordStartDateTime <> '1900-01-01 00:00:00.000'

	END TRY		

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationOperationStatus', 'RecordEndDateTime', 'S01EC2945'	
	END CATCH


	-- School Level

	BEGIN TRY

		;WITH CTE AS
		(
			SELECT DISTINCT 
				so.SchoolOrganizationId
				, so.School_OrganizationOperationalStatusId
				, oros.RefOperationalStatusId
				, so.School_OperationalStatusEffectiveDate
				, so.School_RecordEndDateTime
			FROM Staging.Organization so
			JOIN ODS.SourceSystemReferenceData ossrd
				ON so.School_OperationalStatus = ossrd.InputCode
				AND ossrd.TableName = 'RefOperationalStatus'
				AND ossrd.SchoolYear = @SchoolYear
				AND ossrd.TableFilter = '000533'
			JOIN ODS.RefOperationalStatus oros
				ON ossrd.OutputCode = oros.Code
			JOIN ODS.RefOperationalStatusType orost
				ON ossrd.TableFilter = orost.Code
			WHERE oros.RefOperationalStatusTypeId = orost.RefOperationalStatusTypeId
				AND ISNULL(so.School_OperationalStatusEffectiveDate,'') <> ''
				AND NOT EXISTS (SELECT 'x'
								FROM ODS.OrganizationOperationalStatus ooos
								WHERE so.SchoolOrganizationId = ooos.OrganizationId
									AND oros.RefOperationalStatusId = ooos.RefOperationalStatusId
									AND ooos.RecordEndDateTime IS NULL)
		)
		MERGE ODS.OrganizationOperationalStatus AS trgt
		USING CTE as src
				ON trgt.OrganizationId = src.SchoolOrganizationId
				AND trgt.RecordStartDateTime = src.School_OperationalStatusEffectiveDate
		WHEN MATCHED AND (
				trgt.RefOperationalStatusId <> src.RefOperationalStatusId
				OR ISNULL(trgt.RecordEndDateTime, '1/1/1900') <> ISNULL(src.School_RecordEndDateTime, '1/1/1900')
				)
				THEN
			UPDATE SET 
				trgt.RefOperationalStatusId = src.RefOperationalStatusId
				, trgt.OperationalStatusEffectiveDate = src.School_OperationalStatusEffectiveDate
				, trgt.RecordEndDateTime = src.School_RecordEndDateTime
		WHEN NOT MATCHED BY TARGET THEN  ----Record Exists in Source But NOT IN Target
		INSERT (
				  OrganizationId
				, RefOperationalStatusId
				, OperationalStatusEffectiveDate
				, RecordStartDateTime
				, RecordEndDateTime
				)
		VALUES (
				  src.SchoolOrganizationId
				, src.RefOperationalStatusId
				, src.School_OperationalStatusEffectiveDate
				, src.School_OperationalStatusEffectiveDate
				, src.School_RecordEndDateTime
				);

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationOperationalStatus', NULL, 'S01EC2950'	
	END CATCH

	-- Update the Staging.Organization table with the OrganizationOperationalStatusId for troubleshooting purposes

	BEGIN TRY

		UPDATE Staging.Organization
		SET School_OrganizationOperationalStatusId = ooos.OrganizationOperationalStatusId
		FROM Staging.Organization so
		JOIN ODS.OrganizationOperationalStatus ooos
			ON so.SchoolOrganizationId = ooos.OrganizationId
			AND so.School_RecordStartDateTime = ooos.RecordStartDateTime

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'School_OrganizationOperationalStatusId', 'S01EC2960'
	END CATCH
	
	-- End date any previous OrganizationOperationalStatus record for which a RecordEndDateTime was not supplied
	BEGIN TRY

		;WITH upd AS
		(
			SELECT DISTINCT 
				oos.OrganizationOperationalStatusId
				, ooi.Identifier
				, oos.RecordStartDateTime
				, LEAD (oos.RecordStartDateTime, 1, 0) OVER (PARTITION BY ooi.Identifier ORDER BY oos.RecordStartDateTime ASC) AS OldRecordStartDateTime
			FROM ODS.OrganizationOperationalStatus AS oos
				INNER JOIN ODS.OrganizationIdentifier AS ooi
					ON oos.OrganizationId = ooi.OrganizationId
					AND ooi.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
					AND ooi.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
				INNER JOIN ODS.OrganizationDetail AS ood
					ON oos.OrganizationId = ood.OrganizationId
					AND oos.RecordStartDateTime = ood.RecordStartDateTime
			WHERE oos.RecordEndDateTime IS NULL
			AND ood.RefOrganizationTypeId = 10
		)
		UPDATE oos
		SET RecordEndDateTime = upd.OldRecordStartDateTime -1
		FROM ODS.OrganizationOperationalStatus AS oos
			INNER JOIN upd
				ON oos.OrganizationOperationalStatusId = upd.OrganizationOperationalStatusId
		WHERE upd.OldRecordStartDateTime <> '1900-01-01 00:00:00.000'

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationOperationalStatus', 'RecordEndDateTime', 'S01EC2970'
	END CATCH
				
/***************************************************/
	-- Update Organization Records for Charter Authorizers
	BEGIN TRY
		--Grab the existing OrganizationId for Charter Authorizer organizations that already exist in the ODS.
		UPDATE Staging.CharterSchoolAuthorizer
		SET CharterSchoolAuthorizerOrganizationId = ooi.OrganizationId
		FROM Staging.CharterSchoolAuthorizer AS scsa
		JOIN ODS.OrganizationIdentifier AS ooi
			ON ooi.Identifier = scsa.CharterSchoolAuthorizer_Identifier_State
			AND scsa.CharterSchoolAuthorizerOrganizationId IS NULL
			AND ooi.RefOrganizationIdentificationSystemId = @CharterSchoolAuthorizerIdentificationSystemId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.CharterSchoolAuthorizer', 'CharterSchoolAuthorizerOrganizationId', 'S01EC2975'
	END CATCH

	DECLARE
	@charter_authorizer_xwalk TABLE (
		  OrganizationId INT
		, SourceId INT
		);

	BEGIN TRY
		-- Determine if Charter Authorizers are already in the ODS.Organization table. 
		-- If not, add them to the ODS.Organization table and capture the new IDs we created for these records in the ODS.
		MERGE INTO ODS.Organization TARGET
		USING Staging.CharterSchoolAuthorizer AS SOURCE
			ON TARGET.OrganizationId = SOURCE.CharterSchoolAuthorizerOrganizationId
		WHEN NOT MATCHED THEN 
			INSERT DEFAULT VALUES
		OUTPUT INSERTED.OrganizationId
			  ,SOURCE.Id AS SourceId
		INTO @charter_authorizer_xwalk (OrganizationId, SourceId);

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', 'OrganizationId', 'S01EC2980'
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
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.CharterSchoolAuthorizer', 'CharterSchoolAuthorizerOrganizationId', 'S01EC2981'
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

		MERGE INTO ODS.OrganizationDetail TARGET
		USING CharterSchoolAuthorizerCTE AS SOURCE
			ON TARGET.OrganizationId = SOURCE.OrganizationId
			AND TARGET.RecordStartDateTime  = SOURCE.RecordStartDateTime

		--This is the check to see if any of the fields changed, requiring an update.  It is dependent on the RecordStartDate for the incoming record being
		--     equal to the record that already exists in the ODS.  
		WHEN MATCHED AND (
			 ISNULL(TARGET.Name, '') <> ISNULL(SOURCE.Name, '')
			OR ISNULL(TARGET.RecordEndDateTime, '1/1/1900') <> ISNULL(SOURCE.RecordEndDateTime, '1/1/1900') 
			)
			THEN 
				UPDATE SET 
					TARGET.Name = SOURCE.Name
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
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S01EC2990'
	END CATCH


	--Find the old ODS.OrganizationDetail record associated with the newly inserted active record and end date the old ODS.OrganizationDetail record.
	--Filter to "Charter School Authorizing Organization" type so we don't modify any records that aren't handled by this Charter Authorizer code.
	 BEGIN TRY
			;WITH upd AS
			(
					SELECT ood.OrganizationDetailId, ooi.Identifier, ood.RecordStartDateTime,   
						 LEAD (ood.RecordStartDateTime, 1, 0) OVER (PARTITION BY ooi.Identifier ORDER BY ood.RecordStartDateTime ASC) AS OldRecordStartDateTime
					FROM ODS.OrganizationDetail AS ood
						 INNER JOIN ODS.OrganizationIdentifier AS ooi
								ON ood.OrganizationId = ooi.OrganizationId
					WHERE ood.RecordEndDateTime IS NULL
						AND RefOrganizationTypeId = @charterSchoolAuthTypeId
			)
			UPDATE ood
			SET RecordEndDateTime = upd.OldRecordStartDateTime -1
			FROM ODS.OrganizationDetail AS ood
				   INNER JOIN upd
						 ON ood.OrganizationDetailId = upd.OrganizationDetailId
			WHERE upd.OldRecordStartDateTime <> '1900-01-01 00:00:00.000'

	 END TRY

	 BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonDetail', 'RecordEndDateTime', 'S01EC2991' 
	 END CATCH

	BEGIN TRY

			--Insert Source Identifier into ODS.OrganizationIdentifier
			--Join to the ODS.OrganizationIdentifier table to ensure we're not inserting records that already exist. 
			INSERT INTO ODS.OrganizationIdentifier
						(Identifier
						,RefOrganizationIdentificationSystemId
						,OrganizationId
						,RefOrganizationIdentifierTypeId
						,RecordStartDateTime
						,RecordEndDateTime)
			SELECT DISTINCT
						scsa.CharterSchoolAuthorizer_Identifier_State AS Identifier
						,@CharterSchoolAuthorizerIdentificationSystemId AS RefOrganizationIdentificationSystemId
						,scsa.CharterSchoolAuthorizerOrganizationId AS OrganizationId
						,@OrganizationIdentificationSystem AS RefOrganizationIdentifierTypeId
						,scsa.RecordStartDateTime AS RecordStartDateTime
						,scsa.RecordEndDateTime AS RecordEndDateTime
			FROM Staging.CharterSchoolAuthorizer AS scsa
			LEFT JOIN ODS.OrganizationIdentifier AS ooi
				ON ooi.Identifier = scsa.CharterSchoolAuthorizer_Identifier_State
				AND ooi.RefOrganizationIdentificationSystemId = @CharterSchoolAuthorizerIdentificationSystemId
			WHERE ooi.Identifier IS NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationIdentifier', NULL, 'S01EC3000'
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
					,COALESCE(so_pri.SchoolOrganizationId, so_sec.SchoolOrganizationId) AS OrganizationId
					,CASE WHEN so_pri.Id IS NOT NULL THEN @PrimaryAuthorizingBodyOrganizationRelationship 
						  WHEN so_sec.Id IS NOT NULL THEN @SecondaryAuthorizingBodyOrganizationRelationship
					 END AS RefOrganizationRelationshipId
					,COALESCE( so_pri.SchoolToPrimaryCharterSchoolAuthorizer_OrganizationRelationshipId, 
							   so_sec.SchoolToSecondaryCharterSchoolAuthorizer_OrganizationRelationshipId
							  ) AS SchoolToCharterSchoolAuthorizer_OrganizationRelationshipId
			FROM ODS.OrganizationIdentifier AS ooi
			LEFT JOIN Staging.Organization AS so_pri 
				ON ooi.Identifier = so_pri.School_CharterPrimaryAuthorizer
			LEFT JOIN Staging.Organization AS so_sec 
				ON ooi.Identifier = so_sec.School_CharterSecondaryAuthorizer
			WHERE ooi.RefOrganizationIdentificationSystemId = @CharterSchoolAuthorizerIdentificationSystemId
				AND (so_pri.School_CharterPrimaryAuthorizer IS NOT NULL OR so_sec.School_CharterSecondaryAuthorizer IS NOT NULL)
		)
		
		MERGE INTO ODS.OrganizationRelationship TARGET
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
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationRelationship', NULL, 'S01EC3010'
	END CATCH

	BEGIN TRY
		-- Update relationship IDs in the staging table for the Primary Authorizer
		UPDATE Staging.Organization 
		SET SchoolToPrimaryCharterSchoolAuthorizer_OrganizationRelationshipId = xwalk.OrganizationId
		FROM Staging.Organization AS so
		JOIN @charter_authorizer_relationship_xwalk AS xwalk
			ON so.Id = xwalk.SourceId
		WHERE xwalk.RefOrganizationRelationshipId = @PrimaryAuthorizingBodyOrganizationRelationship 

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToPrimaryCharterSchoolAuthorizer_OrganizationRelationshipId', 'S01EC3020'
	END CATCH

	BEGIN TRY
		-- Update relationship IDs in the staging table for the Secondary Authorizer
		UPDATE Staging.Organization 
		SET SchoolToSecondaryCharterSchoolAuthorizer_OrganizationRelationshipId = xwalk.OrganizationId
		FROM Staging.Organization AS so
		JOIN @charter_authorizer_relationship_xwalk AS xwalk
			ON so.Id = xwalk.SourceId
		WHERE xwalk.RefOrganizationRelationshipId = @SecondaryAuthorizingBodyOrganizationRelationship 

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'SchoolToSecondaryCharterSchoolAuthorizer_OrganizationRelationshipId', 'S01EC3021'
	END CATCH
	
	BEGIN TRY
	
		WITH CharterSchoolAuthorizerCTE AS 
		(
			SELECT 
					 ooi.OrganizationId AS OrganizationId
					,orcsat.RefCharterSchoolAuthorizerTypeId AS RefCharterSchoolAuthorizerTypeId
			FROM Staging.CharterSchoolAuthorizer AS scsa
			JOIN ODS.OrganizationIdentifier AS ooi 
				ON ooi.Identifier = scsa.CharterSchoolAuthorizer_Identifier_State
			JOIN ODS.SourceSystemReferenceData AS ossrd
				ON scsa.CharterSchoolAuthorizerType = ossrd.InputCode
				AND ossrd.TableName = 'RefCharterSchoolAuthorizerType'
				AND ossrd.SchoolYear = @SchoolYear
			JOIN ODS.RefCharterSchoolAuthorizerType AS orcsat 
				ON ossrd.OutputCode = orcsat.Code

		)
		MERGE INTO ODS.K12CharterSchoolAuthorizer TARGET
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
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12CharterSchoolAuthorizer', NULL, 'S01EC3030'
	END CATCH
/***************************************************/

	-------------------------------------------------------------------
	----Create K12LEA and K12School -----------------------------------
	-------------------------------------------------------------------
---first check to see if it exists first so it's not created again? Need to add in the merge process and Record Start End Dates process for all of this

	BEGIN TRY
		INSERT INTO [ODS].[K12Lea]
					([OrganizationId]
					,[RefLeaTypeId]
					,[SupervisoryUnionIdentificationNumber]
					,[RefLEAImprovementStatusId]
					,[RefPublicSchoolChoiceStatusId]
					,[CharterSchoolIndicator]
					,[RefCharterLeaStatusId])
		SELECT DISTINCT
					 tod.LEAOrganizationId [OrganizationId]
					,rlt.RefLeaTypeId [RefLeaTypeId]
					,tod.LEA_SupervisoryUnionIdentificationNumber [SupervisoryUnionIdentificationNumber]
					,NULL [RefLEAImprovementStatusId]
					,NULL [RefPublicSchoolChoiceStatusId]
				    ,tod.LEA_CharterSchoolIndicator [CharterSchoolIndicator]
					,cls.RefCharterLeaStatusId
		FROM Staging.Organization tod
		LEFT JOIN ODS.SourceSystemReferenceData ltss
			ON tod.LEA_Type = ltss.InputCode
			AND ltss.TableName = 'RefLeaType'
			AND ltss.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefLeaType rlt
			ON ltss.OutputCode = rlt.Code
		LEFT JOIN ODS.SourceSystemReferenceData ssrd
			ON tod.LEA_CharterLeaStatus = ssrd.InputCode
			AND ssrd.TableName = 'RefCharterLeaStatus'
			AND ssrd.SchoolYear = @SchoolYear
		LEFT JOIN ODS.RefCharterLeaStatus cls
			ON ssrd.OutputCode = cls.Code
		LEFT JOIN ODS.K12Lea kl 
			ON tod.LEAOrganizationId = kl.OrganizationId
		WHERE tod.LEA_Type IS NOT NULL
			AND kl.OrganizationId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12Lea', NULL, 'S01EC3050'
	END CATCH


	--Check if the LEA_K12LeaTitleISuuportServiceId already exists
	BEGIN TRY

		UPDATE Staging.Organization
		SET LEA_K12LeaTitleISupportServiceId = k12lea.K12LeaTitleISupportServiceId
		FROM ODS.K12LeaTitleISupportService k12lea
			JOIN Staging.Organization org 
				ON org.LEAOrganizationId = k12lea.OrganizationId

	END TRY
	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12LeaTitleISupportService', NULL, 'S01EC3060'
	END CATCH

	BEGIN TRY
		INSERT ODS.K12LeaTitleISupportService (
			OrganizationId
			,RefK12LeaTitleISupportServiceId
			,RecordStartDateTime
			,RecordEndDateTime
		)
		SELECT DISTINCT
			org.LEAOrganizationId
			,ot.RefK12LEATitleISupportServiceId
			,@RecordStartDate
			,@RecordEndDate
		FROM Staging.Organization org
		LEFT JOIN ODS.K12LeaTitleISupportService k12lea 
			ON k12lea.OrganizationId = org.LEAOrganizationId
		LEFT JOIN ODS.SourceSystemReferenceData osss
			ON org.LEA_K12LeaTitleISupportService = osss.InputCode
			AND osss.TableName = 'RefK12LeaTitleISupportService'
			AND osss.SchoolYear = @SchoolYear
		LEFT JOIN ODS.RefK12LeaTitleISupportService ot 
			ON osss.OutputCode = ot.Code
		WHERE k12lea.OrganizationId IS NULL
			AND ot.RefK12LEATitleISupportServiceId IS NOT NULL
	END TRY
	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12LeaTitleISupportService', NULL, 'S01EC3070'
	END CATCH

	--Update the LEA_K12LeaTitleISupportServiceId back to Staging
	BEGIN TRY

		UPDATE Staging.Organization
		SET LEA_K12LeaTitleISupportServiceId = k12lea.K12LeaTitleISupportServiceId
		FROM ODS.K12LeaTitleISupportService k12lea
			JOIN Staging.Organization org 
				ON org.LEAOrganizationId = k12lea.OrganizationId

	END TRY
	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12LeaTitleISupportService', NULL, 'S01EC3075'
	END CATCH


	-- K12ProgramOrService LEA level
	BEGIN TRY
		UPDATE Staging.Organization
		SET LEA_K12programOrServiceId = k12ps.K12ProgramOrServiceId
		FROM ODS.K12ProgramOrService k12ps
			JOIN Staging.Organization org 
				ON org.LEAOrganizationId = k12ps.OrganizationId
	END TRY
	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12ProgramOrService', NULL, 'S01EC3080'
	END CATCH

	BEGIN TRY
		INSERT ODS.K12ProgramOrService (
			OrganizationId
			,RefMepProjectTypeId
			,RefTitleIInstructionalServicesId
			,RefTitleIProgramTypeId
			,RecordStartDateTime
			,RecordEndDateTime
		)
		SELECT DISTINCT
			org.LEAOrganizationId
			,remMep.RefMepProjectTypeId
			,ot1.RefTitleIInstructionalServicesId
			,ot2.RefTitleIProgramTypeId
			,@RecordStartDate
			,@RecordEndDate
		FROM Staging.Organization org
		LEFT JOIN ODS.K12ProgramOrService k12lea 
			ON k12lea.OrganizationId = org.LEAOrganizationId
		LEFT JOIN ODS.SourceSystemReferenceData ss1
			ON org.LEA_TitleIinstructionalService = ss1.InputCode
			AND ss1.TableName = 'RefTitleIInstructionalServices'
			AND ss1.SchoolYear = @SchoolYear
		LEFT JOIN ODS.RefTitleIInstructionalServices ot1 
			ON ss1.OutputCode = ot1.Code
		LEFT JOIN ODS.SourceSystemReferenceData ss2
			ON org.LEA_TitleIProgramType = ss2.InputCode
			AND ss2.TableName = 'RefTitleIProgramType'
			AND ss2.SchoolYear = @SchoolYear
		LEFT JOIN ODS.RefTitleIProgramType ot2
			ON ss2.OutputCode = ot2.Code
		-- MepProjectType
		LEFT JOIN ODS.SourceSystemReferenceData ssmep
			ON ssmep.InputCode = org.LEA_MepProjectType
			AND ssmep.TableName = 'RefMepProjectType'
			AND ssmep.SchoolYear = @SchoolYear
		LEFT JOIN ODS.RefMepProjectType remMep
			ON remMep.Code = ssmep.OutputCode 
		WHERE k12lea.OrganizationId IS NULL

	END TRY
	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12ProgramOrService', NULL, 'S01EC3090'
	END CATCH

	--Update the LEA_K12ProgramOrServiceId back to Staging
	 BEGIN TRY

		UPDATE Staging.Organization
		SET LEA_K12programOrServiceId = k12ps.K12ProgramOrServiceId
		FROM ODS.K12ProgramOrService k12ps
			JOIN Staging.Organization org 
				ON org.LEAOrganizationId = k12ps.OrganizationId

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Organization', 'School_OrganizationWebsiteId', 'S01EC2910'	
	END CATCH


	-- K12ProgramOrService School level
	BEGIN TRY
		UPDATE Staging.Organization
		SET School_K12programOrServiceId = k12ps.K12ProgramOrServiceId
		FROM ODS.K12ProgramOrService k12ps
		JOIN Staging.Organization org 
			ON org.SchoolOrganizationId = k12ps.OrganizationId
	END TRY
	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12ProgramOrService', NULL, 'S01EC3100'
	END CATCH

	BEGIN TRY
		INSERT ODS.K12ProgramOrService (
			OrganizationId
			,RefMepProjectTypeId
			,RecordStartDateTime
			,RecordEndDateTime
		)
		SELECT DISTINCT
			org.SchoolOrganizationId
			,remMep.RefMepProjectTypeId
			,@RecordStartDate
			,@RecordEndDate
		FROM Staging.Organization org
		LEFT JOIN ODS.K12ProgramOrService k12lea 
			ON k12lea.OrganizationId = org.SchoolOrganizationId
		-- MepProjectType
		LEFT JOIN ODS.SourceSystemReferenceData ssmep
			ON ssmep.InputCode = org.School_MepProjectType
			AND ssmep.TableName = 'RefMepProjectType'
			AND ssmep.SchoolYear = @SchoolYear
		LEFT JOIN ODS.RefMepProjectType remMep
			ON remMep.Code = ssmep.OutputCode 
		WHERE org.SchoolOrganizationId IS NOT NULL 
			AND org.SchoolYear = @SchoolYear

	END TRY
	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12ProgramOrService', NULL, 'S01EC3110'
	END CATCH

	-- Update the K12ProgramOrService back to the Staging record
	BEGIN TRY
		UPDATE Staging.Organization
		SET School_K12programOrServiceId = k12ps.K12ProgramOrServiceId
		FROM ODS.K12ProgramOrService k12ps
		JOIN Staging.Organization org 
			ON org.SchoolOrganizationId = k12ps.OrganizationId
	END TRY
	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12ProgramOrService', NULL, 'S01EC3100'
	END CATCH


	--Insert K12School records
	BEGIN TRY
		INSERT INTO [ODS].[K12School](
			[OrganizationId]
			,[RefSchoolTypeId]
			,[RefSchoolLevelId]
			,[RefAdministrativeFundingControlId]
			,[CharterSchoolIndicator]
			,[RefCharterSchoolTypeId]
			,[RefIncreasedLearningTimeTypeId]
			,[RefStatePovertyDesignationId]
			,[CharterSchoolApprovalYear]
			,[AccreditationAgencyName]
			,[CharterSchoolOpenEnrollmentIndicator]
			,[CharterSchoolContractApprovalDate]
			,[CharterSchoolContractIdNumber]
			,[CharterSchoolContractRenewalDate]
			--,[K12CharterSchoolManagementOrganizationId]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
		)
		SELECT DISTINCT
			tod.SchoolOrganizationId [OrganizationId]
			,rst.RefSchoolTypeId [RefSchoolTypeId]
			,NULL [RefSchoolLevelId] --Do we need this?
			,NULL [RefAdministrativeFundingControlId]
			,tod.School_CharterSchoolIndicator	[CharterSchoolIndicator]
			,NULL [RefCharterSchoolTypeId]
			,NULL [RefIncreasedLearningTimeTypeId]
			,rstpov.RefStatePovertyDesignationId [RefStatePovertyDesignationId]
			,NULL [CharterSchoolApprovalYear]
			,NULL [AccreditationAgencyName]
			,tod.School_CharterSchoolOpenEnrollmentIndicator	[CharterSchoolOpenEnrollmentIndicator]
			,tod.School_CharterContractApprovalDate [CharterSchoolContractApprovalDate]
			,tod.School_CharterContractIDNumber [CharterSchoolContractIdNumber]
			,tod.School_CharterContractRenewalDate [CharterSchoolContractRenewalDate]
			,@RecordStartDate
			,@RecordEndDate
		FROM Staging.Organization tod
		LEFT JOIN ODS.SourceSystemReferenceData stss
			ON tod.School_Type = stss.InputCode
			AND stss.TableName = 'RefSchoolType'
			AND stss.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefSchoolType rst
			ON stss.OutputCode = rst.Code
		LEFT JOIN ODS.K12School ks 
			ON tod.SchoolOrganizationId = ks.OrganizationId
			AND ks.RecordStartDateTime = @RecordStartDate
			AND ks.RecordEndDateTime = @RecordEndDate
		LEFT JOIN ODS.K12CharterSchoolManagementOrganization mo 
			ON mo.OrganizationId=tod.SchoolOrganizationId
		-- state poverty designation
		LEFT JOIN ODS.SourceSystemReferenceData stsspov
			ON tod.School_StatePovertyDesignation = stsspov.InputCode
			AND stsspov.TableName = 'RefStatePovertyDesignation'
			AND stsspov.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefStatePovertyDesignation rstpov
			ON stsspov.OutputCode = rstpov.Code
		WHERE ks.K12SchoolId IS NULL
			AND tod.School_Name IS NOT NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12School', NULL, 'S01EC3120'
	END CATCH

	-------------------------------------------------------------------
	----Create Grades Offered -----
	-------------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.OrganizationGradeOffered
		SET OrganizationId = oi.OrganizationId
		FROM Staging.OrganizationGradeOffered ogo
		JOIN ods.OrganizationIdentifier oi
			ON ogo.OrganizationIdentifier = oi.Identifier
			AND oi.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
			AND oi.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationGradeOffered', 'OrganizationId', 'S01EC3140'
	END CATCH

	BEGIN TRY
		INSERT INTO ODS.K12SchoolGradeOffered
		SELECT 
			  sch.K12SchoolId
			, rgl.RefGradeLevelId
			, tod.RecordStartDateTime
			, tod.RecordEndDateTime
		FROM Staging.OrganizationGradeOffered tod
		JOIN ODS.K12School sch 
			ON tod.OrganizationId = sch.OrganizationId
		JOIN ODS.SourceSystemReferenceData grd
			ON tod.GradeOffered = grd.InputCode
			AND grd.TableName = 'RefGradeLevel'
			AND grd.SchoolYear = @SchoolYear
		JOIN ODS.RefGradeLevel rgl 
			ON grd.OutputCode = rgl.Code
		JOIN ODS.RefGradeLevelType rglt 
			ON rgl.RefGradeLevelTypeId = rglt.RefGradeLevelTypeId 
			AND rglt.Code = '000131'
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12SchoolGradeOffered', NULL, 'S01EC3150'
	END CATCH

	-------------------------------------------------------------------
	----Create Location, OrganizationLocation and LocationAddress -----
	-------------------------------------------------------------------

	---------------------------------------------------------------
	---- Organization Address Information -------------------------
	---------------------------------------------------------------

	---Update the OrganizationId on the staging table

	--SEA Level
	BEGIN TRY
		UPDATE Staging.OrganizationAddress
		SET OrganizationId = orgid.OrganizationId
		FROM Staging.OrganizationAddress soa
		JOIN ODS.OrganizationIdentifier orgid
			ON soa.OrganizationIdentifier = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd
			ON orgid.OrganizationId = orgd.OrganizationId
		JOIN ODS.SourceSystemReferenceData osss
			ON soa.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = @SchoolYear
		JOIN ODS.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN ODS.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId = @OrgTypeId_SEA
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_State_Fed
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_State
			AND orgd.RefOrganizationTypeId = ot.RefOrganizationTypeId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'OrganizationId', 'S01EC3160'
	END CATCH

	--LEA Level
	BEGIN TRY
		UPDATE Staging.OrganizationAddress
		SET OrganizationId = orgid.OrganizationId
		FROM Staging.OrganizationAddress soa
		JOIN ODS.OrganizationIdentifier orgid 
			ON soa.OrganizationIdentifier = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd
			ON orgid.OrganizationId = orgd.OrganizationId
		JOIN ODS.SourceSystemReferenceData osss
			ON soa.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = @SchoolYear
		JOIN ODS.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN ODS.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId in (@OrgTypeId_LEANotFederal, @OrgTypeId_LEA)
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_LEA_SEA
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_LEA
			AND orgd.RefOrganizationTypeId = ot.RefOrganizationTypeId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'OrganizationId', 'S01EC3170'
	END CATCH

	--School Level
	BEGIN TRY
		UPDATE Staging.OrganizationAddress
		SET OrganizationId = orgid.OrganizationId
		FROM Staging.OrganizationAddress soa
		JOIN ODS.OrganizationIdentifier orgid 
			ON soa.OrganizationIdentifier = orgid.Identifier
		JOIN ODS.OrganizationDetail orgd
			ON orgid.OrganizationId = orgd.OrganizationId
		JOIN ODS.SourceSystemReferenceData osss
			ON soa.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = @SchoolYear
		JOIN ODS.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN ODS.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		WHERE ot.RefOrganizationTypeId in (@OrgTypeId_K12School, @OrgTypeId_K12SchoolNotFederal)
			AND orgid.RefOrganizationIdentificationSystemId = @OrgIdSystemId_School_SEA
			AND orgid.RefOrganizationIdentifierTypeId = @OrgIdTypeId_School
			AND orgd.RefOrganizationTypeId = ot.RefOrganizationTypeId
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'OrganizationId', 'S01EC3180'
	END CATCH

	---First update the Location Id

	BEGIN TRY

		UPDATE Staging.OrganizationAddress
		SET LocationId = orgl.LocationId
		FROM Staging.OrganizationAddress soa
		JOIN ODS.OrganizationLocation orgl
			ON soa.OrganizationId = orgl.OrganizationId
			AND soa.RecordStartDateTime = orgl.RecordStartDateTime
		JOIN ODS.LocationAddress la
			ON orgl.LocationId = la.LocationId
		JOIN ODS.RefOrganizationLocationType rolt
			ON orgl.RefOrganizationLocationTypeId = rolt.RefOrganizationLocationTypeId
		JOIN ODS.SourceSystemReferenceData ossr
			ON soa.AddressTypeForOrganization = ossr.InputCode
			AND ossr.TableName = 'RefOrganizationLocationType'
			AND ossr.SchoolYear = @SchoolYear
		WHERE ossr.OutputCode = rolt.Code

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'LocationId', 'S01EC3190'
	END CATCH


	---Update the LocationAddress where corrections need to be made

	BEGIN TRY 

		UPDATE ODS.LocationAddress
		SET   StreetNumberAndName = soa.AddressStreetNumberAndName
			, ApartmentRoomOrSuiteNumber = soa.AddressApartmentRoomOrSuite
			, City = soa.AddressCity
			, RefStateId = ors.RefStateId
			, PostalCode = soa.AddressPostalCode
		FROM ODS.LocationAddress la
		JOIN Staging.OrganizationAddress soa
			ON la.LocationId = soa.LocationId
		JOIN ODS.SourceSystemReferenceData ossr
			ON soa.AddressStateAbbreviation = ossr.InputCode
			AND ossr.TableName = 'RefState'
			AND ossr.SchoolYear = @SchoolYear
		JOIN ODS.RefState ors
			ON ossr.OutputCode = ors.Code
		WHERE (ISNULL(la.StreetNumberAndName, '') <> ISNULL(soa.AddressStreetNumberAndName, '')
				OR ISNULL(la.ApartmentRoomOrSuiteNumber, '') <> ISNULL(soa.AddressApartmentRoomOrSuite, '')
				OR ISNULL(la.City, '') <> ISNULL(soa.AddressCity, '')
				OR ISNULL(la.RefStateId, '99') <> ISNULL([App].[GetRefStateId](soa.AddressStateAbbreviation), '99') 
				OR ISNULL(la.PostalCode, '') <> ISNULL(soa.AddressPostalCode, ''))

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.LocationAddress', NULL, 'S01EC3200'
	END CATCH

	-- Update the OrganizationLocation where updates/corrections need to be made

	BEGIN TRY

		UPDATE ODS.OrganizationLocation
		SET RecordEndDateTime = soa.RecordEndDateTime
		FROM ODS.OrganizationLocation ool
		JOIN Staging.OrganizationAddress soa
			ON ool.LocationId = soa.LocationId
		WHERE soa.RecordEndDateTime IS NOT NULL
		AND ISNULL(ool.RecordEndDateTime, '1/1/1900') <> ISNULL(soa.RecordEndDateTime, '1/1/1900')

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationLocation', 'RecordEndDateTime', 'S01EC3210'
	END CATCH

	-- Create the New Location records (ODS.Location, ODS.LocationAddress, ODS.OrganizationLocation)

	BEGIN TRY

		DECLARE @DistinctNewLocations TABLE (
			  LocationId INT NULL
			, OrganizationLocationTypeId INT
			, AddressTypeForOrganization VARCHAR(50)
			, OrganizationId INT
			, AddressStreetNumberAndName VARCHAR(50)
			, AddressApartmentRoomOrSuite VARCHAR(50)
			, AddressCity VARCHAR(30)
			, RefStateId INT
			, AddressPostalCode VARCHAR(17)
			, RecordStartDateTime DATETIME
			, RecordEndDateTime DATETIME
		)

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewLocations', NULL, 'S01EC3220'
	END CATCH

	BEGIN TRY 

		INSERT INTO @DistinctNewLocations
		SELECT DISTINCT
			  NULL
			, roglt.RefOrganizationLocationTypeId
			, soa.AddressTypeForOrganization
			, soa.OrganizationId
			, soa.AddressStreetNumberAndName
			, soa.AddressApartmentRoomOrSuite
			, soa.AddressCity
			, ors.RefStateId
			, soa.AddressPostalCode
			, soa.RecordStartDateTime
			, soa.RecordEndDateTime
		FROM Staging.OrganizationAddress soa
		JOIN ODS.SourceSystemReferenceData ossr
			ON soa.AddressTypeForOrganization = ossr.InputCode
			AND ossr.TableName = 'RefOrganizationLocationType'
			AND ossr.SchoolYear = @SchoolYear
		JOIN ODS.RefOrganizationLocationType roglt
			ON ossr.OutputCode = roglt.Code
		JOIN ODS.SourceSystemReferenceData ossrState
			ON soa.AddressStateAbbreviation = ossrState.InputCode
			AND ossrState.TableName = 'RefState'
			AND ossrState.SchoolYear = @SchoolYear
		JOIN ODS.RefState ors
			ON ossrState.OutputCode = ors.Code
		WHERE soa.LocationId IS NULL
			AND soa.OrganizationId IS NOT NULL

	END TRY
		
	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@DistinctNewLocations', NULL, 'S01EC3230'
	END CATCH

	BEGIN TRY

		DECLARE @NewLocations TABLE (
			  LocationId INT NULL
			, OrganizationLocationTypeId INT
			, AddressTypeForOrganization VARCHAR(50)
			, OrganizationId INT
			, AddressStreetNumberAndName VARCHAR(50)
			, AddressApartmentRoomOrSuite VARCHAR(50)
			, AddressCity VARCHAR(30)
			, RefStateId INT
			, AddressPostalCode VARCHAR(17)
			, RecordStartDateTime DATETIME
			, RecordEndDateTime DATETIME
		)

		MERGE ODS.Location AS TARGET
		USING @DistinctNewLocations AS SOURCE
			ON 1 = 0 ---always insert
		WHEN NOT MATCHED THEN
			INSERT DEFAULT VALUES
		OUTPUT
			  INSERTED.LocationId AS LocationId
			, SOURCE.OrganizationLocationTypeId
			, SOURCE.AddressTypeForOrganization
			, SOURCE.OrganizationId
			, SOURCE.AddressStreetNumberAndName
			, SOURCE.AddressApartmentRoomOrSuite
			, SOURCE.AddressCity
			, SOURCE.RefStateId
			, SOURCE.AddressPostalCode
			, SOURCE.RecordStartDateTime
			, SOURCE.RecordEndDateTime
		INTO @NewLocations;

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Location', NULL, 'S01EC3240'
	END CATCH

	BEGIN TRY

		INSERT INTO ODS.LocationAddress
		SELECT    nl.LocationId
				, nl.AddressStreetNumberAndName
				, nl.AddressApartmentRoomOrSuite
				, NULL
				, nl.AddressCity
				, nl.RefStateId
				, nl.AddressPostalCode
				, NULL
				, NULL
				, NULL
				, NULL
				, NULL
				, NULL
		FROM @NewLocations nl

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.LocationAddress', NULL, 'S01EC3250'
	END CATCH

	BEGIN TRY

		INSERT INTO ODS.OrganizationLocation
		SELECT    nl.OrganizationId
				, nl.LocationId
				, nl.OrganizationLocationTypeId
				, nl.RecordStartDateTime
				, nl.RecordEndDateTime
		FROM @NewLocations nl

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationLocation', NULL, 'S01EC3260'
	END CATCH

		-- Update the LocationId on the Staging.OrganizationAddress table for troubleshooting purposes
	
	BEGIN TRY

		UPDATE Staging.OrganizationAddress
		SET LocationId = ool.LocationId
		FROM Staging.OrganizationAddress soa
		JOIN @NewLocations nl
			ON soa.OrganizationId = nl.OrganizationId
			AND soa.AddressTypeForOrganization = nl.AddressTypeForOrganization
		JOIN ODS.OrganizationLocation ool
			ON nl.LocationId = ool.LocationId
		WHERE soa.LocationID IS NULL
			AND ool.LocationId IS NOT NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationAddress', 'LocationId', 'S01EC3270'
	END CATCH

		--End Date any historical record where a new record was provided, but the older record was not end dated

	BEGIN TRY

        UPDATE r SET r.RecordEndDateTime = s.RecordStartDateTime - 1
        FROM ODS.OrganizationLocation r
        JOIN (
                SELECT 
                    OrganizationId
					, RefOrganizationLocationTypeId
					, MAX(OrganizationLocationId) AS OrganizationLocationId
                    , MAX(RecordStartDateTime) AS RecordStartDateTime
                FROM ODS.OrganizationLocation
                WHERE RecordEndDateTime IS NULL
					AND RecordStartDateTime IS NOT NULL
                GROUP BY OrganizationId, RefOrganizationLocationTypeId, OrganizationLocationId, RecordStartDateTime
        ) s ON r.OrganizationId = s.OrganizationId
				AND r.RefOrganizationLocationTypeId = s.RefOrganizationLocationTypeId
                AND r.OrganizationLocationId <> s.OrganizationLocationId 
                AND r.RecordEndDateTime IS NULL
				AND r.RecordStartDateTime IS NOT NULL
				AND r.RecordStartDateTime < s.RecordStartDateTime

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationLocation', 'RecordEndDateTime', 'S01EC3280'
	END CATCH


	-------------------------------------------------------------------
	----Create OrganizationCalendar and OrganizationCalendarSession----
	-------------------------------------------------------------------

	BEGIN TRY

		INSERT INTO [ODS].[OrganizationCalendar]
				   ([OrganizationId]
				   ,[CalendarCode]
				   ,[CalendarDescription]
				   ,[CalendarYear])
		SELECT DISTINCT
					orgd.OrganizationId [OrganizationId]
				   ,orgid.Identifier [CalendarCode]
				   ,orgid.Identifier [CalendarDescription]
				   ,@SchoolYear AS [CalendarYear]
		FROM ODS.OrganizationDetail orgd
		JOIN ODS.OrganizationIdentifier orgid 
			ON orgd.OrganizationId = orgid.OrganizationId
		JOIN ODS.RefOrganizationType rot 
			ON orgd.RefOrganizationTypeId = rot.RefOrganizationTypeId
		JOIN ODS.RefOrganizationIdentificationSystem rois 
			ON orgid.RefOrganizationIdentificationSystemId = rois.RefOrganizationIdentificationSystemId
		LEFT JOIN ODS.OrganizationCalendar orgc 
			ON orgd.OrganizationId = orgc.OrganizationId
			AND orgc.CalendarYear = @SchoolYear
		WHERE rot.Code IN ('LEA', 'K12School')
		AND rois.Code = 'SEA'
		AND orgc.OrganizationCalendarId IS NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationCalendar', NULL, 'S01EC3290'
	END CATCH


	BEGIN TRY

		INSERT INTO [ODS].[OrganizationCalendarSession]
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
				   ,[SessionEndTime])
		SELECT DISTINCT 
					NULL [Designator]
				   ,@RecordStartDate [BeginDate]
				   ,@RecordEndDate [EndDate]
				   ,(SELECT  [RefSessionTypeId] FROM [ODS].[RefSessionType] WHERE Code = 'FullSchoolYear') [RefSessionTypeId] 
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
		FROM ODS.OrganizationCalendar orgc
		LEFT JOIN ODS.OrganizationCalendarSession orgcs 
			ON orgc.OrganizationCalendarId = orgcs.OrganizationCalendarId 
			AND orgc.CalendarYear = @SchoolYear
		WHERE orgc.CalendarYear = @SchoolYear
			AND orgcs.OrganizationCalendarId IS NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationCalendarSession', NULL, 'S01EC3300'
	END CATCH

	-------------------------------------------------------------------
	----Move Organization Financial Data Into Appropriate Tables ------
	-------------------------------------------------------------------
	BEGIN TRY

		INSERT INTO [ODS].[K12LeaFederalFunds]
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
		   ,[RecordEndDateTime])
		SELECT DISTINCT
		   orgcs.OrganizationCalendarSessionId [OrganizationCalendarSessionId] 
		   ,NULL [InnovativeProgramsFundsReceived]
		   ,NULL [InnovativeDollarsSpent]
		   ,NULL [InnovativeDollarsSpentOnStrategicPriorities]
		   ,NULL [PublicSchoolChoiceFundsSpent]
		   ,NULL [SesFundsSpent]
		   ,NULL [SesSchoolChoice20PercentObligation]
		   ,NULL [RefRlisProgramUseId]
		   ,orgff.ParentalInvolvementReservationFunds [ParentalInvolvementReservationFunds]
		   ,@RecordStartDate [RecordStartDateTime]
		   ,@RecordEndDate [RecordEndDateTime]	
		FROM Staging.OrganizationFederalFunding orgff
		JOIN ODS.OrganizationIdentifier orgid 
			ON orgff.OrganizationIdentifier = orgid.Identifier
		JOIN ODS.OrganizationCalendar orgc 
			ON orgid.OrganizationId = orgc.OrganizationId
		JOIN ODS.OrganizationCalendarSession orgcs 
			ON orgc.OrganizationCalendarId = orgcs.OrganizationCalendarId
		JOIN ODS.SourceSystemReferenceData osss
			ON orgff.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationType'
			AND osss.TableFilter = '001156'
			AND osss.SchoolYear = @SchoolYear
		JOIN ODS.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN ODS.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = osss.TableFilter
		JOIN ODS.RefOrganizationIdentificationSystem rois 
			ON orgid.RefOrganizationIdentificationSystemId = rois.RefOrganizationIdentificationSystemId
		WHERE ot.Code = 'LEA'
		AND rois.Code = 'SEA'

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12LeaFederalFunds', NULL, 'S01EC3310'
	END CATCH

	BEGIN TRY

		INSERT INTO [ODS].[K12FederalFundAllocation]
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
				   ,[RecordEndDateTime])
		SELECT DISTINCT
					orgcs.OrganizationCalendarSessionId							[OrganizationCalendarSessionId]
				   ,orgff.FederalProgramCode									[FederalProgramCode]
				   ,ffad.RefFederalProgramFundingAllocationTypeId				[RefFederalProgramFundingAllocationTypeId]
				   ,orgff.FederalProgramsFundingAllocation						[FederalProgramsFundingAllocation]
				   ,NULL [FundsTransferAmount]
				   ,NULL [SchoolImprovementAllocation]
				   ,NULL [LeaTransferabilityOfFunds]
				   ,NULL [RefLeaFundsTransferTypeId]
				   ,NULL [SchoolImprovementReservedPercent]
				   ,NULL [SesPerPupilExpenditure]
				   ,NULL [NumberOfImmigrantProgramSubgrants]
				   ,REAPot.RefReapAlternativeFundingStatusId [RefReapAlternativeFundingStatusId]
				   ,@RecordStartDate [RecordStartDateTime]
				   ,@RecordEndDate [RecordEndDateTime]
		FROM Staging.OrganizationFederalFunding orgff
		JOIN ODS.OrganizationIdentifier orgid 
			ON orgff.OrganizationIdentifier = orgid.Identifier
		JOIN ODS.OrganizationCalendar orgc 
			ON orgid.OrganizationId = orgc.OrganizationId
		JOIN ODS.OrganizationCalendarSession orgcs 
			ON orgc.OrganizationCalendarId = orgcs.OrganizationCalendarId
		JOIN ODS.SourceSystemReferenceData osss
			ON orgff.OrganizationType = osss.InputCode
			AND osss.TableName = 'RefOrganizationIdentificationSystem'
			AND osss.TableFilter = 'Organization'
			AND osss.SchoolYear = @SchoolYear
		JOIN ODS.RefOrganizationType ot 
			ON osss.OutputCode = ot.Code
		JOIN ODS.SourceSystemReferenceData ffa 
			ON orgff.FederalProgramFundingAllocationType = ffa.InputCode
			AND ffa.TableName = 'RefFederalProgramFundingAllocationType'
			AND ffa.SchoolYear = @SchoolYear
		JOIN ODS.RefFederalProgramFundingAllocationType ffad
			ON ffa.OutputCode = ffad.Code
		JOIN ODS.RefOrganizationIdentificationSystem rois 
			ON orgid.RefOrganizationIdentificationSystemId = rois.RefOrganizationIdentificationSystemId
		LEFT JOIN ODS.RefReapAlternativeFundingStatus REAPot 
			ON orgff.REAPAlternativeFundingStatusCode = REAPot.Code
		LEFT JOIN [ODS].[K12FederalFundAllocation] k12fs ON k12fs.OrganizationCalendarSessionId = orgcs.OrganizationCalendarSessionId 
		WHERE (
				(ot.Code = 'LEA' AND rois.Code = 'SEA')
				OR
				(ot.Code = 'SEA' AND rois.Code = 'Federal')	
			  )
		AND (
			orgff.FederalProgramCode IS NOT NULL
			OR orgff.FederalProgramsFundingAllocation IS NOT NULL
			OR orgff.ParentalInvolvementReservationFunds IS NOT NULL	
			OR orgff.REAPAlternativeFundingStatusCode IS NOT NULL
			)		
		AND k12fs.K12FederalFundAllocationId IS NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12FederalFundAllocation', NULL, 'S01EC3320'
	END CATCH


	BEGIN TRY
		--==================
		INSERT INTO [ODS].[K12FederalFundAllocation]
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
				   ,[RecordEndDateTime])
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
				   ,@RecordStartDate [RecordStartDateTime]
				   ,@RecordEndDate [RecordEndDateTime]
		FROM Staging.Organization orgff
		JOIN ODS.OrganizationCalendar orgc 
			ON orgc.OrganizationId = orgff.SchoolOrganizationId
		JOIN ODS.OrganizationCalendarSession orgcs 
			ON orgcs.OrganizationCalendarId = orgc.OrganizationCalendarId
		WHERE orgff.SchoolOrganizationId IS NOT NULL 
			AND orgff.SchoolYear = @SchoolYear

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12FederalFundAllocation', NULL, 'S01EC3330'
	END CATCH

	BEGIN TRY

		INSERT INTO [ODS].[K12SchoolImprovement]
			([K12SchoolId]
			 ,[RefSchoolImprovementStatusId]
			 ,[RefSchoolImprovementFundsId]
			 ,[RefSigInterventionTypeId]
			 ,[SchoolImprovementExitDate]
			 )
		SELECT DISTINCT
			k12.K12SchoolId	[K12SchoolId]
			,NULL [RefSchoolImprovementStatusId]
			,(SELECT ODS.RefSchoolImprovementFunds.RefSchoolImprovementFundsId FROM ODS.RefSchoolImprovementFunds WHERE ODS.RefSchoolImprovementFunds.Code = 'Yes')
			,NULL [RefSigInterventionTypeId]
			,NULL [SchoolImprovementExitDate]
		FROM Staging.Organization orgff
		JOIN ODS.K12School k12 ON k12.OrganizationId = orgff.SchoolOrganizationId
		JOIN ODS.OrganizationCalendar orgc 
			ON orgc.OrganizationId = orgff.SchoolOrganizationId
		JOIN ODS.OrganizationCalendarSession orgcs 
			ON orgcs.OrganizationCalendarId = orgc.OrganizationCalendarId
		WHERE orgff.SchoolOrganizationId IS NOT NULL
			AND orgff.SchoolYear = @SchoolYear

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12SchoolImprovement', NULL, 'S01EC3340'
	END CATCH
	--==================

	--------------------------------------
	-- Add 'McKinney-Vento subgrant'
	--------------------------------------

	-- [ODS].[FinancialAccount] is LEA specific
	BEGIN TRY

		INSERT INTO [ODS].[FinancialAccount]
		(
			[Name]
			,[Description]
			,[FederalProgramCode]
		)
		SELECT DISTINCT o.LEA_Name + ' McKinney-Vento subgrant' 
			 , o.LEA_Name + ' McKinney-Vento subgrant' 
			 , '84.196'
		FROM Staging.Organization o
		INNER JOIN 	ODS.OrganizationIdentifier orgid 
			ON o.LEA_Identifier_State = orgid.Identifier
		INNER JOIN 	ODS.OrganizationCalendar orgc 
			ON orgid.OrganizationId = orgc.OrganizationId
		INNER JOIN ODS.OrganizationCalendarSession orgcs 
			ON orgc.OrganizationCalendarId = orgcs.OrganizationCalendarId
		LEFT JOIN [ODS].[FinancialAccount] fa
			ON CHARINDEX(o.LEA_Name, fa.Name) > 0
		WHERE o.LEA_McKinneyVentoSubgrantRecipient = 1
			AND fa.FinancialAccountId  IS NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.FinancialAccount', NULL, 'S01EC3350'
	END CATCH

	BEGIN TRY

		INSERT INTO [ODS].[OrganizationFinancial]
		(
			[FinancialAccountId]
			,[OrganizationCalendarSessionId]
		)
		SELECT DISTINCT fa.FinancialAccountId
		 , orgcs.OrganizationCalendarSessionId
		FROM Staging.Organization o
		INNER JOIN 	ODS.OrganizationIdentifier orgid 
			ON o.LEA_Identifier_State = orgid.Identifier
		INNER JOIN 	ODS.OrganizationCalendar orgc 
			ON orgid.OrganizationId = orgc.OrganizationId
		INNER JOIN ODS.OrganizationCalendarSession orgcs 
			ON orgc.OrganizationCalendarId = orgcs.OrganizationCalendarId
		INNER JOIN [ODS].[FinancialAccount] fa
			ON CHARINDEX(o.LEA_Name, fa.Name) > 0
		LEFT JOIN [ODS].[OrganizationFinancial] orgf 
			ON orgf.OrganizationCalendarSessionId = orgcs.OrganizationCalendarSessionId
			AND orgf.FinancialAccountId = fa.FinancialAccountId
		WHERE o.LEA_McKinneyVentoSubgrantRecipient = 1
			AND orgf.OrganizationFinancialId  IS NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationFinancial', NULL, 'S01EC3360'
	END CATCH

		--------------------------------------
		--Insert LEA Gun Free Schools Act Reporting Status --
		--------------------------------------

	BEGIN TRY

		INSERT INTO [ODS].[OrganizationFederalAccountability]
        (
			[OrganizationId]
			,[RefGunFreeSchoolsActStatusReportingId]
		)
		SELECT DISTINCT 
			orgst.LEAOrganizationId
			,gunfreeType.RefGunFreeSchoolsActStatusReportingId
		FROM Staging.Organization orgst
		LEFT JOIN [ODS].[SourceSystemReferenceData] srcRef 
			ON srcRef.InputCode = orgst.LEA_GunFreeSchoolsActReportingStatus
			AND srcRef.TableName='RefGunFreeSchoolsActReportingStatus' 
			AND srcRef.SchoolYear = @SchoolYear
		LEFT JOIN [ODS].[RefGunFreeSchoolsActReportingStatus] gunfreeType 
			ON gunfreeType.Code = srcRef.OutputCode

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationFederalAccountability', NULL, 'S01EC3370'
	END CATCH

		--------------------------------------
		--Insert School Gun Free Schools Act Reporting Status --
		--------------------------------------

	BEGIN TRY

		INSERT INTO [ODS].[OrganizationFederalAccountability]
        (
			[OrganizationId]
			,[RefGunFreeSchoolsActStatusReportingId]
			,[RefReconstitutedStatusId]
		)
		SELECT DISTINCT 
			orgst.SchoolOrganizationId
			,gunfreeType.RefGunFreeSchoolsActStatusReportingId
			,recon.RefReconstitutedStatusId
		FROM Staging.Organization orgst
		LEFT JOIN [ODS].[SourceSystemReferenceData] srcRef 
			ON srcRef.InputCode = orgst.School_GunFreeSchoolsActReportingStatus
			AND srcRef.TableName='RefGunFreeSchoolsActReportingStatus' 
			AND srcRef.SchoolYear = @SchoolYear
		LEFT JOIN [ODS].[RefGunFreeSchoolsActReportingStatus] gunfreeType 
			ON gunfreeType.Code = srcRef.OutputCode
		LEFT JOIN [ODS].[SourceSystemReferenceData] ssrecon 
			ON ssrecon.InputCode = orgst.School_ReconstitutedStatus
			AND ssrecon.TableName='RefReconstitutedStatus' 
			AND ssrecon.SchoolYear = @SchoolYear
		LEFT JOIN [ODS].[RefReconstitutedStatus] recon 
			ON recon.Code = ssrecon.OutputCode
		WHERE orgst.SchoolOrganizationId is not null

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationFederalAccountability', NULL, 'S01EC3380'
	END CATCH

		--------------------------------------
		--Insert RefReconstituted Status --
		--------------------------------------

		--INSERT INTO [ODS].[OrganizationFederalAccountability]
  --      (
		--	[OrganizationId]
		--	,[RefReconstitutedStatusId]
		--)
		--SELECT DISTINCT 
		--	orgst.LEAOrganizationId
		--	,recon.RefReconstitutedStatusId
		--FROM Staging.Organization orgst
		--JOIN [ODS].[RefReconstitutedStatus] recon 
		--	ON recon.Code = orgst.School_ReconstitutedStatus

	--------------------------------------
	--Insert Cheif State School Officer --
	--------------------------------------

	CREATE TABLE #PersonIdtoPersonIdentifier 
		(PersonID INT
		,Identifier VARCHAR(50))

	BEGIN TRY
		MERGE INTO [ODS].[Person] as tgt
		USING Staging.StateDetail as nisl
		ON 1 = 2  --guarantees no matches
		WHEN NOT MATCHED BY TARGET THEN
		INSERT (PersonMasterId)
		  VALUES(NULL)
		  OUTPUT INSERTED.PersonID, nisl.SeaContact_Identifier INTO #PersonIdtoPersonIdentifier;
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Person', NULL, 'S01EC3390'
	END CATCH

	BEGIN TRY
		UPDATE Staging.StateDetail
		SET PersonId = pt.PersonID
		FROM Staging.StateDetail nisl
		JOIN #PersonIdtoPersonIdentifier pt ON nisl.SeaContact_Identifier = pt.Identifier
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StateDetail', 'PersonId', 'S01EC3400'
	END CATCH

	BEGIN TRY
		INSERT INTO [ODS].[PersonDetail]
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
				   ,[RecordEndDateTime])
		SELECT DISTINCT
					PersonId [PersonId]
				   ,SeaContact_FirstName [FirstName]
				   ,NULL [MiddleName]
				   ,SeaContact_LastOrSurname [LastName]
				   ,NULL [GenerationCode]
				   ,SeaContact_PositionTitle [Prefix]
				   ,NULL [Birthdate]
				   ,NULL [RefSexId]
				   ,NULL [HispanicLatinoEthnicity]
				   ,NULL [RefUSCitizenshipStatusId]
				   ,NULL [RefVisaTypeId]
				   ,NULL [RefStateOfResidenceId]
				   ,NULL [RefProofOfResidencyTypeId]
				   ,NULL [RefHighestEducationLevelCompletedId]
				   ,NULL [RefPersonalInformationVerificationId]
				   ,NULL [BirthdateVerification]
				   ,NULL [RefTribalAffiliationId]
				   ,App.GetFiscalYearStartDate(@SchoolYear) [RecordStartDateTime]
				   ,App.GetFiscalYearEndDate(@SchoolYear) [RecordEndDateTime]
		FROM Staging.StateDetail
		WHERE SeaContact_FirstName IS NOT NULL
		AND SeaContact_FirstName <> ''
		AND SeaContact_LastOrSurname IS NOT NULL
		AND SeaContact_LastOrSurname <> ''
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonDetail', NULL, 'S01EC3410'
	END CATCH

	BEGIN TRY
		INSERT INTO [ODS].[PersonEmailAddress]
				   ([PersonId]
				   ,[EmailAddress]
				   ,[RefEmailTypeId])
		SELECT DISTINCT
					PersonId [PersonId]
				   ,SeaContact_ElectronicMailAddress [EmailAddress]
				   ,(SELECT RefEmailTypeId FROM ODS.RefEmailType WHERE Code = 'Work') [RefEmailTypeId]
		FROM Staging.StateDetail
		WHERE SeaContact_ElectronicMailAddress IS NOT NULL
		AND SeaContact_ElectronicMailAddress <> ''
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonEmailAddress', NULL, 'S01EC3420'
	END CATCH

	BEGIN TRY
		INSERT INTO [ODS].[PersonTelephone]
				   ([PersonId]
				   ,[TelephoneNumber]
				   ,[PrimaryTelephoneNumberIndicator]
				   ,[RefPersonTelephoneNumberTypeId])
		SELECT DISTINCT
					PersonId [PersonId]
				   ,SeaContact_PhoneNumber [TelephoneNumber]
				   ,1 [PrimaryTelephoneNumberIndicator]
				   ,(SELECT RefTelephoneNumberTypeId FROM ODS.RefTelephoneNumberType WHERE Code = 'Main') [RefPersonTelephoneNumberTypeId]
		FROM Staging.StateDetail
		WHERE SeaContact_PhoneNumber IS NOT NULL
		AND SeaContact_PhoneNumber <> ''
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonTelephone', NULL, 'S01EC3430'
	END CATCH

	BEGIN TRY
		INSERT INTO [ODS].[OrganizationPersonRole]
				   ([OrganizationId]
				   ,[PersonId]
				   ,[RoleId]
				   ,[EntryDate]
				   ,[ExitDate])
		SELECT DISTINCT
					orgd.OrganizationId [OrganizationId]
				   ,sd.PersonId [PersonId]
				   ,(SELECT RoleId FROM ODS.Role WHERE Name = 'Chief State School Officer') [RoleId]
				   ,App.GetFiscalYearStartDate(@SchoolYear) [EntryDate]
				   ,App.GetFiscalYearEndDate(@SchoolYear) [ExitDate]
		FROM Staging.StateDetail sd
			JOIN ODS.OrganizationDetail orgd 
				ON sd.SeaName = orgd.Name
			JOIN ODS.RefOrganizationType rot 
				ON orgd.RefOrganizationTypeId = rot.RefOrganizationTypeId
		WHERE Code = 'SEA'
		AND sd.PersonId IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S01EC3440'
	END CATCH

	BEGIN TRY
		INSERT INTO [ODS].[StaffEmployment]
				   ([OrganizationPersonRoleId]
				   ,[PositionTitle]
				   )
		SELECT DISTINCT
					OrganizationPersonRoleId			[OrganizationPersonRoleId]
				   ,SeaContact_PositionTitle			[PositionTitle]
		FROM Staging.StateDetail ssd
			JOIN ODS.OrganizationPersonRole oopr 
				ON ssd.OrganizationId = oopr.OrganizationId
		WHERE oopr.RoleId = (SELECT RoleId FROM ODS.Role WHERE Name = 'Chief State School Officer')
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.StaffEmployment', NULL, 'S01EC3445'
	END CATCH

	BEGIN TRY
		INSERT INTO [ODS].[PersonIdentifier]
				   ([PersonId]
				   ,[Identifier]
				   ,[RefPersonIdentificationSystemId]
				   ,[RefPersonalInformationVerificationId])
		SELECT DISTINCT
					PersonId [PersonId]
				   ,SeaContact_Identifier [Identifier]
				   ,(SELECT ris.RefPersonIdentificationSystemId 
					 FROM ODS.RefPersonIdentificationSystem ris JOIN ODS.RefPersonIdentifierType rit 
						ON ris.RefPersonIdentifierTypeId = rit.RefPersonIdentifierTypeId 
					 WHERE ris.Code = 'State' 
						AND rit.Code = '001074') [RefPersonIdentificationSystemId]
				   ,(SELECT RefPersonalInformationVerificationId FROM ODS.RefPersonalInformationVerification WHERE Code = '01011') [RefPersonalInformationVerificationId]
		FROM Staging.StateDetail
		WHERE PersonId IS NOT NULL
		AND SeaContact_Identifier IS NOT NULL
		AND SeaContact_Identifier <> ''
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonIdentifier', NULL, 'S01EC3450'
	END CATCH

	--------------------------------------
	--Insert School Indicator Status. For now, it's only the Graduation Rate --
	-- inclluded other Statuses - AcademicAchievementIndicatorStatus and OtherAcademicIndicatorStatus
	--------------------------------------
	BEGIN TRY
		INSERT INTO [ODS].[K12SchoolIndicatorStatus] (
			[K12SchoolId]
			,[RefIndicatorStatusTypeId]
			,[RefIndicatorStateDefinedStatusId]
			,[RefIndicatorStatusSubgroupTypeId]
			,[IndicatorStatusSubgroup]
			,[IndicatorStatus]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
		)
		SELECT    
			k12.K12SchoolId
			, ist.RefIndicatorStatusTypeId
			, ds.RefIndicatorStateDefinedStatusId
			, st.RefIndicatorStatusSubgroupTypeId
			, s.IndicatorStatusSubgroup
			, s.StatedDefinedIndicatorStatus
			, s.[RecordStartDateTime]
			, s.[RecordEndDateTime]
		FROM [Staging].[OrganizationSchoolIndicatorStatus] s
			JOIN Staging.Organization orgff 
				ON s.School_Identifier_State = orgff.School_Identifier_State
			JOIN ODS.K12School k12 
				ON k12.OrganizationId = orgff.SchoolOrganizationId
			JOIN [ODS].[RefIndicatorStatusType] ist 
				ON ist.Code = s.IndicatorStatusType
			JOIN [ODS].[RefIndicatorStateDefinedStatus] ds 
				ON ds.Code = s.IndicatorStatus
			JOIN [ODS].[RefIndicatorStatusSubgroupType] st	
				ON st.Code = s.IndicatorStatusSubgroupType
			LEFT JOIN [ODS].[K12SchoolIndicatorStatus] ks 
				ON  ks.[K12SchoolId] = k12.K12SchoolId
				AND ks.[RefIndicatorStatusTypeId] = ist.RefIndicatorStatusTypeId
				AND ks.[RefIndicatorStateDefinedStatusId] = ds.RefIndicatorStateDefinedStatusId
				AND ks.[RefIndicatorStatusSubgroupTypeId] = st.RefIndicatorStatusSubgroupTypeId
				AND ks.[IndicatorStatusSubgroup] = s.IndicatorStatusSubgroup
		WHERE ks.K12SchoolIndicatorStatusId IS NULL 
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12SchoolIndicatorStatus', NULL, 'S01EC3460'
	END CATCH

	-----------------------------------------------------------------------------------------
	--Insert School Custom Indicator Status - SchoolQualityOrStudentSuccessIndicatorStatus --
	-----------------------------------------------------------------------------------------
	BEGIN TRY
		INSERT INTO [ODS].[K12SchoolIndicatorStatus] (
			[K12SchoolId]
			,[RefIndicatorStatusTypeId]
			,[RefIndicatorStateDefinedStatusId]
			,[RefIndicatorStatusSubgroupTypeId]
			,[IndicatorStatusSubgroup]
			,[IndicatorStatus]
			,[RefIndicatorStatusCustomTypeId]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
		)
		SELECT    
			k12.K12SchoolId
			, ist.RefIndicatorStatusTypeId
			, ds.RefIndicatorStateDefinedStatusId
			, st.RefIndicatorStatusSubgroupTypeId
			, s.IndicatorStatusSubgroup
			, s.StatedDefinedIndicatorStatus
			, cust.RefIndicatorStatusCustomTypeId
			, s.[RecordStartDateTime]
			, s.[RecordEndDateTime]
		FROM [Staging].[OrganizationCustomSchoolIndicatorStatusType] s
			JOIN Staging.Organization orgff 
				ON s.School_Identifier_State = orgff.School_Identifier_State
			JOIN ODS.K12School k12 
				ON k12.OrganizationId = orgff.SchoolOrganizationId
			JOIN [ODS].[RefIndicatorStatusType] ist 
				ON ist.Code = s.IndicatorStatusType
			JOIN [ODS].[RefIndicatorStateDefinedStatus] ds 
				ON ds.Code = s.IndicatorStatus
			JOIN [ODS].[RefIndicatorStatusSubgroupType] st 
				ON st.Code = s.IndicatorStatusSubgroupType
			JOIN [ODS].[RefIndicatorStatusCustomType] cust 
				ON cust.Code = s.StatedDefinedCustomIndicatorStatusType
				--AND cust.RefJurisdictionId = k12.OrganizationId
			LEFT JOIN [ODS].[K12SchoolIndicatorStatus] ks 
				ON  ks.[K12SchoolId] = k12.K12SchoolId
				AND ks.[RefIndicatorStatusTypeId] = ist.RefIndicatorStatusTypeId
				AND ks.[RefIndicatorStateDefinedStatusId] = ds.RefIndicatorStateDefinedStatusId
				AND ks.[RefIndicatorStatusSubgroupTypeId] = st.RefIndicatorStatusSubgroupTypeId
				AND ks.[IndicatorStatusSubgroup] = s.IndicatorStatusSubgroup
				AND ks.[RefIndicatorStatusCustomTypeId] = cust.RefIndicatorStatusCustomTypeId 
					--AND cust.RefJurisdictionId=k12.OrganizationId
		WHERE ks.K12SchoolIndicatorStatusId IS NULL
	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12SchoolIndicatorStatus', NULL, 'S01EC3470'
	END CATCH
	/*
		[App].[Migrate_Data_ETL_IMPLEMENTATION_STEP01_Organization_EncapsulatedCode] 2018
	*/

	----------------------------------------------------------------
	-- K12SchoolStatus
	----------------------------------------------------------------
	BEGIN TRY
		----------------------------------------------------------------
		--Insert Progress Achiving English Proficency Indicator Status. 
		----------------------------------------------------------------
		INSERT INTO [ODS].[K12SchoolStatus] (
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
		)
		SELECT    
			k12.K12SchoolId
			,ssmagout.RefMagnetSpecialProgramId		[RefMagnetSpecialProgramId]
			,ist.[RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId]
			,CASE
				WHEN ist.Code = 'STTDEF' THEN s.School_ProgressAchievingEnglishLanguageProficiencyStateDefinedStatus
				ELSE NULL
			END
			,sst1.RefTitle1SchoolStatusId
			,s.ConsolidatedMepFundsStatus
			,cts.RefComprehensiveAndTargetedSupportId
			,cs.RefComprehensiveSupportId
			,ts.RefTargetedSupportId
			,sd.RefSchoolDangerousStatusId
			,vir.RefVirtualSchoolStatusId
			,nslp.RefNSLPStatusId
			,App.GetFiscalYearStartDate(@SchoolYear) [RecordStartDateTime]
			,App.GetFiscalYearEndDate(@SchoolYear) [RecordEndDateTime]		
		FROM [Staging].[Organization] s
		JOIN Staging.Organization orgff 
			ON s.School_Identifier_State = orgff.School_Identifier_State
		JOIN ODS.K12School k12 
			ON k12.OrganizationId = orgff.SchoolOrganizationId

		-- Progress Achieving EL Proficiency
		LEFT JOIN ODS.SourceSystemReferenceData sspae
			ON sspae.InputCode = s.School_ProgressAchievingEnglishLanguageProficiencyIndicatorStatus
			AND sspae.TableName = 'RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus'
			AND sspae.SchoolYear = @SchoolYear
		LEFT JOIN [ODS].[RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus] ist 
			ON ist.Code = sspae.OutputCode

		-- Title I Support
		LEFT JOIN ODS.SourceSystemReferenceData ssrd
			ON ssrd.InputCode = s.TitleIPartASchoolDesignation 
			AND ssrd.TableName = 'RefTitleISchoolStatus'
			AND ssrd.SchoolYear = @SchoolYear
		LEFT JOIN [ODS].[RefTitleISchoolStatus] sst1 
			ON sst1.Code = ssrd.OutputCode

		-- C and T support
		LEFT JOIN ODS.SourceSystemReferenceData sscts
			ON sscts.InputCode = s.School_ComprehensiveAndTargetedSupport
			AND sscts.TableName = 'RefComprehensiveAndTargetedSupport'
			AND sscts.SchoolYear = @SchoolYear
		LEFT JOIN [ODS].[RefComprehensiveAndTargetedSupport] cts 
			ON cts.Code = sscts.OutputCode
		
		-- Comprehensive Support
		LEFT JOIN ODS.SourceSystemReferenceData sscs
			ON sscs.InputCode = s.School_ComprehensiveSupport
			AND sscs.TableName = 'RefComprehensiveSupport'
			AND sscs.SchoolYear = @SchoolYear
		LEFT JOIN [ODS].[RefComprehensiveSupport] cs 
			ON cs.Code = sscs.OutputCode

		-- Targeted Support
		LEFT JOIN ODS.SourceSystemReferenceData ssts
			ON ssts.InputCode = s.School_TargetedSupport
			AND ssts.TableName = 'RefTargetedSupport'
			AND ssts.SchoolYear = @SchoolYear
		LEFT JOIN [ODS].[RefTargetedSupport] ts 
			ON ts.Code = ssts.OutputCode

		-- School Dangerous Status
		LEFT JOIN ODS.SourceSystemReferenceData sssds
			ON sssds.InputCode = s.School_SchoolDangerousStatus
			AND sssds.TableName = 'RefSchoolDangerousStatus'
			AND sssds.SchoolYear = @SchoolYear				
		LEFT JOIN [ODS].[RefSchoolDangerousStatus] sd 
			ON sd.Code = sssds.OutputCode

		-- MAGNET SCHOOL
		LEFT JOIN ODS.SourceSystemReferenceData ssmagnet
			ON ssmagnet.InputCode = s.School_MagnetOrSpecialProgramEmphasisSchool 
			AND ssmagnet.TableName = 'RefMagnetSpecialProgram'
			AND ssmagnet.SchoolYear = @SchoolYear
		LEFT JOIN [ODS].RefMagnetSpecialProgram ssmagout 
			ON ssmagout.Code = ssmagnet.OutputCode
		
		-- VIRTUAL SCHOOL
		LEFT JOIN ODS.SourceSystemReferenceData ssvirtual
			ON ssvirtual.InputCode = s.School_VirtualSchoolStatus
			AND ssvirtual.TableName = 'RefVirtualSchoolStatus'
			AND ssvirtual.SchoolYear = @SchoolYear
		LEFT JOIN ODS.RefVirtualSchoolStatus vir 
			ON vir.Code = ssvirtual.OutputCode
		
		-- NSLP Status
		LEFT JOIN ODS.SourceSystemReferenceData ssnslp
			ON ssnslp.InputCode = s.School_NationalSchoolLunchProgramStatus
			AND ssnslp.TableName = 'RefNSLPStatus'
			AND ssnslp.SchoolYear = @SchoolYear
		LEFT JOIN ODS.RefNSLPStatus nslp 
			ON nslp.Code = ssnslp.OutputCode
		
		LEFT JOIN [ODS].[K12SchoolStatus] ks 
			ON  ks.[K12SchoolId] = k12.K12SchoolId
		WHERE ks.K12SchoolStatusId IS NULL

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12SchoolStatus', NULL, 'S01EC3480'
	END CATCH

	BEGIN TRY

		UPDATE ks
		SET 
			[RefTitleISchoolStatusId] = sst1.RefTitle1SchoolStatusId
			,[RefComprehensiveAndTargetedSupportId] = cts.RefComprehensiveAndTargetedSupportId
			,[RefComprehensiveSupportId] = cs.RefComprehensiveSupportId
			,[RefTargetedSupportId] = ts.RefTargetedSupportId
			,[RefSchoolDangerousStatusId] = sd.RefSchoolDangerousStatusId
		FROM [Staging].[OrganizationSchoolComprehensiveAndTargetedSupport] s
		JOIN Staging.Organization orgff 
			ON s.School_Identifier_State = orgff.School_Identifier_State
		JOIN ODS.K12School k12 
			ON k12.OrganizationId = orgff.SchoolOrganizationId
		JOIN [ODS].[K12SchoolStatus] ks 
			ON  ks.[K12SchoolId] = k12.K12SchoolId

		LEFT JOIN ODS.SourceSystemReferenceData ssrd
			ON ssrd.InputCode = orgff.TitleIPartASchoolDesignation 
			AND ssrd.TableName = 'RefTitleISchoolStatus'
			AND ssrd.SchoolYear = @SchoolYear
		LEFT JOIN [ODS].[RefTitleISchoolStatus] sst1 
			ON sst1.Code = ssrd.OutputCode

		LEFT JOIN [ODS].[RefComprehensiveAndTargetedSupport] cts 
			ON cts.Code = s.School_ComprehensiveAndTargetedSupport
		LEFT JOIN [ODS].[RefComprehensiveSupport] cs 
			ON cs.Code = s.School_ComprehensiveSupport
		LEFT JOIN [ODS].[RefTargetedSupport] ts 
			ON ts.Code = s.School_TargetedSupport
		LEFT JOIN [ODS].[RefSchoolDangerousStatus] sd 
			ON sd.Code = orgff.School_SchoolDangerousStatus

	END TRY

	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12SchoolStatus', NULL, 'S01EC3490'
	END CATCH
	--Drop all temporary tables--

	BEGIN TRY
		DROP TABLE #PersonIdtoPersonIdentifier
	END TRY
	
	BEGIN CATCH
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '#PersonIdtoPersonIdentifier', NULL, 'S01EC3500'
	END CATCH

	SET nocount OFF;

	--rollback
END