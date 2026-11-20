CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_Discipline]
	@SchoolYear SMALLINT = NULL
AS 
  /*************************************************************************************************************
    Date Created:  2/12/2018

    Purpose:
        The purpose of this ETL is to load the data for Discipline (c005, c006, c007, c088, c143, c144).

    Assumptions:
        
    Account executed under: LOGIN

    Approximate run time:  ~ 5 seconds

    Data Sources: 

    Data Targets:  Generate Database:   Generate

    Return Values:
    	 0	= Success
  
    Example Usage: 
      EXEC Staging.[Migrate_StagingToIDS_Discipline] 2019;
    
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
	DECLARE @eStoredProc VARCHAR(100) = 'Migrate_StagingToIDS_Discipline'

	-----------------------------------------------------------
	----Grab the LEA student person and enrollment records ----
	-----------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.Discipline 
		SET	PersonId = pid.PersonId
			,OrganizationPersonRoleId_LEA = opr.OrganizationPersonRoleId
			,OrganizationId_LEA = oid.OrganizationId
		FROM Staging.Discipline d 
		JOIN dbo.PersonIdentifier pid 
			ON pid.Identifier = d.Student_Identifier_State
		JOIN dbo.OrganizationIdentifier oid 
			ON oid.Identifier = d.LEA_Identifier_State
		JOIN dbo.OrganizationPersonRole opr 
			ON pid.PersonId = opr.PersonId
			AND oid.OrganizationId = opr.OrganizationId
			AND d.DisciplinaryActionStartDate BETWEEN opr.EntryDate AND ISNULL(opr.ExitDate, GETDATE())
		WHERE 
			oid.RefOrganizationIdentificationSystemId = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001072')
			AND oid.RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('001072')
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Discipline', 'PersonId', 'S13EC100' 
	END CATCH

	--------------------------------------------------------------
	----Grab the school student person and enrollment records ----
	--------------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.Discipline 
		SET	PersonId = pid.PersonId
			,OrganizationPersonRoleId_School = opr.OrganizationPersonRoleId
			,OrganizationId_School = oid.OrganizationId
		FROM Staging.Discipline d 
		JOIN dbo.PersonIdentifier pid 
			ON pid.Identifier = d.Student_Identifier_State
		JOIN dbo.OrganizationIdentifier oid 
			ON oid.Identifier = d.School_Identifier_State
		JOIN dbo.OrganizationPersonRole opr 
			ON pid.PersonId = opr.PersonId
			AND oid.OrganizationId = opr.OrganizationId
			AND d.DisciplinaryActionStartDate BETWEEN opr.EntryDate AND ISNULL(opr.ExitDate, GETDATE())
		WHERE 
			oid.RefOrganizationIdentificationSystemId = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001073')
			AND oid.RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('001073')
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Discipline', 'PersonId', 'S13EC110' 
	END CATCH

	-------------------------------------------------------------------------------------------------
	----Merge School Incident records so that we don't create duplicate discipline entries accidentally ----
	-------------------------------------------------------------------------------------------------

	BEGIN TRY
	--LEA
		INSERT INTO dbo.Incident ( 
			IncidentIdentifier
			,IncidentDate
			,IncidentTime
			,OrganizationPersonRoleId
			,RefFirearmTypeId
		)
		SELECT 
			d.IncidentIdentifier
			,d.IncidentDate
			,d.IncidentTime
			,d.OrganizationPersonRoleId_LEA
			,ft.RefFirearmTypeId
		FROM Staging.Discipline d
		LEFT JOIN dbo.Incident i
			ON d.IncidentIdentifier = i.IncidentIdentifier
			AND d.OrganizationPersonRoleId_LEA = i.OrganizationPersonRoleId
		LEFT JOIN Staging.SourceSystemReferenceData osssft
			ON d.FirearmType = osssft.InputCode
			AND osssft.TableName = 'RefFirearmType'
			AND osssft.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefFirearmType ft 
			ON osssft.OutputCode = ft.Code
		WHERE i.IncidentId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Incident', NULL, 'S13EC120' 
	END CATCH

	BEGIN TRY
		--School
		INSERT INTO dbo.Incident ( 
			IncidentIdentifier
			,IncidentDate
			,IncidentTime
			,OrganizationPersonRoleId
			,RefFirearmTypeId
		)
		SELECT 
			d.IncidentIdentifier
			,d.IncidentDate
			,d.IncidentTime
			,d.OrganizationPersonRoleId_School
			,ft.RefFirearmTypeId
		FROM Staging.Discipline d
		LEFT JOIN dbo.Incident i
			ON d.IncidentIdentifier = i.IncidentIdentifier
			AND d.OrganizationPersonRoleId_School = i.OrganizationPersonRoleId
		LEFT JOIN Staging.SourceSystemReferenceData osssft
			ON d.FirearmType = osssft.InputCode
			AND osssft.TableName = 'RefFirearmType'
			AND osssft.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefFirearmType ft 
			ON osssft.OutputCode = ft.Code
		WHERE i.IncidentId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Incident', NULL, 'S13EC130' 
	END CATCH

	BEGIN TRY
		--LEA
		UPDATE Staging.Discipline
		SET IncidentId_LEA = i.IncidentId
		FROM dbo.Incident i
		JOIN Staging.Discipline d
			ON i.IncidentIdentifier = d.IncidentIdentifier
			AND i.OrganizationPersonRoleId = d.OrganizationPersonRoleId_LEA
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Discipline', 'IncidentId', 'S13EC140' 
	END CATCH

	BEGIN TRY
		--School
		UPDATE Staging.Discipline
		SET IncidentId_School = i.IncidentId
		FROM dbo.Incident i
		JOIN Staging.Discipline d
			ON i.IncidentIdentifier = d.IncidentIdentifier
			AND i.OrganizationPersonRoleId = d.OrganizationPersonRoleId_School
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Discipline', 'IncidentId', 'S13EC150' 
	END CATCH

	-------------------------------------------
	----Merge K12StudentDiscipline records ----
	-------------------------------------------
	-- We cannot update the records in K12StudentDiscipline without K12StudentDisciplineId, so we have to kill & fill the table 
	BEGIN TRY
	--LEA
		DELETE FROM [dbo].[K12StudentDiscipline]
		FROM [dbo].[K12StudentDiscipline] sd
		JOIN Staging.Discipline d
			ON sd.IncidentId = d.IncidentId_LEA
			AND sd.OrganizationPersonRoleId = d.OrganizationPersonRoleId_LEA
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentDiscipline', NULL, 'S13EC200' 
	END CATCH

	BEGIN TRY
		--School
		DELETE FROM [dbo].[K12StudentDiscipline]
		FROM [dbo].[K12StudentDiscipline] sd
		JOIN Staging.Discipline d
			ON sd.IncidentId = d.IncidentId_School
			AND sd.OrganizationPersonRoleId = d.OrganizationPersonRoleId_School
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentDiscipline', NULL, 'S13EC210' 
	END CATCH

	BEGIN TRY
		--LEA
		INSERT INTO [dbo].[K12StudentDiscipline]
		   ([OrganizationPersonRoleId]
		   ,[RefDisciplineReasonId]
		   ,[RefDisciplinaryActionTakenId]
		   ,[DisciplinaryActionStartDate]
		   ,[DisciplinaryActionEndDate]
		   ,[DurationOfDisciplinaryAction]
		   ,[RefDisciplineLengthDifferenceReasonId]
		   ,[FullYearExpulsion]
		   ,[ShortenedExpulsion]
		   ,[EducationalServicesAfterRemoval]
		   ,[RefIdeaInterimRemovalId]
		   ,[RefIdeaInterimRemovalReasonId]
		   ,[RelatedToZeroTolerancePolicy]
		   ,[IncidentId]
		   ,[IEPPlacementMeetingIndicator]
		   ,[RefDisciplineMethodFirearmsId]
		   ,[RefDisciplineMethodOfCwdId]
		   ,[RefIDEADisciplineMethodFirearmId])
		SELECT DISTINCT
			d.OrganizationPersonRoleId_LEA		[OrganizationPersonRoleId]
		   ,dr.RefDisciplineReasonId			[RefDisciplineReasonId]
		   ,dat.RefDisciplinaryActionTakenId	[RefDisciplinaryActionTakenId]
		   ,d.DisciplinaryActionStartDate		[DisciplinaryActionStartDate]
		   ,CASE WHEN d.DisciplinaryActionEndDate IS NULL 
				THEN DisciplinaryActionStartDate
				ELSE d.DisciplinaryActionEndDate 
				END								[DisciplinaryActionEndDate]
		   ,d.DurationOfDisciplinaryAction		[DurationOfDisciplinaryAction]
		   ,NULL								[RefDisciplineLengthDifferenceReasonId]
		   ,NULL								[FullYearExpulsion]
		   ,NULL								[ShortenedExpulsion]
		   ,d.EducationalServicesAfterRemoval	[EducationalServicesAfterRemoval]
		   ,iir.RefIdeaInterimRemovalId			[RefIdeaInterimRemovalId]
		   ,iirr.RefIdeaInterimRemovalReasonId	[RefIdeaInterimRemovalReasonId]
		   ,NULL								[RelatedToZeroTolerancePolicy]
		   ,i.IncidentId						[IncidentId]
		   ,NULL								[IEPPlacementMeetingIndicator]
		   ,gdismethod.RefDisciplineMethodFirearmsId			[RefDisciplineMethodFirearmsId]
		   ,dm.RefDisciplineMethodOfCwdId		[RefDisciplineMethodOfCwdId]
		   ,gIDEAdismethod.RefIDEADisciplineMethodFirearmId		[RefIDEADisciplineMethodFirearmId]
		FROM dbo.Person p
		JOIN dbo.PersonIdentifier pid 
			ON p.PersonID = pid.PersonId
		JOIN Staging.Discipline d 
			ON pid.Identifier = d.Student_Identifier_State
		JOIN dbo.Incident i
			ON i.IncidentId = d.IncidentId_LEA
			AND d.OrganizationPersonRoleId_LEA = i.OrganizationPersonRoleId
		LEFT JOIN Staging.SourceSystemReferenceData rddr
			ON d.DisciplineReason = rddr.InputCode
			AND rddr.TableName = 'RefDisciplineReason'
			AND rddr.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefDisciplineReason dr
			ON rddr.OutputCode = dr.Code
		LEFT JOIN Staging.SourceSystemReferenceData rdda
			ON d.DisciplinaryActionTaken = rdda.InputCode
			AND rdda.TableName = 'RefDisciplinaryActionTaken'
			AND rdda.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefDisciplinaryActionTaken dat
			ON rdda.OutputCode = dat.Code
		LEFT JOIN Staging.SourceSystemReferenceData rdiir
			ON d.IdeaInterimRemoval = rdiir.InputCode
			AND rdiir.TableName = 'RefIdeaInterimRemoval'
			AND rdiir.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefIdeaInterimRemoval iir
			ON rdiir.OutputCode = iir.Code
		LEFT JOIN Staging.SourceSystemReferenceData rdiirr
			ON d.IdeaInterimRemovalReason = rdiirr.InputCode
			AND rdiirr.TableName = 'RefIDEAInterimRemovalReason'
			AND rdiirr.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefIdeaInterimRemovalReason iirr
			ON rdiirr.OutputCode = iirr.Code
		LEFT JOIN Staging.SourceSystemReferenceData rdidm
			ON d.DisciplineMethodOfCwd = rdidm.InputCode
			AND rdidm.TableName = 'RefDisciplineMethodOfCwd'
			AND rdidm.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefDisciplineMethodOfCwd dm
			ON rdidm.OutputCode = dm.Code

		LEFT JOIN Staging.SourceSystemReferenceData dismethod
			ON d.DisciplineMethodFirearm = dismethod.InputCode
			AND dismethod.TableName = 'RefDisciplineMethodFirearms'
			AND dismethod.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefDisciplineMethodFirearms gdismethod
			ON gdismethod.Code = dismethod.OutputCode

		LEFT JOIN Staging.SourceSystemReferenceData IDEAdismethod
			ON d.IDEADisciplineMethodFirearm = IDEAdismethod.InputCode
			AND IDEAdismethod.TableName = 'RefIDEADisciplineMethodFirearm'
			AND IDEAdismethod.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefIDEADisciplineMethodFirearm gIDEAdismethod
			ON gIDEAdismethod.Code = IDEAdismethod.OutputCode

		WHERE pid.RefPersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001075')
			AND d.OrganizationPersonRoleId_LEA IS NOT NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentDiscipline', NULL, 'S13EC220' 
	END CATCH

	BEGIN TRY
		--School
		INSERT INTO [dbo].[K12StudentDiscipline]
		   ([OrganizationPersonRoleId]
		   ,[RefDisciplineReasonId]
		   ,[RefDisciplinaryActionTakenId]
		   ,[DisciplinaryActionStartDate]
		   ,[DisciplinaryActionEndDate]
		   ,[DurationOfDisciplinaryAction]
		   ,[RefDisciplineLengthDifferenceReasonId]
		   ,[FullYearExpulsion]
		   ,[ShortenedExpulsion]
		   ,[EducationalServicesAfterRemoval]
		   ,[RefIdeaInterimRemovalId]
		   ,[RefIdeaInterimRemovalReasonId]
		   ,[RelatedToZeroTolerancePolicy]
		   ,[IncidentId]
		   ,[IEPPlacementMeetingIndicator]
		   ,[RefDisciplineMethodFirearmsId]
		   ,[RefDisciplineMethodOfCwdId]
		   ,[RefIDEADisciplineMethodFirearmId])
		SELECT DISTINCT
			d.OrganizationPersonRoleId_School	[OrganizationPersonRoleId]
		   ,dr.RefDisciplineReasonId			[RefDisciplineReasonId]
		   ,dat.RefDisciplinaryActionTakenId	[RefDisciplinaryActionTakenId]
		   ,d.DisciplinaryActionStartDate		[DisciplinaryActionStartDate]
		   ,CASE WHEN d.DisciplinaryActionEndDate IS NULL 
				THEN DisciplinaryActionStartDate
				ELSE d.DisciplinaryActionEndDate 
				END								[DisciplinaryActionEndDate]
		   ,d.DurationOfDisciplinaryAction		[DurationOfDisciplinaryAction]
		   ,NULL								[RefDisciplineLengthDifferenceReasonId]
		   ,NULL								[FullYearExpulsion]
		   ,NULL								[ShortenedExpulsion]
		   ,d.EducationalServicesAfterRemoval	[EducationalServicesAfterRemoval]
		   ,iir.RefIdeaInterimRemovalId			[RefIdeaInterimRemovalId]
		   ,iirr.RefIdeaInterimRemovalReasonId	[RefIdeaInterimRemovalReasonId]
		   ,NULL								[RelatedToZeroTolerancePolicy]
		   ,i.IncidentId						[IncidentId]
		   ,NULL								[IEPPlacementMeetingIndicator]
		   ,gdismethod.RefDisciplineMethodFirearmsId			[RefDisciplineMethodFirearmsId]
		   ,dm.RefDisciplineMethodOfCwdId		[RefDisciplineMethodOfCwdId]
		   ,gIDEAdismethod.RefIDEADisciplineMethodFirearmId		[RefIDEADisciplineMethodFirearmId]
		FROM dbo.Person p
		JOIN dbo.PersonIdentifier pid 
			ON p.PersonID = pid.PersonId
		JOIN Staging.Discipline d 
			ON pid.Identifier = d.Student_Identifier_State
		JOIN dbo.Incident i
			ON i.IncidentId = d.IncidentId_School
			AND d.OrganizationPersonRoleId_School = i.OrganizationPersonRoleId
		LEFT JOIN Staging.SourceSystemReferenceData rddr
			ON d.DisciplineReason = rddr.InputCode
			AND rddr.TableName = 'RefDisciplineReason'
			AND rddr.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefDisciplineReason dr
			ON rddr.OutputCode = dr.Code
		LEFT JOIN Staging.SourceSystemReferenceData rdda
			ON d.DisciplinaryActionTaken = rdda.InputCode
			AND rdda.TableName = 'RefDisciplinaryActionTaken'
			AND rdda.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefDisciplinaryActionTaken dat
			ON rdda.OutputCode = dat.Code
		LEFT JOIN Staging.SourceSystemReferenceData rdiir
			ON d.IdeaInterimRemoval = rdiir.InputCode
			AND rdiir.TableName = 'RefIdeaInterimRemoval'
			AND rdiir.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefIdeaInterimRemoval iir
			ON rdiir.OutputCode = iir.Code
		LEFT JOIN Staging.SourceSystemReferenceData rdiirr
			ON d.IdeaInterimRemovalReason = rdiirr.InputCode
			AND rdiirr.TableName = 'RefIDEAInterimRemovalReason'
			AND rdiirr.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefIdeaInterimRemovalReason iirr
			ON rdiirr.OutputCode = iirr.Code
		LEFT JOIN Staging.SourceSystemReferenceData rdidm
			ON d.DisciplineMethodOfCwd = rdidm.InputCode
			AND rdidm.TableName = 'RefDisciplineMethodOfCwd'
			AND rdidm.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefDisciplineMethodOfCwd dm
			ON rdidm.OutputCode = dm.Code

		LEFT JOIN Staging.SourceSystemReferenceData dismethod
			ON d.DisciplineMethodFirearm = dismethod.InputCode
			AND dismethod.TableName = 'RefDisciplineMethodFirearms'
			AND dismethod.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefDisciplineMethodFirearms gdismethod
			ON gdismethod.Code = dismethod.OutputCode

		LEFT JOIN Staging.SourceSystemReferenceData IDEAdismethod
			ON d.IDEADisciplineMethodFirearm = IDEAdismethod.InputCode
			AND IDEAdismethod.TableName = 'RefIDEADisciplineMethodFirearm'
			AND IDEAdismethod.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefIDEADisciplineMethodFirearm gIDEAdismethod
			ON gIDEAdismethod.Code = IDEAdismethod.OutputCode

		WHERE pid.RefPersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001075')
			AND d.OrganizationPersonRoleId_School IS NOT NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentDiscipline', NULL, 'S13EC230' 
	END CATCH

	--------------------------------------------------------------------------------------------------
	---- Update Educational Services After Removal based on Disciplinary Action Taken If NULL Value --
	--------------------------------------------------------------------------------------------------

	BEGIN TRY
		UPDATE dbo.K12StudentDiscipline
		SET EducationalServicesAfterRemoval = 1
		FROM dbo.K12StudentDiscipline ksd
		JOIN dbo.RefDisciplinaryActionTaken dat 
			ON ksd.RefDisciplinaryActionTakenId = dat.RefDisciplinaryActionTakenId
		WHERE dat.Code IN ('03086', '03101')
		AND ksd.EducationalServicesAfterRemoval IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentDiscipline', 'EducationalServicesAfterRemoval', 'S13EC240' 
	END CATCH

	BEGIN TRY
		UPDATE dbo.K12StudentDiscipline 
		SET EducationalServicesAfterRemoval = 0 
		WHERE EducationalServicesAfterRemoval IS NULL
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentDiscipline', 'EducationalServicesAfterRemoval', 'S13EC250' 
	END CATCH

	set nocount off;
END

