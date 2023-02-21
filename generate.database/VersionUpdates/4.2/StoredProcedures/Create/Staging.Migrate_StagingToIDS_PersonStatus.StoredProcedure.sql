CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_PersonStatus]
	@SchoolYear SMALLINT = NULL
AS

	/*************************************************************************************************************
	Date Created:  7/9/2018

	Purpose:
		The purpose of this ETL is to load the data for end of year Statuses for Persons

	Assumptions:
        
	Account executed under: LOGIN

	Approximate run time:  ~ 5 seconds

	Data Sources: 

	Data Targets:  Generate Database:   Generate

	Return Values:
    		0	= Success
  
	Example Usage: 
		EXEC Staging.[Migrate_StagingToIDS_PersonStatus] 2018;
    
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
				AND b.DataMigrationTypeCode = 'ODS'
		END 

        ---------------------------------------------------
        --- Declare Error Handling Variables           ----
        ---------------------------------------------------
		DECLARE @eStoredProc			varchar(100) = 'Migrate_StagingToIDS_PersonStatus'

        ---------------------------------------------------
        --- Declare Temporary Variables                ----
        ---------------------------------------------------
        DECLARE
			 @MembershipDate DATE
			,@RecordStartDateTime DATETIME
			,@RecordEndDateTime DATETIME
			,@SpecialEdProgramTypeId INT

        ------------------------------------------------------------
        --- Populate temp code table lookup variables           ----
        ------------------------------------------------------------

		SET @RecordStartDateTime = Staging.GetFiscalYearStartDate(@SchoolYear)
		SET @RecordEndDateTime = Staging.GetFiscalYearEndDate(@SchoolYear)
		SET @SpecialEdProgramTypeId = (SELECT RefProgramTypeId FROM dbo.RefProgramType WHERE Code = '04888')

		SET @MembershipDate = ISNULL(
		(
			SELECT CONVERT(DATE, (LEFT(tr.ResponseValue, 5) + '/' + CAST(@SchoolYear - 1 AS VARCHAR))) 
			FROM App.ToggleQuestions tq
				JOIN App.ToggleResponses tr 
					ON tq.ToggleQuestionId = tr.ToggleQuestionId
			WHERE EmapsQuestionAbbrv = 'CHDCTDTE' 
		), 'XX');

		---Need to consider what to do when/if the dates are not populated for the status - do we default those.  Those are built into the queries below looking for matches
		--If assessments, we could pull from the assessment administration start date.  Otherwise, they will need to fill those dates in for appropriate reporting.

		-------------------------------------------------------
		---Default start and end dates if not provided --------
		-------------------------------------------------------

		BEGIN TRY
		
				UPDATE ps SET EconomicDisadvantage_StatusStartDate = Staging.GetFiscalYearStartDate(dc.DataCollectionSchoolYear), 
				EconomicDisadvantage_StatusEndDate = NULL 
				FROM Staging.PersonStatus ps join dbo.DataCollection dc ON ps.DataCollectionName=dc.DataCollectionName 
				WHERE EconomicDisadvantage_StatusStartDate IS NULL AND EconomicDisadvantageStatus IS NOT NULL
									
				UPDATE ps SET FosterCare_ProgramParticipationStartDate = Staging.GetFiscalYearStartDate(dc.DataCollectionSchoolYear), 
				FosterCare_ProgramParticipationEndDate = NULL 
				FROM Staging.PersonStatus ps join dbo.DataCollection dc ON ps.DataCollectionName=dc.DataCollectionName 
				WHERE FosterCare_ProgramParticipationStartDate IS NULL AND ProgramType_FosterCare IS NOT NULL
									
				UPDATE ps SET Section504_ProgramParticipationStartDate = Staging.GetFiscalYearStartDate(dc.DataCollectionSchoolYear), 
				Section504_ProgramParticipationEndDate = NULL 
				FROM Staging.PersonStatus ps join dbo.DataCollection dc ON ps.DataCollectionName=dc.DataCollectionName 
				WHERE Section504_ProgramParticipationStartDate IS NULL AND ProgramType_Section504 IS NOT NULL
									
				UPDATE ps SET Immigrant_ProgramParticipationStartDate = Staging.GetFiscalYearStartDate(dc.DataCollectionSchoolYear), 
				Immigrant_ProgramParticipationEndDate = NULL 
				FROM Staging.PersonStatus ps join dbo.DataCollection dc ON ps.DataCollectionName=dc.DataCollectionName 
				WHERE Immigrant_ProgramParticipationStartDate IS NULL AND ProgramType_Immigrant IS NOT NULL
									
				UPDATE ps SET Homelessness_StatusStartDate = Staging.GetFiscalYearStartDate(dc.DataCollectionSchoolYear), 
				Homelessness_StatusEndDate = NULL 
				FROM Staging.PersonStatus ps join dbo.DataCollection dc ON ps.DataCollectionName=dc.DataCollectionName 
				WHERE Homelessness_StatusStartDate IS NULL AND HomelessnessStatus IS NOT NULL

				UPDATE ps SET Migrant_StatusStartDate = Staging.GetFiscalYearStartDate(dc.DataCollectionSchoolYear), Migrant_StatusEndDate = NULL 
				FROM Staging.PersonStatus ps join dbo.DataCollection dc ON ps.DataCollectionName=dc.DataCollectionName 
				WHERE Migrant_StatusStartDate IS NULL AND MigrantStatus IS NOT NULL
									
				UPDATE ps SET EnglishLearner_StatusStartDate = Staging.GetFiscalYearStartDate(dc.DataCollectionSchoolYear), 
				EnglishLearner_StatusEndDate = NULL 
				FROM Staging.PersonStatus ps join dbo.DataCollection dc ON ps.DataCollectionName=dc.DataCollectionName 
				WHERE EnglishLearner_StatusStartDate IS NULL AND EnglishLearnerStatus IS NOT NULL
									
				UPDATE Staging.PersonStatus 
				SET   PerkinsLEPStatus_StatusStartDate = Staging.GetFiscalYearStartDate(@SchoolYear)
					, PerkinsLEPStatus_StatusEndDate = NULL 
				WHERE PerkinsLEPStatus_StatusStartDate IS NULL 
					AND PerkinsLEPStatus IS NOT NULL
			
				UPDATE ps SET IDEA_StatusStartDate = Staging.GetFiscalYearStartDate(dc.DataCollectionSchoolYear), IDEA_StatusEndDate = NULL 
				FROM Staging.PersonStatus ps join dbo.DataCollection dc ON ps.DataCollectionName=dc.DataCollectionName 
				WHERE IDEA_StatusStartDate IS NULL AND IDEAIndicator IS NOT NULL
									
				UPDATE ps SET MilitaryConnected_StatusStartDate = Staging.GetFiscalYearStartDate(dc.DataCollectionSchoolYear), 
				MilitaryConnected_StatusEndDate = NULL 
				FROM Staging.PersonStatus ps join dbo.DataCollection dc ON ps.DataCollectionName=dc.DataCollectionName 
				WHERE MilitaryConnected_StatusStartDate IS NULL AND MilitaryConnectedStudentIndicator IS NOT NULL	

		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', NULL, 'S05EC100' 
		END CATCH

		---------------------------------------------------------------
		---Associate the DataCollectionId with the temporary table ----
		---------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET DataCollectionId = dc.DataCollectionId
			FROM Staging.PersonStatus ps
			JOIN dbo.DataCollection dc
				ON ps.DataCollectionName = dc.DataCollectionName
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonID', 'S05EC110' 
		END CATCH


		--------------------------------------------------------------------
		---Associate the LEA OrganizationId with the temporary table ----
		--------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_LEA = orgid.OrganizationId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationIdentifier orgid 
				ON ps.LEA_Identifier_State = orgid.Identifier
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
			WHERE orgid.RefOrganizationIdentifierTypeId = Staging.GetOrganizationIdentifierTypeId('001072')
				AND orgid.RefOrganizationIdentificationSystemId = Staging.GetOrganizationIdentifierSystemId('SEA', '001072')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_LEA', 'S05EC120' 
		END CATCH

		--------------------------------------------------------------------
		---Associate the School OrganizationId with the temporary table ----
		--------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_School = orgid.OrganizationId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationIdentifier orgid 
				ON ps.School_Identifier_State = orgid.Identifier
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
			WHERE orgid.RefOrganizationIdentifierTypeId = Staging.GetOrganizationIdentifierTypeId('001073')
				AND orgid.RefOrganizationIdentificationSystemId = Staging.GetOrganizationIdentifierSystemId('SEA', '001073')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_School', 'S05EC130' 
		END CATCH
		
		-------------------------------------------------------
		---Associate the PersonId with the temporary table ----
		-------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET PersonID = pid.PersonId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonIdentifier pid 
				ON ps.Student_Identifier_State = pid.Identifier
			JOIN dbo.OrganizationPersonRole opr
				ON pid.PersonId = opr.PersonId
				AND ISNULL(ps.OrganizationId_School, ps.OrganizationId_Lea) = opr.OrganizationId
			WHERE pid.RefPersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001075')
				AND pid.RefPersonalInformationVerificationId = Staging.GetRefPersonalInformationVerificationId('01011')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonID', 'S05EC110' 
		END CATCH

		--------------------------------------------------------
		---Get the Student -> LEA OrganizationPersonRoleId  ----
		--------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_LEA = opr.OrganizationId
				AND opr.RoleId = Staging.GetRoleId('K12 Student')
			WHERE opr.EntryDate >= Staging.GetFiscalYearStartDate(@SchoolYear)
				AND (opr.ExitDate IS NULL OR opr.ExitDate <= Staging.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA', 'S05EC124' 
		END CATCH

		-----------------------------------------------------------
		---Get the Student -> School OrganizationPersonRoleId  ----
		-----------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_School = opr.OrganizationId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND opr.RoleId = Staging.GetRoleId('K12 Student')
			WHERE opr.EntryDate >= Staging.GetFiscalYearStartDate(@SchoolYear)
				AND (opr.ExitDate IS NULL OR opr.ExitDate <= Staging.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School', 'S05EC134' 
		END CATCH

		--------------------------------------------------------------------------------
		---Associate the LEA Foster Program OrganizationId with the temporary table ----
		--------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_LEA_Program_Foster = orgr.OrganizationId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationRelationship orgr 
				ON ps.OrganizationID_LEA = orgr.Parent_OrganizationId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgr.OrganizationId = orgpt.OrganizationId
				AND ISNULL(orgr.DataCollectionId, '') = ISNULL(orgpt.DataCollectionId, '')
			WHERE orgpt.RefProgramTypeId = Staging.GetProgramTypeId('75000')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_Program_Foster', 'S05EC140' 
		END CATCH

		-----------------------------------------------------------------------------------
		---Associate the School Foster Program OrganizationId with the temporary table ----
		-----------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_School_Program_Foster = orgr.OrganizationId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationRelationship orgr 
				ON ps.OrganizationID_School = orgr.Parent_OrganizationId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgr.OrganizationId = orgpt.OrganizationId
				AND ISNULL(orgr.DataCollectionId, '') = ISNULL(orgpt.DataCollectionId, '')
			WHERE orgpt.RefProgramTypeId = Staging.GetProgramTypeId('75000')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_Program_Foster', 'S05EC150' 
		END CATCH

		--=====================================================================================================================
		--------------------------------------------------------------------------------
		---Associate the LEA Homeless Program OrganizationId with the staging table ----
		--------------------------------------------------------------------------------
		
		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_LEA_Program_Homeless = orgr.OrganizationId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationRelationship orgr 
				ON ps.OrganizationID_LEA = orgr.Parent_OrganizationId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgr.OrganizationId = orgpt.OrganizationId
				AND ISNULL(orgr.DataCollectionId, '') = ISNULL(orgpt.DataCollectionId, '')
			WHERE orgpt.RefProgramTypeId = Staging.GetProgramTypeId('76000')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_Program_Foster', 'S05EC140' 
		END CATCH

		-----------------------------------------------------------------------------------
		---Associate the School Homeless Program OrganizationId with the staging table ----
		-----------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_School_Program_Homeless = orgr.OrganizationId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationRelationship orgr 
				ON ps.OrganizationID_School = orgr.Parent_OrganizationId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgr.OrganizationId = orgpt.OrganizationId
				AND ISNULL(orgr.DataCollectionId, '') = ISNULL(orgpt.DataCollectionId, '')
			WHERE orgpt.RefProgramTypeId = Staging.GetProgramTypeId('76000')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_Program_Foster', 'S05EC150' 
		END CATCH

		----------------------------------------------------------------------------------
		---Associate the LEA Section504 Program OrganizationId with the staging table ----
		----------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_LEA_Program_Section504 = orgr.OrganizationId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationRelationship orgr 
				ON ps.OrganizationID_LEA = orgr.Parent_OrganizationId
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgr.OrganizationId = orgpt.OrganizationId
			WHERE orgpt.RefProgramTypeId = Staging.GetProgramTypeId('04967')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_LEA_Program_Section504', 'S05EC200' 
		END CATCH

		-------------------------------------------------------------------------------------
		---Associate the School Section504 Program OrganizationId with the staging table ----
		-------------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_School_Program_Section504 = orgr.OrganizationId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationRelationship orgr 
				ON ps.OrganizationID_School = orgr.Parent_OrganizationId
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgr.OrganizationId = orgpt.OrganizationId
			WHERE orgpt.RefProgramTypeId = Staging.GetProgramTypeId('04967')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_School_Program_Section504', 'S05EC210' 
		END CATCH

		----------------------------------------------------------------------------------
		---Associate the LEA Immigrant Program OrganizationId with the staging table ----
		----------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_LEA_Program_Immigrant = orgr.OrganizationId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationRelationship orgr 
				ON ps.OrganizationID_LEA = orgr.Parent_OrganizationId
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgr.OrganizationId = orgpt.OrganizationId
			WHERE orgpt.RefProgramTypeId = Staging.GetProgramTypeId('04957')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_LEA_Program_Immigrant', 'S05EC220' 
		END CATCH

		-------------------------------------------------------------------------------------
		---Associate the School Immigrant Program OrganizationId with the staging table ----
		-------------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_School_Program_Immigrant = orgr.OrganizationId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationRelationship orgr 
				ON ps.OrganizationID_School = orgr.Parent_OrganizationId
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgr.OrganizationId = orgpt.OrganizationId
			WHERE orgpt.RefProgramTypeId = Staging.GetProgramTypeId('77000')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_School_Program_Immigrant', 'S05EC230' 
		END CATCH

		--=====================================================================================================================

		-----------------------------------------------------
		----PersonStatus EconomicDisadvantage ---------------
		-----------------------------------------------------

		BEGIN TRY
			----First check to see IF PersonStatusId -- EconomicDisadvantage EXISTS so that it IS NOT created again
			UPDATE Staging.PersonStatus
			SET PersonStatusId_EconomicDisadvantage = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(pers.DataCollectionId, '')
				AND pers.StatusStartDate = ps.EconomicDisadvantage_StatusStartDate
				AND pers.StatusEndDate = ps.EconomicDisadvantage_StatusEndDate
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'EconomicDisadvantage')
			WHERE ps.PersonStatusId_EconomicDisadvantage IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_EconomicDisadvantage', 'S05EC160' 
		END CATCH


		BEGIN TRY
			----Create PersonStatus -- EconomicDisadvantage
			INSERT INTO [dbo].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate]
					   ,[DataCollectionId])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,(SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'EconomicDisadvantage') [RefPersonStatusTypeId]
					   ,ps.EconomicDisadvantageStatus [StatusValue]
					   ,ps.EconomicDisadvantage_StatusStartDate [StatusStartDate]
					   ,ps.EconomicDisadvantage_StatusEndDate [StatusEndDate]
					   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			WHERE ps.PersonStatusId_EconomicDisadvantage IS NULL
			AND ps.EconomicDisadvantageStatus IS NOT NULL
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonStatus', NULL, 'S05EC170' 
		END CATCH

		BEGIN TRY
			----UPDATE the Staging table with the PersonStatus -- EconomicDisadvantage ID
			UPDATE Staging.PersonStatus
			SET PersonStatusId_EconomicDisadvantage = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(pers.DataCollectionId, '')
				AND pers.StatusStartDate = ps.EconomicDisadvantage_StatusStartDate
				AND ISNULL(pers.StatusEndDate,'01/01/1900') = ISNULL(ps.EconomicDisadvantage_StatusEndDate,'01/01/1900')
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'EconomicDisadvantage')
			WHERE ps.PersonStatusId_EconomicDisadvantage IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', NULL, 'S05EC180' 
		END CATCH



		-----------------------------------------------------
		----PersonStatus Homeless -------------------------------
		-----------------------------------------------------

		BEGIN TRY
			----First check to see IF PersonStatusId -- Homeless EXISTS so that it IS NOT created again
			UPDATE Staging.PersonStatus
			SET PersonStatusId_Homeless = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(pers.DataCollectionId, '')
				AND pers.StatusStartDate = ps.Homelessness_StatusStartDate
				AND ISNULL(pers.StatusEndDate,'01/01/1900') = ISNULL(ps.Homelessness_StatusEndDate,'01/01/1900')
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'Homeless')
			WHERE ps.PersonStatusId_Homeless IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_Homeless', 'S05EC190' 
		END CATCH

		BEGIN TRY
			----Create PersonStatus -- Homeless
			INSERT INTO [dbo].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate]
					   ,[DataCollectionId])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,(SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'Homeless') [RefPersonStatusTypeId]
					   ,ps.HomelessnessStatus [StatusValue]
					   ,ps.Homelessness_StatusStartDate [StatusStartDate]
					   ,ps.Homelessness_StatusEndDate [StatusEndDate]
					   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			WHERE ps.PersonStatusId_Homeless IS NULL
			AND ps.HomelessnessStatus IS NOT NULL
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonStatus', NULL, 'S05EC200' 
		END CATCH


		BEGIN TRY
			----UPDATE the Staging table with the PersonStatus -- Homeless ID
			UPDATE Staging.PersonStatus
			SET PersonStatusId_Homeless = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(pers.DataCollectionId, '')
				AND pers.StatusStartDate = ps.Homelessness_StatusStartDate
				AND ISNULL(pers.StatusEndDate,'01/01/1900') = ISNULL(ps.Homelessness_StatusEndDate,'01/01/1900')
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'Homeless')
			WHERE ps.PersonStatusId_Homeless IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_Homeless', 'S05EC210' 
		END CATCH

		------------------------------------------------------------
        --- INSERT PersonHomelessness Records -- Students       ----
        ------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET PersonHomelessNightTimeResidenceId = pers.PersonId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonHomelessness pers 
				ON ps.PersonId = pers.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(pers.DataCollectionId, '')
			WHERE ps.PersonHomelessNightTimeResidenceId IS NULL	
			AND pers.RecordStartDateTime = ps.HomelessNightTimeResidence_StartDate
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonHomelessNightTimeResidenceId', 'S05EC220' 
		END CATCH

		BEGIN TRY
			INSERT dbo.PersonHomelessness (
				PersonId
				,HomelessnessStatus
				,RefHomelessNighttimeResidenceId
				,RecordStartDateTime
				,RecordEndDateTime
				,DataCollectionId
			)
			SELECT DISTINCT
				 ps.PersonId
				,1
				,ntri.RefHomelessNighttimeResidenceId
				,ps.HomelessNightTimeResidence_StartDate
				,ps.HomelessNightTimeResidence_EndDate
				,ps.DataCollectionId
			FROM Staging.PersonStatus ps 
			JOIN [Staging].[SourceSystemReferenceData] nighttime 
				ON ps.HomelessNightTimeResidence = nighttime.InputCode
				AND nighttime.TableName = 'RefHomelessNighttimeResidence'
				AND nighttime.SchoolYear = @SchoolYear
			JOIN dbo.RefHomelessNighttimeResidence ntri 
				ON nighttime.OutputCode = ntri.Code

		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonHomelessness', NULL, 'S05EC230' 
		END CATCH

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET PersonHomelessNightTimeResidenceId = pers.PersonId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonHomelessness pers 
				ON ps.PersonId = pers.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(pers.DataCollectionId, '')
			WHERE ps.PersonHomelessNightTimeResidenceId IS NULL	
			AND pers.RecordStartDateTime = ps.HomelessNightTimeResidence_StartDate
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonHomelessNightTimeResidenceId', 'S05EC240' 
		END CATCH

		BEGIN TRY
			----Create PersonStatus -- HomelessUnaccompaniedYouth
			INSERT INTO [dbo].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate]
					   ,[DataCollectionId])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,(SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE code = 'HomelessUnaccompaniedYouth') [RefPersonStatusTypeId]
					   ,1 [StatusValue]
					   ,ps.HomelessNightTimeResidence_StartDate [StatusStartDate]
					   ,ps.HomelessNightTimeResidence_EndDate [StatusEndDate]
					   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			WHERE ps.PersonId IS NOT NULL AND ps.HomelessUnaccompaniedYouth = 1
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonStatus', NULL, 'S05EC250' 
		END CATCH


		-----------------------------------------------------
		----PersonStatus Migrant -------------------------------
		-----------------------------------------------------

		BEGIN TRY
			----First check to see IF PersonStatusId -- Migrant EXISTS so that it IS NOT created again
			UPDATE Staging.PersonStatus
			SET PersonStatusId_Migrant = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(pers.DataCollectionId, '')
				AND pers.StatusStartDate = ps.Migrant_StatusStartDate
				AND ISNULL(pers.StatusEndDate,'01/01/1900') = ISNULL(ps.Migrant_StatusEndDate,'01/01/1900')
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'Migrant')
			WHERE ps.PersonStatusId_Migrant IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_Migrant', 'S05EC260' 
		END CATCH

		BEGIN TRY
			----Create PersonStatus -- Migrant
			INSERT INTO [dbo].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate]
					   ,[DataCollectionId])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,(SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'Migrant') [RefPersonStatusTypeId]
					   ,ps.MigrantStatus [StatusValue]
					   ,ps.Migrant_StatusStartDate [StatusStartDate]
					   ,ps.Migrant_StatusEndDate [StatusEndDate]
					   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			WHERE ps.PersonStatusId_Migrant IS NULL
			AND ps.MigrantStatus IS NOT NULL
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonStatus', NULL, 'S05EC270' 
		END CATCH

		BEGIN TRY
			----UPDATE the Staging table with the PersonStatus -- Migrant ID
			UPDATE Staging.PersonStatus
			SET PersonStatusId_Migrant = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(pers.DataCollectionId, '')
				AND pers.StatusStartDate = ps.Migrant_StatusStartDate
				AND ISNULL(pers.StatusEndDate,'01/01/1900') = ISNULL(ps.Migrant_StatusEndDate,'01/01/1900')
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'Migrant')
			WHERE ps.PersonStatusId_Migrant IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_Migrant', 'S05EC280' 
		END CATCH

		-----------------------------------------------------
		----PersonStatus EnglishLearnerStatus -------------
		-----------------------------------------------------

		BEGIN TRY
			----First check to see IF PersonStatusId -- EnglishLearnerStatus EXISTS so that it IS NOT created again
			UPDATE Staging.PersonStatus
			SET PersonStatusId_EnglishLearner = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(pers.DataCollectionId, '')
				AND pers.StatusStartDate = ps.EnglishLearner_StatusStartDate
				AND ISNULL(pers.StatusEndDate,'01/01/1900') = ISNULL(ps.EnglishLearner_StatusEndDate,'01/01/1900')
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'LEP')
			WHERE ps.PersonStatusId_EnglishLearner IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_EnglishLearner', 'S05EC290' 
		END CATCH

		BEGIN TRY
			----Create PersonStatus -- EnglishLearnerStatus
			Declare  @RefPersonStatusTypeLEPId INT
			SELECT @RefPersonStatusTypeLEPId = RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'LEP'
			INSERT INTO [dbo].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate]
					   ,[DataCollectionId])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,@RefPersonStatusTypeLEPId [RefPersonStatusTypeId]
					   ,ps.EnglishLearnerStatus [StatusValue]
					   ,ps.EnglishLearner_StatusStartDate [StatusStartDate]
					   ,ps.EnglishLearner_StatusEndDate [StatusEndDate]
					   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			LEFT JOIN [dbo].[PersonStatus] ps1 
			ON ps1.PersonId = ps.PersonId 
				AND ISNULL(ps1.DataCollectionId, '') = ISNULL(ps.DataCollectionId, '')
				AND ps1.[RefPersonStatusTypeId] = @RefPersonStatusTypeLEPId 
				AND ps1.StatusValue = ps.EnglishLearnerStatus 
				AND ps1.StatusStartDate = ps.EnglishLearner_StatusStartDate
			WHERE ps.PersonStatusId_EnglishLearner IS NULL
			AND ps.EnglishLearnerStatus IS NOT NULL
			AND ps.PersonId IS NOT NULL
			AND ps1.PersonStatusId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonStatus', NULL, 'S05EC300' 
		END CATCH

		BEGIN TRY
			----Update the Staging table with the PersonStatus -- EnglishLearnerStatus ID
			UPDATE Staging.PersonStatus
			SET PersonStatusId_EnglishLearner = pers.PersonStatusId
			FROM Staging.PersonStatus ps
				JOIN dbo.PersonStatus pers 
					ON ps.PersonId = pers.PersonId
					AND pers.StatusStartDate = ps.EnglishLearner_StatusStartDate
					AND ISNULL(pers.StatusEndDate,'01/01/1900') = ISNULL(ps.EnglishLearner_StatusEndDate,'01/01/1900')
					AND pers.RefPersonStatusTypeId = @RefPersonStatusTypeLEPId
			WHERE ps.PersonStatusId_EnglishLearner IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_EnglishLearner', 'S05EC390' 
		END CATCH

		-----------------------------------------------------
		----PersonStatus PerkinsLEP -------------
		-----------------------------------------------------

		BEGIN TRY
			Declare  @RefPersonStatusTypeLEPPId INT
			----First check to see if PersonStatusId -- Perkins LEP exists so that it is not created again
			UPDATE Staging.PersonStatus
			SET PersonStatusId_PerkinsLEP = pers.PersonStatusId
			FROM Staging.PersonStatus ps
				JOIN dbo.PersonStatus pers 
					ON ps.PersonId = pers.PersonId
					AND pers.StatusStartDate = ps.PerkinsLEPStatus_StatusStartDate
					AND ISNULL(pers.StatusEndDate,'01/01/1900') = ISNULL(ps.PerkinsLEPStatus_StatusEndDate,'01/01/1900')
					AND pers.RefPersonStatusTypeId = @RefPersonStatusTypeLEPPId
			WHERE ps.PersonStatusId_EnglishLearner IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_PerkinsLEP', 'S05EC395' 
		END CATCH

		BEGIN TRY
			----Create PersonStatus -- PerkinsLEPStatus
			
			SELECT @RefPersonStatusTypeLEPPId = RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'Perkins LEP'
			INSERT INTO [dbo].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate]
					   ,[DataCollectionId])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,@RefPersonStatusTypeLEPPId [RefPersonStatusTypeId]
					   ,ps.PerkinsLEPStatus [StatusValue]
					   ,ps.PerkinsLEPStatus_StatusStartDate [StatusSt0artDate]
					   ,ps.PerkinsLEPStatus_StatusEndDate [StatusEndDate]
					   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			JOIN dbo.RefPersonStatusType st 
				ON st.Code = ps.PerkinsLEPStatus
			LEFT JOIN [dbo].[PersonStatus] ps1 
				ON ps1.PersonId = ps.PersonId 
				AND ps1.[RefPersonStatusTypeId] = @RefPersonStatusTypeLEPPId 
				AND ps1.StatusValue = ps.PerkinsLEPStatus 
				AND ps1.StatusStartDate = ps.PerkinsLEPStatus_StatusStartDate
			WHERE ps.PersonStatusId_PerkinsLEP IS NULL
				AND ps.PerkinsLEPStatus IS NOT NULL
				AND ps.PersonId IS NOT NULL
				AND ps1.PersonStatusId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonStatus', NULL, 'S05EC305' 
		END CATCH

		BEGIN TRY
			----UPDATE the Staging table with the PersonStatus -- EnglishLearnerStatus ID
			UPDATE Staging.PersonStatus
			SET PersonStatusId_EnglishLearner = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(pers.DataCollectionId, '')
				AND pers.StatusStartDate = ps.EnglishLearner_StatusStartDate
				AND ISNULL(pers.StatusEndDate, '01/01/1900') = ISNULL(ps.EnglishLearner_StatusEndDate, '01/01/1900')
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'LEP')
			WHERE ps.PersonStatusId_EnglishLearner IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_EnglishLearner', 'S05EC310' 
		END CATCH


		-------------------------------------------------------
		------PersonStatus PerkinsLEP -------------
		-------------------------------------------------------

		--BEGIN TRY
		--	Declare  @RefPersonStatusTypeLEPPId INT
		--	----First check to see if PersonStatusId -- Perkins LEP exists so that it is not created again
		--	UPDATE Staging.PersonStatus
		--	SET PersonStatusId_PerkinsLEP = pers.PersonStatusId
		--	FROM Staging.PersonStatus ps
		--		JOIN dbo.PersonStatus pers 
		--			ON ps.PersonId = pers.PersonId
		--			AND pers.StatusStartDate = ps.PerkinsLEPStatus_StatusStartDate
		--			AND ISNULL(pers.StatusEndDate,'01/01/1900') = ISNULL(ps.PerkinsLEPStatus_StatusEndDate,'01/01/1900')
		--			AND pers.RefPersonStatusTypeId = @RefPersonStatusTypeLEPPId
		--	WHERE ps.PersonStatusId_EnglishLearner IS NULL
		--END TRY

		--BEGIN CATCH 
		--	EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_PerkinsLEP', 'S05EC395' 
		--END CATCH

		--BEGIN TRY
		--	----Create PersonStatus -- PerkinsLEPStatus
			
		--	SELECT @RefPersonStatusTypeLEPPId = RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'Perkins LEP'
		--	INSERT INTO [dbo].[PersonStatus]
		--			   ([PersonId]
		--			   ,[RefPersonStatusTypeId]
		--			   ,[StatusValue]
		--			   ,[StatusStartDate]
		--			   ,[StatusEndDate])
		--	SELECT DISTINCT
		--				ps.PersonId							[PersonId]
		--			   ,@RefPersonStatusTypeLEPPId			[RefPersonStatusTypeId]
		--			   ,ps.PerkinsLEPStatus					[StatusValue]
		--			   ,ps.PerkinsLEPStatus_StatusStartDate [StatusStartDate]
		--			   ,ps.PerkinsLEPStatus_StatusEndDate	[StatusEndDate]
		--	FROM Staging.PersonStatus ps
		--		LEFT JOIN [dbo].[PersonStatus] ps1 
		--			ON ps1.PersonId = ps.PersonId 
		--			AND ps1.[RefPersonStatusTypeId] = @RefPersonStatusTypeLEPPId 
		--			AND ps1.StatusValue = ps.PerkinsLEPStatus 
		--			AND ps1.StatusStartDate = ps.PerkinsLEPStatus_StatusStartDate
		--	WHERE ps.PersonStatusId_PerkinsLEP IS NULL
		--	AND ps.PerkinsLEPStatus = 1
		--	AND ps.PersonId IS NOT NULL
		--	AND ps1.PersonStatusId IS NULL

		--END TRY

		--BEGIN CATCH 
		--	EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonStatus', NULL, 'S05EC400' 
		--END CATCH

		--BEGIN TRY
		--	----Update the Staging table with the PersonStatus -- PerkinsLEPStatus ID
		--	UPDATE Staging.PersonStatus
		--	SET PersonStatusId_PerkinsLEP = pers.PersonStatusId
		--	FROM Staging.PersonStatus ps
		--		JOIN dbo.PersonStatus pers 
		--			ON ps.PersonId = pers.PersonId
		--			AND pers.StatusStartDate = ps.PerkinsLEPStatus_StatusStartDate
		--			AND ISNULL(pers.StatusEndDate,'01/01/1900') = ISNULL(ps.PerkinsLEPStatus_StatusEndDate,'01/01/1900')
		--			AND pers.RefPersonStatusTypeId = @RefPersonStatusTypeLEPPId
		--	WHERE ps.PersonStatusId_PerkinsLEP IS NULL
		--END TRY

		--BEGIN CATCH 
		--	EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_PerkinsLEP', 'S05EC405' 
		--END CATCH

	
		---------------------------------------------------------------
		---Associate the PersonLanguageId with the temporary table ----
		---------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET PersonLanguageId = pl.PersonLanguageId
			FROM Staging.PersonStatus mcc
			JOIN dbo.PersonLanguage pl 
				ON mcc.PersonID = pl.PersonId
				AND ISNULL(mcc.DataCollectionId, '') = ISNULL(pl.DataCollectionId, '')
			JOIN [Staging].[SourceSystemReferenceData] rd
				ON mcc.ISO_639_2_NativeLanguage = rd.InputCode
				AND rd.TableName = 'RefLanguage'
				AND rd.SchoolYear = @SchoolYear
			JOIN dbo.RefLanguage rl
				ON rd.OutputCode = rl.Code
			JOIN dbo.RefLanguageUseType rlut 
				ON rlut.Code = 'Native'
			WHERE mcc.PersonID IS NOT NULL
				AND rl.RefLanguageId = pl.RefLanguageId
			--AND pl.RecordEndDateTime IS NULL --This requires a Generate UPDATE to include the RecordStart/End IN this table

		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonLanguageId', 'S05EC410' 
		END CATCH

		---------------------------------------------------
		---Insert Language into dbo.PersonLanguage ----
		---------------------------------------------------

		--This can be uncommented when the RecordEndDateTime has been added to the PersonLanguage table
		--UPDATE dbo.PersonLanguage
		--SET RecordEndDateTime = Staging.GetFiscalYearEndDate(@SchoolYear-1)
		--FROM Staging.PersonStatus mcc
		--JOIN dbo.PersonLanguage pl 
		--	ON mcc.PersonID = pl.PersonId
		--WHERE pl.RecordEndDateTime IS NULL
		--AND mcc.PersonLanguageId IS NULL

		BEGIN TRY
			--Need to add the RecordStart/EndDateTime INTO this WHEN it IS added INTO Generate.
			INSERT INTO [dbo].[PersonLanguage]
			   ([PersonId]
			   ,[RefLanguageId]
			   ,[RefLanguageUseTypeId]
			   ,[DataCollectionId])
			SELECT
				PersonID [PersonId]
			   ,rl.RefLanguageId [RefLanguageId]
			   ,rlut.RefLanguageUseTypeId [RefLanguageUseTypeId]
			   ,mcc.DataCollectionId
			FROM Staging.PersonStatus mcc
			JOIN [Staging].[SourceSystemReferenceData] rd
				ON mcc.ISO_639_2_NativeLanguage = rd.InputCode
				AND rd.TableName = 'RefLanguage'
				AND rd.SchoolYear = @SchoolYear
			JOIN dbo.RefLanguage rl
				ON rd.OutputCode = rl.Code
			JOIN dbo.RefLanguageUseType rlut 
				ON rlut.Code = 'Native'
			WHERE mcc.ISO_639_2_NativeLanguage IS NOT NULL
				AND mcc.PersonID IS NOT NULL

		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonLanguage', NULL, 'S05EC420' 
		END CATCH


		-----------------------------------------------------
		----PersonStatus IDEA -------------------------------
		-----------------------------------------------------

		BEGIN TRY
			----First check to see IF PersonStatusId -- IDEA EXISTS so that it IS NOT created again
			UPDATE Staging.PersonStatus
			SET PersonStatusId_IDEA = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(pers.DataCollectionId, '')
				AND pers.StatusStartDate = ps.IDEA_StatusStartDate
				AND ISNULL(pers.StatusEndDate,'01/01/1900') = ISNULL(ps.IDEA_StatusEndDate,'01/01/1900')
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'IDEA')
			WHERE ps.PersonStatusId_IDEA IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_IDEA', 'S05EC320' 
		END CATCH

		BEGIN TRY
			----Create PersonStatus -- IDEA
			INSERT INTO [dbo].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate]
					   ,[DataCollectionId])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,(SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'IDEA') [RefPersonStatusTypeId]
					   ,ps.IDEAIndicator [StatusValue]
					   ,ps.IDEA_StatusStartDate [StatusStartDate]
					   ,ps.IDEA_StatusEndDate [StatusEndDate]
					   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			WHERE ps.PersonStatusId_IDEA IS NULL
			AND ps.IDEAIndicator IS NOT NULL
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonStatus', NULL, 'S05EC330' 
		END CATCH


		BEGIN TRY
			----UPDATE the Staging table with the PersonStatus -- IDEA ID
			UPDATE Staging.PersonStatus
			SET PersonStatusId_IDEA = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(pers.DataCollectionId, '')
				AND pers.StatusStartDate = ps.IDEA_StatusStartDate
				AND ISNULL(pers.StatusEndDate,'01/01/1900') = ISNULL(ps.IDEA_StatusEndDate,'01/01/1900')
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM dbo.RefPersonStatusType WHERE Code = 'IDEA')
			WHERE ps.PersonStatusId_IDEA IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_IDEA', 'S05EC340' 
		END CATCH



		-----------------------------------------------------
		----Military Connected Studennt ---------------------
		-----------------------------------------------------

		--First check to see if PersonMilitary exists so that it is not created again
		BEGIN TRY

			UPDATE Staging.PersonStatus
			SET PersonMilitaryId = pm.PersonMilitaryId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonMilitary pm 
				ON ps.PersonId = pm.PersonId
			JOIN staging.SourceSystemReferenceData military 
				ON ps.MilitaryConnectedStudentIndicator = military.InputCode
				AND military.TableName = 'RefMilitaryConnectedStudentIndicator'
				AND military.SchoolYear = @SchoolYear
			WHERE pm.RecordStartDateTime <= ISNULL(ps.MilitaryConnected_StatusEndDate, GETDATE())
			AND (pm.RecordEndDateTime IS NULL OR pm.RecordEndDateTime >= ps.MilitaryConnected_StatusStartDate)
			AND ps.PersonMilitaryId IS NULL

		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonMilitaryId', 'S05EC350' 
		END CATCH

		BEGIN TRY
			--Create PersonMilitary
			INSERT INTO [dbo].[PersonMilitary] (
				[PersonId]
				, [RefMilitaryActiveStudentIndicatorId]
				, [RefMilitaryConnectedStudentIndicatorId]
				, [RefMilitaryVeteranStudentIndicatorId]
				, [RefMilitaryBranchId]
				, [RecordStartDateTime]
				, [RecordEndDateTime]
				, [DataCollectionId]
			)
			SELECT DISTINCT
				ps.PersonId										[PersonId]
				, NULL											[RefMilitaryActiveStudentIndicatorId]
				, mcsi.RefMilitaryConnectedStudentIndicatorId	[RefMilitaryConnectedStudentIndicatorId]
				, NULL											[RefMilitaryVeteranStudentIndicatorId]
				, NULL											[RefMilitaryBranchId]
				, ps.MilitaryConnected_StatusStartDate			[RecordStartDateTime]
				, ps.MilitaryConnected_StatusEndDate			[RecordEndDateTime]
				, ps.DataCollectionId							[DataCollectionId]
			FROM Staging.PersonStatus ps
			JOIN [Staging].[SourceSystemReferenceData] military
				ON ps.MilitaryConnectedStudentIndicator = military.InputCode
				AND military.TableName = 'RefMilitaryConnectedStudentIndicator'
				AND military.SchoolYear = @SchoolYear
			JOIN dbo.RefMilitaryConnectedStudentIndicator mcsi 
				ON military.OutputCode = mcsi.Code
			WHERE ps.PersonMilitaryId IS NULL
			AND ps.MilitaryConnectedStudentIndicator IS NOT NULL
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonMilitary', NULL, 'S05EC360' 
		END CATCH

		--UPDATE the Staging table with the PersonMilitaryId
		BEGIN TRY

			UPDATE Staging.PersonStatus
			SET PersonMilitaryId = pm.PersonMilitaryId
			FROM Staging.PersonStatus ps
			JOIN dbo.PersonMilitary pm 
				ON ps.PersonId = pm.PersonId
			JOIN [Staging].[SourceSystemReferenceData] military 
				ON ps.MilitaryConnectedStudentIndicator = military.InputCode
				AND military.TableName = 'RefMilitaryConnectedStudentIndicator'
				AND military.SchoolYear = @SchoolYear
			WHERE pm.RecordStartDateTime <= ISNULL(ps.MilitaryConnected_StatusEndDate, GETDATE())
			AND (pm.RecordEndDateTime IS NULL OR pm.RecordEndDateTime >= ps.MilitaryConnected_StatusStartDate)
			AND ps.PersonMilitaryId IS NULL

		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonMilitaryId', 'S05EC370' 
		END CATCH


		-----------------------------------------------------
		----Foster Care Program Participation----------------
		-----------------------------------------------------

		/*** LEA ***/		
		BEGIN TRY
			--First check to see IF LEA foster care program EXISTS so that it IS NOT created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Foster = ps.OrganizationPersonRoleID_LEA_Program_Foster
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_LEA_Program_Foster = opr.OrganizationId
			WHERE opr.EntryDate <= ps.FosterCare_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.FosterCare_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Foster IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Foster', 'S05EC380' 
		END CATCH
		
		BEGIN TRY	
			--Create LEA Foster Care Program
			INSERT INTO [dbo].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate]
			   ,[DataCollectionId])
			SELECT DISTINCT
				ps.OrganizationID_LEA_Program_Foster		[OrganizationId]
			   ,ps.PersonId									[PersonId]
			   ,Staging.GetRoleId('K12 Student')				[RoleId]
			   ,ps.FosterCare_ProgramParticipationStartDate [EntryDate]
			   ,ps.FosterCare_ProgramParticipationEndDate	[ExitDate] 
			   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_LEA_Program_Foster IS NULL
			AND ps.ProgramType_FosterCare = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S05EC385' 
		END CATCH

		BEGIN TRY
			--UPDATE staging table to include LEA OPR foster care
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Foster = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_LEA_Program_Foster = opr.OrganizationId
			WHERE opr.EntryDate <= ps.FosterCare_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.FosterCare_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Foster IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Foster', 'S05EC390' 
		END CATCH

		BEGIN TRY
			-- Create an LEA program participation record for the foster care students
			INSERT INTO dbo.PersonProgramParticipation
				(OrganizationPersonRoleId
				,RefParticipationTypeId
				,RefProgramExitReasonId
				,RecordStartDateTime
				,RecordEndDateTime
				,ParticipationStatus
				,DataCollectionId)
			SELECT 
				  OrganizationPersonRoleID_LEA_Program_Foster
				, NULL
				, NULL
				, FosterCare_ProgramParticipationStartDate 
				, FosterCare_ProgramParticipationEndDate
				, NULL
				, DataCollectionId  
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_LEA_Program_Foster IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S05EC395' 
		END CATCH

		/*** School ***/		
		BEGIN TRY
			--First check to see IF School foster care program EXISTS so that it IS NOT created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Foster = ps.OrganizationPersonRoleID_School_Program_Foster
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_School_Program_Foster = opr.OrganizationId
			WHERE opr.EntryDate <= ps.FosterCare_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.FosterCare_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Foster IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Foster', 'S05EC400' 
		END CATCH
		
		BEGIN TRY	
			--Create School Foster Care Program
			INSERT INTO [dbo].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate]
			   ,[DataCollectionId])
			SELECT DISTINCT
				ps.OrganizationID_School_Program_Foster		[OrganizationId]
			   ,ps.PersonId									[PersonId]
			   ,Staging.GetRoleId('K12 Student')				[RoleId]
			   ,ps.FosterCare_ProgramParticipationStartDate [EntryDate]
			   ,ps.FosterCare_ProgramParticipationEndDate	[ExitDate] 
			   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_School_Program_Foster IS NULL
			AND ps.ProgramType_FosterCare = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S05EC405' 
		END CATCH

		BEGIN TRY
			--UPDATE staging table to include School foster care
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Foster = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_School_Program_Foster = opr.OrganizationId
			WHERE opr.EntryDate <= ps.FosterCare_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.FosterCare_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Foster IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Foster', 'S05EC410' 
		END CATCH

		BEGIN TRY
			-- Create a School program participation record for the foster care students
			INSERT INTO dbo.PersonProgramParticipation
				(OrganizationPersonRoleId
				,RefParticipationTypeId
				,RefProgramExitReasonId
				,RecordStartDateTime
				,RecordEndDateTime
				,ParticipationStatus
				,DataCollectionId)
			SELECT 
				  OrganizationPersonRoleID_School_Program_Foster
				, NULL
				, NULL
				, FosterCare_ProgramParticipationStartDate 
				, FosterCare_ProgramParticipationEndDate 
				, NULL
				, DataCollectionId
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_School_Program_Foster IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S05EC415' 
		END CATCH

		-----------------------------------------------------
		----Section 504 Program Participation----------------
		-----------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_School_Program_Section504 = orgr.OrganizationId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationRelationship orgr 
				ON ps.OrganizationID_School = orgr.Parent_OrganizationId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgr.OrganizationId = orgpt.OrganizationId
				AND ISNULL(orgr.DataCollectionId, '') = ISNULL(orgpt.DataCollectionId, '')
			WHERE orgpt.RefProgramTypeId = Staging.GetProgramTypeId('04967')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_Program_Foster', 'S11EC150' 
		END CATCH

		/*** LEA ***/		
		BEGIN TRY
			--First check to see IF LEA Section 504 program EXISTS so that it IS NOT created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Section504 = ps.OrganizationPersonRoleID_LEA_Program_Section504
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_LEA_Program_Section504 = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Section504_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Section504_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Section504 IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Section504', 'S11EC380' 
		END CATCH
		
		BEGIN TRY	
			--Create LEA Section 504 Program
			INSERT INTO [dbo].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate]
			   ,[DataCollectionId])
			SELECT DISTINCT
				ps.OrganizationID_LEA_Program_Section504		[OrganizationId]
			   ,ps.PersonId									[PersonId]
			   ,Staging.GetRoleId('K12 Student')				[RoleId]
			   ,ps.Section504_ProgramParticipationStartDate [EntryDate]
			   ,ps.Section504_ProgramParticipationEndDate	[ExitDate] 
			   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_LEA_Program_Section504 IS NULL
			AND ps.ProgramType_Section504 = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S11EC385' 
		END CATCH

		BEGIN TRY
			--UPDATE staging table to include LEA OPR Section 504
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Section504 = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_LEA_Program_Section504 = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Section504_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Section504_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Section504 IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Section504', 'S11EC390' 
		END CATCH

		BEGIN TRY
			-- Create an LEA program participation record for the Section 504 students
			INSERT INTO dbo.PersonProgramParticipation
				(OrganizationPersonRoleId
				,RefParticipationTypeId
				,RefProgramExitReasonId
				,RecordStartDateTime
				,RecordEndDateTime
				,ParticipationStatus
				,DataCollectionId)
			SELECT 
				  OrganizationPersonRoleID_LEA_Program_Section504
				, NULL
				, NULL
				, Section504_ProgramParticipationStartDate 
				, Section504_ProgramParticipationEndDate
				, NULL
				, DataCollectionId 
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_LEA_Program_Section504 IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S11EC395' 
		END CATCH

		/*** School ***/		
		BEGIN TRY
			--First check to see IF School Section 504 program EXISTS so that it IS NOT created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Section504 = ps.OrganizationPersonRoleID_School_Program_Section504
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_School_Program_Section504 = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Section504_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Section504_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Section504 IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Section504', 'S11EC400' 
		END CATCH
		
		BEGIN TRY	
			--Create School Section 504 Program
			INSERT INTO [dbo].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate]
			   ,[DataCollectionId])
			SELECT DISTINCT
				ps.OrganizationID_School_Program_Section504		[OrganizationId]
			   ,ps.PersonId										[PersonId]
			   ,Staging.GetRoleId('K12 Student')				[RoleId]
			   ,ps.Section504_ProgramParticipationStartDate [EntryDate]
			   ,ps.Section504_ProgramParticipationEndDate	[ExitDate] 
			   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_School_Program_Section504 IS NULL
			AND ps.ProgramType_Section504 = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S11EC405' 
		END CATCH

		BEGIN TRY
			--UPDATE staging table to include School Section 504
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Section504 = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_School_Program_Section504 = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Section504_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Section504_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Section504 IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Section504', 'S11EC410' 
		END CATCH

		BEGIN TRY
			-- Create a School program participation record for the Section 504 students
			
		DECLARE @Section504_ProgramParticipationStartDate AS DATE = Staging.GetFiscalYearStartDate(@SchoolYear)
		DECLARE @Section504ServicedIndicator INT
		SELECT @Section504ServicedIndicator = RefParticipationTypeId FROM dbo.RefParticipationType WHERE Code = 'Section504'


			INSERT INTO dbo.PersonProgramParticipation
				(OrganizationPersonRoleId
				,RefParticipationTypeId
				,RefProgramExitReasonId
				,RecordStartDateTime
				,RecordEndDateTime
				,ParticipationStatus
				,DataCollectionId)
			SELECT 
				  OrganizationPersonRoleID_School_Program_Section504
				, @Section504ServicedIndicator
				, NULL
				, Section504_ProgramParticipationStartDate 
				, Section504_ProgramParticipationEndDate
				, NULL
				, DataCollectionId 
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_School_Program_Section504 IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S11EC415' 
		END CATCH

