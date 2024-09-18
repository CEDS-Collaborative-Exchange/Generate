CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP05_PersonStatus_EncapsulatedCode]
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
		  EXEC App.[Migrate_Data_ETL_IMPLEMENTATION_STEP05_PersonStatus_EncapsulatedCode] 2018;
    
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
		DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP05_PersonStatus_EncapsulatedCode'

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

		SET @RecordStartDateTime = App.GetFiscalYearStartDate(@SchoolYear)
		SET @RecordEndDateTime = App.GetFiscalYearEndDate(@SchoolYear)
		SET @SpecialEdProgramTypeId = (SELECT RefProgramTypeId FROM ods.RefProgramType WHERE Code = '04888')

			SET @MembershipDate = ISNULL(
			(
				SELECT CONVERT(DATE, (LEFT(tr.ResponseValue, 5) + '/' + CAST(@SchoolYear - 1 AS VARCHAR))) 
				FROM App.ToggleQuestions tq
				JOIN App.ToggleResponses tr ON tq.ToggleQuestionId = tr.ToggleQuestionId
				WHERE EmapsQuestionAbbrv = 'CHDCTDTE' 
			), 'XX');



		---Need to consider what to do when/if the dates are not populated for the status - do we default those.  Those are built into the queries below looking for matches
		--If assessments, we could pull from the assessment administration start date.  Otherwise, they will need to fill those dates in for appropriate reporting.

		-------------------------------------------------------
		---Default start and end dates if not provided --------
		-------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus SET EconomicDisadvantage_StatusStartDate = App.GetFiscalYearStartDate(@SchoolYear), EconomicDisadvantage_StatusEndDate = NULL WHERE EconomicDisadvantage_StatusStartDate IS NULL AND EconomicDisadvantageStatus IS NOT NULL
			UPDATE Staging.PersonStatus SET FosterCare_ProgramParticipationStartDate = App.GetFiscalYearStartDate(@SchoolYear), FosterCare_ProgramParticipationEndDate = NULL WHERE FosterCare_ProgramParticipationStartDate IS NULL AND ProgramType_FosterCare IS NOT NULL
			UPDATE Staging.PersonStatus SET Section504_ProgramParticipationStartDate = App.GetFiscalYearStartDate(@SchoolYear), Section504_ProgramParticipationEndDate = NULL WHERE Section504_ProgramParticipationStartDate IS NULL AND ProgramType_Section504 IS NOT NULL
			UPDATE Staging.PersonStatus SET Immigrant_ProgramParticipationStartDate = App.GetFiscalYearStartDate(@SchoolYear), Immigrant_ProgramParticipationEndDate = NULL WHERE Immigrant_ProgramParticipationStartDate IS NULL AND ProgramType_Immigrant IS NOT NULL
			UPDATE Staging.PersonStatus SET Homelessness_StatusStartDate = App.GetFiscalYearStartDate(@SchoolYear), Homelessness_StatusEndDate = NULL WHERE Homelessness_StatusStartDate IS NULL AND HomelessnessStatus IS NOT NULL
			UPDATE Staging.PersonStatus SET Migrant_StatusStartDate = App.GetFiscalYearStartDate(@SchoolYear), Migrant_StatusEndDate = NULL WHERE Migrant_StatusStartDate IS NULL AND MigrantStatus IS NOT NULL
			UPDATE Staging.PersonStatus SET EnglishLearner_StatusStartDate = App.GetFiscalYearStartDate(@SchoolYear), EnglishLearner_StatusEndDate = NULL WHERE EnglishLearner_StatusStartDate IS NULL AND EnglishLearnerStatus IS NOT NULL
			UPDATE Staging.PersonStatus SET IDEA_StatusStartDate = App.GetFiscalYearStartDate(@SchoolYear), IDEA_StatusEndDate = NULL WHERE IDEA_StatusStartDate IS NULL AND IDEAIndicator IS NOT NULL
			UPDATE Staging.PersonStatus SET MilitaryConnected_StatusStartDate = App.GetFiscalYearStartDate(@SchoolYear), MilitaryConnected_StatusEndDate = NULL WHERE MilitaryConnected_StatusStartDate IS NULL AND MilitaryConnectedStudentIndicator IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', NULL, 'S05EC100' 
		END CATCH

		-------------------------------------------------------
		---Associate the PersonId with the temporary table ----
		-------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET PersonID = pid.PersonId
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonIdentifier pid 
				ON ps.Student_Identifier_State = pid.Identifier
			WHERE pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075')
				AND pid.RefPersonalInformationVerificationId = App.GetRefPersonalInformationVerificationId('01011')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonID', 'S05EC110' 
		END CATCH

		--------------------------------------------------------------------
		---Associate the LEA OrganizationId with the temporary table ----
		--------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_LEA = orgid.OrganizationId
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationIdentifier orgid 
				ON ps.LEA_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = App.GetOrganizationIdentifierTypeId('001072')
				AND orgid.RefOrganizationIdentificationSystemId = App.GetOrganizationIdentifierSystemId('SEA', '001072')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_LEA', 'S05EC120' 
		END CATCH

		--------------------------------------------------------
		---Get the Student -> LEA OrganizationPersonRoleId  ----
		--------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
				JOIN ODS.OrganizationPersonRole opr 
					ON ps.PersonId = opr.PersonId
					AND ps.OrganizationID_LEA = opr.OrganizationId
					AND opr.RoleId = App.GetRoleId('K12 Student')
			WHERE opr.EntryDate >= App.GetFiscalYearStartDate(@SchoolYear)
				AND (opr.ExitDate IS NULL OR opr.ExitDate <= App.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA', 'S05EC124' 
		END CATCH

		--------------------------------------------------------------------
		---Associate the School OrganizationId with the temporary table ----
		--------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_School = orgid.OrganizationId
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationIdentifier orgid 
				ON ps.School_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = App.GetOrganizationIdentifierTypeId('001073')
				AND orgid.RefOrganizationIdentificationSystemId = App.GetOrganizationIdentifierSystemId('SEA', '001073')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_School', 'S05EC130' 
		END CATCH

		-----------------------------------------------------------
		---Get the Student -> School OrganizationPersonRoleId  ----
		-----------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
				JOIN ODS.OrganizationPersonRole opr 
					ON ps.PersonId = opr.PersonId
					AND ps.OrganizationID_School = opr.OrganizationId
					AND opr.RoleId = App.GetRoleId('K12 Student')
			WHERE opr.EntryDate >= App.GetFiscalYearStartDate(@SchoolYear)
				AND (opr.ExitDate IS NULL OR opr.ExitDate <= App.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School', 'S05EC134' 
		END CATCH

		--------------------------------------------------------------------------------
		---Associate the LEA Foster Program OrganizationId with the temporary table ----
		--------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_LEA_Program_Foster = orgr.OrganizationId
			FROM Staging.PersonStatus ps
				JOIN ODS.OrganizationRelationship orgr 
					ON ps.OrganizationID_LEA = orgr.Parent_OrganizationId
				JOIN ODS.OrganizationProgramType orgpt 
					ON orgr.OrganizationId = orgpt.OrganizationId
			WHERE orgpt.RefProgramTypeId = App.GetProgramTypeId('75000')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_Program_Foster', 'S05EC140' 
		END CATCH

		-----------------------------------------------------------------------------------
		---Associate the School Foster Program OrganizationId with the temporary table ----
		-----------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_School_Program_Foster = orgr.OrganizationId
			FROM Staging.PersonStatus ps
				JOIN ODS.OrganizationRelationship orgr 
					ON ps.OrganizationID_School = orgr.Parent_OrganizationId
				JOIN ODS.OrganizationProgramType orgpt 
					ON orgr.OrganizationId = orgpt.OrganizationId
			WHERE orgpt.RefProgramTypeId = App.GetProgramTypeId('75000')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_Program_Foster', 'S05EC150' 
		END CATCH

		--=====================================================================================================================
		--------------------------------------------------------------------------------
		---Associate the LEA Homeless Program OrganizationId with the staging table ----
		--------------------------------------------------------------------------------
		
		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_LEA_Program_Homeless = orgr.OrganizationId
			FROM Staging.PersonStatus ps
				JOIN ODS.OrganizationRelationship orgr 
					ON ps.OrganizationID_LEA = orgr.Parent_OrganizationId
				JOIN ODS.OrganizationProgramType orgpt 
					ON orgr.OrganizationId = orgpt.OrganizationId
			WHERE orgpt.RefProgramTypeId = App.GetProgramTypeId('76000')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_Program_Foster', 'S05EC140' 
		END CATCH

		-----------------------------------------------------------------------------------
		---Associate the School Homeless Program OrganizationId with the staging table ----
		-----------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_School_Program_Homeless = orgr.OrganizationId
			FROM Staging.PersonStatus ps
				JOIN ODS.OrganizationRelationship orgr 
					ON ps.OrganizationID_School = orgr.Parent_OrganizationId
				JOIN ODS.OrganizationProgramType orgpt 
					ON orgr.OrganizationId = orgpt.OrganizationId
			WHERE orgpt.RefProgramTypeId = App.GetProgramTypeId('76000')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_Program_Foster', 'S05EC150' 
		END CATCH

		--=====================================================================================================================


		-----------------------------------------------------
		----PersonStatus EconomicDisadvantage ---------------
		-----------------------------------------------------

		BEGIN TRY
			----First check to see if PersonStatusId -- EconomicDisadvantage exists so that it is not created again
			UPDATE Staging.PersonStatus
			SET PersonStatusId_EconomicDisadvantage = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND pers.StatusStartDate = ps.EconomicDisadvantage_StatusStartDate
				AND pers.StatusEndDate = ps.EconomicDisadvantage_StatusEndDate
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'EconomicDisadvantage')
			WHERE ps.PersonStatusId_EconomicDisadvantage IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_EconomicDisadvantage', 'S05EC160' 
		END CATCH


		BEGIN TRY
			----Create PersonStatus -- EconomicDisadvantage
			INSERT INTO [ODS].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,(SELECT RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'EconomicDisadvantage') [RefPersonStatusTypeId]
					   ,ps.EconomicDisadvantageStatus [StatusValue]
					   ,ps.EconomicDisadvantage_StatusStartDate [StatusStartDate]
					   ,ps.EconomicDisadvantage_StatusEndDate [StatusEndDate]
			FROM Staging.PersonStatus ps
			WHERE ps.PersonStatusId_EconomicDisadvantage IS NULL
			AND ps.EconomicDisadvantageStatus IS NOT NULL
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonStatus', NULL, 'S05EC170' 
		END CATCH

		BEGIN TRY
			----Update the Staging table with the PersonStatus -- EconomicDisadvantage ID
			UPDATE Staging.PersonStatus
			SET PersonStatusId_EconomicDisadvantage = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND pers.StatusStartDate = ps.EconomicDisadvantage_StatusStartDate
				AND pers.StatusEndDate = ps.EconomicDisadvantage_StatusEndDate
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'EconomicDisadvantage')
			WHERE ps.PersonStatusId_EconomicDisadvantage IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', NULL, 'S05EC180' 
		END CATCH



		-----------------------------------------------------
		----PersonStatus Homeless -------------------------------
		-----------------------------------------------------

		BEGIN TRY
			----First check to see if PersonStatusId -- Homeless exists so that it is not created again
			UPDATE Staging.PersonStatus
			SET PersonStatusId_Homeless = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND pers.StatusStartDate = ps.Homelessness_StatusStartDate
				AND pers.StatusEndDate = ps.Homelessness_StatusEndDate
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'Homeless')
			WHERE ps.PersonStatusId_Homeless IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_Homeless', 'S05EC190' 
		END CATCH

		BEGIN TRY
			----Create PersonStatus -- Homeless
			INSERT INTO [ODS].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,(SELECT RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'Homeless') [RefPersonStatusTypeId]
					   ,ps.HomelessnessStatus [StatusValue]
					   ,ps.Homelessness_StatusStartDate [StatusStartDate]
					   ,ps.Homelessness_StatusEndDate [StatusEndDate]
			FROM Staging.PersonStatus ps
			WHERE ps.PersonStatusId_Homeless IS NULL
			AND ps.HomelessnessStatus IS NOT NULL
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonStatus', NULL, 'S05EC200' 
		END CATCH

		BEGIN TRY
			----Update the Staging table with the PersonStatus -- Homeless ID
			UPDATE Staging.PersonStatus
			SET PersonStatusId_Homeless = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND pers.StatusStartDate = ps.Homelessness_StatusStartDate
				AND pers.StatusEndDate = ps.Homelessness_StatusEndDate
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'Homeless')
			WHERE ps.PersonStatusId_Homeless IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_Homeless', 'S05EC210' 
		END CATCH

		------------------------------------------------------------
        --- Insert PersonHomelessness Records -- Students       ----
        ------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET PersonHomelessNightTimeResidenceId = pers.PersonId
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonHomelessness pers 
				ON ps.PersonId = pers.PersonId
			WHERE ps.PersonHomelessNightTimeResidenceId IS NULL	
			AND pers.RecordStartDateTime = ps.HomelessNightTimeResidence_StartDate
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonHomelessNightTimeResidenceId', 'S05EC220' 
		END CATCH

		BEGIN TRY
			INSERT ODS.PersonHomelessness
				(PersonId
				,HomelessnessStatus
				,RefHomelessNighttimeResidenceId
				,RecordStartDateTime
				,RecordEndDateTime
				)
			SELECT DISTINCT
				 p.PersonId
				,1
				,ntri.RefHomelessNighttimeResidenceId
				,ps.HomelessNightTimeResidence_StartDate
				,ps.HomelessNightTimeResidence_EndDate
			FROM Staging.Person p
			JOIN Staging.PersonStatus ps ON ps.Student_Identifier_State=p.Identifier
			JOIN ODS.SourceSystemReferenceData nighttime 
				ON ps.HomelessNightTimeResidence = nighttime.InputCode
				AND nighttime.TableName = 'RefHomelessNighttimeResidence'
				AND nighttime.SchoolYear = @SchoolYear
			JOIN ODS.RefHomelessNighttimeResidence ntri 
				ON nighttime.OutputCode = ntri.Code
			WHERE [Role] = 'K12 Student'

		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonHomelessness', NULL, 'S05EC230' 
		END CATCH

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET PersonHomelessNightTimeResidenceId = pers.PersonId
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonHomelessness pers 
				ON ps.PersonId = pers.PersonId
			WHERE ps.PersonHomelessNightTimeResidenceId IS NULL	
			AND pers.RecordStartDateTime = ps.HomelessNightTimeResidence_StartDate
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonHomelessNightTimeResidenceId', 'S05EC240' 
		END CATCH

		BEGIN TRY
			----Create PersonStatus -- HomelessUnaccompaniedYouth
			INSERT INTO [ODS].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,(SELECT RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'HomelessUnaccompaniedYouth') [RefPersonStatusTypeId]
					   ,1 [StatusValue]
					   ,ps.HomelessNightTimeResidence_StartDate [StatusStartDate]
					   ,ps.HomelessNightTimeResidence_EndDate [StatusEndDate]
			FROM Staging.PersonStatus ps
			WHERE ps.PersonId IS NOT NULL AND ps.HomelessUnaccompaniedYouth = 1
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonStatus', NULL, 'S05EC250' 
		END CATCH

		-----------------------------------------------------
		----PersonStatus Migrant -------------------------------
		-----------------------------------------------------

		BEGIN TRY
			----First check to see if PersonStatusId -- Migrant exists so that it is not created again
			UPDATE Staging.PersonStatus
			SET PersonStatusId_Migrant = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND pers.StatusStartDate = ps.Migrant_StatusStartDate
				AND pers.StatusEndDate = ps.Migrant_StatusEndDate
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'Migrant')
			WHERE ps.PersonStatusId_Migrant IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_Migrant', 'S05EC260' 
		END CATCH

		BEGIN TRY
			----Create PersonStatus -- Migrant
			INSERT INTO [ODS].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,(SELECT RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'Migrant') [RefPersonStatusTypeId]
					   ,ps.MigrantStatus [StatusValue]
					   ,ps.Migrant_StatusStartDate [StatusStartDate]
					   ,ps.Migrant_StatusEndDate [StatusEndDate]
			FROM Staging.PersonStatus ps
			WHERE ps.PersonStatusId_Migrant IS NULL
			AND ps.MigrantStatus IS NOT NULL
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonStatus', NULL, 'S05EC270' 
		END CATCH

		BEGIN TRY
			----Update the Staging table with the PersonStatus -- Migrant ID
			UPDATE Staging.PersonStatus
			SET PersonStatusId_Migrant = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND pers.StatusStartDate = ps.Migrant_StatusStartDate
				AND pers.StatusEndDate = ps.Migrant_StatusEndDate
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'Migrant')
			WHERE ps.PersonStatusId_Migrant IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_Migrant', 'S05EC280' 
		END CATCH

		-----------------------------------------------------
		----PersonStatus EnglishLearnerStatus -------------
		-----------------------------------------------------

		BEGIN TRY
			----First check to see if PersonStatusId -- EnglishLearnerStatus exists so that it is not created again
			UPDATE Staging.PersonStatus
			SET PersonStatusId_EnglishLearner = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND pers.StatusStartDate = ps.EnglishLearner_StatusStartDate
				AND pers.StatusEndDate = ps.EnglishLearner_StatusEndDate
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'LEP')
			WHERE ps.PersonStatusId_EnglishLearner IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_EnglishLearner', 'S05EC290' 
		END CATCH

		BEGIN TRY
			----Create PersonStatus -- EnglishLearnerStatus
			Declare  @RefPersonStatusTypeLEPId INT
			SELECT @RefPersonStatusTypeLEPId = RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'LEP'
			INSERT INTO [ODS].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,@RefPersonStatusTypeLEPId [RefPersonStatusTypeId]
					   ,ps.EnglishLearnerStatus [StatusValue]
					   ,ps.EnglishLearner_StatusStartDate [StatusStartDate]
					   ,ps.EnglishLearner_StatusEndDate [StatusEndDate]
			FROM Staging.PersonStatus ps
			LEFT JOIN [ODS].[PersonStatus] ps1 ON ps1.PersonId = ps.PersonId AND ps1.[RefPersonStatusTypeId] = @RefPersonStatusTypeLEPId AND ps1.StatusValue = ps.EnglishLearnerStatus AND ps1.StatusStartDate = ps.EnglishLearner_StatusStartDate
			WHERE ps.PersonStatusId_EnglishLearner IS NULL
			AND ps.EnglishLearnerStatus IS NOT NULL
			AND ps.PersonId IS NOT NULL
			AND ps1.PersonStatusId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonStatus', NULL, 'S05EC300' 
		END CATCH

		BEGIN TRY
			----Create PersonStatus -- EnglishLearnerStatus
			Declare  @RefPersonStatusTypeLEPPId INT
			SELECT @RefPersonStatusTypeLEPPId = RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'Perkins LEP'
			INSERT INTO [ODS].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,@RefPersonStatusTypeLEPPId [RefPersonStatusTypeId]
					   ,st.RefPersonStatusTypeId [StatusValue]
					   ,ps.PerkinsLEPStatus_StatusStartDate [StatusStartDate]
					   ,ps.PerkinsLEPStatus_StatusEndDate [StatusEndDate]
			FROM Staging.PersonStatus ps
			JOIN ODS.RefPersonStatusType st ON st.Code = ps.PerkinsLEPStatus
			LEFT JOIN [ODS].[PersonStatus] ps1 ON ps1.PersonId = ps.PersonId AND ps1.[RefPersonStatusTypeId] = @RefPersonStatusTypeLEPPId 
			WHERE 
				 ps.PerkinsLEPStatus IS NOT NULL
			AND ps.PersonId IS NOT NULL
			AND ps1.PersonStatusId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonStatus', NULL, 'S05EC305' 
		END CATCH

		BEGIN TRY
			----Update the Staging table with the PersonStatus -- EnglishLearnerStatus ID
			UPDATE Staging.PersonStatus
			SET PersonStatusId_EnglishLearner = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND pers.StatusStartDate = ps.EnglishLearner_StatusStartDate
				AND pers.StatusEndDate = ps.EnglishLearner_StatusEndDate
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'LEP')
			WHERE ps.PersonStatusId_EnglishLearner IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_EnglishLearner', 'S05EC310' 
		END CATCH

		
		---------------------------------------------------------------
		---Associate the PersonLanguageId with the temporary table ----
		---------------------------------------------------------------

		UPDATE Staging.PersonStatus
		SET PersonLanguageId = pl.PersonLanguageId
		FROM Staging.PersonStatus mcc
		JOIN ODS.PersonLanguage pl 
			ON mcc.PersonID = pl.PersonId
		JOIN ODS.SourceSystemReferenceData rd
			ON mcc.ISO_639_2_NativeLanguage = rd.InputCode
			AND rd.TableName = 'RefLanguage'
			AND rd.SchoolYear = @SchoolYear
		JOIN ODS.RefLanguage rl
			ON rd.OutputCode = rl.Code
		JOIN ODS.RefLanguageUseType rlut 
			ON rlut.Code = 'Native'
		WHERE mcc.PersonID IS NOT NULL
			AND rl.RefLanguageId = pl.PersonLanguageId
			--AND pl.RecordEndDateTime IS NULL --This requires a Generate update to include the RecordStart/End in this table

		---------------------------------------------------
		---Insert Language into ODS.PersonLanguage ----
		---------------------------------------------------

		--This can be uncommented when the RecordEndDateTime has been added to the PersonLanguage table
		--UPDATE ODS.PersonLanguage
		--SET RecordEndDateTime = App.GetFiscalYearEndDate(@SchoolYear-1)
		--FROM Staging.PersonStatus mcc
		--JOIN ODS.PersonLanguage pl 
		--	ON mcc.PersonID = pl.PersonId
		--WHERE pl.RecordEndDateTime IS NULL
		--AND mcc.PersonLanguageId IS NULL


		--Need to add the RecordStart/EndDateTime into this when it is added into Generate.
		INSERT INTO [ODS].[PersonLanguage]
           ([PersonId]
           ,[RefLanguageId]
           ,[RefLanguageUseTypeId])
		SELECT
            PersonID [PersonId]
           ,rl.RefLanguageId [RefLanguageId]
           ,rlut.RefLanguageUseTypeId [RefLanguageUseTypeId]
		FROM Staging.PersonStatus mcc
		JOIN ODS.SourceSystemReferenceData rd
			ON mcc.ISO_639_2_NativeLanguage = rd.InputCode
			AND rd.TableName = 'RefLanguage'
			AND rd.SchoolYear = @SchoolYear
		JOIN ODS.RefLanguage rl
			ON rd.OutputCode = rl.Code
		JOIN ODS.RefLanguageUseType rlut 
			ON rlut.Code = 'Native'
		WHERE mcc.ISO_639_2_NativeLanguage IS NOT NULL
			AND mcc.PersonID IS NOT NULL


		-----------------------------------------------------
		----PersonStatus IDEA -------------------------------
		-----------------------------------------------------

		BEGIN TRY
			----First check to see if PersonStatusId -- IDEA exists so that it is not created again
			UPDATE Staging.PersonStatus
			SET PersonStatusId_IDEA = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND pers.StatusStartDate = ps.IDEA_StatusStartDate
				AND pers.StatusEndDate = ps.IDEA_StatusEndDate
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'IDEA')
			WHERE ps.PersonStatusId_IDEA IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_IDEA', 'S05EC320' 
		END CATCH

		BEGIN TRY
			----Create PersonStatus -- IDEA
			INSERT INTO [ODS].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,(SELECT RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'IDEA') [RefPersonStatusTypeId]
					   ,ps.IDEAIndicator [StatusValue]
					   ,ps.IDEA_StatusStartDate [StatusStartDate]
					   ,ps.IDEA_StatusEndDate [StatusEndDate]
			FROM Staging.PersonStatus ps
			WHERE ps.PersonStatusId_IDEA IS NULL
			AND ps.IDEAIndicator IS NOT NULL
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonStatus', NULL, 'S05EC330' 
		END CATCH


		BEGIN TRY
			----Update the Staging table with the PersonStatus -- IDEA ID
			UPDATE Staging.PersonStatus
			SET PersonStatusId_IDEA = pers.PersonStatusId
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonStatus pers 
				ON ps.PersonId = pers.PersonId
				AND pers.StatusStartDate = ps.IDEA_StatusStartDate
				AND pers.StatusEndDate = ps.IDEA_StatusEndDate
				AND pers.RefPersonStatusTypeId = (SELECT RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'IDEA')
			WHERE ps.PersonStatusId_IDEA IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonStatusId_IDEA', 'S05EC340' 
		END CATCH


		-----------------------------------------------------
		----Military Connected Studennt ---------------------
		-----------------------------------------------------

		--First check to see if PersonMilitary exists so that it is not created again

		--Generate needs and update to include PersonMilitaryId, when this is complete, remove the other code and uncomment this code

		--UPDATE Staging.PersonStatus
		--SET PersonMilitaryId = pm.PersonMilitaryId
		--FROM Staging.PersonStatus ps
		--JOIN ODS.PersonMilitary pm 
			--ON ps.PersonId = pm.PersonId
		--JOIN ODS.SourceSystemReferenceData military 
			--ON ps.MilitaryConnectedStudentIndicator = military.InputCode
		--	AND military.TableName = 'RefMilitaryConnectedStudentIndicator'
		--	AND military.SchoolYear = @SchoolYear
		--WHERE pm.RecordStartDateTime <= ps.MilitaryConnected_StatusStartDate
		--AND (pm.RecordEndDateTime IS NULL OR pm.RecordEndDateTime >= ps.MilitaryConnected_StatusStartDate)
		--AND ps.PersonMilitaryId IS NULL

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET PersonMilitaryId = '0'
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonMilitary pm 
				ON ps.PersonId = pm.PersonId
			JOIN ODS.SourceSystemReferenceData military 
				ON ps.MilitaryConnectedStudentIndicator = military.InputCode
				AND military.TableName = 'RefMilitaryConnectedStudentIndicator'
				AND military.SchoolYear = @SchoolYear
			WHERE ps.PersonMilitaryId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonMilitaryId', 'S05EC350' 
		END CATCH

		BEGIN TRY
			--Create PersonMilitary
			INSERT INTO [ODS].[PersonMilitary]
			   ([PersonId]
			   ,[RefMilitaryActiveStudentIndicatorId]
			   ,[RefMilitaryConnectedStudentIndicatorId]
			   ,[RefMilitaryVeteranStudentIndicatorId]
			   ,[RefMilitaryBranchId])
			SELECT DISTINCT
				ps.PersonId [PersonId]
			   ,NULL [RefMilitaryActiveStudentIndicatorId]
			   ,mcsi.RefMilitaryConnectedStudentIndicatorId [RefMilitaryConnectedStudentIndicatorId]
			   ,NULL [RefMilitaryVeteranStudentIndicatorId]
			   ,NULL [RefMilitaryBranchId]
			   --,ps.MilitaryConnected_StatusStartDate [RecordStartDateTime] -- uncomment when elements added to Generate
			   --,ps.MilitaryConnected_StatusEndDate [RecordEndDateTime] -- uncomment when elements added to Generate
			FROM Staging.PersonStatus ps
			JOIN ODS.SourceSystemReferenceData military
				ON ps.MilitaryConnectedStudentIndicator = military.InputCode
				AND military.TableName = 'RefMilitaryConnectedStudentIndicator'
				AND military.SchoolYear = @SchoolYear
			JOIN ODS.RefMilitaryConnectedStudentIndicator mcsi 
				ON military.OutputCode = mcsi.Code
			WHERE ps.PersonMilitaryId IS NULL
			AND ps.MilitaryConnectedStudentIndicator IS NOT NULL
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonMilitary', NULL, 'S05EC360' 
		END CATCH

		--Update the Staging table with the PersonMilitaryId

		--Generate needs and update to include PersonMilitaryId, when this is complete, remove the other code and uncomment this code

		--UPDATE Staging.PersonStatus
		--SET PersonMilitaryId = pm.PersonMilitaryId
		--FROM Staging.PersonStatus ps
		--JOIN ODS.PersonMilitary pm 
			--ON ps.PersonId = pm.PersonId
		--JOIN ODS.SourceSystemReferenceData military 
			--ON ps.MilitaryConnectedStudentIndicator = military.InputCode
		--	AND military.TableName = 'RefMilitaryConnectedStudentIndicator'
		--	AND military.SchoolYear = @SchoolYear
		--WHERE pm.RecordStartDateTime <= ps.MilitaryConnected_StatusStartDate
		--AND (pm.RecordEndDateTime IS NULL OR pm.RecordEndDateTime >= ps.MilitaryConnected_StatusStartDate)
		--AND ps.PersonMilitaryId IS NULL

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET PersonMilitaryId = '0'
			FROM Staging.PersonStatus ps
			JOIN ODS.PersonMilitary pm 
				ON ps.PersonId = pm.PersonId
			JOIN ODS.SourceSystemReferenceData military 
				ON ps.MilitaryConnectedStudentIndicator = military.InputCode
				AND military.TableName = 'RefMilitaryConnectedStudentIndicator'
				AND military.SchoolYear = @SchoolYear
			WHERE ps.PersonMilitaryId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'PersonMilitaryId', 'S05EC370' 
		END CATCH

		-----------------------------------------------------
		----Foster Care Program Participation----------------
		-----------------------------------------------------

		/*** LEA ***/		
		BEGIN TRY
			--First check to see if LEA foster care program exists so that it is not created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Foster = ps.OrganizationPersonRoleID_LEA_Program_Foster
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_LEA_Program_Foster = opr.OrganizationId
			WHERE opr.EntryDate <= ps.FosterCare_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.FosterCare_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Foster IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Foster', 'S05EC380' 
		END CATCH
		
		BEGIN TRY	
			--Create LEA Foster Care Program
			INSERT INTO [ODS].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				ps.OrganizationID_LEA_Program_Foster		[OrganizationId]
			   ,ps.PersonId									[PersonId]
			   ,App.GetRoleId('K12 Student')				[RoleId]
			   ,ps.FosterCare_ProgramParticipationStartDate [EntryDate]
			   ,ps.FosterCare_ProgramParticipationEndDate	[ExitDate] 
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_LEA_Program_Foster IS NULL
			AND ps.ProgramType_FosterCare = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S05EC385' 
		END CATCH

		BEGIN TRY
			--Update staging table to include LEA OPR foster care
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Foster = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_LEA_Program_Foster = opr.OrganizationId
			WHERE opr.EntryDate <= ps.FosterCare_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.FosterCare_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Foster IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Foster', 'S05EC390' 
		END CATCH

		BEGIN TRY
			-- Create an LEA program participation record for the foster care students
			INSERT INTO ODS.PersonProgramParticipation
			SELECT 
				  OrganizationPersonRoleID_LEA_Program_Foster
				, NULL
				, NULL
				, FosterCare_ProgramParticipationStartDate 
				, FosterCare_ProgramParticipationEndDate 
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_LEA_Program_Foster IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S05EC395' 
		END CATCH

		/*** School ***/		
		BEGIN TRY
			--First check to see if School foster care program exists so that it is not created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Foster = ps.OrganizationPersonRoleID_School_Program_Foster
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_School_Program_Foster = opr.OrganizationId
			WHERE opr.EntryDate <= ps.FosterCare_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.FosterCare_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Foster IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Foster', 'S05EC400' 
		END CATCH
		
		BEGIN TRY	
			--Create School Foster Care Program
			INSERT INTO [ODS].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				ps.OrganizationID_School_Program_Foster		[OrganizationId]
			   ,ps.PersonId									[PersonId]
			   ,App.GetRoleId('K12 Student')				[RoleId]
			   ,ps.FosterCare_ProgramParticipationStartDate [EntryDate]
			   ,ps.FosterCare_ProgramParticipationEndDate	[ExitDate] 
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_School_Program_Foster IS NULL
			AND ps.ProgramType_FosterCare = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S05EC405' 
		END CATCH

		BEGIN TRY
			--Update staging table to include School foster care
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Foster = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_School_Program_Foster = opr.OrganizationId
			WHERE opr.EntryDate <= ps.FosterCare_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.FosterCare_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Foster IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Foster', 'S05EC410' 
		END CATCH

		BEGIN TRY
			-- Create a School program participation record for the foster care students
			INSERT INTO ODS.PersonProgramParticipation
			SELECT 
				  OrganizationPersonRoleID_School_Program_Foster
				, NULL
				, NULL
				, FosterCare_ProgramParticipationStartDate 
				, FosterCare_ProgramParticipationEndDate 
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_School_Program_Foster IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S05EC415' 
		END CATCH

		-----------------------------------------------------
		----Section 504 Program Participation----------------
		-----------------------------------------------------

		BEGIN TRY
			UPDATE Staging.PersonStatus
			SET OrganizationID_School_Program_Section504 = orgr.OrganizationId
			FROM Staging.PersonStatus ps
				JOIN ODS.OrganizationRelationship orgr 
					ON ps.OrganizationID_School = orgr.Parent_OrganizationId
				JOIN ODS.OrganizationProgramType orgpt 
					ON orgr.OrganizationId = orgpt.OrganizationId
			WHERE orgpt.RefProgramTypeId = App.GetProgramTypeId('04967')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_Program_Foster', 'S11EC150' 
		END CATCH

		/*** LEA ***/		
		BEGIN TRY
			--First check to see if LEA Section 504 program exists so that it is not created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Section504 = ps.OrganizationPersonRoleID_LEA_Program_Section504
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_LEA_Program_Section504 = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Section504_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Section504_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Section504 IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Section504', 'S11EC380' 
		END CATCH
		
		BEGIN TRY	
			--Create LEA Section 504 Program
			INSERT INTO [ODS].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				ps.OrganizationID_LEA_Program_Section504		[OrganizationId]
			   ,ps.PersonId									[PersonId]
			   ,App.GetRoleId('K12 Student')				[RoleId]
			   ,ps.Section504_ProgramParticipationStartDate [EntryDate]
			   ,ps.Section504_ProgramParticipationEndDate	[ExitDate] 
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_LEA_Program_Section504 IS NULL
			AND ps.ProgramType_Section504 = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S11EC385' 
		END CATCH

		BEGIN TRY
			--Update staging table to include LEA OPR Section 504
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Section504 = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_LEA_Program_Section504 = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Section504_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Section504_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Section504 IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Section504', 'S11EC390' 
		END CATCH

		BEGIN TRY
			-- Create an LEA program participation record for the Section 504 students
			INSERT INTO ODS.PersonProgramParticipation
			SELECT 
				  OrganizationPersonRoleID_LEA_Program_Section504
				, NULL
				, NULL
				, Section504_ProgramParticipationStartDate 
				, Section504_ProgramParticipationEndDate 
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_LEA_Program_Section504 IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S11EC395' 
		END CATCH

		/*** School ***/		
		BEGIN TRY
			--First check to see if School Section 504 program exists so that it is not created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Section504 = ps.OrganizationPersonRoleID_School_Program_Section504
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_School_Program_Section504 = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Section504_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Section504_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Section504 IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Section504', 'S11EC400' 
		END CATCH
		
		BEGIN TRY	
			--Create School Section 504 Program
			INSERT INTO [ODS].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				ps.OrganizationID_School_Program_Section504		[OrganizationId]
			   ,ps.PersonId									[PersonId]
			   ,App.GetRoleId('K12 Student')				[RoleId]
			   ,ps.Section504_ProgramParticipationStartDate [EntryDate]
			   ,ps.Section504_ProgramParticipationEndDate	[ExitDate] 
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_School_Program_Section504 IS NULL
			AND ps.ProgramType_Section504 = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S11EC405' 
		END CATCH

		BEGIN TRY
			--Update staging table to include School Section 504
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Section504 = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_School_Program_Section504 = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Section504_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Section504_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Section504 IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Section504', 'S11EC410' 
		END CATCH

		BEGIN TRY
			-- Create a School program participation record for the Section 504 students
			
		DECLARE @Section504_ProgramParticipationStartDate AS DATE = App.GetFiscalYearStartDate(@SchoolYear)
		DECLARE @Section504ServicedIndicator INT
		SELECT @Section504ServicedIndicator = RefParticipationTypeId FROM ODS.RefParticipationType WHERE Code = 'Section504'


			INSERT INTO ODS.PersonProgramParticipation
			SELECT 
				  OrganizationPersonRoleID_School_Program_Section504
				, @Section504ServicedIndicator
				, NULL
				, Section504_ProgramParticipationStartDate 
				, Section504_ProgramParticipationEndDate 
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_School_Program_Section504 IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S11EC415' 
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
				JOIN ODS.OrganizationRelationship orgr 
					ON ps.OrganizationID_School = orgr.Parent_OrganizationId
				JOIN ODS.OrganizationProgramType orgpt 
					ON orgr.OrganizationId = orgpt.OrganizationId
			WHERE orgpt.RefProgramTypeId = App.GetProgramTypeId('04967')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationID_Program_Foster', 'S11EC150' 
		END CATCH

		/*** LEA ***/		
		BEGIN TRY
			--First check to see if LEA Immigrant program exists so that it is not created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Immigrant = ps.OrganizationPersonRoleID_LEA_Program_Immigrant
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_LEA_Program_Immigrant = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Immigrant_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Immigrant_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Immigrant IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Immigrant', 'S11EC380' 
		END CATCH
		
		BEGIN TRY	
			--Create LEA Immigrant Program
			INSERT INTO [ODS].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				ps.OrganizationID_LEA_Program_Immigrant		[OrganizationId]
			   ,ps.PersonId									[PersonId]
			   ,App.GetRoleId('K12 Student')				[RoleId]
			   ,ps.Immigrant_ProgramParticipationStartDate [EntryDate]
			   ,ps.Immigrant_ProgramParticipationEndDate	[ExitDate] 
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_LEA_Program_Immigrant IS NULL
			AND ps.ProgramType_Immigrant = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S11EC385' 
		END CATCH

		BEGIN TRY
			--Update staging table to include LEA OPR Immigrant
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Immigrant = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_LEA_Program_Immigrant = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Immigrant_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Immigrant_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Immigrant IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Immigrant', 'S11EC390' 
		END CATCH

		BEGIN TRY
			-- Create an LEA program participation record for the Immigrant students
			INSERT INTO ODS.PersonProgramParticipation
			SELECT 
				  OrganizationPersonRoleID_LEA_Program_Immigrant
				, NULL
				, NULL
				, Immigrant_ProgramParticipationStartDate 
				, Immigrant_ProgramParticipationEndDate 
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_LEA_Program_Immigrant IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S11EC395' 
		END CATCH

		/*** School ***/		
		BEGIN TRY
			--First check to see if School Immigrant program exists so that it is not created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Immigrant = ps.OrganizationPersonRoleID_School_Program_Immigrant
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_School_Program_Immigrant = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Immigrant_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Immigrant_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Immigrant IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Immigrant', 'S11EC400' 
		END CATCH
		
		BEGIN TRY	
			--Create School Immigrant Program
			INSERT INTO [ODS].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				ps.OrganizationID_School_Program_Immigrant		[OrganizationId]
			   ,ps.PersonId									[PersonId]
			   ,App.GetRoleId('K12 Student')				[RoleId]
			   ,ps.Immigrant_ProgramParticipationStartDate [EntryDate]
			   ,ps.Immigrant_ProgramParticipationEndDate	[ExitDate] 
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_School_Program_Immigrant IS NULL
			AND ps.ProgramType_Immigrant = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S11EC405' 
		END CATCH

		BEGIN TRY
			--Update staging table to include School Immigrant
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Immigrant = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_School_Program_Immigrant = opr.OrganizationId
			WHERE opr.EntryDate <= ps.Immigrant_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= ps.Immigrant_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Immigrant IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Immigrant', 'S11EC410' 
		END CATCH

		BEGIN TRY
			-- Create a School program participation record for the Immigrant students
			
		DECLARE @Immigrant_ProgramParticipationStartDate AS DATE = App.GetFiscalYearStartDate(@SchoolYear)
		DECLARE @ImmigrantServicedIndicator INT
		SELECT @ImmigrantServicedIndicator = RefParticipationTypeId FROM ODS.RefParticipationType WHERE Code = 'TitleIIIImmigrantParticipation'


			INSERT INTO ODS.PersonProgramParticipation
			SELECT 
				  OrganizationPersonRoleID_School_Program_Immigrant
				, @ImmigrantServicedIndicator
				, NULL
				, Immigrant_ProgramParticipationStartDate 
				, Immigrant_ProgramParticipationEndDate 
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_School_Program_Immigrant IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S11EC415' 
		END CATCH

