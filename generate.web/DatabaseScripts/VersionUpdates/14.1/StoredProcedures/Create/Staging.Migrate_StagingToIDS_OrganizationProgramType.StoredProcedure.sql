create PROCEDURE [Staging].[Migrate_StagingToIDS_OrganizationProgramType]
	@SchoolYear SMALLINT = NULL
AS


--    /*************************************************************************************************************
--    Date Created:  11/21/2019
--		[Staging].[Migrate_StagingToIDS_OrganizationProgramType] 2018
--    Purpose:
--        The purpose of this ETL IS to manage the non-federal program offerings for K12 organizations
--        so that students can be enrolled AND tracked generically IN the programs.

--					NOTE: DO NOT CREATE FEDERAL PROGRAMS LIKE SPECIAL EDUCATION OR ENGLISH LEARNER HERE
--						  THEY ARE CREATED THROUGH STEP01 AUTOMATICALLY FOR EDFACTS REPORTING.
--    Assumptions:
--        This procedure assumes that the source tables are ready for consumption. 

--    Account executed under: LOGIN

--    Approximate run time:  ~ 10 seconds

--    Data Sources:  State source student data system 

--    Data Targets:  CEDS IDS

--    Return VALUES:
--    	 0	= Success
  
--    Example Usage: 
--      EXEC Staging.[Migrate_StagingToIDS_OrganizationProgramType] 2018;
    
--    Modification Log:
--      #	  Date		  Issue#   Description
--      --  ----------  -------  --------------------------------------------------------------------
--      01  11/21/2019           First Release		
--		02	12/20/2021			 Added School Year to join when setting Organization Id
--    *************************************************************************************************************/


