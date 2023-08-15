CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP10_ProgramParticipationCTE_EncapsulatedCode]
	@SchoolYear SMALLINT = NULL
	AS

		/*************************************************************************************************************
		Date Created:  2/5/2019

		Purpose:
			The purpose of this ETL is to load CTE indicators about students for EDFacts reports that apply to the full year.

		Assumptions:
        
		Account executed under: LOGIN

		Approximate run time:  ~ 5 seconds

		Data Sources: 

		Data Targets:  Generate Database:   Generate

		Return Values:
    		 0	= Success
  
		Example Usage: 
		  EXEC App.[Migrate_Data_ETL_IMPLEMENTATION_STEP10_ProgramParticipationCTE_EncapsulatedCode] 2018;
    
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
		DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP10_ProgramParticipationCTE_EncapsulatedCode'

		--------------------------------------------------------------
		--- Optimize indexes on Staging.ProgramParticipationCTE --- 
		--------------------------------------------------------------
		ALTER INDEX ALL ON Staging.ProgramParticipationCTE
		REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

		-------------------------------------------------------
		---Associate the PersonId with the staging table ----
		-------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET PersonID = pid.PersonId
			FROM Staging.ProgramParticipationCTE mcc
			JOIN ODS.PersonIdentifier pid ON mcc.Student_Identifier_State = pid.Identifier
			WHERE pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075')
				AND pid.RefPersonalInformationVerificationId = App.GetRefPersonalInformationVerificationId('01011')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'PersonID', 'S10EC100'
		END CATCH

		--------------------------------------------------------------------
		---Associate the School OrganizationId with the staging table ----
		--------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationID_School = orgid.OrganizationId
			FROM Staging.ProgramParticipationCTE mcc
			JOIN ODS.OrganizationIdentifier orgid ON mcc.School_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = [App].[GetOrganizationIdentifierTypeId]('001073')
				AND orgid.RefOrganizationIdentificationSystemId = [App].[GetOrganizationIdentifierSystemId]('SEA', '001073')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationID_School', 'S10EC110'
		END CATCH


		-----------------------------------------------------------------------------
		---Associate the CTE Program OrganizationId with the staging table ----
		-----------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationID_CTEProgram = orgd.OrganizationId
			FROM Staging.ProgramParticipationCTE tp
			JOIN ODS.OrganizationRelationship orgr ON tp.OrganizationID_School = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd ON orgr.OrganizationId = orgd.OrganizationId
			JOIN ODS.OrganizationProgramType orgpt ON orgd.OrganizationId = orgpt.OrganizationId
			WHERE orgd.RefOrganizationTypeId = App.GetOrganizationTypeId('Program', '001156') 
				AND orgpt.RefProgramTypeId = App.GetProgramTypeId('04906')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationID_CTEProgram', 'S10EC120'
		END CATCH


		--Note: Need to change 09999 to the ID that represents CTE Programs when that is created ---

		--------------------------------------------------
		----Create CTE Indicator for the Student -----
		--------------------------------------------------

		BEGIN TRY
			--Check for CTE Records that already exist--
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationPersonRoleID_School = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationCTE tp
			JOIN ODS.OrganizationPersonRole opr ON tp.PersonID = opr.PersonId
			WHERE tp.OrganizationID_School = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student')
				AND opr.EntryDate >= [App].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.EntryDate <= [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationPersonRoleID_School', 'S10EC125'
		END CATCH

		BEGIN TRY
			--Check for CTE Records that already exist--
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationPersonRoleID_CTEProgram = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationCTE tp
			JOIN ODS.OrganizationPersonRole opr ON tp.PersonID = opr.PersonId
			WHERE tp.OrganizationID_CTEProgram = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student')
				AND opr.EntryDate = [App].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.ExitDate = [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationPersonRoleID_CTEProgram', 'S10EC130'
		END CATCH

		BEGIN TRY
			--Create an OrganizationPersonRole (Enrollment) into the CTE Program for the last day of the year --
			INSERT INTO [ODS].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				tp.OrganizationID_CTEProgram [OrganizationId]
			   ,tp.PersonID [PersonId]
			   ,App.GetRoleId('K12 Student') [RoleId]
			   ,[App].[GetFiscalYearStartDate](@SchoolYear) [EntryDate]
			   ,[App].[GetFiscalYearEndDate](@SchoolYear) [ExitDate] 
			FROM Staging.ProgramParticipationCTE tp
			WHERE tp.OrganizationPersonRoleID_CTEProgram IS NULL
				AND tp.OrganizationID_CTEProgram IS NOT NULL
				AND tp.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S10EC140'
		END CATCH

		BEGIN TRY
			--Update the staging table with the CTE Program OrganizationPersonRoleId
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationPersonRoleID_CTEProgram = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationCTE tp
			JOIN ODS.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
				AND tp.OrganizationID_CTEProgram = opr.OrganizationId
			WHERE opr.RoleId = App.GetRoleId('K12 Student')
				AND opr.EntryDate = [App].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.ExitDate = [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationPersonRoleID_CTEProgram', 'S10EC150'
		END CATCH


		BEGIN TRY
			--Check to see if a PersonProgramParticipation already exists for the CTE Program--
			UPDATE Staging.ProgramParticipationCTE
			SET PersonProgramParticipationId = ppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationCTE tp
			JOIN ODS.PersonProgramParticipation ppp 
				ON tp.OrganizationPersonRoleID_CTEProgram = ppp.OrganizationPersonRoleId
			JOIN ODS.ProgramParticipationCTE pp 
				ON ppp.PersonProgramParticipationId = pp.PersonProgramParticipationId
				--AND pp.RefTitleIIndicatorId = tp.RefTitleIIndicatorId
			WHERE ppp.RecordStartDateTime = [App].[GetFiscalYearStartDate](@SchoolYear)
				AND ppp.RecordEndDateTime = [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'PersonProgramParticipationId', 'S10EC160'
		END CATCH

		--Create a PersonProgramParticipation for each OrganizationPersonRole
		DECLARE @NewPersonProgramParticipationCTE TABLE (
			  PersonProgramParticipationId INT
			, SourceId INT
		);

		BEGIN TRY
			MERGE [ODS].[PersonProgramParticipation] AS TARGET
			USING Staging.ProgramParticipationCTE AS SOURCE
				ON SOURCE.PersonProgramParticipationId = TARGET.PersonProgramParticipationId
			WHEN NOT MATCHED AND SOURCE.OrganizationPersonRoleID_CTEProgram IS NOT NULL THEN 
				INSERT 
			   ([OrganizationPersonRoleId]
			   ,[RefParticipationTypeId]
			   ,[RefProgramExitReasonId]
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime])
			VALUES
			   (OrganizationPersonRoleID_CTEProgram 
			   ,NULL 
			   ,NULL 
			   ,[App].[GetFiscalYearStartDate](@SchoolYear) 
			   ,[App].[GetFiscalYearEndDate](@SchoolYear))
			OUTPUT
				  INSERTED.PersonProgramParticipationId 
				, SOURCE.ID
			INTO @NewPersonProgramParticipationCTE;
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S10EC170'
		END CATCH

		BEGIN TRY
			--Update the staging table with the new PersonProgramParticipationId
			UPDATE Staging.ProgramParticipationCTE 
			SET PersonProgramParticipationId = nppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationCTE ppi
			JOIN @NewPersonProgramParticipationCTE nppp
				ON ppi.ID = nppp.SourceId
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'PersonProgramParticipationId', 'S10EC180'
		END CATCH

		-- detect new program participation cte - OrganizationPersonRoleId
		DECLARE @NewOrganizationPersonRoleCTE TABLE (
			  OrganizationPersonRoleId INT
			--, SourceId INT
		);

		BEGIN TRY
			-- create new ods.ProgramParticipationCte records
			INSERT INTO ODS.ProgramParticipationCte 
			(
				PersonProgramParticipationId
				,CteParticipant
				,CteConcentrator
				,CteCompleter
				,SingleParentOrSinglePregnantWoman
				,DisplacedHomemakerIndicator
				,RefNonTraditionalGenderStatusId
				,CteNonTraditionalCompletion
			)
			SELECT 
				ppi.PersonProgramParticipationId
				,ppi.CteParticipant
				,ppi.CteConcentrator
				,ppi.CteCompleter 
				,ppi.SingleParentIndicator
				,ppi.DisplacedHomeMakerIndicator
				, CASE 
					WHEN ppi.NonTraditionalGenderStatus = 1 THEN (SELECT RefNonTraditionalGenderStatusId FROM [ODS].[RefNonTraditionalGenderStatus] WHERE Code = 'Underrepresented')
					WHEN ppi.NonTraditionalGenderStatus= 0 THEN (SELECT RefNonTraditionalGenderStatusId FROM [ODS].[RefNonTraditionalGenderStatus] WHERE Code = 'NotUnderrepresented')
				  END AS RefNonTraditionalGenderStatusId
				,CASE 
					WHEN ppi.NonTraditionalGenderStatus = 1 AND ppi.CteCompleter = 1 THEN 1 ELSE 0 
				END AS CteNonTraditionalCompletion
			FROM Staging.ProgramParticipationCTE ppi
			JOIN @NewPersonProgramParticipationCTE nppp
				ON ppi.ID = nppp.SourceId
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationCte', NULL, 'S10EC190'
		END CATCH

		BEGIN TRY
			INSERT INTO @NewOrganizationPersonRoleCTE 
			SELECT ppp.OrganizationPersonRoleId 
			FROM ODS.OrganizationPersonRole org
			JOIN ODS.PersonProgramParticipation ppp
				ON ppp.OrganizationPersonRoleId = org.OrganizationPersonRoleId
			JOIN @NewPersonProgramParticipationCTE nppp
				ON nppp.PersonProgramParticipationId=ppp.PersonProgramParticipationId
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganizationPersonRoleCTE', NULL, 'S10EC200'
		END CATCH

		BEGIN TRY
			-- populate ADVTRAIN for new records
			INSERT INTO ODS.PsStudentEnrollment (OrganizationPersonRoleId, EntryDateIntoPostSecondary)
			SELECT stp.OrganizationPersonRoleID_CTEProgram, stp.AdvancedTrainingEnrollmentDate
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram
			WHERE stp.AdvancedTrainingEnrollmentDate IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PsStudentEnrollment', NULL, 'S10EC210'
		END CATCH

		/*
			[App].[Migrate_Data_ETL_IMPLEMENTATION_STEP10_ProgramParticipationCTE_EncapsulatedCode] 2018
		*/


		-- populate EMPLOYMENT for new records
		DECLARE @RefEmployedAfterExitId INT
		SELECT @RefEmployedAfterExitId = (SELECT RefEmployedAfterExitId FROM ODS.RefEmployedAfterExit
			WHERE ODS.RefEmployedAfterExit.Code = 'Yes')		-- Code = 'Yes'

		BEGIN TRY
			INSERT INTO ODS.WorkforceEmploymentQuarterlyData (OrganizationPersonRoleId, RefEmployedAfterExitId)
			SELECT stp.OrganizationPersonRoleID_CTEProgram, @RefEmployedAfterExitId
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram
			WHERE stp.PlacementType = 'EMPLOYMENT'
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.WorkforceEmploymentQuarterlyData', NULL, 'S10EC220'
		END CATCH

		BEGIN TRY
			-- populate MILITARY for new records
			INSERT INTO ODS.WorkforceEmploymentQuarterlyData (OrganizationPersonRoleId, MilitaryEnlistmentAfterExit)
			SELECT stp.OrganizationPersonRoleID_CTEProgram, 1
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram
			WHERE stp.PlacementType = 'MILITARY'
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.WorkforceEmploymentQuarterlyData', NULL, 'S10EC230'
		END CATCH


		-- populate POSTSEC for new records
		DECLARE @RefWfProgramParticipationId INT
		SELECT @RefWfProgramParticipationId = (SELECT RefWfProgramParticipationId FROM ODS.RefWfProgramParticipation
			WHERE ODS.RefWfProgramParticipation.Code = '99')		-- Code = 'No identified services'

		BEGIN TRY
			INSERT INTO ODS.WorkforceProgramParticipation (PersonProgramParticipationId, RefWfProgramParticipationId)
				SELECT stp.PersonProgramParticipationId, @RefWfProgramParticipationId
				FROM Staging.ProgramParticipationCTE stp
				JOIN @NewOrganizationPersonRoleCTE nop 
					ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram
				WHERE stp.PlacementType = 'POSTSEC'
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.WorkforceProgramParticipation', NULL, 'S10EC240'
		END CATCH

		BEGIN TRY
			-- FS083 Diploma/Credential (Expanded)
			INSERT INTO ODS.K12StudentAcademicRecord (OrganizationPersonRoleId, DiplomaOrCredentialAwardDate,RefHighSchoolDiplomaTypeId) 
			SELECT 
				stp.OrganizationPersonRoleID_School
				,stp.DiplomaCredentialAwardDate
				,CASE
					WHEN stp.DiplomaCredentialType = 'Regular diploma' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [ODS].[RefHighSchoolDiplomaType] WHERE Code = '00806')
					WHEN stp.DiplomaCredentialType = 'Other diploma' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [ODS].[RefHighSchoolDiplomaType] WHERE Code = '00811')
					WHEN stp.DiplomaCredentialType = 'General Educational Development (GED) credential' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [ODS].[RefHighSchoolDiplomaType] WHERE Code = '00816')
				END
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram
			WHERE stp.DiplomaCredentialType IS NOT NULL
			AND stp.OrganizationPersonRoleID_School IS NOT NULL
			AND NOT EXISTS (SELECT 'x' FROM ODS.K12StudentAcademicRecord ksa WHERE stp.OrganizationPersonRoleID_School = ksa.OrganizationPersonRoleId)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentAcademicRecord', NULL, 'S10EC250'
		END CATCH

		BEGIN TRY
			-- HSDPROF option 
			INSERT INTO ODS.CteStudentAcademicRecord (OrganizationPersonRoleId, DiplomaOrCredentialAwardDate,RefProfessionalTechnicalCredentialTypeId) 
			SELECT 
				stp.OrganizationPersonRoleID_School
				,stp.DiplomaCredentialAwardDate
				,eesa.RefProfessionalTechnicalCredentialTypeId
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram
			LEFT JOIN ODS.SourceSystemReferenceData rdsa
				ON stp.DiplomaCredentialType_2 = rdsa.InputCode
				AND rdsa.TableName = 'RefProfessionalTechnicalCredentialType'
				AND rdsa.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefProfessionalTechnicalCredentialType eesa
				ON rdsa.OutputCode = eesa.Code
			WHERE stp.DiplomaCredentialType IS NOT NULL AND stp.DiplomaCredentialType_2 IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.CteStudentAcademicRecord', NULL, 'S10EC260'
		END CATCH

		---Add in validation and error checking in this location --

		set nocount off;

	END