-------------------------------------------------------
-- end of immigrant
-------------------------------------------------------


	--============================================================================================================================
	-----------------------------------------------------
	----Homeless Program Participation----------------
	-----------------------------------------------------

		DECLARE @Homeless_ProgramParticipationStartDate AS DATE = App.GetFiscalYearStartDate(@SchoolYear)
		DECLARE @homelessServicedIndicator INT
		SELECT @homelessServicedIndicator = RefParticipationTypeId FROM ODS.RefParticipationType WHERE Code = 'HomelessServiced'

		/*** LEA ***/		
		BEGIN TRY
			--First check to see if LEA Homeless program exists so that it is not created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Homeless = ps.OrganizationPersonRoleID_LEA_Program_Homeless
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_LEA_Program_Homeless = opr.OrganizationId
			WHERE opr.EntryDate <= @Homeless_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= @Homeless_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Homeless IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Homeless', 'S05EC380' 
		END CATCH
		
		BEGIN TRY	
			--Create LEA Homeless Program
			INSERT INTO [ODS].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				ps.OrganizationID_LEA_Program_Homeless					[OrganizationId]
			   ,ps.PersonId												[PersonId]
			   ,App.GetRoleId('K12 Student')							[RoleId]
			   ,@Homeless_ProgramParticipationStartDate				[EntryDate]
			   ,NULL	[ExitDate] 
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_LEA_Program_Homeless IS NULL
			AND ps.HomelessServicedIndicator = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S05EC385' 
		END CATCH

		BEGIN TRY
			--Update staging table to include LEA OPR Homeless
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_LEA_Program_Homeless = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_LEA_Program_Homeless = opr.OrganizationId
			WHERE opr.EntryDate <= @Homeless_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= @Homeless_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_LEA_Program_Homeless IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_LEA_Program_Homeless', 'S05EC390' 
		END CATCH

		BEGIN TRY
			-- Create an LEA program participation record for the Homeless students
			INSERT INTO ODS.PersonProgramParticipation
			SELECT 
				  OrganizationPersonRoleID_LEA_Program_Homeless
				, @homelessServicedIndicator
				, NULL
				, @Homeless_ProgramParticipationStartDate 
				, NULL 
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_LEA_Program_Homeless IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S05EC395' 
		END CATCH

		/*** School ***/		
		BEGIN TRY
			--First check to see if School Homeless program exists so that it is not created again
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Homeless = ps.OrganizationPersonRoleID_School_Program_Homeless
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_School_Program_Homeless = opr.OrganizationId
			WHERE opr.EntryDate <= @Homeless_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= @Homeless_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Homeless IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Homeless', 'S05EC400' 
		END CATCH
		
		BEGIN TRY	
			--Create School Homeless Program
			INSERT INTO [ODS].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				ps.OrganizationID_School_Program_Homeless					[OrganizationId]
			   ,ps.PersonId													[PersonId]
			   ,App.GetRoleId('K12 Student')								[RoleId]
			   ,@Homeless_ProgramParticipationStartDate					[EntryDate]
			   ,NULL	[ExitDate] 
			FROM Staging.PersonStatus ps
			WHERE ps.OrganizationPersonRoleID_School_Program_Homeless IS NULL
			AND ps.HomelessServicedIndicator = 1
			AND ps.PersonId IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S05EC405' 
		END CATCH

		BEGIN TRY
			--Update staging table to include School Homeless 
			UPDATE Staging.PersonStatus
			SET OrganizationPersonRoleID_School_Program_Homeless = opr.OrganizationPersonRoleId
			FROM Staging.PersonStatus ps
			JOIN ODS.OrganizationPersonRole opr 
				ON ps.PersonId = opr.PersonId
				AND ps.OrganizationID_School_Program_Homeless = opr.OrganizationId
			WHERE opr.EntryDate <= @Homeless_ProgramParticipationStartDate
			AND (opr.ExitDate IS NULL OR opr.ExitDate >= @Homeless_ProgramParticipationStartDate)
			AND ps.OrganizationPersonRoleID_School_Program_Homeless IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonStatus', 'OrganizationPersonRoleID_School_Program_Homeless', 'S05EC410' 
		END CATCH

		BEGIN TRY
			-- Create a School program participation record for the Homeless students
			INSERT INTO ODS.PersonProgramParticipation
			SELECT 
				  OrganizationPersonRoleID_School_Program_Homeless
				, @homelessServicedIndicator
				, NULL
				, @Homeless_ProgramParticipationStartDate 
				, NULL 
			FROM Staging.PersonStatus 
			WHERE OrganizationPersonRoleID_School_Program_Homeless IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S05EC415' 
		END CATCH






	--============================================================================================================================
		-----------------------------------------------------
		----PersonStatus Disability & SpEd      -------------
		-----------------------------------------------------
		BEGIN TRY
			INSERT INTO ODS.PersonDisability
				( PersonId
				, PrimaryDisabilityTypeId
				, DisabilityStatus
				, RecordStartDateTime
				, RecordEndDateTime
				)
			SELECT
				  ps.PersonId
				, dt.RefDisabilityTypeId
				, ps.IDEAIndicator
				, ps.IDEA_StatusStartDate
				, ps.IDEA_StatusEndDate
			FROM Staging.PersonStatus ps
			LEFT JOIN ODS.SourceSystemReferenceData ref
				ON ps.PrimaryDisabilityType = ref.InputCode
				AND ref.TableName = 'RefDisabilityType'
				AND ref.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefDisabilityType dt
				ON ref.OutputCode = dt.Code
			LEFT JOIN ODS.PersonDisability pd
				ON ps.PersonId = pd.PersonId
				AND dt.RefDisabilityTypeId = pd.PrimaryDisabilityTypeId
				AND ps.IDEA_StatusStartDate = pd.RecordStartDateTime
				AND ps.IDEA_StatusEndDate = pd.RecordEndDateTime
			WHERE pd.PersonId IS NULL
				AND ps.PersonId IS NOT NULL
				AND ps.IDEAIndicator = 1
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonDisability', NULL, 'S05EC420' 
		END CATCH

		---------------------------------------------------------------------------------------------------------
		----Add Eligibility Status for School Food Service Programs to K12StudentEnrollment for Membership Date--
		---------------------------------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE ODS.K12StudentEnrollment
			SET RefFoodServiceEligibilityId = rfse.RefFoodServiceEligibilityId
			FROM ODS.K12StudentEnrollment kse
				JOIN Staging.PersonStatus mcc 
					ON kse.OrganizationPersonRoleId = mcc.OrganizationPersonRoleID_School
				JOIN ods.SourceSystemReferenceData rd 
					ON mcc.EligibilityStatusForSchoolFoodServicePrograms = rd.InputCode
					AND rd.TableName = 'RefFoodServiceEligibility'
					AND rd.SchoolYear = @SchoolYear
				JOIN ODS.RefFoodServiceEligibility rfse 
					ON rd.OutputCode = rfse.Code
			WHERE kse.RecordStartDateTime <= @MembershipDate
				AND (kse.RecordEndDateTime IS NULL 
					OR kse.RecordEndDateTime >= @MembershipDate)
				AND mcc.EligibilityStatusForSchoolFoodServicePrograms IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentEnrollment', 'RefFoodServiceEligibilityId', 'S05EC450' 
		END CATCH

		------------------------------------------------------------------------------------------------------------
		----Add NationalSchoolLunchProgramDirectCertificationIndicator to K12StudentEnrollment for Membership Date--
		------------------------------------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE ODS.K12StudentEnrollment
			SET NSLPDirectCertificationIndicator = mcc.NationalSchoolLunchProgramDirectCertificationIndicator
			FROM ODS.K12StudentEnrollment kse
				JOIN Staging.PersonStatus mcc 
					ON kse.OrganizationPersonRoleId = mcc.OrganizationPersonRoleID_School
			WHERE kse.RecordStartDateTime <= @MembershipDate
				AND (kse.RecordEndDateTime IS NULL 
					OR kse.RecordEndDateTime >= @MembershipDate)
				AND mcc.NationalSchoolLunchProgramDirectCertificationIndicator IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentEnrollment', 'NSLPDirectCertificationIndicator', 'S05EC460' 
		END CATCH


END
