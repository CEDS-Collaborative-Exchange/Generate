CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_ProgramParticipationTitleI]
	@SchoolYear SMALLINT = NULL
AS

	/*************************************************************************************************************
	Date Created:  2/12/2018

	Purpose:
		The purpose of this ETL is to load Title 1 indicators about students for EDFacts reports that apply to the full year.

	Assumptions:
        
	Account executed under: LOGIN

	Approximate run time:  ~ 5 seconds

	Data Sources: 

	Data Targets:  Generate Database:   Generate

	Return Values:
    		0	= Success
  
	Example Usage: 
		EXEC Staging.[Migrate_StagingToIDS_ProgramParticipationTitleI] 2018;
    
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
    --- Declare Error Handling Variables           ----
    ---------------------------------------------------
	DECLARE @eStoredProc			varchar(100) = 'Migrate_StagingToIDS_ProgramParticipationTitleI'

	DECLARE @RefPersonIdentificationSystemId INT, @RefPersonalInformationVerificationId INT
	DECLARE @RefOrganizationIdentifierTypeId INT, @RefOrganizationIdentificationSystemId INT
	
	SELECT @RefPersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001075')
	SELECT @RefPersonalInformationVerificationId = Staging.GetRefPersonalInformationVerificationId('01011')
	SELECT @RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('001072')
	SELECT @RefOrganizationIdentificationSystemId = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001072')


	--------------------------------------------------------------
	--- Optimize indexes on Staging.ProgramParticipationTitleI --- 
	--------------------------------------------------------------
	ALTER INDEX ALL ON Staging.ProgramParticipationTitleI
	REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

	-------------------------------------------------------
	---Update the RefTitleIIndicatorId --------------------
	-------------------------------------------------------

	--Need to add RefTitleIIndicator to the dbo.EdFiReferenceData table

	-------------------------------------------------------
	---Associate the PersonId with the staging table ----
	-------------------------------------------------------
	BEGIN TRY

		UPDATE Staging.ProgramParticipationTitleI
		SET PersonID = pid.PersonId
		FROM Staging.ProgramParticipationTitleI mcc
		JOIN dbo.PersonIdentifier pid 
			ON mcc.Student_Identifier_State = pid.Identifier
		WHERE pid.RefPersonIdentificationSystemId = @RefPersonIdentificationSystemId
			AND pid.RefPersonalInformationVerificationId = @RefPersonalInformationVerificationId
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'PersonID', 'S09EC100' 
	END CATCH

	--------------------------------------------------------------------
	---Associate the LEA OrganizationId with the staging table ----
	--------------------------------------------------------------------
	BEGIN TRY


		UPDATE Staging.ProgramParticipationTitleI
		SET OrganizationID_LEA = orgid.OrganizationId
		FROM Staging.ProgramParticipationTitleI mcc
		JOIN dbo.OrganizationIdentifier orgid 
			ON mcc.LEA_Identifier_State = orgid.Identifier
		WHERE orgid.RefOrganizationIdentifierTypeId = @RefOrganizationIdentifierTypeId
			AND orgid.RefOrganizationIdentificationSystemId = @RefOrganizationIdentificationSystemId
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'OrganizationID_LEA', 'S09EC110' 
	END CATCH

	--------------------------------------------------------------------
	---Associate the School OrganizationId with the staging table ----
	--------------------------------------------------------------------
	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleI
		SET OrganizationID_School = orgid.OrganizationId
		FROM Staging.ProgramParticipationTitleI mcc
		JOIN dbo.OrganizationIdentifier orgid 
			ON mcc.School_Identifier_State = orgid.Identifier
		WHERE orgid.RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('001073')
			AND orgid.RefOrganizationIdentificationSystemId = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001073')
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'OrganizationID_School', 'S09EC120' 
	END CATCH

	-----------------------------------------------------------------------------
	---Associate the LEA Title I Program OrganizationId with the staging table ----
	-----------------------------------------------------------------------------
	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleI
		SET OrganizationID_TitleIProgram_LEA = orgd.OrganizationId
		FROM Staging.ProgramParticipationTitleI tp
		JOIN dbo.OrganizationRelationship orgr 
			ON tp.OrganizationID_LEA = orgr.Parent_OrganizationId
		JOIN dbo.OrganizationDetail orgd 
			ON orgr.OrganizationId = orgd.OrganizationId
		JOIN dbo.OrganizationProgramType orgpt 
			ON orgd.OrganizationId = orgpt.OrganizationId
		JOIN dbo.RefProgramType rpt 
			ON orgpt.RefProgramTypeId = rpt.RefProgramTypeId
		WHERE orgd.Name = 'Title I Program'
			AND rpt.Code = '09999'
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'LEAOrganizationID_TitleIProgram', 'S09EC130' 
	END CATCH

	--Note: Need to change 09999 to the ID that represents Title I Programs when that is created ---

	-----------------------------------------------------------------------------
	---Associate the School Title I Program OrganizationId with the staging table ----
	-----------------------------------------------------------------------------
	BEGIN TRY
		UPDATE Staging.ProgramParticipationTitleI
		SET OrganizationID_TitleIProgram_School = orgd.OrganizationId
		FROM Staging.ProgramParticipationTitleI tp
		JOIN dbo.OrganizationRelationship orgr 
			ON tp.OrganizationID_School = orgr.Parent_OrganizationId
		JOIN dbo.OrganizationDetail orgd 
			ON orgr.OrganizationId = orgd.OrganizationId
		JOIN dbo.OrganizationProgramType orgpt 
			ON orgd.OrganizationId = orgpt.OrganizationId
		JOIN dbo.RefProgramType rpt 
			ON orgpt.RefProgramTypeId = rpt.RefProgramTypeId
		WHERE orgd.Name = 'Title I Program'
			AND rpt.Code = '09999'
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'SchoolOrganizationID_TitleIProgram', 'S09EC140' 
	END CATCH

	--Note: Need to change 09999 to the ID that represents Title I Programs when that is created ---

	--------------------------------------------------
	----Create Title I Indicator for the Student -----
	--------------------------------------------------
	BEGIN TRY
	--Check for Title I Records that already exist--
		--LEA
		UPDATE Staging.ProgramParticipationTitleI
		SET OrganizationPersonRoleID_TitleIProgram_LEA = opr.OrganizationPersonRoleId
		FROM Staging.ProgramParticipationTitleI tp
		JOIN dbo.OrganizationPersonRole opr 
			ON tp.PersonID = opr.PersonId
		WHERE tp.OrganizationID_TitleIProgram_LEA = opr.OrganizationId
			AND opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = [Staging].[GetFiscalYearStartDate](@SchoolYear)
			AND opr.ExitDate = [Staging].[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'LEAOrganizationPersonRoleID_TitleIProgram', 'S09EC150' 
	END CATCH

	BEGIN TRY
		--School
		UPDATE Staging.ProgramParticipationTitleI
		SET OrganizationPersonRoleID_TitleIProgram_School = opr.OrganizationPersonRoleId
		FROM Staging.ProgramParticipationTitleI tp
		JOIN dbo.OrganizationPersonRole opr 
			ON tp.PersonID = opr.PersonId
		WHERE tp.OrganizationID_TitleIProgram_School = opr.OrganizationId
			AND opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = [Staging].[GetFiscalYearStartDate](@SchoolYear)
			AND opr.ExitDate = [Staging].[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'SchoolOrganizationPersonRoleID_TitleIProgram', 'S09EC160' 
	END CATCH

	--Create an OrganizationPersonRole (Enrollment) into the Title I Program for the last day of the year --

	BEGIN TRY
		--LEA
		INSERT INTO [dbo].[OrganizationPersonRole] (
			[OrganizationId]
			,[PersonId]
			,[RoleId]
			,[EntryDate]
			,[ExitDate]
		)
		SELECT DISTINCT
			tp.OrganizationID_TitleIProgram_LEA					[OrganizationId]
			,tp.PersonID										[PersonId]
			,Staging.GetRoleId('K12 Student')					[RoleId]
			,[Staging].[GetFiscalYearStartDate](@SchoolYear)	[EntryDate]
			,[Staging].[GetFiscalYearEndDate](@SchoolYear)		[ExitDate] 
		FROM Staging.ProgramParticipationTitleI tp
		WHERE tp.OrganizationPersonRoleID_TitleIProgram_LEA IS NULL
			AND tp.OrganizationID_TitleIProgram_LEA IS NOT NULL
			AND tp.PersonID IS NOT NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S09EC170' 
	END CATCH

	BEGIN TRY
		--School
		INSERT INTO [dbo].[OrganizationPersonRole]  (
			[OrganizationId]
			,[PersonId]
			,[RoleId]
			,[EntryDate]
			,[ExitDate]
		)
		SELECT DISTINCT
			tp.OrganizationID_TitleIProgram_School				[OrganizationId]
			,tp.PersonID										[PersonId]
			,Staging.GetRoleId('K12 Student')					[RoleId]
			,[Staging].[GetFiscalYearStartDate](@SchoolYear)	[EntryDate]
			,[Staging].[GetFiscalYearEndDate](@SchoolYear)		[ExitDate] 
		FROM Staging.ProgramParticipationTitleI tp
		WHERE tp.OrganizationPersonRoleID_TitleIProgram_School IS NULL
			AND tp.OrganizationID_TitleIProgram_School IS NOT NULL
			AND tp.PersonID IS NOT NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S09EC180' 
	END CATCH

	--Update the staging table with the Title I Program OrganizationPersonRoleId

	BEGIN TRY
		--LEA
		UPDATE Staging.ProgramParticipationTitleI
		SET OrganizationPersonRoleID_TitleIProgram_LEA = opr.OrganizationPersonRoleId
		FROM Staging.ProgramParticipationTitleI tp
		JOIN dbo.OrganizationPersonRole opr 
			ON tp.PersonID = opr.PersonId
			AND tp.OrganizationID_TitleIProgram_LEA = opr.OrganizationId
		WHERE opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = [Staging].[GetFiscalYearStartDate](@SchoolYear)
			AND opr.ExitDate = [Staging].[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'LEAOrganizationPersonRoleID_TitleIProgram', 'S09EC190' 
	END CATCH

	BEGIN TRY
		--School
		UPDATE Staging.ProgramParticipationTitleI
		SET OrganizationPersonRoleID_TitleIProgram_School = opr.OrganizationPersonRoleId
		FROM Staging.ProgramParticipationTitleI tp
		JOIN dbo.OrganizationPersonRole opr 
			ON tp.PersonID = opr.PersonId
			AND tp.OrganizationID_TitleIProgram_School = opr.OrganizationId
		WHERE opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = [Staging].[GetFiscalYearStartDate](@SchoolYear)
			AND opr.ExitDate = [Staging].[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'SchoolOrganizationPersonRoleID_TitleIProgram', 'S09EC200' 
	END CATCH

	--Check to see if a PersonProgramParticipation already exists for the Title I Program--

	BEGIN TRY
		--LEA
		UPDATE Staging.ProgramParticipationTitleI
		SET PersonProgramParticipationId_LEA = ppp.PersonProgramParticipationId
		FROM Staging.ProgramParticipationTitleI tp
		JOIN dbo.PersonProgramParticipation ppp 
			ON tp.OrganizationPersonRoleID_TitleIProgram_LEA = ppp.OrganizationPersonRoleId
		JOIN dbo.ProgramParticipationTitleI pp 
			ON ppp.PersonProgramParticipationId = pp.PersonProgramParticipationId
			AND pp.RefTitleIIndicatorId = tp.RefTitleIIndicatorId
		WHERE ppp.RecordStartDateTime = [Staging].[GetFiscalYearStartDate](@SchoolYear)
			AND ppp.RecordEndDateTime = [Staging].[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'LEAPersonProgramParticipationId', 'S09EC210' 
	END CATCH

	BEGIN TRY
		--School
		UPDATE Staging.ProgramParticipationTitleI
		SET PersonProgramParticipationId_School = ppp.PersonProgramParticipationId
		FROM Staging.ProgramParticipationTitleI tp
		JOIN dbo.PersonProgramParticipation ppp 
			ON tp.OrganizationPersonRoleID_TitleIProgram_School = ppp.OrganizationPersonRoleId
		JOIN dbo.ProgramParticipationTitleI pp 
			ON ppp.PersonProgramParticipationId = pp.PersonProgramParticipationId
			AND pp.RefTitleIIndicatorId = tp.RefTitleIIndicatorId
		WHERE ppp.RecordStartDateTime = [Staging].[GetFiscalYearStartDate](@SchoolYear)
			AND ppp.RecordEndDateTime = [Staging].[GetFiscalYearEndDate](@SchoolYear)
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'SchoolPersonProgramParticipationId', 'S09EC220' 
	END CATCH



	--Create a PersonProgramParticipation for each OrganizationPersonRole
	--LEA
	DECLARE @LEANewPersonProgramParticipationTitleI TABLE (
			PersonProgramParticipationId INT
		, SourceId INT
	);

	BEGIN TRY
		MERGE [dbo].[PersonProgramParticipation] AS TARGET
		USING Staging.ProgramParticipationTitleI AS SOURCE
			ON SOURCE.PersonProgramParticipationId_LEA = TARGET.PersonProgramParticipationId
		WHEN NOT MATCHED AND SOURCE.OrganizationPersonRoleID_TitleIProgram_LEA IS NOT NULL THEN 
			INSERT (
			[OrganizationPersonRoleId]
			,[RefParticipationTypeId]
			,[RefProgramExitReasonId]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
			)
		VALUES (
			OrganizationPersonRoleID_TitleIProgram_LEA
			,NULL 
			,NULL 
			,[Staging].[GetFiscalYearStartDate](@SchoolYear) 
			,[Staging].[GetFiscalYearEndDate](@SchoolYear)
			)
		OUTPUT
			INSERTED.PersonProgramParticipationId 
			, SOURCE.ID
		INTO @LEANewPersonProgramParticipationTitleI;
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S09EC230' 
	END CATCH

	BEGIN TRY
		--Update the staging table with the new PersonProgramParticipationId
		UPDATE Staging.ProgramParticipationTitleI
		SET PersonProgramParticipationId_LEA = nppp.PersonProgramParticipationId
		FROM Staging.ProgramParticipationTitleI ppi
		JOIN @LEANewPersonProgramParticipationTitleI nppp
			ON ppi.ID = nppp.SourceId
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'LEAPersonProgramParticipationId', 'S09EC240' 
	END CATCH

	--Create a ProgramParticipationTitleI for each PersonProgramParticipation--

	BEGIN TRY
		INSERT INTO [dbo].[ProgramParticipationTitleI] (
			[PersonProgramParticipationId]
			,[RefTitleIIndicatorId]
		)
		SELECT DISTINCT
			tp.PersonProgramParticipationId_LEA		[PersonProgramParticipationId]
			,rti.RefTitleIIndicatorId				[RefTitleIIndicatorId]
		FROM Staging.ProgramParticipationTitleI tp
		JOIN Staging.SourceSystemReferenceData rd 
			ON tp.TitleIIndicator = rd.InputCode
			AND rd.TableName = 'RefTitleIIndicator'
			AND rd.SchoolYear = @SchoolYear
		JOIN dbo.RefTitleIIndicator rti 
			ON rd.OutputCode = rti.Code
		WHERE tp.PersonProgramParticipationId_LEA IS NOT NULL
			AND rti.RefTitleIIndicatorId IS NOT NULL	
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationTitleI', NULL, 'S09EC250' 
	END CATCH


	--School
	DECLARE @SchoolNewPersonProgramParticipationTitleI TABLE (
			PersonProgramParticipationId INT
		, SourceId INT
	);

	BEGIN TRY
		MERGE [dbo].[PersonProgramParticipation] AS TARGET
		USING Staging.ProgramParticipationTitleI AS SOURCE
			ON SOURCE.PersonProgramParticipationId_School = TARGET.PersonProgramParticipationId
		WHEN NOT MATCHED AND SOURCE.OrganizationPersonRoleID_TitleIProgram_School IS NOT NULL THEN 
			INSERT (
			[OrganizationPersonRoleId]
			,[RefParticipationTypeId]
			,[RefProgramExitReasonId]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
			)
		VALUES (
			OrganizationPersonRoleID_TitleIProgram_School
			,NULL 
			,NULL 
			,[Staging].[GetFiscalYearStartDate](@SchoolYear) 
			,[Staging].[GetFiscalYearEndDate](@SchoolYear)
			)
		OUTPUT
			INSERTED.PersonProgramParticipationId 
			, SOURCE.ID
		INTO @SchoolNewPersonProgramParticipationTitleI;
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S09EC260' 
	END CATCH

	BEGIN TRY
		--Update the staging table with the new PersonProgramParticipationId
		UPDATE Staging.ProgramParticipationTitleI 
		SET PersonProgramParticipationId_School = nppp.PersonProgramParticipationId
		FROM Staging.ProgramParticipationTitleI ppi
		JOIN @SchoolNewPersonProgramParticipationTitleI nppp
			ON ppi.ID = nppp.SourceId
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI ', 'SchoolPersonProgramParticipationId', 'S09EC270' 
	END CATCH

	BEGIN TRY
		--Create a ProgramParticipationTitleI for each PersonProgramParticipation--
		INSERT INTO [dbo].[ProgramParticipationTitleI] (
			[PersonProgramParticipationId]
			,[RefTitleIIndicatorId]
		)
		SELECT DISTINCT
			tp.PersonProgramParticipationId_School	[PersonProgramParticipationId]
			,rti.RefTitleIIndicatorId				[RefTitleIIndicatorId]
		FROM Staging.ProgramParticipationTitleI tp
		JOIN Staging.SourceSystemReferenceData rd 
			ON tp.TitleIIndicator = rd.InputCode
			AND rd.TableName = 'RefTitleIIndicator'
			AND rd.SchoolYear = @SchoolYear
		JOIN dbo.RefTitleIIndicator rti 
			ON rd.OutputCode = rti.Code
		WHERE tp.PersonProgramParticipationId_School IS NOT NULL
			AND rti.RefTitleIIndicatorId IS NOT NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationTitleI', NULL, 'S09EC280' 
	END CATCH

	---Add in validation and error checking in this location --

	set nocount off;

END



