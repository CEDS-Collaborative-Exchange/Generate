CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_ProgramParticipationCTE]
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
		  EXEC Staging.[Migrate_StagingToIDS_ProgramParticipationCTE] 2018;
    
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
		DECLARE @eStoredProc			varchar(100) = 'Migrate_StagingToIDS_ProgramParticipationCTE'


		---------------------------------------------------
		--- Set the multiple use variables		       ----
		---------------------------------------------------
		DECLARE @RefEmployedAfterExitId INT
		SELECT @RefEmployedAfterExitId = (SELECT RefEmployedAfterExitId FROM dbo.RefEmployedAfterExit
			WHERE dbo.RefEmployedAfterExit.Code = 'Yes')

		DECLARE @RefWfProgramParticipationId INT
		SELECT @RefWfProgramParticipationId = (SELECT RefWfProgramParticipationId FROM dbo.RefWfProgramParticipation
			WHERE dbo.RefWfProgramParticipation.Code = '99')		-- Code = 'No identified services'



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
			JOIN dbo.PersonIdentifier pid 
				ON mcc.Student_Identifier_State = pid.Identifier
			WHERE pid.RefPersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001075')
				AND pid.RefPersonalInformationVerificationId = Staging.GetRefPersonalInformationVerificationId('01011')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'PersonID', 'S10EC100'
		END CATCH

		--------------------------------------------------------------------
		---Associate the IEU OrganizationId with the staging table ----
		--------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationID_IEU = orgid.OrganizationId
			FROM Staging.ProgramParticipationCTE mcc
			JOIN dbo.OrganizationIdentifier orgid 
				ON mcc.IEU_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('001156')
				AND orgid.RefOrganizationIdentificationSystemId = [Staging].[GetOrganizationIdentifierSystemId]('IEU', '001156')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationID_IEU', 'S10EC105'
		END CATCH

		--------------------------------------------------------------------
		---Associate the LEA OrganizationId with the staging table ----
		--------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationID_LEA = orgid.OrganizationId
			FROM Staging.ProgramParticipationCTE mcc
			JOIN dbo.OrganizationIdentifier orgid 
				ON mcc.LEA_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('001072')
				AND orgid.RefOrganizationIdentificationSystemId = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001072')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationID_LEA', 'S10EC110'
		END CATCH

		--------------------------------------------------------------------
		---Associate the School OrganizationId with the staging table ----
		--------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationID_School = orgid.OrganizationId
			FROM Staging.ProgramParticipationCTE mcc
			JOIN dbo.OrganizationIdentifier orgid 
				ON mcc.School_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('001073')
				AND orgid.RefOrganizationIdentificationSystemId = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001073')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationID_School', 'S10EC120'
		END CATCH


		-----------------------------------------------------------------------------
		---Associate the IEU CTE Program OrganizationId with the staging table ----
		-----------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationID_CTEProgram_IEU = orgd.OrganizationId
			FROM Staging.ProgramParticipationCTE tp
			JOIN dbo.OrganizationRelationship orgr 
				ON tp.OrganizationID_IEU = orgr.Parent_OrganizationId
			JOIN dbo.OrganizationDetail orgd 
				ON orgr.OrganizationId = orgd.OrganizationId
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgd.OrganizationId = orgpt.OrganizationId
			WHERE orgd.RefOrganizationTypeId = Staging.GetOrganizationTypeId('Program', '001156') 
				AND orgpt.RefProgramTypeId = Staging.GetProgramTypeId('04906')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationID_CTEProgram_IEU', 'S10EC125'
		END CATCH

		-----------------------------------------------------------------------------
		---Associate the LEA CTE Program OrganizationId with the staging table ----
		-----------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationID_CTEProgram_LEA = orgd.OrganizationId
			FROM Staging.ProgramParticipationCTE tp
			JOIN dbo.OrganizationRelationship orgr 
				ON tp.OrganizationID_LEA = orgr.Parent_OrganizationId
			JOIN dbo.OrganizationDetail orgd 
				ON orgr.OrganizationId = orgd.OrganizationId
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgd.OrganizationId = orgpt.OrganizationId
			WHERE orgd.RefOrganizationTypeId = Staging.GetOrganizationTypeId('Program', '001156') 
				AND orgpt.RefProgramTypeId = Staging.GetProgramTypeId('04906')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationID_CTEProgram_LEA', 'S10EC130'
		END CATCH

		-----------------------------------------------------------------------------
		---Associate the School CTE Program OrganizationId with the staging table ----
		-----------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationID_CTEProgram_School = orgd.OrganizationId
			FROM Staging.ProgramParticipationCTE tp
			JOIN dbo.OrganizationRelationship orgr 
				ON tp.OrganizationID_School = orgr.Parent_OrganizationId
			JOIN dbo.OrganizationDetail orgd 
				ON orgr.OrganizationId = orgd.OrganizationId
			JOIN dbo.OrganizationProgramType orgpt 
				ON orgd.OrganizationId = orgpt.OrganizationId
			WHERE orgd.RefOrganizationTypeId = Staging.GetOrganizationTypeId('Program', '001156') 
				AND orgpt.RefProgramTypeId = Staging.GetProgramTypeId('04906')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationID_CTEProgram_School', 'S10EC140'
		END CATCH

		--Note: Need to change 09999 to the ID that represents CTE Programs when that is created ---

		--------------------------------------------------
		----Create IEU CTE Indicator for the Student -----
		--------------------------------------------------

		--Check if there is an IEU defined and only run this block if necessary
		IF EXISTS (SELECT * FROM staging.K12Organization WHERE ISNULL(IEU_Identifier_State, '') <> '')
		BEGIN

			--Check for IEU CTE Records that already exist--
			BEGIN TRY
				UPDATE Staging.ProgramParticipationCTE
				SET OrganizationPersonRoleID_IEU = opr.OrganizationPersonRoleId
				FROM Staging.ProgramParticipationCTE tp
				JOIN dbo.OrganizationPersonRole opr 
					ON tp.PersonID = opr.PersonId
				WHERE tp.OrganizationID_IEU = opr.OrganizationId
					AND opr.RoleId = Staging.GetRoleId('K12 Student')
					AND opr.EntryDate >= [Staging].[GetFiscalYearStartDate](@SchoolYear)
					AND opr.EntryDate <= [Staging].[GetFiscalYearEndDate](@SchoolYear)
			END TRY

			BEGIN CATCH 
				EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationPersonRoleID_IEU', 'S10EC142'
			END CATCH

			--Check for CTE Records that already exist--
			BEGIN TRY
				UPDATE Staging.ProgramParticipationCTE
				SET OrganizationPersonRoleID_CTEProgram_IEU = opr.OrganizationPersonRoleId
				FROM Staging.ProgramParticipationCTE tp
				JOIN dbo.OrganizationPersonRole opr 
					ON tp.PersonID = opr.PersonId
				WHERE tp.OrganizationID_CTEProgram_IEU = opr.OrganizationId
					AND opr.RoleId = Staging.GetRoleId('K12 Student')
					AND opr.EntryDate = [Staging].[GetFiscalYearStartDate](@SchoolYear)
					AND opr.ExitDate = [Staging].[GetFiscalYearEndDate](@SchoolYear)
			END TRY

			BEGIN CATCH 
				EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationPersonRoleID_CTEProgram_IEU', 'S10EC144'
			END CATCH

			--Create an OrganizationPersonRole (Enrollment) into the CTE Program for the last day of the year --
			BEGIN TRY
				INSERT INTO [dbo].[OrganizationPersonRole]
				   ([OrganizationId]
				   ,[PersonId]
				   ,[RoleId]
				   ,[EntryDate]
				   ,[ExitDate])
				SELECT DISTINCT
					tp.OrganizationID_CTEProgram_IEU [OrganizationId]
				   ,tp.PersonID [PersonId]
				   ,Staging.GetRoleId('K12 Student') [RoleId]
				   ,[Staging].[GetFiscalYearStartDate](@SchoolYear) [EntryDate]
				   ,[Staging].[GetFiscalYearEndDate](@SchoolYear) [ExitDate] 
				FROM Staging.ProgramParticipationCTE tp
				WHERE tp.OrganizationPersonRoleID_CTEProgram_IEU IS NULL
					AND tp.OrganizationID_CTEProgram_IEU IS NOT NULL
					AND tp.PersonID IS NOT NULL
			END TRY

			BEGIN CATCH 
				EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S10EC146'
			END CATCH

			--Update the staging table with the CTE Program OrganizationPersonRoleId
			BEGIN TRY
				UPDATE Staging.ProgramParticipationCTE
				SET OrganizationPersonRoleID_CTEProgram_IEU = opr.OrganizationPersonRoleId
				FROM Staging.ProgramParticipationCTE tp
				JOIN dbo.OrganizationPersonRole opr 
					ON tp.PersonID = opr.PersonId
					AND tp.OrganizationID_CTEProgram_IEU = opr.OrganizationId
				WHERE opr.RoleId = Staging.GetRoleId('K12 Student')
					AND opr.EntryDate = [Staging].[GetFiscalYearStartDate](@SchoolYear)
					AND opr.ExitDate = [Staging].[GetFiscalYearEndDate](@SchoolYear)
			END TRY

			BEGIN CATCH 
				EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationPersonRoleID_CTEProgram_IEU', 'S10EC148'
			END CATCH

		END -- finish of the check if IEUs exist in the K12Organization table

		--------------------------------------------------
		----Create LEA CTE Indicator for the Student -----
		--------------------------------------------------

		--Check for LEA CTE Records that already exist--
		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationPersonRoleID_LEA = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationCTE tp
			JOIN dbo.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
			WHERE tp.OrganizationID_LEA = opr.OrganizationId
				AND opr.RoleId = Staging.GetRoleId('K12 Student')
				AND opr.EntryDate >= [Staging].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.EntryDate <= [Staging].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationPersonRoleID_LEA', 'S10EC150'
		END CATCH

		--Check for CTE Records that already exist--
		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationPersonRoleID_CTEProgram_LEA = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationCTE tp
			JOIN dbo.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
			WHERE tp.OrganizationID_CTEProgram_LEA = opr.OrganizationId
				AND opr.RoleId = Staging.GetRoleId('K12 Student')
				AND opr.EntryDate = [Staging].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.ExitDate = [Staging].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationPersonRoleID_CTEProgram_LEA', 'S10EC160'
		END CATCH

		--Create an OrganizationPersonRole (Enrollment) into the CTE Program for the last day of the year --
		BEGIN TRY
			INSERT INTO [dbo].[OrganizationPersonRole]
			   ([OrganizationId]
			   ,[PersonId]
			   ,[RoleId]
			   ,[EntryDate]
			   ,[ExitDate])
			SELECT DISTINCT
				tp.OrganizationID_CTEProgram_LEA [OrganizationId]
			   ,tp.PersonID [PersonId]
			   ,Staging.GetRoleId('K12 Student') [RoleId]
			   ,[Staging].[GetFiscalYearStartDate](@SchoolYear) [EntryDate]
			   ,[Staging].[GetFiscalYearEndDate](@SchoolYear) [ExitDate] 
			FROM Staging.ProgramParticipationCTE tp
			WHERE tp.OrganizationPersonRoleID_CTEProgram_LEA IS NULL
				AND tp.OrganizationID_CTEProgram_LEA IS NOT NULL
				AND tp.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S10EC170'
		END CATCH

		--Update the staging table with the CTE Program OrganizationPersonRoleId
		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationPersonRoleID_CTEProgram_LEA = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationCTE tp
			JOIN dbo.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
				AND tp.OrganizationID_CTEProgram_LEA = opr.OrganizationId
			WHERE opr.RoleId = Staging.GetRoleId('K12 Student')
				AND opr.EntryDate = [Staging].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.ExitDate = [Staging].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationPersonRoleID_CTEProgram_LEA', 'S10EC180'
		END CATCH

		--------------------------------------------------
		----Create School CTE Indicator for the Student -----
		--------------------------------------------------

		--Check for LEA CTE Records that already exist--
		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationPersonRoleID_School = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationCTE tp
			JOIN dbo.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
			WHERE tp.OrganizationID_School = opr.OrganizationId
				AND opr.RoleId = Staging.GetRoleId('K12 Student')
				AND opr.EntryDate >= [Staging].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.EntryDate <= [Staging].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationPersonRoleID_School', 'S10EC190'
		END CATCH

		--Check for CTE Records that already exist--
		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationPersonRoleID_CTEProgram_School = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationCTE tp
			JOIN dbo.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
			WHERE tp.OrganizationID_CTEProgram_School = opr.OrganizationId
				AND opr.RoleId = Staging.GetRoleId('K12 Student')
				AND opr.EntryDate = [Staging].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.ExitDate = [Staging].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationPersonRoleID_CTEProgram_School', 'S10EC200'
		END CATCH

		--Create an OrganizationPersonRole (Enrollment) into the CTE Program for the last day of the year --
		BEGIN TRY
			INSERT INTO [dbo].[OrganizationPersonRole] (
				[OrganizationId]
				,[PersonId]
				,[RoleId]
				,[EntryDate]
				,[ExitDate]
			)
			SELECT DISTINCT
				tp.OrganizationID_CTEProgram_School [OrganizationId]
				,tp.PersonID [PersonId]
				,Staging.GetRoleId('K12 Student') [RoleId]
				,[Staging].[GetFiscalYearStartDate](@SchoolYear) [EntryDate]
				,[Staging].[GetFiscalYearEndDate](@SchoolYear) [ExitDate] 
			FROM Staging.ProgramParticipationCTE tp
			WHERE tp.OrganizationPersonRoleID_CTEProgram_School IS NULL
				AND tp.OrganizationID_CTEProgram_School IS NOT NULL
				AND tp.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S10EC210'
		END CATCH

		--Update the staging table with the CTE Program OrganizationPersonRoleId
		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET OrganizationPersonRoleID_CTEProgram_School = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationCTE tp
			JOIN dbo.OrganizationPersonRole opr 
				ON tp.PersonID = opr.PersonId
				AND tp.OrganizationID_CTEProgram_School = opr.OrganizationId
			WHERE opr.RoleId = Staging.GetRoleId('K12 Student')
				AND opr.EntryDate = [Staging].[GetFiscalYearStartDate](@SchoolYear)
				AND opr.ExitDate = [Staging].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'OrganizationPersonRoleID_CTEProgram_School', 'S10EC220'
		END CATCH

		--------------------------------------------------------------
		----Create LEA Person Program Participation for the Student -----
		--------------------------------------------------------------

		--Check to see if a PersonProgramParticipation already exists for the CTE Program--
		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET PersonProgramParticipationId_LEA = ppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationCTE tp
			JOIN dbo.PersonProgramParticipation ppp 
				ON tp.OrganizationPersonRoleID_CTEProgram_LEA = ppp.OrganizationPersonRoleId
			JOIN dbo.ProgramParticipationCTE pp 
				ON ppp.PersonProgramParticipationId = pp.PersonProgramParticipationId
				--AND pp.RefTitleIIndicatorId = tp.RefTitleIIndicatorId
			WHERE ppp.RecordStartDateTime = [Staging].[GetFiscalYearStartDate](@SchoolYear)
				AND ppp.RecordEndDateTime = [Staging].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'PersonProgramParticipationId_LEA', 'S10EC230'
		END CATCH

		--Create a PersonProgramParticipation for each OrganizationPersonRole
		DECLARE @NewLEAPersonProgramParticipationCTE TABLE (
			  PersonProgramParticipationId INT
			, SourceId INT
		);

		BEGIN TRY
			MERGE [dbo].[PersonProgramParticipation] AS TARGET
			USING Staging.ProgramParticipationCTE AS SOURCE
				ON SOURCE.PersonProgramParticipationId_LEA = TARGET.PersonProgramParticipationId
			WHEN NOT MATCHED AND SOURCE.OrganizationPersonRoleID_CTEProgram_LEA IS NOT NULL THEN 
				INSERT 
			   ([OrganizationPersonRoleId]
			   ,[RefParticipationTypeId]
			   ,[RefProgramExitReasonId]
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime])
			VALUES
			   (OrganizationPersonRoleID_CTEProgram_LEA
			   ,NULL 
			   ,NULL 
			   ,[Staging].[GetFiscalYearStartDate](@SchoolYear) 
			   ,[Staging].[GetFiscalYearEndDate](@SchoolYear))
			OUTPUT
				  INSERTED.PersonProgramParticipationId 
				, SOURCE.ID
			INTO @NewLEAPersonProgramParticipationCTE;
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S10EC240'
		END CATCH

		BEGIN TRY
			--Update the staging table with the new PersonProgramParticipationId
			UPDATE Staging.ProgramParticipationCTE 
			SET PersonProgramParticipationId_LEA = nppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationCTE ppi
			JOIN @NewLEAPersonProgramParticipationCTE nppp
				ON ppi.ID = nppp.SourceId
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'PersonProgramParticipationId_LEA', 'S10EC250'
		END CATCH

		--------------------------------------------------------------
		----Create School Person Program Participation for the Student -----
		--------------------------------------------------------------

		--Check to see if a PersonProgramParticipation already exists for the CTE Program--
		BEGIN TRY
			UPDATE Staging.ProgramParticipationCTE
			SET PersonProgramParticipationId_School = ppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationCTE tp
			JOIN dbo.PersonProgramParticipation ppp 
				ON tp.OrganizationPersonRoleID_CTEProgram_School = ppp.OrganizationPersonRoleId
			JOIN dbo.ProgramParticipationCTE pp 
				ON ppp.PersonProgramParticipationId = pp.PersonProgramParticipationId
				--AND pp.RefTitleIIndicatorId = tp.RefTitleIIndicatorId
			WHERE ppp.RecordStartDateTime = [Staging].[GetFiscalYearStartDate](@SchoolYear)
				AND ppp.RecordEndDateTime = [Staging].[GetFiscalYearEndDate](@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'PersonProgramParticipationId_School', 'S10EC260'
		END CATCH

		--Create a PersonProgramParticipation for each OrganizationPersonRole
		DECLARE @NewSchoolPersonProgramParticipationCTE TABLE (
			  PersonProgramParticipationId INT
			, SourceId INT
		);

		BEGIN TRY
			MERGE [dbo].[PersonProgramParticipation] AS TARGET
			USING Staging.ProgramParticipationCTE AS SOURCE
				ON SOURCE.PersonProgramParticipationId_School = TARGET.PersonProgramParticipationId
			WHEN NOT MATCHED AND SOURCE.OrganizationPersonRoleID_CTEProgram_School IS NOT NULL THEN 
				INSERT 
			   ([OrganizationPersonRoleId]
			   ,[RefParticipationTypeId]
			   ,[RefProgramExitReasonId]
			   ,[RecordStartDateTime]
			   ,[RecordEndDateTime])
			VALUES
			   (OrganizationPersonRoleID_CTEProgram_School
			   ,NULL 
			   ,NULL 
			   ,[Staging].[GetFiscalYearStartDate](@SchoolYear) 
			   ,[Staging].[GetFiscalYearEndDate](@SchoolYear))
			OUTPUT
				  INSERTED.PersonProgramParticipationId 
				, SOURCE.ID
			INTO @NewSchoolPersonProgramParticipationCTE;
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonProgramParticipation', NULL, 'S10EC270'
		END CATCH

		BEGIN TRY
			--Update the staging table with the new PersonProgramParticipationId
			UPDATE Staging.ProgramParticipationCTE 
			SET PersonProgramParticipationId_School = nppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationCTE ppi
			JOIN @NewSchoolPersonProgramParticipationCTE nppp
				ON ppi.ID = nppp.SourceId
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationCTE', 'PersonProgramParticipationId_School', 'S10EC280'
		END CATCH

		--------------------------------------------------------------
		----Create LEA CTE Program Participation for the Student -----
		--------------------------------------------------------------

		-- detect new program participation cte - OrganizationPersonRoleId
		DECLARE @NewLEAOrganizationPersonRoleCTE TABLE (
			  OrganizationPersonRoleId INT
			--, SourceId INT
		);

		BEGIN TRY
			-- create new dbo.ProgramParticipationCte records
			INSERT INTO dbo.ProgramParticipationCte  (
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
				ppi.PersonProgramParticipationId_LEA
				,ppi.CteParticipant
				,ppi.CteConcentrator
				,ppi.CteCompleter 
				,ppi.SingleParentIndicator
				,ppi.DisplacedHomeMakerIndicator
				, CASE 
					WHEN ppi.NonTraditionalGenderStatus = 1 THEN (SELECT RefNonTraditionalGenderStatusId FROM [dbo].[RefNonTraditionalGenderStatus] WHERE Code = 'Underrepresented')
					WHEN ppi.NonTraditionalGenderStatus= 0 THEN (SELECT RefNonTraditionalGenderStatusId FROM [dbo].[RefNonTraditionalGenderStatus] WHERE Code = 'NotUnderrepresented')
				  END AS RefNonTraditionalGenderStatusId
				,CASE 
					WHEN ppi.NonTraditionalGenderStatus = 1 AND ppi.CteCompleter = 1 THEN 1 ELSE 0 
				END AS CteNonTraditionalCompletion
			FROM Staging.ProgramParticipationCTE ppi
			JOIN @NewLEAPersonProgramParticipationCTE nppp
				ON ppi.ID = nppp.SourceId
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationCte', NULL, 'S10EC290'
		END CATCH

		BEGIN TRY
			INSERT INTO @NewLEAOrganizationPersonRoleCTE 
			SELECT ppp.OrganizationPersonRoleId 
			FROM dbo.OrganizationPersonRole org
			JOIN dbo.PersonProgramParticipation ppp
				ON ppp.OrganizationPersonRoleId = org.OrganizationPersonRoleId
			JOIN @NewLEAPersonProgramParticipationCTE nppp
				ON nppp.PersonProgramParticipationId = ppp.PersonProgramParticipationId
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '@NewLEAOrganizationPersonRoleCTE', NULL, 'S10EC300'
		END CATCH

		--------------------------------------------------------------
		----Create School CTE Program Participation for the Student -----
		--------------------------------------------------------------

		-- detect new program participation cte - OrganizationPersonRoleId
		DECLARE @NewSchoolOrganizationPersonRoleCTE TABLE (
			  OrganizationPersonRoleId INT
			--, SourceId INT
		);

		BEGIN TRY
			-- create new dbo.ProgramParticipationCte records
			INSERT INTO dbo.ProgramParticipationCte  (
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
				ppi.PersonProgramParticipationId_School
				,ppi.CteParticipant
				,ppi.CteConcentrator
				,ppi.CteCompleter 
				,ppi.SingleParentIndicator
				,ppi.DisplacedHomeMakerIndicator
				, CASE 
					WHEN ppi.NonTraditionalGenderStatus = 1 THEN (SELECT RefNonTraditionalGenderStatusId FROM [dbo].[RefNonTraditionalGenderStatus] WHERE Code = 'Underrepresented')
					WHEN ppi.NonTraditionalGenderStatus= 0 THEN (SELECT RefNonTraditionalGenderStatusId FROM [dbo].[RefNonTraditionalGenderStatus] WHERE Code = 'NotUnderrepresented')
				  END AS RefNonTraditionalGenderStatusId
				,CASE 
					WHEN ppi.NonTraditionalGenderStatus = 1 AND ppi.CteCompleter = 1 THEN 1 ELSE 0 
				END AS CteNonTraditionalCompletion
			FROM Staging.ProgramParticipationCTE ppi
			JOIN @NewSchoolPersonProgramParticipationCTE nppp
				ON ppi.ID = nppp.SourceId
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.ProgramParticipationCte', NULL, 'S10EC310'
		END CATCH

		BEGIN TRY
			INSERT INTO @NewSchoolOrganizationPersonRoleCTE 
			SELECT ppp.OrganizationPersonRoleId 
			FROM dbo.OrganizationPersonRole org
			JOIN dbo.PersonProgramParticipation ppp
				ON ppp.OrganizationPersonRoleId = org.OrganizationPersonRoleId
			JOIN @NewLEAPersonProgramParticipationCTE nppp
				ON nppp.PersonProgramParticipationId = ppp.PersonProgramParticipationId
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '@NewSchoolOrganizationPersonRoleCTE', NULL, 'S10EC320'
		END CATCH

		--------------------------------------------------------------
		----Populate LEA CTE data for new records
		--------------------------------------------------------------

		-- populate ADVTRAIN for new records
		BEGIN TRY
			INSERT INTO dbo.PsStudentEnrollment (
				OrganizationPersonRoleId
				, EntryDateIntoPostSecondary
			)
			SELECT stp.OrganizationPersonRoleID_CTEProgram_LEA
				, stp.AdvancedTrainingEnrollmentDate
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewLEAOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram_LEA
			WHERE stp.AdvancedTrainingEnrollmentDate IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PsStudentEnrollment', NULL, 'S10EC330'
		END CATCH

		-- populate EMPLOYMENT for new records
		BEGIN TRY
			INSERT INTO dbo.WorkforceEmploymentQuarterlyData (
				OrganizationPersonRoleId
				, RefEmployedAfterExitId
			)
			SELECT stp.OrganizationPersonRoleID_CTEProgram_LEA
				, @RefEmployedAfterExitId
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewLEAOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram_LEA
			WHERE stp.PlacementType = 'EMPLOYMENT'
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.WorkforceEmploymentQuarterlyData', NULL, 'S10EC340'
		END CATCH

		-- populate MILITARY for new records
		BEGIN TRY
			INSERT INTO dbo.WorkforceEmploymentQuarterlyData (
				OrganizationPersonRoleId
				, MilitaryEnlistmentAfterExit
			)
			SELECT stp.OrganizationPersonRoleID_CTEProgram_LEA
				, 1
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewLEAOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram_LEA
			WHERE stp.PlacementType = 'MILITARY'
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.WorkforceEmploymentQuarterlyData', NULL, 'S10EC350'
		END CATCH

		-- populate POSTSEC for new records
		BEGIN TRY
			INSERT INTO dbo.WorkforceProgramParticipation (
				PersonProgramParticipationId
				, RefWfProgramParticipationId
			)
			SELECT stp.PersonProgramParticipationId_LEA
				, @RefWfProgramParticipationId
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewLEAOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram_LEA
			WHERE stp.PlacementType = 'POSTSEC'
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.WorkforceProgramParticipation', NULL, 'S10EC360'
		END CATCH

/*		-- FS083 Diploma/Credential (Expanded)
		BEGIN TRY
			INSERT INTO dbo.K12StudentAcademicRecord (
				OrganizationPersonRoleId
				, DiplomaOrCredentialAwardDate
				, RefHighSchoolDiplomaTypeId
			) 
			SELECT 
				stp.OrganizationPersonRoleID_LEA
				,stp.DiplomaCredentialAwardDate
				,CASE
					WHEN stp.DiplomaCredentialType = 'Regular diploma' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00806')
					WHEN stp.DiplomaCredentialType = 'Other diploma' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00811')
					WHEN stp.DiplomaCredentialType = 'General Educational Development (GED) credential' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00816')
				END
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewLEAOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram_LEA
			WHERE stp.DiplomaCredentialType IS NOT NULL
			AND stp.OrganizationPersonRoleID_LEA IS NOT NULL
			AND NOT EXISTS (SELECT 'x' FROM dbo.K12StudentAcademicRecord ksa WHERE stp.OrganizationPersonRoleID_LEA = ksa.OrganizationPersonRoleId)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentAcademicRecord', NULL, 'S10EC370'
		END CATCH

		-- HSDPROF option 
		BEGIN TRY
			INSERT INTO dbo.CteStudentAcademicRecord (
				OrganizationPersonRoleId
				, DiplomaOrCredentialAwardDate
				, RefProfessionalTechnicalCredentialTypeId
			)
			SELECT 
				stp.OrganizationPersonRoleID_LEA
				,stp.DiplomaCredentialAwardDate
				,eesa.RefProfessionalTechnicalCredentialTypeId
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewLEAOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram_LEA
			LEFT JOIN Staging.SourceSystemReferenceData rdsa
				ON stp.DiplomaCredentialType_2 = rdsa.InputCode
				AND rdsa.TableName = 'RefProfessionalTechnicalCredentialType'
				AND rdsa.SchoolYear = @SchoolYear
			LEFT JOIN dbo.RefProfessionalTechnicalCredentialType eesa
				ON rdsa.OutputCode = eesa.Code
			WHERE stp.DiplomaCredentialType IS NOT NULL AND stp.DiplomaCredentialType_2 IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.CteStudentAcademicRecord', NULL, 'S10EC380'
		END CATCH
*/
		--------------------------------------------------------------
		----Populate School CTE data for new records
		--------------------------------------------------------------

		-- populate ADVTRAIN for new records
		BEGIN TRY
			INSERT INTO dbo.PsStudentEnrollment (
				OrganizationPersonRoleId
				, EntryDateIntoPostSecondary
			)
			SELECT stp.OrganizationPersonRoleID_CTEProgram_School
				, stp.AdvancedTrainingEnrollmentDate
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewSchoolOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram_School
			WHERE stp.AdvancedTrainingEnrollmentDate IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PsStudentEnrollment', NULL, 'S10EC390'
		END CATCH

		-- populate EMPLOYMENT for new records
		BEGIN TRY
			INSERT INTO dbo.WorkforceEmploymentQuarterlyData (
				OrganizationPersonRoleId
				, RefEmployedAfterExitId
			)
			SELECT stp.OrganizationPersonRoleID_CTEProgram_School
				, @RefEmployedAfterExitId
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewSchoolOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram_School
			WHERE stp.PlacementType = 'EMPLOYMENT'
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.WorkforceEmploymentQuarterlyData', NULL, 'S10EC400'
		END CATCH

		-- populate MILITARY for new records
		BEGIN TRY
			INSERT INTO dbo.WorkforceEmploymentQuarterlyData (
				OrganizationPersonRoleId
				, MilitaryEnlistmentAfterExit
			)
			SELECT stp.OrganizationPersonRoleID_CTEProgram_School
				, 1
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewSchoolOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram_School
			WHERE stp.PlacementType = 'MILITARY'
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.WorkforceEmploymentQuarterlyData', NULL, 'S10EC410'
		END CATCH

		-- populate POSTSEC for new records
		BEGIN TRY
			INSERT INTO dbo.WorkforceProgramParticipation (
				PersonProgramParticipationId
				, RefWfProgramParticipationId
			)
			SELECT stp.PersonProgramParticipationId_School
				, @RefWfProgramParticipationId
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewSchoolOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram_School
			WHERE stp.PlacementType = 'POSTSEC'
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.WorkforceProgramParticipation', NULL, 'S10EC420'
		END CATCH
/*
		-- FS083 Diploma/Credential (Expanded)
		BEGIN TRY
			INSERT INTO dbo.K12StudentAcademicRecord (
				OrganizationPersonRoleId
				, DiplomaOrCredentialAwardDate
				, RefHighSchoolDiplomaTypeId
			) 
			SELECT 
				stp.OrganizationPersonRoleID_School
				,stp.DiplomaCredentialAwardDate
				,CASE
					WHEN stp.DiplomaCredentialType = 'Regular diploma' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00806')
					WHEN stp.DiplomaCredentialType = 'Other diploma' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00811')
					WHEN stp.DiplomaCredentialType = 'General Educational Development (GED) credential' THEN (SELECT RefHighSchoolDiplomaTypeId FROM [dbo].[RefHighSchoolDiplomaType] WHERE Code = '00816')
				END
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewSchoolOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram_School
			WHERE stp.DiplomaCredentialType IS NOT NULL
			AND stp.OrganizationPersonRoleID_School IS NOT NULL
			AND NOT EXISTS (SELECT 'x' FROM dbo.K12StudentAcademicRecord ksa WHERE stp.OrganizationPersonRoleID_School = ksa.OrganizationPersonRoleId)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentAcademicRecord', NULL, 'S10EC430'
		END CATCH

		-- HSDPROF option 
		BEGIN TRY
			INSERT INTO dbo.CteStudentAcademicRecord (
				OrganizationPersonRoleId
				, DiplomaOrCredentialAwardDate
				, RefProfessionalTechnicalCredentialTypeId
			)
			SELECT 
				stp.OrganizationPersonRoleID_School
				,stp.DiplomaCredentialAwardDate
				,eesa.RefProfessionalTechnicalCredentialTypeId
			FROM Staging.ProgramParticipationCTE stp
			JOIN @NewSchoolOrganizationPersonRoleCTE nop 
				ON nop.OrganizationPersonRoleId = stp.OrganizationPersonRoleID_CTEProgram_School
			LEFT JOIN Staging.SourceSystemReferenceData rdsa
				ON stp.DiplomaCredentialType_2 = rdsa.InputCode
				AND rdsa.TableName = 'RefProfessionalTechnicalCredentialType'
				AND rdsa.SchoolYear = @SchoolYear
			LEFT JOIN dbo.RefProfessionalTechnicalCredentialType eesa
				ON rdsa.OutputCode = eesa.Code
			WHERE stp.DiplomaCredentialType IS NOT NULL AND stp.DiplomaCredentialType_2 IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.CteStudentAcademicRecord', NULL, 'S10EC440'
		END CATCH
*/
	set nocount off;

	END
