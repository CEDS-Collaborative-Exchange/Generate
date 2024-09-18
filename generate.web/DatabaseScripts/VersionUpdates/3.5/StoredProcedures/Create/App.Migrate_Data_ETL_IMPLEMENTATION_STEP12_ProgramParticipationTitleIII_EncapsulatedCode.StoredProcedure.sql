CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP12_ProgramParticipationTitleIII_EncapsulatedCode]
	@SchoolYear SMALLINT = NULL
	AS

		/*************************************************************************************************************
		Date Created:  5/9/2019

		Purpose:
			The purpose of this ETL is to load Title III about students for EDFacts reports that apply to the full year.

		Assumptions:
        
		Account executed under: LOGIN

		Approximate run time:  ~ 5 seconds

		Data Sources: 

		Data Targets:  Generate Database:   Generate

		Return Values:
    		 0	= Success
  
		Example Usage: 
		  EXEC App.[Migrate_Data_ETL_IMPLEMENTATION_STEP015_ProgramParticipationTitleIII_EncapsulatedCode];
    
		Modification Log:
		  #	  Date		  Issue#   Description
		  --  ----------  -------  --------------------------------------------------------------------
		  01		  	 
		*************************************************************************************************************/

	BEGIN
		--begin transaction


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
		DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP12_ProgramParticipationTitleIII_EncapsulatedCode'
		DECLARE @TitleIiiImmigrantStatus INT
		,@RecordStartDateTime DATETIME
		,@RecordEndDateTime DATETIME

		SELECT @TitleIiiImmigrantStatus = RefPersonStatusTypeId FROM ODS.RefPersonStatusType WHERE Code = 'TitleIIIImmigrant'
		SET @RecordStartDateTime = App.GetFiscalYearStartDate(@SchoolYear)
		SET @RecordEndDateTime = App.GetFiscalYearEndDate(@SchoolYear)

		--------------------------------------------------------------
		--- Optimize indexes on Staging.ProgramParticipationTitleIII --- 
		--------------------------------------------------------------
		ALTER INDEX ALL ON Staging.ProgramParticipationTitleIII
		REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

		-------------------------------------------------------
		---Associate the PersonId with the staging table ----
		-------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationTitleIII
			SET PersonID = pid.PersonId
			FROM Staging.ProgramParticipationTitleIII mcc
			JOIN ODS.PersonIdentifier pid ON mcc.Student_Identifier_State = pid.Identifier
			WHERE pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075')
				AND pid.RefPersonalInformationVerificationId = App.GetRefPersonalInformationVerificationId('01011')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'PersonID', 'S12EC100'
		END CATCH

		--------------------------------------------------------------------
		---Associate the School OrganizationId with the staging table ----
		--------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationTitleIII
			SET OrganizationID_School = orgid.OrganizationId
			FROM Staging.ProgramParticipationTitleIII mcc
			JOIN ODS.OrganizationIdentifier orgid ON mcc.School_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = [App].[GetOrganizationIdentifierTypeId]('001073')
				AND orgid.RefOrganizationIdentificationSystemId = [App].[GetOrganizationIdentifierSystemId]('SEA', '001073')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'OrganizationID_School', 'S12EC110'
		END CATCH


		-----------------------------------------------------------------------------
		---Associate the TitleIII Program OrganizationId with the staging table ----
		-----------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationTitleIII
			SET OrganizationID_TitleIIIProgram = orgd.OrganizationId
			FROM Staging.ProgramParticipationTitleIII tp
			JOIN ODS.OrganizationRelationship orgr ON tp.OrganizationID_School = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd ON orgr.OrganizationId = orgd.OrganizationId
			JOIN ODS.OrganizationProgramType orgpt ON orgd.OrganizationId = orgpt.OrganizationId
			WHERE orgd.RefOrganizationTypeId = App.GetOrganizationTypeId('Program', '001156') 
				AND orgpt.RefProgramTypeId = App.GetProgramTypeId('77000') -- 'Tilte III Program
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'OrganizationID_TitleIIIProgram', 'S12EC120'
		END CATCH

		--------------------------------------------------
		----Create TitleIII Indicator for the Student -----
		--------------------------------------------------

		BEGIN TRY
			--Check for TitleIII Records that already exist--
			UPDATE Staging.ProgramParticipationTitleIII
			SET OrganizationPersonRoleID_TitleIIIProgram = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationTitleIII tp
			JOIN ODS.OrganizationPersonRole opr ON tp.PersonID = opr.PersonId
			WHERE tp.OrganizationID_TitleIIIProgram = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student')
				AND opr.EntryDate = [App].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.ExitDate = [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'OrganizationPersonRoleID_TitleIIIProgram', 'S12EC130'
		END CATCH

		BEGIN TRY
			--Create an OrganizationPersonRole (Enrollment) into the TitleIII Program for the last day of the year --
			INSERT INTO [ODS].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				tp.OrganizationID_TitleIIIProgram [OrganizationId]
			   ,tp.PersonID [PersonId]
			   ,App.GetRoleId('K12 Student') [RoleId]
			   ,tp.ProgramParticipationBeginDate
			   ,tp.ProgramParticipationEndDate
			   --,[App].[GetFiscalYearStartDate](@SchoolYear) [EntryDate]
			   --,[App].[GetFiscalYearEndDate](@SchoolYear) [ExitDate] 
			FROM Staging.ProgramParticipationTitleIII tp
			LEFT JOIN [ODS].[OrganizationPersonRole] opr 
				ON opr.OrganizationId = tp.OrganizationID_TitleIIIProgram AND opr.PersonId = tp.PersonID AND opr.RoleId = App.GetRoleId('K12 Student') AND opr.EntryDate = [App].[GetFiscalYearStartDate](@SchoolYear) 
			WHERE opr.OrganizationPersonRoleId IS NULL
				AND tp.OrganizationPersonRoleID_TitleIIIProgram IS NULL
				AND tp.OrganizationID_TitleIIIProgram IS NOT NULL
				AND tp.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S12EC140'
		END CATCH

		BEGIN TRY
			--Update the staging table with the TitleIII Program OrganizationPersonRoleId
			UPDATE Staging.ProgramParticipationTitleIII
			SET OrganizationPersonRoleID_TitleIIIProgram = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationTitleIII tp
			JOIN ODS.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
				AND tp.OrganizationID_TitleIIIProgram = opr.OrganizationId
			WHERE opr.RoleId = App.GetRoleId('K12 Student')
				--AND opr.EntryDate = [App].[GetFiscalYearStartDate](@SchoolYear)
				--AND opr.ExitDate = [App].[GetFiscalYearEndDate](@SchoolYear)
				AND opr.EntryDate = tp.ProgramParticipationBeginDate
				AND (opr.ExitDate IS NULL OR opr.ExitDate = tp.ProgramParticipationEndDate)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'OrganizationPersonRoleID_TitleIIIProgram', 'S12EC150'
		END CATCH


		BEGIN TRY
			--Check to see if a PersonProgramParticipation already exists for the TitleIII Program--
			UPDATE Staging.ProgramParticipationTitleIII
			SET PersonProgramParticipationId = ppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationTitleIII tp
			JOIN ODS.PersonProgramParticipation ppp 
				ON tp.OrganizationPersonRoleID_TitleIIIProgram = ppp.OrganizationPersonRoleId
			JOIN ODS.ProgramParticipationTitleIIILep pp 
				ON ppp.PersonProgramParticipationId = pp.PersonProgramParticipationId
			WHERE ppp.RecordStartDateTime = [App].[GetFiscalYearStartDate](@SchoolYear)
				AND ppp.RecordEndDateTime = [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'PersonProgramParticipationId', 'S12EC160'
		END CATCH

		--Create a PersonProgramParticipation for each OrganizationPersonRole
		DECLARE @NewPersonProgramParticipationTitleIII TABLE (
			  PersonProgramParticipationId INT
			, SourceId INT
		);

		DECLARE @RefParticipationTypeId INT
		SELECT @RefParticipationTypeId = RefParticipationTypeId FROM [ODS].[RefParticipationType] WHERE [Code] = 'TitleIIILEPParticipation' -- Description = 'Title III Limited English Proficient Participation'

		BEGIN TRY
			MERGE [ODS].[PersonProgramParticipation] AS TARGET
			USING Staging.ProgramParticipationTitleIII AS SOURCE
				ON SOURCE.PersonProgramParticipationId = TARGET.PersonProgramParticipationId
			WHEN NOT MATCHED AND SOURCE.OrganizationPersonRoleID_TitleIIIProgram IS NOT NULL THEN 
				INSERT 
			   ([OrganizationPersonRoleId]
			   ,[RefParticipationTypeId]
			   ,[RefProgramExitReasonId]
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime])
			VALUES
			   (OrganizationPersonRoleID_TitleIIIProgram 
			   ,CASE
					WHEN [EnglishLearnerParticipation] = 1 THEN @RefParticipationTypeId 
					ELSE NULL
				END 
			   ,NULL 
			   ,ProgramParticipationBeginDate	
			   ,ProgramParticipationEndDate	
			   )	
			   --,[App].[GetFiscalYearStartDate](@SchoolYear) 
			   --,[App].[GetFiscalYearEndDate](@SchoolYear))
			OUTPUT
				  INSERTED.PersonProgramParticipationId 
				, SOURCE.ID
			INTO @NewPersonProgramParticipationTitleIII;
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S12EC170'
		END CATCH

		BEGIN TRY
			--Update the staging table with the new PersonProgramParticipationId
			UPDATE Staging.ProgramParticipationTitleIII 
			SET PersonProgramParticipationId = nppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationTitleIII ppi
			JOIN @NewPersonProgramParticipationTitleIII nppp
				ON ppi.ID = nppp.SourceId
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'PersonProgramParticipationId', 'S12EC180'
		END CATCH

		BEGIN TRY
			-- create new ods.ProgramParticipationTitleIII records
			INSERT INTO ODS.ProgramParticipationTitleIIILep 
			(
				PersonProgramParticipationId
			   ,RefTitleIIIAccountabilityId
			   ,RefTitleIIILanguageInstructionProgramTypeId
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime]
			)
			SELECT 
				ppi.PersonProgramParticipationId
				,CASE
					WHEN acct.RefTitleIIIAccountabilityId IS NOT NULL THEN acct.RefTitleIIIAccountabilityId
					ELSE NULL
				END
				,CASE
					WHEN lipt.RefTitleIIILanguageInstructionProgramTypeId IS NOT NULL THEN lipt.RefTitleIIILanguageInstructionProgramTypeId
					WHEN ppi.LanguageInstructionProgramServiceType IS NOT NULL THEN  (SELECT RefTitleIIIAccountabilityId FROM [ODS].RefTitleIIIAccountability WHERE Code = 'NOPROGRESS')
					ELSE NULL
				END RefTitleIIILanguageInstructionProgramTypeId
				,ProgramParticipationBeginDate	
				,ProgramParticipationEndDate		
			FROM Staging.ProgramParticipationTitleIII ppi
			JOIN @NewPersonProgramParticipationTitleIII nppp ON ppi.ID = nppp.SourceId
			LEFT JOIN ODS.SourceSystemReferenceData ssrd 
				ON ssrd.InputCode = ppi.Progress_TitleIII
				AND ssrd.TableName = 'RefTitleIIIAccountability'
			LEFT JOIN [ODS].RefTitleIIIAccountability acct ON acct.Code = ssrd.OutputCode
			LEFT JOIN ODS.SourceSystemReferenceData lisd 
				ON lisd.InputCode = ppi.LanguageInstructionProgramServiceType
				AND lisd.TableName = 'RefTitleIIILanguageInstructionProgramType'
			LEFT JOIN [ODS].RefTitleIIILanguageInstructionProgramType lipt ON lipt.Description = lisd.OutputCode -- generate: description = edfi:  codevalue
			LEFT JOIN ODS.ProgramParticipationTitleIIILep lep 
				ON lep.PersonProgramParticipationId = ppi.PersonProgramParticipationId AND lep.RefTitleIIIAccountabilityId = acct.RefTitleIIIAccountabilityId
				AND lep.RecordStartDateTime = [App].[GetFiscalYearStartDate](@SchoolYear)
			WHERE lep.ProgramParticipationTitleIiiLepId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationTitleIII', NULL, 'S12EC190'
		END CATCH

		BEGIN TRY
			-- create new ods.ProgramParticipationTitleIII records
			INSERT INTO [ODS].[K12TitleIIILanguageInstruction]
			           (
					     [OrganizationId]
						,[RefTitleIIILanguageInstructionProgramTypeId]
						)
			SELECT DISTINCT
				ppi.OrganizationID_School
				,CASE
					WHEN lipt.RefTitleIIILanguageInstructionProgramTypeId IS NOT NULL THEN lipt.RefTitleIIILanguageInstructionProgramTypeId
					WHEN ppi.LanguageInstructionProgramServiceType IS NOT NULL THEN  (SELECT RefTitleIIIAccountabilityId FROM [ODS].RefTitleIIIAccountability WHERE Code = 'NOPROGRESS')
					ELSE NULL
				END RefTitleIIILanguageInstructionProgramTypeId	
			FROM Staging.ProgramParticipationTitleIII ppi
			LEFT JOIN ODS.SourceSystemReferenceData ssrd 
				ON ssrd.InputCode = ppi.Progress_TitleIII
				AND ssrd.TableName = 'RefTitleIIIAccountability'
			LEFT JOIN [ODS].RefTitleIIIAccountability acct ON acct.Code = ssrd.OutputCode
			LEFT JOIN ODS.SourceSystemReferenceData lisd 
				ON lisd.InputCode = ppi.LanguageInstructionProgramServiceType
				AND lisd.TableName = 'RefTitleIIILanguageInstructionProgramType'
			LEFT JOIN [ODS].RefTitleIIILanguageInstructionProgramType lipt ON lipt.Description = lisd.OutputCode -- generate: description = edfi:  codevalue
			LEFT JOIN ODS.[K12TitleIIILanguageInstruction] li 
				ON li.OrganizationId = ppi.OrganizationID_School
			WHERE li.OrganizationId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationTitleIII', NULL, 'S12EC190'
		END CATCH

		-------------------------------------------------------------------------------
		---Associate the TitleIII Immigration Person Status with the staging table ----
		-------------------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.ProgramParticipationTitleIII
				SET ImmigrationPersonStatusId = ps.PersonStatusId
			FROM Staging.ProgramParticipationTitleIII tp
			JOIN ODS.PersonStatus ps ON tp.PersonID = ps.PersonId
			JOIN ODS.RefPersonStatusType rps ON rps.RefPersonStatusTypeId = ps.RefPersonStatusTypeId
			WHERE rps.Code = 'TitleIIIImmigrant'
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'ImmigrationPersonStatusId', 'S12EC200'
		END CATCH

		BEGIN TRY
			----Create PersonStatus -- Immigration status
			declare @immigrantTitleIIIPersonStatusTypeId as int
			select @immigrantTitleIIIPersonStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'TitleIIIImmigrant'
			INSERT INTO [ODS].[PersonStatus]
					   ([PersonId]
					   ,[RefPersonStatusTypeId]
					   ,[StatusValue]
					   ,[StatusStartDate]
					   ,[StatusEndDate])
			SELECT DISTINCT
						ps.PersonId [PersonId]
					   ,@immigrantTitleIIIPersonStatusTypeId [RefPersonStatusTypeId]
					   ,TitleIiiImmigrantStatus [StatusValue]
					   ,ps.TitleIiiImmigrantStatus_StartDate [StatusStartDate]
					   ,ps.TitleIiiImmigrantStatus_EndDate [StatusEndDate]
			FROM Staging.ProgramParticipationTitleIII ps
			WHERE ps.TitleIiiImmigrantStatus = 1
			AND ps.PersonId IS NOT NULL
			AND ps.TitleIiiImmigrantStatus_StartDate <= @RecordEndDateTime
			AND (ps.TitleIiiImmigrantStatus_EndDate IS NULL OR ps.TitleIiiImmigrantStatus_EndDate >= @RecordStartDateTime)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonStatus', NULL, 'S12EC210' 
		END CATCH

		BEGIN TRY
			-- Create a School program participation record for the TitleIIIImmigrantParticipation students
			declare @TitleIIIImmigrantParticipation as int
			select @TitleIIIImmigrantParticipation = RefParticipationTypeId from ods.RefParticipationType where code = 'TitleIIIImmigrantParticipation'

			INSERT INTO [ODS].[PersonProgramParticipation]
			   ([OrganizationPersonRoleId]
			   ,[RefParticipationTypeId]
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime])
			SELECT 
				  [OrganizationPersonRoleID_TitleIIIProgram]
				, @TitleIIIImmigrantParticipation
				, TitleIiiImmigrantStatus_StartDate 
				, TitleIiiImmigrantStatus_EndDate 
			FROM Staging.ProgramParticipationTitleIII tp 
			WHERE TitleIiiImmigrantStatus = 1
			AND OrganizationPersonRoleID_TitleIIIProgram IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S11EC415' 
		END CATCH
		BEGIN TRY
			UPDATE Staging.ProgramParticipationTitleIII
				SET ImmigrationPersonStatusId = ps.PersonStatusId
			FROM Staging.ProgramParticipationTitleIII tp
			JOIN ODS.PersonStatus ps ON tp.PersonID = ps.PersonStatusId
			JOIN ODS.RefPersonStatusType rps ON rps.RefPersonStatusTypeId = ps.RefPersonStatusTypeId
			WHERE rps.Code = 'TitleIIIImmigrant'
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationTitleIII', 'ImmigrationPersonStatusId', 'S12EC210'
		END CATCH
		-------END   Student Immigrant status -----------------------------------------

		---Add in validation and error checking in this location --

		set nocount off;

	END


