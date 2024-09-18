CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP11_ProgramParticipationNorD_EncapsulatedCode]
	@SchoolYear SMALLINT = NULL
	AS

		/*************************************************************************************************************
		Date Created:  5/28/2019

		Purpose:
			The purpose of this ETL is to load NoD indicators about students for EDFacts reports that apply to the full year.

		Assumptions:
        
		Account executed under: LOGIN

		Approximate run time:  ~ 5 seconds

		Data Sources: 

		Data Targets:  Generate Database:   Generate

		Return Values:
    		 0	= Success
  
		Example Usage: 
		  EXEC App.[Migrate_Data_ETL_IMPLEMENTATION_STEP11_ProgramParticipationNorD_EncapsulatedCode] 2018;
    
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
		DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP11_ProgramParticipationNorD_EncapsulatedCode'

		--------------------------------------------------------------
		--- Optimize indexes on Staging.ProgramParticipationNorD --- 
		--------------------------------------------------------------
		ALTER INDEX ALL ON Staging.ProgramParticipationNorD
		REBUILD WITH (FILLFACTOR = 100, SORT_IN_TEMPDB = ON, STATISTICS_NORECOMPUTE = ON);

		-------------------------------------------------------
		---Associate the PersonId with the staging table ----
		-------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationNorD
			SET PersonID = pid.PersonId
			FROM Staging.ProgramParticipationNorD mcc
			JOIN ODS.PersonIdentifier pid ON mcc.Student_Identifier_State = pid.Identifier
			WHERE pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075')
				AND pid.RefPersonalInformationVerificationId = App.GetRefPersonalInformationVerificationId('01011')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'PersonID', 'S11EC100'
		END CATCH

		--------------------------------------------------------------------
		---Associate the School OrganizationId with the staging table ----
		--------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationNorD
			SET OrganizationID_School = orgid.OrganizationId
			FROM Staging.ProgramParticipationNorD mcc
			JOIN ODS.OrganizationIdentifier orgid ON mcc.School_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = [App].[GetOrganizationIdentifierTypeId]('001073')
				AND orgid.RefOrganizationIdentificationSystemId = [App].[GetOrganizationIdentifierSystemId]('SEA', '001073')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'OrganizationID_School', 'S11EC110'
		END CATCH

		-----------------------------------------------------------------------------
		---Associate the NoD Program OrganizationId with the staging table ----
		-----------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationNorD
			SET LEAOrganizationID_Program  = orgd.OrganizationId
			FROM Staging.ProgramParticipationNorD tp
			JOIN ODS.OrganizationRelationship orgr ON tp.OrganizationID_School = orgr.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd ON orgr.OrganizationId = orgd.OrganizationId
			JOIN ODS.OrganizationProgramType orgpt ON orgd.OrganizationId = orgpt.OrganizationId
			WHERE orgd.RefOrganizationTypeId = App.GetOrganizationTypeId('Program', '001156') 
				AND orgpt.RefProgramTypeId = App.GetProgramTypeId('09999') -- TODO. Use 'Other', '09999' for now
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'LEAOrganizationID_Program', 'S11EC120'
		END CATCH


		--Note: Need to change 09999 to the ID that represents NoD Programs when that is created ---

		--------------------------------------------------
		----Create NoD Indicator for the Student -----
		--------------------------------------------------

		BEGIN TRY
			--Check for NoD Records that already exist--
			UPDATE Staging.ProgramParticipationNorD
			SET LEAOrganizationPersonRoleId_Program = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationNorD tp
			JOIN ODS.OrganizationPersonRole opr ON tp.PersonID = opr.PersonId
			WHERE tp.LEAOrganizationID_Program  = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student')
				AND opr.EntryDate = [App].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.ExitDate = [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'LEAOrganizationPersonRoleId_Program', 'S11EC130'
		END CATCH

		BEGIN TRY
			--Create an OrganizationPersonRole (Enrollment) into the NoD Program for the last day of the year --
			INSERT INTO [ODS].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				tp.LEAOrganizationID_Program [OrganizationId]
			   ,tp.PersonID [PersonId]
			   ,App.GetRoleId('K12 Student') [RoleId]
			   ,[App].[GetFiscalYearStartDate](@SchoolYear) [EntryDate]
			   ,[App].[GetFiscalYearEndDate](@SchoolYear) [ExitDate] 
			FROM Staging.ProgramParticipationNorD tp
			WHERE tp.LEAOrganizationPersonRoleId_Program IS NULL
				AND tp.LEAOrganizationID_Program IS NOT NULL
				AND tp.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S11EC140'
		END CATCH

		BEGIN TRY
			--Update the staging table with the NoD Program OrganizationPersonRoleId
			UPDATE Staging.ProgramParticipationNorD
			SET LEAOrganizationPersonRoleId_Program = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationNorD tp
			JOIN ODS.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
				AND tp.LEAOrganizationID_Program = opr.OrganizationId
			WHERE opr.RoleId = App.GetRoleId('K12 Student')
				AND opr.EntryDate = [App].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.ExitDate = [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'OrganizationPersonRoleID_NoDProgram', 'S11EC150'
		END CATCH


		BEGIN TRY
			--Check to see if a PersonProgramParticipation already exists for the NoD Program--
			UPDATE Staging.ProgramParticipationNorD
			SET PersonProgramParticipationId = ppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationNorD tp
			JOIN ODS.PersonProgramParticipation ppp 
				ON tp.LEAOrganizationPersonRoleId_Program = ppp.OrganizationPersonRoleId
			JOIN ODS.ProgramParticipationNeglected pp 
				ON ppp.PersonProgramParticipationId = pp.PersonProgramParticipationId
				--AND pp.RefTitleIIndicatorId = tp.RefTitleIIndicatorId
			WHERE ppp.RecordStartDateTime = [App].[GetFiscalYearStartDate](@SchoolYear)
				AND ppp.RecordEndDateTime = [App].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'PersonProgramParticipationId', 'S11EC160'
		END CATCH

		--Create a PersonProgramParticipation for each OrganizationPersonRole
		DECLARE @NewPersonProgramParticipationNorD TABLE (
			  PersonProgramParticipationId INT
			, SourceId INT
		);

		BEGIN TRY
			DECLARE @RefParticipationTypeId INT
			SELECT @RefParticipationTypeId = RefParticipationTypeId FROM [ODS].[RefParticipationType] WHERE [Code] = 'CorrectionalEducationReentryServicesParticipation'

			MERGE [ODS].[PersonProgramParticipation] AS TARGET
			USING Staging.ProgramParticipationNorD AS SOURCE
				ON SOURCE.PersonProgramParticipationId = TARGET.PersonProgramParticipationId
			WHEN NOT MATCHED AND SOURCE.LEAOrganizationPersonRoleId_Program IS NOT NULL THEN 
				INSERT 
			   ([OrganizationPersonRoleId]
			   ,[RefParticipationTypeId]
			   ,[RefProgramExitReasonId]
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime])
			VALUES
			   (
					LEAOrganizationPersonRoleId_Program 
					,@RefParticipationTypeId 
					,NULL 
					,ProgramParticipationBeginDate
					,ProgramParticipationEndDate
				)
			OUTPUT
				  INSERTED.PersonProgramParticipationId 
				, SOURCE.ID
			INTO @NewPersonProgramParticipationNorD;
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S11EC170'
		END CATCH

		BEGIN TRY
			--Update the staging table with the new PersonProgramParticipationId
			UPDATE Staging.ProgramParticipationNorD 
			SET PersonProgramParticipationId = nppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationNorD ppi
			JOIN @NewPersonProgramParticipationNorD nppp
				ON ppi.ID = nppp.SourceId
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationNorD', 'PersonProgramParticipationId', 'S11EC180'
		END CATCH

		-- detect new program participation NoD - OrganizationPersonRoleId
		DECLARE @NewOrganizationPersonRoleNoD TABLE (
			  OrganizationPersonRoleId INT
			--, SourceId INT
		);

		BEGIN TRY
			-- create new ods.ProgramParticipationNorD records

		INSERT INTO [ODS].[ProgramParticipationNeglected]
			(
			 [PersonProgramParticipationId]
			,[RefNeglectedProgramTypeId]
			--,[AchievementIndicator]
			--,[OutcomeIndicator]
			--,[ObtainedEmployment]
			,[RefAcademicCareerAndTechnicalOutcomesInProgramId]
			,[RefAcademicCareerAndTechnicalOutcomesExitedProgramId]
			,[RecordStartDateTime]
			,[RecordEndDateTime]
			)
			SELECT 
				ppn.PersonProgramParticipationId
				,neg.[RefNeglectedProgramTypeId]
				,outcome.RefAcademicCareerAndTechnicalOutcomesInProgramId
				,CASE
					WHEN ProgramParticipationEndDate IS NOT NULL THEN outcomeexit.RefAcademicCareerAndTechnicalOutcomesInProgramId
					ELSE NULL
				END
				,ProgramParticipationBeginDate
				,ProgramParticipationEndDate
			FROM Staging.ProgramParticipationNorD ppn
		--	JOIN @NewPersonProgramParticipationNorD nppp
		--		ON ppn.ID = nppp.SourceId
			LEFT JOIN [ODS].[SourceSystemReferenceData] src ON src.InputCode = ppn.ProgramParticipationNorD AND TableName = 'RefNeglectedProgramType' -- TODO Add entries
			LEFT JOIN [ODS].[RefNeglectedProgramType] neg ON neg.Code = src.OutputCode
			LEFT JOIN [ODS].[ProgramParticipationNeglected] ppn2
				ON ppn2.PersonProgramParticipationID = ppn.PersonProgramParticipationID
				--AND ppn2.RefNeglectedProgramTypeId = neg.RefNeglectedProgramTypeId
				AND ppn2.RecordStartDateTime = ProgramParticipationBeginDate
			LEFT JOIN [ODS].RefAcademicCareerAndTechnicalOutcomesInProgram outcome
				ON outcome.Code = ppn.Outcome
			LEFT JOIN [ODS].RefAcademicCareerAndTechnicalOutcomesInProgram outcomeexit
				ON outcomeexit.Code = ppn.Outcome
			WHERE ppn2.[ProgramParticipationNeglectedId] IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationNeglected', NULL, 'S11EC190'
		END CATCH

		BEGIN TRY
			INSERT INTO @NewOrganizationPersonRoleNoD 
			SELECT ppp.OrganizationPersonRoleId 
			FROM ODS.OrganizationPersonRole org
			JOIN ODS.PersonProgramParticipation ppp
				ON ppp.OrganizationPersonRoleId = org.OrganizationPersonRoleId
			JOIN @NewPersonProgramParticipationNorD nppp
				ON nppp.PersonProgramParticipationId=ppp.PersonProgramParticipationId

		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '@NewOrganizationPersonRoleNoD', NULL, 'S11EC200'
		END CATCH


		BEGIN TRY
			-- Update the existing school student K12StudentAcademicRecord
			-- The reason is that the generate migrate procedures use the OrganizationPersonRoleId and not using the OrganizationPersonRoleId with program organization Id.
			Update ar
			SET DiplomaOrCredentialAwardDate = stp.DiplomaCredentialAwardDate
				,RefHighSchoolDiplomaTypeId = 
				CASE
					WHEN stp.Outcome = 'EARNDIPL' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [ODS].[RefHighSchoolDiplomaType] WHERE Code = '00806')
					WHEN stp.Outcome = 'EARNEGED' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [ODS].[RefHighSchoolDiplomaType] WHERE Code = '00816')
				END 
				, RefPsEnrollmentActionId = act.RefPsEnrollmentActionId
			FROM Staging.ProgramParticipationNorD stp
			JOIN ODS.OrganizationPersonRole op 
				ON stp.PersonID = op.PersonId AND stp.OrganizationID_School = op.OrganizationId
			JOIN ODS.K12StudentAcademicRecord ar ON  ar.OrganizationPersonRoleId = op.OrganizationPersonRoleId
		--	JOIN @NewOrganizationPersonRoleNoD nop ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleID_Program
			LEFT JOIN ODS.K12StudentAcademicRecord  k12 ON k12.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleID_Program
			LEFT JOIN [ODS].[RefHighSchoolDiplomaType] t ON t.Code = stp.Outcome
			LEFT JOIN ODS.RefPsEnrollmentAction act ON act.Code = stp.Outcome
			WHERE stp.Outcome IN ('EARNDIPL', 'EARNEGED') 

			-- FS083 Diploma/Credential (Expanded)
			INSERT INTO ODS.K12StudentAcademicRecord 
			(
				OrganizationPersonRoleId
				,DiplomaOrCredentialAwardDate
				,RefHighSchoolDiplomaTypeId
				,RefPsEnrollmentActionId
			) 
			SELECT 
				stp.LEAOrganizationPersonRoleID_Program
				,stp.DiplomaCredentialAwardDate
				,CASE
					WHEN stp.Outcome = 'EARNDIPL' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [ODS].[RefHighSchoolDiplomaType] WHERE Code = '00806')
					WHEN stp.Outcome = 'EARNEGED' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [ODS].[RefHighSchoolDiplomaType] WHERE Code = '00816')
				END
				, act.RefPsEnrollmentActionId
			FROM Staging.ProgramParticipationNorD stp
			JOIN @NewOrganizationPersonRoleNoD nop ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleID_Program
			LEFT JOIN ODS.K12StudentAcademicRecord  k12 ON k12.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleID_Program
			LEFT JOIN [ODS].[RefHighSchoolDiplomaType] t ON t.Code = stp.Outcome
			LEFT JOIN ODS.RefPsEnrollmentAction act ON act.Code = stp.Outcome
			WHERE stp.Outcome IN ('EARNDIPL', 'EARNEGED') AND k12.RefHighSchoolDiplomaTypeId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentAcademicRecord', NULL, 'S11EC210'
		END CATCH

		--BEGIN TRY
		--	-- populate ADVTRAIN for new records
		--	--INSERT INTO ODS.PsStudentEnrollment (OrganizationPersonRoleId, EntryDateIntoPostSecondary)
		--	--SELECT stp.OrganizationPersonRoleID_CTEProgram, stp.AdvancedTrainingEnrollmentDate
		--	--FROM Staging.ProgramParticipationNorD stp
		--	--JOIN @NewOrganizationPersonRoleNoD nop 
		--	--	ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleId_Program
		--	--WHERE stp.AdvancedTrainingEnrollmentDate IS NOT NULL
		--END TRY

		--BEGIN CATCH 
		--	EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PsStudentEnrollment', NULL, 'S11EC210'
		--END CATCH

		/*
			[App].[Migrate_Data_ETL_IMPLEMENTATION_STEP11_ProgramParticipationNorD_EncapsulatedCode] 2018
		*/


		-- populate EMPLOYMENT for new records
		DECLARE @RefEmployedAfterExitId INT
		SELECT @RefEmployedAfterExitId = (SELECT RefEmployedAfterExitId FROM ODS.RefEmployedAfterExit
			WHERE ODS.RefEmployedAfterExit.Code = 'Yes')		-- Code = 'Yes'

		BEGIN TRY
			INSERT INTO ODS.WorkforceEmploymentQuarterlyData (OrganizationPersonRoleId, RefEmployedAfterExitId)
			SELECT stp.LEAOrganizationPersonRoleId_Program, @RefEmployedAfterExitId
			FROM Staging.ProgramParticipationNorD stp
			JOIN @NewOrganizationPersonRoleNoD nop 
				ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleId_Program
			LEFT JOIN ODS.WorkforceEmploymentQuarterlyData wf 
				ON wf.OrganizationPersonRoleId = LEAOrganizationPersonRoleId_Program AND wf.RefEmployedAfterExitId = @RefEmployedAfterExitId
			WHERE stp.Outcome = 'OBTAINEMP' AND wf.OrganizationPersonRoleId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.WorkforceEmploymentQuarterlyData', NULL, 'S11EC220'
		END CATCH


		-- populate POSTSEC for new records
		DECLARE @RefWfProgramParticipationId INT
		SELECT @RefWfProgramParticipationId = (SELECT RefWfProgramParticipationId FROM ODS.RefWfProgramParticipation
			WHERE ODS.RefWfProgramParticipation.Code = '06')		-- Code = 'Adult Education and Literacy'

		BEGIN TRY
			INSERT INTO ODS.WorkforceProgramParticipation (PersonProgramParticipationId, RefWfProgramParticipationId)
				SELECT stp.PersonProgramParticipationId, @RefWfProgramParticipationId
				FROM Staging.ProgramParticipationNorD stp
				JOIN @NewOrganizationPersonRoleNoD nop 
					ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleId_Program
				LEFT JOIN ODS.WorkforceProgramParticipation wfpp 
					ON wfpp.PersonProgramParticipationId = stp.PersonProgramParticipationId 
					AND wfpp.RefWfProgramParticipationId = @RefWfProgramParticipationId
				WHERE stp.Outcome = 'POSTSEC'
					AND wfpp.PersonProgramParticipationId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.WorkforceProgramParticipation', NULL, 'S11EC230'
		END CATCH

		-- Populate Progresslevel-Math
		DECLARE @RefAcademicSubject_MathId INT
		SELECT @RefAcademicSubject_MathId = 
			(SELECT RefAcademicSubjectId FROM ODS.RefAcademicSubject WHERE Code = '01166')		-- Code = 'Mathematics'

		BEGIN TRY
			INSERT INTO [ODS].[ProgramParticipationNeglectedProgressLevel]
			   (
				[PersonProgramParticipationId]
			   ,[RefAcademicSubjectId]
			   ,[RefProgressLevelId]
			   )
			SELECT stp.PersonProgramParticipationId, @RefAcademicSubject_MathId, refpl.RefProgressLevelId
			FROM Staging.ProgramParticipationNorD stp
			JOIN @NewOrganizationPersonRoleNoD nop ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleId_Program
			JOIN [ODS].[SourceSystemReferenceData] rd ON rd.InputCode = stp.ProgressLevel_Math AND rd.TableName = 'RefProgressLevel'
			JOIN [ODS].[RefProgressLevel] refpl ON refpl.Code = rd.OutputCode
			LEFT JOIN ODS.ProgramParticipationNeglectedProgressLevel pl 
				ON pl.PersonProgramParticipationId = stp.PersonProgramParticipationId 
				AND pl.RefAcademicSubjectId = @RefAcademicSubject_MathId
			WHERE pl.ProgramParticipationNeglectedProgressLevelId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationNeglectedProgressLevel', NULL, 'S11EC240'
		END CATCH

		-- Populate Progresslevel-ELA
		DECLARE @RefAcademicSubject_ELAId INT
		SELECT @RefAcademicSubject_ELAId = 
			(SELECT RefAcademicSubjectId FROM ODS.RefAcademicSubject WHERE Code = '13372')		-- Code = 'English'


		BEGIN TRY
			INSERT INTO [ODS].[ProgramParticipationNeglectedProgressLevel]
			   (
				[PersonProgramParticipationId]
			   ,[RefAcademicSubjectId]
			   ,[RefProgressLevelId]
			   )
			SELECT stp.PersonProgramParticipationId, ref.RefAcademicSubjectId, refpl.RefProgressLevelId
			FROM Staging.ProgramParticipationNorD stp
			JOIN @NewOrganizationPersonRoleNoD nop ON nop.OrganizationPersonRoleId = stp.LEAOrganizationPersonRoleId_Program
			JOIN [ODS].[SourceSystemReferenceData] rd ON rd.InputCode = stp.ProgressLevel_Reading AND rd.TableName = 'RefProgressLevel'
			JOIN [ODS].[RefProgressLevel] refpl ON refpl.Code = rd.OutputCode
			JOIN [Staging].[AssessmentResult] ar ON ar.Student_Identifier_State = stp.Student_Identifier_State
			LEFT JOIN ods.RefAcademicSubject ref on ref.Description = RTRIM(LTRIM(ar.AssessmentAcademicSubject))
			LEFT JOIN ODS.ProgramParticipationNeglectedProgressLevel pl 
				ON pl.PersonProgramParticipationId = stp.PersonProgramParticipationId 
				AND pl.RefAcademicSubjectId = @RefAcademicSubject_ELAId
			WHERE pl.ProgramParticipationNeglectedProgressLevelId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationNeglectedProgressLevel', NULL, 'S11EC250'
		END CATCH

		set nocount off;

	END



