CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP16_StaffAssignment_EncapsulatedCode]
	@SchoolYear SMALLINT = NULL
	AS
   /*************************************************************************************************************
    Created by:    Nathan Clinton | nathan.clinton@aemcorp.com | CIID (https://ciidta.grads360.org/#program)
    Date Created:  6/28/2018

    Purpose:
        The purpose of this ETL is to maintain the unique list of Student Identifiers assigned by the state
		in the ODS.

    Assumptions:
        

    Account executed under: LOGIN

    Approximate run time:  ~ 5 seconds

    Data Sources:  Data Warehouse: db_ECSUID.dbo.ECSUID

    Data Targets:  Generate Database:   Generate.ODS.Person
										Generate.ODS.PersonIdentifier

    Return Values:
    	 0	= Success
       All Errors are Thrown via Try/Catch Block	
  
    Example Usage: 
      EXEC App.[Migrate_Data_ETL_IMPLEMENTATION_STEP16_StaffAssignment_EncapsulatedCode] 2018;
    
    Modification Log:
      #	  Date		    Developer	  Issue#	 Description
      --  ----------  ----------  -------  --------------------------------------------------------------------
      01		  	 
    *************************************************************************************************************/
    BEGIN

        SET NOCOUNT ON;
		
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
		DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP16_StaffAssignment_EncapsulatedCode'

        ---------------------------------------------------
        ---------------------------------------------------
		DECLARE @RecordStartDate DATETIME

		SET @RecordStartDate = App.GetFiscalYearEndDate(@SchoolYear)
        ---------------------------------------------------
        ---------------------------------------------------

		BEGIN TRY
			-- Grab the PersonID for all personnel records
			UPDATE Staging.StaffAssignment
			SET PersonId = pid.PersonId
			FROM Staging.StaffAssignment sa
			JOIN ODS.PersonIdentifier pid
				ON sa.Personnel_Identifier_State = pid.Identifier
				AND pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001074')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StaffAssignment', 'PersonId', 'S16EC100' 
		END CATCH

		BEGIN TRY
			-- Grab the LEA OrganizationID for all personnel records
			UPDATE Staging.StaffAssignment
			SET OrganizationId_LEA = oid.OrganizationId
			FROM Staging.StaffAssignment sa
			JOIN ODS.OrganizationIdentifier oid
				ON sa.LEA_Identifier_State = oid.Identifier
				AND oid.RefOrganizationIdentifierTypeId = [App].[GetOrganizationIdentifierTypeId]('001072')
				AND oid.RefOrganizationIdentificationSystemId = [App].[GetOrganizationIdentifierSystemId]('SEA', '001072')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StaffAssignment', 'OrganizationId_LEA', 'S16EC110' 
		END CATCH

		BEGIN TRY
			-- Grab the School OrganizationID for all personnel records
			UPDATE Staging.StaffAssignment
			SET OrganizationId_School = oid.OrganizationId
			FROM Staging.StaffAssignment sa
			JOIN ODS.OrganizationIdentifier oid
				ON sa.School_Identifier_State = oid.Identifier
				AND oid.RefOrganizationIdentifierTypeId = [App].[GetOrganizationIdentifierTypeId]('001073')
				AND oid.RefOrganizationIdentificationSystemId = [App].[GetOrganizationIdentifierSystemId]('SEA', '001073')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StaffAssignment', 'OrganizationId_School', 'S16EC120' 
		END CATCH

