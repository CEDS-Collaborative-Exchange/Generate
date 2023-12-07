CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_Migrant]
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
      EXEC Staging.[Migrate_StagingToIDS_Migrant];
    
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
		DECLARE @eStoredProc			varchar(100) = 'Migrate_StagingToIDS_Migrant'

		--------------------------------------------------------
		---Associate the PersonId with the temporary tables ----
		--------------------------------------------------------

		BEGIN TRY
			--Staging.Migrant
			UPDATE Staging.Migrant
			SET PersonID = pid.PersonId
			FROM Staging.Migrant mcc
			JOIN dbo.PersonIdentifier pid 
				ON mcc.Student_Identifier_State = pid.Identifier
			WHERE pid.RefPersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001075')
			AND pid.RefPersonalInformationVerificationId = Staging.GetRefPersonalInformationVerificationId('01011') 
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'PersonID', 'S08EC100' 
		END CATCH

		------------------------------------------------------------------
		---Associate the LEA OrganizationId with the temporary tables ----
		------------------------------------------------------------------

		BEGIN TRY
			--Staging.Migrant
			UPDATE Staging.Migrant
			SET OrganizationID_LEA = orgid.OrganizationId
			FROM Staging.Migrant mcc
			JOIN dbo.OrganizationIdentifier orgid 
				ON mcc.School_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = Staging.GetOrganizationIdentifierTypeId('001072')
			AND orgid.RefOrganizationIdentificationSystemId = Staging.GetOrganizationIdentifierSystemId('SEA', '001072')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'OrganizationID_LEA', 'S08EC110' 
		END CATCH

		---------------------------------------------------------------------
		---Associate the School OrganizationId with the temporary tables ----
		---------------------------------------------------------------------
		
		BEGIN TRY
			--Staging.Migrant
			UPDATE Staging.Migrant
			SET OrganizationID_School = orgid.OrganizationId
			FROM Staging.Migrant mcc
			JOIN dbo.OrganizationIdentifier orgid 
				ON mcc.School_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = Staging.GetOrganizationIdentifierTypeId('001073')
			AND orgid.RefOrganizationIdentificationSystemId = Staging.GetOrganizationIdentifierSystemId('SEA', '001073')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'OrganizationID_School', 'S08EC120' 
		END CATCH


		------------------------------------------------------------------------------
		---Associate the LEA Migrant Program OrganizationId with the temporary tables ----
		------------------------------------------------------------------------------

		BEGIN TRY
			--Staging.Migrant
			UPDATE Staging.Migrant
			SET LEAOrganizationID_MigrantProgram = orgd.OrganizationId
			FROM Staging.Migrant tp
			JOIN dbo.OrganizationRelationship orgr 
				ON tp.OrganizationID_LEA = orgr.Parent_OrganizationId
			JOIN dbo.OrganizationDetail orgd 
				ON orgr.OrganizationId = orgd.OrganizationId
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgd.OrganizationId = orgpt.OrganizationId
			JOIN dbo.RefProgramType rpt 
				ON orgpt.RefProgramTypeId = rpt.RefProgramTypeId
			LEFT JOIN dbo.OrganizationRelationship orl
				ON orl.OrganizationId = tp.OrganizationID_School
			WHERE orgd.Name = 'Migrant Program'
				AND rpt.Code = '04920'
				AND (orl.Parent_OrganizationId <> tp.OrganizationID_LEA 
					or tp.OrganizationID_School IS NULL)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'LEAOrganizationID_MigrantProgram', 'S08EC130' 
		END CATCH


		-------------------------------------------------------------------------------------
		---Associate the School Migrant Program OrganizationId with the temporary tables ----
		-------------------------------------------------------------------------------------

		BEGIN TRY
		--Staging.Migrant
		UPDATE Staging.Migrant
			SET SchoolOrganizationID_MigrantProgram = orgd.OrganizationId
			FROM Staging.Migrant tp
			JOIN dbo.OrganizationRelationship orgr 
				ON tp.OrganizationID_School = orgr.Parent_OrganizationId
			JOIN dbo.OrganizationDetail orgd 
				ON orgr.OrganizationId = orgd.OrganizationId
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgd.OrganizationId = orgpt.OrganizationId
			JOIN dbo.RefProgramType rpt 
				ON orgpt.RefProgramTypeId = rpt.RefProgramTypeId
			WHERE orgd.Name = 'Migrant Program'
				AND rpt.Code = '04920'
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'SchoolOrganizationID_MigrantProgram', 'S08EC140' 
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
			JOIN dbo.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
			WHERE tp.LEAOrganizationID_MigrantProgram = opr.OrganizationId
			AND opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = ISNULL(tp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear))
			AND (opr.ExitDate IS NULL OR opr.ExitDate = ISNULL(tp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear)))
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'LEAOrganizationPersonRoleID_MigrantProgram', 'S08EC150' 
		END CATCH

		BEGIN TRY
			--School
			UPDATE Staging.Migrant
			SET SchoolOrganizationPersonRoleID_MigrantProgram = opr.OrganizationPersonRoleId
			FROM Staging.Migrant tp
			JOIN dbo.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
			WHERE tp.SchoolOrganizationID_MigrantProgram = opr.OrganizationId
			AND opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = ISNULL(tp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear))
			AND (opr.ExitDate IS NULL OR opr.ExitDate = ISNULL(tp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear)))
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'SchoolOrganizationPersonRoleID_MigrantProgram', 'S08EC160' 
		END CATCH

		BEGIN TRY
			--Create an OrganizationPersonRole (Enrollment) into the Migrant Program if the ProgramParticipationStartDate and ProgramParticipationEndDates are supplied
			--LEA
			INSERT INTO [dbo].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				tp.LEAOrganizationID_MigrantProgram [OrganizationId]
			   ,tp.PersonID [PersonId]
			   ,Staging.GetRoleId('K12 Student') [RoleId]
			   ,ISNULL(tp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear)) [EntryDate]
			   ,ISNULL(tp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear)) [ExitDate] 
			FROM Staging.Migrant tp
			WHERE tp.LEAOrganizationPersonRoleID_MigrantProgram IS NULL
			AND tp.LEAOrganizationID_MigrantProgram IS NOT NULL
			AND tp.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S08EC170' 
		END CATCH


		BEGIN TRY
			--School
			INSERT INTO [dbo].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				tp.SchoolOrganizationID_MigrantProgram [OrganizationId]
			   ,tp.PersonID [PersonId]
			   ,Staging.GetRoleId('K12 Student') [RoleId]
			   ,ISNULL(tp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear)) [EntryDate]
			   ,ISNULL(tp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear)) [ExitDate] 
			FROM Staging.Migrant tp
			WHERE tp.SchoolOrganizationPersonRoleID_MigrantProgram IS NULL
			AND tp.SchoolOrganizationID_MigrantProgram IS NOT NULL
			AND tp.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S08EC180' 
		END CATCH

		--Update the temporary table with the Migrant Program OrganizationPersonRoleId

		BEGIN TRY
			--Staging.Migrant
			--LEA
			UPDATE Staging.Migrant
			SET LEAOrganizationPersonRoleID_MigrantProgram = opr.OrganizationPersonRoleId
			FROM Staging.Migrant tp
			JOIN dbo.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
			WHERE tp.LEAOrganizationID_MigrantProgram = opr.OrganizationId
			AND opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = ISNULL(tp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear))
			AND opr.ExitDate = ISNULL(tp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'LEAOrganizationPersonRoleID_MigrantProgram', 'S08EC190' 
		END CATCH

		BEGIN TRY
			--School
			UPDATE Staging.Migrant
			SET SchoolOrganizationPersonRoleID_MigrantProgram = opr.OrganizationPersonRoleId
			FROM Staging.Migrant tp
			JOIN dbo.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
			WHERE tp.SchoolOrganizationID_MigrantProgram = opr.OrganizationId
			AND opr.RoleId = Staging.GetRoleId('K12 Student')
			AND opr.EntryDate = ISNULL(tp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear))
			AND opr.ExitDate = ISNULL(tp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'SchoolOrganizationPersonRoleID_MigrantProgram', 'S08EC200' 
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
			JOIN dbo.PersonProgramParticipation ppp 
				ON tp.LEAOrganizationPersonRoleID_MigrantProgram = ppp.OrganizationPersonRoleId
			WHERE ppp.RecordStartDateTime = ISNULL(tp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear))
			AND ppp.RecordEndDateTime = ISNULL(tp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'PersonProgramParticipationId', 'S08EC210' 
		END CATCH

		BEGIN TRY
			--School
			UPDATE Staging.Migrant
			SET PersonProgramParticipationId = ppp.PersonProgramParticipationId
			FROM Staging.Migrant tp
			JOIN dbo.PersonProgramParticipation ppp 
				ON tp.SchoolOrganizationPersonRoleID_MigrantProgram = ppp.OrganizationPersonRoleId
			WHERE ppp.RecordStartDateTime = ISNULL(tp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear))
			AND ppp.RecordEndDateTime = ISNULL(tp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'PersonProgramParticipationId', 'S08EC220' 
		END CATCH

		--Create a PersonProgramParticipation for each OrganizationPersonRole
		
		DECLARE @refParticipationTypeId INT
		SELECT  @refParticipationTypeId = RefParticipationTypeId 
		FROM dbo.RefParticipationType WHERE Code = 'MEPParticipation'

		BEGIN TRY
			--Staging.Migrant
			--LEA	
			INSERT INTO [dbo].[PersonProgramParticipation]
			   ([OrganizationPersonRoleId]
			   ,[RefParticipationTypeId]
			   ,[RefProgramExitReasonId]
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime])
			SELECT DISTINCT
				tp.LEAOrganizationPersonRoleID_MigrantProgram		[OrganizationPersonRoleId]
			   ,@refParticipationTypeId								[RefParticipationTypeId]
			   ,NULL												[RefProgramExitReasonId]
			   ,ISNULL(tp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear)) [RecordStartDateTime]
			   ,ISNULL(tp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear)) [RecordEndDateTime]
			FROM Staging.Migrant tp
			WHERE tp.PersonProgramParticipationId IS NULL
			AND tp.LEAOrganizationPersonRoleID_MigrantProgram IS NOT NULL
			AND tp.ProgramParticipationStartDate IS NOT NULL


			-- Add as LEA oraganizationId for the generate purpose. May need change later
			-- Use OrganizationPersonRoleId with LEA organization Id becasue the generate's migrate procedures uses this Id - OrganizationPersonRoleId
			INSERT INTO [dbo].[PersonProgramParticipation]
			   ([OrganizationPersonRoleId]
			   ,[RefParticipationTypeId]
			   ,[RefProgramExitReasonId]
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime])
			SELECT DISTINCT
				leaop.OrganizationPersonRoleId
				,@refParticipationTypeId								[RefParticipationTypeId]
			   ,NULL												[RefProgramExitReasonId]
			   ,ISNULL(tp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear)) [RecordStartDateTime]
			   ,ISNULL(tp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear)) [RecordEndDateTime]
			FROM Staging.Migrant tp
			join dbo.OrganizationPersonRole op 
				on op.OrganizationPersonRoleId = tp.LEAOrganizationPersonRoleID_MigrantProgram
			join dbo.OrganizationRelationship ors 
				on ors.OrganizationId = op.OrganizationId
			join dbo.OrganizationPersonRole leaop 
				on leaop.OrganizationId = ors.Parent_OrganizationId 
				and leaop.PersonId = op.PersonId
			WHERE  tp.LEAOrganizationPersonRoleID_MigrantProgram IS NOT NULL
			AND tp.ProgramParticipationStartDate IS NOT NULL

		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S08EC230' 
		END CATCH

		BEGIN TRY
			--School	
			INSERT INTO [dbo].[PersonProgramParticipation]
			   ([OrganizationPersonRoleId]
			   ,[RefParticipationTypeId]
			   ,[RefProgramExitReasonId]
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime])
			SELECT DISTINCT
				tp.SchoolOrganizationPersonRoleID_MigrantProgram [OrganizationPersonRoleId]
			   ,@refParticipationTypeId [RefParticipationTypeId]
			   ,NULL [RefProgramExitReasonId]
			   ,ISNULL(tp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear)) [RecordStartDateTime]
			   ,ISNULL(tp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear)) [RecordEndDateTime]
			FROM Staging.Migrant tp
			WHERE tp.PersonProgramParticipationId IS NULL
			AND tp.SchoolOrganizationPersonRoleID_MigrantProgram IS NOT NULL
			AND tp.ProgramParticipationStartDate IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S08EC240' 
		END CATCH

		--Update the temporary table with the Migrant Program PersonProgramParticipationId--

		BEGIN TRY
			--Staging.Migrant
			--LEA
			UPDATE Staging.Migrant
			SET PersonProgramParticipationId = ppp.PersonProgramParticipationId
			FROM Staging.Migrant tp
			JOIN dbo.PersonProgramParticipation ppp 
				ON tp.LEAOrganizationPersonRoleID_MigrantProgram = ppp.OrganizationPersonRoleId
			WHERE ppp.RecordStartDateTime = ISNULL(tp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear))
			AND ppp.RecordEndDateTime = ISNULL(tp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'PersonProgramParticipationId', 'S08EC250' 
		END CATCH

		BEGIN TRY
			--School
			UPDATE Staging.Migrant
			SET PersonProgramParticipationId = ppp.PersonProgramParticipationId
			FROM Staging.Migrant tp
			JOIN dbo.PersonProgramParticipation ppp 
				ON tp.SchoolOrganizationPersonRoleID_MigrantProgram = ppp.OrganizationPersonRoleId
			WHERE ppp.RecordStartDateTime = ISNULL(tp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear))
			AND ppp.RecordEndDateTime = ISNULL(tp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'PersonProgramParticipationId', 'S08EC260' 
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
			JOIN dbo.PersonProgramParticipation pp 
				ON mp.PersonProgramParticipationId = pp.PersonProgramParticipationId
			JOIN dbo.ProgramParticipationMigrant ppm 
				ON pp.PersonProgramParticipationId = ppm.PersonProgramParticipationId
			WHERE ISNULL(ppm.RecordStartDateTime, Staging.GetFiscalYearStartDate(@SchoolYear)) = ISNULL(mp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear))
			AND ISNULL(ppm.RecordEndDateTime, Staging.GetFiscalYearEndDate(@SchoolYear)) = ISNULL(mp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'ProgramParticipationMigrantId', 'S08EC270' 
		END CATCH

		BEGIN TRY
			--Staging.Migrant
			INSERT INTO [dbo].[ProgramParticipationMigrant]
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
					   ,ISNULL(ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear)) [RecordStartDateTime]
					   ,ISNULL(ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear)) [RecordEndDateTime]
					   ,MigrantPrioritizedForServices [PrioritizedForServices]
			FROM Staging.Migrant mp
			JOIN Staging.SourceSystemReferenceData mepservice 
				ON mp.MigrantEducationProgramServicesType = mepservice.InputCode
				AND mepservice.TableName = 'RefMepServiceType'
				AND mepservice.SchoolYear = @SchoolYear
			JOIN dbo.RefMepServiceType mepst 
				ON mepservice.OutputCode = mepst.Code
			LEFT JOIN Staging.SourceSystemReferenceData mepenrollment 
				ON mp.MigrantEducationProgramEnrollmentType = mepenrollment.InputCode
				AND mepenrollment.TableName = 'RefMepEnrollmentType'
				AND mepenrollment.SchoolYear = @SchoolYear
			LEFT JOIN dbo.RefMepEnrollmentType mepe 
				ON mepenrollment.OutputCode = mepe.Code
			LEFT JOIN Staging.SourceSystemReferenceData ContinuationOfServices
				ON mp.ContinuationOfServicesReason = ContinuationOfServices.InputCode
				AND ContinuationOfServices.TableName = 'RefContinuationOfServices'
				AND ContinuationOfServices.SchoolYear = @SchoolYear
			LEFT JOIN dbo.RefContinuationOfServices conser 
				ON ContinuationOfServices.OutputCode = conser.Code
			WHERE mp.PersonProgramParticipationId IS NOT NULL
			AND mp.ProgramParticipationMigrantId IS NULL

			--Add PersonProgramParticipationId with LEA organization Id becasue the generate's migrate procedures uses this Id - PersonProgramParticipationId
			INSERT INTO [dbo].[ProgramParticipationMigrant]
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
					   ,ISNULL(ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear)) [RecordStartDateTime]
					   ,ISNULL(ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear)) [RecordEndDateTime]
					   ,MigrantPrioritizedForServices [PrioritizedForServices]
			FROM Staging.Migrant mp
			join dbo.OrganizationPersonRole opr
				on opr.PersonId = mp.PersonID and opr.OrganizationId = mp.OrganizationID_LEA
			JOIN dbo.PersonProgramParticipation ppp 
				ON opr.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
			JOIN Staging.SourceSystemReferenceData mepservice 
				ON mp.MigrantEducationProgramServicesType = mepservice.InputCode
				AND mepservice.TableName = 'RefMepServiceType'
				AND mepservice.SchoolYear = @SchoolYear
			JOIN dbo.RefMepServiceType mepst 
				ON mepservice.OutputCode = mepst.Code
			LEFT JOIN Staging.SourceSystemReferenceData mepenrollment 
				ON mp.MigrantEducationProgramEnrollmentType = mepenrollment.InputCode
				AND mepenrollment.TableName = 'RefMepEnrollmentType'
				AND mepenrollment.SchoolYear = @SchoolYear
			LEFT JOIN dbo.RefMepEnrollmentType mepe 
				ON mepenrollment.OutputCode = mepe.Code
			LEFT JOIN Staging.SourceSystemReferenceData ContinuationOfServices
				ON mp.ContinuationOfServicesReason = ContinuationOfServices.InputCode
				AND ContinuationOfServices.TableName = 'RefContinuationOfServices'
				AND ContinuationOfServices.SchoolYear = @SchoolYear
			LEFT JOIN dbo.RefContinuationOfServices conser 
				ON ContinuationOfServices.OutputCode = conser.Code
			WHERE mp.PersonProgramParticipationId IS NOT NULL

		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationMigrant', NULL, 'S08EC280' 
		END CATCH

		BEGIN TRY
			--Update ProgramParticipationMigrantId in the staging table--
			UPDATE Staging.Migrant
			SET ProgramParticipationMigrantId = ppm.ProgramParticipationMigrantId
			FROM Staging.Migrant mp
			JOIN dbo.PersonProgramParticipation pp 
				ON mp.PersonProgramParticipationId = pp.PersonProgramParticipationId
			JOIN dbo.ProgramParticipationMigrant ppm 
				ON pp.PersonProgramParticipationId = ppm.PersonProgramParticipationId
			WHERE ISNULL(ppm.RecordStartDateTime, Staging.GetFiscalYearStartDate(@SchoolYear)) = 
			ISNULL(mp.ProgramParticipationStartDate, Staging.GetFiscalYearStartDate(@SchoolYear))
			AND ISNULL(ppm.RecordEndDateTime, Staging.GetFiscalYearEndDate(@SchoolYear)) = 
			ISNULL(mp.ProgramParticipationExitDate, Staging.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Migrant', 'ProgramParticipationMigrantId', 'S08EC290' 
		END CATCH


		set nocount off;


END