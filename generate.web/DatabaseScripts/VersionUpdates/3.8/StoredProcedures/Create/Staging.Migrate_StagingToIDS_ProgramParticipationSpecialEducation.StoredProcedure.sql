CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_ProgramParticipationSpecialEducation]
	@SchoolYear SMALLINT = NULL
AS
	/*************************************************************************************************************
	Date Created:  7/9/2018

	Purpose:
		The purpose of this ETL is to load the Special Education Participation data 

	Assumptions:
        
	Account executed under: LOGIN

	Approximate run time:  ~ 5 seconds

	Data Sources: 

	Data Targets:  Generate Database:   Generate

	Return Values:
    		0	= Success
  
	Example Usage: 
		EXEC Staging.[Migrate_StagingToIDS_ProgramParticipationSpecialEducation] 2018;
    
	Modification Log:
		#	  Date		  Issue#   Description
		--  ----------  -------  --------------------------------------------------------------------
		01		  	 
	*************************************************************************************************************/BEGIN
	
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
	DECLARE @eStoredProc			varchar(100) = 'Migrate_StagingToIDS_ProgramParticipationSpecialEducation'

	DECLARE @RefPersonIdentificationSystemId INT,
			@RefPersonalInformationVerificationId INT,
			@RefOrganizationIdentifierTypeId_Lea INT,
			@RefOrganizationIdentifierSystemId_Lea INT,
			@RefOrganizationIdentifierTypeId_Sch INT,
			@RefOrganizationIdentifierSystemId_Sch INT,
			@RefOrganizationTypeId INT, 
			@RefProgramTypeId INT,
			@RoleId INT,
			@SchoolYearStartDate DATETIME


	SELECT @RefPersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001075') 
	SELECT @RefPersonalInformationVerificationId = Staging.GetRefPersonalInformationVerificationId('01011')
	SELECT @RefOrganizationIdentifierTypeId_Lea = Staging.GetOrganizationIdentifierTypeId('001072')
	SELECT @RefOrganizationIdentifierSystemId_Lea = Staging.GetOrganizationIdentifierSystemId('SEA', '001072') 
	SELECT @RefOrganizationIdentifierTypeId_Sch = Staging.GetOrganizationIdentifierTypeId('001073')
	SELECT @RefOrganizationIdentifierSystemId_Sch = Staging.GetOrganizationIdentifierSystemId('SEA', '001073')
	SELECT @RefOrganizationTypeId = Staging.GetOrganizationTypeId('Program', '001156') 
	SELECT @RefProgramTypeId = Staging.GetProgramTypeId('04888')
	SELECT @RoleId = Staging.GetRoleId('K12 Student')
	SELECT @SchoolYearStartDate = Staging.GetFiscalYearStartDate(@SchoolYear) 

