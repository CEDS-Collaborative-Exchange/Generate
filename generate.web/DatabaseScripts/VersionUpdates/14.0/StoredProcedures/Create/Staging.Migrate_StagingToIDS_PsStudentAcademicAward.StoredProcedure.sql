CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_PsStudentAcademicAward]
	@SchoolYear INT = NULL
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
      EXEC Staging.[Migrate_StagingToIDS_PsStudentAcademicAward] 2019;
    
    Modification Log:
      #	  Date		  Issue#   Description
      --  ----------  -------  --------------------------------------------------------------------
      01		  	 
    *************************************************************************************************************/
BEGIN

    --SET NOCOUNT ON;
		
	--IF @SchoolYear IS NULL BEGIN
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
	DECLARE @eStoredProc			VARCHAR(100) = 'Migrate_StagingToIDS_PsStudentAcademicAward'

	-------------------------------------------------------------
	---Associate the DataCollectionId with the staging table ----
	-------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.PsStudentAcademicAward
		SET  DataCollectionId = dc.DataCollectionId
		FROM Staging.PsStudentAcademicAward saa
		JOIN dbo.DataCollection dc
			ON saa.DataCollectionName = dc.DataCollectionName
	END TRY
		
	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PsStudentAcademicAward', 'DataCollectionId', 'S03EC090' 
	END CATCH

	-------------------------------------------------------
	---Associate the OrganizationId with the staging table ----
	-------------------------------------------------------
	DECLARE @RefOrganizationIdentifierTypeId int
	SET @RefOrganizationIdentifierTypeId = Staging.GetOrganizationIdentifierTypeId('000166')

	BEGIN TRY
		UPDATE Staging.PsStudentAcademicAward
		SET  OrganizationId = orgid.OrganizationId
		FROM Staging.PsStudentAcademicAward saa
		JOIN dbo.OrganizationIdentifier orgid ON saa.InstitutionIpedsUnitId = orgid.Identifier
		WHERE orgid.RefOrganizationIdentifierTypeId = @RefOrganizationIdentifierTypeId
			--AND orgid.RefOrganizationIdentificationSystemId = Staging.GetOrganizationIdentifierSystemId('SEA', '001072')
			AND ISNULL(orgid.DataCollectionId, '') = ISNULL(saa.DataCollectionId, '')
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
		UPDATE Staging.PsStudentAcademicAward
		SET  PersonId = pid.PersonId
		FROM Staging.PsStudentAcademicAward e
		JOIN dbo.PersonIdentifier pid ON e.Student_Identifier_State = pid.Identifier
		WHERE pid.RefPersonIdentificationSystemId = @RefPersonIdentificationSystemId
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
		UPDATE Staging.PsStudentAcademicAward
		SET  OrganizationPersonRoleId = opr.PersonId
		FROM Staging.PsStudentAcademicAward e
		JOIN dbo.OrganizationPersonRole opr 
			ON e.OrganizationId = opr.OrganizationId
			AND e.PersonId = opr.PersonId
			AND e.EntryDate = opr.EntryDate
			AND ISNULL(e.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
	END TRY
		
	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Assessment', 'AssessmentId', 'S15EC100' 
	END CATCH

	------------------------------------------------------------------
	--- Associate PsStudentAcademicAwardId with the staging table ----
	------------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.PsStudentAcademicAward
		SET  PsStudentAcademicAwardId = saa.PsStudentAcademicAwardId
		FROM Staging.PsStudentAcademicAward e
		JOIN dbo.PsStudentAcademicAward saa
			ON e.OrganizationPersonRoleId = saa.OrganizationPersonRoleId
			AND ISNULL(e.DataCollectionId, '') = ISNULL(saa.DataCollectionId, '')
	END TRY
		
	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Assessment', 'AssessmentId', 'S15EC100' 
	END CATCH

	-----------------------------------------------
	---Add new PsStudentAcademicAward Awards ----
	-----------------------------------------------

	BEGIN TRY
		INSERT INTO dbo.PsStudentAcademicAward
			(
			  OrganizationPersonRoleId
			, AcademicAwardDate
			, RefPESCAwardLevelTypeId
			, DataCollectionId
			)
		SELECT 
			  e.OrganizationPersonRoleId
			, e.AcademicAwardDate
			, palt.RefPESCAwardLevelTypeId
			, e.DataCollectionId
		FROM Staging.PsStudentAcademicAward e
		LEFT JOIN Staging.SourceSystemReferenceData ssrd
			ON e.PescAwardLevelType = ssrd.InputCode
			AND ssrd.TableName = 'RefPESCAwardLevelType'
			AND ssrd.SchoolYear = e.SchoolYear
		LEFT JOIN dbo.RefPESCAwardLevelType palt
			ON ssrd.OutputCode = palt.Code
		WHERE e.PsStudentAcademicAwardId IS NULL

	END TRY
		
	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Assessment', 'AssessmentId', 'S15EC100' 
	END CATCH



END    