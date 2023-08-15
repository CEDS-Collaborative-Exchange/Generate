CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP09_ProgramParticipationTitleI_EncapsulatedCode]
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
		  EXEC App.[Migrate_Data_ETL_IMPLEMENTATION_STEP09_ProgramParticipationTitleI_EncapsulatedCode] 2018;
    
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

        ---------------------------------------------------
        --- Declare Error Handling Variables           ----
        ---------------------------------------------------
		DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP09_TitleIParticipation'

		--------------------------------------------------------------
		--- Optimize indexes on Staging.ProgramParticipationTitleI --- 
		--------------------------------------------------------------
		ALTER INDEX ALL ON Staging.ProgramParticipationTitleI
		REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

		-------------------------------------------------------
		---Update the RefTitleIIndicatorId --------------------
		-------------------------------------------------------

		--Need to add RefTitleIIndicator to the ODS.EdFiReferenceData table


		-------------------------------------------------------
		---Associate the PersonId with the staging table ----
		-------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.ProgramParticipationTitleI
			SET PersonID = pid.PersonId
			FROM Staging.ProgramParticipationTitleI mcc
			JOIN ODS.PersonIdentifier pid 
				ON mcc.Student_Identifier_State = pid.Identifier
			WHERE pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075')
				AND pid.RefPersonalInformationVerificationId = App.GetRefPersonalInformationVerificationId('01011')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'PersonID', 'S09EC100' 
		END CATCH

		--------------------------------------------------------------------
		---Associate the LEA OrganizationId with the staging table ----
		--------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.ProgramParticipationTitleI
			SET OrganizationID_LEA = orgid.OrganizationId
			FROM Staging.ProgramParticipationTitleI mcc
			JOIN ODS.OrganizationIdentifier orgid 
				ON mcc.LEA_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = [App].[GetOrganizationIdentifierTypeId]('001072')
				AND orgid.RefOrganizationIdentificationSystemId = [App].[GetOrganizationIdentifierSystemId]('SEA', '001072')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'OrganizationID_LEA', 'S09EC110' 
		END CATCH

		--------------------------------------------------------------------
		---Associate the School OrganizationId with the staging table ----
		--------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.ProgramParticipationTitleI
			SET OrganizationID_School = orgid.OrganizationId
			FROM Staging.ProgramParticipationTitleI mcc
			JOIN ODS.OrganizationIdentifier orgid 
				ON mcc.School_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = [App].[GetOrganizationIdentifierTypeId]('001073')
				AND orgid.RefOrganizationIdentificationSystemId = [App].[GetOrganizationIdentifierSystemId]('SEA', '001073')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'OrganizationID_School', 'S09EC120' 
		END CATCH

		-----------------------------------------------------------------------------
		---Associate the LEA Title I Program OrganizationId with the staging table ----
		-----------------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.ProgramParticipationTitleI
			SET LEAOrganizationID_TitleIProgram = orgd.OrganizationId
			FROM Staging.ProgramParticipationTitleI tp
			JOIN ODS.OrganizationRelationship orgr 
				ON tp.OrganizationID_LEA = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd 
				ON orgr.OrganizationId = orgd.OrganizationId
			JOIN ODS.OrganizationProgramType orgpt 
				ON orgd.OrganizationId = orgpt.OrganizationId
			JOIN ODS.RefProgramType rpt 
				ON orgpt.RefProgramTypeId = rpt.RefProgramTypeId
			WHERE orgd.Name = 'Title I Program'
				AND rpt.Code = '09999'
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'LEAOrganizationID_TitleIProgram', 'S09EC130' 
		END CATCH

		--Note: Need to change 09999 to the ID that represents Title I Programs when that is created ---

		-----------------------------------------------------------------------------
		---Associate the School Title I Program OrganizationId with the staging table ----
		-----------------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.ProgramParticipationTitleI
			SET SchoolOrganizationID_TitleIProgram = orgd.OrganizationId
			FROM Staging.ProgramParticipationTitleI tp
			JOIN ODS.OrganizationRelationship orgr 
				ON tp.OrganizationID_School = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd 
				ON orgr.OrganizationId = orgd.OrganizationId
			JOIN ODS.OrganizationProgramType orgpt 
				ON orgd.OrganizationId = orgpt.OrganizationId
			JOIN ODS.RefProgramType rpt 
				ON orgpt.RefProgramTypeId = rpt.RefProgramTypeId
			WHERE orgd.Name = 'Title I Program'
				AND rpt.Code = '09999'
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'SchoolOrganizationID_TitleIProgram', 'S09EC140' 
		END CATCH

		--Note: Need to change 09999 to the ID that represents Title I Programs when that is created ---

		--------------------------------------------------
		----Create Title I Indicator for the Student -----
		--------------------------------------------------
		BEGIN TRY
		--Check for Title I Records that already exist--
			--LEA
			UPDATE Staging.ProgramParticipationTitleI
			SET LEAOrganizationPersonRoleID_TitleIProgram = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationTitleI tp
			JOIN ODS.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
			WHERE tp.LEAOrganizationID_TitleIProgram = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student')
				AND opr.EntryDate = [App].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.ExitDate = [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'LEAOrganizationPersonRoleID_TitleIProgram', 'S09EC150' 
		END CATCH

		BEGIN TRY
			--School
			UPDATE Staging.ProgramParticipationTitleI
			SET SchoolOrganizationPersonRoleID_TitleIProgram = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationTitleI tp
			JOIN ODS.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
			WHERE tp.SchoolOrganizationID_TitleIProgram = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student')
				AND opr.EntryDate = [App].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.ExitDate = [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'SchoolOrganizationPersonRoleID_TitleIProgram', 'S09EC160' 
		END CATCH

		--Create an OrganizationPersonRole (Enrollment) into the Title I Program for the last day of the year --

		BEGIN TRY
			--LEA
			INSERT INTO [ODS].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				tp.LEAOrganizationID_TitleIProgram [OrganizationId]
			   ,tp.PersonID [PersonId]
			   ,App.GetRoleId('K12 Student') [RoleId]
			   ,[App].[GetFiscalYearStartDate](@SchoolYear) [EntryDate]
			   ,[App].[GetFiscalYearEndDate](@SchoolYear) [ExitDate] 
			FROM Staging.ProgramParticipationTitleI tp
			WHERE tp.LEAOrganizationPersonRoleID_TitleIProgram IS NULL
				AND tp.LEAOrganizationID_TitleIProgram IS NOT NULL
				AND tp.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S09EC170' 
		END CATCH

		BEGIN TRY
			--School
			INSERT INTO [ODS].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				tp.SchoolOrganizationID_TitleIProgram [OrganizationId]
			   ,tp.PersonID [PersonId]
			   ,App.GetRoleId('K12 Student') [RoleId]
			   ,[App].[GetFiscalYearStartDate](@SchoolYear) [EntryDate]
			   ,[App].[GetFiscalYearEndDate](@SchoolYear) [ExitDate] 
			FROM Staging.ProgramParticipationTitleI tp
			WHERE tp.SchoolOrganizationPersonRoleID_TitleIProgram IS NULL
				AND tp.SchoolOrganizationID_TitleIProgram IS NOT NULL
				AND tp.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S09EC180' 
		END CATCH

		--Update the staging table with the Title I Program OrganizationPersonRoleId

		BEGIN TRY
			--LEA
			UPDATE Staging.ProgramParticipationTitleI
			SET LEAOrganizationPersonRoleID_TitleIProgram = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationTitleI tp
			JOIN ODS.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
				AND tp.LEAOrganizationID_TitleIProgram = opr.OrganizationId
			WHERE opr.RoleId = App.GetRoleId('K12 Student')
				AND opr.EntryDate = [App].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.ExitDate = [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'LEAOrganizationPersonRoleID_TitleIProgram', 'S09EC190' 
		END CATCH

		BEGIN TRY
			--School
			UPDATE Staging.ProgramParticipationTitleI
			SET SchoolOrganizationPersonRoleID_TitleIProgram = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationTitleI tp
			JOIN ODS.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
				AND tp.SchoolOrganizationID_TitleIProgram = opr.OrganizationId
			WHERE opr.RoleId = App.GetRoleId('K12 Student')
				AND opr.EntryDate = [App].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.ExitDate = [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'SchoolOrganizationPersonRoleID_TitleIProgram', 'S09EC200' 
		END CATCH

		--Check to see if a PersonProgramParticipation already exists for the Title I Program--

		BEGIN TRY
			--LEA
			UPDATE Staging.ProgramParticipationTitleI
			SET LEAPersonProgramParticipationId = ppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationTitleI tp
			JOIN ODS.PersonProgramParticipation ppp 
				ON tp.LEAOrganizationPersonRoleID_TitleIProgram = ppp.OrganizationPersonRoleId
			JOIN ODS.ProgramParticipationTitleI pp 
				ON ppp.PersonProgramParticipationId = pp.PersonProgramParticipationId
				AND pp.RefTitleIIndicatorId = tp.RefTitleIIndicatorId
			WHERE ppp.RecordStartDateTime = [App].[GetFiscalYearStartDate](@SchoolYear)
				AND ppp.RecordEndDateTime = [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'LEAPersonProgramParticipationId', 'S09EC210' 
		END CATCH

		BEGIN TRY
			--School
			UPDATE Staging.ProgramParticipationTitleI
			SET SchoolPersonProgramParticipationId = ppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationTitleI tp
			JOIN ODS.PersonProgramParticipation ppp 
				ON tp.SchoolOrganizationPersonRoleID_TitleIProgram = ppp.OrganizationPersonRoleId
			JOIN ODS.ProgramParticipationTitleI pp 
				ON ppp.PersonProgramParticipationId = pp.PersonProgramParticipationId
				AND pp.RefTitleIIndicatorId = tp.RefTitleIIndicatorId
			WHERE ppp.RecordStartDateTime = [App].[GetFiscalYearStartDate](@SchoolYear)
				AND ppp.RecordEndDateTime = [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'SchoolPersonProgramParticipationId', 'S09EC220' 
		END CATCH



		--Create a PersonProgramParticipation for each OrganizationPersonRole
		--LEA
		DECLARE @LEANewPersonProgramParticipationTitleI TABLE (
			  PersonProgramParticipationId INT
			, SourceId INT
		);

		BEGIN TRY
			MERGE [ODS].[PersonProgramParticipation] AS TARGET
			USING Staging.ProgramParticipationTitleI AS SOURCE
				ON SOURCE.LEAPersonProgramParticipationId = TARGET.PersonProgramParticipationId
			WHEN NOT MATCHED AND SOURCE.LEAOrganizationPersonRoleID_TitleIProgram IS NOT NULL THEN 
				INSERT 
			   ([OrganizationPersonRoleId]
			   ,[RefParticipationTypeId]
			   ,[RefProgramExitReasonId]
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime])
			VALUES
			   (LEAOrganizationPersonRoleID_TitleIProgram 
			   ,NULL 
			   ,NULL 
			   ,[App].[GetFiscalYearStartDate](@SchoolYear) 
			   ,[App].[GetFiscalYearEndDate](@SchoolYear))
			OUTPUT
				  INSERTED.PersonProgramParticipationId 
				, SOURCE.ID
			INTO @LEANewPersonProgramParticipationTitleI;
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S09EC230' 
		END CATCH

		BEGIN TRY
					--Update the staging table with the new PersonProgramParticipationId
			UPDATE Staging.ProgramParticipationTitleI
			SET LEAPersonProgramParticipationId = nppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationTitleI ppi
			JOIN @LEANewPersonProgramParticipationTitleI nppp
				ON ppi.ID = nppp.SourceId
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI', 'LEAPersonProgramParticipationId', 'S09EC240' 
		END CATCH

		--Create a ProgramParticipationTitleI for each PersonProgramParticipation--

		BEGIN TRY
			INSERT INTO [ODS].[ProgramParticipationTitleI]
			   ([PersonProgramParticipationId]
			   ,[RefTitleIIndicatorId])
			SELECT DISTINCT
				tp.LEAPersonProgramParticipationId [PersonProgramParticipationId]
			   ,rti.RefTitleIIndicatorId [RefTitleIIndicatorId]
			FROM Staging.ProgramParticipationTitleI tp
			JOIN ODS.SourceSystemReferenceData rd 
				ON tp.TitleIIndicator = rd.InputCode
				AND rd.TableName = 'RefTitleIIndicator'
				AND rd.SchoolYear = @SchoolYear
			JOIN ODS.RefTitleIIndicator rti 
				ON rd.OutputCode = rti.Code
			WHERE tp.LEAPersonProgramParticipationId IS NOT NULL
				AND rti.RefTitleIIndicatorId IS NOT NULL	
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationTitleI', NULL, 'S09EC250' 
		END CATCH


		--School
		DECLARE @SchoolNewPersonProgramParticipationTitleI TABLE (
			  PersonProgramParticipationId INT
			, SourceId INT
		);

		BEGIN TRY
			MERGE [ODS].[PersonProgramParticipation] AS TARGET
			USING Staging.ProgramParticipationTitleI AS SOURCE
				ON SOURCE.SchoolPersonProgramParticipationId = TARGET.PersonProgramParticipationId
			WHEN NOT MATCHED AND SOURCE.SchoolOrganizationPersonRoleID_TitleIProgram IS NOT NULL THEN 
				INSERT 
			   ([OrganizationPersonRoleId]
			   ,[RefParticipationTypeId]
			   ,[RefProgramExitReasonId]
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime])
			VALUES
			   (SchoolOrganizationPersonRoleID_TitleIProgram 
			   ,NULL 
			   ,NULL 
			   ,[App].[GetFiscalYearStartDate](@SchoolYear) 
			   ,[App].[GetFiscalYearEndDate](@SchoolYear))
			OUTPUT
				  INSERTED.PersonProgramParticipationId 
				, SOURCE.ID
			INTO @SchoolNewPersonProgramParticipationTitleI;
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S09EC260' 
		END CATCH

		BEGIN TRY
			--Update the staging table with the new PersonProgramParticipationId
			UPDATE Staging.ProgramParticipationTitleI 
			SET SchoolPersonProgramParticipationId = nppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationTitleI ppi
			JOIN @SchoolNewPersonProgramParticipationTitleI nppp
				ON ppi.ID = nppp.SourceId
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleI ', 'SchoolPersonProgramParticipationId', 'S09EC270' 
		END CATCH

		BEGIN TRY
			--Create a ProgramParticipationTitleI for each PersonProgramParticipation--
			INSERT INTO [ODS].[ProgramParticipationTitleI]
			   ([PersonProgramParticipationId]
			   ,[RefTitleIIndicatorId])
			SELECT DISTINCT
				tp.SchoolPersonProgramParticipationId [PersonProgramParticipationId]
			   ,rti.RefTitleIIndicatorId [RefTitleIIndicatorId]
			FROM Staging.ProgramParticipationTitleI tp
			JOIN ODS.SourceSystemReferenceData rd 
				ON tp.TitleIIndicator = rd.InputCode
				AND rd.TableName = 'RefTitleIIndicator'
				AND rd.SchoolYear = @SchoolYear
			JOIN ODS.RefTitleIIndicator rti 
				ON rd.OutputCode = rti.Code
			WHERE tp.SchoolPersonProgramParticipationId IS NOT NULL
				AND rti.RefTitleIIndicatorId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationTitleI', NULL, 'S09EC280' 
		END CATCH


		---Add in validation and error checking in this location --

		set nocount off;


	END