---Additional Items to add in the future - exit/withdraw reason--
--Need to add ProgramParticipationSpecialEducation into this stored procedure - grab from membership child count
--Need to add PersonProgramParticipation into this stored procedure - grab grom membership child count

	-------------------------------------------------------
	---Associate the PersonId with the temporary table ----
	-------------------------------------------------------
	BEGIN TRY
		UPDATE Staging.ProgramParticipationSpecialEducation
		SET PersonID = pid.PersonId
		FROM Staging.ProgramParticipationSpecialEducation ppse
		JOIN dbo.PersonIdentifier pid 
			ON ppse.Student_Identifier_State = pid.Identifier
		WHERE pid.RefPersonIdentificationSystemId = @RefPersonIdentificationSystemId 
		AND pid.RefPersonalInformationVerificationId = @RefPersonalInformationVerificationId  
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'PersonId', 'S07EC100' 
	END CATCH
	--------------------------------------------------------------------
	---Associate the LEA OrganizationId with the temporary table ----
	--------------------------------------------------------------------
	BEGIN TRY
		UPDATE Staging.ProgramParticipationSpecialEducation
		SET OrganizationID_LEA = orgid.OrganizationId
		FROM Staging.ProgramParticipationSpecialEducation ppse
		JOIN dbo.OrganizationIdentifier orgid 
			ON ppse.LEA_Identifier_State = orgid.Identifier
		WHERE orgid.RefOrganizationIdentifierTypeId = @RefOrganizationIdentifierTypeId_Lea
		AND orgid.RefOrganizationIdentificationSystemId = @RefOrganizationIdentifierSystemId_Lea 
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'OrganizationID_LEA', 'S07EC110' 
	END CATCH

				--------------------------------------------------------------------
	---Associate the School OrganizationId with the temporary table ----
	--------------------------------------------------------------------
	BEGIN TRY
		UPDATE Staging.ProgramParticipationSpecialEducation
		SET OrganizationID_School = orgid.OrganizationId
		FROM Staging.ProgramParticipationSpecialEducation ppse
		JOIN dbo.OrganizationIdentifier orgid 
			ON ppse.School_Identifier_State = orgid.Identifier
		WHERE orgid.RefOrganizationIdentifierTypeId = @RefOrganizationIdentifierTypeId_Sch
		AND orgid.RefOrganizationIdentificationSystemId = @RefOrganizationIdentifierSystemId_Sch
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'OrganizationID_School', 'S07EC120' 
	END CATCH

	-------------------------------------------------------------------------------------------
	---Associate the LEA Special Education Program OrganizationId with the temporary table ----
	-------------------------------------------------------------------------------------------
	BEGIN TRY
		UPDATE Staging.ProgramParticipationSpecialEducation
		SET OrganizationID_Program_LEA = orgd.OrganizationId
		FROM Staging.ProgramParticipationSpecialEducation ppse
		JOIN dbo.OrganizationRelationship ord 
			ON ppse.OrganizationID_LEA = ord.Parent_OrganizationId
		JOIN dbo.OrganizationDetail orgd 
			ON ord.OrganizationId = orgd.OrganizationId
		JOIN dbo.OrganizationProgramType orgpt 
			ON orgd.OrganizationId = orgpt.OrganizationId 
		WHERE orgd.RefOrganizationTypeId = @RefOrganizationTypeId 
			AND orgpt.RefProgramTypeId = @RefProgramTypeId
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'OrganizationID_Program_LEA', 'S07EC130' 
	END CATCH

	----------------------------------------------------------------------------------------------
	---Associate the School Special Education Program OrganizationId with the temporary table ----
	----------------------------------------------------------------------------------------------
	BEGIN TRY
		UPDATE Staging.ProgramParticipationSpecialEducation
		SET OrganizationID_Program_School = orgd.OrganizationId
		FROM Staging.ProgramParticipationSpecialEducation ppse
		JOIN dbo.OrganizationRelationship ord 
			ON ppse.OrganizationID_School = ord.Parent_OrganizationId
		JOIN dbo.OrganizationDetail orgd 
			ON ord.OrganizationId = orgd.OrganizationId
		JOIN dbo.OrganizationProgramType orgpt 
			ON orgd.OrganizationId = orgpt.OrganizationId 
		WHERE orgd.RefOrganizationTypeId = @RefOrganizationTypeId 
			AND orgpt.RefProgramTypeId = @RefProgramTypeId
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'OrganizationID_Program_School', 'S07EC140'
	END CATCH

	----------------------------------------------------------------------------------------------
	---Manage the Special Education Program OrganizationPersonRole Records for each Student ------
	----------------------------------------------------------------------------------------------
	--LEA
	BEGIN TRY
		INSERT INTO [dbo].[OrganizationPersonRole] (
			[OrganizationId]
			,[PersonId]
			,[RoleId]
			,[EntryDate]
			,[ExitDate]
		)
		SELECT DISTINCT
			ppse.OrganizationID_Program_LEA		[OrganizationId]
			,ppse.PersonID						[PersonId]
			,@RoleId	[RoleId]
			,ProgramParticipationBeginDate		[EntryDate]
			,ProgramParticipationEndDate		[ExitDate]
		FROM Staging.ProgramParticipationSpecialEducation ppse
		LEFT JOIN dbo.OrganizationPersonRole opr 
			ON ppse.PersonID = opr.PersonId
			AND ppse.ProgramParticipationBeginDate = opr.EntryDate
			AND ISNULL(ppse.ProgramParticipationEndDate, '1900-01-01') = ISNULL(opr.ExitDate, '1900-01-01')
			AND ppse.OrganizationID_Program_LEA = opr.OrganizationId
			AND opr.RoleId = @RoleId
		WHERE opr.PersonId IS NULL
			AND ppse.OrganizationID_Program_LEA IS NOT NULL
			AND ppse.PersonID IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S07EC150'
	END CATCH

	--School
	BEGIN TRY
		INSERT INTO [dbo].[OrganizationPersonRole] (
			[OrganizationId]
			,[PersonId]
			,[RoleId]
			,[EntryDate]
			,[ExitDate]
		)
		SELECT DISTINCT
			ppse.OrganizationID_Program_School	[OrganizationId]
			,ppse.PersonID						[PersonId]
			,@RoleId	[RoleId]
			,ProgramParticipationBeginDate		[EntryDate]
			,ProgramParticipationEndDate		[ExitDate]
		FROM Staging.ProgramParticipationSpecialEducation ppse
		LEFT JOIN dbo.OrganizationPersonRole opr 
			ON ppse.PersonID = opr.PersonId
			AND ppse.ProgramParticipationBeginDate = opr.EntryDate
			AND ISNULL(ppse.ProgramParticipationEndDate, '1900-01-01') = ISNULL(opr.ExitDate, '1900-01-01')
			AND ppse.OrganizationID_Program_School = opr.OrganizationId
			AND opr.RoleId = @RoleId
		WHERE opr.PersonId IS NULL
			AND ppse.OrganizationID_Program_School IS NOT NULL
			AND ppse.PersonID IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S07EC160'
	END CATCH

	--LEA
	BEGIN TRY
		UPDATE Staging.ProgramParticipationSpecialEducation
		SET OrganizationPersonRoleId_Program_LEA = opr.OrganizationPersonRoleId
		FROM Staging.ProgramParticipationSpecialEducation ppse
		JOIN dbo.OrganizationPersonRole opr 
			ON ppse.PersonID = opr.PersonId 
		WHERE ppse.OrganizationID_Program_LEA = opr.OrganizationId
			AND opr.RoleId = @RoleId 
			AND EntryDate = ppse.ProgramParticipationBeginDate
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'OrganizationPersonRoleId_Program_LEA', 'S07EC170'
	END CATCH
		
	--School
	BEGIN TRY
		UPDATE Staging.ProgramParticipationSpecialEducation
		SET OrganizationPersonRoleId_Program_School = opr.OrganizationPersonRoleId
		FROM Staging.ProgramParticipationSpecialEducation ppse
		JOIN dbo.OrganizationPersonRole opr 
			ON ppse.PersonID = opr.PersonId 
		WHERE ppse.OrganizationID_Program_School = opr.OrganizationId
			AND opr.RoleId = @RoleId 
			AND EntryDate = ppse.ProgramParticipationBeginDate
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'OrganizationPersonRoleId_Program_School', 'S07EC180'
	END CATCH

	-------------------------------------------------------------------------------
	---Delete any OrganizationPersonRole Records not found in the temp table ------
	-------------------------------------------------------------------------------

	CREATE TABLE #RecordsToDelete_OrganizationPersonRole
		(OrganizationPersonRoleId INT)

	BEGIN TRY
		--LEA
		INSERT INTO #RecordsToDelete_OrganizationPersonRole (
			OrganizationPersonRoleId
		)
		SELECT DISTINCT OrganizationPersonRoleId 
		FROM dbo.OrganizationPersonRole opr
		JOIN dbo.OrganizationDetail orgd 
			ON opr.OrganizationId = orgd.OrganizationId
		LEFT JOIN Staging.ProgramParticipationSpecialEducation e 
			ON opr.OrganizationPersonRoleId = e.OrganizationPersonRoleId_Program_LEA
		WHERE e.PersonId IS NULL
			AND opr.RoleId = @RoleId 
		AND orgd.RefOrganizationTypeId = @RefOrganizationTypeId 
		AND opr.EntryDate IS NOT NULL
		AND opr.EntryDate >= @SchoolYearStartDate
		AND orgd.Name = 'Special Education Program'
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '#RecordsToDelete_OrganizationPersonRole', 'OrganizationPersonRoleId', 'S07EC190'
	END CATCH

	BEGIN TRY
		--School
		INSERT INTO #RecordsToDelete_OrganizationPersonRole (
			OrganizationPersonRoleId
		)
		SELECT DISTINCT OrganizationPersonRoleId 
		FROM dbo.OrganizationPersonRole opr
		JOIN dbo.OrganizationDetail orgd 
			ON opr.OrganizationId = orgd.OrganizationId
		LEFT JOIN Staging.ProgramParticipationSpecialEducation e 
			ON opr.OrganizationPersonRoleId = e.OrganizationPersonRoleId_Program_School
		WHERE e.PersonId IS NULL
		AND opr.RoleId = @RoleId 
		AND orgd.RefOrganizationTypeId = @RefOrganizationTypeId 
		AND opr.EntryDate IS NOT NULL
		AND opr.EntryDate >= @SchoolYearStartDate
		AND orgd.Name = 'Special Education Program'
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '#RecordsToDelete_OrganizationPersonRole', 'OrganizationPersonRoleId', 'S07EC200'
	END CATCH

	BEGIN TRY
		CREATE TABLE #RecordsToDelete_PersonProgramParticipation (
			PersonProgramParticipationId INT
		)
		INSERT INTO #RecordsToDelete_PersonProgramParticipation (
			PersonProgramParticipationId
		)
		SELECT DISTINCT PersonProgramParticipationId
		FROM dbo.PersonProgramParticipation ppp
		JOIN #RecordsToDelete_OrganizationPersonRole rtdopr 
			ON ppp.OrganizationPersonRoleId = rtdopr.OrganizationPersonRoleId
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '#RecordsToDelete_PersonProgramParticipation', 'PersonProgramParticipationId', 'S07EC210'
	END CATCH

	---------------------------------------------------------------------------
	--Remove any records that are not in the Current dbo for this School Year--
	---------------------------------------------------------------------------

	BEGIN TRY
		DELETE ppp 
		FROM dbo.ProgramParticipationCte ppp 
		JOIN #RecordsToDelete_PersonProgramParticipation rtdppp 
			ON ppp.PersonProgramParticipationId = rtdppp.PersonProgramParticipationId
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationCte', NULL, 'S07EC220'
	END CATCH

	BEGIN TRY
		DELETE ppp 
		FROM dbo.ProgramParticipationMigrant ppp 
		JOIN #RecordsToDelete_PersonProgramParticipation rtdppp 
			ON ppp.PersonProgramParticipationId = rtdppp.PersonProgramParticipationId
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationMigrant', NULL, 'S07EC230'
	END CATCH

	BEGIN TRY
		DELETE ppp 
		FROM dbo.ProgramParticipationTitleIIILEp ppp 
		JOIN #RecordsToDelete_PersonProgramParticipation rtdppp 
			ON ppp.PersonProgramParticipationId = rtdppp.PersonProgramParticipationId
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationTitleIIILEp', NULL, 'S07EC240'
	END CATCH

	BEGIN TRY
		DELETE ppp 
		FROM dbo.ProgramParticipationSpecialEducation ppp 
		JOIN #RecordsToDelete_PersonProgramParticipation rtdppp
			ON ppp.PersonProgramParticipationId = rtdppp.PersonProgramParticipationId
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationSpecialEducation', NULL, 'S07EC250'
	END CATCH

	BEGIN TRY
		DELETE opr 
		FROM dbo.PersonProgramParticipation opr 
		JOIN #RecordsToDelete_OrganizationPersonRole rtdopr 
			ON opr.OrganizationPersonRoleId = rtdopr.OrganizationPersonRoleId
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S07EC260'
	END CATCH

	---------------------------------------------------------------------------
	--Create PersonProgramParticipation and ProgramParticipationSpecialEd -----
	---------------------------------------------------------------------------

	BEGIN TRY
		--LEA
		INSERT INTO [dbo].[PersonProgramParticipation] (
			[OrganizationPersonRoleId]
			,[RefParticipationTypeId]
			,[RefProgramExitReasonId]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
		)
		SELECT
			ppse.OrganizationPersonRoleId_Program_LEA	[OrganizationPersonRoleId]
			,NULL										[RefParticipationTypeId]
			,NULL										[RefProgramExitReasonId]
			,ProgramParticipationBeginDate				[RecordStartDateTime]
			,ProgramParticipationEndDate				[RecordEndDateTime]
		FROM Staging.ProgramParticipationSpecialEducation ppse
		WHERE ppse.OrganizationPersonRoleId_Program_LEA IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S07EC270'
	END CATCH


	BEGIN TRY
		--School
		INSERT INTO [dbo].[PersonProgramParticipation] (
			[OrganizationPersonRoleId]
			,[RefParticipationTypeId]
			,[RefProgramExitReasonId]
			,[RecordStartDateTime]
			,[RecordEndDateTime])
		SELECT
			ppse.OrganizationPersonRoleId_Program_School	[OrganizationPersonRoleId]
			,NULL											[RefParticipationTypeId]
			,NULL											[RefProgramExitReasonId]
			,ProgramParticipationBeginDate					[RecordStartDateTime]
			,ProgramParticipationEndDate					[RecordEndDateTime]
		FROM Staging.ProgramParticipationSpecialEducation ppse
		WHERE ppse.OrganizationPersonRoleId_Program_School IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S07EC280'
	END CATCH

	BEGIN TRY
		--LEA
		UPDATE Staging.ProgramParticipationSpecialEducation
		SET PersonProgramParticipationID_LEA = ppp.PersonProgramParticipationId
		FROM Staging.ProgramParticipationSpecialEducation ppse
		JOIN dbo.PersonProgramParticipation ppp 
			ON ppse.OrganizationPersonRoleId_Program_LEA = ppp.OrganizationPersonRoleId
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'PersonProgramParticipationID_LEA', 'S07EC290'
	END CATCH

	BEGIN TRY
		--School
		UPDATE Staging.ProgramParticipationSpecialEducation
		SET PersonProgramParticipationID_School = ppp.PersonProgramParticipationId
		FROM Staging.ProgramParticipationSpecialEducation ppse
		JOIN dbo.PersonProgramParticipation ppp 
			ON ppse.OrganizationPersonRoleId_Program_School = ppp.OrganizationPersonRoleId
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'PersonProgramParticipationID_School', 'S07EC300'
	END CATCH

	-- LEA PPSE record
	BEGIN TRY
		INSERT INTO [dbo].[ProgramParticipationSpecialEducation] (
			[PersonProgramParticipationId]
			,[AwaitingInitialIDEAEvaluationStatus]
			,[RefIDEAEducationalEnvironmentECId]
			,[RefIDEAEducationalEnvironmentSchoolAgeId]
			,[SpecialEducationFTE]
			,[RefSpecialEducationExitReasonId]
			,[SpecialEducationServicesExitDate]
			,[RecordStartDateTime]
			,[RecordEndDateTime])
		SELECT 
			ppse.PersonProgramParticipationID_LEA				[PersonProgramParticipationId]
			,NULL												[AwaitingInitialIDEAEvaluationStatus]
			,eeec.[RefIDEAEducationalEnvironmentECId]			[RefIDEAEducationalEnvironmentECId]
			,eesa.[RefIDEAEducationalEnvironmentSchoolAgeId]	[RefIDEAEdEnvironmentSchoolAgeId]
			,NULL												[SpecialEducationFTE]
			,seer.RefSpecialEducationExitReasonId				[RefSpecialEducationExitReasonId]
			,ProgramParticipationEndDate						[SpecialEducationServicesExitDate]
			,ProgramParticipationBeginDate						[RecordStartDateTime]
			,ProgramParticipationEndDate						[RecordEndDateTime]
		FROM Staging.ProgramParticipationSpecialEducation ppse
		LEFT JOIN Staging.SourceSystemReferenceData rdec
			ON ppse.IDEAEducationalEnvironmentForEarlyChildhood = rdec.InputCode
			AND rdec.TableName = 'RefIDEAEducationalEnvironmentEC'
			AND rdec.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefIDEAEducationalEnvironmentEC eeec
			ON rdec.OutputCode = eeec.Code
		LEFT JOIN Staging.SourceSystemReferenceData rdsa
			ON ppse.IDEAEducationalEnvironmentForSchoolAge = rdsa.InputCode
			AND rdsa.TableName = 'RefIDEAEducationalEnvironmentSchoolAge'
			AND rdsa.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefIDEAEducationalEnvironmentSchoolAge eesa
			ON rdsa.OutputCode = eesa.Code
		LEFT JOIN Staging.SourceSystemReferenceData ersa
			ON ppse.SpecialEducationExitReason = ersa.InputCode
			AND ersa.TableName = 'RefSpecialEducationExitReason'
			AND ersa.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefSpecialEducationExitReason seer
			ON ersa.OutputCode = seer.Code
		WHERE PersonProgramParticipationID_LEA IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationSpecialEducation', NULL, 'S07EC310'
	END CATCH

		
	BEGIN TRY
		INSERT INTO [dbo].[ProgramParticipationSpecialEducation] (
			[PersonProgramParticipationId]
			,[AwaitingInitialIDEAEvaluationStatus]
			,[RefIDEAEducationalEnvironmentECId]
			,[RefIDEAEducationalEnvironmentSchoolAgeId]
			,[SpecialEducationFTE]
			,[RefSpecialEducationExitReasonId]
			,[SpecialEducationServicesExitDate]
			,[RecordStartDateTime]
			,[RecordEndDateTime])
		SELECT 
			ppse.PersonProgramParticipationID_School			[PersonProgramParticipationId]
			,NULL												[AwaitingInitialIDEAEvaluationStatus]
			,eeec.[RefIDEAEducationalEnvironmentECId]			[RefIDEAEducationalEnvironmentECId]
			,eesa.[RefIDEAEducationalEnvironmentSchoolAgeId]	[RefIDEAEdEnvironmentSchoolAgeId]
			,NULL												[SpecialEducationFTE]
			,seer.RefSpecialEducationExitReasonId				[RefSpecialEducationExitReasonId]
			,ProgramParticipationEndDate						[SpecialEducationServicesExitDate]
			,ProgramParticipationBeginDate						[RecordStartDateTime]
			,ProgramParticipationEndDate						[RecordEndDateTime]
		FROM Staging.ProgramParticipationSpecialEducation ppse
		LEFT JOIN Staging.SourceSystemReferenceData rdec
			ON ppse.IDEAEducationalEnvironmentForEarlyChildhood = rdec.InputCode
			AND rdec.TableName = 'RefIDEAEducationalEnvironmentEC'
			AND rdec.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefIDEAEducationalEnvironmentEC eeec
			ON rdec.OutputCode = eeec.Code
		LEFT JOIN Staging.SourceSystemReferenceData rdsa
			ON ppse.IDEAEducationalEnvironmentForSchoolAge = rdsa.InputCode
			AND rdsa.TableName = 'RefIDEAEducationalEnvironmentSchoolAge'
			AND rdsa.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefIDEAEducationalEnvironmentSchoolAge eesa
			ON rdsa.OutputCode = eesa.Code
		LEFT JOIN Staging.SourceSystemReferenceData ersa
			ON ppse.SpecialEducationExitReason = ersa.InputCode
			AND ersa.TableName = 'RefSpecialEducationExitReason'
			AND ersa.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefSpecialEducationExitReason seer
			ON ersa.OutputCode = seer.Code
		WHERE PersonProgramParticipationID_School IS NOT NULL
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationSpecialEducation', NULL, 'S07EC320'
	END CATCH

	----Error table logging will be inserted here.  Not only errors with the ETL itself, but with the data. The temporary tables will be checked
	----for erroneous or missing data and that information will be logged in a table that will eventually be displayed through the Generate UI

	DROP TABLE #RecordsToDelete_OrganizationPersonRole
	DROP TABLE #RecordsToDelete_PersonProgramParticipation

	set nocount off;


END