-- Create base OrganizationPersonRole to link the personnel to the Organization to which they are assigned

		BEGIN TRY
			--LEA
			INSERT INTO ODS.OrganizationPersonRole 
			SELECT 
				  oid.OrganizationId
				, sa.PersonId
				, r.RoleId
				, sa.AssignmentStartDate
				, sa.AssignmentEndDate
			FROM Staging.StaffAssignment sa
			JOIN ODS.OrganizationIdentifier oid
				ON sa.LEA_Identifier_State = oid.Identifier
				AND oid.RefOrganizationIdentifierTypeId = [App].[GetOrganizationIdentifierTypeId]('001072')
				AND oid.RefOrganizationIdentificationSystemId = [App].[GetOrganizationIdentifierSystemId]('SEA', '001072')
			JOIN ODS.[Role] r
				ON [Name] = 'K12 Personnel'
			LEFT JOIN ODS.OrganizationPersonRole opr
				ON sa.PersonId = opr.PersonId
				AND oid.OrganizationId = opr.OrganizationId
				AND r.RoleId = opr.RoleId
				AND sa.AssignmentStartDate = opr.EntryDate
			WHERE opr.OrganizationPersonRoleId IS NULL
			  AND sa.OrganizationID_LEA IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S16EC130' 
		END CATCH

		BEGIN TRY
			--School
			INSERT INTO ODS.OrganizationPersonRole 
			SELECT 
				  oid.OrganizationId
				, sa.PersonId
				, r.RoleId
				, sa.AssignmentStartDate
				, sa.AssignmentEndDate
			FROM Staging.StaffAssignment sa
			JOIN ODS.OrganizationIdentifier oid
				ON sa.School_Identifier_State = oid.Identifier
				AND oid.RefOrganizationIdentifierTypeId = [App].[GetOrganizationIdentifierTypeId]('001073')
				AND oid.RefOrganizationIdentificationSystemId = [App].[GetOrganizationIdentifierSystemId]('SEA', '001073')
			JOIN ODS.[Role] r
				ON [Name] = 'K12 Personnel'
			LEFT JOIN ODS.OrganizationPersonRole opr
				ON sa.PersonId = opr.PersonId
				AND oid.OrganizationId = opr.OrganizationId
				AND r.RoleId = opr.RoleId
				AND sa.AssignmentStartDate = opr.EntryDate
			WHERE opr.OrganizationPersonRoleId IS NULL
			  AND sa.OrganizationID_School IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S16EC140' 
		END CATCH

-- Update School Assignment End Dates as necessary
		BEGIN TRY
			--LEA
			UPDATE ODS.OrganizationPersonRole
			SET ExitDate = sa.AssignmentEndDate
			FROM Staging.StaffAssignment sa
			JOIN ODS.[Role] r
				ON [Name] = 'K12 Personnel'
			JOIN ODS.OrganizationPersonRole opr
				ON sa.OrganizationId_LEA = opr.OrganizationId
				AND sa.PersonId = opr.PersonId
				AND sa.AssignmentStartDate = opr.EntryDate
				AND opr.ExitDate IS NULL
				AND sa.AssignmentEndDate IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', 'ExitDate', 'S16EC150' 
		END CATCH

		BEGIN TRY
			--School	
			UPDATE ODS.OrganizationPersonRole
			SET ExitDate = sa.AssignmentEndDate
			FROM Staging.StaffAssignment sa
			JOIN ODS.[Role] r
				ON [Name] = 'K12 Personnel'
			JOIN ODS.OrganizationPersonRole opr
				ON sa.OrganizationId_School = opr.OrganizationId
				AND sa.PersonId = opr.PersonId
				AND sa.AssignmentStartDate = opr.EntryDate
				AND opr.ExitDate IS NULL
				AND sa.AssignmentEndDate IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', 'ExitDate', 'S16EC160' 
		END CATCH

-- Grab the OrganizationPersonRoleIds for all StaffAssignment records
		BEGIN TRY
			--LEA
			UPDATE Staging.StaffAssignment
			SET OrganizationPersonRoleId_LEA = opr.OrganizationPersonRoleId
			FROM Staging.StaffAssignment sa
			LEFT JOIN ODS.OrganizationRelationship orl
				ON orl.OrganizationId = sa.OrganizationID_LEA
			JOIN ODS.OrganizationPersonRole opr
				ON sa.OrganizationId_LEA = opr.OrganizationId
				AND sa.PersonId = opr.PersonId
				AND sa.AssignmentStartDate = opr.EntryDate
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StaffAssignment', 'OrganizationPersonRoleId_LEA', 'S16EC170' 
		END CATCH

		BEGIN TRY
			--School
			UPDATE Staging.StaffAssignment
			SET OrganizationPersonRoleId_School = opr.OrganizationPersonRoleId
			FROM Staging.StaffAssignment sa
			LEFT JOIN ODS.OrganizationRelationship orl
				ON orl.OrganizationId = sa.OrganizationID_School
			JOIN ODS.OrganizationPersonRole opr
				ON sa.OrganizationId_School = opr.OrganizationId
				AND sa.PersonId = opr.PersonId
				AND sa.AssignmentStartDate = opr.EntryDate
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StaffAssignment', 'OrganizationPersonRoleId_School', 'S16EC180' 
		END CATCH