-------------------------------------------------------
-- The end of Section 504
-------------------------------------------------------

		-----------------------------------------------------
		----Immigrant Program Participation----------------
		-----------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_School_Program_Immigrant = orgr.OrganizationId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationRelationship orgr 
				ON ps.OrganizationID_School = orgr.Parent_OrganizationId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(orgr.DataCollectionId, '')
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgr.OrganizationId = orgpt.OrganizationId
				AND ISNULL(orgr.DataCollectionId, '') = ISNULL(orgpt.DataCollectionId, '')
			WHERE orgpt.RefProgramTypeId = Staging.GetProgramTypeId('77000')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_Program_Foster', 'S11EC150' 
		END CATCH

		/*** LEA ***/		
		BEGIN TRY
			--First check to see IF LEA Immigrant program EXISTS so that it IS NOT created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Immigrant = ps.OrganizationPersonRoleID_LEA_Program_Immigrant
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_LEA_Program_Immigrant = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Immigrant_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Immigrant_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Immigrant IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Immigrant', 'S11EC380' 
		END CATCH
		
		BEGIN TRY	
			--Create LEA Immigrant Program
			INSERT INTO [dbo].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate]
			   ,[DataCollectionId])
			SELECT DISTINCT
				ps.OrganizationID_LEA_Program_Immigrant		[OrganizationId]
			   ,ps.PersonId									[PersonId]
			   ,Staging.GetRoleId('K12 Student')				[RoleId]
			   ,ps.Immigrant_ProgramParticipationStartDate [EntryDate]
			   ,ps.Immigrant_ProgramParticipationEndDate	[ExitDate] 
			   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_LEA_Program_Immigrant IS NULL
			AND ps.ProgramType_Immigrant = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S11EC385' 
		END CATCH

		BEGIN TRY
			--UPDATE staging table to include LEA OPR Immigrant
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Immigrant = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_LEA_Program_Immigrant = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Immigrant_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Immigrant_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Immigrant IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Immigrant', 'S11EC390' 
		END CATCH

		BEGIN TRY
			-- Create an LEA program participation record for the Immigrant students
			INSERT INTO dbo.PersonProgramParticipation
				(OrganizationPersonRoleId
				,RefParticipationTypeId
				,RefProgramExitReasonId
				,RecordStartDateTime
				,RecordEndDateTime
				,ParticipationStatus
				,DataCollectionId)
			SELECT 
				  OrganizationPersonRoleID_LEA_Program_Immigrant
				, NULL
				, NULL
				, Immigrant_ProgramParticipationStartDate 
				, Immigrant_ProgramParticipationEndDate 
				, NULL
				, DataCollectionId
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_LEA_Program_Immigrant IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S11EC395' 
		END CATCH

		/*** School ***/		
		BEGIN TRY
			--First check to see IF School Immigrant program EXISTS so that it IS NOT created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Immigrant = ps.OrganizationPersonRoleID_School_Program_Immigrant
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_School_Program_Immigrant = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Immigrant_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Immigrant_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Immigrant IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Immigrant', 'S11EC400' 
		END CATCH
		
		BEGIN TRY	
			--Create School Immigrant Program
			INSERT INTO [dbo].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate]
			   ,[DataCollectionId])
			SELECT DISTINCT
				ps.OrganizationID_School_Program_Immigrant		[OrganizationId]
			   ,ps.PersonId									[PersonId]
			   ,Staging.GetRoleId('K12 Student')				[RoleId]
			   ,ps.Immigrant_ProgramParticipationStartDate [EntryDate]
			   ,ps.Immigrant_ProgramParticipationEndDate	[ExitDate] 
			   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_School_Program_Immigrant IS NULL
			AND ps.ProgramType_Immigrant = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S11EC405' 
		END CATCH

		BEGIN TRY
			--UPDATE staging table to include School Immigrant
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Immigrant = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_School_Program_Immigrant = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Immigrant_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Immigrant_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Immigrant IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Immigrant', 'S11EC410' 
		END CATCH

		BEGIN TRY
			-- Create a School program participation record for the Immigrant students
			
		DECLARE @Immigrant_ProgramParticipationStartDate AS DATE = Staging.GetFiscalYearStartDate(@SchoolYear)
		DECLARE @ImmigrantServicedIndicator INT
		SELECT @ImmigrantServicedIndicator = RefParticipationTypeId FROM dbo.RefParticipationType WHERE Code = 'TitleIIIImmigrantParticipation'


			INSERT INTO dbo.PersonProgramParticipation
				(OrganizationPersonRoleId
				,RefParticipationTypeId
				,RefProgramExitReasonId
				,RecordStartDateTime
				,RecordEndDateTime
				,ParticipationStatus
				,DataCollectionId)
			SELECT 
				  OrganizationPersonRoleID_School_Program_Immigrant
				, @ImmigrantServicedIndicator
				, NULL
				, Immigrant_ProgramParticipationStartDate 
				, Immigrant_ProgramParticipationEndDate 
				, NULL
				, DataCollectionId
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_School_Program_Immigrant IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S11EC415' 
		END CATCH

