CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP08_Migrant_EncapsulatedCode]
	@SchoolYear SMALLINT = NULL
AS

    /*************************************************************************************************************
    Date Created:  2/12/2018

    Purpose:
        The purpose of this ETL is to load Migrant indicators about students for EDFacts reports that apply to the full year.

    Assumptions:
        
    Account executed under: LOGIN

    Approximate run time:  ~ 5 seconds

    Data Sources: 

    Data Targets:  Generate Database:   Generate

    Return Values:
    	 0	= Success
  
    Example Usage: 
      EXEC App.[Migrate_Data_ETL_IMPLEMENTATION_STEP08_Migrant_EncapsulatedCode];
    
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
		DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP08_Migrant_EncapsulatedCode'

		--------------------------------------------------------
		---Associate the PersonId with the temporary tables ----
		--------------------------------------------------------

		BEGIN TRY
			--Staging.Migrant
			UPDATE Staging.Migrant
			SET PersonID = pid.PersonId
			FROM Staging.Migrant mcc
			JOIN ODS.PersonIdentifier pid 
				ON mcc.Student_Identifier_State = pid.Identifier
			WHERE pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075')
			AND pid.RefPersonalInformationVerificationId = App.GetRefPersonalInformationVerificationId('01011') 
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'PersonID', 'S08EC100' 
		END CATCH

		------------------------------------------------------------------
		---Associate the LEA OrganizationId with the temporary tables ----
		------------------------------------------------------------------

		BEGIN TRY
			--Staging.Migrant
			UPDATE Staging.Migrant
			SET OrganizationID_LEA = orgid.OrganizationId
			FROM Staging.Migrant mcc
			JOIN ODS.OrganizationIdentifier orgid 
				ON mcc.School_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = App.GetOrganizationIdentifierTypeId('001072')
			AND orgid.RefOrganizationIdentificationSystemId = App.GetOrganizationIdentifierSystemId('SEA', '001072')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'OrganizationID_LEA', 'S08EC110' 
		END CATCH

		---------------------------------------------------------------------
		---Associate the School OrganizationId with the temporary tables ----
		---------------------------------------------------------------------
		
		BEGIN TRY
			--Staging.Migrant
			UPDATE Staging.Migrant
			SET OrganizationID_School = orgid.OrganizationId
			FROM Staging.Migrant mcc
			JOIN ODS.OrganizationIdentifier orgid 
				ON mcc.School_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = App.GetOrganizationIdentifierTypeId('001073')
			AND orgid.RefOrganizationIdentificationSystemId = App.GetOrganizationIdentifierSystemId('SEA', '001073')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'OrganizationID_School', 'S08EC120' 
		END CATCH


		------------------------------------------------------------------------------
		---Associate the LEA Migrant Program OrganizationId with the temporary tables ----
		------------------------------------------------------------------------------

		BEGIN TRY
			--Staging.Migrant
			UPDATE Staging.Migrant
			SET LEAOrganizationID_MigrantProgram = orgd.OrganizationId
			FROM Staging.Migrant tp
			JOIN ODS.OrganizationRelationship orgr 
				ON tp.OrganizationID_LEA = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd 
				ON orgr.OrganizationId = orgd.OrganizationId
			JOIN ODS.OrganizationProgramType orgpt 
				ON orgd.OrganizationId = orgpt.OrganizationId
			JOIN ODS.RefProgramType rpt 
				ON orgpt.RefProgramTypeId = rpt.RefProgramTypeId
			LEFT JOIN ODS.OrganizationRelationship orl
				ON orl.OrganizationId = tp.OrganizationID_School
			WHERE orgd.Name = 'Migrant Program'
				AND rpt.Code = '04920'
				AND (orl.Parent_OrganizationId <> tp.OrganizationID_LEA 
					or tp.OrganizationID_School IS NULL)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'LEAOrganizationID_MigrantProgram', 'S08EC130' 
		END CATCH


		-------------------------------------------------------------------------------------
		---Associate the School Migrant Program OrganizationId with the temporary tables ----
		-------------------------------------------------------------------------------------

		BEGIN TRY
		--Staging.Migrant
		UPDATE Staging.Migrant
			SET SchoolOrganizationID_MigrantProgram = orgd.OrganizationId
			FROM Staging.Migrant tp
			JOIN ODS.OrganizationRelationship orgr 
				ON tp.OrganizationID_School = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd 
				ON orgr.OrganizationId = orgd.OrganizationId
			JOIN ODS.OrganizationProgramType orgpt 
				ON orgd.OrganizationId = orgpt.OrganizationId
			JOIN ODS.RefProgramType rpt 
				ON orgpt.RefProgramTypeId = rpt.RefProgramTypeId
			WHERE orgd.Name = 'Migrant Program'
				AND rpt.Code = '04920'
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'SchoolOrganizationID_MigrantProgram', 'S08EC140' 
		END CATCH


		-----------------------------------------------------------------------------
		----Create an OrganizationPersonRole Migrant Status for the Student --------
		-----------------------------------------------------------------------------

		--Check for Migrant Records that already exist--

		--Staging.Migrant

		BEGIN TRY
			--LEA
			UPDATE Staging.Migrant
			SET LEAOrganizationPersonRoleID_MigrantProgram = opr.OrganizationPersonRoleId
			FROM Staging.Migrant tp
			JOIN ODS.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
			WHERE tp.LEAOrganizationID_MigrantProgram = opr.OrganizationId
			AND opr.RoleId = App.GetRoleId('K12 Student')
			AND opr.EntryDate = ISNULL(tp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear))
			AND (opr.ExitDate IS NULL OR opr.ExitDate = ISNULL(tp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear)))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'LEAOrganizationPersonRoleID_MigrantProgram', 'S08EC150' 
		END CATCH

		BEGIN TRY
			--School
			UPDATE Staging.Migrant
			SET SchoolOrganizationPersonRoleID_MigrantProgram = opr.OrganizationPersonRoleId
			FROM Staging.Migrant tp
			JOIN ODS.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
			WHERE tp.SchoolOrganizationID_MigrantProgram = opr.OrganizationId
			AND opr.RoleId = App.GetRoleId('K12 Student')
			AND opr.EntryDate = ISNULL(tp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear))
			AND (opr.ExitDate IS NULL OR opr.ExitDate = ISNULL(tp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear)))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'SchoolOrganizationPersonRoleID_MigrantProgram', 'S08EC160' 
		END CATCH

		BEGIN TRY
			--Create an OrganizationPersonRole (Enrollment) into the Migrant Program if the ProgramParticipationStartDate and ProgramParticipationEndDates are supplied
			--LEA
			INSERT INTO [ODS].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				tp.LEAOrganizationID_MigrantProgram [OrganizationId]
			   ,tp.PersonID [PersonId]
			   ,App.GetRoleId('K12 Student') [RoleId]
			   ,ISNULL(tp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear)) [EntryDate]
			   ,ISNULL(tp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear)) [ExitDate] 
			FROM Staging.Migrant tp
			WHERE tp.LEAOrganizationPersonRoleID_MigrantProgram IS NULL
			AND tp.LEAOrganizationID_MigrantProgram IS NOT NULL
			AND tp.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S08EC170' 
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
				tp.SchoolOrganizationID_MigrantProgram [OrganizationId]
			   ,tp.PersonID [PersonId]
			   ,App.GetRoleId('K12 Student') [RoleId]
			   ,ISNULL(tp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear)) [EntryDate]
			   ,ISNULL(tp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear)) [ExitDate] 
			FROM Staging.Migrant tp
			WHERE tp.SchoolOrganizationPersonRoleID_MigrantProgram IS NULL
			AND tp.SchoolOrganizationID_MigrantProgram IS NOT NULL
			AND tp.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S08EC180' 
		END CATCH

		--Update the temporary table with the Migrant Program OrganizationPersonRoleId

		BEGIN TRY
			--Staging.Migrant
			--LEA
			UPDATE Staging.Migrant
			SET LEAOrganizationPersonRoleID_MigrantProgram = opr.OrganizationPersonRoleId
			FROM Staging.Migrant tp
			JOIN ODS.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
			WHERE tp.LEAOrganizationID_MigrantProgram = opr.OrganizationId
			AND opr.RoleId = App.GetRoleId('K12 Student')
			AND opr.EntryDate = ISNULL(tp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear))
			AND opr.ExitDate = ISNULL(tp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'LEAOrganizationPersonRoleID_MigrantProgram', 'S08EC190' 
		END CATCH

		BEGIN TRY
			--School
			UPDATE Staging.Migrant
			SET SchoolOrganizationPersonRoleID_MigrantProgram = opr.OrganizationPersonRoleId
			FROM Staging.Migrant tp
			JOIN ODS.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
			WHERE tp.SchoolOrganizationID_MigrantProgram = opr.OrganizationId
			AND opr.RoleId = App.GetRoleId('K12 Student')
			AND opr.EntryDate = ISNULL(tp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear))
			AND opr.ExitDate = ISNULL(tp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'SchoolOrganizationPersonRoleID_MigrantProgram', 'S08EC200' 
		END CATCH

		-------------------------------------------------------------------------------
		----Create a PersonProgramParticipation Migrant Status for the Student --------
		-------------------------------------------------------------------------------

		--Check to see if a PersonProgramParticipation already exists for the Migrant Program--

		BEGIN TRY
			--Staging.Migrant
			--LEA
			UPDATE Staging.Migrant
			SET PersonProgramParticipationId = ppp.PersonProgramParticipationId
			FROM Staging.Migrant tp
			JOIN ODS.PersonProgramParticipation ppp 
				ON tp.LEAOrganizationPersonRoleID_MigrantProgram = ppp.OrganizationPersonRoleId
			WHERE ppp.RecordStartDateTime = ISNULL(tp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear))
			AND ppp.RecordEndDateTime = ISNULL(tp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'PersonProgramParticipationId', 'S08EC210' 
		END CATCH

		BEGIN TRY
			--School
			UPDATE Staging.Migrant
			SET PersonProgramParticipationId = ppp.PersonProgramParticipationId
			FROM Staging.Migrant tp
			JOIN ODS.PersonProgramParticipation ppp 
				ON tp.SchoolOrganizationPersonRoleID_MigrantProgram = ppp.OrganizationPersonRoleId
			WHERE ppp.RecordStartDateTime = ISNULL(tp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear))
			AND ppp.RecordEndDateTime = ISNULL(tp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'PersonProgramParticipationId', 'S08EC220' 
		END CATCH

		--Create a PersonProgramParticipation for each OrganizationPersonRole
		
		DECLARE @refParticipationTypeId INT
		SELECT  @refParticipationTypeId = RefParticipationTypeId 
		FROM ODS.RefParticipationType WHERE Code = 'MEPParticipation'

		BEGIN TRY
			--Staging.Migrant
			--LEA	
			INSERT INTO [ODS].[PersonProgramParticipation]
			   ([OrganizationPersonRoleId]
			   ,[RefParticipationTypeId]
			   ,[RefProgramExitReasonId]
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime])
			SELECT DISTINCT
				tp.LEAOrganizationPersonRoleID_MigrantProgram		[OrganizationPersonRoleId]
			   ,@refParticipationTypeId								[RefParticipationTypeId]
			   ,NULL												[RefProgramExitReasonId]
			   ,ISNULL(tp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear)) [RecordStartDateTime]
			   ,ISNULL(tp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear)) [RecordEndDateTime]
			FROM Staging.Migrant tp
			WHERE tp.PersonProgramParticipationId IS NULL
			AND tp.LEAOrganizationPersonRoleID_MigrantProgram IS NOT NULL
			AND tp.ProgramParticipationStartDate IS NOT NULL


			-- Add as LEA oraganizationId for the generate purpose. May need change later
			-- Use OrganizationPersonRoleId with LEA organization Id becasue the generate's migrate procedures uses this Id - OrganizationPersonRoleId
			INSERT INTO [ODS].[PersonProgramParticipation]
			   ([OrganizationPersonRoleId]
			   ,[RefParticipationTypeId]
			   ,[RefProgramExitReasonId]
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime])
			SELECT DISTINCT
				leaop.OrganizationPersonRoleId
				,@refParticipationTypeId								[RefParticipationTypeId]
			   ,NULL												[RefProgramExitReasonId]
			   ,ISNULL(tp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear)) [RecordStartDateTime]
			   ,ISNULL(tp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear)) [RecordEndDateTime]
			FROM Staging.Migrant tp
			join ods.OrganizationPersonRole op on op.OrganizationPersonRoleId = tp.LEAOrganizationPersonRoleID_MigrantProgram
			join ods.OrganizationRelationship ors on ors.OrganizationId = op.OrganizationId
			join ods.OrganizationPersonRole leaop on leaop.OrganizationId = ors.Parent_OrganizationId and leaop.PersonId = op.PersonId
			WHERE  tp.LEAOrganizationPersonRoleID_MigrantProgram IS NOT NULL
			AND tp.ProgramParticipationStartDate IS NOT NULL

		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S08EC230' 
		END CATCH

		BEGIN TRY
			--School	
			INSERT INTO [ODS].[PersonProgramParticipation]
			   ([OrganizationPersonRoleId]
			   ,[RefParticipationTypeId]
			   ,[RefProgramExitReasonId]
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime])
			SELECT DISTINCT
				tp.SchoolOrganizationPersonRoleID_MigrantProgram [OrganizationPersonRoleId]
			   ,@refParticipationTypeId [RefParticipationTypeId]
			   ,NULL [RefProgramExitReasonId]
			   ,ISNULL(tp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear)) [RecordStartDateTime]
			   ,ISNULL(tp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear)) [RecordEndDateTime]
			FROM Staging.Migrant tp
			WHERE tp.PersonProgramParticipationId IS NULL
			AND tp.SchoolOrganizationPersonRoleID_MigrantProgram IS NOT NULL
			AND tp.ProgramParticipationStartDate IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S08EC240' 
		END CATCH

		--Update the temporary table with the Migrant Program PersonProgramParticipationId--

		BEGIN TRY
			--Staging.Migrant
			--LEA
			UPDATE Staging.Migrant
			SET PersonProgramParticipationId = ppp.PersonProgramParticipationId
			FROM Staging.Migrant tp
			JOIN ODS.PersonProgramParticipation ppp 
				ON tp.LEAOrganizationPersonRoleID_MigrantProgram = ppp.OrganizationPersonRoleId
			WHERE ppp.RecordStartDateTime = ISNULL(tp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear))
			AND ppp.RecordEndDateTime = ISNULL(tp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'PersonProgramParticipationId', 'S08EC250' 
		END CATCH

		BEGIN TRY
			--School
			UPDATE Staging.Migrant
			SET PersonProgramParticipationId = ppp.PersonProgramParticipationId
			FROM Staging.Migrant tp
			JOIN ODS.PersonProgramParticipation ppp 
				ON tp.SchoolOrganizationPersonRoleID_MigrantProgram = ppp.OrganizationPersonRoleId
			WHERE ppp.RecordStartDateTime = ISNULL(tp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear))
			AND ppp.RecordEndDateTime = ISNULL(tp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'PersonProgramParticipationId', 'S08EC260' 
		END CATCH

		-------------------------------------------------------------------------------
		----Create ProgramParticipationMigrant records for the Student ----------------
		-------------------------------------------------------------------------------

		--Create a ProgramParticipationMigrant for each PersonProgramParticipation--

		--Check to see if ProgramParticipationMigrant already exists

		BEGIN TRY
			--Staging.Migrant
			UPDATE Staging.Migrant
			SET ProgramParticipationMigrantId = ppm.ProgramParticipationMigrantId
			FROM Staging.Migrant mp
			JOIN ODS.PersonProgramParticipation pp 
				ON mp.PersonProgramParticipationId = pp.PersonProgramParticipationId
			JOIN ODS.ProgramParticipationMigrant ppm 
				ON pp.PersonProgramParticipationId = ppm.PersonProgramParticipationId
			WHERE ISNULL(ppm.RecordStartDateTime, App.GetFiscalYearStartDate(@SchoolYear)) = ISNULL(mp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear))
			AND ISNULL(ppm.RecordEndDateTime, App.GetFiscalYearEndDate(@SchoolYear)) = ISNULL(mp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'ProgramParticipationMigrantId', 'S08EC270' 
		END CATCH

		BEGIN TRY
			--Staging.Migrant
			INSERT INTO [ODS].[ProgramParticipationMigrant]
					   ([PersonProgramParticipationId]
					   ,[RefMepEnrollmentTypeId]
					   ,[RefMepProjectBasedId]
					   ,[RefMepServiceTypeId]
					   ,[MepEligibilityExpirationDate]
					   ,[ContinuationOfServicesStatus]
					   ,[RefContinuationOfServicesReasonId]
					   ,[BirthdateVerification]
					   ,[ImmunizationRecordFlag]
					   ,[MigrantStudentQualifyingArrivalDate]
					   ,[LastQualifyingMoveDate]
					   ,[QualifyingMoveFromCity]
					   ,[RefQualifyingMoveFromStateId]
					   ,[RefQualifyingMoveFromCountryId]
					   ,[DesignatedGraduationSchoolId]
					   ,[RecordStartDateTime]
					   ,[RecordEndDateTime]
					   ,[PrioritizedForServices])
			SELECT DISTINCT
						mp.PersonProgramParticipationId [PersonProgramParticipationId]
					   ,mepe.RefMepEnrollmentTypeId [RefMepEnrollmentTypeId]
					   ,NULL [RefMepProjectBasedId]
					   ,mepst.RefMepServiceTypeId [RefMepServiceTypeId]
					   ,NULL [MepEligibilityExpirationDate]
					   ,mp.MigrantEducationProgramContinuationOfServicesStatus [ContinuationOfServicesStatus]
					   ,conser.RefContinuationOfServicesReasonId [RefContinuationOfServicesReasonId]
					   ,NULL [BirthdateVerification]
					   ,NULL [ImmunizationRecordFlag]
					   ,mp.MigrantStudentQualifyingArrivalDate [MigrantStudentQualifyingArrivalDate]
					   ,mp.LastQualifyingMoveDate [LastQualifyingMoveDate]
					   ,NULL [QualifyingMoveFromCity]
					   ,NULL [RefQualifyingMoveFromStateId]
					   ,NULL [RefQualifyingMoveFromCountryId]
					   ,NULL [DesignatedGraduationSchoolId]
					   ,ISNULL(ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear)) [RecordStartDateTime]
					   ,ISNULL(ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear)) [RecordEndDateTime]
					   ,MigrantPrioritizedForServices [PrioritizedForServices]
			FROM Staging.Migrant mp
			JOIN ODS.SourceSystemReferenceData mepservice 
				ON mp.MigrantEducationProgramServicesType = mepservice.InputCode
				AND mepservice.TableName = 'RefMepServiceType'
				AND mepservice.SchoolYear = @SchoolYear
			JOIN ODS.RefMepServiceType mepst 
				ON mepservice.OutputCode = mepst.Code
			LEFT JOIN ODS.SourceSystemReferenceData mepenrollment 
				ON mp.MigrantEducationProgramEnrollmentType = mepenrollment.InputCode
				AND mepenrollment.TableName = 'RefMepEnrollmentType'
				AND mepenrollment.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefMepEnrollmentType mepe 
				ON mepenrollment.OutputCode = mepe.Code
			LEFT JOIN ODS.SourceSystemReferenceData ContinuationOfServices
				ON mp.ContinuationOfServicesReason = ContinuationOfServices.InputCode
				AND ContinuationOfServices.TableName = 'RefContinuationOfServices'
				AND ContinuationOfServices.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefContinuationOfServices conser 
				ON ContinuationOfServices.OutputCode = conser.Code
			WHERE mp.PersonProgramParticipationId IS NOT NULL
			AND mp.ProgramParticipationMigrantId IS NULL

			--Add PersonProgramParticipationId with LEA organization Id becasue the generate's migrate procedures uses this Id - PersonProgramParticipationId
			INSERT INTO [ODS].[ProgramParticipationMigrant]
					   ([PersonProgramParticipationId]
					   ,[RefMepEnrollmentTypeId]
					   ,[RefMepProjectBasedId]
					   ,[RefMepServiceTypeId]
					   ,[MepEligibilityExpirationDate]
					   ,[ContinuationOfServicesStatus]
					   ,[RefContinuationOfServicesReasonId]
					   ,[BirthdateVerification]
					   ,[ImmunizationRecordFlag]
					   ,[MigrantStudentQualifyingArrivalDate]
					   ,[LastQualifyingMoveDate]
					   ,[QualifyingMoveFromCity]
					   ,[RefQualifyingMoveFromStateId]
					   ,[RefQualifyingMoveFromCountryId]
					   ,[DesignatedGraduationSchoolId]
					   ,[RecordStartDateTime]
					   ,[RecordEndDateTime]
					   ,[PrioritizedForServices])
			SELECT DISTINCT
						ppp.PersonProgramParticipationId [PersonProgramParticipationId]
					   ,mepe.RefMepEnrollmentTypeId [RefMepEnrollmentTypeId]
					   ,NULL [RefMepProjectBasedId]
					   ,mepst.RefMepServiceTypeId [RefMepServiceTypeId]
					   ,NULL [MepEligibilityExpirationDate]
					   ,mp.MigrantEducationProgramContinuationOfServicesStatus [ContinuationOfServicesStatus]
					   ,conser.RefContinuationOfServicesReasonId [RefContinuationOfServicesReasonId]
					   ,NULL [BirthdateVerification]
					   ,NULL [ImmunizationRecordFlag]
					   ,mp.MigrantStudentQualifyingArrivalDate [MigrantStudentQualifyingArrivalDate]
					   ,mp.LastQualifyingMoveDate [LastQualifyingMoveDate]
					   ,NULL [QualifyingMoveFromCity]
					   ,NULL [RefQualifyingMoveFromStateId]
					   ,NULL [RefQualifyingMoveFromCountryId]
					   ,NULL [DesignatedGraduationSchoolId]
					   ,ISNULL(ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear)) [RecordStartDateTime]
					   ,ISNULL(ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear)) [RecordEndDateTime]
					   ,MigrantPrioritizedForServices [PrioritizedForServices]
			FROM Staging.Migrant mp
			join ODS.OrganizationPersonRole opr
				on opr.PersonId = mp.PersonID and opr.OrganizationId = mp.OrganizationID_LEA
			JOIN ODS.PersonProgramParticipation ppp 
				ON opr.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
						JOIN ODS.SourceSystemReferenceData mepservice 
				ON mp.MigrantEducationProgramServicesType = mepservice.InputCode
				AND mepservice.TableName = 'RefMepServiceType'
				AND mepservice.SchoolYear = @SchoolYear
			JOIN ODS.RefMepServiceType mepst 
				ON mepservice.OutputCode = mepst.Code
			LEFT JOIN ODS.SourceSystemReferenceData mepenrollment 
				ON mp.MigrantEducationProgramEnrollmentType = mepenrollment.InputCode
				AND mepenrollment.TableName = 'RefMepEnrollmentType'
				AND mepenrollment.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefMepEnrollmentType mepe 
				ON mepenrollment.OutputCode = mepe.Code
			LEFT JOIN ODS.SourceSystemReferenceData ContinuationOfServices
				ON mp.ContinuationOfServicesReason = ContinuationOfServices.InputCode
				AND ContinuationOfServices.TableName = 'RefContinuationOfServices'
				AND ContinuationOfServices.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefContinuationOfServices conser 
				ON ContinuationOfServices.OutputCode = conser.Code
			WHERE mp.PersonProgramParticipationId IS NOT NULL

		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationMigrant', NULL, 'S08EC280' 
		END CATCH

		BEGIN TRY
			--Update ProgramParticipationMigrantId in the staging table--
			UPDATE Staging.Migrant
			SET ProgramParticipationMigrantId = ppm.ProgramParticipationMigrantId
			FROM Staging.Migrant mp
			JOIN ODS.PersonProgramParticipation pp 
				ON mp.PersonProgramParticipationId = pp.PersonProgramParticipationId
			JOIN ODS.ProgramParticipationMigrant ppm 
				ON pp.PersonProgramParticipationId = ppm.PersonProgramParticipationId
			WHERE ISNULL(ppm.RecordStartDateTime, App.GetFiscalYearStartDate(@SchoolYear)) = ISNULL(mp.ProgramParticipationStartDate, App.GetFiscalYearStartDate(@SchoolYear))
			AND ISNULL(ppm.RecordEndDateTime, App.GetFiscalYearEndDate(@SchoolYear)) = ISNULL(mp.ProgramParticipationExitDate, App.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'ProgramParticipationMigrantId', 'S08EC290' 
		END CATCH


		set nocount off;


END