-- Update existing K12StaffAssignment records
		BEGIN TRY
			--LEA
			UPDATE ODS.K12StaffAssignment
			SET   RefK12StaffClassificationId = sc.RefEducationStaffClassificationId
				, FullTimeEquivalency = sa.FullTimeEquivalency
				, HighlyQualifiedTeacherIndicator = ksa.HighlyQualifiedTeacherIndicator
				, SpecialEducationTeacher = 
					CASE 
						WHEN (sa.K12StaffClassification = 'Teacher' OR sa.K12StaffClassification = 'Substitute Teacher') AND sa.ProgramTypeCode = 'Special Education' THEN 1 
						ELSE 0 
					END
				, RefSpecialEducationStaffCategoryId = sesc.RefSpecialEducationStaffCategoryId
				, RefSpecialEducationAgeGroupTaughtId = seagt.RefSpecialEducationAgeGroupTaughtId
				, RefTitleIProgramStaffCategoryId = tipsc.RefTitleIProgramStaffCategoryId
				, RefUnexperiencedStatusId = unexp.RefUnexperiencedStatusId
				, RefEmergencyOrProvisionalCredentialStatusId = emerg.RefEmergencyOrProvisionalCredentialStatusId
				, RefOutOfFieldStatusId = outoffield.RefOutOfFieldStatusId
				, SpecialEducationRelatedServicesPersonnel = 
					CASE
						WHEN sa.ProgramTypeCode = 'Special Education' THEN 1
						ELSE 0
				   END 
				, RecordEndDateTime = sa.AssignmentEndDate
			FROM Staging.StaffAssignment sa
			LEFT JOIN ODS.SourceSystemReferenceData scss
				ON sa.K12StaffClassification = scss.InputCode
				AND scss.TableName = 'RefK12StaffClassification'
				AND scss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefK12StaffClassification sc
				ON scss.OutputCode = sc.Code
			LEFT JOIN ODS.SourceSystemReferenceData sescss
				ON sa.SpecialEducationStaffCategory = sescss.InputCode
				AND sescss.TableName = 'RefSpecialEducationStaffCategory'
				AND sescss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefSpecialEducationStaffCategory sesc
				ON sescss.OutputCode = sesc.Code
			LEFT JOIN ODS.SourceSystemReferenceData seagtss
				ON sa.SpecialEducationAgeGroupTaught = seagtss.InputCode
				AND seagtss.TableName = 'RefSpecialEducationAgeGroupTaught'
				AND seagtss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefSpecialEducationAgeGroupTaught seagt
				ON seagtss.OutputCode = seagt.Code
			LEFT JOIN ODS.SourceSystemReferenceData tipscss
				ON sa.TitleIProgramStaffCategory = tipscss.InputCode
				AND tipscss.TableName = 'RefTitleIProgramStaffCategory'
				AND tipscss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefTitleIProgramStaffCategory tipsc
				ON tipscss.OutputCode = tipsc.code
			JOIN ODS.K12StaffAssignment ksa
				ON sa.OrganizationPersonRoleId_LEA = ksa.OrganizationPersonRoleId
			-- teacher attributes
			LEFT JOIN ODS.RefUnexperiencedStatus unexp
				ON unexp.Code= sa.InexperiencedStatus
			LEFT JOIN ODS.RefOutOfFieldStatus outoffield
				ON outoffield.Code= sa.OutOfFieldStatus
			LEFT JOIN ODS.RefEmergencyOrProvisionalCredentialStatus emerg
				ON emerg.Code= sa.EmergencyorProvisionalCredentialStatus
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StaffAssignment', NULL, 'S16EC190' 
		END CATCH

		BEGIN TRY
			--School
			UPDATE ODS.K12StaffAssignment
			SET   RefK12StaffClassificationId = sc.RefEducationStaffClassificationId
				, FullTimeEquivalency = sa.FullTimeEquivalency
				, HighlyQualifiedTeacherIndicator = ksa.HighlyQualifiedTeacherIndicator
				, SpecialEducationTeacher = CASE WHEN sc.Code = 'SpecialEducationTeachers' THEN 1 ELSE 0 END
				, RefSpecialEducationStaffCategoryId = sesc.RefSpecialEducationStaffCategoryId
				, RefSpecialEducationAgeGroupTaughtId = seagt.RefSpecialEducationAgeGroupTaughtId
				, RefTitleIProgramStaffCategoryId = tipsc.RefTitleIProgramStaffCategoryId
				, RefUnexperiencedStatusId = unexp.RefUnexperiencedStatusId
				, RefEmergencyOrProvisionalCredentialStatusId = emerg.RefEmergencyOrProvisionalCredentialStatusId
				, RefOutOfFieldStatusId = outoffield.RefOutOfFieldStatusId
				, RecordEndDateTime = sa.AssignmentEndDate
			FROM Staging.StaffAssignment sa
			LEFT JOIN ODS.SourceSystemReferenceData scss
				ON sa.K12StaffClassification = scss.InputCode
				AND scss.TableName = 'RefK12StaffClassification'
				AND scss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefK12StaffClassification sc
				ON scss.OutputCode = sc.Code
			LEFT JOIN ODS.SourceSystemReferenceData sescss
				ON sa.SpecialEducationStaffCategory = sescss.InputCode
				AND sescss.TableName = 'RefSpecialEducationStaffCategory'
				AND sescss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefSpecialEducationStaffCategory sesc
				ON sescss.OutputCode = sesc.Code
			LEFT JOIN ODS.SourceSystemReferenceData seagtss
				ON sa.SpecialEducationAgeGroupTaught = seagtss.InputCode
				AND seagtss.TableName = 'RefSpecialEducationAgeGroupTaught'
				AND seagtss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefSpecialEducationAgeGroupTaught seagt
				ON seagtss.OutputCode = seagt.Code
			LEFT JOIN ODS.SourceSystemReferenceData tipscss
				ON sa.TitleIProgramStaffCategory = tipscss.InputCode
				AND tipscss.TableName = 'RefTitleIProgramStaffCategory'
				AND tipscss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefTitleIProgramStaffCategory tipsc
				ON tipscss.OutputCode = tipsc.code
			JOIN ODS.K12StaffAssignment ksa
				ON sa.OrganizationPersonRoleId_School = ksa.OrganizationPersonRoleId
			-- teacher attributes
			LEFT JOIN ODS.RefUnexperiencedStatus unexp
				ON unexp.Code= sa.InexperiencedStatus
			LEFT JOIN ODS.RefOutOfFieldStatus outoffield
				ON outoffield.Code= sa.OutOfFieldStatus
			LEFT JOIN ODS.RefEmergencyOrProvisionalCredentialStatus emerg
				ON emerg.Code= sa.EmergencyorProvisionalCredentialStatus
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StaffAssignment', NULL, 'S16EC200' 
		END CATCH