-------------------------------------------------------
-- end of immigrant
-------------------------------------------------------


	--============================================================================================================================
	-----------------------------------------------------
	----Homeless Program Participation----------------
	-----------------------------------------------------

		DECLARE @Homeless_ProgramParticipationStartDate AS DATE = Staging.GetFiscalYearStartDate(@SchoolYear)
		DECLARE @homelessServicedIndicator INT
		SELECT @homelessServicedIndicator = RefParticipationTypeId FROM dbo.RefParticipationType WHERE Code = 'HomelessServiced'

		/*** LEA ***/		
		BEGIN TRY
			--First check to see IF LEA Homeless program EXISTS so that it IS NOT created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Homeless = ps.OrganizationPersonRoleID_LEA_Program_Homeless
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_LEA_Program_Homeless = opr.OrganizationId
			WHERE opr.EntryDate <= @Homeless_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= @Homeless_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Homeless IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Homeless', 'S05EC380' 
		END CATCH
		
		BEGIN TRY	
			--Create LEA Homeless Program
			INSERT INTO [dbo].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate]
			   ,[DataCollectionId])
			SELECT DISTINCT
				ps.OrganizationID_LEA_Program_Homeless					[OrganizationId]
			   ,ps.PersonId												[PersonId]
			   ,Staging.GetRoleId('K12 Student')							[RoleId]
			   ,@Homeless_ProgramParticipationStartDate				[EntryDate]
			   ,NULL	[ExitDate]
			   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_LEA_Program_Homeless IS NULL
			AND ps.HomelessServicedIndicator = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S05EC385' 
		END CATCH

		BEGIN TRY
			--UPDATE staging table to include LEA OPR Homeless
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Homeless = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_LEA_Program_Homeless = opr.OrganizationId
			WHERE opr.EntryDate <= @Homeless_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= @Homeless_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Homeless IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Homeless', 'S05EC390' 
		END CATCH

		BEGIN TRY
			-- Create an LEA program participation record for the Homeless students
			INSERT INTO dbo.PersonProgramParticipation
				(OrganizationPersonRoleId
				,RefParticipationTypeId
				,RefProgramExitReasonId
				,RecordStartDateTime
				,RecordEndDateTime
				,ParticipationStatus
				,DataCollectionId)
			SELECT 
				  OrganizationPersonRoleID_LEA_Program_Homeless
				, @homelessServicedIndicator
				, NULL
				, @Homeless_ProgramParticipationStartDate 
				, NULL 
				, NULL 
				, DataCollectionId
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_LEA_Program_Homeless IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S05EC395' 
		END CATCH

		/*** School ***/		
		BEGIN TRY
			--First check to see IF School Homeless program EXISTS so that it IS NOT created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Homeless = ps.OrganizationPersonRoleID_School_Program_Homeless
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_School_Program_Homeless = opr.OrganizationId
			WHERE opr.EntryDate <= @Homeless_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= @Homeless_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Homeless IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Homeless', 'S05EC400' 
		END CATCH
		
		BEGIN TRY	
			--Create School Homeless Program
			INSERT INTO [dbo].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate]
			   ,[DataCollectionId])
			SELECT DISTINCT
				ps.OrganizationID_School_Program_Homeless			[OrganizationId]
			   ,ps.PersonId											[PersonId]
			   ,Staging.GetRoleId('K12 Student')					[RoleId]
			   ,@Homeless_ProgramParticipationStartDate				[EntryDate]
			   ,NULL												[ExitDate]
			   ,ps.DataCollectionId
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_School_Program_Homeless IS NULL
			AND ps.HomelessServicedIndicator = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S05EC405' 
		END CATCH

		BEGIN TRY
			--UPDATE staging table to include School Homeless 
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Homeless = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND ps.OrganizationID_School_Program_Homeless = opr.OrganizationId
			WHERE opr.EntryDate <= @Homeless_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= @Homeless_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Homeless IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Homeless', 'S05EC410' 
		END CATCH

		BEGIN TRY
			-- Create a School program participation record for the Homeless students
			INSERT INTO dbo.PersonProgramParticipation
				(OrganizationPersonRoleId
				,RefParticipationTypeId
				,RefProgramExitReasonId
				,RecordStartDateTime
				,RecordEndDateTime
				,ParticipationStatus
				,DataCollectionId)
			SELECT 
				  OrganizationPersonRoleID_School_Program_Homeless
				, @homelessServicedIndicator
				, NULL
				, @Homeless_ProgramParticipationStartDate 
				, NULL 
				, NULL
				, DataCollectionId
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_School_Program_Homeless IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S05EC415' 
		END CATCH

	--============================================================================================================================
		-----------------------------------------------------
		----PersonStatus Disability & SpEd      -------------
		-----------------------------------------------------
		BEGIN TRY
			INSERT INTO dbo.PersonDisability
				( PersonId
				, PrimaryDisabilityTypeId
				, DisabilityStatus
				, RecordStartDateTime
				, RecordEndDateTime
				, DataCollectionId
				)
			SELECT
				  ps.PersonId
				, dt.RefDisabilityTypeId
				, ps.IDEAIndicator
				, ps.IDEA_StatusStartDate
				, ps.IDEA_StatusEndDate
				, ps.DataCollectionId
			FROM Staging.PersonStatus ps
			LEFT JOIN [Staging].[SourceSystemReferenceData] ref
				ON ps.PrimaryDisabilityType = ref.InputCode
				AND ref.TableName = 'RefDisabilityType'
				AND ref.SchoolYear = @SchoolYear
			LEFT JOIN dbo.RefDisabilityType dt
				ON ref.OutputCode = dt.Code
			LEFT JOIN dbo.PersonDisability pd
				ON ps.PersonId = pd.PersonId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(pd.DataCollectionId, '')
				AND dt.RefDisabilityTypeId = pd.PrimaryDisabilityTypeId
				AND ps.IDEA_StatusStartDate = pd.RecordStartDateTime
				AND ps.IDEA_StatusEndDate = pd.RecordEndDateTime
			WHERE pd.PersonId IS NULL
				AND ps.PersonId IS NOT NULL
				AND ps.IDEAIndicator = 1
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonDisability', NULL, 'S05EC420' 
		END CATCH
		/*
			 EXEC Staging.[Migrate_Data_ETL_IMPLEMENTATION_STEP05_PersonStatus_EncapsulatedCode] 2018;
		*/
		BEGIN TRY
			--LEA
			INSERT INTO dbo.OrganizationPersonRole 
				( OrganizationId
				, PersonId
				, RoleId
				, EntryDate
				, ExitDate
				, DataCollectionId
				)
			SELECT 
				  ore.OrganizationId
				, ps.PersonId
				, rol.RoleId
				, @RecordStartDateTime
				, @RecordEndDateTime
				, ps.DataCollectionId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationRelationship ore
				ON ps.OrganizationID_LEA = ore.Parent_OrganizationId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(ore.DataCollectionId, '')
			JOIN dbo.OrganizationProgramType t 
				ON t.OrganizationId = ore.OrganizationId 
				AND ISNULL(t.DataCollectionId, '') = ISNULL(ore.DataCollectionId, '')
				AND t.RefProgramTypeId = @SpecialEdProgramTypeId
			JOIN dbo.[Role] rol
				ON rol.Name = 'K12 Student'
			LEFT JOIN dbo.OrganizationPersonRole ext
				ON ext.PersonId = ps.PersonId
				AND ISNULL(ext.DataCollectionId, '') = ISNULL(ps.DataCollectionId, '')
				AND ext.OrganizationId = ore.OrganizationId
			WHERE ext.PersonId IS NULL
				AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S05EC430' 
		END CATCH

				
		BEGIN TRY
			--UPDATE staging table to include SPED OPR for LEA
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_SPED = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationRelationship ore
				ON ps.OrganizationID_LEA = ore.Parent_OrganizationId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(ore.DataCollectionId, '')
			JOIN dbo.OrganizationProgramType t 
				ON t.OrganizationId = ore.OrganizationId 
				AND ISNULL(t.DataCollectionId, '') = ISNULL(ore.DataCollectionId, '')
				AND t.RefProgramTypeId = @SpecialEdProgramTypeId
			JOIN dbo.OrganizationPersonRole opr
				ON opr.PersonId = ps.PersonId
				AND ISNULL(opr.DataCollectionId, '') = ISNULL(ps.DataCollectionId, '')
				AND opr.OrganizationId = ore.OrganizationId
				AND opr.RoleId = Staging.GetRoleId('K12 Student')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', NULL, 'S05EC435' 
		END CATCH

		BEGIN TRY
			--School
			INSERT INTO dbo.OrganizationPersonRole 
				( OrganizationId
				, PersonId
				, RoleId
				, EntryDate
				, ExitDate
				, DataCollectionId
				)
			SELECT 
				  ore.OrganizationId
				, ps.PersonId
				, rol.RoleId
				, @RecordStartDateTime
				, @RecordEndDateTime
				, ps.DataCollectionId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationRelationship ore
				ON ps.OrganizationID_School = ore.Parent_OrganizationId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(ore.DataCollectionId, '')
			JOIN dbo.OrganizationProgramType t 
				ON t.OrganizationId = ore.OrganizationId 
				AND ISNULL(t.DataCollectionId, '') = ISNULL(ore.DataCollectionId, '')
				AND t.RefProgramTypeId = @SpecialEdProgramTypeId
			JOIN dbo.[Role] rol
				ON rol.Name = 'K12 Student'
			LEFT JOIN dbo.OrganizationPersonRole ext
				ON ext.PersonId = ps.PersonId
				AND ISNULL(ext.DataCollectionId, '') = ISNULL(ps.DataCollectionId, '')
				AND ext.OrganizationId = ore.OrganizationId
			WHERE ext.PersonId IS NULL
				AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S05EC440' 
		END CATCH

		BEGIN TRY
			--UPDATE staging table to include SPED OPR for School
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_SPED = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN dbo.OrganizationRelationship ore
				ON ps.OrganizationID_School = ore.Parent_OrganizationId
				AND ISNULL(ps.DataCollectionId, '') = ISNULL(ore.DataCollectionId, '')
			JOIN dbo.OrganizationProgramType t 
				ON t.OrganizationId = ore.OrganizationId 
				AND ISNULL(t.DataCollectionId, '') = ISNULL(ore.DataCollectionId, '')
				AND t.RefProgramTypeId = @SpecialEdProgramTypeId
			JOIN dbo.OrganizationPersonRole opr
				ON opr.PersonId = ps.PersonId
				AND ISNULL(opr.DataCollectionId, '') = ISNULL(ps.DataCollectionId, '')
				AND opr.OrganizationId = ore.OrganizationId
				AND opr.RoleId = Staging.GetRoleId('K12 Student')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', NULL, 'S05EC445' 
		END CATCH


		---------------------------------------------------------------------------------------------------------
		----Add Eligibility Status for School Food Service Programs to K12StudentEnrollment for Membership Date--
		---------------------------------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE dbo.K12StudentEnrollment
			SET RefFoodServiceEligibilityId = rfse.RefFoodServiceEligibilityId
			FROM dbo.K12StudentEnrollment kse
			JOIN Staging.PersonStatus mcc 
				ON kse.OrganizationPersonRoleId = mcc.OrganizationPersonRoleID_School
				AND ISNULL(kse.DataCollectionId, '') = ISNULL(mcc.DataCollectionId, '')
			JOIN [Staging].[SourceSystemReferenceData] rd 
				ON mcc.EligibilityStatusForSchoolFoodServicePrograms = rd.InputCode
				AND rd.TableName = 'RefFoodServiceEligibility'
				AND rd.SchoolYear = @SchoolYear
			JOIN dbo.RefFoodServiceEligibility rfse 
				ON rd.OutputCode = rfse.Code
			WHERE kse.RecordStartDateTime <= @MembershipDate
				AND (kse.RecordEndDateTime IS NULL 
					OR kse.RecordEndDateTime >= @MembershipDate)
				AND mcc.EligibilityStatusForSchoolFoodServicePrograms IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentEnrollment', 'RefFoodServiceEligibilityId', 'S05EC450' 
		END CATCH

		------------------------------------------------------------------------------------------------------------
		----Add NationalSchoolLunchProgramDirectCertificationIndicator to K12StudentEnrollment for Membership Date--
		------------------------------------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE dbo.K12StudentEnrollment
			SET NSLPDirectCertificationIndicator = mcc.NationalSchoolLunchProgramDirectCertificationIndicator
			FROM dbo.K12StudentEnrollment kse
			JOIN Staging.PersonStatus mcc 
				ON kse.OrganizationPersonRoleId = mcc.OrganizationPersonRoleID_School
				AND ISNULL(kse.DataCollectionId, '') = ISNULL(mcc.DataCollectionId, '')
			WHERE kse.RecordStartDateTime <= @MembershipDate
				AND (kse.RecordEndDateTime IS NULL 
					OR kse.RecordEndDateTime >= @MembershipDate)
				AND mcc.NationalSchoolLunchProgramDirectCertificationIndicator IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentEnrollment', 'NSLPDirectCertificationIndicator', 'S05EC460' 
		END CATCH


END