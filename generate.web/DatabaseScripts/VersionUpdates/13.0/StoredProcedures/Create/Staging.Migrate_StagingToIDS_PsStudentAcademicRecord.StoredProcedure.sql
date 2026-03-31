Create PROCEDURE [Staging].[Migrate_StagingToIDS_PsStudentAcademicRecord]
	--@SchoolYear INT = NULL
AS
    /*************************************************************************************************************
    Date Created:  12/09/2019

    Purpose:
        The purpose of this ETL IS to load postsecondary academic award data.

    Assumptions:
        
    Account executed under: LOGIN

    Approximate run time:  ~ 5 seconds

    Data Sources: 

    Data Targets:  Generate Database:   Generate

    Return VALUES:
    	 0	= Success
  
    Example Usage: 
      EXEC Staging.[Migrate_StagingToIDS_PsStudentAcademicRecord] 2019;
    
    Modification Log:
      #	  Date		  Issue#   Description
      --  ----------  -------  --------------------------------------------------------------------
      01		  	 
    *************************************************************************************************************/
BEGIN

    SET NOCOUNT ON;
		
	--IF @SchoolYear IS NULL 
	--BEGIN
	--	SELECT @SchoolYear = d.Year + 1
	--	FROM rds.DimDateDataMigrationTypes dd 
	--	JOIN rds.DimDates d 
	--		ON dd.DimDateId = d.DimDateId 
	--	JOIN rds.DimDataMigrationTypes b 
	--		ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
	--	WHERE dd.IsSelected = 1 
	--		AND DataMigrationTypeCode = 'ODS'
	--END 

    ---------------------------------------------------
    --- Declare Error Handling Variables           ----
    ---------------------------------------------------
	DECLARE @eStoredProc			VARCHAR(100) = 'Migrate_StagingToIDS_PsStudentAcademicRecord'

	-------------------------------------------------------------
	---Associate the DataCollectionId with the staging table ----
	-------------------------------------------------------------

	BEGIN TRY
		UPDATE pr
		SET DataCollectionId = dc.DataCollectionId
		FROM [Staging].[PsStudentAcademicRecord] pr
		JOIN dbo.DataCollection dc
			ON pr.DataCollectionName = dc.DataCollectionName
	END TRY
		
	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PsStudentAcademicRecord', 'DataCollectionId', 'S03EC090' 
	END CATCH

	-------------------------------------------------------
	---Associate the OrganizationId with the staging table ----
	-------------------------------------------------------

	DECLARE @RefOrganizationIdentifierTypeId int
	SET @RefOrganizationIdentifierTypeId = Staging.GetOrganizationIdentifierTypeId('000166')
	
	BEGIN TRY
		UPDATE Staging.PsStudentAcademicRecord
		SET  OrganizationId = orgid.OrganizationId
		FROM Staging.PsStudentAcademicRecord sar
		JOIN dbo.OrganizationIdentifier orgid 
			ON sar.InstitutionIpedsUnitId = orgid.Identifier
		WHERE orgid.RefOrganizationIdentifierTypeId = @RefOrganizationIdentifierTypeId
			AND ISNULL(orgid.DataCollectionId, '') = ISNULL(sar.DataCollectionId, '')
	END TRY
		
	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Assessment', 'AssessmentId', 'S15EC100' 
	END CATCH

	-------------------------------------------------------
	---Associate the PersonId with the staging table ----
	-------------------------------------------------------

	DECLARE @RefPersonIdentificationSystemId int,@RefPersonalInformationVerificationId INT
	SET @RefPersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001075')
	SET @RefPersonalInformationVerificationId =  Staging.GetRefPersonalInformationVerificationId('01011')
	
	BEGIN TRY
		UPDATE Staging.PsStudentAcademicRecord
		SET  PersonId = pid.PersonId
		FROM Staging.PsStudentAcademicRecord e
		JOIN dbo.PersonIdentifier pid 
			ON e.Student_Identifier_State = pid.Identifier
		JOIN dbo.OrganizationPersonRole opr 
			ON e.OrganizationId = opr.OrganizationId
			AND pid.PersonId = opr.PersonId
			AND e.EntryDate = opr.EntryDate
			AND ISNULL(e.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
		WHERE  pid.RefPersonIdentificationSystemId = @RefPersonIdentificationSystemId
			AND pid.RefPersonalInformationVerificationId = @RefPersonalInformationVerificationId
			AND ISNULL(pid.DataCollectionId, '') = ISNULL(e.DataCollectionId, '')
	END TRY
		
	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Assessment', 'AssessmentId', 'S15EC100' 
	END CATCH

	-----------------------------------------------------------------------
	---Associate the OrganizationPersonRoleId with the staging table ----
	-----------------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.PsStudentAcademicRecord
		SET  OrganizationPersonRoleId = opr.organizationpersonroleid
		FROM Staging.PsStudentAcademicRecord e
		JOIN dbo.OrganizationPersonRole opr 
			ON e.OrganizationId = opr.OrganizationId
			AND e.PersonId = opr.PersonId
			AND e.EntryDate = opr.EntryDate
			AND e.exitdate =  opr.exitdate
			AND ISNULL(e.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
	END TRY
		
	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Assessment', 'AssessmentId', 'S15EC100' 
	END CATCH

	------------------------------------------------------------------
	--- Associate PsStudentAcademicRecordId with the staging table ----
	------------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.PsStudentAcademicRecord
		SET  PsStudentAcademicRecordId = sar.PsStudentAcademicRecordId
		FROM Staging.PsStudentAcademicRecord e
		JOIN dbo.PsStudentAcademicRecord sar
			ON e.OrganizationPersonRoleId = sar.OrganizationPersonRoleId
			AND ISNULL(e.DataCollectionId, '') = ISNULL(sar.DataCollectionId, '')
	END TRY
		
	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Assessment', 'AssessmentId', 'S15EC100' 
	END CATCH

	-----------------------------------------------
	---Add new PsStudentAcademicRecord records ----
	-----------------------------------------------

	BEGIN TRY
		INSERT INTO dbo.PsStudentAcademicRecord
			(
			  OrganizationPersonRoleId
			, AcademicYearDesignator
			, DiplomaOrCredentialAwardDate
			, RefAcademicTermDesignatorId
			--, RefProfessionalTechCredentialTypeId
			, DataCollectionId
			)
		SELECT 
			  e.OrganizationPersonRoleId
			, e.SchoolYear
			, e.DiplomaOrCredentialAwardDate
			, atd.RefAcademicTermDesignatorId
			--, ptct.RefProfessionalTechnicalCredentialTypeId
			, e.DataCollectionId
		FROM Staging.PsStudentAcademicRecord e
		JOIN Staging.SourceSystemReferenceData ssrd
			ON e.AcademicTermDesignator = ssrd.InputCode
			AND ssrd.TableName = 'RefAcademicTermDesignator'
			AND ssrd.SchoolYear = e.SchoolYear
		JOIN dbo.RefAcademicTermDesignator atd
			ON ssrd.OutputCode = atd.Code
		--LEFT JOIN Staging.SourceSystemReferenceData ssrd2
		--	ON e.ProfessionalOrTechnicalCredentialConferred = ssrd2.InputCode
		--	AND ssrd2.TableName = 'RefProfessionalTechCredentialType'
		--	AND ssrd2.SchoolYear = e.SchoolYear
		--LEFT JOIN dbo.RefProfessionalTechnicalCredentialType ptct
		--	ON ssrd2.OutputCode = ptct.Code
		WHERE e.PsStudentAcademicRecordId IS NULL

	END TRY
		
	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Assessment', 'AssessmentId', 'S15EC100' 
	END CATCH

END    