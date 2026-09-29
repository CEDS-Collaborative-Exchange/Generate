CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_ProgramParticipationTitleIII]
	@SchoolYear SMALLINT = NULL
AS

	/*************************************************************************************************************
	Date Created:  5/9/2019

	Purpose:
		The purpose of this ETL is to load Title III about students for EDFacts reports that apply to the full year.

	Assumptions:
        
	Account executed under: LOGIN

	Approximate run time:  ~ 5 seconds

	Data Sources: 

	Data Targets:  Generate Database:   Generate

	Return Values:
    		0	= Success
  
	Example Usage: 
		EXEC Staging.[Migrate_StagingToIDS_ProgramParticipationTitleIII];
    
	Modification Log:
		#	  Date		  Issue#   Description
		--  ----------  -------  --------------------------------------------------------------------
		01		  	 
	*************************************************************************************************************/

BEGIN

	set nocount on;
		
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
	--- Declare Error Handling Variables
	---------------------------------------------------
	DECLARE @eStoredProc			varchar(100) = 'Migrate_StagingToIDS_ProgramParticipationTitleIII'
	DECLARE @TitleIiiImmigrantStatus INT
	,@RecordStartDateTime DATETIME
	,@RecordEndDateTime DATETIME

	---------------------------------------------------
	--- Declare Multiple Use Variables
	---------------------------------------------------
	SELECT @TitleIiiImmigrantStatus = RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'TitleIIIImmigrant'
	SET @RecordStartDateTime = Staging.GetFiscalYearStartDate(@SchoolYear)
	SET @RecordEndDateTime = Staging.GetFiscalYearEndDate(@SchoolYear)

	DECLARE @RefParticipationTypeId INT
	SELECT @RefParticipationTypeId = RefParticipationTypeId FROM [dbo].[RefParticipationType] WHERE [Code] = 'TitleIIILEPParticipation' -- Description = 'Title III Limited English Proficient Participation'

	DECLARE @immigrantTitleIIIPersonStatusTypeId as int
	SELECT @immigrantTitleIIIPersonStatusTypeId = RefPersonStatusTypeId from dbo.RefPersonStatusType where code = 'TitleIIIImmigrant'

	DECLARE @TitleIIIImmigrantParticipation as int
	SELECT @TitleIIIImmigrantParticipation = RefParticipationTypeId from dbo.RefParticipationType where code = 'TitleIIIImmigrantParticipation'


	--------------------------------------------------------------
	--- Optimize indexes on Staging.ProgramParticipationTitleIII 
	--------------------------------------------------------------
	ALTER INDEX ALL ON Staging.ProgramParticipationTitleIII
	REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

	-------------------------------------------------------
	---Associate the PersonId with the staging table 
	-------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleIII
		SET PersonID = pid.PersonId
		FROM Staging.ProgramParticipationTitleIII mcc
		JOIN dbo.PersonIdentifier pid 
			ON mcc.Student_Identifier_State = pid.Identifier
		WHERE pid.RefPersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001075')
			AND pid.RefPersonalInformationVerificationId = Staging.GetRefPersonalInformationVerificationId('01011')
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'PersonID', 'S12EC100'
	END CATCH

	--------------------------------------------------------------------
	---Associate the LEA OrganizationId with the staging table 
	--------------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleIII
		SET OrganizationID_LEA = orgid.OrganizationId
		FROM Staging.ProgramParticipationTitleIII mcc
		JOIN dbo.OrganizationIdentifier orgid 
			ON mcc.LEA_Identifier_State = orgid.Identifier
		WHERE orgid.RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('001072')
			AND orgid.RefOrganizationIdentificationSystemId = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001072')
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'OrganizationID_School', 'S12EC110'
	END CATCH

	--------------------------------------------------------------------
	---Associate the School OrganizationId with the staging table
	--------------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleIII
		SET OrganizationID_School = orgid.OrganizationId
		FROM Staging.ProgramParticipationTitleIII mcc
		JOIN dbo.OrganizationIdentifier orgid 
			ON mcc.School_Identifier_State = orgid.Identifier
		WHERE orgid.RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('001073')
			AND orgid.RefOrganizationIdentificationSystemId = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001073')
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'OrganizationID_School', 'S12EC110'
	END CATCH


	-----------------------------------------------------------------------------
	---Associate the LEA TitleIII Program OrganizationId with the staging table ----
	-----------------------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleIII
		SET OrganizationID_TitleIIIProgram_LEA = orgd.OrganizationId
		FROM Staging.ProgramParticipationTitleIII tp
		JOIN dbo.OrganizationRelationship orgr 
			ON tp.OrganizationID_LEA = orgr.Parent_OrganizationId
		JOIN dbo.OrganizationDetail orgd 
			ON orgr.OrganizationId = orgd.OrganizationId
		JOIN dbo.OrganizationProgramType orgpt 
			ON orgd.OrganizationId = orgpt.OrganizationId
		WHERE orgd.RefOrganizationTypeId = Staging.GetOrganizationTypeId('Program', '001156') 
			AND orgpt.RefProgramTypeId = Staging.GetProgramTypeId('77000') -- 'Tilte III Program
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'OrganizationID_TitleIIIProgram', 'S12EC120'
	END CATCH

	-----------------------------------------------------------------------------
	---Associate the School TitleIII Program OrganizationId with the staging table ----
	-----------------------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleIII
		SET OrganizationID_TitleIIIProgram_School = orgd.OrganizationId
		FROM Staging.ProgramParticipationTitleIII tp
		JOIN dbo.OrganizationRelationship orgr ON tp.OrganizationID_School = orgr.Parent_OrganizationId
		JOIN dbo.OrganizationDetail orgd ON orgr.OrganizationId = orgd.OrganizationId
		JOIN dbo.OrganizationProgramType orgpt ON orgd.OrganizationId = orgpt.OrganizationId
		WHERE orgd.RefOrganizationTypeId = Staging.GetOrganizationTypeId('Program', '001156') 
			AND orgpt.RefProgramTypeId = Staging.GetProgramTypeId('77000') -- 'Tilte III Program
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'OrganizationID_TitleIIIProgram', 'S12EC120'
	END CATCH

	--------------------------------------------------
	----Create LEA TitleIII Indicator for the Student 
	--------------------------------------------------

	--Check for TitleIII Records that already exist--
	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleIII
		SET OrganizationPersonRoleID_TitleIIIProgram_LEA = opr.OrganizationPersonRoleId
		FROM Staging.ProgramParticipationTitleIII tp
		JOIN dbo.OrganizationPersonRole opr 
			ON tp.PersonID = opr.PersonId
		WHERE tp.OrganizationID_TitleIIIProgram_LEA = opr.OrganizationId
			AND opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = [Staging].[GetFiscalYearStartDate](@SchoolYear)
			AND opr.ExitDate = [Staging].[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'OrganizationPersonRoleID_TitleIIIProgram', 'S12EC130'
	END CATCH

	--Create an OrganizationPersonRole (Enrollment) into the TitleIII Program for the last day of the year --
	BEGIN TRY
		INSERT INTO [dbo].[OrganizationPersonRole] (
			[OrganizationId]
			,[PersonId]
			,[RoleId]
			,[EntryDate]
			,[ExitDate]
		)
		SELECT DISTINCT
			tp.OrganizationID_TitleIIIProgram_LEA	[OrganizationId]
			,tp.PersonID							[PersonId]
			,Staging.GetRoleId('K12 Student')		[RoleId]
			,tp.ProgramParticipationBeginDate		[EntryDate]
			,tp.ProgramParticipationEndDate			[ExitDate]
		FROM Staging.ProgramParticipationTitleIII tp
		LEFT JOIN [dbo].[OrganizationPersonRole] opr 
			ON opr.OrganizationId = tp.OrganizationID_TitleIIIProgram_LEA
			AND opr.PersonId = tp.PersonID 
			AND opr.RoleId = Staging.GetRoleId('K12 Student') 
			AND opr.EntryDate = [Staging].[GetFiscalYearStartDate](@SchoolYear) 
		WHERE opr.OrganizationPersonRoleId IS NULL
			AND tp.OrganizationPersonRoleID_TitleIIIProgram_LEA IS NULL
			AND tp.OrganizationID_TitleIIIProgram_LEA IS NOT NULL
			AND tp.PersonID IS NOT NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S12EC140'
	END CATCH

	--Update the staging table with the TitleIII Program OrganizationPersonRoleId
	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleIII
		SET OrganizationPersonRoleID_TitleIIIProgram_LEA = opr.OrganizationPersonRoleId
		FROM Staging.ProgramParticipationTitleIII tp
		JOIN dbo.OrganizationPersonRole opr 
			ON tp.PersonID = opr.PersonId
			AND tp.OrganizationID_TitleIIIProgram_LEA = opr.OrganizationId
		WHERE opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = tp.ProgramParticipationBeginDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate = tp.ProgramParticipationEndDate)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'OrganizationPersonRoleID_TitleIIIProgram', 'S12EC150'
	END CATCH

	--------------------------------------------------
	----Create School TitleIII Indicator for the Student 
	--------------------------------------------------

	--Check for TitleIII Records that already exist--
	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleIII
		SET OrganizationPersonRoleID_TitleIIIProgram_School = opr.OrganizationPersonRoleId
		FROM Staging.ProgramParticipationTitleIII tp
		JOIN dbo.OrganizationPersonRole opr 
			ON tp.PersonID = opr.PersonId
		WHERE tp.OrganizationID_TitleIIIProgram_School = opr.OrganizationId
			AND opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = [Staging].[GetFiscalYearStartDate](@SchoolYear)
			AND opr.ExitDate = [Staging].[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'OrganizationPersonRoleID_TitleIIIProgram', 'S12EC130'
	END CATCH

	--Create an OrganizationPersonRole (Enrollment) into the TitleIII Program for the last day of the year --
	BEGIN TRY
		INSERT INTO [dbo].[OrganizationPersonRole] (
			[OrganizationId]
			,[PersonId]
			,[RoleId]
			,[EntryDate]
			,[ExitDate]
		)
		SELECT DISTINCT
			tp.OrganizationID_TitleIIIProgram_School	[OrganizationId]
			,tp.PersonID								[PersonId]
			,Staging.GetRoleId('K12 Student')			[RoleId]
			,tp.ProgramParticipationBeginDate			[EntryDate]
			,tp.ProgramParticipationEndDate				[ExitDate]
		FROM Staging.ProgramParticipationTitleIII tp
		LEFT JOIN [dbo].[OrganizationPersonRole] opr 
			ON opr.OrganizationId = tp.OrganizationID_TitleIIIProgram_School
			AND opr.PersonId = tp.PersonID 
			AND opr.RoleId = Staging.GetRoleId('K12 Student') 
			AND opr.EntryDate = [Staging].[GetFiscalYearStartDate](@SchoolYear) 
		WHERE opr.OrganizationPersonRoleId IS NULL
			AND tp.OrganizationPersonRoleID_TitleIIIProgram_School IS NULL
			AND tp.OrganizationID_TitleIIIProgram_School IS NOT NULL
			AND tp.PersonID IS NOT NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S12EC140'
	END CATCH

	--Update the staging table with the TitleIII Program OrganizationPersonRoleId
	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleIII
		SET OrganizationPersonRoleID_TitleIIIProgram_School = opr.OrganizationPersonRoleId
		FROM Staging.ProgramParticipationTitleIII tp
		JOIN dbo.OrganizationPersonRole opr 
			ON tp.PersonID = opr.PersonId
			AND tp.OrganizationID_TitleIIIProgram_School = opr.OrganizationId
		WHERE opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = tp.ProgramParticipationBeginDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate = tp.ProgramParticipationEndDate)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'OrganizationPersonRoleID_TitleIIIProgram', 'S12EC150'
	END CATCH

	-------------------------------------------------------------
	----Create LEA PersonProgramParticipation for the Student 
	-------------------------------------------------------------

	--Check to see if a PersonProgramParticipation already exists for the TitleIII Program--
	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleIII
		SET PersonProgramParticipationId_LEA = ppp.PersonProgramParticipationId
		FROM Staging.ProgramParticipationTitleIII tp
		JOIN dbo.PersonProgramParticipation ppp 
			ON tp.OrganizationPersonRoleID_TitleIIIProgram_LEA = ppp.OrganizationPersonRoleId
		JOIN dbo.ProgramParticipationTitleIIILep pp 
			ON ppp.PersonProgramParticipationId = pp.PersonProgramParticipationId
		WHERE ppp.RecordStartDateTime = [Staging].[GetFiscalYearStartDate](@SchoolYear)
			AND ppp.RecordEndDateTime = [Staging].[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'PersonProgramParticipationId', 'S12EC160'
	END CATCH

	--Create a PersonProgramParticipation for each OrganizationPersonRole
	DECLARE @NewLEAPersonProgramParticipationTitleIII TABLE (
		PersonProgramParticipationId INT
		, SourceId INT
	);

	BEGIN TRY
		MERGE [dbo].[PersonProgramParticipation] AS TARGET
		USING Staging.ProgramParticipationTitleIII AS SOURCE
			ON SOURCE.PersonProgramParticipationId_LEA = TARGET.PersonProgramParticipationId
		WHEN NOT MATCHED AND SOURCE.OrganizationPersonRoleID_TitleIIIProgram_LEA IS NOT NULL THEN 
			INSERT (
			[OrganizationPersonRoleId]
			,[RefParticipationTypeId]
			,[RefProgramExitReasonId]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
			)
		VALUES (
			OrganizationPersonRoleID_TitleIIIProgram_LEA
			,CASE
				WHEN [EnglishLearnerParticipation] = 1 THEN @RefParticipationTypeId 
				ELSE NULL
			END 
			,NULL 
			,ProgramParticipationBeginDate	
			,ProgramParticipationEndDate	
			)	
		OUTPUT
			INSERTED.PersonProgramParticipationId 
			, SOURCE.ID
		INTO @NewLEAPersonProgramParticipationTitleIII;
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S12EC170'
	END CATCH

	--Update the staging table with the new PersonProgramParticipationId
	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleIII 
		SET PersonProgramParticipationId_LEA = nppp.PersonProgramParticipationId
		FROM Staging.ProgramParticipationTitleIII ppi
		JOIN @NewLEAPersonProgramParticipationTitleIII nppp
			ON ppi.ID = nppp.SourceId
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'PersonProgramParticipationId', 'S12EC180'
	END CATCH

	-------------------------------------------------------------
	----Create School PersonProgramParticipation for the Student 
	-------------------------------------------------------------

	--Check to see if a PersonProgramParticipation already exists for the TitleIII Program--
	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleIII
		SET PersonProgramParticipationId_School = ppp.PersonProgramParticipationId
		FROM Staging.ProgramParticipationTitleIII tp
		JOIN dbo.PersonProgramParticipation ppp 
			ON tp.OrganizationPersonRoleID_TitleIIIProgram_School = ppp.OrganizationPersonRoleId
		JOIN dbo.ProgramParticipationTitleIIILep pp 
			ON ppp.PersonProgramParticipationId = pp.PersonProgramParticipationId
		WHERE ppp.RecordStartDateTime = [Staging].[GetFiscalYearStartDate](@SchoolYear)
			AND ppp.RecordEndDateTime = [Staging].[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'PersonProgramParticipationId', 'S12EC160'
	END CATCH

	--Create a PersonProgramParticipation for each OrganizationPersonRole
	DECLARE @NewSchoolPersonProgramParticipationTitleIII TABLE (
		PersonProgramParticipationId INT
		, SourceId INT
	);

	BEGIN TRY
		MERGE [dbo].[PersonProgramParticipation] AS TARGET
		USING Staging.ProgramParticipationTitleIII AS SOURCE
			ON SOURCE.PersonProgramParticipationId_School = TARGET.PersonProgramParticipationId
		WHEN NOT MATCHED AND SOURCE.OrganizationPersonRoleID_TitleIIIProgram_School IS NOT NULL THEN 
			INSERT (
			[OrganizationPersonRoleId]
			,[RefParticipationTypeId]
			,[RefProgramExitReasonId]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
			)
		VALUES (
			OrganizationPersonRoleID_TitleIIIProgram_School
			,CASE
				WHEN [EnglishLearnerParticipation] = 1 THEN @RefParticipationTypeId 
				ELSE NULL
			END 
			,NULL 
			,ProgramParticipationBeginDate	
			,ProgramParticipationEndDate	
			)	
		OUTPUT
			INSERTED.PersonProgramParticipationId 
			, SOURCE.ID
		INTO @NewSchoolPersonProgramParticipationTitleIII;
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S12EC170'
	END CATCH

	--Update the staging table with the new PersonProgramParticipationId
	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleIII 
		SET PersonProgramParticipationId_School = nppp.PersonProgramParticipationId
		FROM Staging.ProgramParticipationTitleIII ppi
		JOIN @NewSchoolPersonProgramParticipationTitleIII nppp
			ON ppi.ID = nppp.SourceId
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'PersonProgramParticipationId', 'S12EC180'
	END CATCH

	-------------------------------------------------------------
	----Create LEA ProgramParticipationTitleIII for the Student 
	-------------------------------------------------------------

	-- create new dbo.ProgramParticipationTitleIII records
	BEGIN TRY
		INSERT INTO dbo.ProgramParticipationTitleIIILep  (
			PersonProgramParticipationId
			,RefTitleIIIAccountabilityId
			,RefTitleIIILanguageInstructionProgramTypeId
			,RecordStartDateTime
			,RecordEndDateTime
		)
		SELECT 
			ppi.PersonProgramParticipationId_LEA
			,CASE
				WHEN acct.RefTitleIIIAccountabilityId IS NOT NULL THEN acct.RefTitleIIIAccountabilityId
				ELSE NULL
			END
			,CASE
				WHEN lipt.RefTitleIIILanguageInstructionProgramTypeId IS NOT NULL THEN lipt.RefTitleIIILanguageInstructionProgramTypeId
				WHEN ppi.LanguageInstructionProgramServiceType IS NOT NULL THEN  (SELECT RefTitleIIIAccountabilityId FROM [dbo].RefTitleIIIAccountability WHERE Code = 'NOPROGRESS')
				ELSE NULL
			END RefTitleIIILanguageInstructionProgramTypeId
			,ProgramParticipationBeginDate	
			,ProgramParticipationEndDate		
		FROM Staging.ProgramParticipationTitleIII ppi
		JOIN @NewLEAPersonProgramParticipationTitleIII nppp 
			ON ppi.ID = nppp.SourceId
		LEFT JOIN Staging.SourceSystemReferenceData ssrd 
			ON ssrd.InputCode = ppi.Progress_TitleIII
			AND ssrd.TableName = 'RefTitleIIIAccountability'
		LEFT JOIN [dbo].RefTitleIIIAccountability acct 
			ON acct.Code = ssrd.OutputCode
		LEFT JOIN Staging.SourceSystemReferenceData lisd 
			ON lisd.InputCode = ppi.LanguageInstructionProgramServiceType
			AND lisd.TableName = 'RefTitleIIILanguageInstructionProgramType'
		LEFT JOIN [dbo].RefTitleIIILanguageInstructionProgramType lipt 
			ON lipt.Description = lisd.OutputCode
		LEFT JOIN dbo.ProgramParticipationTitleIIILep lep 
			ON lep.PersonProgramParticipationId = ppi.PersonProgramParticipationId_LEA
			AND lep.RefTitleIIIAccountabilityId = acct.RefTitleIIIAccountabilityId
			AND lep.RecordStartDateTime = [Staging].[GetFiscalYearStartDate](@SchoolYear)
		WHERE lep.ProgramParticipationTitleIiiLepId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationTitleIII', NULL, 'S12EC190'
	END CATCH

	-------------------------------------------------------------
	----Create School ProgramParticipationTitleIII for the Student 
	-------------------------------------------------------------

	-- create new dbo.ProgramParticipationTitleIII records
	BEGIN TRY
		INSERT INTO dbo.ProgramParticipationTitleIIILep  (
			PersonProgramParticipationId
			,RefTitleIIIAccountabilityId
			,RefTitleIIILanguageInstructionProgramTypeId
			,RecordStartDateTime
			,RecordEndDateTime
		)
		SELECT 
			ppi.PersonProgramParticipationId_School
			,CASE
				WHEN acct.RefTitleIIIAccountabilityId IS NOT NULL THEN acct.RefTitleIIIAccountabilityId
				ELSE NULL
			END
			,CASE
				WHEN lipt.RefTitleIIILanguageInstructionProgramTypeId IS NOT NULL THEN lipt.RefTitleIIILanguageInstructionProgramTypeId
				WHEN ppi.LanguageInstructionProgramServiceType IS NOT NULL THEN  (SELECT RefTitleIIIAccountabilityId FROM [dbo].RefTitleIIIAccountability WHERE Code = 'NOPROGRESS')
				ELSE NULL
			END RefTitleIIILanguageInstructionProgramTypeId
			,ProgramParticipationBeginDate	
			,ProgramParticipationEndDate		
		FROM Staging.ProgramParticipationTitleIII ppi
		JOIN @NewSchoolPersonProgramParticipationTitleIII nppp 
			ON ppi.ID = nppp.SourceId
		LEFT JOIN Staging.SourceSystemReferenceData ssrd 
			ON ssrd.InputCode = ppi.Progress_TitleIII
			AND ssrd.TableName = 'RefTitleIIIAccountability'
		LEFT JOIN [dbo].RefTitleIIIAccountability acct 
			ON acct.Code = ssrd.OutputCode
		LEFT JOIN Staging.SourceSystemReferenceData lisd 
			ON lisd.InputCode = ppi.LanguageInstructionProgramServiceType
			AND lisd.TableName = 'RefTitleIIILanguageInstructionProgramType'
		LEFT JOIN [dbo].RefTitleIIILanguageInstructionProgramType lipt 
			ON lipt.Description = lisd.OutputCode
		LEFT JOIN dbo.ProgramParticipationTitleIIILep lep 
			ON lep.PersonProgramParticipationId = ppi.PersonProgramParticipationId_School
			AND lep.RefTitleIIIAccountabilityId = acct.RefTitleIIIAccountabilityId
			AND lep.RecordStartDateTime = [Staging].[GetFiscalYearStartDate](@SchoolYear)
		WHERE lep.ProgramParticipationTitleIiiLepId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationTitleIII', NULL, 'S12EC190'
	END CATCH

	-------------------------------------------------------------
	----Create LEA K12TitleIIILanguageInstruction for the Student 
	-------------------------------------------------------------

	-- create new dbo.K12TitleIIILanguageInstruction records
	BEGIN TRY
		INSERT INTO [dbo].[K12TitleIIILanguageInstruction] (
			[OrganizationId]
			,[RefTitleIIILanguageInstructionProgramTypeId]
		)
		SELECT DISTINCT
			ppi.OrganizationID_LEA
			,CASE
				WHEN lipt.RefTitleIIILanguageInstructionProgramTypeId IS NOT NULL THEN lipt.RefTitleIIILanguageInstructionProgramTypeId
				WHEN ppi.LanguageInstructionProgramServiceType IS NOT NULL THEN  (SELECT RefTitleIIIAccountabilityId FROM [dbo].RefTitleIIIAccountability WHERE Code = 'NOPROGRESS')
				ELSE NULL
			END RefTitleIIILanguageInstructionProgramTypeId	
		FROM Staging.ProgramParticipationTitleIII ppi
		LEFT JOIN Staging.SourceSystemReferenceData ssrd 
			ON ssrd.InputCode = ppi.Progress_TitleIII
			AND ssrd.TableName = 'RefTitleIIIAccountability'
		LEFT JOIN [dbo].RefTitleIIIAccountability acct 
			ON acct.Code = ssrd.OutputCode
		LEFT JOIN [Staging].SourceSystemReferenceData lisd 
			ON lisd.InputCode = ppi.LanguageInstructionProgramServiceType
			AND lisd.TableName = 'RefTitleIIILanguageInstructionProgramType'
		LEFT JOIN [dbo].RefTitleIIILanguageInstructionProgramType lipt 
			ON lipt.Description = lisd.OutputCode
		LEFT JOIN dbo.[K12TitleIIILanguageInstruction] li 
			ON li.OrganizationId = ppi.OrganizationID_LEA
		WHERE li.OrganizationId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationTitleIII', NULL, 'S12EC190'
	END CATCH

	-------------------------------------------------------------
	----Create School K12TitleIIILanguageInstruction for the Student 
	-------------------------------------------------------------

	-- create new dbo.K12TitleIIILanguageInstruction records
	BEGIN TRY
		INSERT INTO [dbo].[K12TitleIIILanguageInstruction] (
			[OrganizationId]
			,[RefTitleIIILanguageInstructionProgramTypeId]
		)
		SELECT DISTINCT
			ppi.OrganizationID_School
			,CASE
				WHEN lipt.RefTitleIIILanguageInstructionProgramTypeId IS NOT NULL THEN lipt.RefTitleIIILanguageInstructionProgramTypeId
				WHEN ppi.LanguageInstructionProgramServiceType IS NOT NULL THEN  (SELECT RefTitleIIIAccountabilityId FROM [dbo].RefTitleIIIAccountability WHERE Code = 'NOPROGRESS')
				ELSE NULL
			END RefTitleIIILanguageInstructionProgramTypeId	
		FROM Staging.ProgramParticipationTitleIII ppi
		LEFT JOIN Staging.SourceSystemReferenceData ssrd 
			ON ssrd.InputCode = ppi.Progress_TitleIII
			AND ssrd.TableName = 'RefTitleIIIAccountability'
		LEFT JOIN [dbo].RefTitleIIIAccountability acct 
			ON acct.Code = ssrd.OutputCode
		LEFT JOIN [Staging].SourceSystemReferenceData lisd 
			ON lisd.InputCode = ppi.LanguageInstructionProgramServiceType
			AND lisd.TableName = 'RefTitleIIILanguageInstructionProgramType'
		LEFT JOIN [dbo].RefTitleIIILanguageInstructionProgramType lipt 
			ON lipt.Description = lisd.OutputCode
		LEFT JOIN dbo.[K12TitleIIILanguageInstruction] li 
			ON li.OrganizationId = ppi.OrganizationID_School
		WHERE li.OrganizationId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationTitleIII', NULL, 'S12EC190'
	END CATCH


	-------------------------------------------------------------------------------
	---Associate the TitleIII Immigration Person Status with the staging table 
	-------------------------------------------------------------------------------
	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleIII
			SET PersonStatusId_Immigration = ps.PersonStatusId
		FROM Staging.ProgramParticipationTitleIII tp
		JOIN dbo.PersonStatus ps 
			ON tp.PersonID = ps.PersonId
		JOIN dbo.RefPersonStatusType rps 
			ON rps.RefPersonStatusTypeId = ps.RefPersonStatusTypeId
		WHERE rps.Code = 'TitleIIIImmigrant'
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'ImmigrationPersonStatusId', 'S12EC200'
	END CATCH

	----Create PersonStatus -- Immigration status
	BEGIN TRY
		INSERT INTO [dbo].[PersonStatus] (
			[PersonId]
			,[RefPersonStatusTypeId]
			,[StatusValue]
			,[StatusStartDate]
			,[StatusEndDate]
		)
		SELECT DISTINCT
			ps.PersonId								[PersonId]
			,@immigrantTitleIIIPersonStatusTypeId	[RefPersonStatusTypeId]
			,TitleIiiImmigrantStatus				[StatusValue]
			,ps.TitleIiiImmigrantStatus_StartDate	[StatusStartDate]
			,ps.TitleIiiImmigrantStatus_EndDate		[StatusEndDate]
		FROM Staging.ProgramParticipationTitleIII ps
		WHERE ps.TitleIiiImmigrantStatus = 1
		AND ps.PersonId IS NOT NULL
		AND ps.TitleIiiImmigrantStatus_StartDate <= @RecordEndDateTime
		AND (ps.TitleIiiImmigrantStatus_EndDate IS NULL OR ps.TitleIiiImmigrantStatus_EndDate >= @RecordStartDateTime)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonStatus', NULL, 'S12EC210' 
	END CATCH

	----Update the Staging table with the PersonStatus -- TitleIII Immigrant ID
	--BEGIN TRY
	--	UPDATE Staging.PersonStatus
	--	SET PersonStatusId_Immigration = pers.PersonStatusId
	--	FROM Staging.PersonStatus ps
	--	JOIN dbo.PersonStatus pers 
	--		ON ps.PersonId = pers.PersonId
	--		AND pers.StatusStartDate = ps.Immigrant_ProgramParticipationStartDate
	--		AND ISNULL(pers.StatusEndDate,'01/01/1900') = ISNULL(ps.Immigrant_ProgramParticipationEndDate,'01/01/1900')
	--		AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'TitleIIIImmigrant')
	--	WHERE ps.PersonStatusId_Immigrant IS NULL
	--END TRY
	--BEGIN CATCH 
	--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'ImmigrationPersonStatusId', 'S12EC210'
	--END CATCH
	-----Add in validation and error checking in this location --

END


