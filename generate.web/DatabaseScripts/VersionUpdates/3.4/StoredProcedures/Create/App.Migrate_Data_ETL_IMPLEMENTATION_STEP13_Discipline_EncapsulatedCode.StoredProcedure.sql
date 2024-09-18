CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP13_Discipline_EncapsulatedCode]
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
      EXEC App.[Migrate_Data_ETL_IMPLEMENTATION_STEP13_Discipline_EncapsulatedCode] 2019;
    
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
	DECLARE @eStoredProc VARCHAR(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP13_Discipline_EncapsulatedCode'

	-----------------------------------------------------------
	----Grab the LEA student person and enrollment records ----
	-----------------------------------------------------------

	BEGIN TRY
		UPDATE Staging.Discipline 
		SET	PersonId = pid.PersonId
			,OrganizationPersonRoleId_LEA = opr.OrganizationPersonRoleId
			,OrganizationId_LEA = oid.OrganizationId
		FROM Staging.Discipline d 
		JOIN ODS.PersonIdentifier pid 
			ON pid.Identifier = d.Student_Identifier_State
		JOIN ODS.OrganizationIdentifier oid 
			ON oid.Identifier = d.LEA_Identifier_State
		JOIN ODS.OrganizationPersonRole opr 
			ON pid.PersonId = opr.PersonId
			AND oid.OrganizationId = opr.OrganizationId
			AND d.DisciplinaryActionStartDate BETWEEN opr.EntryDate AND ISNULL(opr.ExitDate, GETDATE())
		WHERE 
			oid.RefOrganizationIdentificationSystemId = [App].[GetOrganizationIdentifierSystemId]('SEA', '001072')
			AND oid.RefOrganizationIdentifierTypeId = [App].[GetOrganizationIdentifierTypeId]('001072')
	END TRY

	BEGIN CATCH 
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Discipline', 'PersonId', 'S13EC100' 
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
		JOIN ODS.PersonIdentifier pid 
			ON pid.Identifier = d.Student_Identifier_State
		JOIN ODS.OrganizationIdentifier oid 
			ON oid.Identifier = d.School_Identifier_State
		JOIN ODS.OrganizationPersonRole opr 
			ON pid.PersonId = opr.PersonId
			AND oid.OrganizationId = opr.OrganizationId
			AND d.DisciplinaryActionStartDate BETWEEN opr.EntryDate AND ISNULL(opr.ExitDate, GETDATE())
		WHERE 
			oid.RefOrganizationIdentificationSystemId = [App].[GetOrganizationIdentifierSystemId]('SEA', '001073')
			AND oid.RefOrganizationIdentifierTypeId = [App].[GetOrganizationIdentifierTypeId]('001073')
	END TRY

	BEGIN CATCH 
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Discipline', 'PersonId', 'S13EC110' 
	END CATCH

	-------------------------------------------------------------------------------------------------
	----Merge School Incident records so that we don't create duplicate discipline entries accidentally ----
	-------------------------------------------------------------------------------------------------

	BEGIN TRY
	--LEA
		INSERT INTO ODS.Incident ( 
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
		LEFT JOIN ODS.Incident i
			ON d.IncidentIdentifier = i.IncidentIdentifier
			AND d.OrganizationPersonRoleId_LEA = i.OrganizationPersonRoleId
		LEFT JOIN ODS.SourceSystemReferenceData osssft
			ON d.WeaponType = osssft.InputCode
			AND osssft.TableName = 'RefFirearmType'
			AND osssft.SchoolYear = @SchoolYear
		LEFT JOIN ODS.RefFirearmType ft 
			ON osssft.OutputCode = ft.Code
		WHERE i.IncidentId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Incident', NULL, 'S13EC120' 
	END CATCH

	BEGIN TRY
		--School
		INSERT INTO ODS.Incident ( 
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
		LEFT JOIN ODS.Incident i
			ON d.IncidentIdentifier = i.IncidentIdentifier
			AND d.OrganizationPersonRoleId_School = i.OrganizationPersonRoleId
		LEFT JOIN ODS.SourceSystemReferenceData osssft
			ON d.WeaponType = osssft.InputCode
			AND osssft.TableName = 'RefFirearmType'
			AND osssft.SchoolYear = @SchoolYear
		LEFT JOIN ODS.RefFirearmType ft 
			ON osssft.OutputCode = ft.Code
		WHERE i.IncidentId IS NULL
	END TRY

	BEGIN CATCH 
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Incident', NULL, 'S13EC130' 
	END CATCH

	BEGIN TRY
		--LEA
		UPDATE Staging.Discipline
		SET IncidentId_LEA = i.IncidentId
		FROM ODS.Incident i
		JOIN Staging.Discipline d
			ON i.IncidentIdentifier = d.IncidentIdentifier
			AND i.OrganizationPersonRoleId = d.OrganizationPersonRoleId_LEA
	END TRY

	BEGIN CATCH 
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Discipline', 'IncidentId', 'S13EC140' 
	END CATCH

	BEGIN TRY
		--School
		UPDATE Staging.Discipline
		SET IncidentId_School = i.IncidentId
		FROM ODS.Incident i
		JOIN Staging.Discipline d
			ON i.IncidentIdentifier = d.IncidentIdentifier
			AND i.OrganizationPersonRoleId = d.OrganizationPersonRoleId_School
	END TRY

	BEGIN CATCH 
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Discipline', 'IncidentId', 'S13EC150' 
	END CATCH

	-------------------------------------------
	----Merge K12StudentDiscipline records ----
	-------------------------------------------
	-- We cannot update the records in K12StudentDiscipline without K12StudentDisciplineId, so we have to kill & fill the table 
	BEGIN TRY
	--LEA
		DELETE FROM [ODS].[K12StudentDiscipline]
		FROM [ODS].[K12StudentDiscipline] sd
		JOIN Staging.Discipline d
			ON sd.IncidentId = d.IncidentId_LEA
			AND sd.OrganizationPersonRoleId = d.OrganizationPersonRoleId_LEA
	END TRY

	BEGIN CATCH 
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentDiscipline', NULL, 'S13EC200' 
	END CATCH

	BEGIN TRY
		--School
		DELETE FROM [ODS].[K12StudentDiscipline]
		FROM [ODS].[K12StudentDiscipline] sd
		JOIN Staging.Discipline d
			ON sd.IncidentId = d.IncidentId_School
			AND sd.OrganizationPersonRoleId = d.OrganizationPersonRoleId_School
	END TRY

	BEGIN CATCH 
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentDiscipline', NULL, 'S13EC210' 
	END CATCH

	BEGIN TRY
		--LEA
		INSERT INTO [ODS].[K12StudentDiscipline]
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
		FROM ODS.Person p
		JOIN ODS.PersonIdentifier pid 
			ON p.PersonID = pid.PersonId
		JOIN Staging.Discipline d 
			ON pid.Identifier = d.Student_Identifier_State
		JOIN ODS.Incident i
			ON i.IncidentId = d.IncidentId_LEA
			AND d.OrganizationPersonRoleId_LEA = i.OrganizationPersonRoleId
		LEFT JOIN ods.SourceSystemReferenceData rddr
			ON d.DisciplineReason = rddr.InputCode
			AND rddr.TableName = 'RefDisciplineReason'
			AND rddr.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefDisciplineReason dr
			ON rddr.OutputCode = dr.Code
		LEFT JOIN ods.SourceSystemReferenceData rdda
			ON d.DisciplinaryActionTaken = rdda.InputCode
			AND rdda.TableName = 'RefDisciplinaryActionTaken'
			AND rdda.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefDisciplinaryActionTaken dat
			ON rdda.OutputCode = dat.Code
		LEFT JOIN ods.SourceSystemReferenceData rdiir
			ON d.IdeaInterimRemoval = rdiir.InputCode
			AND rdiir.TableName = 'RefIdeaInterimRemoval'
			AND rdiir.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefIdeaInterimRemoval iir
			ON rdiir.OutputCode = iir.Code
		LEFT JOIN ods.SourceSystemReferenceData rdiirr
			ON d.IdeaInterimRemovalReason = rdiirr.InputCode
			AND rdiirr.TableName = 'RefIDEAInterimRemovalReason'
			AND rdiirr.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefIdeaInterimRemovalReason iirr
			ON rdiirr.OutputCode = iirr.Code
		LEFT JOIN ods.SourceSystemReferenceData rdidm
			ON d.DisciplineMethodOfCwd = rdidm.InputCode
			AND rdidm.TableName = 'RefDisciplineMethodOfCwd'
			AND rdidm.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefDisciplineMethodOfCwd dm
			ON rdidm.OutputCode = dm.Code

		LEFT JOIN ods.SourceSystemReferenceData dismethod
			ON d.DisciplineMethodFirearm = dismethod.InputCode
			AND dismethod.TableName = 'RefDisciplineMethodFirearms'
			AND dismethod.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefDisciplineMethodFirearms gdismethod
			ON gdismethod.Code = dismethod.OutputCode

		LEFT JOIN ods.SourceSystemReferenceData IDEAdismethod
			ON d.IDEADisciplineMethodFirearm = IDEAdismethod.InputCode
			AND IDEAdismethod.TableName = 'RefIDEADisciplineMethodFirearm'
			AND IDEAdismethod.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefIDEADisciplineMethodFirearm gIDEAdismethod
			ON gIDEAdismethod.Code = IDEAdismethod.OutputCode

		WHERE pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075')
			AND d.OrganizationPersonRoleId_LEA IS NOT NULL
	END TRY

	BEGIN CATCH 
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentDiscipline', NULL, 'S13EC220' 
	END CATCH

	BEGIN TRY
		--School
		INSERT INTO [ODS].[K12StudentDiscipline]
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
		FROM ODS.Person p
		JOIN ODS.PersonIdentifier pid 
			ON p.PersonID = pid.PersonId
		JOIN Staging.Discipline d 
			ON pid.Identifier = d.Student_Identifier_State
		JOIN ODS.Incident i
			ON i.IncidentId = d.IncidentId_School
			AND d.OrganizationPersonRoleId_School = i.OrganizationPersonRoleId
		LEFT JOIN ods.SourceSystemReferenceData rddr
			ON d.DisciplineReason = rddr.InputCode
			AND rddr.TableName = 'RefDisciplineReason'
			AND rddr.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefDisciplineReason dr
			ON rddr.OutputCode = dr.Code
		LEFT JOIN ods.SourceSystemReferenceData rdda
			ON d.DisciplinaryActionTaken = rdda.InputCode
			AND rdda.TableName = 'RefDisciplinaryActionTaken'
			AND rdda.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefDisciplinaryActionTaken dat
			ON rdda.OutputCode = dat.Code
		LEFT JOIN ods.SourceSystemReferenceData rdiir
			ON d.IdeaInterimRemoval = rdiir.InputCode
			AND rdiir.TableName = 'RefIdeaInterimRemoval'
			AND rdiir.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefIdeaInterimRemoval iir
			ON rdiir.OutputCode = iir.Code
		LEFT JOIN ods.SourceSystemReferenceData rdiirr
			ON d.IdeaInterimRemovalReason = rdiirr.InputCode
			AND rdiirr.TableName = 'RefIDEAInterimRemovalReason'
			AND rdiirr.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefIdeaInterimRemovalReason iirr
			ON rdiirr.OutputCode = iirr.Code
		LEFT JOIN ods.SourceSystemReferenceData rdidm
			ON d.DisciplineMethodOfCwd = rdidm.InputCode
			AND rdidm.TableName = 'RefDisciplineMethodOfCwd'
			AND rdidm.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefDisciplineMethodOfCwd dm
			ON rdidm.OutputCode = dm.Code

		LEFT JOIN ods.SourceSystemReferenceData dismethod
			ON d.DisciplineMethodFirearm = dismethod.InputCode
			AND dismethod.TableName = 'RefDisciplineMethodFirearm'
			AND dismethod.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefDisciplineMethodFirearms gdismethod
			ON gdismethod.Code = dismethod.OutputCode

		LEFT JOIN ods.SourceSystemReferenceData IDEAdismethod
			ON d.IDEADisciplineMethodFirearm = IDEAdismethod.InputCode
			AND IDEAdismethod.TableName = 'RefIDEADisciplineMethodFirearm'
			AND IDEAdismethod.SchoolYear = @SchoolYear
		LEFT JOIN ods.RefIDEADisciplineMethodFirearm gIDEAdismethod
			ON gIDEAdismethod.Code = IDEAdismethod.OutputCode

		WHERE pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075')
			AND d.OrganizationPersonRoleId_School IS NOT NULL
	END TRY

	BEGIN CATCH 
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentDiscipline', NULL, 'S13EC230' 
	END CATCH

	--------------------------------------------------------------------------------------------------
	---- Update Educational Services After Removal based on Disciplinary Action Taken If NULL Value --
	--------------------------------------------------------------------------------------------------

	BEGIN TRY
		UPDATE ODS.K12StudentDiscipline
		SET EducationalServicesAfterRemoval = 1
		FROM ODS.K12StudentDiscipline ksd
		JOIN ODS.RefDisciplinaryActionTaken dat 
			ON ksd.RefDisciplinaryActionTakenId = dat.RefDisciplinaryActionTakenId
		WHERE dat.Code IN ('03086', '03101')
		AND ksd.EducationalServicesAfterRemoval IS NULL
	END TRY

	BEGIN CATCH 
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentDiscipline', 'EducationalServicesAfterRemoval', 'S13EC240' 
	END CATCH

	BEGIN TRY
		UPDATE ODS.K12StudentDiscipline 
		SET EducationalServicesAfterRemoval = 0 
		WHERE EducationalServicesAfterRemoval IS NULL
	END TRY

	BEGIN CATCH 
		EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentDiscipline', 'EducationalServicesAfterRemoval', 'S13EC250' 
	END CATCH

	set nocount off;
END

