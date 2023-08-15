/*
	[App].[Migrate_Data_ETL_IMPLEMENTATION_STEP07_ProgramParticipationSpecialEducation_EncapsulatedCode] 2018
*/

CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP07_ProgramParticipationSpecialEducation_EncapsulatedCode]
	@SchoolYear SMALLINT = NULL
	AS
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
		DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP07_ProgramParticipationSpecialEducation_EncapsulatedCode'


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
			JOIN ODS.PersonIdentifier pid 
				ON ppse.Student_Identifier_State = pid.Identifier
			WHERE pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075') 
			AND pid.RefPersonalInformationVerificationId = App.GetRefPersonalInformationVerificationId('01011') 
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'PersonId', 'S07EC100' 
		END CATCH
		--------------------------------------------------------------------
		---Associate the LEA OrganizationId with the temporary table ----
		--------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.ProgramParticipationSpecialEducation
			SET OrganizationID_LEA = orgid.OrganizationId
			FROM Staging.ProgramParticipationSpecialEducation ppse
			JOIN ODS.OrganizationIdentifier orgid 
				ON ppse.LEA_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = App.GetOrganizationIdentifierTypeId('001072')
			AND orgid.RefOrganizationIdentificationSystemId = App.GetOrganizationIdentifierSystemId('SEA', '001072') 
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'OrganizationID_LEA', 'S07EC110' 
		END CATCH

			
		-------------------------------------------------------
		---Associate the PersonId with the temporary table ----
		-------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.ProgramParticipationSpecialEducation
			SET PersonID = pid.PersonId
			FROM Staging.ProgramParticipationSpecialEducation ppse
			JOIN ODS.PersonIdentifier pid 
				ON ppse.Student_Identifier_State = pid.Identifier
			JOIN ODS.OrganizationPersonRole opr
				ON pid.PersonId = opr.PersonId
				AND opr.OrganizationId = ISNULL(ppse.OrganizationID_School, ppse.OrganizationID_LEA)
			WHERE pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075') 
			AND pid.RefPersonalInformationVerificationId = App.GetRefPersonalInformationVerificationId('01011') 
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'PersonId', 'S07EC100' 
		END CATCH

		--------------------------------------------------------------------
		---Associate the School OrganizationId with the temporary table ----
		--------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.ProgramParticipationSpecialEducation
			SET OrganizationID_School = orgid.OrganizationId
			FROM Staging.ProgramParticipationSpecialEducation ppse
			JOIN ODS.OrganizationIdentifier orgid 
				ON ppse.School_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = App.GetOrganizationIdentifierTypeId('001073')
			AND orgid.RefOrganizationIdentificationSystemId = App.GetOrganizationIdentifierSystemId('SEA', '001073') 
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'OrganizationID_School', 'S07EC120' 
		END CATCH

		-------------------------------------------------------------------------------------------
		---Associate the LEA Special Education Program OrganizationId with the temporary table ----
		-------------------------------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.ProgramParticipationSpecialEducation
			SET LEAOrganizationID_Program = orgd.OrganizationId
			FROM Staging.ProgramParticipationSpecialEducation ppse
			JOIN ODS.OrganizationRelationship ord 
				ON ppse.OrganizationID_LEA = ord.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd 
				ON ord.OrganizationId = orgd.OrganizationId
			JOIN ODS.OrganizationProgramType orgpt 
				ON orgd.OrganizationId = orgpt.OrganizationId 
			WHERE orgd.RefOrganizationTypeId = App.GetOrganizationTypeId('Program', '001156') 
				AND orgpt.RefProgramTypeId = App.GetProgramTypeId('04888')
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'LEAOrganizationID_Program', 'S07EC130' 
		END CATCH

		----------------------------------------------------------------------------------------------
		---Associate the School Special Education Program OrganizationId with the temporary table ----
		----------------------------------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.ProgramParticipationSpecialEducation
			SET SchoolOrganizationID_Program = orgd.OrganizationId
			FROM Staging.ProgramParticipationSpecialEducation ppse
			JOIN ODS.OrganizationRelationship ord 
				ON ppse.OrganizationID_School = ord.Parent_OrganizationId
			JOIN ODS.OrganizationDetail orgd 
				ON ord.OrganizationId = orgd.OrganizationId
			JOIN ODS.OrganizationProgramType orgpt 
				ON orgd.OrganizationId = orgpt.OrganizationId 
			WHERE orgd.RefOrganizationTypeId = App.GetOrganizationTypeId('Program', '001156') 
				AND orgpt.RefProgramTypeId = App.GetProgramTypeId('04888')
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'SchoolOrganizationID_Program', 'S07EC140'
		END CATCH

		----------------------------------------------------------------------------------------------
		---Manage the Special Education Program OrganizationPersonRole Records for each Student ------
		----------------------------------------------------------------------------------------------
		--LEA
		BEGIN TRY
			INSERT INTO [ODS].[OrganizationPersonRole]
					   ([OrganizationId]
					   ,[PersonId]
					   ,[RoleId]
					   ,[EntryDate]
					   ,[ExitDate])
			SELECT DISTINCT
						ppse.LEAOrganizationID_Program	[OrganizationId]
					   ,ppse.PersonID					[PersonId]
					   ,App.GetRoleId('K12 Student')	[RoleId]
					   ,ProgramParticipationBeginDate	[EntryDate]
					   ,ProgramParticipationEndDate		[ExitDate]
			FROM Staging.ProgramParticipationSpecialEducation ppse
			LEFT JOIN ODS.OrganizationPersonRole opr 
				ON ppse.PersonID = opr.PersonId
				AND ppse.ProgramParticipationBeginDate = opr.EntryDate
				AND ISNULL(ppse.ProgramParticipationEndDate, '1900-01-01') = ISNULL(opr.ExitDate, '1900-01-01')
				AND ppse.LEAOrganizationID_Program = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student')
			WHERE opr.PersonId IS NULL
				AND ppse.LEAOrganizationID_Program IS NOT NULL
				AND ppse.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S07EC150'
		END CATCH

		--School
		BEGIN TRY
			INSERT INTO [ODS].[OrganizationPersonRole]
					   ([OrganizationId]
					   ,[PersonId]
					   ,[RoleId]
					   ,[EntryDate]
					   ,[ExitDate])
			SELECT DISTINCT
						ppse.SchoolOrganizationID_Program [OrganizationId]
					   ,ppse.PersonID [PersonId]
					   ,App.GetRoleId('K12 Student')  [RoleId]
					   ,ProgramParticipationBeginDate [EntryDate]
					   ,ProgramParticipationEndDate [ExitDate]
			FROM Staging.ProgramParticipationSpecialEducation ppse
			LEFT JOIN ODS.OrganizationPersonRole opr 
				ON ppse.PersonID = opr.PersonId
				AND ppse.ProgramParticipationBeginDate = opr.EntryDate
				AND ISNULL(ppse.ProgramParticipationEndDate, '1900-01-01') = ISNULL(opr.ExitDate, '1900-01-01')
				AND ppse.SchoolOrganizationID_Program = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student')
			WHERE opr.PersonId IS NULL
				AND ppse.SchoolOrganizationID_Program IS NOT NULL
				AND ppse.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S07EC160'
		END CATCH

		--LEA
		BEGIN TRY
			UPDATE Staging.ProgramParticipationSpecialEducation
			SET LEAOrganizationPersonRoleId_Program = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationSpecialEducation ppse
			JOIN ODS.OrganizationPersonRole opr 
				ON ppse.PersonID = opr.PersonId 
			WHERE ppse.LEAOrganizationID_Program = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student') 
				AND EntryDate = ppse.ProgramParticipationBeginDate
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'LEAOrganizationPersonRoleId_Program', 'S07EC170'
		END CATCH
		
		--School
		BEGIN TRY
			UPDATE Staging.ProgramParticipationSpecialEducation
			SET SchoolOrganizationPersonRoleId_Program = opr.OrganizationPersonRoleId
			FROM Staging.ProgramParticipationSpecialEducation ppse
			JOIN ODS.OrganizationPersonRole opr 
				ON ppse.PersonID = opr.PersonId 
			WHERE ppse.SchoolOrganizationID_Program = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student') 
				AND EntryDate = ppse.ProgramParticipationBeginDate
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'SchoolOrganizationPersonRoleId_Program', 'S07EC180'
		END CATCH

		-------------------------------------------------------------------------------
		---Delete any OrganizationPersonRole Records not found in the temp table ------
		-------------------------------------------------------------------------------

		CREATE TABLE #RecordsToDelete_OrganizationPersonRole
			(OrganizationPersonRoleId INT)

		BEGIN TRY
			--LEA
			INSERT INTO #RecordsToDelete_OrganizationPersonRole
				(OrganizationPersonRoleId)
			SELECT DISTINCT OrganizationPersonRoleId 
			FROM ODS.OrganizationPersonRole opr
			JOIN ODS.OrganizationDetail orgd 
				ON opr.OrganizationId = orgd.OrganizationId
			LEFT JOIN Staging.ProgramParticipationSpecialEducation e 
				ON opr.OrganizationPersonRoleId = e.LEAOrganizationPersonRoleId_Program
			WHERE e.PersonId IS NULL
				AND opr.RoleId = App.GetRoleId('K12 Student') 
			AND orgd.RefOrganizationTypeId = App.GetOrganizationTypeId('Program', '001156') 
			AND opr.EntryDate IS NOT NULL
			AND opr.EntryDate >= App.GetFiscalYearStartDate(@SchoolYear) 
			AND orgd.Name = 'Special Education Program'
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '#RecordsToDelete_OrganizationPersonRole', 'OrganizationPersonRoleId', 'S07EC190'
		END CATCH

		BEGIN TRY
			--School
			INSERT INTO #RecordsToDelete_OrganizationPersonRole
				(OrganizationPersonRoleId)
			SELECT DISTINCT OrganizationPersonRoleId 
			FROM ODS.OrganizationPersonRole opr
			JOIN ODS.OrganizationDetail orgd 
				ON opr.OrganizationId = orgd.OrganizationId
			LEFT JOIN Staging.ProgramParticipationSpecialEducation e 
				ON opr.OrganizationPersonRoleId = e.SchoolOrganizationPersonRoleId_Program
			WHERE e.PersonId IS NULL
			AND opr.RoleId = App.GetRoleId('K12 Student') 
			AND orgd.RefOrganizationTypeId = App.GetOrganizationTypeId('Program', '001156') 
			AND opr.EntryDate IS NOT NULL
			AND opr.EntryDate >= App.GetFiscalYearStartDate(@SchoolYear) 
			AND orgd.Name = 'Special Education Program'
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '#RecordsToDelete_OrganizationPersonRole', 'OrganizationPersonRoleId', 'S07EC200'
		END CATCH

		BEGIN TRY
			CREATE TABLE #RecordsToDelete_PersonProgramParticipation
				(PersonProgramParticipationId INT)
			INSERT INTO #RecordsToDelete_PersonProgramParticipation
				(PersonProgramParticipationId)
			SELECT DISTINCT PersonProgramParticipationId
			FROM ODS.PersonProgramParticipation ppp
			JOIN #RecordsToDelete_OrganizationPersonRole rtdopr 
				ON ppp.OrganizationPersonRoleId = rtdopr.OrganizationPersonRoleId
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '#RecordsToDelete_PersonProgramParticipation', 'PersonProgramParticipationId', 'S07EC210'
		END CATCH

		---------------------------------------------------------------------------
		--Remove any records that are not in the Current ODS for this School Year--
		---------------------------------------------------------------------------

		BEGIN TRY
			DELETE ppp 
			FROM ODS.ProgramParticipationCte ppp 
			JOIN #RecordsToDelete_PersonProgramParticipation rtdppp 
				ON ppp.PersonProgramParticipationId = rtdppp.PersonProgramParticipationId
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationCte', NULL, 'S07EC220'
		END CATCH

		BEGIN TRY
			DELETE ppp 
			FROM ODS.ProgramParticipationMigrant ppp 
			JOIN #RecordsToDelete_PersonProgramParticipation rtdppp 
				ON ppp.PersonProgramParticipationId = rtdppp.PersonProgramParticipationId
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationMigrant', NULL, 'S07EC230'
		END CATCH

		BEGIN TRY
			DELETE ppp 
			FROM ODS.ProgramParticipationTitleIIILEp ppp 
			JOIN #RecordsToDelete_PersonProgramParticipation rtdppp 
				ON ppp.PersonProgramParticipationId = rtdppp.PersonProgramParticipationId
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationTitleIIILEp', NULL, 'S07EC240'
		END CATCH

		BEGIN TRY
			DELETE ppp 
			FROM ODS.ProgramParticipationSpecialEducation ppp 
			JOIN #RecordsToDelete_PersonProgramParticipation rtdppp
				ON ppp.PersonProgramParticipationId = rtdppp.PersonProgramParticipationId
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationSpecialEducation', NULL, 'S07EC250'
		END CATCH

		BEGIN TRY
			DELETE opr 
			FROM ODS.PersonProgramParticipation opr 
			JOIN #RecordsToDelete_OrganizationPersonRole rtdopr 
				ON opr.OrganizationPersonRoleId = rtdopr.OrganizationPersonRoleId
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S07EC260'
		END CATCH

		---------------------------------------------------------------------------
		--Create PersonProgramParticipation and ProgramParticipationSpecialEd -----
		---------------------------------------------------------------------------


		BEGIN TRY
			--LEA
			INSERT INTO [ODS].[PersonProgramParticipation]
					   ([OrganizationPersonRoleId]
					   ,[RefParticipationTypeId]
					   ,[RefProgramExitReasonId]
					   ,[RecordStartDateTime]
					   ,[RecordEndDateTime])
			SELECT
						ppse.LEAOrganizationPersonRoleId_Program [OrganizationPersonRoleId]
					   ,NULL [RefParticipationTypeId]
					   ,NULL [RefProgramExitReasonId]
					   ,ProgramParticipationBeginDate [RecordStartDateTime]
					   ,ProgramParticipationEndDate [RecordEndDateTime]
			FROM Staging.ProgramParticipationSpecialEducation ppse
			WHERE ppse.LEAOrganizationPersonRoleId_Program IS NOT NULL
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S07EC270'
		END CATCH


		BEGIN TRY
			--School
			INSERT INTO [ODS].[PersonProgramParticipation]
					   ([OrganizationPersonRoleId]
					   ,[RefParticipationTypeId]
					   ,[RefProgramExitReasonId]
					   ,[RecordStartDateTime]
					   ,[RecordEndDateTime])
			SELECT
						ppse.SchoolOrganizationPersonRoleId_Program [OrganizationPersonRoleId]
					   ,NULL [RefParticipationTypeId]
					   ,NULL [RefProgramExitReasonId]
					   ,ProgramParticipationBeginDate [RecordStartDateTime]
					   ,ProgramParticipationEndDate [RecordEndDateTime]
			FROM Staging.ProgramParticipationSpecialEducation ppse
			WHERE ppse.SchoolOrganizationPersonRoleId_Program IS NOT NULL
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonProgramParticipation', NULL, 'S07EC280'
		END CATCH

		BEGIN TRY
			--LEA
			UPDATE Staging.ProgramParticipationSpecialEducation
			SET PersonProgramParticipationID_LEA = ppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationSpecialEducation ppse
			JOIN ODS.PersonProgramParticipation ppp 
				ON ppse.LEAOrganizationPersonRoleId_Program = ppp.OrganizationPersonRoleId
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'PersonProgramParticipationID_LEA', 'S07EC290'
		END CATCH

		BEGIN TRY
			--School
			UPDATE Staging.ProgramParticipationSpecialEducation
			SET PersonProgramParticipationID_School = ppp.PersonProgramParticipationId
			FROM Staging.ProgramParticipationSpecialEducation ppse
			JOIN ODS.PersonProgramParticipation ppp 
				ON ppse.SchoolOrganizationPersonRoleId_Program = ppp.OrganizationPersonRoleId
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.ProgramParticipationSpecialEducation', 'PersonProgramParticipationID_School', 'S07EC300'
		END CATCH

		-- LEA PPSE record
		BEGIN TRY
			INSERT INTO [ODS].[ProgramParticipationSpecialEducation]
					   ([PersonProgramParticipationId]
					   ,[AwaitingInitialIDEAEvaluationStatus]
					   ,[RefIDEAEducationalEnvironmentECId]
					   ,[RefIDEAEdEnvironmentSchoolAgeId]
					   ,[SpecialEducationFTE]
					   ,[RefSpecialEducationExitReasonId]
					   ,[SpecialEducationServicesExitDate]
					   ,[RecordStartDateTime]
					   ,[RecordEndDateTime])
			SELECT 
						ppse.PersonProgramParticipationID_LEA [PersonProgramParticipationId]
					   ,NULL [AwaitingInitialIDEAEvaluationStatus]
					   ,eeec.[RefIDEAEducationalEnvironmentECId] [RefIDEAEducationalEnvironmentECId]
					   ,eesa.[RefIDESEducationalEnvironmentSchoolAge] [RefIDEAEdEnvironmentSchoolAgeId]
					   ,NULL [SpecialEducationFTE]
					   ,seer.RefSpecialEducationExitReasonId [RefSpecialEducationExitReasonId]
					   ,ProgramParticipationEndDate [SpecialEducationServicesExitDate]
					   ,ProgramParticipationBeginDate [RecordStartDateTime]
					   ,ProgramParticipationEndDate [RecordEndDateTime]
			FROM Staging.ProgramParticipationSpecialEducation ppse
			LEFT JOIN ODS.SourceSystemReferenceData rdec
				ON ppse.IDEAEducationalEnvironmentForEarlyChildhood = rdec.InputCode
				AND rdec.TableName = 'RefIDEAEducationalEnvironmentEC'
				AND rdec.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefIDEAEducationalEnvironmentEC eeec
				ON rdec.OutputCode = eeec.Code
			LEFT JOIN ODS.SourceSystemReferenceData rdsa
				ON ppse.IDEAEducationalEnvironmentForSchoolAge = rdsa.InputCode
				AND rdsa.TableName = 'RefIDEAEducationalEnvironmentSchoolAge'
				AND rdsa.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefIDEAEducationalEnvironmentSchoolAge eesa
				ON rdsa.OutputCode = eesa.Code
			LEFT JOIN ODS.SourceSystemReferenceData ersa
				ON ppse.SpecialEducationExitReason = ersa.InputCode
				AND ersa.TableName = 'RefSpecialEducationExitReason'
				AND ersa.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefSpecialEducationExitReason seer
				ON ersa.OutputCode = seer.Code
			WHERE PersonProgramParticipationID_LEA IS NOT NULL
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationSpecialEducation', NULL, 'S07EC310'
		END CATCH

		
		BEGIN TRY
			INSERT INTO [ODS].[ProgramParticipationSpecialEducation]
					   ([PersonProgramParticipationId]
					   ,[AwaitingInitialIDEAEvaluationStatus]
					   ,[RefIDEAEducationalEnvironmentECId]
					   ,[RefIDEAEdEnvironmentSchoolAgeId]
					   ,[SpecialEducationFTE]
					   ,[RefSpecialEducationExitReasonId]
					   ,[SpecialEducationServicesExitDate]
					   ,[RecordStartDateTime]
					   ,[RecordEndDateTime])
			SELECT 
						ppse.PersonProgramParticipationID_School [PersonProgramParticipationId]
					   ,NULL [AwaitingInitialIDEAEvaluationStatus]
					   ,eeec.[RefIDEAEducationalEnvironmentECId] [RefIDEAEducationalEnvironmentECId]
					   ,eesa.[RefIDESEducationalEnvironmentSchoolAge] [RefIDEAEdEnvironmentSchoolAgeId]
					   ,NULL [SpecialEducationFTE]
					   ,seer.RefSpecialEducationExitReasonId [RefSpecialEducationExitReasonId]
					   ,ProgramParticipationEndDate [SpecialEducationServicesExitDate]
					   ,ProgramParticipationBeginDate [RecordStartDateTime]
					   ,ProgramParticipationEndDate [RecordEndDateTime]
			FROM Staging.ProgramParticipationSpecialEducation ppse
			LEFT JOIN ODS.SourceSystemReferenceData rdec
				ON ppse.IDEAEducationalEnvironmentForEarlyChildhood = rdec.InputCode
				AND rdec.TableName = 'RefIDEAEducationalEnvironmentEC'
				AND rdec.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefIDEAEducationalEnvironmentEC eeec
				ON rdec.OutputCode = eeec.Code
			LEFT JOIN ODS.SourceSystemReferenceData rdsa
				ON ppse.IDEAEducationalEnvironmentForSchoolAge = rdsa.InputCode
				AND rdsa.TableName = 'RefIDEAEducationalEnvironmentSchoolAge'
				AND rdsa.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefIDEAEducationalEnvironmentSchoolAge eesa
				ON rdsa.OutputCode = eesa.Code
			LEFT JOIN ODS.SourceSystemReferenceData ersa
				ON ppse.SpecialEducationExitReason = ersa.InputCode
				AND ersa.TableName = 'RefSpecialEducationExitReason'
				AND ersa.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefSpecialEducationExitReason seer
				ON ersa.OutputCode = seer.Code
			WHERE PersonProgramParticipationID_School IS NOT NULL
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.ProgramParticipationSpecialEducation', NULL, 'S07EC320'
		END CATCH

		----Error table logging will be inserted here.  Not only errors with the ETL itself, but with the data. The temporary tables will be checked
		----for erroneous or missing data and that information will be logged in a table that will eventually be displayed through the Generate UI

		DROP TABLE #RecordsToDelete_OrganizationPersonRole
		DROP TABLE #RecordsToDelete_PersonProgramParticipation

		set nocount off;


END