-- Create new K12StaffAssignment records 

		BEGIN TRY
			--LEA
			INSERT INTO ODS.K12StaffAssignment
			SELECT 
				  sa.OrganizationPersonRoleId_LEA
				, sc.RefEducationStaffClassificationId
				, NULL
				, NULL
				, NULL
				, NULL
				, NULL
				, sa.FullTimeEquivalency
				, NULL
				, NULL
				, sa.HighlyQualifiedTeacherIndicator
				, CASE WHEN sc.Code = 'SpecialEducationTeachers' THEN 1 ELSE 0 END
				, sesc.RefSpecialEducationStaffCategoryId
				, NULL
				, NULL
				, seagt.RefSpecialEducationAgeGroupTaughtId
				, NULL
				, tipsc.RefTitleIProgramStaffCategoryId
				, sa.AssignmentStartDate
				, sa.AssignmentEndDate
				, unexp.RefUnexperiencedStatusId									RefUnexperiencedStatusId
				, emerg.RefEmergencyOrProvisionalCredentialStatusId					RefEmergencyOrProvisionalCredentialStatusId
				, outoffield.RefOutOfFieldStatusId									RefOutOfFieldStatusId
			FROM Staging.StaffAssignment sa
			LEFT JOIN ODS.SourceSystemReferenceData scss
				ON sa.K12StaffClassification = scss.InputCode
				AND scss.TableName = 'RefK12StaffClassification'
				AND scss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefK12StaffClassification sc
				ON scss.OutputCode = sc.Code
			LEFT JOIN ODS.SourceSystemReferenceData sescss
				ON sa.SpecialEducationStaffCategory = sescss.InputCode
				AND sescss.TableName = 'RefSpecialEducationStaffCategory'
				AND sescss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefSpecialEducationStaffCategory sesc
				ON sescss.OutputCode = sesc.Code
			LEFT JOIN ODS.SourceSystemReferenceData seagtss
				ON sa.SpecialEducationAgeGroupTaught = seagtss.InputCode
				AND seagtss.TableName = 'RefSpecialEducationAgeGroupTaught'
				AND seagtss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefSpecialEducationAgeGroupTaught seagt
				ON seagtss.OutputCode = seagt.Code
			LEFT JOIN ODS.SourceSystemReferenceData tipscss
				ON sa.TitleIProgramStaffCategory = tipscss.InputCode
				AND tipscss.TableName = 'RefTitleIProgramStaffCategory'
				AND tipscss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefTitleIProgramStaffCategory tipsc
				ON tipscss.OutputCode = tipsc.code
			LEFT JOIN ODS.K12StaffAssignment ksa
				ON sa.OrganizationPersonRoleId_LEA = ksa.OrganizationPersonRoleId
			-- teacher attributes
			LEFT JOIN ODS.RefUnexperiencedStatus unexp
				ON unexp.Code= sa.InexperiencedStatus
			LEFT JOIN ODS.RefOutOfFieldStatus outoffield
				ON outoffield.Code= sa.OutOfFieldStatus
			LEFT JOIN ODS.RefEmergencyOrProvisionalCredentialStatus emerg
				ON emerg.Code= sa.EmergencyorProvisionalCredentialStatus
			WHERE ksa.K12StaffAssignmentId IS NULL
				AND sa.OrganizationPersonRoleId_LEA is NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StaffAssignment', NULL, 'S16EC210' 
		END CATCH

		BEGIN TRY
			--School
			INSERT INTO ODS.K12StaffAssignment
			SELECT 
				  sa.OrganizationPersonRoleId_School							OrganizationPersonRoleId
				, sc.RefEducationStaffClassificationId
				, NULL
				, NULL
				, NULL
				, NULL
				, NULL
				, sa.FullTimeEquivalency
				, NULL
				, NULL
				, sa.HighlyQualifiedTeacherIndicator
				, CASE WHEN sc.Code = 'SpecialEducationTeachers' THEN 1 ELSE 0 END
				, sesc.RefSpecialEducationStaffCategoryId
				, NULL
				, NULL
				, seagt.RefSpecialEducationAgeGroupTaughtId
				, NULL
				, tipsc.RefTitleIProgramStaffCategoryId
				, sa.AssignmentStartDate
				, sa.AssignmentEndDate
				, unexp.RefUnexperiencedStatusId									RefUnexperiencedStatusId
				, emerg.RefEmergencyOrProvisionalCredentialStatusId					RefEmergencyOrProvisionalCredentialStatusId
				, outoffield.RefOutOfFieldStatusId									RefOutOfFieldStatusId
			FROM Staging.StaffAssignment sa
			LEFT JOIN ODS.SourceSystemReferenceData scss
				ON sa.K12StaffClassification = scss.InputCode
				AND scss.TableName = 'RefK12StaffClassification'
				AND scss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefK12StaffClassification sc
				ON scss.OutputCode = sc.Code
			LEFT JOIN ODS.SourceSystemReferenceData sescss
				ON sa.SpecialEducationStaffCategory = sescss.InputCode
				AND sescss.TableName = 'RefSpecialEducationStaffCategory'
				AND sescss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefSpecialEducationStaffCategory sesc
				ON sescss.OutputCode = sesc.Code
			LEFT JOIN ODS.SourceSystemReferenceData seagtss
				ON sa.SpecialEducationAgeGroupTaught = seagtss.InputCode
				AND seagtss.TableName = 'RefSpecialEducationAgeGroupTaught'
				AND seagtss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefSpecialEducationAgeGroupTaught seagt
				ON seagtss.OutputCode = seagt.Code
			LEFT JOIN ODS.SourceSystemReferenceData tipscss
				ON sa.TitleIProgramStaffCategory = tipscss.InputCode
				AND tipscss.TableName = 'RefTitleIProgramStaffCategory'
				AND tipscss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefTitleIProgramStaffCategory tipsc
				ON tipscss.OutputCode = tipsc.Code
			LEFT JOIN ODS.K12StaffAssignment ksa
				ON sa.OrganizationPersonRoleId_School = ksa.OrganizationPersonRoleId
			-- teacher attributes
			LEFT JOIN ODS.RefUnexperiencedStatus unexp
				ON unexp.Code= sa.InexperiencedStatus
			LEFT JOIN ODS.RefOutOfFieldStatus outoffield
				ON outoffield.Code= sa.OutOfFieldStatus
			LEFT JOIN ODS.RefEmergencyOrProvisionalCredentialStatus emerg
				ON emerg.Code= sa.EmergencyorProvisionalCredentialStatus
			WHERE ksa.K12StaffAssignmentId IS NULL
				AND sa.OrganizationPersonRoleId_School is NOT NULL
		END TRY

		BEGIN CATCH 
		
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StaffAssignment', NULL, 'S16EC220' 
		END CATCH
		/*
			EXEC App.[Migrate_Data_ETL_IMPLEMENTATION_STEP16_StaffAssignment_EncapsulatedCode] 2018;
		*/
		
		BEGIN TRY
			-- Create missing PersonCredential records
			INSERT INTO ODS.PersonCredential
			SELECT 
				  sa.PersonId
				, NULL
				, ct.RefCredentialTypeId
				, sa.CredentialIssuanceDate
				, sa.CredentialExpirationDate
				, NULL
				, NULL
				, NULL
			FROM Staging.StaffAssignment sa
			LEFT JOIN ODS.SourceSystemReferenceData ctss
				ON sa.CredentialType = ctss.InputCode
				AND ctss.TableName = 'RefCredentialType'
				AND ctss.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefCredentialType ct
				ON ctss.OutputCode = ct.Code
			LEFT JOIN ods.PersonCredential pc
				ON sa.PersonId = pc.PersonId
			WHERE pc.PersonCredentialId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonCredential', NULL, 'S16EC230' 
		END CATCH

		BEGIN TRY
			-- Create missing StaffCredential records
			INSERT INTO ODS.StaffCredential
			SELECT
				  NULL
				, NULL
				, NULL
				, pq.RefParaprofessionalQualificationId
				, NULL
				, NULL
				, NULL
				, NULL
				, pc.PersonCredentialId
				, sa.CredentialIssuanceDate
				, sa.CredentialExpirationDate
			FROM Staging.StaffAssignment sa
			JOIN ODS.PersonCredential pc
				ON sa.PersonId = pc.PersonId
			JOIN ODS.RefParaprofessionalQualification pq
				ON sa.ParaprofessionalQualification = pq.Code
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.StaffCredential', NULL, 'S16EC240' 
		END CATCH

		SET NOCOUNT OFF;
  END