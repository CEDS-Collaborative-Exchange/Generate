CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_K12StaffAssignment]
@SchoolYear SMALLINT = NULL
AS
/*************************************************************************************************************
Created by:    Nathan Clinton | nathan.clinton@aemcorp.com | CIID (https://ciidta.grads360.org/#program)
Date Created:  6/28/2018

Purpose:
    The purpose of this ETL is to migrate the person and staff specific data to the IDS.

Assumptions:
        

Account executed under: LOGIN

Stagingroximate run time:  ~ 5 seconds

Data Sources:  Data Warehouse: db_ECSUID.dbo.ECSUID

Data Targets:  Generate Database:   Generate.dbo.Person
									Generate.dbo.PersonDetail
									Generate.dbo.PersonIdentifier
									Generate.dbo.K12StaffAssignment
									Generate.dbo.PersonCredential
									Generate.dbo.StaffCredential
Return Values:
    	0	= Success
    All Errors are Thrown via Try/Catch Block	
  
Example Usage: 
    EXEC Staging.[Migrate_StagingToIDS_K12StaffAssignment] 2018;
    
Modification Log:
    #	  Date		    Developer	  Issue#	 Description
    --  ----------  ----------  -------  --------------------------------------------------------------------
    01		  	 
*************************************************************************************************************/
BEGIN

    SET NOCOUNT ON;
		
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
	DECLARE @eStoredProc varchar(100) = 'Migrate_StagingToIDS_K12StaffAssignment'

    ---------------------------------------------------
    --- Declare Common Variables        
    ---------------------------------------------------
	DECLARE @RecordStartDate DATETIME
	SET @RecordStartDate = Staging.GetFiscalYearEndDate(@SchoolYear)

	--------------------------------------------------------------
    --- Update DataCollectionId in Staging.K12StaffAssignment
    --------------------------------------------------------------
	BEGIN TRY

		UPDATE sa
		SET sa.DataCollectionId = dc.DataCollectionId
		FROM Staging.K12StaffAssignment sa
		JOIN dbo.DataCollection dc
			ON sa.DataCollectionName = dc.DataCollectionName

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12StaffAssignment', 'DataCollectionId', 'S16EC100'
	END CATCH

	DECLARE @RefPersonIdentificationSystemId int,@RefPersonalInformationVerificationId int
	SET @RefPersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001074')
	SET @RefPersonalInformationVerificationId = Staging.GetRefPersonalInformationVerificationId('01011')

	BEGIN TRY
		UPDATE Staging.K12StaffAssignment
		SET PersonId = pid.PersonId
		FROM Staging.K12StaffAssignment sa
		JOIN dbo.PersonIdentifier pid
			ON sa.Personnel_Identifier_State = pid.Identifier
			AND ISNULL(pid.DataCollectionId, '') = ISNULL(sa.DataCollectionId, '')
		JOIN dbo.OrganizationPersonRole opr
			ON pid.PersonId = opr.OrganizationId
		JOIN dbo.OrganizationIdentifier oi
			ON opr.OrganizationId = oi.OrganizationId
			AND oi.Identifier = ISNULL(sa.School_Identifier_State, sa.LEA_Identifier_State)
		WHERE pid.RefPersonIdentificationSystemId = @RefPersonIdentificationSystemId
		AND pid.RefPersonalInformationVerificationId = @RefPersonalInformationVerificationId
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12StaffAssignment', 'PersonId', 'S16EC110' 
	END CATCH
		
	--------------------------------------------------------------------
	---Associate the LEA OrganizationId with the staging table
	--------------------------------------------------------------------
	DECLARE @RefOrganizationIdentifierTypeId int,@RefOrganizationIdentificationSystemId int
	SET @RefOrganizationIdentifierTypeId = Staging.GetOrganizationIdentifierTypeId('001072')
	SET @RefOrganizationIdentificationSystemId = Staging.GetOrganizationIdentifierSystemId('SEA', '001072')

	BEGIN TRY
		UPDATE Staging.K12StaffAssignment
		SET OrganizationID_LEA = orgid.OrganizationId
		FROM Staging.K12StaffAssignment sa
		JOIN dbo.OrganizationIdentifier orgid 
			ON sa.LEA_Identifier_State = orgid.Identifier
			AND ISNULL(orgid.DataCollectionId, '') = ISNULL(sa.DataCollectionId, '')   
		WHERE orgid.RefOrganizationIdentifierTypeId = @RefOrganizationIdentifierTypeId
		AND orgid.RefOrganizationIdentificationSystemId = @RefOrganizationIdentificationSystemId
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12StaffAssignment', 'OrganizationID_LEA', 'S16EC120' 
	END CATCH

	--------------------------------------------------------------------
	---Associate the School OrganizationId with the staging table
	--------------------------------------------------------------------

	DECLARE @RefOrganizationIdentifierTypeId_School int,@RefOrganizationIdentificationSystemId_School int
	SET @RefOrganizationIdentifierTypeId_School = Staging.GetOrganizationIdentifierTypeId('001073')
	SET @RefOrganizationIdentificationSystemId_School = Staging.GetOrganizationIdentifierSystemId('SEA', '001073')

	BEGIN TRY
		UPDATE Staging.K12StaffAssignment
		SET OrganizationID_School = orgid.OrganizationId
		FROM Staging.K12StaffAssignment sa
		JOIN dbo.OrganizationIdentifier orgid 
			ON sa.School_Identifier_State = orgid.Identifier
			AND ISNULL(orgid.DataCollectionId, '') = ISNULL(sa.DataCollectionId, '')     
		WHERE orgid.RefOrganizationIdentifierTypeId = @RefOrganizationIdentifierTypeId_School
		AND orgid.RefOrganizationIdentificationSystemId = @RefOrganizationIdentificationSystemId_School
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12StaffAssignment', 'OrganizationID_School', 'S16EC130' 
	END CATCH

    DECLARE
    @staff_person_xwalk TABLE (
		SourceId INT
    , PersonId INT
    );

	BEGIN TRY
		WITH distinctStaff AS (
			SELECT DISTINCT
				Id
				, PersonId
				, DataCollectionId
			FROM Staging.K12StaffAssignment
		)
		MERGE INTO dbo.Person TARGET
		USING distinctStaff AS distinctIDs
			ON TARGET.PersonId = distinctIDs.PersonId
		WHEN NOT MATCHED THEN 
			INSERT ( PersonMasterId
					, DataCollectionId)  
			VALUES ( NULL
					, distinctIDs.DataCollectionid)   
		OUTPUT distinctIds.Id
				, INSERTED.PersonId
		INTO @staff_person_xwalk (SourceId, PersonId);
	END TRY 

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Person', NULL, 'S16EC140' 
	END CATCH

	BEGIN TRY

		UPDATE Staging.K12StaffAssignment
		SET PersonId = xwalk.PersonId
		FROM Staging.K12StaffAssignment sa
		JOIN @staff_person_xwalk xwalk
			ON sa.Id = xwalk.SourceId
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12StaffAssignment', 'PersonId', 'S16EC150' 
	END CATCH

    -------------------------------------------------------------
    --- INSERT PersonIdentifier Records K12 Staff     
    -------------------------------------------------------------
	DECLARE @PersonIdentificationSystemId INT
	DECLARE @PersonalInformationVerificationId INT

	SET @PersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001074' /* Staff Identification System */)
	SET @PersonalInformationVerificationId = Staging.GetRefPersonalInformationVerificationId('01011')

	BEGIN TRY    
		INSERT dbo.PersonIdentifier (
			PersonId
			, Identifier
			, RefPersonIdentificationSystemId
			, RefPersonalInformationVerificationId
			, DataCollectionId
		)
		SELECT DISTINCT
			sa.PersonId
			, sa.Personnel_Identifier_State AS Identifier
			, @PersonIdentificationSystemId AS RefPersonIdentificationSystemId
			, @PersonalInformationVerificationId AS RefPersonalInformationVerificationId
			, sa.DataCollectionId
		FROM Staging.K12StaffAssignment sa
		LEFT JOIN dbo.PersonIdentifier pid
			ON pid.PersonId = sa.PersonId 
			AND pid.Identifier = sa.Personnel_Identifier_State
			AND pid.RefPersonIdentificationSystemId = @PersonIdentificationSystemId
			AND pid.RefPersonalInformationVerificationId = @PersonalInformationVerificationId
			AND ISNULL(pid.DataCollectionId, '') = ISNULL(sa.DataCollectionId, '')
		WHERE pid.PersonId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonIdentifier', NULL, 'S16EC160' 
	END CATCH

    ------------------------------------------------------------
    --- Merge Person Details					        
    ------------------------------------------------------------
	DECLARE @PersonalIdVerificationId INT
	SET @PersonalIdVerificationId = Staging.GetRefPersonalInformationVerificationId('01011')

	BEGIN TRY
		INSERT INTO dbo.PersonDetail (
			[PersonId]
			, [FirstName]
			, [MiddleName]
			, [LastName]
			, [GenerationCode]
			, [RecordStartDateTime]
			, [RecordEndDateTime]
			, [DataCollectionId]
		)
		SELECT 
			sa.PersonId
			, LEFT(sa.FirstName, 35)
			, LEFT(sa.MiddleName, 35)
			, ISNULL(LEFT(sa.LastName, 35),'MISSING') 
			, NULL
			, Staging.GetFiscalYearStartDate(@schoolYear) 
			, NULL
			, sa.DataCollectionId
		FROM Staging.K12StaffAssignment sa
		LEFT JOIN dbo.PersonDetail pd
			ON sa.PersonId = pd.PersonId
			AND ISNULL(sa.DataCollectionId, '') = ISNULL(pd.DataCollectionId, '')
		WHERE pd.PersonId IS NULL
			  
		UPDATE dbo.PersonDetail
		SET RefSexId = s.RefSexId
		FROM Staging.K12StaffAssignment sa
		JOIN dbo.PersonDetail pd
			ON sa.PersonId = pd.PersonId
			AND ISNULL(sa.DataCollectionId, '') = ISNULL(pd.DataCollectionId, '')
		JOIN [Staging].[SourceSystemReferenceData] ref
			ON sa.Sex = ref.InputCode
			AND ref.TableName = 'RefSex'
			AND ref.SchoolYear = @schoolYear
		JOIN dbo.RefSex s
			ON ref.OutputCode = s.Code
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonDetail', NULL, 'S16EC170' 
	END CATCH

	----------------------------------------------------------------------------------------
	---Manage the OrganizationPersonRole Records for each Student to LEA relationship
	----------------------------------------------------------------------------------------
	BEGIN TRY
		INSERT INTO [dbo].[OrganizationPersonRole] (
			[OrganizationId]
			, [PersonId]
			, [RoleId]
			, [EntryDate]
			, [ExitDate]
			, [DataCollectionId]
		)
		SELECT DISTINCT
			sa.OrganizationID_LEA					[OrganizationId]
			, sa.PersonID							[PersonId]
			, Staging.GetRoleId('K12 Personnel')	[RoleId]
			, sa.AssignmentStartDate				[EntryDate]
			, sa.AssignmentEndDate					[ExitDate]
			, sa.DataCollectionId					[DataCollectionId]
		FROM Staging.K12StaffAssignment sa
		LEFT JOIN dbo.OrganizationPersonRole opr 
			ON sa.PersonID = opr.PersonId
			AND ISNULL(sa.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')  
			AND sa.AssignmentStartDate = opr.EntryDate
			AND ISNULL(sa.AssignmentEndDate, '1900-01-01') = ISNULL(opr.ExitDate, '1900-01-01')
			AND sa.OrganizationID_LEA = opr.OrganizationId
			AND opr.RoleId = Staging.GetRoleId('K12 Personnel')
		WHERE opr.PersonId IS NULL
			AND sa.OrganizationID_LEA IS NOT NULL
			AND sa.PersonID IS NOT NULL
			--AND sa.AssignmentStartDate >= Staging.GetFiscalYearStartDate(@schoolYear)
			--AND (sa.AssignmentEndDate IS NULL OR sa.AssignmentEndDate <= Staging.GetFiscalYearEndDate(@schoolYear))
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S16EC180' 
	END CATCH

	BEGIN TRY
		UPDATE Staging.K12StaffAssignment
		SET OrganizationPersonRoleId_LEA = opr.OrganizationPersonRoleId
		FROM Staging.K12StaffAssignment sa
		JOIN dbo.OrganizationPersonRole opr 
			ON  sa.PersonID = opr.PersonId 
			AND ISNULL(sa.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '') 
		WHERE sa.OrganizationID_LEA = opr.OrganizationId
			AND opr.RoleId = Staging.GetRoleId('K12 Personnel')
			AND EntryDate = sa.AssignmentStartDate
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12StaffAssignment', 'OrganizationPersonRoleId_LEA', 'S16EC190' 
	END CATCH

	-------------------------------------------------------------------------------------------
	---Manage the OrganizationPersonRole Records for each Staff to School relationship 
	-------------------------------------------------------------------------------------------

	BEGIN TRY
		INSERT INTO [dbo].[OrganizationPersonRole] (
			[OrganizationId]
			, [PersonId]
			, [RoleId]
			, [EntryDate]
			, [ExitDate]
			, [DataCollectionId]
		)
		SELECT DISTINCT
			sa.OrganizationID_School				[OrganizationId]
			, sa.PersonID							[PersonId]
			, Staging.GetRoleId('K12 Personnel')	[RoleId]
			, sa.AssignmentStartDate				[EntryDate]
			, sa.AssignmentEndDate					[ExitDate]
			, sa.DataCollectionId					[DataCollectionId]
		FROM Staging.K12StaffAssignment sa
		LEFT JOIN dbo.OrganizationPersonRole opr 
			ON  sa.PersonID = opr.PersonId
			AND ISNULL(sa.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')  
			AND sa.AssignmentStartDate = opr.EntryDate
			AND ISNULL(sa.AssignmentEndDate, '1900-01-01') = ISNULL(opr.ExitDate, '1900-01-01')
			AND sa.OrganizationID_School = opr.OrganizationId
			AND opr.RoleId = Staging.GetRoleId('K12 Personnel')
		WHERE opr.PersonId IS NULL
			AND sa.OrganizationID_School IS NOT NULL
			AND sa.PersonID IS NOT NULL
			--AND sa.AssignmentStartDate >= Staging.GetFiscalYearStartDate(@schoolYear)
			--AND (sa.AssignmentEndDate IS NULL OR sa.AssignmentEndDate <= Staging.GetFiscalYearEndDate(@schoolYear))
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S16EC200' 
	END CATCH

	BEGIN TRY
		UPDATE Staging.K12StaffAssignment
		SET OrganizationPersonRoleId_School = opr.OrganizationPersonRoleId
		FROM Staging.K12StaffAssignment sa
		JOIN dbo.OrganizationPersonRole opr 
			ON sa.PersonID = opr.PersonId 
			AND ISNULL(sa.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')  
		WHERE sa.OrganizationID_School = opr.OrganizationId
			AND opr.RoleId = Staging.GetRoleId('K12 Personnel')
			AND EntryDate = sa.AssignmentStartDate
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12StaffAssignment', 'OrganizationPersonRoleId_School', 'S16EC210' 
	END CATCH
		
	------------------------------------------------------------------------------------------------
	---Manage the OrganizationPersonRoleRelationship Records for each School to LEA relationship ---
	------------------------------------------------------------------------------------------------
	DECLARE @NewOrganizationPersonRoleRelationships TABLE (
			Id INT
		, OrganizationPersonRoleRelationshipId INT
	)
				
	BEGIN TRY
		MERGE [dbo].[OrganizationPersonRoleRelationship] AS TARGET
		USING Staging.K12StaffAssignment AS SOURCE
			ON TARGET.OrganizationPersonRoleId = SOURCE.OrganizationPersonRoleId_School
		AND TARGET.OrganizationPersonRoleId_Parent = SOURCE.OrganizationPersonRoleId_Lea
		AND TARGET.RecordStartDateTime = SOURCE.AssignmentStartDate
		WHEN MATCHED THEN UPDATE SET [RecordEndDateTime] = SOURCE.AssignmentEndDate
		WHEN NOT MATCHED 
		AND SOURCE.OrganizationPersonRoleId_School IS NOT NULL
		AND SOURCE.OrganizationPersonRoleId_Lea IS NOT NULL
		THEN INSERT (
			OrganizationPersonRoleId
			, OrganizationPersonRoleId_Parent
			, RecordStartDateTime
			, RecordEndDateTime
		)
		VALUES ( 
			SOURCE.OrganizationPersonRoleId_School
			, SOURCE.OrganizationPersonRoleId_Lea
			, SOURCE.AssignmentStartDate
			, SOURCE.AssignmentEndDate
		)
		OUTPUT 
			SOURCE.Id
			, INSERTED.OrganizationPersonRoleRelationshipId
		INTO @NewOrganizationPersonRoleRelationships;
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRoleRelationship', NULL, 'S16EC212'
	END CATCH


	BEGIN TRY 
		UPDATE enr
		SET OrganizationPersonRoleRelationshipId = noprr.OrganizationPersonRoleRelationshipId
		FROM Staging.K12StaffAssignment enr 
		JOIN @NewOrganizationPersonRoleRelationships noprr
			ON enr.Id = noprr.Id
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Enrollment', 'OrganizationPersonRoleRelationshipId', 'S16EC214' 
	END CATCH

	BEGIN TRY
			UPDATE r SET r.RecordEndDateTime = s.RecordStartDateTime - 1
			FROM dbo.OrganizationPersonRoleRelationship r				
			JOIN (
				SELECT 								  
					OrganizationPersonRoleId
					, OrganizationPersonRoleId_Parent
					, MAX(OrganizationPersonRoleRelationshipId) AS OrganizationPersonRoleRelationshipId
					, MAX(RecordStartDateTime) AS RecordStartDateTime
				FROM dbo.OrganizationPersonRoleRelationship oprr
				WHERE RecordEndDateTime IS NULL 								
				GROUP BY oprr.OrganizationPersonRoleId,oprr.OrganizationPersonRoleId_Parent
			) s ON  r.OrganizationPersonRoleId = s.OrganizationPersonRoleId
				AND r.OrganizationPersonRoleId_Parent = s.OrganizationPersonRoleId
				AND r.OrganizationPersonRoleRelationshipId <> s.OrganizationPersonRoleRelationshipId
				AND r.RecordEndDateTime IS NULL

	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRoleRelationship', NULL, 'S16EC216'
	END CATCH


	-------------------------------------------------------------------------------------------
	---Update existing K12StaffAssignment records
	-------------------------------------------------------------------------------------------
	BEGIN TRY
		--LEA
		UPDATE dbo.K12StaffAssignment
		SET RefK12StaffClassificationId = sc.RefK12StaffClassificationId
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
		FROM Staging.K12StaffAssignment sa
		LEFT JOIN Staging.SourceSystemReferenceData scss
			ON sa.K12StaffClassification = scss.InputCode
			AND scss.TableName = 'RefK12StaffClassification'
			AND scss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefK12StaffClassification sc
			ON scss.OutputCode = sc.Code
		LEFT JOIN Staging.SourceSystemReferenceData sescss
			ON sa.SpecialEducationStaffCategory = sescss.InputCode
			AND sescss.TableName = 'RefSpecialEducationStaffCategory'
			AND sescss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefSpecialEducationStaffCategory sesc
			ON sescss.OutputCode = sesc.Code
		LEFT JOIN Staging.SourceSystemReferenceData seagtss
			ON sa.SpecialEducationAgeGroupTaught = seagtss.InputCode
			AND seagtss.TableName = 'RefSpecialEducationAgeGroupTaught'
			AND seagtss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefSpecialEducationAgeGroupTaught seagt
			ON seagtss.OutputCode = seagt.Code
		LEFT JOIN Staging.SourceSystemReferenceData tipscss
			ON sa.TitleIProgramStaffCategory = tipscss.InputCode
			AND tipscss.TableName = 'RefTitleIProgramStaffCategory'
			AND tipscss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefTitleIProgramStaffCategory tipsc
			ON tipscss.OutputCode = tipsc.code
		JOIN dbo.K12StaffAssignment ksa
			ON sa.OrganizationPersonRoleId_LEA = ksa.OrganizationPersonRoleId
		-- teacher attributes
		LEFT JOIN dbo.RefUnexperiencedStatus unexp
			ON unexp.Code= sa.InexperiencedStatus
		LEFT JOIN dbo.RefOutOfFieldStatus outoffield
			ON outoffield.Code= sa.OutOfFieldStatus
		LEFT JOIN dbo.RefEmergencyOrProvisionalCredentialStatus emerg
			ON emerg.Code= sa.EmergencyorProvisionalCredentialStatus
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StaffAssignment', NULL, 'S16EC220' 
	END CATCH

	BEGIN TRY
		--School
		UPDATE dbo.K12StaffAssignment
		SET RefK12StaffClassificationId = sc.RefK12StaffClassificationId
			, FullTimeEquivalency = sa.FullTimeEquivalency
			, HighlyQualifiedTeacherIndicator = ksa.HighlyQualifiedTeacherIndicator
			, SpecialEducationTeacher = 
				CASE 
					WHEN sc.Code = 'SpecialEducationTeachers' THEN 1 
					ELSE 0 
				END
			, RefSpecialEducationStaffCategoryId = sesc.RefSpecialEducationStaffCategoryId
			, RefSpecialEducationAgeGroupTaughtId = seagt.RefSpecialEducationAgeGroupTaughtId
			, RefTitleIProgramStaffCategoryId = tipsc.RefTitleIProgramStaffCategoryId
			, RefUnexperiencedStatusId = unexp.RefUnexperiencedStatusId
			, RefEmergencyOrProvisionalCredentialStatusId = emerg.RefEmergencyOrProvisionalCredentialStatusId
			, RefOutOfFieldStatusId = outoffield.RefOutOfFieldStatusId
			, RecordEndDateTime = sa.AssignmentEndDate
		FROM Staging.K12StaffAssignment sa
		LEFT JOIN Staging.SourceSystemReferenceData scss
			ON sa.K12StaffClassification = scss.InputCode
			AND scss.TableName = 'RefK12StaffClassification'
			AND scss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefK12StaffClassification sc
			ON scss.OutputCode = sc.Code
		LEFT JOIN Staging.SourceSystemReferenceData sescss
			ON sa.SpecialEducationStaffCategory = sescss.InputCode
			AND sescss.TableName = 'RefSpecialEducationStaffCategory'
			AND sescss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefSpecialEducationStaffCategory sesc
			ON sescss.OutputCode = sesc.Code
		LEFT JOIN Staging.SourceSystemReferenceData seagtss
			ON sa.SpecialEducationAgeGroupTaught = seagtss.InputCode
			AND seagtss.TableName = 'RefSpecialEducationAgeGroupTaught'
			AND seagtss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefSpecialEducationAgeGroupTaught seagt
			ON seagtss.OutputCode = seagt.Code
		LEFT JOIN Staging.SourceSystemReferenceData tipscss
			ON sa.TitleIProgramStaffCategory = tipscss.InputCode
			AND tipscss.TableName = 'RefTitleIProgramStaffCategory'
			AND tipscss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefTitleIProgramStaffCategory tipsc
			ON tipscss.OutputCode = tipsc.code
		JOIN dbo.K12StaffAssignment ksa
			ON sa.OrganizationPersonRoleId_School = ksa.OrganizationPersonRoleId
		-- teacher attributes
		LEFT JOIN dbo.RefUnexperiencedStatus unexp
			ON unexp.Code= sa.InexperiencedStatus
		LEFT JOIN dbo.RefOutOfFieldStatus outoffield
			ON outoffield.Code= sa.OutOfFieldStatus
		LEFT JOIN dbo.RefEmergencyOrProvisionalCredentialStatus emerg
			ON emerg.Code= sa.EmergencyorProvisionalCredentialStatus
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StaffAssignment', NULL, 'S16EC230' 
	END CATCH

	-------------------------------------------------------------------------------------------
	---Create new StaffAssignment records 
	-------------------------------------------------------------------------------------------
	BEGIN TRY
		--LEA
		INSERT INTO dbo.K12StaffAssignment (
			[OrganizationPersonRoleId]
			, [RefK12StaffClassificationId]
			, [FullTimeEquivalency]
			, [HighlyQualifiedTeacherIndicator]
			, [SpecialEducationTeacher]
			, [RefSpecialEducationStaffCategoryId]
			, [RefSpecialEducationAgeGroupTaughtId]
			, [RefTitleIProgramStaffCategoryId]
			, [RecordStartDateTime]
			, [RecordEndDateTime]
			, [RefUnexperiencedStatusId]
			, [RefEmergencyOrProvisionalCredentialStatusId]
			, [RefOutOfFieldStatusId]
		)
		SELECT 
				sa.OrganizationPersonRoleId_LEA
			, sc.RefK12StaffClassificationId
			, sa.FullTimeEquivalency
			, sa.HighlyQualifiedTeacherIndicator
			, CASE WHEN sc.Code = 'SpecialEducationTeachers' THEN 1 ELSE 0 END
			, sesc.RefSpecialEducationStaffCategoryId
			, seagt.RefSpecialEducationAgeGroupTaughtId
			, tipsc.RefTitleIProgramStaffCategoryId
			, sa.AssignmentStartDate
			, sa.AssignmentEndDate
			, unexp.RefUnexperiencedStatusId									
			, emerg.RefEmergencyOrProvisionalCredentialStatusId					
			, outoffield.RefOutOfFieldStatusId									
		FROM Staging.K12StaffAssignment sa
		LEFT JOIN Staging.SourceSystemReferenceData scss
			ON sa.K12StaffClassification = scss.InputCode
			AND scss.TableName = 'RefK12StaffClassification'
			AND scss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefK12StaffClassification sc
			ON scss.OutputCode = sc.Code
		LEFT JOIN Staging.SourceSystemReferenceData sescss
			ON sa.SpecialEducationStaffCategory = sescss.InputCode
			AND sescss.TableName = 'RefSpecialEducationStaffCategory'
			AND sescss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefSpecialEducationStaffCategory sesc
			ON sescss.OutputCode = sesc.Code
		LEFT JOIN Staging.SourceSystemReferenceData seagtss
			ON sa.SpecialEducationAgeGroupTaught = seagtss.InputCode
			AND seagtss.TableName = 'RefSpecialEducationAgeGroupTaught'
			AND seagtss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefSpecialEducationAgeGroupTaught seagt
			ON seagtss.OutputCode = seagt.Code
		LEFT JOIN Staging.SourceSystemReferenceData tipscss
			ON sa.TitleIProgramStaffCategory = tipscss.InputCode
			AND tipscss.TableName = 'RefTitleIProgramStaffCategory'
			AND tipscss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefTitleIProgramStaffCategory tipsc
			ON tipscss.OutputCode = tipsc.code
		LEFT JOIN dbo.K12StaffAssignment ksa
			ON sa.OrganizationPersonRoleId_LEA = ksa.OrganizationPersonRoleId
		-- teacher attributes
		LEFT JOIN dbo.RefUnexperiencedStatus unexp
			ON unexp.Code= sa.InexperiencedStatus
		LEFT JOIN dbo.RefOutOfFieldStatus outoffield
			ON outoffield.Code= sa.OutOfFieldStatus
		LEFT JOIN dbo.RefEmergencyOrProvisionalCredentialStatus emerg
			ON emerg.Code= sa.EmergencyorProvisionalCredentialStatus
		WHERE ksa.K12StaffAssignmentId IS NULL
			AND sa.OrganizationPersonRoleId_LEA is NOT NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StaffAssignment', NULL, 'S16EC240' 
	END CATCH

	BEGIN TRY
		--School
		INSERT INTO dbo.K12StaffAssignment (
			[OrganizationPersonRoleId]
			, [RefK12StaffClassificationId]
			, [FullTimeEquivalency]
			, [HighlyQualifiedTeacherIndicator]
			, [SpecialEducationTeacher]
			, [RefSpecialEducationStaffCategoryId]
			, [RefSpecialEducationAgeGroupTaughtId]
			, [RefTitleIProgramStaffCategoryId]
			, [RecordStartDateTime]
			, [RecordEndDateTime]
			, [RefUnexperiencedStatusId]
			, [RefEmergencyOrProvisionalCredentialStatusId]
			, [RefOutOfFieldStatusId]
		)
		SELECT 
			sa.OrganizationPersonRoleId_School							
			, sc.RefK12StaffClassificationId
			, sa.FullTimeEquivalency
			, sa.HighlyQualifiedTeacherIndicator
			, CASE WHEN sc.Code = 'SpecialEducationTeachers' THEN 1 ELSE 0 END
			, sesc.RefSpecialEducationStaffCategoryId
			, seagt.RefSpecialEducationAgeGroupTaughtId
			, tipsc.RefTitleIProgramStaffCategoryId
			, sa.AssignmentStartDate
			, sa.AssignmentEndDate
			, unexp.RefUnexperiencedStatusId									
			, emerg.RefEmergencyOrProvisionalCredentialStatusId					
			, outoffield.RefOutOfFieldStatusId									
		FROM Staging.K12StaffAssignment sa
		LEFT JOIN Staging.SourceSystemReferenceData scss
			ON sa.K12StaffClassification = scss.InputCode
			AND scss.TableName = 'RefK12StaffClassification'
			AND scss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefK12StaffClassification sc
			ON scss.OutputCode = sc.Code
		LEFT JOIN Staging.SourceSystemReferenceData sescss
			ON sa.SpecialEducationStaffCategory = sescss.InputCode
			AND sescss.TableName = 'RefSpecialEducationStaffCategory'
			AND sescss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefSpecialEducationStaffCategory sesc
			ON sescss.OutputCode = sesc.Code
		LEFT JOIN Staging.SourceSystemReferenceData seagtss
			ON sa.SpecialEducationAgeGroupTaught = seagtss.InputCode
			AND seagtss.TableName = 'RefSpecialEducationAgeGroupTaught'
			AND seagtss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefSpecialEducationAgeGroupTaught seagt
			ON seagtss.OutputCode = seagt.Code
		LEFT JOIN Staging.SourceSystemReferenceData tipscss
			ON sa.TitleIProgramStaffCategory = tipscss.InputCode
			AND tipscss.TableName = 'RefTitleIProgramStaffCategory'
			AND tipscss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefTitleIProgramStaffCategory tipsc
			ON tipscss.OutputCode = tipsc.Code
		LEFT JOIN dbo.K12StaffAssignment ksa
			ON sa.OrganizationPersonRoleId_School = ksa.OrganizationPersonRoleId
		-- teacher attributes
		LEFT JOIN dbo.RefUnexperiencedStatus unexp
			ON unexp.Code= sa.InexperiencedStatus
		LEFT JOIN dbo.RefOutOfFieldStatus outoffield
			ON outoffield.Code= sa.OutOfFieldStatus
		LEFT JOIN dbo.RefEmergencyOrProvisionalCredentialStatus emerg
			ON emerg.Code= sa.EmergencyorProvisionalCredentialStatus
		WHERE ksa.K12StaffAssignmentId IS NULL
			AND sa.OrganizationPersonRoleId_School is NOT NULL
	END TRY

	BEGIN CATCH 
		
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StaffAssignment', NULL, 'S16EC250' 
	END CATCH

	-------------------------------------------------------------------------------------------
	---Create missing PersonCredential records
	-------------------------------------------------------------------------------------------
	BEGIN TRY
		INSERT INTO dbo.PersonCredential
		SELECT 
			sa.PersonId
			, NULL
			, ct.RefCredentialTypeId
			, sa.CredentialIssuanceDate
			, sa.CredentialExpirationDate
			, NULL
			, NULL
			, NULL
			, NULL
			, NULL
			, NULL
		FROM Staging.K12StaffAssignment sa
		LEFT JOIN Staging.SourceSystemReferenceData ctss
			ON sa.CredentialType = ctss.InputCode
			AND ctss.TableName = 'RefCredentialType'
			AND ctss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefCredentialType ct
			ON ctss.OutputCode = ct.Code
		LEFT JOIN dbo.PersonCredential pc
			ON sa.PersonId = pc.PersonId
		WHERE pc.PersonCredentialId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonCredential', NULL, 'S16EC260' 
	END CATCH

	BEGIN TRY
		-- Create missing StaffCredential records
		INSERT INTO dbo.StaffCredential (
			RefParaprofessionalQualificationId
			, PersonCredentialId
			, RecordStartDateTime
			, RecordEndDateTime
		)
		SELECT
			pq.RefParaprofessionalQualificationId
			, pc.PersonCredentialId
			, sa.CredentialIssuanceDate
			, sa.CredentialExpirationDate
		FROM Staging.K12StaffAssignment sa
		JOIN dbo.PersonCredential pc
			ON sa.PersonId = pc.PersonId
		LEFT JOIN Staging.SourceSystemReferenceData scss
			ON sa.ParaprofessionalQualification = scss.InputCode
			AND scss.TableName = 'RefParaprofessionalQualification'
			AND scss.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefParaprofessionalQualification pq
			ON scss.OutputCode = pq.Code

	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.StaffCredential', NULL, 'S16EC270' 
	END CATCH

	SET NOCOUNT OFF;
END