BEGIN


	SET NOCOUNT ON;
	
	--IF @SchoolYear IS NULL BEGIN
	--	SELECT @SchoolYear = d.Year + 1
	--	FROM rds.DimDateDataMigrationTypes dd 
	--	JOIN rds.DimDates d 
	--		ON dd.DimDateId = d.DimDateId 
	--	JOIN rds.DimDataMigrationTypes b 
	--		ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
	--	WHERE dd.IsSelected = 1 
	--		AND DataMigrationTypeCode = 'dbo'
	--END 

    ---------------------------------------------------
    --- Declare Error Handling Variables           ----
    ---------------------------------------------------
	DECLARE @eStoredProc VARCHAR(100) = 'Migrate_StagingToIDS_OrganizationProgramType'
	DECLARE @LeaOrganizationIdentificationSystemId INT = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001072')
	DECLARE @LeaOrganizationIdentificationTypeId INT = [Staging].[GetOrganizationIdentifierTypeId]('001072')
	DECLARE @K12OrganizationIdentificationSystemId INT = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001073')
	DECLARE @K12OrganizationIdentificationTypeId INT = [Staging].[GetOrganizationIdentifierTypeId]('001073')
	DECLARE @IeuOrganizationIdentificationSystemId INT = [Staging].[GetOrganizationIdentifierSystemId]('IEU', '001156')
	DECLARE @IeuOrganizationIdentificationTypeId INT = [Staging].[GetOrganizationIdentifierTypeId]('001156')
	DECLARE @PscOrganizationIdentificationTypeId INT = [Staging].[GetOrganizationIdentifierTypeId]('000166')

	---------------------------------------------------------------
	---Associate the DataCollectionId with the temporary table ----
	---------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.OrganizationProgramType
		SET DataCollectionId = dc.DataCollectionId
		FROM Staging.OrganizationProgramType ps
		JOIN dbo.DataCollection dc
			ON ps.DataCollectionName = dc.DataCollectionName
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonID', 'S05EC110' 
	END CATCH


    ---------------------------------------------------
    --- Get the parent organizationId              ----
    ---------------------------------------------------

	BEGIN TRY
		UPDATE Staging.OrganizationProgramType
		SET OrganizationId = oi.OrganizationId
		FROM Staging.OrganizationProgramType sopt
		JOIN dbo.OrganizationIdentifier oi
			ON sopt.OrganizationIdentifier = oi.Identifier
			AND ISNULL(sopt.DataCollectionId, '') = ISNULL(oi.DataCollectionId, '')
		JOIN Staging.SourceSystemReferenceData ssrd
			ON sopt.OrganizationType = ssrd.InputCode
			AND ssrd.TableName = 'RefOrganizationType'
			AND ssrd.TableFilter = '001156'
			AND ssrd.SchoolYear = sopt.SchoolYear -- JW 12/20/2021

		JOIN dbo.OrganizationDetail od
			ON oi.OrganizationId = od.OrganizationId
		JOIN dbo.RefOrganizationType ot
				ON od.RefOrganizationTypeId = ot.RefOrganizationTypeId
				AND ssrd.OutputCode = ot.Code

	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationProgramType', 'OrganizationId', 'S02EC0100'
	END CATCH

	
    -------------------------------------------------------------------------------------
    --- Check to see IF the organization already has the program SET up              ----
    -------------------------------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.OrganizationProgramType
		SET ProgramOrganizationId = opt.OrganizationId
		FROM Staging.OrganizationProgramType sopt
		JOIN [Staging].[SourceSystemReferenceData] ssrd
			ON sopt.ProgramType = ssrd.InputCode
			AND ssrd.TableName = 'RefProgramType'
			AND ssrd.SchoolYear = sopt.SchoolYear
		JOIN dbo.RefProgramType pt 
			ON ssrd.OutputCode = pt.Code
		JOIN dbo.OrganizationProgramType opt
			ON pt.RefProgramTypeId = opt.RefProgramTypeId
		JOIN dbo.OrganizationRelationship ore
			ON opt.OrganizationId = ore.OrganizationId
			AND ore.Parent_OrganizationId = sopt.OrganizationId

	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationProgramType', 'ProgramOrganizationId', 'S02EC0110'
	END CATCH

    -----------------------------------------------------------
    --- Get the program type for the program               ----
    -----------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.OrganizationProgramType
		SET ProgramTypeId = pt.RefProgramTypeId
		FROM Staging.OrganizationProgramType sopt
		JOIN [Staging].[SourceSystemReferenceData] ssrd
			ON sopt.ProgramType = ssrd.InputCode
			AND ssrd.TableName = 'RefProgramType'
			AND ssrd.SchoolYear = sopt.SchoolYear
		JOIN dbo.RefProgramType pt 
			ON ssrd.OutputCode = pt.Code

	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationProgramType', 'ProgramOrganizationId', 'S02EC0110'
	END CATCH


	---------------------------------------------------------
    --- Create the new Organization records              ----
    ---------------------------------------------------------

	DECLARE @NewProgramOrganizations TABLE (
		  ParentOrganizationId INT
		, ProgramTypeId INT
		, ProgramOrganizationId INT
		, RecordStartDateTime DATETIME
	)
	
	BEGIN TRY

		-- Create new records
		MERGE dbo.Organization AS TARGET
		USING Staging.OrganizationProgramType AS SOURCE
			ON 1 = 0 
		WHEN NOT MATCHED AND SOURCE.ProgramOrganizationId IS NULL THEN INSERT(DataCollectionId) VALUES (SOURCE.DataCollectionId)
		OUTPUT
			  SOURCE.OrganizationId
			, SOURCE.ProgramTypeId
			, INSERTED.OrganizationId
			, SOURCE.RecordStartDateTime
		INTO @NewProgramOrganizations;

	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Organization', '', 'S02EC0120'
	END CATCH

	------------------------------------------------------------------------
	--- UPDATE staging table wtih the new ProgramOrganizationId        ----
	------------------------------------------------------------------------

	BEGIN TRY

		UPDATE opt
		SET opt.ProgramOrganizationId = nopt.ProgramOrganizationId 
		FROM Staging.OrganizationProgramType opt
			JOIN @NewProgramOrganizations nopt
				ON opt.OrganizationId = nopt.ParentOrganizationId
				AND opt.ProgramTypeId = nopt.ProgramTypeId
				--AND opt.RecordStartDateTime = nopt.RecordStartDateTime
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationProgramType', 'ProgramOrganizationId', 'S02EC0150'
	END CATCH

	----------------------------------------------------------------
    --- Create the new Organization Detail records              ----
    ----------------------------------------------------------------
	
	DECLARE @ProgramOrganizationTypeId INT
	SELECT @ProgramOrganizationTypeId = RefOrganizationTypeId
	FROM dbo.RefOrganizationType
	WHERE Code = 'Program'

	BEGIN TRY

		INSERT INTO dbo.OrganizationDetail (
			  OrganizationId
			, Name
			, RefOrganizationTypeId
			, RecordStartDateTime
			, RecordEndDateTime
			, DataCollectionId)
		SELECT 
			  npo.ProgramOrganizationId	
			, ISNULL(opt.OrganizationName, opt.ProgramType)
			, @ProgramOrganizationTypeId
			, opt.RecordStartDateTime
			, opt.RecordEndDateTime
			, opt.DataCollectionId
		FROM Staging.OrganizationProgramType opt
		JOIN @NewProgramOrganizations npo 
			ON opt.OrganizationId = npo.ParentOrganizationId
			AND opt.ProgramTypeId = npo.ProgramTypeId
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', '', 'S02EC0130'
	END CATCH


	----------------------------------------------------------------
    --- Merge IN the new OrganizationProgramType records        ----
    ----------------------------------------------------------------
	
	DECLARE @NewOrganizationProgramTypes TABLE (
		  ParentOrganizationId INT
		, ProgramTypeId INT
		, ProgramOrganizationId INT
		, RecordStartDateTime DATETIME
		, DataCollectionId INT
	)

	BEGIN TRY

		MERGE dbo.OrganizationProgramType AS TARGET
		USING Staging.OrganizationProgramType AS SOURCE 
			ON 
			SOURCE.ProgramOrganizationId = TARGET.OrganizationId
			AND SOURCE.RecordStartDateTime = TARGET.RecordStartDateTime
		WHEN MATCHED THEN 
			UPDATE
			SET RefProgramTypeId = SOURCE.ProgramTypeId
			  , RecordStartDateTime = SOURCE.RecordStartDateTime
			  , RecordEndDateTime = SOURCE.RecordEndDateTime
		WHEN NOT MATCHED AND SOURCE.ProgramOrganizationId IS NOT NULL THEN INSERT 
			(
			  OrganizationId
			, RefProgramTypeId
			, RecordStartDateTime
			, RecordEndDateTime
			, DataCollectionId
			)
			VALUES
			(
			  SOURCE.ProgramOrganizationId
			, SOURCE.ProgramTypeId
			, SOURCE.RecordStartDateTime
			, SOURCE.RecordEndDateTime
			, SOURCE.DataCollectionId
			)
		OUTPUT 
			  SOURCE.OrganizationId
			, SOURCE.ProgramTypeId
			, INSERTED.OrganizationProgramTypeId
			, SOURCE.RecordStartDateTime
			, SOURCE.DataCollectionId
		INTO @NewOrganizationProgramTypes;

	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationProgramType', '', 'S02EC0140'
	END CATCH


	----------------------------------------------------------------------------
    --- UPDATE staging table wtih the new OrganizationProgramTypeIds        ----
    ----------------------------------------------------------------------------

	BEGIN TRY

		UPDATE opt
		SET opt.OrganizationProgramTypeId = nopt.ProgramOrganizationId
		FROM Staging.OrganizationProgramType opt
		JOIN @NewOrganizationProgramTypes nopt
			ON opt.OrganizationId = nopt.ParentOrganizationId
			AND opt.ProgramTypeId = nopt.ProgramTypeId
			--AND opt.RecordStartDateTime = nopt.RecordStartDateTime
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationProgramType', 'OrganizationProgramTypeId', 'S02EC0150'
	END CATCH

	-------------------------------------------------------------------------------------------
	--- Create relationship between the program and the organization offering the program.  ---
	-------------------------------------------------------------------------------------------

	BEGIN TRY
		INSERT INTO [dbo].[OrganizationRelationship] (
			[Parent_OrganizationId]
			, [OrganizationId]
			, [RefOrganizationRelationshipId]
			, [DataCollectionId]
		)
		SELECT DISTINCT
			opt.OrganizationId			[Parent_OrganizationId]
			, opt.ProgramOrganizationId	[OrganizationId]
			, NULL						[RefOrganizationRelationshipId]
			, opt.DataCollectionId		[DataCollectionId]
		FROM Staging.OrganizationProgramType opt
		LEFT JOIN dbo.OrganizationRelationship ore
			ON opt.ProgramOrganizationId = ore.OrganizationId
			AND opt.OrganizationId = ore.Parent_OrganizationId
		WHERE ore.Parent_OrganizationId IS NULL
			AND opt.OrganizationId IS NOT NULL
			AND opt.ProgramOrganizationId IS NOT NULL

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationProgramType', 'OrganizationProgramTypeId', 'S02EC0160'
	END CATCH

END